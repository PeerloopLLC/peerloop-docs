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

### Code Topics (→ DECISIONS.md)

| Topic | Scan For |
|-------|----------|
| `d1` | Cloudflare D1, SQLite, migrations, query patterns, local vs remote |
| `stripe` | Payments, Connect, webhooks, payouts, test vs live mode |
| `cloudflare` | Workers, Pages, R2, edge runtime, deployment |
| `auth` | JWT, sessions, OAuth, permissions, cookies |
| `stream` | Stream.io feeds, activities, notifications |
| `video` | PlugNmeet, BigBlueButton, video sessions, recordings |
| `astro` | Astro.js, islands, SSR/SSG, components, routing |
| `testing` | Vitest, Playwright, test patterns, CI |
| `deployment` | Build, deploy, CI/CD, environment differences |

### Docs-Repo Topics (→ PLAYBOOK.md)

| Topic | Scan For |
|-------|----------|
| `docs-infra` | Repo organization, folder structure, file conventions, what goes where |
| `dual-repo` | Cross-repo workflow, symlinks, launch pattern, commit conventions |
| `cc-workflow` | Claude Code hooks, skills, config, permissions, session management |
| `obsidian` | Vault setup, plugins, Obsidian configuration, linking conventions |

### Shared Topic

| Topic | Scan For | Routes To |
|-------|----------|-----------|
| `workflow` | Process, tooling, conventions that span both repos | Decide per item |

If a learning or decision uses a topic not listed above, consider adding it here if it recurs.

### Cross-Cutting Topics

Items often span multiple topics. Tag with all relevant areas:

- **d1, cloudflare**: D1 local emulation, macOS version requirements
- **stripe, auth**: Webhook signature verification
- **astro, d1**: Server-side data fetching patterns
- **cc-workflow, dual-repo**: Hook paths, $CLAUDE_PROJECT_DIR behavior
- **docs-infra, obsidian**: Vault folder structure, gitignore decisions

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
| Code architecture | `DECISIONS.md` |
| Docs-repo workflow | `PLAYBOOK.md` |

---

## Decision Routing

**CRITICAL:** When the global skill identifies an Important decision, route it to the correct file based on topic:

### → DECISIONS.md (Code Topics)

Decisions about the Peerloop application: schema, API design, UI patterns, technology selection, component architecture, testing strategy.

**Sections:** Numbered 1-10 by category (Architecture, Database, API, Auth, UI/UX, Testing, Workflow, Deployment, Feature Flags, Admin)

### → PLAYBOOK.md (Docs-Repo Topics)

Decisions about the docs repo itself: organization, CC workflow, Obsidian vault, session conventions, dual-repo patterns, skill behavior.

**Sections:** Numbered 1-5 by category (Repo Architecture, Folder Structure, Claude Code Workflow, Obsidian Vault, Documentation Conventions)

### Entry Format (Same for Both Files)

```markdown
### [Brief Title]
**Date:** YYYY-MM-DD (Session NNN)

[Clear statement of the decision]

**Rationale:** [Why this was chosen]

**See:** [Optional: reference to code or docs]
```

For significant decisions, include the full format:

```markdown
### [Brief Title]
**Date:** YYYY-MM-DD (Session NNN)

[Clear statement of the decision]

**Trigger:** [What prompted this decision]

**Options Considered:**
1. Option A
2. Option B ← Chosen
3. Option C

**Rationale:** [Why this was chosen]

**Consequence:** [What changed as a result]
```

**Remember:** Update "Last Updated" date at top of whichever file is modified.

---

## Insight Capture

During `/q-learn-decide` processing, also scan the session's `★ Insight` blocks for **durable, informative insights** worth preserving.

### What Qualifies

An insight is durable if it:
- Connects a project-specific decision to **broader professional context** (how others solve the same problem, why this pattern exists in the industry)
- Explains **why a convention works well** beyond the immediate rationale (not just "we chose X" but "X works because...")
- Would be **useful to someone starting a similar project** — it teaches, not just records

### What Does NOT Qualify

- Restating what was decided (already in the decision entry)
- Generic programming knowledge (obvious to experienced developers)
- Session-specific context that won't matter in a month

### How to Capture

Append qualifying insights to the **relevant decision entry** in DECISIONS.md or PLAYBOOK.md as an `> **Insight:**` block quote:

```markdown
### Two-Vault Architecture: Personal vs Project
**Date:** 2026-02-21 (Session 233)

[... decision content ...]

> **Insight:** The access-control boundaries (client-visible vs personal, git-backed vs sync-backed) are real and non-negotiable. The cleanest architectures respect those boundaries rather than trying to abstract over them. (Session 233)
```

This keeps the insight co-located with the decision it illuminates, rather than in a separate file.
