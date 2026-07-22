export type ReviewStatus =
  | "draft"
  | "pending_review"
  | "approved"
  | "rejected"
  | "closed";

export type CommunityPostKind = "need" | "opportunity";

export interface CommunityPost {
  id: string;
  communityId: string;
  authorId: string;
  kind: CommunityPostKind;
  title: string;
  body: string;
  locationText: string | null;
  contactPreference: string | null;
  reviewStatus: ReviewStatus;
  closesAt: string | null;
  createdAt: string;
  updatedAt: string;
}

export interface CommunityEvent {
  id: string;
  communityId: string;
  createdBy: string;
  title: string;
  description: string | null;
  locationText: string | null;
  startsAt: string;
  endsAt: string | null;
  capacity: number | null;
  status: "draft" | "published" | "cancelled" | "completed";
}

export interface CommunityComment {
  id: string;
  postId: string | null;
  eventId: string | null;
  authorId: string;
  parentId: string | null;
  body: string;
  isHidden: boolean;
  createdAt: string;
}

export interface CommunityNotification {
  id: string;
  recipientId: string;
  actorId: string | null;
  kind: "membership" | "post" | "comment" | "event" | "moderation" | "system";
  title: string;
  body: string | null;
  actionUrl: string | null;
  readAt: string | null;
  createdAt: string;
}
