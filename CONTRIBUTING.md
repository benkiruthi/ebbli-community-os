# Contributing to Ebbli Community OS

Thank you for helping build trustworthy, mobile-first community infrastructure.

## Before you begin

Please read:

- `README.md`
- `CODE_OF_CONDUCT.md`
- `ROADMAP.md`
- `docs/ARCHITECTURE.md`
- `docs/RESPONSIBLE_AI.md`

## Prerequisites and setup

Use Node.js 20 LTS, Corepack, pnpm 10.13.1, Docker Desktop, and Git.

```bash
corepack enable
corepack prepare pnpm@10.13.1 --activate
pnpm install --frozen-lockfile
pnpm db:start
pnpm db:reset
pnpm dev
```

## Ways to contribute

You can help through code, documentation, product research, accessibility testing, security review, localization, design, moderation systems, and community feedback.

## Development workflow

1. Open or find an issue before starting substantial work.
2. Comment on the issue with your proposed approach.
3. Fork the repository or create a feature branch.
4. Keep changes focused and documented.
5. Add tests where code behavior changes.
6. Run the complete validation relevant to the change.
7. Open a pull request using the provided template.

## Branch naming

Use clear branch names:

```text
feature/community-directory
fix/mobile-navigation
docs/architecture-overview
security/rls-policy-review
```

## Commit messages

Prefer conventional, descriptive commits:

```text
feat: add opportunity posting schema
fix: prevent unauthorized community updates
docs: explain moderation workflow
test: cover needs approval rules
```

## Pull request expectations

A pull request should:

- explain the problem and solution;
- reference an issue where possible;
- avoid unrelated changes;
- include screenshots for interface changes;
- describe privacy, security, moderation, or AI implications;
- pass all applicable automated checks.

## Database migrations and RLS

- Create forward-only migrations with the Supabase CLI and a unique 14-digit timestamp.
- Run `pnpm migration:check`, `pnpm db:reset`, and `pnpm test:db`.
- Never edit a migration already included in a published release.
- RLS changes require positive and negative tests for anonymous, member, owner/moderator,
  and cross-community access where applicable.
- Protect immutable ownership, tenant, reviewer, and workflow-state fields explicitly.

## Design requirements

Contributions should support:

- mobile-first use;
- keyboard and screen-reader accessibility;
- low-bandwidth environments;
- secure defaults;
- clear error states;
- privacy-conscious data collection;
- localization-ready interfaces.

## AI contributions

AI features must follow `docs/RESPONSIBLE_AI.md`. Do not add systems that silently make high-impact decisions, expose private information, or present unverified claims as trusted facts.

## Security

Do not report vulnerabilities in public issues. Follow `SECURITY.md`.

## Definition of done

- Formatting, migration naming, lint, type checking, unit tests, database tests, and build
  pass where applicable.
- Security, privacy, moderation, AI safety, accessibility, mobile, and low-bandwidth effects
  are documented.
- Documentation and `docs/FEATURE_STATUS.md` match the implementation.
- No secret, production data, generated cache, or unrelated change is committed.

## Triage and response boundaries

Maintainers triage for reproducibility, impact, safety, roadmap fit, and available capacity.
Reports may be closed as duplicates, redirected for private security handling, or deferred.
There is no guaranteed response time or acceptance promise.

## Contributor recognition

Meaningful contributors may be recognized in release notes, project documentation, and future governance roles.
