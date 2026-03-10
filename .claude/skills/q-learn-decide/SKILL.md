---
name: q-learn-decide
description: Document session learnings and decisions
argument-hint: ""
allowed-tools: Read, Write, Edit, Bash, Glob
---

# Document Session Learnings & Decisions

**Purpose:** Capture insights and choices from a development session into two structured files.

---

## Project Config

!`cat .claude/config.json 2>/dev/null || echo "(no config.json found — using defaults)"`

**Used from config:**
- `paths.sessions` — output directory (default: `docs/sessions/`)

### Session Number

!`grep '^## Session' SESSION-INDEX.md 2>/dev/null | tail -1 | sed 's/## /Current: **/' | sed 's/$/**/' || echo "(session number unavailable — check SESSION-INDEX.md)"`

### Existing Session Files This Month

!`MONTH=$(date '+%Y-%m'); find docs/sessions/$MONTH \( -name '*Learnings.md' -o -name '*Decisions.md' \) 2>/dev/null | sort | tail -10 | sed 's|^|- |' || echo "- (none yet this month)"`

---

## Progress Tracking

**When called from `/q-end-session`:** Update the existing "Create Learnings.md" and "Create Decisions.md" items when complete.

**When called standalone:** Add these items to TodoWrite before starting:
- Scan session for learnings
- Create Learnings.md
- Scan session for decisions
- Create Decisions.md (if any)
- Check for Important decisions → DECISIONS.md / PLAYBOOK.md

Mark each `in_progress` when starting, `completed` when done.

---

## Execution Flow

1. **Get current timestamp:**
   - If `$ARGUMENTS` contains two values (MONTH FILENAME), use them directly
   - Otherwise, run these bash commands:
     ```bash
     date '+%Y-%m'              # MONTH (for directory)
     date '+%Y%m%d_%H%M'        # FILENAME (compact, no hyphens)
     ```

2. **Scan session** for learnings and decisions

3. **Create files** in `{paths.sessions}/{MONTH}/`:
   - `{FILENAME} Learnings.md`
   - `{FILENAME} Decisions.md` (skip if no decisions)

4. **Check Important decisions** — route to DECISIONS.md or PLAYBOOK.md (see Decision Routing below)

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
| Cloudflare, edge | `docs/vendors/cloudflare.md` |
| Auth, sessions | `docs/vendors/auth-libraries.md` |
| Stream.io, feeds | `docs/vendors/stream.md` |
| Video, sessions | `docs/vendors/bigbluebutton.md`, `docs/vendors/plugnmeet.md` |
| Astro | `docs/vendors/astrojs.md` |
| Tailwind | `docs/vendors/tailwindcss.md` |
| Machine-specific | `docs/architecture/devcomputers.md` |
| Dev environment | `docs/architecture/dev-setup.md` |
| New pattern | `docs/reference/DEVELOPMENT-GUIDE.md` |
| API discovery | `docs/reference/API-REFERENCE.md` |
| Test approach | `docs/reference/CLI-TESTING.md` |
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

**Topic assignment:**
- Use listed topics when applicable
- Create new topic names for unlisted areas
- All learnings are important — don't skip unlisted ones

**File format:** `{FILENAME} Learnings.md`

```markdown
# Session Learnings - YYYY-MM-DD

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
- "Let's go with..." or "I prefer..." statements
- Architecture/design choices
- Trade-off discussions that reached a conclusion
- TodoWrite `[DECISION:*]` items (if any)

**Topic assignment:**
- Use listed topics when applicable
- Create new topic names for unlisted areas
- **All decisions are important** — don't skip decisions just because they don't match a listed topic

**File format:** `{FILENAME} Decisions.md`

```markdown
# Session Decisions - YYYY-MM-DD

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

## Writing Guidelines

### For Learnings:
1. **Number**: Sequential (1, 2, 3...)
2. **Title**: Descriptive (e.g., "Vitest runIf() Evaluates at Parse Time")
3. **Topics**: Tag with relevant areas
4. **Context**: Brief setup
5. **Learning**: The insight
6. **Pattern**: Optional code/approach
7. **Separator**: `---` after each (except last)

### For Decisions:
1. **Number**: Sequential (1, 2, 3...)
2. **Title**: Brief decision summary
3. **Type**: Strategic or Implementation
4. **Topics**: Tag with relevant areas
5. **Trigger**: What prompted it
6. **Options**: List alternatives, mark chosen with ← Chosen
7. **Decision**: Clear statement
8. **Rationale**: Why
9. **Consequences**: What changed
10. **Separator**: `---` after each (except last)

---

## Decision Routing

**CRITICAL:** When identifying an Important decision, route it to the correct file based on topic.

### → docs/DECISIONS.md (Code Topics)

Decisions about the Peerloop application: schema, API design, UI patterns, technology selection, component architecture, testing strategy.

**Current sections:**
!`grep '^## [0-9]' docs/DECISIONS.md 2>/dev/null | sed 's/^## /- /' || echo "- (unable to read sections — read docs/DECISIONS.md manually)"`

### → PLAYBOOK.md (Docs-Repo Topics)

Decisions about the docs repo itself: organization, CC workflow, Obsidian vault, session conventions, dual-repo patterns, skill behavior.

**Current sections:**
!`grep '^## [0-9]' PLAYBOOK.md 2>/dev/null | sed 's/^## /- /' || echo "- (unable to read sections — read PLAYBOOK.md manually)"`

### Important Decision Criteria

| Criterion | Example |
|-----------|---------|
| **Thwarted by conditions** | Planned approach blocked by platform/library limitations, had to pivot |
| **Architecture choice** | How systems connect, data flow patterns, component structure |
| **Code style/convention** | Naming patterns, file organization, coding standards |
| **Technology selection** | Choosing between libraries, services, or approaches |
| **Breaking change** | Decision that affects existing code or requires migration |

### When Uncertain

If a decision doesn't clearly fit the criteria but seems significant, ask:
> "Should this decision be added to DECISIONS.md or PLAYBOOK.md? [Brief description]"

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

During processing, also scan the session's `★ Insight` blocks for **durable, informative insights** worth preserving.

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

Append qualifying insights to the **relevant decision entry** in docs/DECISIONS.md or PLAYBOOK.md as an `> **Insight:**` block quote:

```markdown
### Two-Vault Architecture: Personal vs Project
**Date:** 2026-02-21 (Session 233)

[... decision content ...]

> **Insight:** The access-control boundaries (client-visible vs personal, git-backed vs sync-backed) are real and non-negotiable. The cleanest architectures respect those boundaries rather than trying to abstract over them. (Session 233)
```

This keeps the insight co-located with the decision it illuminates, rather than in a separate file.

---

## Confirmation

Display:
```
Created: docs/sessions/{MONTH}/{FILENAME} Learnings.md
  Learnings: {count}
  Topics: {topics used}
  New topics: {any created - consider adding to topics list}

Created: docs/sessions/{MONTH}/{FILENAME} Decisions.md
  Decisions: {count}
  Types: {Strategic: N, Implementation: N}
  Topics: {topics used}
  New topics: {any created - consider adding to topics list}
```

If no decisions found, note "No decisions identified this session" and skip Decisions file.
