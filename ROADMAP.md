# Roadmap

Ebbli Community OS is being built in deliberate phases. Dates are intentionally flexible until the contributor base and technical scope mature.

## Phase 1 — Open-source foundation

Status: **Completed**

- Establish project vision and positioning
- Add Apache 2.0 license
- Add contribution, conduct, and security policies
- Document architecture principles
- Document responsible AI principles
- Define community governance
- Add issue and pull request templates
- Publish initial roadmap and changelog

## Phase 2 — Technical foundation

Status: **Completed**

- Initialize a pnpm and Turborepo monorepo
- Create a mobile-first Next.js reference application
- Add strict TypeScript, ESLint, Prettier, Vitest, and GitHub Actions CI
- Define validated environment configuration
- Add a reproducible Supabase local-development workflow
- Publish initial profiles, communities, and memberships migration
- Add authentication-triggered profile creation
- Add secure Row Level Security examples
- Document installation, validation, and security boundaries

## Phase 3 — Core community modules

Status: **Implemented — validation pending before release**

- Communities and memberships authorization helpers
- Needs and opportunities with moderated review states
- Evidence attachment metadata with private-by-default visibility
- Events and attendance responses
- Nested comments and member interaction
- Private recipient notifications
- Reporting and moderation workflows
- Append-only moderation audit trail
- TypeScript domain contracts and module documentation

Before a tagged Phase 3 release, maintainers must run the local Supabase reset, authorization-policy tests, lint, type checking, unit tests, and production build.

## Phase 4 — Trust and responsible AI

Status: **Implemented — validation and security review pending before release**

- Verification requests with private evidence metadata and explicit review states
- Explainable trust signals and bounded profile trust summaries
- Human-led moderation appeals
- AI-assistance audit records with model, prompt, confidence, risk, and review metadata
- Deterministic AI safety classification and human-review boundaries
- Safety evaluation, privacy, retention, and deployment guidance
- Tests for low-, high-, and critical-risk AI assistance scenarios

Before a tagged Phase 4 release, maintainers must validate all migrations against a clean local Supabase instance, test RLS using multiple roles, run the complete CI suite, and complete a privacy and abuse-case review.

## Phase 5 — Ecosystem and adoption

Status: **Next**

- Reusable packages and component library
- Localization and African-language support
- Low-bandwidth benchmarks
- Reference deployments for nonprofits, schools, churches, and community groups
- Stable releases and migration guides
