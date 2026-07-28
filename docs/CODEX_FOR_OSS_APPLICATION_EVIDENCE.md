# Codex for Open Source application evidence

| Claim                | Evidence                                           | Verification              | Status                      | Safe?                      | Notes                              |
| -------------------- | -------------------------------------------------- | ------------------------- | --------------------------- | -------------------------- | ---------------------------------- |
| Public repository    | `https://github.com/benkiruthi/ebbli-community-os` | Open signed out           | Verifiable                  | Yes                        | Confirm at submission              |
| Apache 2.0           | `LICENSE`                                          | Read license              | Verifiable                  | Yes                        | Unchanged                          |
| Primary maintainer   | `docs/MAINTAINERS.md` and Git history              | Inspect commits/ownership | Verifiable                  | Yes                        | One maintainer                     |
| Project stage        | `README.md`, `docs/FEATURE_STATUS.md`              | Cross-check code          | Early alpha                 | Yes                        | Schema-first                       |
| Fresh build          | `docs/VALIDATION.md` and PR CI                     | Run command/check         | Pending final rerun         | No, until green            | Never infer from old run           |
| Clean migrations     | `supabase/migrations`, CI database job             | Reset local DB            | Pending final rerun         | No, until green            | Four unique migrations             |
| RLS tests            | `supabase/tests/database`                          | `pnpm test:db`            | Implemented                 | No, until green            | Partial coverage                   |
| CI                   | `.github/workflows/ci.yml`                         | GitHub checks             | Configured                  | No, until public green run | Includes database                  |
| Release              | `docs/RELEASE_PROCESS.md`                          | Git tags/releases         | Draft only                  | No                         | No tag                             |
| Issues/triage        | Templates and public issue history                 | GitHub                    | Process configured          | Limited                    | Do not imply volume                |
| PR reviews           | GitHub PR history                                  | GitHub                    | Not yet demonstrated        | No                         | This branch can establish workflow |
| Contributor count    | GitHub contributors                                | GitHub                    | Not recorded here           | No                         | Use live verifiable value only     |
| Stars/forks          | GitHub metadata                                    | GitHub                    | Not recorded here           | No                         | Use live values only if asked      |
| Downloads            | Package/release metrics                            | Provider                  | Not available               | No                         | No published package               |
| Deployments          | `docs/ADOPTION.md`                                 | Public URL                | Not available               | No                         | No public demo                     |
| Pilots               | `docs/ADOPTION.md`                                 | Consented evidence        | Not available               | No                         | Intended only                      |
| Security process     | `SECURITY.md`, `docs/THREAT_MODEL.md`              | Inspect/test              | Implemented, review pending | Yes, qualified             | Not independently audited          |
| Responsible AI       | `docs/RESPONSIBLE_AI.md`, core tests               | Run tests                 | Implemented boundary        | Yes, qualified             | No provider integration            |
| Ecosystem importance | `docs/VISION.md`, architecture                     | Inspect reusable modules  | Credible rationale          | Yes                        | Not adoption                       |
| Intended Codex use   | Application draft                                  | Review specificity        | Documented                  | Yes                        | Maintainer workflow                |

Unavailable evidence must remain “not available” until independently verifiable.
