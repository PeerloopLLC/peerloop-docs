---
description: Project-specific learnings and decisions configuration
argument-hint: ""
---

# Peerloop Learnings & Decisions Config

**Extends:** `/q-learn-decide`

**Configuration** (paths) comes from `.claude/config.json`.

This file defines Peerloop-specific topics for categorizing learnings and decisions.

---

## Topics (Priority Areas)

These are the key areas for this project. The skill scans for learnings and decisions in these topics first, but will also capture **any others** with appropriate topic names.

| Topic | Scan For |
|-------|----------|
| `d1` | Cloudflare D1, SQLite, migrations, query patterns, local vs remote |
| `stripe` | Payments, Connect, webhooks, payouts, test vs live mode |
| `cloudflare` | Workers, Pages, R2, edge runtime, deployment |
| `auth` | JWT, sessions, OAuth, permissions, cookies |
| `stream` | Stream.io feeds, activities, notifications |
| `video` | PlugNmeet, BigBlueButton, video sessions, recordings |
| `astro` | Astro.js, islands, SSR/SSG, components, routing |
| `workflow` | Process, tooling, session management, skills |
| `testing` | Vitest, Playwright, test patterns, CI |
| `deployment` | Build, deploy, CI/CD, environment differences |

If a learning or decision uses a topic not listed above, consider adding it here if it recurs.

### Cross-Cutting Topics

Items often span multiple topics. Tag with all relevant areas:

- **d1, cloudflare**: D1 local emulation, macOS version requirements
- **stripe, auth**: Webhook signature verification
- **astro, d1**: Server-side data fetching patterns
- **workflow, testing**: CI environment detection

### Related Documentation

When documenting, consider if items should also update:

| If item involves... | Consider updating... |
|---------------------|---------------------|
| D1, database | `docs/tech/tech-011-cloudflare.md` |
| Stripe, payments | `docs/tech/tech-003-stripe.md` |
| Cloudflare, edge | `docs/tech/tech-011-cloudflare.md` |
| Auth, sessions | `docs/tech/tech-010-auth-libraries.md` |
| Stream.io, feeds | `docs/tech/tech-002-stream.md` |
| Video, sessions | `docs/tech/tech-001-bigbluebutton.md`, `tech-006-plugnmeet.md` |
| Astro | `docs/tech/tech-016-astrojs.md` |
| Tailwind | `docs/tech/tech-005-tailwindcss.md` |
| Machine-specific | `docs/tech/tech-013-devcomputers.md` |
| Dev environment | `docs/tech/tech-015-dev-setup.md` |
| New pattern | `docs/reference/DEVELOPMENT-GUIDE.md` |
| API discovery | `docs/reference/API-REFERENCE.md` |
| Test approach | `docs/reference/CLI-TESTING.md` |
| Architecture decision | `BEST-PRACTICES.md` or `DECISIONS.md` |

---

## DECISIONS.md Format (Peerloop-Specific)

When the global skill determines a decision is Important, use this format for Peerloop's `DECISIONS.md`:

**Sections:** Numbered 1-10 by category (Architecture, Database, API, Auth, UI/UX, Testing, Workflow, Deployment, Feature Flags, Admin)

**Entry format:**
```markdown
### [Brief Title]
**Date:** YYYY-MM-DD

[Clear statement of the decision]

**Rationale:** [Why this was chosen]

**See:** [Optional: reference to code or docs]
```

**Remember:** Update "Last Updated" date at top of file.
