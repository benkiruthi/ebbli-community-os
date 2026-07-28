# Open-source readiness audit

**Audit date:** 2026-07-24

**Audited commit:** `f6ab522`

**Audit branch:** `codex/oss-readiness-audit`

**Scope:** repository inventory, baseline diagnostics, and remediation status

**Overall result:** **Technical readiness substantially improved; external evidence remains**

This audit is intentionally evidence-based. It does not claim adoption, production use,
independent security review, release readiness, or passing checks that were not observed.
Findings preserve the initial snapshot; the remediation addendum records subsequent fixes.

## Remediation addendum — 2026-07-24

Resolved in `codex/oss-readiness-audit`:

- OR-001, OR-002, OR-004, OR-005, OR-006, OR-007, OR-008, OR-009, OR-011, OR-012,
  OR-013, OR-014, OR-019, and OR-020.
- OR-003 is materially improved with 15 pgTAP checks, clean-reset CI, and both workspace
  unit suites; additional table-by-table negative coverage remains appropriate.
- Formatting, migration naming, lint, type checking, five unit tests, clean migration
  reset, 15 database tests, database linting, and a forced production build passed during
  remediation. The final pre-commit rerun is recorded in `docs/VALIDATION.md`.

Intentionally unresolved because they require external evidence, a larger product milestone,
or explicit maintainer authorization:

- OR-010: release process and alpha draft exist, but no tag/release was published.
- OR-015: accessibility and low-bandwidth commitments still need measured independent
  evidence.
- OR-016: secure object-storage upload/download remains unimplemented.
- OR-017: public adoption remains unavailable.
- OR-018: the reference UI remains a landing page.

These remaining limitations are now prominent in the README, feature matrix, adoption
document, pilot guide, reviewer guide, evidence table, and review simulation.

## Executive assessment

Ebbli Community OS has a credible mission, an Apache 2.0 license, a real Next.js workspace,
three substantial Supabase migrations, RLS on every application table, and an explicitly
bounded responsible-AI design. Its strongest current evidence is schema/domain work and
maintainer activity.

It is not ready for an OpenAI Codex for Open Source application. Four blockers should be
resolved first:

1. The public README materially understates and contradicts the repository state.
2. The `packages/core` code is not a workspace package, so its AI-safety tests are not run
   by the advertised root test command or CI.
3. No database/RLS tests validate the authorization and trust claims made by the roadmap.
4. The current CI uses a non-frozen install and does not validate migrations, RLS,
   dependencies, secrets, or static security.

The repository also has no tagged release, no public adoption evidence in the checkout, no
reference deployment, and no documented external installation. These are not defects to
hide; they are maturity facts to state plainly.

## Inventory

### Architecture and workspace

- Root: private pnpm/Turborepo package, Node `>=20`, pinned package-manager declaration
  `pnpm@10.13.1` (`package.json:2-25`).
- Workspace discovery: `apps/*` and `packages/*` (`pnpm-workspace.yaml:1-3`).
- Executable application: one Next.js application, `@ebbli/web`, at `apps/web`
  (`apps/web/package.json:1-29`).
- Application entry points: root layout at `apps/web/app/layout.tsx:4-15` and a static
  landing page at `apps/web/app/page.tsx:1-40`.
- Reusable code: TypeScript files under `packages/core/src`, but no
  `packages/core/package.json`; consequently this directory is not an executable workspace
  package.
- Provider boundary: a browser Supabase factory exists at
  `apps/web/lib/supabase/browser.ts:1-7`. No server data layer, API routes, notification
  provider, storage adapter, or AI provider implementation is present.
- The architecture document mostly describes a target package structure, not the current
  tree (`docs/ARCHITECTURE.md:7-27`).

### Database and RLS

- `20260722130000_initial_foundation.sql`: profiles, communities, memberships,
  authentication profile trigger, and RLS (`:1-103`).
- `20260722150000_phase3_core_modules.sql`: posts, evidence metadata, events, attendance,
  comments, notifications, reports, audit log, authorization helpers, policies, and audit
  triggers (`:1-300`).
- `20260722160000_phase4_trust_verification_ai.sql`: verification requests/evidence, trust
  signals/summaries, appeals, AI-assistance audit records, policies, and trust-summary
  functions (`:1-202`).
- All 17 application tables have an `enable row level security` statement. This is
  implementation evidence, not proof that the policies enforce the intended boundaries.
- There is no `supabase/tests`, SQL test suite, seed fixture, storage-bucket migration, or
  integration-test harness.

### Tests and quality commands

- Root scripts: `dev`, `build`, `lint`, `typecheck`, `test`, `format`, `format:check`,
  `db:start`, `db:stop`, and `db:reset` (`package.json:9-20`).
- Web scripts: Next.js development/build/start, ESLint, TypeScript, and Vitest
  (`apps/web/package.json:5-12`).
- Tests discovered:
  - two slug assertions in `apps/web/lib/slug.test.ts:1-12`;
  - three AI-safety cases in `packages/core/src/ai-safety.test.ts:1-46`.
- Only the web test file is currently reachable through the workspace test command.
- No browser, accessibility, performance, migration, RLS, authorization, misuse, or
  integration tests were found.

### CI, security, governance, and release files

- One CI workflow: `.github/workflows/ci.yml`.
- Issue forms: bug and feature request; pull-request template present.
- Governance/policy files: `CODE_OF_CONDUCT.md`, `CONTRIBUTING.md`, `SECURITY.md`,
  `docs/GOVERNANCE.md`, and `docs/RESPONSIBLE_AI.md`.
- Release files: `CHANGELOG.md` only. No release process, release notes, tags, or GitHub
  release configuration was found in the checkout.
- Missing requested public-maintenance files include `SUPPORT.md`,
  `docs/MAINTAINERS.md`, `docs/RELEASE_PROCESS.md`, and a private-report redirect issue
  form.

### Generated and local state

- Tracked generated file: `apps/web/next-env.d.ts`.
- Ignored local state observed: `.turbo/`, `apps/web/.next/`,
  `apps/web/.turbo/`, `node_modules/`, `apps/web/node_modules/`,
  `apps/web/tsconfig.tsbuildinfo`, `supabase/.branches/`, and `supabase/.temp/`.
- `pnpm-lock.yaml` is tracked.
- The diagnostic pnpm invocation created an untracked `.pnpm-store/`; the repository does
  not currently ignore a root local pnpm store.
- No tracked build artifact or committed secret was found by filename review and a
  working-tree pattern scan. This is not a full-history secret scan.

## Baseline validation observed

| Check                                     | Result                   | Notes                                                                                                                     |
| ----------------------------------------- | ------------------------ | ------------------------------------------------------------------------------------------------------------------------- |
| `node --version`                          | Failed requirement match | `v24.18.0`; supported by `>=20`, but not the documented/CI Node 20 baseline                                               |
| `pnpm --version`                          | Failed requirement match | `11.9.0`, while the repository declares `10.13.1`                                                                         |
| `pnpm format:check` equivalent            | **Failed**               | Prettier reported style issues in 38 files                                                                                |
| root lint through installed Turbo         | Passed from cache        | 1 package: `@ebbli/web`; core was excluded                                                                                |
| root typecheck through installed Turbo    | Passed from cache        | 1 package: `@ebbli/web`; core was excluded                                                                                |
| root test through installed Turbo         | Passed from cache        | 1 file and 2 tests; core AI-safety tests were excluded                                                                    |
| forced root build through installed Turbo | **Failed**               | local pnpm 11 attempted to purge modules without a TTY because the installed tree was created by a different pnpm version |
| clean Supabase reset                      | Not rerun in this pass   | Prior maintainer evidence is documented in the brief, not independently revalidated here                                  |
| dependency audit                          | Not run                  | Package-manager version/install state must be normalized first                                                            |
| full-history secret scan                  | Not run                  | No configured scanner is present                                                                                          |

These local results do not invalidate the previously reported clean reset and forced build
on the maintainer's configured environment. They demonstrate that the currently documented
toolchain is not yet reproducible in this audit environment and that CI may test less code
than repository readers reasonably expect.

## Findings

Each finding includes the shortest useful verification command. `Fixed` is **No** throughout
because this pass intentionally stops after the audit.

### OR-001 — README contradicts implemented repository state

- **Severity:** blocker
- **Evidence:** `README.md:33-46` labels implemented schema modules as planned;
  `README.md:50` says Phase 1; `README.md:69-75` says `apps` and `packages` are planned;
  `README.md:79` says the workspace is not initialized. `ROADMAP.md:20-30` marks Phase 2
  complete and `ROADMAP.md:34-60` marks Phases 3 and 4 implemented pending validation.
- **Impact:** a reviewer cannot determine what exists, and the contradiction signals stale
  maintenance.
- **Recommended fix:** rewrite the README around an honest pre-release maturity notice and
  distinguish schema/domain implementation, local validation, UI, security review, and
  release state.
- **Fixed:** No
- **Verify:** `rg -n "Phase 1|not yet been initialized|planned" README.md ROADMAP.md`

### OR-002 — Core package and its tests are outside the executable workspace

- **Severity:** blocker
- **Evidence:** `pnpm-workspace.yaml:1-3` includes `packages/*`, but
  `packages/core` has no `package.json`. Root test output scoped only `@ebbli/web` and ran
  two slug tests, while the three AI-safety tests exist at
  `packages/core/src/ai-safety.test.ts:1-46`.
- **Impact:** CI can report tests passing while the most safety-relevant TypeScript logic is
  neither tested nor typechecked.
- **Recommended fix:** make `packages/core` a proper workspace package with build,
  typecheck, test, and lint scripts; import it through a declared package boundary.
- **Fixed:** No
- **Verify:** `pnpm --filter @ebbli/core test` and `pnpm test`

### OR-003 — No RLS or database integration tests support the security claims

- **Severity:** blocker
- **Evidence:** `ROADMAP.md:46` and `ROADMAP.md:60` require authorization/RLS validation;
  `docs/LOCAL_DEVELOPMENT.md:61-62` requires authorization tests when policies change.
  No SQL or integration tests exist under `supabase/`; the observed test command ran only
  `apps/web/lib/slug.test.ts`.
- **Impact:** cross-community isolation, private evidence, moderator access, append-only
  audit behavior, appeals, and verification transitions are unverified.
- **Recommended fix:** add role-based database tests for anonymous, member, author,
  moderator, owner, and cross-community actors; execute them after a clean reset locally
  and in CI.
- **Fixed:** No
- **Verify:** `rg --files supabase | rg "test|spec"` and `pnpm test`

### OR-004 — CI is not reproducible and omits database/security gates

- **Severity:** blocker
- **Evidence:** `.github/workflows/ci.yml:24` uses
  `pnpm install --no-frozen-lockfile`. Lines 25-32 only format, lint, typecheck, test, and
  build. There is no migration reset, RLS suite, dependency review, CodeQL/static analysis,
  dependency audit, license check, or secret scan.
- **Impact:** lockfile drift can be accepted and the repository's highest-risk database
  surface is not validated on pull requests.
- **Recommended fix:** use a frozen lockfile; add least-privilege migration/RLS validation
  with local test credentials; add appropriately scoped dependency, secret, and static
  analysis workflows.
- **Fixed:** No
- **Verify:** inspect a pull request's required checks and
  `rg -n "frozen|supabase|codeql|dependency|secret" .github`

### OR-005 — Verification requesters can write reviewer-controlled fields

- **Severity:** high
- **Evidence:** requester updates are selected by old status at
  `supabase/migrations/20260722160000_phase4_trust_verification_ai.sql:107-110`, but the
  `WITH CHECK` only preserves `requester_id`. The table contains reviewer-controlled
  `status`, `reviewed_at`, `reviewed_by`, `decision_reason`, and `expires_at` columns at
  `:13-21`.
- **Impact:** an authenticated requester may be able to set an approved status or reviewer
  metadata through a direct update, undermining verification integrity.
- **Recommended fix:** enforce allowed state transitions and immutable/reviewer-only fields
  with separate RPCs/triggers or restrictive checks; add hostile-client RLS tests.
- **Fixed:** No
- **Verify:** an authenticated SQL test must attempt to change a request from `draft` to
  `approved` and must be denied.

### OR-006 — Update policies do not protect field-level integrity

- **Severity:** high
- **Evidence:** broad update policies appear at
  `20260722150000_phase3_core_modules.sql:177-181`, `:215-216`, `:246-247`, and
  `:267-272`; appeal review uses only reviewer identity at
  `20260722160000_phase4_trust_verification_ai.sql:152-154`.
- **Impact:** authorized row editors may change ownership, tenant linkage, reviewer
  assignment, moderation linkage, or other fields beyond the intended workflow. RLS is
  row-level, not column-level.
- **Recommended fix:** define immutable-column triggers or narrow security-definer
  transition functions with explicit grants; test every ownership and tenant field.
- **Fixed:** No
- **Verify:** database tests attempt to change `author_id`, `community_id`,
  `appellant_id`, `reviewer_id`, and linked entity IDs.

### OR-007 — Security-definer execution privileges are not explicitly narrowed

- **Severity:** high
- **Evidence:** security-definer helpers/functions exist at
  `20260722150000_phase3_core_modules.sql:136-159` and `:277-292`, and
  `20260722160000_phase4_trust_verification_ai.sql:160-198`. No `REVOKE EXECUTE` or
  explicit role-specific `GRANT EXECUTE` statements are present.
- **Impact:** PostgreSQL functions are executable by `PUBLIC` by default unless privileges
  are changed. Callable security-definer functions expand the attack surface even when
  their current bodies appear bounded.
- **Recommended fix:** inventory callable functions, revoke public execution, grant only
  required roles, use hardened search paths, and test direct invocation.
- **Fixed:** No
- **Verify:** query `information_schema.routine_privileges` after reset and test `anon` and
  `authenticated` execution.

### OR-008 — Formatting gate currently fails across the repository

- **Severity:** high
- **Evidence:** the audit's Prettier check reported style issues in 38 tracked files,
  including CI, application, documentation, packages, lockfile, and configuration.
- **Impact:** the existing CI formatting step should fail on the current default branch,
  so visible green CI evidence cannot be assumed.
- **Recommended fix:** apply one mechanical formatting commit, confirm no semantic changes,
  and rerun all gates.
- **Fixed:** No
- **Verify:** `pnpm format:check`

### OR-009 — Package-manager and local-store behavior is not reproducible

- **Severity:** high
- **Evidence:** `package.json:5` declares pnpm `10.13.1`; the audit environment resolved
  pnpm `11.9.0`. A forced build failed during pnpm's dependency-state check, and a root
  `.pnpm-store/` became untracked. `.gitignore:41-55` does not cover `.pnpm-store/`.
- **Impact:** contributors can encounter implicit module purges, non-interactive failures,
  and a dirty tree even before application work.
- **Recommended fix:** document Corepack/pinned pnpm activation, test frozen installation
  from a clean checkout, and ignore only the confirmed local store artifact.
- **Fixed:** No
- **Verify:** clean-clone `corepack pnpm --version`,
  `pnpm install --frozen-lockfile`, all checks, then `git status --short`.

### OR-010 — The release/version story is internally inconsistent

- **Severity:** medium
- **Evidence:** root and web packages declare `0.2.0` (`package.json:3`,
  `apps/web/package.json:3`); `CHANGELOG.md:5` says Semantic Versioning will begin later,
  and `CHANGELOG.md:22-24` lists `0.1.0`. `git tag --list` returned no tags.
- **Impact:** a reviewer cannot map package version, changelog entry, and a verifiable
  release.
- **Recommended fix:** document versioning and release procedure; prepare but do not
  publish an honest alpha release until validation and security gates pass.
- **Fixed:** No
- **Verify:** `git tag --list` and compare package versions with `CHANGELOG.md`.

### OR-011 — Feature maturity is not centrally controlled

- **Severity:** medium
- **Evidence:** README calls all modules planned (`README.md:33-46`), roadmap calls schema
  phases implemented (`ROADMAP.md:32-60`), the app labels itself Phase 2
  (`apps/web/app/page.tsx:12`), and the UI is a static module overview
  (`apps/web/app/page.tsx:8-40`).
- **Impact:** documentation can accidentally imply complete end-user workflows where only
  schemas or interfaces exist.
- **Recommended fix:** add `docs/FEATURE_STATUS.md` with separate design, schema, RLS,
  domain/API, UI, tests, security-review, docs, and release columns.
- **Fixed:** No
- **Verify:** cross-check every README “implemented” statement against the matrix.

### OR-012 — Contributor setup is aspirational rather than executable

- **Severity:** medium
- **Evidence:** `CONTRIBUTING.md:19-59` describes workflow but omits prerequisites, install
  commands, database reset, exact checks, migration timestamp uniqueness, RLS test
  requirements, definition of done, and triage boundaries. It says checks should pass
  “once they are available” at `:59`, although CI exists.
- **Impact:** outside contributors cannot reliably reproduce maintainer expectations.
- **Recommended fix:** consolidate executable setup and review requirements, including
  Windows/WSL2/Docker constraints.
- **Fixed:** No
- **Verify:** a non-maintainer follows only `CONTRIBUTING.md` from a clean clone.

### OR-013 — Security reporting has no explicit private contact route

- **Severity:** medium
- **Evidence:** `SECURITY.md:11` says to send a private report to the maintainer but gives
  no verified email or exact GitHub private-vulnerability-reporting path. The issue config
  links to the repository security overview (`.github/ISSUE_TEMPLATE/config.yml:3-5`).
- **Impact:** reporters may not know how to deliver a vulnerability privately.
- **Recommended fix:** verify and document GitHub private vulnerability reporting or a
  dedicated security contact; do not collect vulnerability details in a public issue.
- **Fixed:** No
- **Verify:** follow the security-report path while signed out and signed in.

### OR-014 — Architecture documentation overstates the current modular shape

- **Severity:** medium
- **Evidence:** `docs/ARCHITECTURE.md:9-25` shows eight planned packages and a seed
  directory; the checkout contains only an unconfigured `packages/core/src` and no seed.
  The document does label the structure as a target at `:27`, but offers no current-state
  diagram.
- **Impact:** reviewers must infer which boundaries are real.
- **Recommended fix:** show current and target architecture separately and add an accurate
  Mermaid diagram covering Next.js, Supabase Auth/Postgres/RLS, evidence storage boundary,
  moderation/verification, AI assistance, human review, and audit logging.
- **Fixed:** No
- **Verify:** every diagram node maps to a path or is explicitly labeled planned/external.

### OR-015 — Accessibility and low-bandwidth commitments lack evidence

- **Severity:** medium
- **Evidence:** commitments appear in `README.md:26-31`,
  `CONTRIBUTING.md:61-71`, and `docs/VISION.md:5-22`. The UI has responsive CSS
  (`apps/web/app/globals.css:17-31`) and semantic headings, but no automated accessibility
  tests, audit, performance budget, offline strategy, or low-bandwidth benchmark.
- **Impact:** these are currently design intentions rather than demonstrated OSS
  contributions.
- **Recommended fix:** add measurable budgets and an accessible reference workflow before
  promoting these as project strengths.
- **Fixed:** No
- **Verify:** automated accessibility checks plus a documented throttled-network benchmark.

### OR-016 — Evidence storage is only metadata and policy guidance

- **Severity:** medium
- **Evidence:** evidence tables store paths/metadata
  (`20260722150000_phase3_core_modules.sql:26-36` and
  `20260722160000_phase4_trust_verification_ai.sql:27-35`), while
  `docs/PHASE_3_MODULES.md:49-50` says storage policies, malware scanning, validation,
  limits, and retention remain future deployment work.
- **Impact:** documentation must not imply secure upload/download workflows are implemented.
- **Recommended fix:** label this boundary explicitly in the feature matrix and pilot guide;
  implement/test private storage policies before any evidence-upload demo.
- **Fixed:** No
- **Verify:** inspect `storage.buckets` and `storage.objects` policies after reset.

### OR-017 — Public maintenance and adoption evidence is absent from the checkout

- **Severity:** medium
- **Evidence:** no adoption, pilot, reviewer, maintainer, or support document exists; no
  release tag exists. Repository files contain no verifiable deployment, outside user,
  independent installation, contributor, pilot, download, star, or fork evidence.
- **Impact:** the application cannot safely claim meaningful usage or broad adoption.
- **Recommended fix:** state “Public adoption evidence is not yet available,” publish an
  ethical pilot guide, and pursue one independently documented installation or pilot.
- **Fixed:** No
- **Verify:** map only GitHub/API-verifiable metrics and consented pilot evidence in
  `docs/CODEX_FOR_OSS_APPLICATION_EVIDENCE.md`.

### OR-018 — Application code is a landing page, not a reference workflow

- **Severity:** medium
- **Evidence:** `apps/web/app/page.tsx:1-40` renders static copy and repository links.
  There are no authentication screens, server routes/actions, community CRUD screens, or
  schema-backed workflows.
- **Impact:** screenshots cannot demonstrate the implemented database modules, and a
  reviewer may mistake schema breadth for product completeness.
- **Recommended fix:** document the limitation immediately; later prioritize one coherent,
  secure reference workflow instead of many shallow screens.
- **Fixed:** No
- **Verify:** reviewer walkthrough should identify exactly which screen talks to which
  tested policy.

### OR-019 — Templates do not capture all high-risk review dimensions

- **Severity:** low
- **Evidence:** the PR checklist covers broad concerns
  (`.github/PULL_REQUEST_TEMPLATE.md:27-36`) but does not explicitly ask whether migrations
  or RLS policies changed, nor request separate privacy/security/moderation/AI-safety impact
  explanations.
- **Impact:** reviewers can miss database-specific security work.
- **Recommended fix:** expand the PR template and add a public security/privacy concern
  form that only redirects private vulnerabilities.
- **Fixed:** No
- **Verify:** open a draft PR and confirm all requested prompts render.

### OR-020 — Documentation set lacks validation, support, release, threat, and reviewer guides

- **Severity:** low
- **Evidence:** 46 tracked files were inventoried. The required files
  `docs/VALIDATION.md`, `docs/THREAT_MODEL.md`, `docs/RELEASE_PROCESS.md`,
  `docs/ADOPTION.md`, `docs/PILOT_GUIDE.md`, `docs/MAINTAINERS.md`,
  `docs/REVIEWER_GUIDE.md`, `SUPPORT.md`, and the application evidence/draft/simulation
  documents do not exist.
- **Impact:** operational knowledge remains implicit with the sole maintainer.
- **Recommended fix:** create these after blocker fixes so they describe verified behavior,
  not intended behavior.
- **Fixed:** No
- **Verify:** `rg --files docs . | sort`

## Security and threat-review summary

### Assets

Identity/profile records, community membership and roles, needs/opportunities, evidence
references, event attendance, comments, private notifications, reports, moderation audit
records, verification evidence, trust signals/summaries, appeals, and AI audit metadata.

### Actors

Anonymous visitors, authenticated non-members, members, content authors, community
moderators, community owners, assigned appeal reviewers, application service roles, and a
malicious or compromised account in any of those categories.

### Trust boundaries

Browser to Supabase, Supabase Auth to PostgreSQL, tenant/community boundaries, RLS to
security-definer functions, database metadata to future private object storage, AI provider
boundary, AI output to human reviewer, and maintainer/release automation to repository.

### Priority abuse cases

Unauthorized verification approval; mutation of tenant/owner/reviewer fields; cross-community
reads; evidence-path leakage; report and moderation abuse; forged trust signals; direct
security-definer invocation; audit-log bypass/tampering; notification privacy leaks; prompt
injection in community/evidence content; unsafe AI auto-publication; and unverifiable human
review metadata.

The existing design documents recognize many of these risks, but the implementation lacks
tests proving the controls.

## Dead links, placeholders, TODOs, and unused code

- No project TODO/FIXME markers were found outside sample Git hooks.
- The bug issue form's “Go to...” text is an intentional user-entry placeholder
  (`.github/ISSUE_TEMPLATE/bug_report.yml:21-24`).
- No definitively dead Markdown link was identified by static path inspection. External
  links were not network-validated in this pass.
- `packages/core/src/*` is effectively disconnected code from the workspace quality gates.
- `apps/web/lib/supabase/browser.ts` and community types have no observed caller in the
  current static page.
- `apps/web/next-env.d.ts` is tracked and consistent with the current Next.js-generated
  reference, but generation stability should be rechecked after a clean build.

## Proposed remediation order

1. Normalize the pinned toolchain and get a clean frozen install.
2. Make `packages/core` a real workspace package; ensure all code is linted, typed, and
   tested.
3. Fix the verification/update-policy integrity risks and explicitly restrict
   security-definer execution.
4. Add migration-order, reset, RLS, cross-tenant, audit, verification, appeal, and AI-boundary
   tests.
5. Make formatting and the full forced build pass without cache; record exact versions and
   results.
6. Replace CI's non-frozen install and add database/security quality gates.
7. Rewrite README and add the feature-status matrix, using only verified maturity labels.
8. Improve contributor, security, support, governance, maintainer, release, threat-model,
   validation, and reviewer documentation.
9. Prepare—but do not publish—an alpha release draft.
10. Publish honest adoption/pilot guidance and obtain independent usage evidence before
    drafting the final application copy.

## Recommended decision

**Do not apply yet.** The project has a credible foundation and strong fit for maintainer
automation, but the current default-branch evidence overstates test coverage, understates
implemented schema work, and does not prove the most consequential authorization claims.
Resolve OR-001 through OR-009, demonstrate green pull-request CI, and obtain at least one
independent installation or pilot signal before reassessing application readiness.
