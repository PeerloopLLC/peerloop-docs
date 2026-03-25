# Format Rules: Learnings & Decisions

Shared reference for the learn-decide agent. Defines file templates, topic routing, and decision criteria.

---

## Topics (Priority Areas)

Scan for learnings and decisions in these topics first, but also capture **any others** with appropriate topic names.

### Code Topics (→ docs/DECISIONS.md)

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

### Docs-Repo Topics (→ DOC-DECISIONS.md)

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
| D1, database | `docs/reference/cloudflare.md` |
| Stripe, payments | `docs/reference/stripe.md` |
| Auth, sessions | `docs/reference/auth-libraries.md` |
| Stream.io, feeds | `docs/reference/stream.md` |
| Video | `docs/reference/bigbluebutton.md`, `docs/reference/plugnmeet.md` |
| Astro | `docs/reference/astrojs.md` |
| Machine-specific | `docs/as-designed/devcomputers.md` |
| New pattern | `docs/reference/DEVELOPMENT-GUIDE.md` |
| Code architecture | `docs/DECISIONS.md` |
| Docs-repo workflow | `DOC-DECISIONS.md` |

---

## Learnings File Template

**Filename:** `{FILENAME} Learnings.md`

**What to capture:** Insights, discoveries, patterns, gotchas — problems encountered and solved, unexpected behaviors, patterns that worked well, caveats to remember.

```markdown
# Conv Learnings - YYYY-MM-DD

## 1. Descriptive Title
**Topics:** topic1, topic2

**Context:** What situation led to this

**Learning:** The key insight

**Pattern:** (optional)
Code or reusable approach

---

## 2. Another Learning
...
```

If no learnings exist, create a minimal file: `# Conv Learnings - YYYY-MM-DD\n\nNo learnings identified this conv.`

---

## Decisions File Template

**Filename:** `{FILENAME} Decisions.md`

**What to capture:** Choices made between alternatives — options presented and chosen, "should we do X or Y?" discussions, architecture/design choices, trade-off discussions that reached a conclusion.

```markdown
# Conv Decisions - YYYY-MM-DD

## 1. Brief Decision Title
**Type:** Strategic | Implementation
**Topics:** topic1, topic2

**Trigger:** What prompted this decision

**Options Considered:**
1. Option A description
2. Option B description ← Chosen
3. Option C description

**Decision:** Clear statement of what was decided

**Rationale:** Why this option was chosen

**Consequences:** What changed as a result

---

## 2. Another Decision
...
```

If no decisions exist, skip creating this file entirely.

### Decision Types

| Type | Description |
|------|-------------|
| Strategic | Project direction, workflow, architecture |
| Implementation | Technical choices, API design, library selection |

---

## Decision Routing

When a decision is **important**, also add it to the correct file based on topic.

### → docs/DECISIONS.md (Code Topics)

Decisions about the Peerloop application: schema, API design, UI patterns, technology selection, component architecture, testing strategy.

### → DOC-DECISIONS.md (Docs-Repo Topics)

Decisions about the docs repo itself: organization, CC workflow, Obsidian vault, session conventions, dual-repo patterns, skill behavior.

### Important Decision Criteria

| Criterion | Example |
|-----------|---------|
| **Thwarted by conditions** | Planned approach blocked by platform/library limitations |
| **Architecture choice** | How systems connect, data flow patterns |
| **Code style/convention** | Naming patterns, file organization |
| **Technology selection** | Choosing between libraries, services, or approaches |
| **Breaking change** | Decision that affects existing code or requires migration |

### Entry Format (Same for Both Files)

```markdown
### [Brief Title]
**Date:** YYYY-MM-DD

[Clear statement of the decision]

**Rationale:** [Why this was chosen]
```

**Remember:** Update "Last Updated" date at top of whichever file is modified.

---

## Insight Capture

Scan for **durable, informative insights** worth preserving. An insight qualifies if it connects a decision to broader professional context or would teach someone starting a similar project. Append to the relevant decision entry as:

```markdown
> **Insight:** [text]
```
