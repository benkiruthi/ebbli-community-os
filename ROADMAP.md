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

Status: **Next**

- Verification workflows
- Community-led trust signals
- Moderation queues and appeals
- AI-assisted navigation with visible uncertainty
- Safety evaluations and human-review boundaries

## Phase 5 — Ecosystem and adoption

- Reusable packages and component library
- Localization and African-language support
- Low-bandwidth benchmarks
- Reference deployments for nonprofits, schools, churches, and community groups
- Stable releases and migration guides
