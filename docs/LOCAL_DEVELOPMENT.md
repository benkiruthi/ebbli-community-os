# Local development

## Requirements

- Node.js 20 or newer
- pnpm 10
- Docker Desktop
- Supabase CLI (installed through the workspace)

## Install

```bash
git clone https://github.com/benkiruthi/ebbli-community-os.git
cd ebbli-community-os
pnpm install
```

Copy the environment template:

```bash
cp .env.example apps/web/.env.local
```

## Start Supabase

Docker must be running.

```bash
pnpm db:start
```

The command prints the local API URL and anonymous key. Add them to `apps/web/.env.local`.

Reset the database and apply all migrations:

```bash
pnpm db:reset
```

## Run the reference app

```bash
pnpm dev
```

Open `http://localhost:3000`.

## Validate changes

```bash
pnpm format:check
pnpm lint
pnpm typecheck
pnpm test
pnpm build
```

## Security boundaries

- Use the anonymous key in browser code; never expose the service-role key.
- Enable Row Level Security for every table containing user or community data.
- Add authorization tests whenever policies change.
- Do not copy production Ebbli credentials, user data, or proprietary business logic into this repository.
