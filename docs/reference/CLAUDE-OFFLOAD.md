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
