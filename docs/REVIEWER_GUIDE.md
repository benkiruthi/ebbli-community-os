# Reviewer guide

This 10–15 minute path verifies repository claims without implying production readiness.

1. Read the maturity notice and `docs/FEATURE_STATUS.md`.
2. Install with the pinned toolchain using `pnpm install --frozen-lockfile`.
3. Run `pnpm format:check`, `pnpm migration:check`, `pnpm lint`,
   `pnpm typecheck`, and `pnpm test`.
4. Run `pnpm build --force` and confirm both workspace packages are included.
5. Start Docker/Supabase, then run `pnpm db:reset` and `pnpm test:db`.
6. Inspect the three module migrations and the forward security-hardening migration.
7. Read `docs/THREAT_MODEL.md` and `docs/RESPONSIBLE_AI.md`.
8. Review limitations and absent adoption in `docs/ADOPTION.md`.
9. Compare implemented/planned work in `ROADMAP.md`.

The landing page is the only meaningful current UI. Schema, RLS, and tests—not screenshots—
are the evidence for community modules.
