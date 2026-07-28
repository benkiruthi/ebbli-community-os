# Release process

The project uses Semantic Versioning. Until the API and migrations stabilize, releases are
pre-releases such as `v0.2.0-alpha.1`.

## Checklist

1. Confirm all planned scope is represented in issues and the feature matrix.
2. Use a unique forward-only migration; review compatibility and rollback implications.
3. Complete privacy, security, RLS, responsible-AI, accessibility, and low-bandwidth review.
4. Run the full checklist in `docs/VALIDATION.md` from a clean checkout.
5. Require green CI and resolve material review comments.
6. Update `CHANGELOG.md`, version fields, known limitations, and setup/upgrade notes.
7. Draft release notes stating what is included and excluded.
8. Create a signed/annotated tag when practical and mark early versions as GitHub
   pre-releases.
9. Verify installation from the tag.

Database migrations are forward-only. Rollback may require a corrective migration or
database restore; release notes must say which. Never publish a release automatically
without maintainer authorization.

## `v0.2.0-alpha.1`

Includes the workspace foundation, schema/domain modules through trust and responsible AI,
RLS hardening, automated database tests, and maintainer documentation. It excludes a
complete UI, secure object-storage workflow, public deployment, and production certification.
The release is intended for evaluation, independent installation testing, and early pilots.
