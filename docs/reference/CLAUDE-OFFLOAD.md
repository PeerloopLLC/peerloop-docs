# CLAUDE-OFFLOAD.md - Extended Documentation

Sections moved from `CLAUDE.md` to keep the always-loaded file lean. Each section's CLAUDE.md stub carries a one-line summary + back-link here. Behavioral rules stayed in CLAUDE.md; this file holds procedures, command catalogs, directory trees, and reference tables.

---

## Dual-Repo Architecture

Peerloop uses two sibling repositories:

```
~/projects/
├── peerloop-docs/    ← CC home (this repo) + Obsidian vault
│   ├── .claude/      # All CC configuration, commands, hooks
│   ├── CLAUDE.md     # This file (behavioral rules + project context)
│   └── docs/         # Sessions, reference (incl. memory-archive/), as-designed, requirements, guides (see docs/INDEX.md)
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
| `/w-codecheck` | Fast static code-quality checks (commit-safety; no test/build) |
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

The test suite is one of five gates that constitute a baseline check — see CLAUDE.md §Baseline Verification for the full set and the verify-in-THIS-conv discipline. **`npm run verify` is the authoritative baseline command** that runs all five (plus `check:tokens`/`check:icons`); `/w-codecheck` is the faster *commit-safety* pass and does **not** run `test`/`build`.

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

The two incidents behind CLAUDE.md §Baseline Verification (also in `docs/reference/memory-archive/feedback_verify_baselines_in_conv.md`):

- **Conv 104 (astro-check gate):** discovered 10 pre-existing type errors in `.astro` pages that had been hidden through Convs 100–103 because `astro check` was never run. `tsc --noEmit` alone does not scan `.astro` files — which is why all five gates are required; the authoritative command that runs them is `npm run verify` (`/w-codecheck` is the faster commit-safety subset — static only, no `test`/`build`).
- **Conv 101→102 (verify-in-conv):** Conv 101's RESUME-STATE confidently claimed "6399/6399 passing"; Conv 102 ran the suite and found 5 silently-broken session-creation tests (time-fragile `Date.now()+Nh` patterns) that had been failing for an unknown number of convs. Carry-forward claims hide regressions — treat a prior conv's claimed baseline as a hypothesis until re-verified.

---

## Page Provenance — detection & component provenance

Detail behind CLAUDE.md §Page Provenance (full convention + detection sweep + examples: `docs/as-designed/matt-provenance.md § 11`).

| Marker | Meaning |
|--------|---------|
| `@stand-in` | Legacy-rehost page awaiting retrofit (transient). |
| `@matt-source <nodeId>` | 1:1 port from a Matt Figma frame (may list multiple nodeIds). |
| `@matt-inspired` | Built with Matt tokens/primitives/design language; no source Figma frame. |

**When retrofitting `@stand-in` → `@matt-inspired`,** scan for primitive candidates BEFORE writing inline JSX (see `docs/reference/memory-archive/feedback_scan_for_primitive_candidates_on_retrofit.md`). Component-level provenance (`@matt-source` on `.tsx` primitives) is a separate axis — page markers don't propagate to children, and Phase-6-extrapolated components don't carry page markers. `dev/*` pages opt out of the convention entirely.

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

---

## Situational Notes Archive (retired MEMORY.md index)

> **The `MEMORY.md` auto-memory system was retired (Conv 456).** Its detail sub-files were relocated wholesale to `docs/reference/memory-archive/` (git-tracked, on-demand — **not** auto-loaded). This is the old MEMORY.md pointer index, repointed at the archive, kept so a future CLAUDE.md prune can decide entry-by-entry what is still current. Always-on **rules** already live in `CLAUDE.md`; these pointers are situational recall + incident history only. The archive dir also holds ~40 files that were never in this index (orphans) — `ls docs/reference/memory-archive/` for the full set.

### Rule detail & incident-history (behind CLAUDE.md rules)

- [feedback_option_phrasing](memory-archive/feedback_option_phrasing.md) — §User-Facing Questions detail: malformed-question archaeology (Convs 132/147/208/263) + QLINT Stop-hook build-then-retire + Conv 273 switch to AskUserQuestion.
- [feedback_pause_on_pointing_questions](memory-archive/feedback_pause_on_pointing_questions.md) — §Recurring-Failures #2 detail: 👉👉👉/decision must be last visible content; Conv 125 reorder example.
- [feedback_conversational_brevity](memory-archive/feedback_conversational_brevity.md) — §Explanatory Style detail: Conv 150 screen-buffer rationale; [MCFRAME] steer-don't-re-ask (Conv 199); Conv 306 work-progress extension.
- [feedback_audit_surface_findings_first](memory-archive/feedback_audit_surface_findings_first.md) — §Investigative Framings detail: Conv 206 [MEM-AUDIT] motivating quote + CC-sees-findings-first asymmetry + edge cases.
- [feedback_explicit_approval_not_inferred](memory-archive/feedback_explicit_approval_not_inferred.md) — §Critical Rule (Consent discipline) detail: Conv 300 scratch-folder-flip incident; bar HIGHER right after a miss.
- [feedback_no_simplest_fix](memory-archive/feedback_no_simplest_fix.md) — §Solution Quality detail: Conv 100 principle quote + drift signal-lists.
- [feedback_default_durable_no_ask](memory-archive/feedback_default_durable_no_ask.md) — §Solution Quality/§Critical Rule detail: multi-conv-scope counter-case + Conv 131 [TDS-AUTH] precedent.
- [feedback_surface_and_track_all_issues](memory-archive/feedback_surface_and_track_all_issues.md) — §Issue Surfacing detail: Sessions 386/390 + Conv 340 incidents; self-monitoring trigger words; "I'll handle at /r-end" = no-op promise.
- [feedback_current_tasks_persistence](memory-archive/feedback_current_tasks_persistence.md) — §Task Persistence detail: CURRENT-TASKS.md IS the state — write-through, no Task-tool overlay. [CURTASKS] 350-352, detach 406.
- [feedback_todowrite_mnemonic_codes](memory-archive/feedback_todowrite_mnemonic_codes.md) — §Task Persistence detail: code format/derivation/collision (`[GE]`→`[GE2]`); Conv 135 origin.
- [feedback_rend_discipline](memory-archive/feedback_rend_discipline.md) — §Conv Lifecycle detail: Conv 062 vanished-alert incident; Conv 108 r-commit-autonomous / r-end-needs-approval change.
- [feedback_git_dash_c_enforcement](memory-archive/feedback_git_dash_c_enforcement.md) — §Dual-Repo detail: Conv 109 wrong-repo near-miss; tilde-literal dodges `$VAR` simple_expansion; Conv 214 [GUARD-VERIFY].
- [feedback_no_tool_call_spam_loops](memory-archive/feedback_no_tool_call_spam_loops.md) — §Guards detail: Conv 218 ~420K-token Read-spam incident; [TERM-GARBLE] carve-out.
- [feedback_no_paste_tokens_in_chat](memory-archive/feedback_no_paste_tokens_in_chat.md) — §Guards detail: Conv 113 CF-token + Conv 144 Stripe-key leaks; unsafe-patterns list; safe-alternatives table; leak-response.
- [feedback_external_source_of_truth_first](memory-archive/feedback_external_source_of_truth_first.md) — §Guards detail: [VDF]/[MFM]/[STOR][DTU]/[EMP]; Convs 178-180.
- [feedback_verify_baselines_in_conv](memory-archive/feedback_verify_baselines_in_conv.md) — §Baseline Verification detail: Conv 101→102 (5 time-fragile tests) + Conv 104 (astro-check gate).
- [feedback_memory_index_load_bearing](memory-archive/feedback_memory_index_load_bearing.md) — §Memory detail: one-liners expose distinctive markers; `[link]` label convention; index-vs-body drift discipline.
- [user_hands_off_pilot_workflow](memory-archive/user_hands_off_pilot_workflow.md) — §User WIP File detail: "CC is sole author" implications; USER-WIP.md carve-out (CC read-only).
- [feedback_assess_ask_before_acting](memory-archive/feedback_assess_ask_before_acting.md) — Conv 407: surface scope choices as questions; a changed premise ⇒ full-doc rewrite.
- [feedback_retest_task_premise_before_executing](memory-archive/feedback_retest_task_premise_before_executing.md) — [PREMISE] verify against CONSUMERS not the definition; measure visuals live. Convs 418-421.

### Dual-repo & environment

- [project_route_gen_cross_repo](memory-archive/project_route_gen_cross_repo.md) — route-doc regen writes BOTH repos; `git status` both before commit. Conv 201.
- [feedback_db_setup_shorthand](memory-archive/feedback_db_setup_shorthand.md) — "run the {local/staging} D1 {level} script" → `npm run db:setup:{target}:{level}`.
- [project_schema_edit_remote_d1_propagation](memory-archive/project_schema_edit_remote_d1_propagation.md) — [D1-SCHEMA-REMOTE] `0001_schema.sql` edits don't reach an already-migrated remote D1 → `ALTER TABLE ADD COLUMN`. Conv 394.
- [project_wrangler_exact_pin_miniflare_dedupe](memory-archive/project_wrangler_exact_pin_miniflare_dedupe.md) — [MF-SKEW] `wrangler` EXACT-pinned 4.112.0 (miniflare dedupe). Conv 416.
- [project_code_repo_shared_with_client](memory-archive/project_code_repo_shared_with_client.md) — [TC-BRANCH-GATE] CODE repo is SHARED with the client — allowlist `^jfg-dev`. Conv 396.
- [project_task_tools_child_session_leak](memory-archive/project_task_tools_child_session_leak.md) — [TASK-TOOLS-VERIFY] Task*/TodoWrite killed by an undocumented server gate → write-through CURRENT-TASKS.md. Convs 403-406.

### Navigation & UI

- [feedback_orphaned_components_survive_migration](memory-archive/feedback_orphaned_components_survive_migration.md) — [ORPHAN-DETECT] route migrations orphan page components while gates stay GREEN — verify route-reachability. Convs 339/391/392.
- [reference_icon_system](memory-archive/reference_icon_system.md) — [ICN-NS] 3 icon systems (legacy RETIRED Conv 370); `MattIcon` canonical, kebab-name-wins.
- [project_navigation_architecture](memory-archive/project_navigation_architecture.md) — AppLayout (Matt shell) canonical since ROUTE-FLIP (Conv 197); mind which shell + `startsWith` active-match.
- [reference_astro_slot_forwarding](memory-archive/reference_astro_slot_forwarding.md) — Astro Fragment-slot forwarding suppresses child `<slot>FALLBACK`; fix = defaults at layout consumer. Conv 175 [MSH-VIZ].
- [reference_tailwind_intellisense_canonical_suggestions](memory-archive/reference_tailwind_intellisense_canonical_suggestions.md) — Tailwind `suggestCanonicalClasses` arbitrary-`[Npx]`→scale warnings: REJECT ([DEMO-HOME] 4× bug class). Conv 371.

### Testing & PLATO

- [feedback_full_test_output](memory-archive/feedback_full_test_output.md) — Full suite `npm test 2>&1 | tee /tmp/lastFullTestRun.log` (~3min); `--testNamePattern` for iterative fixes.
- [e2e-testing-patterns](memory-archive/e2e-testing-patterns.md) — After `page.goto()` add `waitForLoadState('networkidle')` for `client:load` islands.
- [feedback_no_test_artifacts_in_prod](memory-archive/feedback_no_test_artifacts_in_prod.md) — No dev-only testing infra in production code; two browser vendors for multi-user testing.
- [feedback_test_import_cleanup](memory-archive/feedback_test_import_cleanup.md) — After writing a test file, quick-pass to remove unused imports/variables.
- [plato-context](memory-archive/plato-context.md) — **Load when** PLATO/browser-run/STUMBLE-AUDIT/BrowserIntent discussed.
- [feedback_dom_truth_over_screenshots](memory-archive/feedback_dom_truth_over_screenshots.md) — Precise layout/position: trust DOM + dev log, NOT screenshots. Conv 191.
- [reference_responsive_iframe_harness](memory-archive/reference_responsive_iframe_harness.md) — [MINWIDTH][SIDEBAR-COLLIDE] responsive testing = exact-SIZE same-origin IFRAME. Conv 367/368.
- [reference_chrome_bridge_island_stale_cache](memory-archive/reference_chrome_bridge_island_stale_cache.md) — [BRIDGE-MEM] client-gated islands need dev-login + hard nav + settle-read; [STALE-301]. Convs 258/379/408.
- [reference_playwright_headless_browser_fallback](memory-archive/reference_playwright_headless_browser_fallback.md) — [BRIDGE-OK-USE-LOCALHOST] always `localhost:4321`; [BRIDGE-OFFSCREEN-WINDOW] off-screen window renders BLACK. Convs 413/424/425.
- [reference_chrome_bridge_connection_recovery](memory-archive/reference_chrome_bridge_connection_recovery.md) — [BRIDGE-CONNECT] "extension is not connected" recovery ritual; try ~2× then STOP. Conv 450.
- [feedback_plato_expect_is_legacy_spec](memory-archive/feedback_plato_expect_is_legacy_spec.md) — PLATO `expect`/`pageAction` = frozen LEGACY spec; triage REDESIGN/REGRESSION/NEVER-EXISTED first. Conv 343.
- [feedback_persistent_dev_server_4321](memory-archive/feedback_persistent_dev_server_4321.md) — NO persistent dev server (retired Conv 366) — EPHEMERAL `npm run dev` on demand.
- [reference_devserver_stale_daemon](memory-archive/reference_devserver_stale_daemon.md) — [DEVSRV-STALE] 3 brick variants via one `curl`; astro-7 `npm run dev` daemonizes; NEVER port-kill. Conv 429.
- [feedback_codecheck_moment_includes_tests_and_build](memory-archive/feedback_codecheck_moment_includes_tests_and_build.md) — `/w-codecheck` = decision point: also weigh prov-sweep + full suite + build. Conv 207.
- [feedback_pipefail_when_teeing_verify](memory-archive/feedback_pipefail_when_teeing_verify.md) — `verify`/`test`/`build` piped `| tee | tail` returns TAIL's exit (0), hiding failures. Conv 443 [TBK].
- [feedback_tailwind_arbitrary_class_stale_on_viewtransition](memory-archive/feedback_tailwind_arbitrary_class_stale_on_viewtransition.md) — newly-added arbitrary Tailwind class can compute to 0 on the ClientRouter swap path → restart dev server. Conv 443.
- [plato_walk_mocked_service_divergence](memory-archive/plato_walk_mocked_service_divergence.md) — [PLATO-SEQ] browser-walk row-identity EXCLUDES `notifications`; [PSA-WAITUNTIL] fixed Conv 384.

### Output & terms

- [feedback_pointing_emoji_prefix](memory-archive/feedback_pointing_emoji_prefix.md) — Stub anchor — 👉👉👉 + bold rule lives in CLAUDE.md §User-Facing Questions.
- [feedback_visual_issue_alerts](memory-archive/feedback_visual_issue_alerts.md) — Stub anchor — 🔴🔴🔴 / 🟠🟠🟠 issue-alert rule lives in CLAUDE.md §Issue Surfacing.
- [feedback_mirror_term_annotation](memory-archive/feedback_mirror_term_annotation.md) — Say "mirror (from last r-end)" not bare "mirror". Conv 228. *(Obsolete post-Conv-456: mirror system removed.)*
- [reference_term_garble_upstream_bug](memory-archive/reference_term_garble_upstream_bug.md) — [TERM-GARBLE] blank/partial tool output + confabulated failure = OPEN upstream CC bug. Conv 227.
- [feedback_routing_addressability_first](memory-archive/feedback_routing_addressability_first.md) — Route shape = decide ADDRESSABILITY not page-count; transient confirmations → overlays. Conv 187.
- [feedback_afk_nudge_disabled](memory-archive/feedback_afk_nudge_disabled.md) — [AFK-CFG] AskUserQuestion 60s auto-proceed nudge disabled; non-answer/timeout ≠ consent. Conv 361.
- [feedback_chat_vs_tooling_output_separation](memory-archive/feedback_chat_vs_tooling_output_separation.md) — [CHATSEP] `verbose:false` in PROJECT settings + `chat-replay.sh`; `/focus`/fullscreen REJECTED. Conv 395.
- [feedback_mouse_disabled_picker_misclick](memory-archive/feedback_mouse_disabled_picker_misclick.md) — [MOUSE-GUARD] `CLAUDE_CODE_DISABLE_MOUSE`=1 is DELIBERATE — NEVER re-enable. Conv 395.

### Docs & memory discipline

- [feedback_check_docs_on_how_questions](memory-archive/feedback_check_docs_on_how_questions.md) — On "how does X work" questions, check docs too; offer doc update if answer needed heavy searching.
- [reference_generated_doc_regen](memory-archive/reference_generated_doc_regen.md) — [DOCGEN] route maps = generated docs, auto-regen at r-end Step 5c; `route-stories.md` is hand-written. Conv 246.
- [feedback_read_legacy_source_before_conclusion](memory-archive/feedback_read_legacy_source_before_conclusion.md) — Review/compare/port → fully read BOTH sides (esp. legacy `/old` SoT) BEFORE concluding. Conv 222.
- [feedback_check_memory_before_directive_save](memory-archive/feedback_check_memory_before_directive_save.md) — Before offering to save a directive, grep the memory dir for an existing entry. *(Obsolete post-Conv-456: no memory dir.)*
- [feedback_confirmations_stand_unless_revoked](memory-archive/feedback_confirmations_stand_unless_revoked.md) — User-confirmed sub-decisions survive later topic pivots; sticky until user names the item to revoke.
- [feedback_msi_sync_user_checkpoint](memory-archive/feedback_msi_sync_user_checkpoint.md) — /r-start Step 5.7 mirror-vs-live checkpoint. Conv 155-156. *(Obsolete post-Conv-456: sync removed.)*
- [feedback_fix_docs_inline_not_rend](memory-archive/feedback_fix_docs_inline_not_rend.md) — Fix stale doc refs INLINE same-conv; do NOT defer to /r-end. Conv 286 [TW-V4].

### Skills & planning

- [feedback_skill_body_stale_after_self_pull](memory-archive/feedback_skill_body_stale_after_self_pull.md) — A skill's in-context body = pre-pull SNAPSHOT; re-read on-disk after a pull updates SKILL.md. Conv 218.
- [feedback_uncategorized_filtering](memory-archive/feedback_uncategorized_filtering.md) — Extract §Uncategorized: "not a bug"/"no action needed" doesn't belong there.
- [feedback_exploration_pacing](memory-archive/feedback_exploration_pacing.md) — After Phase 1 establishes patterns, Phase N+1 writes code — do NOT re-explore. Conv 057.
- [feedback_plan_mode](memory-archive/feedback_plan_mode.md) — CC Plan Mode: VERIFY/stress-test designs; plan files EPHEMERAL → persist durable plans. Conv 055-056.
- [feedback_skill_sync_same_name_divergence](memory-archive/feedback_skill_sync_same_name_divergence.md) — Same-named skills across projects often diverge — default to "evolve independently".
- [feedback_heuristic_calibration](memory-archive/feedback_heuristic_calibration.md) — New detection heuristic/threshold MUST run against the canonical case BEFORE commit. Conv 142 [CMH].
- [feedback_cleanup_step](memory-archive/feedback_cleanup_step.md) — Every PLAN block ends with a Cleanup phase.
- [feedback_infra_vs_deliverable](memory-archive/feedback_infra_vs_deliverable.md) — Building test infra: pause to check generalizable vs special-cased.
- [feedback_decompose_by_cohesion_not_pseudo_isolation](memory-archive/feedback_decompose_by_cohesion_not_pseudo_isolation.md) — Split by cohesion (vertical slices), NOT fragments. Conv 271.
- [feedback_watch_task_assumptions](memory-archive/feedback_watch_task_assumptions.md) — Watch-tasks state the assumed precondition in subject; audit falsifies it FIRST. Conv 149-150 [OPW].
- [rename-lessons](memory-archive/rename-lessons.md) — **Load when** planning a large rename (>50 files): baseline tests first; macOS `sed` lacks `\b` → `perl -pi -e`.
- [feedback_rend_complete_all_steps](memory-archive/feedback_rend_complete_all_steps.md) — **RECURRING FAILURE:** /r-end must execute ALL steps without stopping after /r-eos. Convs 006/019/026/027.

### Security & Figma

- [figma-context](memory-archive/figma-context.md) — **Load when** Figma/design-token work. GUARDRAIL: Figma READ-ONLY — NEVER call write-shaped `mcp__figma__*` [MNV].

### References

- [reference_spt_dual_repo](memory-archive/reference_spt_dual_repo.md) — `spt`/`spt-docs` is a sibling dual-repo; `r-end-soft`/etc. live THERE not here.
- [reference_staging_url](memory-archive/reference_staging_url.md) — Staging: `peerloop-staging.brian-1dc.workers.dev` · slug `brian-1dc` · D1 `peerloop-db-staging`.
- [reference_cf_data_recovery](memory-archive/reference_cf_data_recovery.md) — CF recovery floors: D1 30d Time Travel; R2 Bucket Locks + backup-copy; KV no PITR. Conv 212.
- [feedback_staging_is_deploy_target_prod_gated](memory-archive/feedback_staging_is_deploy_target_prod_gated.md) — [Deploy] staging is the ONLY deploy target; NEVER `deploy:prod`. Conv 262.

### Project context

- [project_spacing_snap_over_matt_exception](memory-archive/project_spacing_snap_over_matt_exception.md) — SPACING axis: off-scale `@matt-source` spacing SNAPS to nearest 4px (ties round UP). Conv 305.
- [project_role_studios_deconstruct_nudges](memory-archive/project_role_studios_deconstruct_nudges.md) — [ROLE-STUDIOS] `/dashboard`→role workspaces + nudges. Conv 252/317/339/392.
- [project_matt_phaseout_inspired_default](memory-archive/project_matt_phaseout_inspired_default.md) — Matt phase-out: Figma LAYOUT-ONLY; pages default `@matt-inspired`, NEVER lose `/old` function. Conv 239/289.
- [project_route_404_honesty_standin](memory-archive/project_route_404_honesty_standin.md) — Route migration: unconverted pages must 404; `@stand-in` = TRANSIENT marker. Conv 203.
- [project_old_pages_no_delete_until_vetted](memory-archive/project_old_pages_no_delete_until_vetted.md) — RTMIG-4 ports MOVE `/old/X`→`/X` as `@stand-in`; 74 `/old` pages need per-page vetting. Conv 250/338.
- [feedback_port_functionality_and_styling](memory-archive/feedback_port_functionality_and_styling.md) — legacy→Matt port = faithful function+content AND full Matt styling; diff field-by-field. Conv 222.
- [feedback_route_sweep_pause_protocol](memory-archive/feedback_route_sweep_pause_protocol.md) — ROUTE SWEEP (RTMIG-4): every route swept, 8-step PAUSE process → `[<ROUTE>-FIXES]` capture.
- [feedback_scan_for_primitive_candidates_on_retrofit](memory-archive/feedback_scan_for_primitive_candidates_on_retrofit.md) — Retrofitting `@stand-in`→`@matt-inspired`: scan for existing primitive candidates BEFORE inline JSX.
- [project_preflip_worktree_reference](memory-archive/project_preflip_worktree_reference.md) — [PREFLIP-WT] pre-flip worktree reference. *(Note: worktree removed Conv 455.)*
- [project_module_submodule_model](memory-archive/project_module_submodule_model.md) — Session↔Module = 1:1; nested "N Modules" = Sub-Modules. Conv 188 [MOD-SCHEMA].
- [project_timezone_confidence](memory-archive/project_timezone_confidence.md) — Recurring `new Date()` issues; user has LOW confidence TZ handling is correct.
- [project_staging_integration_plan](memory-archive/project_staging_integration_plan.md) — Expand BBB-VERIFY into full staging block (Stream, Resend, Stripe, BBB).
- [project_feeds_hub](memory-archive/project_feeds_hub.md) — [FEEDS] `/`=merged SmartFeed; `/feeds`+`FeedsHub` NO LONGER EXIST (retired Conv 331). Conv 427.
- [project_obsidian_vault_synced](memory-archive/project_obsidian_vault_synced.md) — `~/Obsidian Vaults/main2025/` synced across M4/M4Pro via Obsidian Sync.
- [project_scratch_obsidian_symlink](memory-archive/project_scratch_obsidian_symlink.md) — scratch = REAL `_scratch/` + `.scratch` compat symlink; don't delete/flip. Conv 300.
- [project_ephemeral_dismiss_dev_staging](memory-archive/project_ephemeral_dismiss_dev_staging.md) — Dismissible nudges reappear every reload in dev+staging BY DESIGN. Conv 292.
- [project_settings_tier_local_control](memory-archive/project_settings_tier_local_control.md) — Settings: project `settings.json` + machine-local `settings.local.json`; [SETTINGS-GUARD]. Conv 212.
- [project_jfg_dev_branches_are_snapshots](memory-archive/project_jfg_dev_branches_are_snapshots.md) — `jfg-dev-NN` code branches = intentional SNAPSHOTS — NEVER propose `git branch -d` sweeps. Conv 292.
- [project_old_appnavbar_retire_by_default](memory-archive/project_old_appnavbar_retire_by_default.md) — [OLD-RETIRE-DEFAULT] `/old/*` + AppNavbar = RETIRE-by-default. Conv 331.
- [project_admin_conformance_policy](memory-archive/project_admin_conformance_policy.md) — [ADMIN-CONF-POLICY] RG-ADMIN = dense operational console; relaxations A-D. Conv 331.
- [project_diploma_vs_certificate](memory-archive/project_diploma_vs_certificate.md) — [DIPLOMA] Diploma=course-completion (auto, derived) vs Certificate=teach-readiness. Conv 389.
