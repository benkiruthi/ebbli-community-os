# Feature status

Status terms: **implemented** means code/schema exists; **validated** means an automated or
recorded local check exists; **review pending** means no independent security assessment;
**unreleased** means there is no tagged release containing the work.

| Module                      | Design    | Schema        | RLS           | Domain/API          | UI                      | Tests                      | Security review | Docs        | Release    | Known limitations               |
| --------------------------- | --------- | ------------- | ------------- | ------------------- | ----------------------- | -------------------------- | --------------- | ----------- | ---------- | ------------------------------- |
| Authentication/profiles     | Defined   | Implemented   | Implemented   | Browser client only | None                    | Structural RLS             | Pending         | Partial     | Unreleased | No auth UI                      |
| Communities/memberships     | Defined   | Implemented   | Implemented   | Types only          | None                    | Core boundaries            | Pending         | Partial     | Unreleased | No management flow              |
| Needs/opportunities         | Defined   | Implemented   | Implemented   | Types only          | None                    | Ownership/review           | Pending         | Yes         | Unreleased | No CRUD UI                      |
| Evidence attachments        | Defined   | Metadata only | Metadata RLS  | None                | None                    | Access model partial       | Pending         | Yes         | Unreleased | No Storage policies or scanning |
| Events/attendance           | Defined   | Implemented   | Implemented   | Types only          | None                    | Integrity partial          | Pending         | Yes         | Unreleased | No UI                           |
| Comments                    | Defined   | Implemented   | Implemented   | Types only          | None                    | Integrity partial          | Pending         | Yes         | Unreleased | No UI                           |
| Notifications               | Defined   | Implemented   | Implemented   | Types only          | None                    | Privacy policy structural  | Pending         | Yes         | Unreleased | No delivery provider            |
| Reporting/moderation        | Defined   | Implemented   | Implemented   | None                | None                    | Moderator boundary partial | Pending         | Yes         | Unreleased | No moderation UI                |
| Moderation audit log        | Defined   | Implemented   | Read-only RLS | Trigger only        | None                    | Append/read boundary       | Pending         | Yes         | Unreleased | Limited event coverage          |
| Verification workflows      | Defined   | Implemented   | Implemented   | Core types          | None                    | Self-approval denied       | Pending         | Yes         | Unreleased | No reviewer UI                  |
| Trust summaries             | Defined   | Implemented   | Public read   | Core types          | None                    | Privileged execution check | Pending         | Yes         | Unreleased | Scoring requires review         |
| Appeals                     | Defined   | Implemented   | Implemented   | Core types          | None                    | Integrity partial          | Pending         | Yes         | Unreleased | Assignment workflow missing     |
| AI-assistance audit records | Defined   | Implemented   | Read-only     | Safety engine       | None                    | Unit tests                 | Pending         | Yes         | Unreleased | No AI provider                  |
| AI safety classification    | Defined   | N/A           | N/A           | Implemented         | None                    | Unit tests                 | Pending         | Yes         | Unreleased | Deterministic policy only       |
| Localization                | Principle | None          | N/A           | None                | None                    | None                       | Pending         | Partial     | Unreleased | English only                    |
| Low-bandwidth support       | Principle | N/A           | N/A           | None                | Responsive landing page | None                       | Pending         | Partial     | Unreleased | No benchmark/offline mode       |
| Accessibility               | Principle | N/A           | N/A           | None                | Semantic landing page   | None                       | Pending         | Partial     | Unreleased | No independent audit            |
| Reference deployments       | Planned   | N/A           | N/A           | N/A                 | None                    | None                       | Pending         | Pilot guide | Unreleased | No public deployment            |
