export type AiRiskLevel = 'low' | 'medium' | 'high' | 'critical';
export type HumanReviewStatus = 'not_required' | 'pending' | 'approved' | 'rejected';

export interface AiSafetyInput {
  purpose: string;
  containsSensitivePersonalData: boolean;
  affectsAccessToMoneyOrEssentialServices: boolean;
  affectsModerationOrVerification: boolean;
  userMayBeInImmediateDanger: boolean;
  confidence?: number;
}

export interface AiSafetyDecision {
  riskLevel: AiRiskLevel;
  humanReviewRequired: boolean;
  mayAutoPublish: boolean;
  uncertaintyNoteRequired: boolean;
  reasons: string[];
}

export function evaluateAiSafety(input: AiSafetyInput): AiSafetyDecision {
  const reasons: string[] = [];

  if (input.userMayBeInImmediateDanger) {
    reasons.push('Possible immediate danger requires human-led safety handling.');
    return {
      riskLevel: 'critical',
      humanReviewRequired: true,
      mayAutoPublish: false,
      uncertaintyNoteRequired: true,
      reasons,
    };
  }

  if (input.affectsModerationOrVerification) {
    reasons.push('AI must not make final moderation or verification decisions.');
  }

  if (input.affectsAccessToMoneyOrEssentialServices) {
    reasons.push('The output may materially affect access to support or essential services.');
  }

  if (input.containsSensitivePersonalData) {
    reasons.push('The request contains sensitive personal information.');
  }

  const highRisk =
    input.affectsModerationOrVerification ||
    input.affectsAccessToMoneyOrEssentialServices;

  if (highRisk) {
    return {
      riskLevel: 'high',
      humanReviewRequired: true,
      mayAutoPublish: false,
      uncertaintyNoteRequired: true,
      reasons,
    };
  }

  if (input.containsSensitivePersonalData || (input.confidence ?? 1) < 0.65) {
    if ((input.confidence ?? 1) < 0.65) reasons.push('Model confidence is below the publishing threshold.');
    return {
      riskLevel: 'medium',
      humanReviewRequired: input.containsSensitivePersonalData,
      mayAutoPublish: !input.containsSensitivePersonalData,
      uncertaintyNoteRequired: true,
      reasons,
    };
  }

  return {
    riskLevel: 'low',
    humanReviewRequired: false,
    mayAutoPublish: true,
    uncertaintyNoteRequired: false,
    reasons: ['The request is assistive and does not make a consequential decision.'],
  };
}

export const AI_HUMAN_REVIEW_BOUNDARIES = [
  'AI may summarize, translate, categorize, and suggest next steps.',
  'AI may not approve verification requests.',
  'AI may not issue or uphold moderation sanctions.',
  'AI may not rank a person as deserving or undeserving of aid.',
  'AI may not conceal uncertainty or present generated claims as verified facts.',
] as const;
