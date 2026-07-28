# Security Policy

## Supported versions

Ebbli Community OS is currently pre-release. Security fixes will target the default branch until stable releases are published.

## Reporting a vulnerability

Please do not open a public issue for suspected vulnerabilities.

Use GitHub's **Security → Report a vulnerability** private reporting flow for
`benkiruthi/ebbli-community-os`. If that option is unavailable, open a public issue
containing no vulnerability details and ask for a private contact channel.

Include privately:

- a clear description of the issue;
- affected files, modules, or endpoints;
- reproduction steps or proof of concept;
- potential impact;
- suggested remediation, if known.

Do not include real user data, production credentials, or secrets in reports.

## Response process

The maintainer will aim to:

1. acknowledge the report;
2. assess severity and reproducibility;
3. coordinate a fix and disclosure timeline;
4. credit the reporter where appropriate and desired.

These are process goals, not guaranteed response times.

## Security expectations

Contributions involving authentication, authorization, Supabase Row Level Security, file uploads, evidence documents, moderation, private messaging, or AI data handling require explicit security review.

Never commit API keys, service-role keys, database passwords, private certificates, or production user information.

The current early-alpha release line has no production support guarantee. Database, Storage,
AI, authentication, moderation, and evidence-handling changes require explicit review and
negative authorization tests.
