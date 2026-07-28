# Codex for Open Source application draft

Do not submit until final validation is green, the readiness PR demonstrates public
maintenance, and evidence marked unsafe in the evidence table is removed or resolved.

## Identity fields

- First name: Ben
- Last name: Kiruthi
- Email associated with ChatGPT: `[maintainer to enter]`
- GitHub username: `benkiruthi`
- Repository: `https://github.com/benkiruthi/ebbli-community-os`
- Primary or core maintainer: Yes
- Interest in Codex Security: `[maintainer to select]`
- Interest in API credits: `[maintainer to select]`
- OpenAI Organization ID: `[maintainer to enter]`

## Why does this repository qualify? (500 characters maximum)

**Primary — 458 characters**

Ebbli Community OS is an Apache-2.0 early-alpha project building reusable community
infrastructure: profiles, memberships, needs and opportunities, moderation, verification,
appeals, audit records, and bounded AI assistance. It is designed for mobile-first,
low-bandwidth African contexts while remaining adaptable globally. As the sole primary
maintainer, I own architecture, migrations, RLS/security review, issue triage, releases,
and contributor support.

**Alternative A — 377 characters**

Ebbli Community OS addresses a repeated open-source need: safe community platforms should
not rebuild membership, moderation, verification, appeals, and audit controls from scratch.
The project is early alpha and has no broad-adoption claim. Its ecosystem case is reusable,
mobile-first infrastructure shaped by low-bandwidth African contexts. I am its sole primary
maintainer.

**Alternative B — 351 characters**

This public Apache-2.0 repository turns common community-platform concerns into reusable
schema, RLS, domain, safety, and governance patterns. It is pre-release and honest about its
minimal UI and absent public adoption. I maintain the architecture, security boundaries,
database migrations, reviews, releases, documentation, and contributor workflow.

## How will API credits be used? (500 characters maximum)

**Primary — 461 characters**

Credits would support maintainer work on real repository changes: reviewing pull requests,
triaging issues, generating negative RLS and migration tests, analyzing authorization and
AI-safety risks, preparing release notes, keeping documentation aligned with code, and
onboarding contributors. I would also use Codex to measure and improve accessibility and
low-bandwidth behavior. Human review would remain required for merges, security decisions,
and releases.

**Alternative A — 410 characters**

I would use credits to reduce a one-maintainer bottleneck: reproduce bug reports, review
focused PRs, test migration ordering and tenant isolation, inspect RLS and privileged
functions, expand misuse cases, draft release artifacts, and maintain contributor
documentation. Codex would assist—not replace—human security, moderation, and responsible-AI
judgment, and it would never publish releases automatically.

**Alternative B — 377 characters**

API credits would fund repeatable OSS maintenance: issue classification, PR review,
regression-test generation, clean-migration validation, RLS threat analysis, changelog and
release preparation, documentation checks, and contributor setup support. Accessibility
and throttled-network findings would become tracked work. The maintainer retains final
review and release control.

## Anything else we should know? (500 characters maximum)

**Primary — 424 characters**

The project is deliberately not presenting itself as widely adopted or production-ready.
Its strongest evidence today is reusable schema/domain work, explicit RLS and human-review
boundaries, reproducible validation, and transparent limitations. Public adoption evidence
is not yet available. Codex would help turn this foundation into reviewed releases,
maintainable contributor workflows, and a credible independent pilot.

**Alternative A — 351 characters**

Ebbli is early alpha, schema-first, and currently maintained by one person. There is no
public deployment, outside pilot, or independent security review yet. Those gaps are
documented rather than hidden. Support would be used to improve tested security boundaries,
release discipline, contributor experience, accessibility, and low-bandwidth evidence.

**Alternative B — 334 characters**

African constraints—costly data, intermittent connectivity, affordable devices,
localization, and community-led trust—shape the design, but the modules are intended to be
reusable globally. The repository excludes production Ebbli data and proprietary logic.
Consequential moderation, verification, and AI outputs retain human review.

## Submission checklist

- All CI and database checks are green on a public pull request.
- Evidence-table claims marked unsafe are excluded or resolved.
- No adoption, contributor, star, fork, download, deployment, or pilot metric is guessed.
- The maintainer supplies private identity/organization fields.
- The alpha release is published only after explicit approval.
- Each answer is re-counted after any form-field edit.

## Likely objections

- **No adoption:** accurate; obtain an independent installation or pilot before submission.
- **Minimal UI:** schema/domain and security infrastructure are the current contribution.
- **One maintainer:** Codex directly reduces review, triage, test, release, and docs burden.
- **Security maturity:** automated boundaries exist; independent review remains pending.
- **No release:** prepare and validate the alpha, then publish only with approval.
