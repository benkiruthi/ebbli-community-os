# Threat model

## Scope and assets

The model covers profiles, tenant membership/roles, community content, evidence references,
attendance, notifications, reports, moderation audits, verification, trust summaries,
appeals, and AI audit metadata. Object storage and production provider integrations are
future boundaries.

## Actors and boundaries

Actors include anonymous visitors, authenticated non-members, members, authors, moderators,
owners, appeal reviewers, service processes, compromised accounts, and malicious content
authors. Boundaries are browser-to-API, Auth-to-PostgreSQL, community-to-community, RLS-to-
privileged functions, database-to-private storage, AI-provider-to-human-review, and
maintainer-to-release automation.

| Threat                                | Control today                                   | Remaining work                                   |
| ------------------------------------- | ----------------------------------------------- | ------------------------------------------------ |
| Cross-community disclosure            | RLS membership/moderator predicates             | Expand negative tests to every table             |
| Ownership/tenant reassignment         | Immutable-field triggers                        | Independent review and more misuse tests         |
| Verification self-approval            | Restricted update policy and trigger            | Formal transition function/reviewer UI           |
| Evidence leakage                      | Private-by-default metadata RLS                 | Private bucket policies, scanning, retention     |
| False verification/trust manipulation | Moderator checks and audited summaries          | Conflict-of-interest and expiry controls         |
| Moderation abuse                      | Role checks, reports, appeals, audit records    | Broader audit coverage and reviewer separation   |
| Audit tampering                       | No client write policy; trigger-only writes     | Retention/export and privileged-admin monitoring |
| Notification privacy                  | Recipient-only RLS                              | Delivery-provider privacy review                 |
| Prompt injection/harmful advice       | Deterministic risk boundaries, human review     | Provider sandbox, evaluations, incident process  |
| Secret exposure                       | ignored env files, CI placeholders              | Automated full-history secret scanning           |
| Supply-chain compromise               | lockfile, Dependabot, dependency review, CodeQL | Pin actions to immutable SHAs by policy          |

## Security assumptions

Deployers protect service-role credentials, configure private Storage, review legal/privacy
obligations, keep JWT lifetimes appropriate, and do not expose the local stack publicly.
RLS is not a substitute for field validation, abuse throttling, malware scanning, backups,
or incident response.

Review this model for every migration, new provider, sensitive field, public deployment, and
release candidate.
