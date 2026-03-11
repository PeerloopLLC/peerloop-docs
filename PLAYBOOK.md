# PLAYBOOK.md

This document tracks decisions about **how the peerloop-docs repo itself works** — its organization, workflows, conventions, and tooling. For Peerloop application decisions (code, schema, UI), see `docs/DECISIONS.md`.

**Last Updated:** 2026-03-11 Session 373 (w-* prefix for project skills, orphaned command cleanup)

---

## How This Document Works

- **Latest Wins:** If a newer decision contradicts an older one, only the newer decision appears here
- **Organized by Category:** Repo architecture, CC workflow, Obsidian, conventions
- **Dates Included:** Each decision shows when it was made and which session
- **Source:** Consolidated from session decision files in `docs/sessions/`
- **Updated By:** `/w-learn-decide` emits docs-repo decisions here

---

## 1. Repo Architecture

### Dual-Repo: Docs Separated from Code
**Date:** 2026-02-20 (Session 229 planned, Session 232 implemented)

All documentation (~899 files, ~19 MB) lives in `peerloop-docs`. Application code lives in `Peerloop`. Two sibling repos in the same parent directory.

**Trigger:** Code repo cluttered with ~861 documentation files that don't belong in a shipping codebase. Client needs a clean code repo.

**Options Considered:**
1. Keep everything in one repo (status quo)
2. Symlink repo folders INTO an Obsidian vault
3. Move docs OUT of repo into a vault, symlink back ← Chosen
4. Copy/sync approach between two locations

**Rationale:** Docs repo doubles as Obsidian vault. Claude Code follows symlinks transparently. Code repo reduced 69% (27.6 MB → 8.6 MB). Client gets browsable knowledge base as separate deliverable.

**See:** Session 232 Decisions.md

### Docs Repo as CC Home
**Date:** 2026-02-20 (Session 232)

Claude Code launches from `peerloop-docs/` with `--add-dir ../Peerloop`. The `.claude/` directory, CLAUDE.md, hooks, commands, and config all live here.

**Launch pattern:** `cd ~/projects/peerloop-docs && claude --add-dir ../Peerloop`

**Rationale:** CC home should be where the most context lives. Documentation, research, planning, and session history provide richer project context than code alone. `--add-dir` grants full tool access to the code repo.

**Consequence:** `$CLAUDE_PROJECT_DIR` always resolves to `peerloop-docs/`. Hooks referencing code repo must use `$CLAUDE_PROJECT_DIR/../Peerloop/...`.

### Same GitHub Organization
**Date:** 2026-02-20 (Session 229)

Both repos hosted in `PeerloopLLC` GitHub org.

**Rationale:** Both repos discoverable together. Client already has org access. Simplest permission model.

### Relative Symlinks for Portability
**Date:** 2026-02-20 (Session 229)

All cross-repo symlinks use relative paths (`../peerloop-docs/docs`, not `~/projects/peerloop-docs/docs`).

**Options Considered:**
1. Absolute paths — tied to specific home directory
2. Relative paths ← Chosen
3. Environment variable paths — adds complexity

**Rationale:** Works on any machine where both repos are cloned into the same parent directory. No hardcoded home directory paths. `scripts/link-docs.sh` creates the symlinks.

### Symlinks Over Copies for Build Dependencies
**Date:** 2026-02-20 (Session 232)

Code repo has symlinks (`Peerloop/docs → ../peerloop-docs/docs`, `Peerloop/research → ../peerloop-docs/research`) created by `scripts/link-docs.sh` and gitignored.

**Options Considered:**
1. Modify build scripts to accept configurable paths
2. Symlink docs/ and research/ back into code repo ← Chosen
3. Copy files as a build step

**Rationale:** Symlinks transparent to Node.js/Vite/Astro with zero code changes. Build (0 errors) + full test suite (4891 assertions) pass without script modifications.

### CLAUDE.md as Symlink
**Date:** 2026-02-20 (Session 229)

Code repo's CLAUDE.md is a symlink to `../peerloop-docs/CLAUDE.md`. No pre-testing required — symlink resolution is an OS-level guarantee.

**Fallback:** If CC ever fails to follow the symlink, replace with a real file containing a pointer to the docs repo.

### GLOSSARY.md: Root-Level Terminology Reference
**Date:** 2026-03-05 (Session 346)

Created `GLOSSARY.md` at docs repo root as the prescriptive source of truth for all platform terminology. Covers identity hierarchy (Visitor → Member → Student → Teacher → Creator → Moderator → Admin), core domain terms, DB table naming targets, component naming conventions, and ambiguous terms to avoid.

**Trigger:** Naming inconsistencies across code, schema, and docs caused real bugs and made the codebase harder to navigate. "Student-Teacher" vs "Teacher" was the highest-impact example that prompted the glossary.

**Governance:** If code contradicts the glossary, the code is the bug. New terms must be added to the glossary before being used. Historical session docs are exempt from retroactive updates.

**See:** `docs/GLOSSARY.md`, `docs/DECISIONS.md` §1 (three related decisions)

---

## 2. Folder Structure

### Repository Layout
**Date:** 2026-02-20 (Session 232, updated Session 233)

```
peerloop-docs/
├── .claude/                  # CC configuration
│   ├── commands/             # Slash commands (project-specific -local variants)
│   ├── hooks/                # SessionStart hooks
│   ├── settings.json         # Permissions & hook config
│   └── config.json           # Project paths & feature flags
├── .obsidian/                # Obsidian vault config (gitignored, local per user)
├── CLAUDE.md                 # Full project guidance for CC
├── PLAN.md                   # Current & pending work
├── COMPLETED_PLAN.md         # Completed work
├── PLAYBOOK.md               # This file — docs repo decisions
├── SESSION-INDEX.md          # Session log index
├── docs/
│   ├── sessions/             # Development session logs (by month)
│   ├── DECISIONS.md          # Peerloop application decisions
│   ├── GLOSSARY.md           # Platform terminology
│   ├── POLICIES.md           # Platform behavior policies
│   ├── reference/            # CLI, API, testing docs, coding standards
│   ├── vendors/              # Vendor/service decision docs
│   ├── architecture/         # Architecture & design docs
│   └── guides/               # How-to guides
├── research/
│   ├── GOALS.md              # Mission & success metrics
│   ├── USER-STORIES.md       # All user stories (370+)
│   ├── DB-GUIDE.md           # Database design rationale & relationships
│   ├── DB-SCHEMA.md          # Database entities (DEPRECATED)
│   ├── DB-API.md             # Internal API endpoints
│   ├── REMOTE-API.md         # External service APIs
│   ├── COMPONENTS.md         # UI component library
│   ├── run-001/              # Implementation scenario
│   └── stories/              # User stories by role
├── RFC/
│   ├── INDEX.md              # RFC lookup table
│   └── CD-XXX/               # Individual change requests
└── scripts/
    └── link-docs.sh          # Symlink setup for code repo
```

### What Goes Where

| Content Type | Location | Committed? |
|-------------|----------|:----------:|
| CC commands, hooks, config | `.claude/` | Yes |
| Obsidian vault config | `.obsidian/` | No |
| Application decisions | `docs/DECISIONS.md` | Yes |
| Docs-repo decisions | `PLAYBOOK.md` | Yes |
| Current/pending work | `PLAN.md` | Yes |
| Session logs | `docs/sessions/YYYY-MM/` | Yes |
| Technology decisions | `docs/vendors/*.md`, `docs/architecture/*.md` | Yes |
| Specifications & schemas | `research/` | Yes |
| Client change requests | `RFC/CD-XXX/` | Yes |
### Docs Folder Reorganization: vendors/ + architecture/
**Date:** 2026-03-09 (Session 362)

Split `docs/tech/` into `docs/vendors/` (19 files — external service/library decisions) and `docs/architecture/` (13 files — internal design patterns). Dropped `tech-0XX-` numbering prefix, using descriptive names (e.g., `stripe.md`, `state-management.md`). Moved 9 root files to appropriate folders (DECISIONS.md, GLOSSARY.md, POLICIES.md → `docs/`; BEST-PRACTICES.md → `docs/reference/`; navigation docs → `docs/architecture/`; USER-STORIES-MAP.md → `research/`).

**Trigger:** `docs/tech/` had drifted to contain both vendor evaluations and internal architecture docs. Deciding where new docs should go required guessing.

**Consequences:** 42 files moved, ~200 references updated across ~65 files. Session logs left unchanged — `docs/DOCS-REORG-MAP.md` serves as old→new path lookup. Config updated: `techDocs` key in `.claude/config.json` replaced with `vendorDocs` + `architectureDocs`.

> **Insight:** Three reorganizations in this project followed the same pattern: incremental drift → cognitive threshold → systematic reorganization (terminology ~960 files, page specs ~312 files, docs folders ~65 files). The mapping document is the critical artifact — it costs nothing to create and makes the historical record navigable forever. (Session 362)

### Session Logs Immutable During Reorganizations
**Date:** 2026-03-09 (Session 362)

When reorganizing folder structure or renaming files, session logs are NOT updated. They reference the paths that existed at the time. A mapping document (`docs/DOCS-REORG-MAP.md`) provides old→new lookup.

**Rationale:** Session logs are historical records. Changing paths retroactively makes them less accurate. The terminology block (Sessions 346-356) updated session logs, but that was a content change (wrong terms), not a structural reorganization.

### No Archive Folders — Use Git History
**Date:** 2026-02-28 (Session 311)

When deleting large batches of files, do not archive them into an `archive/` subfolder. Git history preserves everything with full commit context. Archive folders just move clutter around and create their own maintenance burden (references to update, contents to eventually question again).

**Rationale:** Sessions 307-311 progressively archived 312 PageSpec files (17MB) into `docs/archive/`, then deleted the archive entirely when it proved useless. Skip the intermediate step in future.

---

## 3. Claude Code Workflow

### Dual-Repo Commit Workflow
**Date:** 2026-02-20 (Session 232)

When changes span both repos, commit code first, then docs. Both commits use the same session number.

| Scenario | Action |
|----------|--------|
| Code changes only | `git -C ../Peerloop add . && git -C ../Peerloop commit` |
| Doc changes only | `git add . && git commit` |
| Both repos changed | Code first, then docs |

**Rationale:** Code commits may trigger CI. Docs commits are follow-up context. Same session number links them for traceability.

### Session File Naming Convention
**Date:** 2026-02-20 (Session 229)

All session files use the format `YYYY-MM-DD_HH-MM-SS {Type}.md` where Type is `Dev`, `Learnings`, or `Decisions`. Files within the same session share the same timestamp.

**Trigger:** Learnings/Decisions files initially used `YYYYMMDD-HHMM` format while Dev used `YYYY-MM-DD_HH-MM-SS`. Inconsistency caused confusion.

**Rationale:** Single format, shared timestamp groups related files together in directory listing.

### Session Logs Are Immutable Historical Records
**Date:** 2026-02-27 (Session 307)

Session files in `docs/sessions/` are never modified after creation. They document what happened at that point in time, including file paths, decisions, and references that may later become stale.

**Trigger:** STORY-REMAP stale reference audit found ~200 mentions of deprecated `src/data/pages/` paths in old session logs. Question: should they be updated?

**Decision:** No. Editing session logs to remove stale references rewrites history and undermines their value as an audit trail.

**Rationale:** Session logs are like commit messages — they describe the state of the world at the time. Stale references in old sessions are expected and correct.

### CC Hooks Run in Minimal Shell
**Date:** 2026-02-20 (Session 229)

Claude Code hooks execute in a minimal shell that does NOT source `~/.zshrc` or `~/.bash_profile`. Tools managed by nvm, Homebrew (`/opt/homebrew/bin`), or other profile-dependent managers are invisible.

**Pattern:** Hook scripts must explicitly source dependencies:
```bash
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
```

**Consequence:** Diagnostic/informational hooks should always `exit 0`. Non-zero exits are treated as errors by CC.

### w-git-history: Per-Commit Machine and Repo Tags
**Date:** 2026-02-21 (Session 237)

`/w-git-history` now includes machine name and repo identifier on every commit entry. Previously, `Machine:` lines were filtered out and the repo name was only in a section header.

**Changes:**
- `Machine:` lines no longer excluded — rendered as a regular bullet per commit
- `(code)` or `(docs)` tag appended to each commit's datetime header line

**Trigger:** Timecards combining commits from both repos (via `/w-timecard`) didn't show which computer or which repo each commit came from.

**Rationale:** The data was already in every commit body (`Machine:` footer from `/q-commit-local`) and inherent to the git directory (`repo=` argument). Fixing the display layer is retroactive — all existing commits benefit with no format changes needed.

**See:** `~/.claude/commands/q-git-history.md`

### CURRENT-BLOCK-PLAN.md for Multi-Session Blocks
**Date:** 2026-02-24 (Session 276)

For blocks too large for one session, create `CURRENT-BLOCK-PLAN.md` at the docs repo root. Contains checkboxes for every item, key files table, and progress summary updated each session. Deleted when block completes.

**Trigger:** BBB block has 5 sub-blocks with ~25 items. PLAN.md is too high-level for per-item tracking. RESUME-STATE.md is session-specific and gets deleted on resume.

**Pattern:** Each session reads the file first, works through unchecked items, updates checkboxes, adds a session progress summary at top. "Next session" guidance tells the next CC instance where to start.

**Automation:** Use `/q-make-block-persistent <BLOCK-NAME>` to extract a block from PLAN.md and write it to `CURRENT-BLOCK-PLAN.md` with a progress table. Global skill (Session 287).

**See:** `CURRENT-BLOCK-PLAN.md` (exists while block is active), `~/.claude/commands/q-make-block-persistent.md`

### w-* Prefix for Project Skills (Disambiguation)
**Date:** 2026-03-11 (Session 373)

All project skills in `.claude/skills/` use the `w-*` prefix. Global commands in `~/.claude/commands/` retain the `q-*` prefix. This eliminates autocomplete collisions where the UI showed both `/q-eos (project)` and `/q-eos (user)`.

**Trigger:** Repeatedly selecting the wrong skill from the ambiguous autocomplete list.

**Pattern:** `w-*` = project-local (this repo only), `q-*` = global (all projects). The prefix makes origin immediately obvious. 13 project skills renamed; global commands unchanged.

**Consequences:** Updated SKILL.md files, CLAUDE.md, PLAYBOOK.md, skills-system.md, DEVELOPMENT-GUIDE.md, detect-changes.sh. Session logs left as-is. Also deleted 3 orphaned `*-local` command files and migrated 2 `L-*` commands to Skills 2 as `w-*` skills. `.claude/commands/` is now empty.

**See:** `docs/architecture/skills-system.md`, Session 373 Decisions.md

### Skills 2 Migration: Merged Single-File Pattern
**Date:** 2026-03-10 (Session 364)

Skills with paired global/local commands (`q-docs.md` + `q-docs-local.md`) are migrated to Skills 2 as a single merged `SKILL.md` in `.claude/skills/<name>/`. Project-specific content is inlined (not in a separate `project.md`), replacing `<!-- PROJECT -->` placeholders from the canonical template.

**Trigger:** Skills 2 directories naturally accommodate both global logic and project config. The old two-file handoff ("REQUIRED: read project.md") was a reliability risk.

**Pattern:** Project `.claude/skills/w-docs/SKILL.md` overrides global `~/.claude/commands/q-docs.md` — unconverted projects keep working. Use `!` backtick injection for helper scripts that pre-compute data at invocation time.

**See:** Session 364 Decisions.md, `~/skills-canon/` repo

### skills-canon Repository for Skill Template Management
**Date:** 2026-03-10 (Session 364)

Canonical skill templates live in `~/skills-canon/` (git repo, GitHub-backed). Each project gets real copies (not symlinks). Drift is managed, not prevented.

**Tools:**
- `drift-report.sh` — section-level divergence detection across projects
- `skill-patch.sh` — interactive surgical sync (pull/push/hunk selection)
- `install.sh` — deploy skills to new projects

**Pattern:** Each project skill directory has a `.sync` file tracking last reconciliation. Canonical templates use `<!-- PROJECT -->` comments for customization points. `CUSTOMIZATION-GUIDE.md` documents what to change per project.

> **Insight:** This is the cathedral vs. bazaar applied to skills — the symlink approach enforces uniformity (cathedral), while real copies with drift tools allow each project to evolve freely and cross-pollinate improvements (bazaar). The `.sync` file does the same job as `git merge-base` — recording a common ancestor for intelligent reconciliation. (Session 364)

### Marker-Anchored Detection for /w-docs
**Date:** 2026-03-10 (Session 365)

`detect-changes.sh` records both repos' HEAD SHAs in `.last-qdocs-run` after each `/w-docs` run. The next run diffs from that marker forward, showing only changes since the last documentation pass.

**Trigger:** `HEAD~5` was arbitrary and pulled in 260+ files from weeks of prior sessions. Time-based `--since` was better but still duplicated work on multi-session days.

**Pattern:** Marker file is committed (not gitignored) so it travels across machines — Mac A documents and commits the marker, Mac B pulls and continues from that point. Falls back to `--since "24 hours ago"` when no marker exists or the SHA isn't found locally. `--reset` flag forces fallback.

**See:** `.claude/skills/w-docs/scripts/detect-changes.sh`, `docs/architecture/skills-system.md`

### Separate Skill for Dual-Repo Timecards
**Date:** 2026-03-10 (Session 369)

`/w-timecard-dual` is a standalone skill rather than a `repo=both` mode on `/w-timecard`. The single-repo skill stays clean and composable; the dual skill handles merge logic (unified header, combined Focus/Client/Work sections, two Git History blocks).

**Rationale:** Extending `/w-timecard` would mean either complex argument handling or chaining to itself — but `/w-timecard` opens the editor as a side effect, making chaining impractical. Compact `c2d3` syntax (regex-parsed, order-independent) keeps invocation fast.

**See:** `.claude/skills/w-timecard-dual/SKILL.md`

### Marker Tracking Not Suitable for Billing-Critical Output
**Date:** 2026-03-10 (Session 369)

Evaluated and rejected adding a `latest` argument to `/w-timecard-dual` that would auto-detect un-timecarded commits via a marker file (same pattern as `.last-qdocs-run`).

**Rationale:** Marker-based tracking works when stale/premature markers have low-cost consequences (detect-changes.sh showing extra files — harmless). For timecards, a premature marker advance means *missing billable work*. The marker would update at generation time but the user might not copy the output. Other issues: no sane first-run fallback, cross-skill coordination between single and dual timecard skills. The explicit `c2d3` count syntax costs ~5 seconds but eliminates state-tracking bugs.

> **Insight:** The suitability of marker-based tracking depends on failure mode asymmetry. "Show too much" (harmless) vs "miss data" (costly) — the same pattern works for one and fails for the other. Always evaluate the consequence of a stale or premature marker before adopting this pattern. (Session 369)

### $CLAUDE_PROJECT_DIR Points to CC Home
**Date:** 2026-02-20 (Session 232)

`$CLAUDE_PROJECT_DIR` always resolves to the project where `.claude/` lives (the CC home, `peerloop-docs/`). It does NOT point to directories added via `--add-dir`.

**Consequence:** Hooks needing code repo paths must use `$CLAUDE_PROJECT_DIR/../Peerloop/...`.

---

## 4. Obsidian Vault

### Local .obsidian/ Per User
**Date:** 2026-02-20 (Session 229)

Each user creates their own `.obsidian/` folder locally. It is gitignored and never committed. Users customize their own themes, plugins, and workspace layout independently.

### Markdown Links Over Wikilinks
**Date:** 2026-02-21 (Session 233)

Obsidian configured with `useMarkdownLinks: true` — standard `[text](path)` format, not `[[wikilinks]]`.

**Rationale:** Files are viewed on GitHub (client deliverable), in Cursor, and in CC context. Standard markdown links render correctly everywhere. Wikilinks only work inside Obsidian.

**Trade-off:** Slightly more verbose link syntax, but full portability.

### Two-Vault Architecture: Personal vs Project
**Date:** 2026-02-21 (Session 233)

Personal Obsidian vault (synced via Obsidian Sync) remains separate from peerloop-docs vault (on GitHub). No consolidation.

**Trigger:** Considered merging personal notes, timecards, and daily notes into peerloop-docs. Client visibility on GitHub prevents this — personal content must not be committed.

**Options Considered:**
1. Single vault with gitignored `_private/` folder — no off-machine backup for private content
2. Single vault with Obsidian Sync + git — two sync mechanisms fighting over same files
3. Two separate vaults ← Chosen

**Rationale:** Each vault has exactly one sync mechanism and one audience. Personal vault uses Obsidian Sync (multi-device, no GitHub). Project vault uses git (version control, client-visible). Clean separation.

**Consequence:** Cross-vault linking not possible in Obsidian. Use searchable conventions (e.g., "Session 233 — see peerloop-docs") for cross-references.

> **Insight:** The temptation to consolidate everything into one system is strong, but access-control boundaries (client-visible vs personal, git-backed vs sync-backed) are non-negotiable. The cleanest architectures respect those boundaries rather than trying to abstract over them. Two vaults with clear responsibilities and a few CC skills bridging the gap is simpler to maintain than one vault with layered privacy rules. (Session 233)

---

## 5. Documentation Conventions

### PLAYBOOK.md for Docs-Repo Decisions
**Date:** 2026-02-21 (Session 233)

`/w-learn-decide` (migrated to Skills 2 in Session 367) routes decisions to the appropriate file:
- **Peerloop application decisions** (code, schema, UI, API) → `docs/DECISIONS.md`
- **Docs-repo decisions** (organization, workflows, CC config, vault) → `PLAYBOOK.md`

Same structured format (trigger, options, rationale, consequences) for both.

> **Insight:** The split between DECISIONS.md and PLAYBOOK.md mirrors a distinction that exists in most software projects but is rarely made explicit: product decisions (what we're building) vs process decisions (how we work). By separating them, each file stays focused and navigable. Because PLAYBOOK.md tracks docs-repo conventions, it becomes a portable reference — if you start a new client project with a similar docs-first architecture, the playbook carries forward as a template. (Session 233)

### Durable Insight Capture
**Date:** 2026-02-21 (Session 233)

During `/w-learn-decide` processing, `★ Insight` blocks are scanned for durable, informative insights. Qualifying insights are co-located with the decision they illuminate as `> **Insight:**` blockquotes.

**Rationale:** Co-locating insights with decisions follows the same principle as co-locating tests with code — the context you need to understand *why* something exists should be as close as possible to the thing itself. Separate files create cross-referencing overhead.

**Qualification:** An insight is durable if it connects a decision to broader professional context, explains why a convention works well beyond the immediate rationale, or would teach someone starting a similar project.

### Dynamic Tech Doc Sweep in /w-docs
**Date:** 2026-03-05 (Session 334), migrated to Skills 2 (Session 364)

`/w-docs` dynamically discovers tech docs (`docs/vendors/*.md`, `docs/architecture/*.md`) and cross-references against code paths changed in the session. No hard-coded mapping to maintain — new tech docs are automatically included. Originally implemented in `/q-docs-local` section 7; now runs as `tech-doc-sweep.sh` helper script via `!` backtick injection.

**Trigger:** Session 334 missed updating `session-booking.md` during `/q-docs` because the existing checklist only triggered on package/config changes, not domain code changes.

**Options Considered:**
1. Hard-coded code-path → tech-doc table — drifts as tech docs are added
2. Hard-coded table + maintenance skill in `/w-eos` — extra step, easy to forget
3. Dynamic sweep: discover docs, match against session changes ← Chosen

**Rationale:** 31 tech docs and growing. Any static mapping becomes stale. The dynamic approach has zero maintenance cost and catches new tech docs automatically. The heuristic matching (code path patterns → topic keywords) doesn't need to be perfect — it's a reminder check, not a gate.

**See:** `.claude/skills/w-docs/scripts/tech-doc-sweep.sh`

### Feature Tracking Rule: All Features Must Be in PLAN.md
**Date:** 2026-03-05 (Session 342)

Any time a feature is mentioned — in a tech doc, session discussion, RFC, or code comment — it must be added to `PLAN.md`. Where it goes is situational (active block, deferred, sub-task of an existing block). If the feature originated from a tech doc, add a cross-reference noting the PLAN block (e.g., "Tracked in PLAN.md: RATINGS-EXT"). Tech docs describe *how* and *why*; PLAN.md is the single source of truth for *what needs to be done*.

**Trigger:** Scanned all 31 tech docs and found 4 blocks worth of untracked development work (POSTHOG, MOCK-DATA-MIGRATION, RATINGS-EXT, CURRENTUSER-REFRESH) plus 1 missing item in an existing block (SessionHistory in MSG-ACCESS.PHASE2).

**Rationale:** Without this rule, features silently accumulate in tech docs where they're invisible to planning. The cross-reference closes the loop in both directions.

**See:** CLAUDE.md "Feature Tracking Rule" section

### DB-GUIDE.md Replaces DB-SCHEMA.md
**Date:** 2026-03-07 (Session 359)

`research/DB-SCHEMA.md` deprecated. Replaced by slim `research/DB-GUIDE.md` that covers only design rationale — the *why* behind the schema. For column names, types, and constraints, use the SQL source of truth (`../Peerloop/migrations/0001_schema.sql`).

**Trigger:** Capabilities review found DB-SCHEMA.md massively out of sync: TERMINOLOGY renames never applied, 15+ columns undocumented, 23 tables documented but never built. The file duplicated information already in the SQL and always drifted.

**Options Considered:**
1. Full rewrite of DB-SCHEMA.md to match current SQL
2. Drop entirely — just use SQL
3. Replace with slim guide covering only rationale ← Chosen

**Rationale:** Documentation that duplicates code will always drift. The SQL file is what developers reference. The only value worth maintaining is design rationale: why Community > Progression > Course, why capabilities not roles, how the two rating systems work, payment split architecture. DB-GUIDE.md captures that in ~200 lines vs DB-SCHEMA.md's 2000+.

**Consequences:** DB-SCHEMA.md kept with deprecation banner for history. References updated in CLAUDE.md, PLAYBOOK.md, docs/DECISIONS.md, q-docs-local.md (now deleted — migrated to Skills 2 `/w-docs`, Session 364). Session logs left as-is.

**See:** `research/DB-GUIDE.md`, `../Peerloop/migrations/0001_schema.sql`

### Deferred Blocks in PLAN.md
**Date:** 2026-02-21 (Session 233)

Work that is planned but not yet needed uses the `Deferred:` prefix in PLAN.md with:
- Context section (current state, what's needed)
- Task checklist
- **Triggers section** — conditions that indicate when to start the work
- **Dependencies section** — what must be in place first

**Example:** `Deferred: SENTRY` — production error tracking, triggered when MVP-GOLIVE begins.

### PLAN.md is Forward-Looking Only
**Date:** 2026-02-22 (Session 248)

PLAN.md contains only work that remains to be done. Completed content lives exclusively in COMPLETED_PLAN.md. No "Completed Blocks" section, no stubs, no links to completed work.

**Trigger:** PLAN.md had grown to 1,260 lines — ~60% completed content. The old convention of keeping completed sub-blocks as one-liners caused steady bloat over 248 sessions.

**Options Considered:**
1. Keep completed sub-blocks as one-liners until entire block completes (status quo)
2. Strip completed sub-blocks, only show remaining work ← Chosen

**Rationale:** A planning document's value is in showing what's next. Mixing completed and pending work makes the file hard to scan and creates maintenance overhead.

**Consequences:**
- Active blocks show a "Completed:" summary line + only remaining sections
- When a block fully completes: terse entry to COMPLETED_PLAN.md, full removal from PLAN.md
- `/w-update-plan` rewritten to match this philosophy (migrated to Skills 2 in Session 366)

**See:** PLAN.md, `.claude/skills/w-update-plan/SKILL.md`

### Block Completion: Terse Archive, Clean Removal
**Date:** 2026-02-22 (Session 248)

When a block fully completes: (1) add terse entry to COMPLETED_PLAN.md (block name + 1-line summary + session range), (2) fold any deferred items into related blocks in PLAN.md, (3) remove entire block from PLAN.md — no stub or link.

**Trigger:** Old workflow described moving "full details" to COMPLETED_PLAN.md. But COMPLETED_PLAN.md was restructured to terse format (Session 247), creating a mismatch with `/w-update-plan` (then `/w-update-plan-local`).

**Rationale:** Session docs in `docs/sessions/` already preserve full detail. COMPLETED_PLAN.md serves as a quick index of what was done and when. PLAN.md stays clean.

### Deferred Items Folded Into Related Blocks
**Date:** 2026-02-22 (Session 248)

~~Supersedes: "Cross-Reference Pre-Launch Deferred Items in Go-Live Checklists" (Session 247)~~

When a block completes with deferred items, fold those items directly into their related blocks in PLAN.md. No separate "Deferred Items" catch-all table.

**Trigger:** The catch-all Deferred Items table had ~18 items from various completed blocks — disconnected from context, some already resolved, some overlapping with existing blocks.

**Rationale:** Items stay discoverable when their related block is worked on. A flat list becomes a dumping ground where items are easy to forget.

### SCRIPTS.md as Unified Scripts Reference
**Date:** 2026-02-21 (Session 236)

Create `docs/reference/SCRIPTS.md` as the single reference for all npm scripts, script files (`scripts/*.{js,ts,sh,mjs}`), and page test scripts (`scripts/page-tests/test-*.sh`). Organized by category with cross-reference tables mapping npm scripts to underlying script files.

**Trigger:** Audit found 13 of 21 script files had zero documentation. 9 standalone scripts (no npm wrapper) were completely undiscoverable.

**Rationale:** npm scripts were documented across 4 CLI-*.md files but the underlying script files were not. A unified document makes the entire scripts ecosystem discoverable — both "what commands can I run?" and "what do these script files do?"

**Consequences:** Added to CLI-QUICKREF.md navigation table. Added Scripts Sync Check to `/q-docs` global skill (conditional: only runs if SCRIPTS.md exists, keeping the skill portable across projects).

**See:** `docs/reference/SCRIPTS.md`, `~/.claude/commands/q-docs.md`

### ROLES.md for Comprehensive Role Reference
**Date:** 2026-02-21 (Session 237), expanded 2026-02-23 (Sessions 261, 263)

Created `docs/reference/ROLES.md` as the comprehensive roles reference — covers how each role is acquired, what it can do (capabilities, accessible pages, API endpoints), and what it can't (restrictions). Renamed from `ROLE-TRANSITIONS.md` in Session 261 when capabilities/restrictions were added. Session 263 added two-tier moderator model (§5) and Content Hierarchy & Authority Map (§7).

**Trigger:** Needed comprehensive documentation of all role transition paths and capabilities — the information was spread across multiple API endpoints, components, and specs with no single source of truth.

**Rationale:** Role information is cross-cutting (auth, payments, admin tools, creator tools, navigation filtering) and doesn't fit cleanly into any single existing doc. Includes authorization matrix, capability quick reference, CurrentUser runtime methods, navigation menu filtering, and per-role page/API access tables.

**See:** `docs/reference/ROLES.md`

### Authority Map in ROLES.md (Not Standalone Doc)
**Date:** 2026-02-23 (Session 263)

The "Content Hierarchy & Authority Map" — showing who has authority at each level of the Community → Progression → Course chain — lives as a section in ROLES.md rather than a standalone file.

**Trigger:** The hierarchy was documented across 4+ files (CD-036 RFC, docs/DECISIONS.md, url-routing doc, DB-SCHEMA.md), none showing role annotations. Needed a "who can do what at each level" unified reference.

**Options Considered:**
1. New section in ROLES.md ← Chosen
2. Annotate RFC/CD-036 (historical record, not ideal for living reference)
3. New standalone `AUTHORITY-MAP.md` (yet another file to maintain)

**Rationale:** ROLES.md is already the role reference. The authority map complements the per-role sections (§1-6) by showing the same information from the hierarchy's perspective. Avoids a separate file that duplicates role information.

**See:** `docs/reference/ROLES.md` (§ Content Hierarchy & Authority Map)

### POLICIES.md for Platform Behavior Rules
**Date:** 2026-03-01 (Session 319)

Created `POLICIES.md` for prescriptive platform behavior policies — access control rules, business logic, user capabilities. If code contradicts a policy, the code is the bug.

**Trigger:** Creator access control policies (permission vs state gating, revocation behavior) didn't fit into docs/DECISIONS.md (architectural/implementation) or PLAYBOOK.md (docs-repo conventions).

**Options Considered:**
1. Add to docs/DECISIONS.md under a new section
2. Create a separate docs/POLICIES.md ← Chosen

**Rationale:** docs/DECISIONS.md records *how* we build (architecture). docs/POLICIES.md defines *what* the platform does (behavior). The distinction matters because policies are the authority when code is inconsistent — exactly the situation that revealed the creator access bugs.

**Three decision documents now:**
- **docs/POLICIES.md** — How the platform *behaves* (access rules, business logic)
- **docs/DECISIONS.md** — How we *build* it (architecture, tech choices)
- **PLAYBOOK.md** — How the *docs repo* works (workflow, conventions)

**See:** `docs/POLICIES.md`, `CLAUDE.md` (project structure + research reference)

### Deleted TEST-API.md — Directory Structure is the Test Index
**Date:** 2026-03-04 (Session 325)

Deleted `docs/reference/TEST-API.md`. The file was a manually maintained table of test counts by API area that repeatedly drifted from reality (corrected in sessions 213, 252, 325). It only had category-level counts, not individual file paths, so it didn't help find specific tests.

**Trigger:** Updated counts for Session 325, then questioned why a manually maintained index exists when `tests/api/` already mirrors the API route structure.

**Options Considered:**
1. Keep maintaining manually
2. Auto-generate from filesystem
3. Delete — directory structure is self-documenting ← Chosen

**Rationale:** `tests/api/sessions/index.test.ts` is self-evident. No skills or active docs referenced TEST-API.md. TEST-COVERAGE.md updated to point to the directory directly.

**See:** `docs/reference/TEST-COVERAGE.md`
