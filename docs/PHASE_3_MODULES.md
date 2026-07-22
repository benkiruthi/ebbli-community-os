# Phase 3 core community modules

Phase 3 introduces the reusable social and operational primitives needed by community-led platforms.

## Communities and memberships

Phase 2 established communities, profiles, and membership roles. Phase 3 modules consistently use active membership and moderator checks so private community data does not become readable merely because a user is authenticated.

## Needs and opportunities

`community_posts` supports two post kinds:

- `need`
- `opportunity`

Posts move through explicit review states: draft, pending review, approved, rejected, and closed. Authors can prepare and revise unapproved posts. Community moderators can review them. Public feeds should display approved posts only.

## Evidence

`post_evidence` stores metadata for files or external references connected to a need or opportunity. Evidence is private by default. Applications should use a private storage bucket and short-lived signed URLs for non-public evidence.

Evidence is not proof of legitimacy by itself. Interfaces must tell members to verify claims independently before sending money, sharing sensitive information, or taking consequential action.

## Events

Events support draft, published, cancelled, and completed states, optional capacity, locations, schedules, and attendance responses.

## Comments

Comments attach to exactly one parent type: a community post or an event. Nested replies use `parent_id`. Moderation can hide comments without immediately deleting the audit context.

## Notifications

Notifications are private to their recipient and support membership, post, comment, event, moderation, and system activity. Generation and delivery should happen from trusted server-side code rather than directly from untrusted clients.

## Reports and moderation

Members can report one community, post, comment, or event at a time. Reports move through open, reviewing, resolved, and dismissed states. Moderators can access reports for communities they manage.

## Audit trail

The initial audit log records post review-state and report-status changes. It is intentionally append-only from normal client roles. Future work should extend auditing to membership role changes, content removal, evidence access, and appeals.

## Security notes

- Row Level Security is enabled for every Phase 3 table.
- Helper functions centralize active-member and moderator checks.
- Browser code must never receive a Supabase service-role key.
- File storage policies must be created separately before evidence uploads are enabled.
- Production deployments should add abuse throttling, malware scanning, content-type validation, maximum file sizes, retention rules, and policy tests.

## Validation still required

The migrations and TypeScript domain contracts are committed, but maintainers should run the local Supabase reset, authorization tests, lint, type checking, unit tests, and production build before declaring a tagged release.
