# CLAUDE-OFFLOAD.md - Extended Documentation

Sections moved from `CLAUDE.md` to keep the always-loaded file lean. Each section's CLAUDE.md stub carries a one-line summary + back-link here. Behavioral rules stayed in CLAUDE.md; this file holds procedures, command catalogs, directory trees, and reference tables.

---

## Dual-Repo Architecture

Peerloop uses two sibling repositories:

```
~/projects/
├── peerloop-docs/    ← CC home (this repo) + Obsidian vault
│   ├── .claude/      # All CC configuration, commands, hooks
│   │   └── memory-sync/memories/  # Cross-machine memory mirror (committed, git is transport)
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
- **Skill `!`-backticks and Bash commands — use tilde everywhere.** Tilde (`~`) IS equivalent to `$HOME` functionally (both resolve to the current user's home), but the Bash permission gate only flags `$VAR` form as `simple_expansion`. Use `~/projects/peerloop-docs/...` and `~/projects/Peerloop/...` consistently — both cross-machine-portable (works on M4 = `livingroom`, M4Pro = `jamesfraser`) and prompt-free. Tilde expands only **outside double quotes**, so in bash blocks: drop the surrounding double quotes from path strings (paths have no spaces, so unquoted is safe). For variable assignments, write `LIVE=~/.claude/projects/$SLUG/memory` not `LIVE="$HOME/.claude/projects/$SLUG/memory"`. For slug derivation, use `SLUG=$(echo ~/projects/peerloop-docs | tr / -)` instead of `${CLAUDE_PROJECT_DIR//\//-}`. Local script vars (`$SLUG`, `$LIVE`, `$DIFF_OUT`, etc., defined and consumed within the same bash block) are unaffected — the gate only flags external env-var references. Convention established Conv 162.

**Symlinks in code repo** (for build-time dependencies):
- `Peerloop/docs → ../peerloop-docs/docs`

---

## Startup Hooks (SessionStart)

**Global hook** (runs for all projects via `~/.claude/settings.json`):

### Machine Detection (`~/.claude/hooks/detect-machine.sh`)
Detects the development machine and displays capabilities/constraints. Writes machine name to `~/.claude/.machine-name` for use by `/r-commit` and `/w-timecard`.

| Machine | D1 Local | D1 Remote | R2 Local | R2 Remote | Notes |
|---------|:--------:|:---------:|:--------:|:---------:|-------|
| MacMiniM4Pro | ✅ | ✅ | ✅ | ✅ | Full functionality |
| MacMiniM4 | ✅ | ✅ | ✅ | ✅ | Full functionality |

**Project hooks** (Peerloop-specific via `.claude/settings.json`, in execution order):

- `persist-project-dir.sh` — Persists `$CLAUDE_PROJECT_DIR` to `$CLAUDE_ENV_FILE` so it's available to skill `!` backtick expressions. **Historical** as of Conv 162: skills no longer reference `$CLAUDE_PROJECT_DIR` (swept to tilde-literal `~/projects/peerloop-docs` to avoid the Bash tool's `simple_expansion` permission prompt). The only consumer left is the `w-test-env` diagnostic skill. Hook can be removed once `w-test-env` is retired.
- `dual-repo-info.sh` — Shows both repos and their branches
- `check-env.sh` — Validates dev environment (Node, wrangler, etc.)
- `tech-doc-drift.sh` — Wraps `.claude/scripts/tech-doc-sweep.sh`. Silent on clean; surfaces a `=== TECH-DOC DRIFT ===` block with the flagged-doc list + resolve hint when tech docs appear stale vs recent code changes. Uses `.claude/.drift-baseline-sha` as the diff anchor (records last-reviewed code commit); `/r-end` auto-advances the baseline after each conv so flags don't repeat.

---

## Conversation (Conv) Lifecycle

Work units are tracked as **Conv** (Conversation) numbers, replacing the previous Session numbering (which ended at Session 393). Conv numbers start at 001. Both repos are treated as a paired unit — same Conv number in both repos' commit messages.

**Key files:** `CONV-COUNTER` (persistent integer, git-synced), `.conv-current` (ephemeral, gitignored), `.conv-branch` (ephemeral, gitignored — the code branch `/r-start` validated; the `[CBG]` guard compares against it at `/r-commit` + `/r-end`, Conv 395)

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
| `/r-timecard-day` | Generate intelligent daily timecard — deterministic via `timecard-day.js` script, per-Block reporting; parses both v1 and v2 commit bodies; writes to Obsidian vault (`rTimecardDay.vaultPath` in `.claude/config.json`) |
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
| `/w-sync-skills` | Scan another dual-repo project for skill changes and port improvements |
| `/w-test-env` | Test env var availability in skill expressions |

### Multi-Session Blocks

For blocks too large for one session, create `CURRENT-BLOCK-PLAN.md` at project root with per-item checkboxes, key files table, and progress summary updated each session.

---

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

The test suite is one of five gates that constitute a baseline check — see CLAUDE.md §Baseline Verification for the full set and the verify-in-THIS-conv discipline. `/w-codecheck` is the authoritative skill that runs all five.

---

## Schema Discrepancy Discipline

**CRITICAL: The schema is NOT finalized.** When writing tests, if you encounter ANY discrepancy between:
- Test expectations vs schema
- Endpoint code vs schema
- Non-existent tables/columns referenced in code

**You MUST STOP and ask the user.** Do NOT assume the schema is correct. Do NOT silently fix the endpoint to match the schema.

**Present options to the user using the A/B/C labeled-list format** (per CLAUDE.md §User-Facing Questions):

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

---

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

---

## Database Migrations

**Migration Strategy:** Split seed files for production safety. Full operational details (D1 reset, recovery procedures, dependency-order drops) are in `docs/as-designed/migrations.md`.

```
../Peerloop/migrations/              # PRODUCTION-SAFE (applied everywhere)
├── 0001_schema.sql                  # Table definitions
└── 0002_seed_core.sql               # Essential data (topics, tags, admin, System community)

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
- For schema/code discrepancies during testing, see CLAUDE.md §Schema Discrepancy Discipline.

**Testing:**
- Test DB uses better-sqlite3 (works on all machines)
- Applies migrations fresh each run
- `cd ../Peerloop && npm run test` validates schema automatically

---

## Technology & Architecture Documentation

**Locations:**
- `docs/reference/` — Reference docs including vendor/service docs (e.g., `stripe.md`, `cloudflare.md`, `API-*.md`, `CLI-*.md`)
- `docs/as-designed/` — Architecture & design docs (e.g., `url-routing.md`, `migrations.md`, `messaging.md`)

For full doc-tree navigation see `docs/INDEX.md`.

### Maintenance Tiers (Conv 200)

Docs are not all maintained equally. The `docsRegistry` in `.claude/config.json`
assigns every doc a **category** that defines its maintenance contract:

| Category | What it is | Who keeps it current |
|----------|------------|----------------------|
| **driftCheck** | Hand-written, but a deterministic check verifies it against a code source-of-truth (API route coverage, schema tables, script lists, architecture keyword sweep) | Auto: tech-doc-sweep + `/r-end` docs agent + `/w-sync-docs` |
| **manual** | Prose with no automated check — vendor docs, `DEVELOPMENT-GUIDE.md`, `POLICIES.md`, guides, governance | **Editorial only.** Update *deliberately* when its scope is wrong; never auto-expanded |
| **archival** | Frozen/historical snapshots | Never updated; edits are suspicious |
| **generated** | Produced entirely by a tool | Regenerated from source |

Resolve any doc's category: `node .claude/scripts/docs-registry.mjs doc-category <relpath>`.
**Unclassified docs default to `manual`** — new docs are NOT auto-maintained until
deliberately added to a `driftCheck` group.

### When Working with a Technology

1. **Read the doc only if it's cheaper than the source of truth.** For vendor
   libraries, the vendor's own site (and the code) is canonical and always more
   current than our local `manual` snapshot — go there. Read a local doc when it
   *concentrates knowledge that's otherwise scattered* (e.g. `route-api-map.md`,
   `url-routing.md`, `migrations.md`) or records *why* a choice was made.

2. **Update a doc only when its stated scope is now wrong** (contract violation)
   — not on every discovery. Specifically:
   - `driftCheck` docs: update when the code source-of-truth they track changed.
   - `manual` docs (incl. all vendor docs): leave alone unless the user asks, or
     a documented fact became actively misleading. Do **not** mirror a vendor's
     API surface or restate code — that duplication is the drift we removed.
   - Never *create* a new doc that duplicates code or a vendor's own docs. A new
     doc earns existence only by concentrating scattered knowledge or recording a
     decision; default it to `manual` unless it has a deterministic check.

### Doc Format

`driftCheck` and architecture docs: overview, why chosen, caveats, integration
examples, references to official docs. **Vendor (`manual`) docs are snapshots** —
keep them to *why chosen + our specific config/gotchas + a link to the official
source*; do not grow them into a mirror of the vendor's documentation.

---

## Scratch Space (`.scratch/`)

`.scratch/` at the docs-repo root is a **gitignored persistent workspace** for files CC and the user collaborate on but don't want in git history. Files there survive past conversation scrollback so they can be re-read or re-used in later convs.

**Common uses:**
- Draft messages (email, Slack, etc.) awaiting user review/send
- Before/after snapshots when tracking specific changes through a sequence of edits
- One-off skill execution logs and diagnostic output (e.g., script run results)
- Intermediate artifacts: transcripts, paste-ins, error dumps, log excerpts
- Anything that needs to survive past the visible context window but isn't worth committing

**Conventions** (see `.scratch/README.md` for details): one file per artifact, dated descriptive filenames, markdown preferred. CC may write here freely without further approval — the folder is the user's pre-authorization for persistent scratch.

**Not for:** anything that belongs in the repo proper. Docs → `docs/`, code → `src/`, planning → `PLAN.md`. If it's worth keeping in git history, it doesn't belong in `.scratch/`.

---

## Conversation Turn Log (`.scratch/conv-turns.md`)

A **re-orientation companion** the user keeps open in VS Code to recall what was recently asked/decided. **CC-maintained, live-sync** (prepended every turn) — Claude is the sole author.

**At the end of every turn, prepend a new entry** (newest-first — latest at the top, under the header) capturing:
- **Q:** the user's request/question for that turn captured **in full** — verbatim (or near-verbatim if very long); **not** terse. The point is to recall exactly what was asked.
- **A:** the reply — for an `AskUserQuestion` pick, the **selected choice value(s)** (`▸ chose "X"`); otherwise an **extremely terse** summary of the answer (one line). Only the answer is terse.

Rules: fold bare confirmations (yes/no) into the decision they answered rather than logging a standalone entry; skip pure-noise turns (slash-command plumbing) unless they ended in a question worth recalling. The file is **conv-scoped** — seeded fresh each conv (header carries `Conv NNN · MACHINE`). It is a convenience log, not a source of truth: PLAN.md / CURRENT-TASKS.md / git history remain authoritative. `/r-end` may read it as a recap source.

---

## Baseline Verification — incident detail

The two incidents behind CLAUDE.md §Baseline Verification (also in `memory/feedback_verify_baselines_in_conv.md`):

- **Conv 104 (astro-check gate):** discovered 10 pre-existing type errors in `.astro` pages that had been hidden through Convs 100–103 because `astro check` was never run. `tsc --noEmit` alone does not scan `.astro` files — which is why all five gates are required and `/w-codecheck` bundles them.
- **Conv 101→102 (verify-in-conv):** Conv 101's RESUME-STATE confidently claimed "6399/6399 passing"; Conv 102 ran the suite and found 5 silently-broken session-creation tests (time-fragile `Date.now()+Nh` patterns) that had been failing for an unknown number of convs. Carry-forward claims hide regressions — treat a prior conv's claimed baseline as a hypothesis until re-verified.

---

## Page Provenance — detection & component provenance

Detail behind CLAUDE.md §Page Provenance (full convention + detection sweep + examples: `docs/as-designed/matt-provenance.md § 11`).

| Marker | Meaning |
|--------|---------|
| `@stand-in` | Legacy-rehost page awaiting retrofit (transient). |
| `@matt-source <nodeId>` | 1:1 port from a Matt Figma frame (may list multiple nodeIds). |
| `@matt-inspired` | Built with Matt tokens/primitives/design language; no source Figma frame. |

**When retrofitting `@stand-in` → `@matt-inspired`,** scan for primitive candidates BEFORE writing inline JSX (see `memory/feedback_scan_for_primitive_candidates_on_retrofit.md`). Component-level provenance (`@matt-source` on `.tsx` primitives) is a separate axis — page markers don't propagate to children, and Phase-6-extrapolated components don't carry page markers. `dev/*` pages opt out of the convention entirely.

---

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

---

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
| `MacMiniM4Pro` | Mac Mini M4 Pro (64GB) | Local + Remote | Local + Remote |
| `MacMiniM4` | Mac Mini M4 (24GB) | Local + Remote | Local + Remote |

Both machines have identical, full capabilities. See `docs/as-designed/devcomputers.md` for details.

---

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
