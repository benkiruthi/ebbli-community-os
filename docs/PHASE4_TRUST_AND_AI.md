# Phase 4 — Trust, verification, appeals, and responsible AI

Phase 4 adds reusable trust infrastructure without turning a score or an AI model into the final authority over a person.

## Verification workflow

Verification requests move through explicit states: draft, submitted, under review, approved, rejected, expired, or revoked.

Evidence is stored by reference and is visible only to the requester and authorized reviewers. Deployments should use a private storage bucket, short-lived signed URLs, malware scanning, retention limits, and redaction before sharing evidence with additional reviewers.

Approval is a human decision. AI may summarize evidence or highlight missing fields, but it may not approve, reject, expire, or revoke a verification.

## Trust signals

Trust signals are explainable records with a source, weight, and human-readable explanation. The derived profile summary is intentionally bounded and should never be presented as a measure of human worth.

Recommended interface rules:

- Show the reasons behind a badge or summary.
- Distinguish identity verification from reliability signals.
- Never expose negative raw signals publicly.
- Allow members to challenge incorrect signals.
- Recalculate and expire stale signals where appropriate.
- Do not use the score as the sole basis for access to aid, work, education, housing, healthcare, or other essential opportunities.

## Appeals

Members can appeal moderation actions. The reviewer should not be the original decision-maker when practical. Every decision must include a reason and remain auditable.

AI may organize an appeal, summarize the record, or identify policy sections. It may not uphold or overturn an appeal.

## AI-assisted navigation

AI assistance is limited to supportive tasks such as:

- explaining how the platform works;
- translating or simplifying content;
- suggesting relevant communities, events, or public resources;
- summarizing long discussions;
- helping members improve a draft before submission.

Every recorded AI run includes its purpose, model and prompt versions, risk level, confidence when available, safety flags, uncertainty text, and human-review state.

## Human-review boundaries

Human review is mandatory when an output could:

- affect verification or moderation;
- affect access to money or essential services;
- expose or infer sensitive personal data;
- respond to a possible immediate safety concern;
- make claims that cannot be adequately supported;
- materially damage a person's reputation or opportunities.

Critical and high-risk outputs must not auto-publish.

## Safety evaluation

Before release, deployments should test:

1. False accusations and coordinated reporting.
2. Attempts to forge or reuse verification evidence.
3. Bias across names, languages, regions, gender, disability, and income groups.
4. Prompt injection inside posts and uploaded evidence.
5. Low-confidence recommendations presented too strongly.
6. Attempts to infer protected or sensitive traits.
7. Moderator conflicts of interest and appeal independence.
8. Data retention, deletion, and access-log behavior.

## Privacy and retention

Store the minimum evidence needed. Do not send identity documents to a model unless the deployment has an explicit lawful basis, informed consent, appropriate vendor terms, and a documented retention policy. Prefer deterministic validation and trained human reviewers for identity evidence.

The open-source project provides infrastructure and boundaries, not legal certification. Deployers remain responsible for applicable privacy, child-safety, consumer-protection, employment, financial, and identity-verification requirements.
