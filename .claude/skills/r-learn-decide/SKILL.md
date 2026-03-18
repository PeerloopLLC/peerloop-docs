---
name: r-learn-decide
description: Document conv learnings and decisions
argument-hint: "[MONTH FILENAME] - optional: 2026-03 20260317_1400"
allowed-tools: Read, Write, Edit, Bash, Glob
---

# Document Conv Learnings & Decisions

**Purpose:** Capture insights and choices from a development conversation into two structured files.

---

## Pre-computed Context

**Existing conv files this month:**
!`$CLAUDE_PROJECT_DIR/.claude/scripts/conv-files-learn-decide.sh`

---

## Execution Flow

1. **Get current timestamp:**
   - If `$ARGUMENTS` contains two values (MONTH FILENAME), use them directly
   - Otherwise, run these bash commands:
     ```bash
     date '+%Y-%m'              # MONTH (for directory)
     date '+%Y%m%d_%H%M'        # FILENAME (compact)
     ```

2. **Scan conversation** for learnings and decisions

3. **Create files** in `docs/sessions/{MONTH}/`:
   - `{FILENAME} Learnings.md`
   - `{FILENAME} Decisions.md` (skip if no decisions)

4. **Check Important decisions** — route to docs/DECISIONS.md or PLAYBOOK.md (see Decision Routing below)

5. **Check Insight Capture** — append durable insights to relevant decision entries

6. **Confirm creation** (see Confirmation below)

---

## Topics (Priority Areas)

These are the key areas for this project. Scan for learnings and decisions in these topics first, but also capture **any others** with appropriate topic names.

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
| D1, database | `docs/vendors/cloudflare.md` |
| Stripe, payments | `docs/vendors/stripe.md` |
| Auth, sessions | `docs/vendors/auth-libraries.md` |
| Stream.io, feeds | `docs/vendors/stream.md` |
| Video | `docs/vendors/bigbluebutton.md`, `docs/vendors/plugnmeet.md` |
| Astro | `docs/vendors/astrojs.md` |
| Machine-specific | `docs/architecture/devcomputers.md` |
| New pattern | `docs/reference/DEVELOPMENT-GUIDE.md` |
| Code architecture | `docs/DECISIONS.md` |
| Docs-repo workflow | `PLAYBOOK.md` |

---

## Part 1: Learnings

**What to capture:** Insights, discoveries, patterns, gotchas

**Scan for:**
- Problems encountered and how they were solved
- Unexpected behaviors discovered
- Patterns or approaches that worked well
- Gotchas or caveats to remember

**File format:** `{FILENAME} Learnings.md`

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

---

## Part 2: Decisions

**What to capture:** Choices made between alternatives

**Scan for:**
- Options presented and which was chosen
- "Should we do X or Y?" discussions
- Architecture/design choices
- Trade-off discussions that reached a conclusion

**File format:** `{FILENAME} Decisions.md`

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

### Decision Types

| Type | Description |
|------|-------------|
| Strategic | Project direction, workflow, architecture |
| Implementation | Technical choices, API design, library selection |

---

## Decision Routing

**When a decision is important**, also add it to the correct file based on topic.

### → docs/DECISIONS.md (Code Topics)

Decisions about the Peerloop application: schema, API design, UI patterns, technology selection, component architecture, testing strategy.

### → PLAYBOOK.md (Docs-Repo Topics)

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

During processing, scan for **durable, informative insights** worth preserving. An insight qualifies if it connects a decision to broader professional context or would teach someone starting a similar project. Append to the relevant decision entry as `> **Insight:**` blockquotes.

---

## Confirmation

Display:
```
Created: docs/sessions/{MONTH}/{FILENAME} Learnings.md
  Learnings: {count}
  Topics: {topics used}

Created: docs/sessions/{MONTH}/{FILENAME} Decisions.md
  Decisions: {count}
  Types: {Strategic: N, Implementation: N}
  Topics: {topics used}
```

If no decisions found, note "No decisions identified this conv" and skip Decisions file.
