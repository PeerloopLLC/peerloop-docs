# CLAUDE.md

This file provides guidance to Claude Code when working in the Peerloop dual-repo architecture.

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

**Threshold:** If the decision follows patterns already established in the codebase (same file type, same component structure, same API shape, same test pattern), proceed without stopping. Only escalate genuinely novel decisions — not every coding choice requires a check-in.

## Skills: Preserve `!` Backtick Determinism

Pre-computed context (`!` backticks in SKILL.md) is a core feature of this project's skills. It guarantees determinism — the skill author controls what data Claude sees, not Claude's runtime decisions. Do NOT replace `!` backtick commands with tool-based alternatives unless the user explicitly approves.

## Multi-Session Blocks

For blocks too large for one session, create `CURRENT-BLOCK-PLAN.md` at project root with per-item checkboxes, key files table, and progress summary updated each session.

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

## Explanatory Style Override

The active output style requires `★ Insight` blocks before and after code. Limit this to **one insight block per response**, only when the insight is genuinely non-obvious or specific to this codebase. Do NOT add insight blocks for standard patterns (React hooks, REST endpoints, SQL queries, etc.) that any competent developer would recognize. Prefer velocity over narration.

## Dual-Repo Architecture

Peerloop uses two sibling repositories:

```
~/projects/
├── peerloop-docs/    ← CC home (this repo) + Obsidian vault
│   ├── .claude/      # All CC configuration, commands, hooks
│   ├── CLAUDE.md     # This file (full project guidance)
│   └── docs/         # Sessions, reference, as-designed, requirements, guides
│
└── Peerloop/         ← Code repo (added via --add-dir)
    ├── src/          # Application code
    ├── tests/        # Test suite
    ├── scripts/      # Build & utility scripts
    ├── migrations/   # Database SQL
    └── ...           # Config files, package.json, etc.
```

**Launch pattern:** `cd ~/projects/peerloop-docs && claude --add-dir ../Peerloop`

**Shell alias:** The above command is aliased as `peerloop` in `~/.zshrc`. From any terminal (typically `~/projects/Peerloop`), type `peerloop` to launch the dual-repo environment. This is the standard entry point and must be configured when setting up a new development machine.

**Path conventions:**
- Docs, planning files → local paths (e.g., `docs/reference/...`, `docs/as-designed/...`, `docs/reference/DB-GUIDE.md`)
- Code, tests, scripts, config → prefixed paths (e.g., `../Peerloop/src/...`)
- npm/npx commands → `cd ../Peerloop && npm run ...`

**Symlinks in code repo** (for build-time dependencies):
- `Peerloop/docs → ../peerloop-docs/docs`

---

## Startup Hooks (SessionStart)

**Global hook** (runs for all projects via `~/.claude/settings.json`):

### Machine Detection (`~/.claude/hooks/detect-machine.sh`)
Detects the development machine and displays capabilities/constraints. Writes machine name to `~/.claude/.machine-name` for use by `/r-commit` and `/w-timecard`.

| Machine | D1 Local | D1 Remote | R2 Local | R2 Remote | Notes |
|---------|:--------:|:---------:|:--------:|:---------:|-------|
| MacMiniM4-Pro | ✅ | ✅ | ✅ | ✅ | Full functionality |
| MacMiniM4 | ✅ | ✅ | ✅ | ✅ | Full functionality |

**Project hooks** (Peerloop-specific via `.claude/settings.json`):

- `dual-repo-info.sh` — Shows both repos and their branches
- `check-env.sh` — Validates dev environment (Node, wrangler, etc.)

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
| `/r-end` | **End conversation** — collector + 3 parallel agents (learn-decide, update-plan, docs), commit/push |
| `/r-commit` | Commit both repos with Conv + Machine metadata |
| `/r-timecard` | Generate merged dual-repo timecard for client billing |
| `/r-timecard-day` | Generate intelligent daily timecard with auto-grouping and structured tag extraction |
| `/r-timecard-day2` | Generate intelligent daily timecard — deterministic via `timecard-day.js` script, per-Block reporting |
| `/r-prune-claude` | Optimize CLAUDE.md by moving content to offload file |

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

**Baseline checks must include ALL of tsc, astro check, lint, test, and build.** Running `tsc --noEmit` alone is insufficient — it does not scan `.astro` files. Conv 104 discovered 10 pre-existing type errors in `.astro` pages that had been invisible because `astro check` was never part of the local or CI baseline. If you are claiming "clean baselines", all five gates must be green.

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

**Migration Strategy:** Split seed files for production safety. See `docs/as-designed/migrations.md`.

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
```

**Blocked Commands (for safety):**
- `npm run db:seed:prod` - Dev seed CANNOT be applied to production
- `npm run db:reset:prod` - Production reset is blocked

**Schema Changes:**
- Edit `../Peerloop/migrations/0001_schema.sql` directly - it's the authoritative schema
- Post-launch: Add incremental `0003_*.sql` migrations for production upgrades

**Testing:**
- Test DB uses better-sqlite3 (works on all machines)
- Applies migrations fresh each run
- `cd ../Peerloop && npm run test` validates schema automatically

### Schema Mismatch During Testing

**CRITICAL: The schema is NOT finalized.** When writing tests, if you encounter ANY discrepancy between:
- Test expectations vs schema
- Endpoint code vs schema
- Non-existent tables/columns referenced in code

**You MUST STOP and ask the user.** Do NOT assume the schema is correct. Do NOT silently fix the endpoint to match the schema.

**Present options to the user:**
```
Schema/Code Discrepancy Detected
────────────────────────────────
Location: [endpoint or test file]
Issue: [describe the mismatch]

Current schema says: [X]
Code/test expects: [Y]

Options:
1. Fix the schema to match the code's design intent
2. Fix the code/test to match current schema
3. Discuss the design intent first
```

**Examples of discrepancies to flag:**
- FK references wrong table (e.g., `REFERENCES users(id)` vs `REFERENCES teacher_certifications(id)`)
- Code references non-existent table or column
- Test expects columns that don't exist
- Column types or constraints don't match usage

**Let the user decide** - the schema is still evolving. Often the code represents the intended design and the schema needs updating.

**Exception:** If the missing column/table is unambiguously the code's design intent — its name and purpose are self-evident from context — state the assumption inline ("Schema is missing `X` — adding it now") and proceed. Hard-stop only when both interpretations (fix schema vs. fix code) are genuinely plausible.

**If extending schema:** Edit `../Peerloop/migrations/0001_schema.sql` directly, update `../Peerloop/migrations/0002_seed_core.sql` if needed.

### D1 Database Reset

To reset a D1 database and re-apply migrations fresh:

```bash
# Local D1
cd ../Peerloop && npm run db:reset:local && npm run db:migrate:local

# Staging D1 (Cloudflare)
cd ../Peerloop && npm run db:reset:staging && npm run db:migrate:staging

# Production D1 (Cloudflare) - use with caution!
cd ../Peerloop && npm run db:reset:remote && npm run db:migrate:remote
```

**How it works:**
- **Local:** Deletes SQLite files in `../Peerloop/.wrangler/state/v3/d1/` (simplest approach)
- **Remote:** Parses `0001_schema.sql` for FK relationships, drops tables in dependency order (children before parents)

**Why dependency order?** D1 enforces `foreign_keys=ON` at the platform level and doesn't allow `PRAGMA foreign_keys=OFF`. Using `PRAGMA defer_foreign_keys=ON` doesn't help with DROP TABLE. The only reliable approach is to drop child tables before parent tables.

**Known issue — remote reset can leave orphaned indexes (Session 359):**
The `reset-d1.js` script drops tables but not standalone indexes. If the batch drop fails partway (e.g., FK constraint error on a circular dependency), surviving tables retain their indexes. When you then drop those tables individually, the indexes become orphaned — they exist in `sqlite_master` but reference no table. On the next `CREATE INDEX` (without `IF NOT EXISTS`), the migration fails with `index already exists`.

**Manual recovery when remote reset leaves orphans:**
```bash
# 1. Check what's left
npx wrangler d1 execute DB --env preview --remote \
  --command "SELECT name, type FROM sqlite_master WHERE type IN ('table','index') AND name NOT LIKE 'sqlite_%' AND name NOT LIKE 'd1_%' AND name NOT LIKE '_cf_%';"

# 2. Drop orphaned indexes (batch — extract names from step 1)
npx wrangler d1 execute DB --env preview --remote \
  --command "DROP INDEX IF EXISTS idx_name_1; DROP INDEX IF EXISTS idx_name_2; ..."

# 3. Drop remaining tables in dependency order (children first, 3 batches)
# Batch 1: leaf tables (no children)
# Batch 2: mid-level (sessions, enrollments, etc.)
# Batch 3: parent tables (courses, communities, users)

# 4. Clear migration tracking and re-apply
npx wrangler d1 execute DB --env preview --remote --command "DELETE FROM d1_migrations;"
npm run db:migrate:staging
```

## Project Structure

```
~/projects/
├── peerloop-docs/                    # CC home + Obsidian vault
│   ├── .claude/                      # CC configuration
│   │   ├── commands/                 # (empty — all migrated to skills/)
│   │   ├── skills/                  # w-* skills (Peerloop-specific) + r-* skills (Conv lifecycle)
│   │   ├── hooks/                    # Session hooks
│   │   ├── settings.json             # Permissions & hook config
│   │   ├── config.json               # Project config
│   │   └── plans/                    # CC plans
│   ├── CLAUDE.md                     # This file
│   ├── PLAN.md                       # Current & pending work
│   ├── COMPLETED_PLAN.md             # Completed work
│   ├── DOC-DECISIONS.md              # Docs-repo decisions & conventions
│   ├── CONV-INDEX.md                 # Conversation log index (Conv 001+)
│   ├── SESSION-INDEX.md              # Session log archive (Sessions 0-393)
│   ├── TIMELINE.md                   # Project milestone timeline (inflection points)
│   └── docs/
│       ├── DECISIONS.md              # Peerloop application decisions
│       ├── GLOSSARY.md               # Official terminology
│       ├── POLICIES.md               # Platform behavior policies (access control, business rules)
│       ├── reference/                # CLI, API, testing, DB docs (+ DB-GUIDE, DB-API, REMOTE-API)
│       ├── as-designed/              # Architecture & design docs (+ run-001/, orig-pages-map, route-stories)
│       ├── requirements/             # Goals, user stories, RFCs, client docs
│       │   ├── rfc/                  # Client change requests (CD-XXX/)
│       │   └── stories/              # User stories by role
│       ├── sessions/                 # Development session logs
│       └── guides/                   # How-to guides
│
└── Peerloop/                         # Code repo (via --add-dir)
    ├── CLAUDE.md                     # Minimal pointer to docs repo
    ├── src/                          # Application source
    │   ├── components/               # React components
    │   ├── pages/                    # Astro pages
    │   ├── layouts/                  # Page layouts
    │   ├── lib/                      # Utility functions
    │   ├── services/                 # External service integrations
    │   └── styles/                   # Global styles
    ├── public/                       # Static assets
    ├── tests/                        # Test suite
    ├── e2e/                          # End-to-end tests
    ├── scripts/                      # Build & utility scripts
    ├── migrations/                   # Production DB migrations
    ├── migrations-dev/               # Dev-only seed data
    ├── docs → ../peerloop-docs/docs          # Symlink
    └── [config files]                # package.json, wrangler.toml, etc.
```

## Key Roles

| Role | Description |
|------|-------------|
| Student | Learner progressing through courses |
| Teacher | Certified graduate who teaches peers (70% commission) |
| Creator | Course author who certifies Teachers (15% royalty) |
| Admin | Platform operations and oversight |
| Moderator | Community moderation |

## Research Reference

All specifications live under `docs/` (in `reference/`, `requirements/`, and `as-designed/`). Use this guide to find what you need:

### Terminology

| Need | Look In |
|------|---------|
| **Official terminology (source of truth)** | `docs/GLOSSARY.md` — identity hierarchy, domain terms, naming conventions, ambiguous terms (§7) |

> **TERMINOLOGY Rename Boundary (Sessions 346-356, ~960 files, ~5000 replacements)**
> To compare pre-rename state, check out the commits *before* each range:
>
> | Repo | Branch | Pre-rename (checkout this) | First rename | Last rename |
> |------|--------|---------------------------|--------------|-------------|
> | `peerloop-docs` | `main` | `ec44e52` (Session 345) | `a2cf81a` (Session 346) | `24d50a6` (Session 356) |
> | `Peerloop` | `jfg-dev-7-fix` | `aa140ab` (Session 345) | `7c4f658` (Session 349) | `433945f` (Session 355) |
>
> Diff the full range: `git diff ec44e52..24d50a6` (docs) or `git diff aa140ab..433945f` (code).
>
> **Test baseline caveat:** 6 test failures pre-existed this block; 1 new failure surfaced during it. Pre-rename state is not a clean-passing baseline.

### What Are We Building?

| Need | Look In |
|------|---------|
| Project goals & success metrics | `docs/requirements/GOALS.md` |
| User stories (all 370+) | `docs/requirements/USER-STORIES.md` |
| User stories by role | `docs/requirements/stories/stories-*.md` (admin, creator, student, etc.) |
| **Route→story mapping (402 stories)** | `docs/as-designed/route-stories.md` — **Canonical route-to-story assignment** |
| MVP scope (144 P0 stories) | `docs/as-designed/run-001/SCOPE.md` |

### How Should It Look/Work?

| Need | Look In |
|------|---------|
| **Routes & navigation** | `docs/as-designed/url-routing.md` - **Source of truth for routes** |
| Page specs (JSON) | **DELETED** (Sessions 307+311) — see git history |
| Page specs (MD) | **DELETED** (Sessions 307+311) — see git history |
| UI components | `docs/reference/_COMPONENTS.md` |
| Feature breakdown by block | `docs/as-designed/run-001/_features-block-*.md` |
| Original page architecture | `docs/as-designed/orig-pages-map.md` - Pre-Twitter UI pivot reference |

**Note:** The original `PAGES-MAP.md` was renamed to `docs/as-designed/orig-pages-map.md` after the client moved to a Twitter-like UI/UX. Route information is now maintained in `docs/as-designed/url-routing.md`.

### Data & APIs

| Need | Look In |
|------|---------|
| Database schema (SQL source of truth) | `../Peerloop/migrations/0001_schema.sql` |
| Database design rationale | `docs/reference/DB-GUIDE.md` |
| Internal API endpoints | `docs/reference/DB-API.md` |
| External service APIs | `docs/reference/REMOTE-API.md` (Stripe, Stream, PlugNmeet, Resend) |

### Technology Decisions

| Need | Look In |
|------|---------|
| Why we chose a vendor/service | `docs/reference/*.md` (vendor docs merged here) |
| Vendor comparisons | `docs/reference/comp-*.md` |
| Integration patterns | `docs/reference/*.md` (code examples section) |
| Architecture & design patterns | `docs/as-designed/*.md` |
| Skills 2 system & drift tools | `docs/as-designed/skills-system.md` |

### Platform Policies & Decisions

| Need | Look In |
|------|---------|
| Platform behavior policies | `docs/POLICIES.md` — Access control, business rules, user capabilities |
| Architecture & implementation decisions | `docs/DECISIONS.md` |
| Docs-repo conventions | `DOC-DECISIONS.md` |

### Implementation

| Need | Look In |
|------|---------|
| Current & pending work | `PLAN.md` (root) |
| Completed work | `COMPLETED_PLAN.md` (root) |
| Project milestone timeline | `TIMELINE.md` (root) — inflection points, not routine work |
| Block-by-block features | `docs/as-designed/run-001/` (files prefixed with `_features-`) |
| Infrastructure features | `docs/as-designed/run-001/_features-infrastructure.md` |

### Feature Tracking Rule

**When a feature is described in actionable detail** — who does what, on which route or page — during coding work, RFC processing, or tech doc updates, add it to `PLAN.md`. Casual planning-discussion mentions can be batched to `/r-end`. Where it goes is situational (active block, deferred block, sub-task of an existing block, etc.). If the feature originated from a tech doc, add a cross-reference in the tech doc noting the PLAN block it was added to (e.g., "Tracked in PLAN.md: RATINGS-EXT"). Tech docs describe *how* and *why*; PLAN.md is the single source of truth for *what needs to be done*.

### Client Change Requests (RFCs)

| Need | Look In |
|------|---------|
| **RFC index & status** | `docs/requirements/rfc/INDEX.md` - **Lookup table for all RFCs** |
| Source document | `docs/requirements/rfc/CD-XXX/CD-XXX.md` |
| Actionable checklist | `docs/requirements/rfc/CD-XXX/RFC.md` |

## RFC System

Client-driven change requests are tracked in `docs/requirements/rfc/`.

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
2. Run `/q-add-client-note` to analyze and create RFC
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

### When Working with a Technology

1. **Check the doc first** - Before implementing with a technology, read the relevant doc in `docs/reference/` or `docs/as-designed/` — **unless** you're following a pattern already established and used in the current session. Read when: first encounter with that technology this session, or using a feature of it not yet exemplified in the codebase.
   - Why it was chosen (decision rationale)
   - Known caveats or limitations
   - Integration patterns and code examples
   - Pricing considerations

2. **Update the doc** - When you discover:
   - New caveats or gotchas
   - Better integration patterns
   - Version-specific issues
   - Performance considerations
   - Useful tips or workarounds

### Doc Format

Each doc includes:
- Overview and why chosen
- Comparison with alternatives
- Features relevant to PeerLoop
- Integration code examples
- Pricing (vendor docs)
- References to official docs

## Block Sequence

| Block | Focus | Key Deliverables |
|-------|-------|------------------|
| 0 | Foundation | Auth, database schema, navigation shell |
| 1 | Course Display | Homepage, course browse, creator profiles |
| 2 | Enrollment | Payment, checkout, enrollment management |
| 3 | Dashboards | Student, Teacher, Creator dashboards |
| 4 | Video Sessions | VideoProvider, booking, session room |
| 5 | Community Feed | Stream.io integration, posts, reactions |
| 6 | Certifications | Certificate issuance, verification |
| 7 | Teacher Management | Availability, earnings, students |
| 8 | Admin Tools | User/course/payout management |
| 9 | Notifications | Email + in-app notifications |

## Documentation Reference

**Location:** `docs/reference/`

Living documentation maintained by the docs agent within `/r-end` (scripts in `.claude/skills/r-end/scripts/`).

### Reference Docs

| File | Purpose | When to Update |
|------|---------|----------------|
| `CLI-QUICKREF.md` | Command index (start here) | Any npm script or API change |
| `CLI-REFERENCE.md` | Detailed npm script docs | Script added/changed |
| `CLI-TESTING.md` | Test command details | Test commands changed |
| `BROWSER-TESTING.md` | Chrome MCP vs Playwright comparison | Browser testing approach changed |
| `CLI-MISC.md` | Setup & installation | Environment/setup changes |
| `API-REFERENCE.md` | REST API & database patterns | Endpoints or DB patterns changed |
| `TEST-COVERAGE.md` | Test file inventory | Tests added/removed |
| `DEVELOPMENT-GUIDE.md` | Dev patterns & conventions | New patterns established |

### Project-Specific Docs (also covered by `/r-end` docs agent)

| Location | Purpose | When to Update |
|----------|---------|----------------|
| `docs/reference/*.md` (vendor), `docs/as-designed/*.md` | Technology & architecture docs | Package changes, caveats, design patterns |
| `docs/as-designed/run-001/_*.md` | Page specifications | Page design changes |
| `docs/reference/DB-GUIDE.md` | Database design rationale | Schema design changes |

**Related project docs:**
- `PLAN.md` - Current & pending work (docs repo root)
- `COMPLETED_PLAN.md` - Completed work (docs repo root)
- `docs/as-designed/orig-pages-map.md` - Original page architecture (pre-Twitter UI pivot)
- `docs/requirements/` - Goals, user stories, RFCs
