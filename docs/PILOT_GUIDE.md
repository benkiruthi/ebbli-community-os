# Pilot guide

A pilot evaluates the early-alpha system; it is not a production endorsement.

## Supported evaluation

Use synthetic data to inspect local setup, profiles, communities, memberships, moderated
posts, events, reports, verification states, appeals, audit records, and AI-safety rules.
The current UI does not expose most workflows, so database-level evaluation is expected.

## Excluded

Do not use real identity evidence, children’s data, health/financial records, payments,
emergency response, production credentials, or consequential eligibility decisions. File
uploads, malware scanning, provider delivery, operational monitoring, and recovery are not
production-ready.

## Responsibilities and metrics

The evaluator is responsible for lawful data handling, access control, consent, retention,
and incident response. Measure clean-install success, time to first validation, failed
steps, policy-test results, accessibility findings, throttled-network behavior, contributor
clarity, and whether one bounded workflow meets a real need.

Exit when the agreed evaluation is complete, a material security/privacy concern appears,
or the organization cannot operate within the exclusions. Remove test data and provide
feedback using an issue that contains no sensitive information.
