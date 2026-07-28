# Validation

## Supported development baseline

- Node.js 20 LTS (CI baseline; `>=20` is accepted by package metadata)
- pnpm 10.13.1 through Corepack
- Docker Desktop on Windows, macOS, or Linux
- Supabase CLI from the committed workspace lockfile

## Clean validation

```bash
corepack enable
corepack prepare pnpm@10.13.1 --activate
pnpm install --frozen-lockfile
pnpm format:check
pnpm migration:check
pnpm lint
pnpm typecheck
pnpm test
pnpm build --force
pnpm db:start
pnpm db:reset
pnpm test:db
pnpm exec supabase db lint --level warning
pnpm exec supabase status
git status --short
```

Expected results are a frozen install, both workspace packages included in Turbo output,
all checks passing, all migrations applied once, pgTAP passing, and no generated untracked
files.

## Windows, WSL2, and Docker

Docker Desktop should use the WSL2 backend. Local analytics is disabled in
`supabase/config.toml` because it is optional and has caused Windows compatibility issues.
If Docker is unavailable, JavaScript checks can still run, but database validation must be
recorded as not run rather than treated as passing.

If pnpm wants to purge `node_modules`, confirm the active version is 10.13.1, remove the
install only through a deliberate clean-install workflow, and reinstall with the frozen
lockfile. Do not mix pnpm major versions.

## Troubleshooting

- Duplicate migration versions: run `pnpm migration:check`.
- Docker connection failure: start Docker Desktop and verify `docker info`.
- Ports 54320–54324 occupied: stop the conflicting local stack before retrying.
- Local Supabase state problems: run `pnpm db:stop`, then start and reset again.
- Build environment errors: confirm the two public Supabase variables are valid URL/key
  shaped values; never substitute production secrets.

## Validation record

Validated on Windows 11 with Node.js `v24.18.0`, pnpm `10.13.1`, Supabase CLI from the
workspace, WSL2, and Docker Desktop on 2026-07-24. The repository baseline remains Node 20
LTS in CI.

Observed passing results: frozen install; Prettier; four unique migrations; uncached lint
and typecheck for two packages; five unit tests; forced production build; clean database
reset; 15 pgTAP checks; and database lint with no schema errors. A high-confidence pattern
scan found no secrets in reachable Git history. The external npm advisory audit was not
run because advisory-service egress was not authorized; CI dependency review covers pull
requests. A passing build is not a security certification.
