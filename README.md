# Ebbli Community OS

**The open-source operating system for trusted, mobile-first digital communities.**

Ebbli Community OS is a reusable foundation for building community platforms that help people find the right people, opportunities, support, learning, and pathways to progress.

It is designed first for African contexts, mobile devices, low-bandwidth environments, and organizations that need practical community infrastructure without building everything from scratch.

## Vision

Ebbli Community OS aims to become reusable infrastructure for:

- community networks;
- needs and opportunity boards;
- learning and mentoring communities;
- churches, schools, alumni and family networks;
- business and professional communities;
- nonprofit and civic programs;
- trusted member directories;
- responsible AI-assisted community navigation.

The commercial Ebbli platform may build on this foundation, while private production data, proprietary business logic, payments, and sensitive matching systems remain outside this repository.

## Principles

1. **Community before technology** — technology should strengthen human relationships rather than replace them.
2. **Mobile first** — core workflows must work well on affordable phones and unstable connections.
3. **Trust by design** — verification, moderation, privacy, and clear accountability are core infrastructure.
4. **Responsible AI** — AI should assist human judgment, expose uncertainty, and avoid high-impact autonomous decisions.
5. **Reusable infrastructure** — modules should be useful beyond a single Ebbli product.
6. **African context, global usefulness** — design for African realities while keeping the framework adaptable elsewhere.

## Planned modules

- Authentication and member profiles
- Communities and membership
- Needs and opportunities
- Events
- Learning and mentoring
- Messaging and notifications
- Moderation and reporting
- Verification and evidence workflows
- Responsible AI assistant interfaces
- Supabase schema and Row Level Security examples
- Mobile-first React components
- Localization and low-bandwidth support

## Project status

This repository is currently in **Phase 1: open-source foundation**. The architecture and modules are being defined before production code is extracted or introduced.

Do not treat the repository as production-ready yet.

## Proposed technology direction

- Next.js
- React
- TypeScript
- Tailwind CSS
- Supabase
- PostgreSQL
- OpenAI-compatible AI interfaces
- Resend-compatible email interfaces

The architecture should remain modular so contributors can replace providers where practical.

## Repository structure

```text
docs/                     Project vision and technical decisions
.github/                  Contribution and issue templates
apps/                     Reference applications (planned)
packages/                 Reusable modules (planned)
examples/                 Example implementations (planned)
```

## Getting started

The application workspace has not yet been initialized. For now:

```bash
git clone https://github.com/benkiruthi/ebbli-community-os.git
cd ebbli-community-os
```

Read:

- [Vision](docs/VISION.md)
- [Architecture](docs/ARCHITECTURE.md)
- [Responsible AI](docs/RESPONSIBLE_AI.md)
- [Governance](docs/GOVERNANCE.md)
- [Roadmap](ROADMAP.md)
- [Contributing](CONTRIBUTING.md)

## Contributing

Contributions are welcome from developers, designers, researchers, community builders, nonprofits, schools, churches, and civic organizations.

Before contributing, read [CONTRIBUTING.md](CONTRIBUTING.md) and the [Code of Conduct](CODE_OF_CONDUCT.md).

Strong early contribution areas include:

- architecture feedback;
- documentation;
- accessibility;
- low-bandwidth performance;
- localization and African language support;
- moderation and trust systems;
- Supabase security patterns;
- testing strategy.

## Security

Do not publish vulnerabilities or sensitive information in public issues. Follow [SECURITY.md](SECURITY.md).

## License

Licensed under the [Apache License 2.0](LICENSE).

## Maintainer

Initiated and maintained by [Ben Kiruthi](https://github.com/benkiruthi), Nairobi, Kenya.
