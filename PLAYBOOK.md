# PLAYBOOK.md

This document tracks decisions about **how the peerloop-docs repo itself works** — its organization, workflows, conventions, and tooling. For Peerloop application decisions (code, schema, UI), see `DECISIONS.md`.

**Last Updated:** 2026-03-05 Session 342 (feature tracking rule: all features must be in PLAN.md)

---

## How This Document Works

- **Latest Wins:** If a newer decision contradicts an older one, only the newer decision appears here
- **Organized by Category:** Repo architecture, CC workflow, Obsidian, conventions
- **Dates Included:** Each decision shows when it was made and which session
- **Source:** Consolidated from session decision files in `docs/sessions/`
- **Updated By:** `/q-learn-decide` → `/q-learn-decide-local` emits docs-repo decisions here

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
├── DECISIONS.md              # Peerloop application decisions
├── PLAYBOOK.md               # This file — docs repo decisions
├── BEST-PRACTICES.md         # Coding standards
├── SESSION-INDEX.md          # Session log index
├── USER-STORIES-MAP.md       # User stories overview
├── SITE-MAP.md               # Site map
├── ORIG-PAGES-MAP.md         # Original page architecture (pre-Twitter pivot)
├── docs/
│   ├── sessions/             # Development session logs (by month)
│   ├── reference/            # CLI, API, testing docs
│   ├── tech/                 # Technology decision docs
│   └── guides/               # How-to guides
├── research/
│   ├── GOALS.md              # Mission & success metrics
│   ├── USER-STORIES.md       # All user stories (370+)
│   ├── DB-SCHEMA.md          # Database entities
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
| Application decisions | `DECISIONS.md` | Yes |
| Docs-repo decisions | `PLAYBOOK.md` | Yes |
| Current/pending work | `PLAN.md` | Yes |
| Session logs | `docs/sessions/YYYY-MM/` | Yes |
| Technology decisions | `docs/tech/tech-NNN-*.md` | Yes |
| Specifications & schemas | `research/` | Yes |
| Client change requests | `RFC/CD-XXX/` | Yes |
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

### q-git-history: Per-Commit Machine and Repo Tags
**Date:** 2026-02-21 (Session 237)

`/q-git-history` now includes machine name and repo identifier on every commit entry. Previously, `Machine:` lines were filtered out and the repo name was only in a section header.

**Changes:**
- `Machine:` lines no longer excluded — rendered as a regular bullet per commit
- `(code)` or `(docs)` tag appended to each commit's datetime header line

**Trigger:** Timecards combining commits from both repos (via `/q-timecard`) didn't show which computer or which repo each commit came from.

**Rationale:** The data was already in every commit body (`Machine:` footer from `/q-commit-local`) and inherent to the git directory (`repo=` argument). Fixing the display layer is retroactive — all existing commits benefit with no format changes needed.

**See:** `~/.claude/commands/q-git-history.md`

### CURRENT-BLOCK-PLAN.md for Multi-Session Blocks
**Date:** 2026-02-24 (Session 276)

For blocks too large for one session, create `CURRENT-BLOCK-PLAN.md` at the docs repo root. Contains checkboxes for every item, key files table, and progress summary updated each session. Deleted when block completes.

**Trigger:** BBB block has 5 sub-blocks with ~25 items. PLAN.md is too high-level for per-item tracking. RESUME-STATE.md is session-specific and gets deleted on resume.

**Pattern:** Each session reads the file first, works through unchecked items, updates checkboxes, adds a session progress summary at top. "Next session" guidance tells the next CC instance where to start.

**Automation:** Use `/q-make-block-persistent <BLOCK-NAME>` to extract a block from PLAN.md and write it to `CURRENT-BLOCK-PLAN.md` with a progress table. Global skill (Session 287).

**See:** `CURRENT-BLOCK-PLAN.md` (exists while block is active), `~/.claude/commands/q-make-block-persistent.md`

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

`/q-learn-decide` → `/q-learn-decide-local` routes decisions to the appropriate file:
- **Peerloop application decisions** (code, schema, UI, API) → `DECISIONS.md`
- **Docs-repo decisions** (organization, workflows, CC config, vault) → `PLAYBOOK.md`

Same structured format (trigger, options, rationale, consequences) for both.

> **Insight:** The split between DECISIONS.md and PLAYBOOK.md mirrors a distinction that exists in most software projects but is rarely made explicit: product decisions (what we're building) vs process decisions (how we work). By separating them, each file stays focused and navigable. Because PLAYBOOK.md tracks docs-repo conventions, it becomes a portable reference — if you start a new client project with a similar docs-first architecture, the playbook carries forward as a template. (Session 233)

### Durable Insight Capture
**Date:** 2026-02-21 (Session 233)

During `/q-learn-decide` processing, `★ Insight` blocks are scanned for durable, informative insights. Qualifying insights are co-located with the decision they illuminate as `> **Insight:**` blockquotes.

**Rationale:** Co-locating insights with decisions follows the same principle as co-locating tests with code — the context you need to understand *why* something exists should be as close as possible to the thing itself. Separate files create cross-referencing overhead.

**Qualification:** An insight is durable if it connects a decision to broader professional context, explains why a convention works well beyond the immediate rationale, or would teach someone starting a similar project.

### Dynamic Tech Doc Sweep in /q-docs-local
**Date:** 2026-03-05 (Session 334)

`/q-docs-local` section 7 dynamically discovers tech docs (`docs/tech/tech-*.md`) at runtime and cross-references against code paths changed in the session. No hard-coded mapping to maintain — new tech docs are automatically included.

**Trigger:** Session 334 missed updating `tech-032-session-booking.md` during `/q-docs` because the existing checklist only triggered on package/config changes, not domain code changes.

**Options Considered:**
1. Hard-coded code-path → tech-doc table in `/q-docs-local` — drifts as tech docs are added
2. Hard-coded table + maintenance skill in `/q-eos` — extra step, easy to forget
3. Dynamic sweep: `ls tech-*.md`, read titles, match against session changes ← Chosen

**Rationale:** 31 tech docs and growing. Any static mapping becomes stale. The dynamic approach has zero maintenance cost and catches new tech docs automatically. The heuristic matching (code path patterns → topic keywords) doesn't need to be perfect — it's a reminder check, not a gate.

### Feature Tracking Rule: All Features Must Be in PLAN.md
**Date:** 2026-03-05 (Session 342)

Any time a feature is mentioned — in a tech doc, session discussion, RFC, or code comment — it must be added to `PLAN.md`. Where it goes is situational (active block, deferred, sub-task of an existing block). If the feature originated from a tech doc, add a cross-reference noting the PLAN block (e.g., "Tracked in PLAN.md: RATINGS-EXT"). Tech docs describe *how* and *why*; PLAN.md is the single source of truth for *what needs to be done*.

**Trigger:** Scanned all 31 tech docs and found 4 blocks worth of untracked development work (POSTHOG, MOCK-DATA-MIGRATION, RATINGS-EXT, CURRENTUSER-REFRESH) plus 1 missing item in an existing block (SessionHistory in MSG-ACCESS.PHASE2).

**Rationale:** Without this rule, features silently accumulate in tech docs where they're invisible to planning. The cross-reference closes the loop in both directions.

**See:** CLAUDE.md "Feature Tracking Rule" section

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
- `/q-update-plan-local` rewritten to match this philosophy

**See:** PLAN.md, `.claude/commands/q-update-plan-local.md`

### Block Completion: Terse Archive, Clean Removal
**Date:** 2026-02-22 (Session 248)

When a block fully completes: (1) add terse entry to COMPLETED_PLAN.md (block name + 1-line summary + session range), (2) fold any deferred items into related blocks in PLAN.md, (3) remove entire block from PLAN.md — no stub or link.

**Trigger:** Old workflow described moving "full details" to COMPLETED_PLAN.md. But COMPLETED_PLAN.md was restructured to terse format (Session 247), creating a mismatch with `/q-update-plan-local`.

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

**Trigger:** The hierarchy was documented across 4+ files (CD-036 RFC, DECISIONS.md, tech-021, DB-SCHEMA.md), none showing role annotations. Needed a "who can do what at each level" unified reference.

**Options Considered:**
1. New section in ROLES.md ← Chosen
2. Annotate RFC/CD-036 (historical record, not ideal for living reference)
3. New standalone `AUTHORITY-MAP.md` (yet another file to maintain)

**Rationale:** ROLES.md is already the role reference. The authority map complements the per-role sections (§1-6) by showing the same information from the hierarchy's perspective. Avoids a separate file that duplicates role information.

**See:** `docs/reference/ROLES.md` (§ Content Hierarchy & Authority Map)

### POLICIES.md for Platform Behavior Rules
**Date:** 2026-03-01 (Session 319)

Created `POLICIES.md` for prescriptive platform behavior policies — access control rules, business logic, user capabilities. If code contradicts a policy, the code is the bug.

**Trigger:** Creator access control policies (permission vs state gating, revocation behavior) didn't fit into DECISIONS.md (architectural/implementation) or PLAYBOOK.md (docs-repo conventions).

**Options Considered:**
1. Add to DECISIONS.md under a new section
2. Create a separate POLICIES.md ← Chosen

**Rationale:** DECISIONS.md records *how* we build (architecture). POLICIES.md defines *what* the platform does (behavior). The distinction matters because policies are the authority when code is inconsistent — exactly the situation that revealed the creator access bugs.

**Three decision documents now:**
- **POLICIES.md** — How the platform *behaves* (access rules, business logic)
- **DECISIONS.md** — How we *build* it (architecture, tech choices)
- **PLAYBOOK.md** — How the *docs repo* works (workflow, conventions)

**See:** `POLICIES.md`, `CLAUDE.md` (project structure + research reference)

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
