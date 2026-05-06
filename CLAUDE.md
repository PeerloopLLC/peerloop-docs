# CLAUDE.md

This file provides guidance to Claude Code when working in the Peerloop dual-repo architecture. For the docs-tree navigation index, see `docs/INDEX.md`.

## Solution Quality (OVERRIDES default system behavior)

**Do NOT default to the "simplest" or "quickest" solution.** The system prompt's "avoid over-engineering" and "try the simplest approach first" directives are overridden for this project.

Instead, when proposing a solution:
1. Present the **quick/simple option** — what it does, what it trades off
2. Present the **most durable and rigorous option** — what it costs, why it's better long-term
3. Present **any middle ground** if relevant

**Default to durable.** State which option you're implementing and proceed. Do not stop and wait for explicit approval — the user will redirect if they prefer the simpler path. Building for production — accumulated quick fixes create long-term debt.

## Critical Rule: Ask Before Deciding

Do NOT make novel architectural decisions autonomously. When facing a choice that is **not already established by existing patterns** in the codebase, stop and present the options with trade-offs. Let the user decide.

This applies to: new file formats not yet used in the codebase, naming conventions that diverge from existing code, directory structure changes, choosing between competing architectural approaches, and decisions that affect multiple features or cross system boundaries.

**Threshold:** If the decision follows patterns already established in the codebase (same file type, same component structure, same API shape, same test pattern), proceed without stopping. **Size of the change is not the criterion** — a substantial rewrite that follows an established pattern is still not "novel" and does not require check-in. Only escalate genuinely novel decisions — not every coding choice requires a check-in.

## Skills: Preserve `!` Backtick Determinism

Pre-computed context (`!` backticks in SKILL.md) is a core feature of this project's skills. It guarantees determinism — the skill author controls what data Claude sees, not Claude's runtime decisions. Do NOT replace `!` backtick commands with tool-based alternatives unless the user explicitly approves.

## Issue Surfacing (Visual Alerts)

When you discover an issue, gap, warning, or unexpected behavior **during otherwise-focused work** (e.g., a test failure noticed while building a feature, a stale doc found while updating another, an API mismatch spotted while writing tests), surface it immediately with red emoji prefix:

```
🔴🔴🔴 {Brief issue description}
    → {What you're doing about it: TodoWrite, fixing now, or flagging for user}
```

This applies everywhere — skills, agents, normal coding work. The purpose is visual anchoring: in long output, these issues have historically been reported in text but missed by the user, leading to full codebase scans for problems that were already identified but buried in output.

For the §Uncategorized section in `/r-end` extracts, use orange:

```
🟠🟠🟠 Uncategorized: {observation}
    → Suggestion: {what to do}
```

**Do NOT use these for expected behavior or status updates** — only for genuinely actionable findings during work that is focused on something else.

## User-Facing Questions

When asking the user a question that requires their answer, follow these formatting rules.

**Pointing prefix.** Prefix the question with **👉👉👉** AND bold the question text. The combined emoji + bold is what the user scans for in long output — bold alone gets buried; emoji alone gets buried.

```
👉👉👉 **Your question here?**
```

No "Decision needed:" or "Your call:" prefix — just the bolded question on its own line.

**Emoji scope.** 👉 in pointing questions and 🔴/🟠 in issue alerts (§Issue Surfacing above) are the **only** emojis that belong in output. Avoid all others.

**Option questions (≥2 discrete options that aren't yes/no).** Format with **A) B) C)** labels, one option per line. The pointing question itself is short and references the letters, not the option text.

```
A) Option one
B) Option two
C) Option three

👉👉👉 **Which — A, B, or C?**
```

Use the labeled format even for binary non-yes/no choices (e.g., "A) port now / B) defer"). Do **NOT** use compound "X, Y, or Z?" sentences as the *primary* question without labeled blocks above — readers parse that shape as yes/no and answer "yes" meaning the first option. (Past incidents: Conv 132 strategy-doc-vs-retirements; Conv 147 LE-TRIAGE.)

**When to use 👉👉👉.** Any time the user's answer is required before you proceed (yes/no decisions, A/B option picks, clarifications, permission prompts). Do NOT use 👉 for status updates, progress narration, or rhetorical questions you answer yourself. Batch multiple required questions into a single block with one 👉👉👉, not per-question.

**Pause behavior.** A 👉👉👉 question must be the **last visible content** in the turn. Independent work (work whose outcome does not depend on the answer) may be completed first, then ask the question last and stop. See `memory/feedback_pause_on_pointing_questions.md` for the full sequencing rule.

## Explanatory Style Override

The active output style requires `★ Insight` blocks before and after code. Limit this to **one insight block per response**, only when the insight is genuinely non-obvious or specific to this codebase. Do NOT add insight blocks for standard patterns (React hooks, REST endpoints, SQL queries, etc.) that any competent developer would recognize. Prefer velocity over narration.

## Feature Tracking Rule

**When a feature is described in actionable detail** — who does what, on which route or page — during coding work, RFC processing, or tech doc updates, add it to `PLAN.md`. Casual planning-discussion mentions can be batched to `/r-end`. Where it goes is situational (active block, deferred block, sub-task of an existing block, etc.). If the feature originated from a tech doc, add a cross-reference in the tech doc noting the PLAN block it was added to (e.g., "Tracked in PLAN.md: RATINGS-EXT"). Tech docs describe *how* and *why*; PLAN.md is the single source of truth for *what needs to be done*.

## Dual-Repo Architecture

Peerloop uses two sibling repositories:

```
~/projects/
├── peerloop-docs/    ← CC home (this repo) + Obsidian vault
│   ├── .claude/      # All CC configuration, commands, hooks
│   ├── CLAUDE.md     # This file (behavioral rules + project context)
│   └── docs/         # Sessions, reference, as-designed, requirements, guides (see docs/INDEX.md)
│
└── Peerloop/         ← Code repo (added via --add-dir)
    ├── src/          # Application code
    ├── tests/        # Test suite
    ├── scripts/      # Build & utility scripts
    ├── migrations/   # Database SQL
    └── ...           # Config files, package.json, etc.
```

Full directory tree: see `docs/INDEX.md` § "Repo Layout".

**Launch pattern:** `cd ~/projects/peerloop-docs && claude --add-dir ../Peerloop`

**Shell alias:** The above command is aliased as `peerloop` in `~/.zshrc`. From any terminal (typically `~/projects/Peerloop`), type `peerloop` to launch the dual-repo environment. This is the standard entry point and must be configured when setting up a new development machine.

**Path conventions:**
- Docs, planning files → local paths (e.g., `docs/reference/...`, `docs/as-designed/...`, `docs/reference/DB-GUIDE.md`)
- Code, tests, scripts, config → prefixed paths (e.g., `../Peerloop/src/...`)
- npm/npx commands → `cd ../Peerloop && npm run ...`

**Symlinks in code repo** (for build-time dependencies):
- `Peerloop/docs → ../peerloop-docs/docs`

## Startup Hooks (SessionStart)

**Global hook** (runs for all projects via `~/.claude/settings.json`):

### Machine Detection (`~/.claude/hooks/detect-machine.sh`)
Detects the development machine and displays capabilities/constraints. Writes machine name to `~/.claude/.machine-name` for use by `/r-commit` and `/w-timecard`.

| Machine | D1 Local | D1 Remote | R2 Local | R2 Remote | Notes |
|---------|:--------:|:---------:|:--------:|:---------:|-------|
| MacMiniM4-Pro | ✅ | ✅ | ✅ | ✅ | Full functionality |
| MacMiniM4 | ✅ | ✅ | ✅ | ✅ | Full functionality |

**Project hooks** (Peerloop-specific via `.claude/settings.json`, in execution order):

- `persist-project-dir.sh` — Persists `$CLAUDE_PROJECT_DIR` to `$CLAUDE_ENV_FILE` so it's available to skill `!` backtick expressions for the rest of the session. Required by skills that reference `$CLAUDE_PROJECT_DIR` in pre-computed context.
- `dual-repo-info.sh` — Shows both repos and their branches
- `check-env.sh` — Validates dev environment (Node, wrangler, etc.)
- `tech-doc-drift.sh` — Wraps `.claude/scripts/tech-doc-sweep.sh`. Silent on clean; surfaces a `=== TECH-DOC DRIFT ===` block with the flagged-doc list + resolve hint when tech docs appear stale vs recent code changes. Uses `.claude/.drift-baseline-sha` as the diff anchor (records last-reviewed code commit); `/r-end` auto-advances the baseline after each conv so flags don't repeat.

## Conversation (Conv) Lifecycle

Work units are tracked as **Conv** (Conversation) numbers, replacing the previous Session numbering (which ended at Session 393). Conv numbers start at 001. Both repos are treated as a paired unit — same Conv number in both repos' commit messages.

**Key files:** `CONV-COUNTER` (persistent integer, git-synced), `.conv-current` (ephemeral, gitignored)

### Workflow

| I want to... | Run |
|---|---|
| Start working (any context) | `/r-start` |
| Save & keep working (fresh context) | `/r-end` → `/clear` → `/r-start` |
| Save & keep working (same context) | `/r-commit` |
| Save & quit for the day | `/r-end` → exit |

### Conv Skills (r-* prefix)

| Skill | Purpose |
|-------|---------|
| `/r-start` | **Start conversation** — check repos clean, pull, increment Conv, push, resume (inline) |
| `/r-end` | **End conversation** — collector + 3 parallel agents (learn-decide, update-plan, docs), commit/push using v2 format |
| `/r-commit` | Commit both repos using v2 commit format (H3 sections + `Format: v2` trailer) |
| `/r-timecard` | Generate merged dual-repo timecard for client billing |
| `/r-timecard-day` | Generate intelligent daily timecard — deterministic via `timecard-day.js` script, per-Block reporting; parses both v1 and v2 commit bodies |
| `/r-prune-claude` | Optimize CLAUDE.md by moving content to offload file |

See `docs/reference/COMMIT-MESSAGE-FORMAT.md` for the v2 commit-body spec used by `/r-commit` and `/r-end`.

### Peerloop-Specific Skills (w-* prefix)

| Skill | Purpose |
|-------|---------|
| `/w-timecard` | Generate single-repo commit timecard for client billing |
| `/w-schema-dump` | Export database table schema to TSV |
| `/w-sync-docs` | Audit docs for drift against codebase |
| `/w-add-client-note` | Process client notes into RFC |
| `/w-codecheck` | Run comprehensive code quality checks |
| `/w-post-fix` | Lightweight end-of-conv for bug-fix conversations |
| `/w-git-history` | Extract commit history |
| `/w-review-resume-state` | Present RESUME-STATE.md for user review |
| `/w-sync-skills` | Scan another dual-repo project for skill changes and port improvements |
| `/w-test-env` | Test env var availability in skill expressions |

### Multi-Session Blocks

For blocks too large for one session, create `CURRENT-BLOCK-PLAN.md` at project root with per-item checkboxes, key files table, and progress summary updated each session.

## Test Suite Workflow

**Test suite workflow — follow this sequence:**

1. **Run once and capture failures** to a file:
   ```bash
   cd ../Peerloop && npm test 2>&1 | tee /tmp/test-output.txt
   ```

2. **Extract failing tests** into a structured list:
   ```bash
   grep -E "FAIL.*test\.(ts|tsx)" /tmp/test-output.txt | sort -u > /tmp/failing-tests.txt
   ```

3. **Evaluate and proceed:**
   - Show the count of failures and failing test files
   - **≤5 failures with clear names** → proceed directly to fix them
   - **>5 failures or unclear cause** → stop and ask the user how to proceed

4. **Fix tests individually**, running only that specific test:
   ```bash
   cd ../Peerloop && npm test -- --testNamePattern="TestName" 2>&1 | tail -15
   ```

5. **Do NOT re-run the full suite** until all identified failures are fixed.

**Why this matters:**
- Full test suite takes ~2 minutes
- Running it repeatedly wastes time and context
- Fixing tests one-by-one with targeted runs is efficient

The test suite is one of five gates that constitute a baseline check — see §Baseline Verification below for the full set and the verify-in-THIS-conv discipline. `/w-codecheck` is the authoritative skill that runs all five.

## Baseline Verification

A "baseline" claim asserts the project is healthy — tests pass, types check, build succeeds. These claims appear in `RESUME-STATE.md`, `COMPLETED_PLAN.md`, session docs, and `/r-end` summaries, and downstream work depends on them. Two rules govern when those claims are valid.

**Rule 1 — All five gates must be green:**

```
1. tsc --noEmit          # .ts/.tsx type check
2. npm run check         # astro check (.astro files)
3. npm run lint
4. npm test
5. npm run build
```

`tsc --noEmit` alone is **not** sufficient — it does not scan `.astro` files. Missing any of the five gates leaves a category of errors invisible. Conv 104 discovered 10 pre-existing type errors in `.astro` pages that had been hidden through Convs 100–103 because `astro check` was never run. `/w-codecheck` is the authoritative gate that bundles all five.

**Rule 2 — Verify in THIS conv before claiming:**

Never assert "tests passing", "tsc clean", or "build clean" in any document unless the corresponding command was actually run **in this conversation**. If carrying a number forward from a previous conv without re-verifying, write it explicitly: `(unchanged from Conv N, not re-verified this conv)`. Conv 101's RESUME-STATE confidently claimed "6399/6399 passing" — Conv 102 ran the suite and found 5 silently-broken session-creation tests that had been failing for an unknown number of convs. Carry-forward claims hide regressions.

When `/r-start` reads a previous conv's claimed baseline, treat it as a **hypothesis**, not a fact, until this conv re-verifies. See `memory/feedback_baseline_includes_astro_check.md` and `memory/feedback_verify_baselines_in_conv.md` for the full incident details.

## Schema Discrepancy Discipline

**CRITICAL: The schema is NOT finalized.** When writing tests, if you encounter ANY discrepancy between:
- Test expectations vs schema
- Endpoint code vs schema
- Non-existent tables/columns referenced in code

**You MUST STOP and ask the user.** Do NOT assume the schema is correct. Do NOT silently fix the endpoint to match the schema.

**Present options to the user using the A/B/C labeled-list format** (per §User-Facing Questions above):

```
Schema/Code Discrepancy Detected
────────────────────────────────
Location: [endpoint or test file]
Issue: [describe the mismatch]

Current schema says: [X]
Code/test expects: [Y]

A) Fix the schema to match the code's design intent
B) Fix the code/test to match current schema
C) Discuss the design intent first

👉👉👉 **Which — A, B, or C?**
```

**Examples of discrepancies to flag:**
- FK references wrong table (e.g., `REFERENCES users(id)` vs `REFERENCES teacher_certifications(id)`)
- Code references non-existent table or column
- Test expects columns that don't exist
- Column types or constraints don't match usage

**Let the user decide** — the schema is still evolving. Often the code represents the intended design and the schema needs updating.

**Exception:** If the missing column/table is unambiguously the code's design intent — its name and purpose are self-evident from context — state the assumption inline ("Schema is missing `X` — adding it now") and proceed. Hard-stop only when both interpretations (fix schema vs. fix code) are genuinely plausible.

**If extending schema:** Edit `../Peerloop/migrations/0001_schema.sql` directly, update `../Peerloop/migrations/0002_seed_core.sql` if needed.

## Project Overview

**Peerloop** (formerly Alpha Peer) is a peer-to-peer learning platform that solves the "2 Sigma Problem" by making 1-on-1 tutoring affordable and scalable through a learn-teach-earn flywheel.

### The Flywheel Model
- Student enrolls and learns from a Teacher
- Student completes course → Teacher recommends → Creator certifies
- Student becomes Teacher → teaches new students → earns 70% commission
- Cycle repeats, creating self-sustaining teaching capacity

### Key Metrics

| Metric | Target |
|--------|--------|
| Course Completion Rate | ≥75% (vs 15-20% MOOC average) |
| Student-to-Teacher Conversion | 10-20% |
| Genesis Cohort | 60-80 students, 4-5 courses |
| Timeline | 4 months |
| Budget | $75,000 |

### Key Roles

| Role | Description |
|------|-------------|
| Student | Learner progressing through courses |
| Teacher | Certified graduate who teaches peers (70% commission) |
| Creator | Course author who certifies Teachers (15% royalty) |
| Admin | Platform operations and oversight |
| Moderator | Community moderation |

## Technology Stack

| Layer | Technology | Notes |
|-------|------------|-------|
| Meta-framework | Astro.js | React islands, SSG/SSR |
| UI Framework | React.js | Component library |
| Styling | TailwindCSS | Utility-first CSS |
| Hosting/Edge | Cloudflare | Pages, Workers, R2, D1 |
| Database | Cloudflare D1 | SQLite-based |
| Auth | Custom JWT | Session management |
| Payments | Stripe Connect | 85/15 split, payouts |
| Activity Feeds | Stream.io | Feeds only (not chat) |
| Video | VideoProvider Interface | BBB/PlugNmeet abstraction |
| Email | Resend | Transactional email |
| File Storage | Cloudflare R2 | S3-compatible |

### Development Machines

| Name | Machine | D1 Support | R2 Support |
|------|---------|------------|------------|
| `MacMiniM4-Pro` | Mac Mini M4 Pro (64GB) | Local + Remote | Local + Remote |
| `MacMiniM4` | Mac Mini M4 (24GB) | Local + Remote | Local + Remote |

Both machines have identical, full capabilities. See `docs/as-designed/devcomputers.md` for details.

## Development Commands

All code commands run from the code repo:

```bash
# Install dependencies
cd ../Peerloop && npm install

# Start development server
cd ../Peerloop && npm run dev

# Dev server with remote staging D1 (for bug reproduction)
cd ../Peerloop && npm run dev:staging

# Build for production
cd ../Peerloop && npm run build

# Preview production build
cd ../Peerloop && npm run preview

# Type checking (.ts/.tsx only)
cd ../Peerloop && npx tsc --noEmit

# Type checking (.astro files — tsc does NOT scan these)
cd ../Peerloop && npm run check

# Linting
cd ../Peerloop && npm run lint
```

## SQLite Datetime Rule

**NEVER use `datetime()` in SQL comparisons.** SQLite's `datetime()` returns space-separated format (`2026-03-25 11:00:00`) while Peerloop stores timestamps in ISO format with `T` separator (`2026-03-25T11:00:00.000Z`). String comparison makes `datetime()` results always appear "less than" ISO strings because space (ASCII 32) < T (ASCII 84). This causes silent, hard-to-detect bugs.

**Always use:** `strftime('%Y-%m-%dT%H:%M:%fZ', ...)` for any SQL datetime arithmetic in comparisons.

```sql
-- ❌ WRONG — silent comparison bug
WHERE datetime(s.scheduled_end, '+1 hour') < ?

-- ✅ CORRECT — produces ISO format matching stored timestamps
WHERE strftime('%Y-%m-%dT%H:%M:%fZ', s.scheduled_end, '+1 hour') < ?
```

`datetime()` is safe in non-comparison contexts (e.g., `DEFAULT (datetime('now'))` in schema DDL) but even there, prefer `strftime('%Y-%m-%dT%H:%M:%fZ', 'now')` for consistency.

This is enforced by `/w-codecheck`.

## Database Migrations

**Migration Strategy:** Split seed files for production safety. Full operational details (D1 reset, recovery procedures, dependency-order drops) are in `docs/as-designed/migrations.md`.

```
../Peerloop/migrations/              # PRODUCTION-SAFE (applied everywhere)
├── 0001_schema.sql                  # Table definitions
└── 0002_seed_core.sql               # Essential data (topics, tags, admin, The Commons)

../Peerloop/migrations-dev/          # DEV ONLY (local + staging only)
└── 0001_seed_dev.sql                # Test data (users, courses, etc.)
```

**Commands:**
```bash
# Local production-like (schema + core seed only)
cd ../Peerloop && npm run db:setup:local

# Local dev (+ dev seed data)
cd ../Peerloop && npm run db:setup:local:dev

# Local dev + booking test data
cd ../Peerloop && npm run db:setup:local:booking

# Production (SAFEGUARDED - requires confirmation)
cd ../Peerloop && npm run db:migrate:prod

# Reset (local | staging | remote — see docs/as-designed/migrations.md for details)
cd ../Peerloop && npm run db:reset:local && npm run db:migrate:local
```

**Blocked Commands (for safety):**
- `npm run db:seed:prod` — Dev seed CANNOT be applied to production
- `npm run db:reset:prod` — Production reset is blocked

**Schema Changes:**
- Edit `../Peerloop/migrations/0001_schema.sql` directly — it's the authoritative schema
- Post-launch: Add incremental `0003_*.sql` migrations for production upgrades
- For schema/code discrepancies during testing, see §Schema Discrepancy Discipline above.

**Testing:**
- Test DB uses better-sqlite3 (works on all machines)
- Applies migrations fresh each run
- `cd ../Peerloop && npm run test` validates schema automatically

## RFC System

Client-driven change requests are tracked in `docs/requirements/rfc/`. Navigation table (RFC index, source docs, checklists) is in `docs/INDEX.md` § "Client Change Requests (RFCs)".

**Structure:**
```
docs/requirements/rfc/
├── INDEX.md           # Lookup table (status, item counts)
└── CD-XXX/
    ├── CD-XXX.md      # Source: raw client input
    └── RFC.md         # Actionable checklist with checkboxes
```

**Workflow:**
1. Client provides note/directive
2. Run `/w-add-client-note` to analyze and create RFC
3. Check off items in `RFC.md` as implemented
4. Update status in `docs/requirements/rfc/INDEX.md` when complete

**When working on an RFC:**
- Read `docs/requirements/rfc/INDEX.md` to find open RFCs
- Check `docs/requirements/rfc/CD-XXX/RFC.md` for pending items
- Mark checkboxes as completed during implementation

## Technology & Architecture Documentation

**Locations:**
- `docs/reference/` — Reference docs including vendor/service docs (e.g., `stripe.md`, `cloudflare.md`, `API-*.md`, `CLI-*.md`)
- `docs/as-designed/` — Architecture & design docs (e.g., `url-routing.md`, `migrations.md`, `messaging.md`)

For full doc-tree navigation see `docs/INDEX.md`.

### When Working with a Technology

1. **Check the doc first** — Before implementing with a technology, read the relevant doc in `docs/reference/` or `docs/as-designed/` — **unless** you're following a pattern already established and used in the current session. Read when: first encounter with that technology this session, or using a feature of it not yet exemplified in the codebase.
   - Why it was chosen (decision rationale)
   - Known caveats or limitations
   - Integration patterns and code examples
   - Pricing considerations

2. **Update the doc** — When you discover:
   - New caveats or gotchas
   - Better integration patterns
   - Version-specific issues
   - Performance considerations
   - Useful tips or workarounds

### Doc Format

Each vendor/architecture doc includes: overview and why chosen, comparison with alternatives, features relevant to PeerLoop, integration code examples, pricing (vendor docs), references to official docs.
