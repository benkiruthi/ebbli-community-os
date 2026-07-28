# Changelog

All notable changes to Ebbli Community OS will be documented here.

The project follows the spirit of Keep a Changelog and will adopt Semantic Versioning when packaged releases begin.

## [Unreleased]

## [0.2.0-alpha.1] — 2026-07-28

### Added

- Open-source readiness audit, feature matrix, threat model, validation, pilot, release,
  adoption, maintainer, reviewer, and application-evidence documentation
- Executable `@ebbli/core` workspace package
- Migration uniqueness check and pgTAP database/RLS tests
- CI database validation, dependency review, CodeQL, and Dependabot
- Forward migration protecting workflow integrity and privileged function execution
- Project vision and positioning
- Apache 2.0 license
- Contribution guide
- Code of Conduct
- Security policy
- Roadmap
- Responsible AI principles
- Architecture principles
- Governance documentation
- GitHub issue and pull request templates

### Changed

- Rewrote the README to distinguish schema/domain implementation from UI, review, release,
  and production readiness
- Switched CI installation to the frozen lockfile

### Upgrade notes

- This is the first packaged prerelease; there is no supported in-place upgrade from an
  earlier tagged deployment.
- Database migrations are forward-only. Back up an existing database before applying them;
  rollback requires a corrective migration or database restore.

### Known limitations

- The web UI is a foundation rather than a complete reference product.
- Secure object-storage workflows and a public reference deployment are not included.
- Independent installation and pilot evidence are still being gathered in issue #7.
- This prerelease is not a production certification.

## [0.1.0] — Foundation

Initial open-source project foundation.
