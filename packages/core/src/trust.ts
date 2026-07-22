export type VerificationKind = 'person' | 'organization' | 'community_leader';
export type VerificationStatus =
  | 'draft'
  | 'submitted'
  | 'under_review'
  | 'approved'
  | 'rejected'
  | 'expired'
  | 'revoked';

export interface VerificationRequest {
  id: string;
  requesterId: string;
  communityId: string | null;
  kind: VerificationKind;
  status: VerificationStatus;
  submittedAt: string | null;
  reviewedAt: string | null;
  expiresAt: string | null;
}

export interface TrustSummary {
  profileId: string;
  score: number;
  verificationLevel: 0 | 1 | 2 | 3;
  signalCount: number;
  lastCalculatedAt: string;
}

export type AppealStatus =
  | 'submitted'
  | 'under_review'
  | 'upheld'
  | 'overturned'
  | 'withdrawn';

export interface ModerationAppeal {
  id: string;
  moderationActionId: string;
  appellantId: string;
  status: AppealStatus;
  reason: string;
  reviewerId: string | null;
  decisionReason: string | null;
}

export function trustLabel(score: number): 'limited' | 'developing' | 'established' {
  if (score >= 150) return 'established';
  if (score >= 30) return 'developing';
  return 'limited';
}

export function canShowVerifiedBadge(status: VerificationStatus, expiresAt: string | null): boolean {
  if (status !== 'approved') return false;
  if (!expiresAt) return true;
  return new Date(expiresAt).getTime() > Date.now();
}
