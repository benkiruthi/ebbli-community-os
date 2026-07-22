import { describe, expect, it } from 'vitest';
import { evaluateAiSafety } from './ai-safety';

describe('evaluateAiSafety', () => {
  it('requires human review for moderation decisions', () => {
    const result = evaluateAiSafety({
      purpose: 'Recommend whether to suspend a member',
      containsSensitivePersonalData: false,
      affectsAccessToMoneyOrEssentialServices: false,
      affectsModerationOrVerification: true,
      userMayBeInImmediateDanger: false,
      confidence: 0.99,
    });

    expect(result.riskLevel).toBe('high');
    expect(result.humanReviewRequired).toBe(true);
    expect(result.mayAutoPublish).toBe(false);
  });

  it('allows low-risk navigation assistance', () => {
    const result = evaluateAiSafety({
      purpose: 'Suggest relevant public communities',
      containsSensitivePersonalData: false,
      affectsAccessToMoneyOrEssentialServices: false,
      affectsModerationOrVerification: false,
      userMayBeInImmediateDanger: false,
      confidence: 0.9,
    });

    expect(result.riskLevel).toBe('low');
    expect(result.mayAutoPublish).toBe(true);
  });

  it('escalates possible immediate danger', () => {
    const result = evaluateAiSafety({
      purpose: 'Respond to a possible emergency',
      containsSensitivePersonalData: true,
      affectsAccessToMoneyOrEssentialServices: false,
      affectsModerationOrVerification: false,
      userMayBeInImmediateDanger: true,
    });

    expect(result.riskLevel).toBe('critical');
    expect(result.humanReviewRequired).toBe(true);
  });
});
