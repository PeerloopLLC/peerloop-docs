# DOC-DECISIONS.md

This document tracks decisions about **how the peerloop-docs repo itself works** — its organization, workflows, conventions, and tooling. For Peerloop application decisions (code, schema, UI), see `docs/DECISIONS.md`.

**Last Updated:** 2026-04-11 Conv 103 (reporting skills must scan all branches; /r-start dirty-guard exception for RESUME-STATE.md)

---

## How This Document Works

- **Latest Wins:** If a newer decision contradicts an older one, only the newer decision appears here
- **Organized by Category:** Repo architecture, CC workflow, Obsidian, conventions
- **Dates Included:** Each decision shows when it was made and which session
- **Source:** Consolidated from session decision files in `docs/sessions/`
- **Updated By:** `/r-learn-decide` emits docs-repo decisions here

---

## 1. Repo Architecture

### Favour Durable Decisions Over Faster Options (Project Guiding Principle)
**Date:** 2026-04-10 (Conv 100)

When presenting or weighing options, always present the most durable/rigorous alternative alongside any quick fix, and answer decisively when asked "which is durable?". The software should be characterized by a small number of overview directives adhered to by default and broken only for sound reasons.

**Rationale:** User stated verbatim: "I am less concerned about disruptions and more concerned about a stable outcome that survives. Are we making a convenient 'fix' to expedite moving on... or should we opt for a more encompassing solution that will last?" Accumulated quick fixes create long-term debt; stability over speed is the guiding lens. Anchored to Conv 100's Stripe apiVersion bump decision (bump pin + consolidate call sites > pin cast hacks).

**See:** `feedback_no_simplest_fix.md` in Claude memory (verbatim framing + signal checklists).

### `/r-commit` Mid-Conv Is Allowed for Strategic Snapshots
**Date:** 2026-04-10 (Conv 100)

The memory rule "always use /r-end to commit, never /r-commit directly" applies to isolated commits. For strategic mid-conv snapshots within a multi-phase work block, `/r-commit` is appropriate when the conversation continues into the next phase. `/r-end` remains the sole owner of session doc creation at end-of-conv.

**Rationale:** `feedback_always_r_end.md` exists to prevent overlapped session docs. A mid-conv `/r-commit` only commits code — it doesn't create session docs — so the rules don't conflict. Recognized exception, not a rule change.

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

Code repo has symlink (`Peerloop/docs → ../peerloop-docs/docs`) created by `scripts/link-docs.sh` and gitignored.

**Options Considered:**
1. Modify build scripts to accept configurable paths
2. Symlink docs/ back into code repo ← Chosen
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
├── DOC-DECISIONS.md               # This file — docs repo decisions
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
└── scripts/
    └── link-docs.sh          # Symlink setup for code repo
```

### What Goes Where

| Content Type | Location | Committed? |
|-------------|----------|:----------:|
| CC commands, hooks, config | `.claude/` | Yes |
| Obsidian vault config | `.obsidian/` | No |
| Application decisions | `docs/DECISIONS.md` | Yes |
| Docs-repo decisions | `DOC-DECISIONS.md` | Yes |
| Current/pending work | `PLAN.md` | Yes |
| Session logs | `docs/sessions/YYYY-MM/` | Yes |
| Technology decisions | `docs/reference/*.md`, `docs/as-designed/*.md` | Yes |
| Specifications & schemas | `docs/reference/`, `docs/requirements/` | Yes |
| Client change requests | `docs/requirements/rfc/CD-XXX/` | Yes |
### Docs Folder Reorganization: vendors/ + architecture/
**Date:** 2026-03-09 (Session 362)

Split `docs/tech/` into `docs/reference/` (19 files — external service/library decisions) and `docs/as-designed/` (13 files — internal design patterns). Dropped `tech-0XX-` numbering prefix, using descriptive names (e.g., `stripe.md`, `state-management.md`). Moved 9 root files to appropriate folders (DECISIONS.md, GLOSSARY.md, POLICIES.md → `docs/`; BEST-PRACTICES.md → `docs/reference/`; navigation docs → `docs/as-designed/`; USER-STORIES-MAP.md → `docs/requirements/`).

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

### Skill Interplay Merged Into skills-system.md
**Date:** 2026-04-06 (Conv 089)

All skill documentation (architecture + runtime interplay) lives in one file: `docs/as-designed/skills-system.md`. SPT had a separate `SKILL-INTERPLAY.md`; Peerloop merged the content into the existing file.

**Rationale:** One file for both how skills are built and how they interact at runtime. Peerloop doesn't have a `docs/as-built/` directory, so a separate file would create an orphan.

---

## 3. Claude Code Workflow

### Baseline Claims Must Come From the Current Conv
**Date:** 2026-04-10 (Conv 102)

Any test/tsc/build baseline stated in RESUME-STATE.md, session docs, or `/r-end` docs-agent output must come from a command that actually ran in the current conv. Baselines are never copy-forwarded from prior RESUME-STATE files. If unchanged and not re-verified, mark explicitly: `(unchanged from Conv N, not re-verified this conv)`. Rule encoded in `~/.claude/projects/-Users-jamesfraser-projects-peerloop-docs/memory/feedback_verify_baselines_in_conv.md`.

**Rationale:** Conv 101's RESUME-STATE claimed "6399/6399 passing" without running the suite. Conv 102 ran it and found 5 pre-existing failures that had been lurking across an unknown number of conversations. Copy-forwarding hides regressions in plain sight.

### SKILL.md `!` Backtick Scripts Must Always Exit 0
**Date:** 2026-04-10 (Conv 102)

Scripts invoked via `!` backtick expressions in SKILL.md are pre-computed context, not validation. They must always `exit 0` regardless of what they find. Any script using `grep`, `find`, `test`, or similar commands that exit non-zero on "no match" must explicitly `|| true` those commands or end with `exit 0`. A failing script blocks SKILL.md from loading entirely with a `Shell command failed for pattern` error.

**Rationale:** `.claude/scripts/resume-state-check.sh` broke `/r-end` in Conv 102 because it did `grep 'Saved:'` on a file whose format had changed and no longer contained `Saved:`. grep exited 1, the harness treated the `!` backtick as failed, and SKILL.md never loaded. Fix added broadened regex, `|| head -1` fallback, and explicit `exit 0` safety net.

### Conv (Conversation) Lifecycle — Replaces Session Numbering
**Date:** 2026-03-17 (Session 393)

Work units are tracked as "Conv" (Conversation) numbers, replacing "Session" numbering (which ended at Session 393). Conv numbers start at 001. Both repos treated as a paired unit — same Conv number in both repos' commit messages (`Conv NNN: description`).

**Lifecycle:**
- `/r-start` — check both repos clean, pull both, increment CONV-COUNTER, push, resume
- `/r-commit` — always commits both repos with Conv + Machine metadata
- `/r-end` — EOS sequence, save pending tasks to RESUME-STATE.md, commit both, push both, cleanup `.conv-current`

**Key files:** `CONV-COUNTER` (persistent integer, git-synced), `.conv-current` (ephemeral, gitignored)

**Trigger:** "Session" collided with Claude Code's internal session concept. A CC session can span multiple Convs (via `/clear`), and one Conv can span multiple CC sessions (across machines).

**`/r-pre-clear` eliminated (Conv 010):** Formerly a separate skill for saving state before `/clear`. Its state-save responsibility was incorporated into `/r-end` Step 3 — if pending TaskList items exist, `/r-end` runs `/r-save-state` automatically before committing.

**RESUME-STATE.md as transparent TodoWrite persistence (Conv 012):** RESUME-STATE.md is now purely a serialization layer — the user never interacts with it directly. `/r-start` Step 7 reads remaining items from RESUME-STATE.md, creates TaskCreate entries in TodoWrite, then deletes the file. `/r-end` serializes pending TodoWrite tasks to RESUME-STATE.md before committing. TodoWrite is the single interface for outstanding work; RESUME-STATE.md is just the wire format between conversations.

**Skill consolidation (Conv 001):** Retired 6 w-* skills that had direct r-* equivalents (w-eos, w-learn-decide, w-dump, w-update-plan, w-commit, w-save-state). Merged w-docs into r-docs as single canonical docs skill. Remaining w-* skills (timecard, codecheck, sync-docs, etc.) retain their names — they have no r-* equivalent and are Peerloop-specific.

**See:** `CONV-COUNTER`, `.claude/skills/r-start/SKILL.md`, `CONV-FLOWCHART.md` (in prod-helpers)

### CONV-INDEX.md Replaces SESSION-INDEX.md
**Date:** 2026-03-17 (Conv 005)

`CONV-INDEX.md` tracks Conv-numbered work (001+). `SESSION-INDEX.md` is frozen at Session 393 as a historical archive.

**Rationale:** Clean break between numbering systems. Mixing two numbering schemes in one file would be confusing. SESSION-INDEX.md is a complete 393-entry historical record.

### Dual-Repo Commit Workflow
**Date:** 2026-02-20 (Session 232), updated 2026-03-17 (Session 393)

When changes span both repos, commit code first, then docs. Both commits use the same Conv number. `/r-commit` always commits both repos — if one has nothing to commit, it's skipped silently.

| Scenario | Action |
|----------|--------|
| Code changes only | `git -C ../Peerloop add . && git -C ../Peerloop commit` |
| Doc changes only | `git add . && git commit` |
| Both repos changed | Code first, then docs (same Conv number) |

**Rationale:** Code commits may trigger CI. Docs commits are follow-up context. Same Conv number links them for traceability.

### Dev Log File Naming Convention
**Date:** 2026-02-20 (Session 229)

All dev log files use the format `YYYY-MM-DD_HH-MM-SS {Type}.md` where Type is `Dev`, `Learnings`, or `Decisions`. Files within the same conv share the same timestamp.

**Trigger:** Learnings/Decisions files initially used `YYYYMMDD-HHMM` format while Dev used `YYYY-MM-DD_HH-MM-SS`. Inconsistency caused confusion.

**Rationale:** Single format, shared timestamp groups related files together in directory listing.

### Dev Logs Are Immutable Historical Records
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

### PostToolUse Hook for Check Output Reminders
**Date:** 2026-03-16 (Session 391)

A PostToolUse hook (`check-output-reminder.sh`) fires after every Bash tool call and reminds Claude to TodoWrite any issues found. Two-layer design:

- **Layer 1 (check commands):** Parses output from `npm test`, `tsc`, `eslint`, `astro check`, `check:tailwind` for detailed error/warning/hint counts. Strong "TodoWrite NOW" language.
- **Layer 2 (general failures):** Catches any non-zero exit code not handled by Layer 1. Softer "Diagnose the failure" language since not all failures are bugs.

**Trigger:** Claude repeatedly dismissed check findings as "pre-existing" instead of tracking them. Feedback memories weren't sufficient — the behavioral gap required intervention at the exact moment of discovery.

**Consequence:** Hook registered in `.claude/settings.json` with `matcher: "Bash"`. Non-check commands exit immediately (minimal overhead). Takes effect from next session.

### TodoWrite-Gap Reminders Embedded in Skill Chain
**Date:** 2026-03-20 (Conv 021)

When `/r-docs` discovers documentation gaps (undocumented endpoints, stale docs, missing coverage), it must TodoWrite them — not just mention them as "pre-existing" in commentary. This rule is now embedded directly in the skill text at two levels:

- **`/r-eos` Rules section** — sets the expectation before `/r-docs` is invoked
- **`/r-docs` Action Plan** — `⚠️ CRITICAL` callout with trigger-word self-monitoring ("pre-existing", "missing", "stale", "gap", "undocumented")

**Trigger:** Despite two feedback memory entries (`feedback_surface_and_track_all_issues.md`, `feedback_codecheck_todos.md`), the behavior kept recurring because memory can be compressed away during long `/r-end` chain executions. Skill SKILL.md files are loaded fresh each invocation.

**Rationale:** Complements the PostToolUse hook (which catches Bash tool output) by covering the skill chain path where gaps are discovered through script output and manual review rather than direct tool calls.

### w-git-history: Per-Commit Machine and Repo Tags
**Date:** 2026-02-21 (Session 237)

`/w-git-history` now includes machine name and repo identifier on every commit entry. Previously, `Machine:` lines were filtered out and the repo name was only in a section header.

**Changes:**
- `Machine:` lines no longer excluded — rendered as a regular bullet per commit
- `(code)` or `(docs)` tag appended to each commit's datetime header line

**Trigger:** Timecards combining commits from both repos (via `/w-timecard`) didn't show which computer or which repo each commit came from.

**Rationale:** The data was already in every commit body (`Machine:` footer from `/q-commit-local`) and inherent to the git directory (`repo=` argument). Fixing the display layer is retroactive — all existing commits benefit with no format changes needed.

**See:** `~/.claude/commands/q-git-history.md`

### Conv-Based Timecard Selection (conv=NNN)
**Date:** 2026-03-20 (Conv 019)

`/w-timecard-dual` gained a `conv=NNN[,NNN,...]` parameter as an alternative to count-based `cNdN`. Uses `git log --grep="Conv NNN"` to find all commits matching the requested conv numbers across both repos automatically.

**Trigger:** Generating retroactive timecards for multiple convs required manually counting commits per repo — tedious and error-prone.

**Caveat:** `--grep` matches anywhere in the commit message body, not just the `Conv:` metadata line. A Conv 016 commit mentioning "Conv 015-016" in its body gets returned as a false match for Conv 015. Requires manual verification of subject lines when convs are adjacent.

**See:** `.claude/skills/w-timecard-dual/SKILL.md`

### Reporting Skills Must Scan All Local Branches; Commit-Creation Skills Stay HEAD-Only
**Date:** 2026-04-11 (Conv 103)

For timecard/history-style **reporting** skills, plain `git log` (which reads HEAD) is a silent billing bug whenever long-lived branches exist. They must scan all local refs/heads/* and de-dup by hash. **Commit-creation** skills (`/r-commit`, `/q-commit`) stay HEAD-only — that's the only sensible semantic for "commit to where you are."

**UX split based on query semantics:**
- **Date-based queries** (`/r-timecard-day`) → per-branch iteration via `git for-each-ref refs/heads/`, count in-window commits per branch, prompt user with 👉👉👉 (default include-all) when non-HEAD branches have hits. Date windows are inherently ambiguous — multiple branches may legitimately have in-window work, not all of which should bill.
- **Unique-ID queries** (`/r-timecard conv=NNN`) → silent `git log --branches --grep=...` + per-commit `git branch --contains` resolution + de-dup. Conv numbers identify a single unambiguous unit of work; just find it wherever it lives.
- **Count-based queries** (`/r-timecard cNdN`) → HEAD-only by design. "Last N commits on the branch I'm on" is the semantic; switching branches before running is user error, not skill bug.

**Trigger:** `/r-timecard-day Apr-10-2026` returned zero code commits because all 4 of Apr 10's code commits lived exclusively on `jfg-dev-10up` (the long-lived Astro 6 upgrade branch) while HEAD was `jfg-dev-9`. Only caught by cross-referencing docs commit messages that textually mentioned the code hashes.

**Rationale:** `git log --branches` is the canonical "all local heads" flag — cleaner than `--all` (no remote/tag noise), more readable than explicit for-each-ref iteration. Use it when you need union-across-branches without per-branch counts.

**Branch column convention:** All reporting-skill Git History tables now include a Branch column between Hash and Machine. Dedup rule: when a commit is reachable from multiple branches (post-merge), record the non-HEAD/non-main branch — that's where the work was actually done.

**See:** `.claude/skills/r-timecard-day/SKILL.md`, `.claude/skills/r-timecard/SKILL.md`

### /r-start Dirty-Repo Guard: Proceed When Only RESUME-STATE.md Is Dirty
**Date:** 2026-04-11 (Conv 103)

When `/r-start`'s Step 1 dirty-repo check halts with `RESUME-STATE.md` as the only modified file, the correct action is to **proceed past the guard**, not commit first. Step 7 of `/r-start` consumes RESUME-STATE.md by reading its TodoWrite Items into TodoWrite and deleting the file — the deletion is the canonical end-state.

**Trigger:** Conv 103 /r-start halted on ` M RESUME-STATE.md` after the user appended insurance tasks pre-/r-start. Committing first would create a commit whose lines are immediately deleted by Step 7's transfer-and-delete, adding noise to git history.

**Rationale:** The dirty-repo guard exists to prevent losing uncommitted work. RESUME-STATE.md is a special case — its "uncommitted work" IS the thing /r-start is supposed to consume.

**Caveat:** RESUME-STATE.md is **tracked**, not gitignored. Edits to it are real uncommitted changes and the deletion is staged as part of the next /r-end commit.

**Known gap:** /r-start Step 7 assumes TodoWrite is empty (true after `/clear`). In no-clear `/r-start` paths, pre-existing TodoWrite items may collide with items transferred from RESUME-STATE.md and need manual dedup. Tracked as task `[RD]`.

**See:** `.claude/skills/r-start/SKILL.md`

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

**Consequences:** Updated SKILL.md files, CLAUDE.md, DOC-DECISIONS.md, skills-system.md, DEVELOPMENT-GUIDE.md, detect-changes.sh. Session logs left as-is. Also deleted 3 orphaned `*-local` command files and migrated 2 `L-*` commands to Skills 2 as `w-*` skills. `.claude/commands/` is now empty.

**See:** `docs/as-designed/skills-system.md`, Session 373 Decisions.md

### Skills 2 Migration: Merged Single-File Pattern
**Date:** 2026-03-10 (Session 364)

Skills with paired global/local commands (`q-docs.md` + `q-docs-local.md`) are migrated to Skills 2 as a single merged `SKILL.md` in `.claude/skills/<name>/`. Project-specific content is inlined (not in a separate `project.md`), replacing `<!-- PROJECT -->` placeholders from the canonical template.

**Trigger:** Skills 2 directories naturally accommodate both global logic and project config. The old two-file handoff ("REQUIRED: read project.md") was a reliability risk.

**Pattern:** Project `.claude/skills/r-docs/SKILL.md` overrides global `~/.claude/commands/q-docs.md` — unconverted projects keep working. Use `!` backtick injection for helper scripts that pre-compute data at invocation time.

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

### Marker-Anchored Detection for /r-docs
**Date:** 2026-03-10 (Session 365)

`detect-changes.sh` records both repos' HEAD SHAs in `.last-qdocs-run` after each `/r-docs` run. The next run diffs from that marker forward, showing only changes since the last documentation pass.

**Trigger:** `HEAD~5` was arbitrary and pulled in 260+ files from weeks of prior sessions. Time-based `--since` was better but still duplicated work on multi-session days.

**Pattern:** Marker file is now gitignored (Conv 061). Originally committed so it could travel across machines, but a race condition caused it to be left dirty: if the docs agent writes the marker after the `/r-end` commit, the file blocks the next `/r-start`. Since both machines have full functionality, the cross-machine benefit didn't justify the intermittent breakage. Falls back to `--since "24 hours ago"` when no marker exists or the SHA isn't found locally. `--reset` flag forces fallback.

**See:** `.claude/skills/r-docs/scripts/detect-changes.sh`, `docs/as-designed/skills-system.md`

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

### TodoWrite Discipline: Capture Everything
**Date:** 2026-03-12 (Session 386)

Any unresolved issue, opportunity, question, or implied action item must be added to TodoWrite immediately. This includes pre-existing errors found during checks, ideas spotted while reading code, and user messages containing signal words ("should", "might", "could", "need to", "do later", "soon", "eventually").

**Rationale:** TodoWrite items carry forward via `/r-end` → RESUME-STATE.md → `/r-start` → TodoWrite (transparent persistence, Conv 012). Silently skipping items means they're lost in conversation noise. The user decides priority, not the assistant.

**Consequence:** Updated `~/.claude/CLAUDE.md` (global), feedback memories, and `/r-start` Step 7 (deserialize RESUME-STATE.md into TodoWrite on startup).

### Test File Hygiene: Draft Fast, Clean Immediately
**Date:** 2026-03-12 (Session 386)

When writing tests, draft with a full starter-kit of imports for speed, but do a cleanup pass to remove unused imports/variables before moving to the next file.

**Rationale:** Unused imports create persistent Astro/TS hints that accumulate and obscure real issues. A 10-second pass when the file is fresh prevents this entirely.

**See:** `docs/reference/BEST-PRACTICES.md` §8, `docs/reference/CLI-TESTING.md` "Import & Fixture Hygiene"

### Collector + Agent Dispatch Pattern for Multi-Stage Skills
**Date:** 2026-03-25 (Conv 031)

Skills that need to process conversation data in multiple independent ways (learn-decide, dump, update-plan, docs) should use a collector + agent dispatch pattern instead of nested skill calls. Main context scans conversation once into a structured extract file, then dispatches agents in parallel — each reading only their relevant section.

**Rationale:** Skills are prompt injections, not functions — nesting 3 levels deep loses the outer return path. Agents get isolated context windows, and the extract file doubles as a debugging artifact. This replaced the r-end → r-eos → 4 skills nesting that caused recurring failures (stopping after step 2, missing TodoWrite items).

> **Insight:** The instinct to compose skills like functions comes from a programming background, but LLM context windows don't have call stacks. The materialized view pattern — pre-compute shared data to disk, dispatch isolated agents — is the LLM-native equivalent of function composition.

**See:** `.claude/skills/r-end2/SKILL.md`, Conv 031 Decisions.md

### Shared Reference Files (refs/) for Agent Format Rules
**Date:** 2026-03-25 (Conv 031)

When agents need formatting rules from standalone skills, extract those rules into shared `refs/fmt-{name}.md` files rather than inlining them in the orchestrator or having agents read standalone skill files directly.

**Rationale:** Decouples agent format rules from standalone skill execution flow. Agents get focused instructions without pre-computed context or confirmation templates they don't need. Standalone skills remain the source of truth; refs files are curated extracts.

**See:** `.claude/skills/r-end2/refs/`, Conv 031 Decisions.md

### Extract Files: Keep Permanently, Prune Duplicated Content
**Date:** 2026-03-26 (Conv 034)

Keep r-end2 Extract files permanently but prune §Learnings and §Decisions sections after agents produce their companion files. Replace pruned sections with pointer lines. (§Changes is no longer pruned — see "Extract Replaces Dev.md" below.)

**Rationale:** §Prompts & Actions is the unique narrative — the only record of what was discussed and why. §Uncategorized captures stray observations. Both have no equivalent in other files. Pruning eliminates ~70% duplication while preserving 100% of unique value.

> **Insight:** Intermediate artifacts in a pipeline should be pruned to their unique value, not deleted entirely. The pruning boundary is defined by what downstream consumers already materialized — anything they copied is redundant, anything they didn't is irreplaceable.

**See:** `.claude/skills/r-end2/SKILL.md` Step 4b, Conv 034 Decisions.md

### Manifest-Based Pruning for Parallel Agent Coordination
**Date:** 2026-03-26 (Conv 034)

Agents append consumed line numbers to a shared manifest file (`/tmp/extract-manifest.txt`) via atomic `echo >>`. Controller reads manifest after all agents complete, sorts descending, and deletes listed lines. Failed agents don't append, so their sections stay in the Extract as fallback.

**Rationale:** Agents know exactly which lines they cherry-picked. Manifest is append-only (no race conditions under PIPE_BUF). Controller handles deletion at the natural synchronization point. This replaced blunt controller-side section removal that couldn't know if an agent succeeded.

**Current state:** After eliminating the dump agent (see below), only the learn-decide agent writes to the manifest. The manifest infrastructure is retained for forward-compatibility — if a future agent needs to prune Extract content (e.g., a dedicated Changes agent, or a new section type), it can append to the same manifest with zero coordination changes. Simplifying to inline response parsing would save one file I/O but would require re-introducing the manifest if a second writer ever appears.

> **Insight:** The append-only manifest pattern solves a common parallel coordination problem: multiple producers need to signal completion to a single consumer without locks. The key constraint is that the source file must be immutable during agent execution — line numbers are stable addresses only if nothing else modifies the file.

**See:** `.claude/skills/r-end2/SKILL.md`, Conv 034

### Extract Replaces Dev.md — Dump Agent Eliminated
**Date:** 2026-03-26 (Conv 034)

The Extract file is now the primary conv record, fully replacing Dev.md. Added `## Conv Prompts` section (bulleted verbatim user prompts) and kept `## Changes` (git diffs + per-file context) in the Extract instead of pruning them. The dump agent is eliminated — r-end2 dispatches 3 agents instead of 4.

**Per-conv output is now 3 files:**
| File | Content | Produced by |
|---|---|---|
| `Extract.md` | Meta, Prompts & Actions, Changes, Conv Prompts, Progress, Tasks, Uncategorized | r-end2 controller (§Learnings and §Decisions pruned after agents) |
| `Learnings.md` | Formatted learnings with topic tags | learn-decide agent |
| `Decisions.md` | Formatted decisions with options/rationale | learn-decide agent |

**Trigger:** Post-r-end2 review revealed §Prompts & Actions in Extract was nearly word-for-word duplicated in Dev.md's Development Transcript section. Since the Extract already contained the narrative, changes, and progress, adding Conv Prompts made Dev.md entirely redundant.

**Rationale:** Eliminating the dump agent reduces dispatch from 4→3 agents (faster, simpler). The Extract was already being kept permanently — making it the sole conv record avoids maintaining two files with overlapping content. Conv Prompts provides the quick-scan index that Dev.md's prompt list offered.

**Supersedes:** The "Extract Files: Keep Permanently, Prune Duplicated Content" decision above is partially updated — §Changes is no longer pruned (it stays in the Extract since there's no Dev.md to hold it). Only §Learnings and §Decisions are still pruned via manifest.

**See:** `.claude/skills/r-end2/SKILL.md`, Conv 034

### Skill Consolidation: spt-docs Back-Port
**Date:** 2026-03-27 (Conv 035)

Ported the simplified skill architecture from the spt-docs project back to peerloop-docs. The spt-docs skills were originally derived from peerloop-docs but evolved to consolidate 8 end-of-conv skills into a single `/r-end` with 3 parallel agents, inline resume logic in `/r-start`, and a unified `/r-timecard`.

**Changes:**
- `/r-end` now owns all end-of-conv processing: Extract collection, 3 parallel agents (learn-decide, update-plan, docs), state save, commit/push. Replaces r-end (legacy), r-end2, r-eos, r-dump, r-learn-decide, r-docs, r-update-plan, r-save-state.
- `/r-start` inlines resume logic (Step 8) — no separate `/r-resume` skill.
- `/r-timecard` replaces `/w-timecard-dual`. `/w-timecard` (single-repo) preserved separately.
- `/r-prune-claude` renamed from `/w-prune-claude` for prefix consistency.
- Agent format refs moved to `r-end/refs/`, docs scripts to `r-end/scripts/`.
- `r-end-agent-failed` from spt-docs was NOT ported — references non-existent `.claude/agents/` definitions.

**Result:** 22 skills → 14 skills (5 r-* + 9 w-*). Rollback tag: `pre-skill-migration`.

**Rationale:** Fewer skills = less maintenance, fewer skill-to-skill call failures, faster end-of-conv execution. The spt-docs version proved stable over multiple conversations.

**See:** `.claude/skills/r-end/SKILL.md`, Conv 035

### Post-/r-end Fix Pattern: /r-start Without /clear
**Date:** 2026-03-27 (Conv 036)

When fixes are needed after /r-end completes, run `/r-start` (without `/clear`) to open a new conv with full conversation context. Fix the issue, then `/r-end`. Each fix gets its own conv number with proper session docs.

**Rationale:** Zero changes to any skill required. The pattern works because: (1) /r-end commits and pushes, leaving repos clean; (2) /r-start pulls, increments counter, and pushes — which also pushes any post-/r-end commits that piggybacked; (3) /r-start overwrites `.conv-current` with the new conv number. Alternatives (gate inside /r-end, split into /r-end + /r-close, gate + topup skill) all added complexity with no benefit.

**See:** Conv 036 Decisions.md

### r-end Closing Menu
**Date:** 2026-03-27 (Conv 036)

After /r-end completes, a text-based menu offers two options: (1) `/clear` to start fresh, or (2) `/r-start` to continue with existing history. User types 1 or 2. `Skill` added to r-end allowed-tools for /r-start invocation.

**Rationale:** Keyboard-selectable widgets are not possible in Claude Code — text menu is the only UX option.

**See:** `.claude/skills/r-end/SKILL.md`, Conv 036 Decisions.md

### Persist Implementation Plans to Committed Files
**Date:** 2026-03-29 (Conv 056)

Implementation plans that need to survive across conversations are persisted to `docs/as-designed/` and committed to git. `.claude/plans/` is for in-conversation use only — it is gitignored and ephemeral.

**Trigger:** Conv 055 created a detailed plan in Plan Mode. User was told it was "saved." After /r-end, /clear, /r-start, the plan file was gone. Session files capture decisions/learnings but not implementation-level detail (component signatures, SQL queries, file paths).

**Rationale:** When user says "save the plan," they mean persist permanently. `docs/as-designed/{plan-name}.md` is durable, committed, and available to future conversations.

**See:** Conv 056 Decisions.md

### Composable STUMBLE Segments Over Monolithic Instances
**Date:** 2026-04-01 (Conv 071)

STUMBLE walkthroughs should be built from small chainable segments (2-3 steps each) rather than monolithic instances. Segments align with service boundaries (local vs external dependencies). A failed segment can be re-run independently without restarting from the beginning.

**Rationale:** Flywheel STUMBLE hit a natural boundary at checkpoint 10 (Stripe) — checkpoints 11-14 (BBB) couldn't be tested in dev. Composable segments provide failure isolation, incremental coverage, and reuse across instances.

**See:** Conv 071 Decisions.md, `docs/as-designed/plato.md`

### Pre/Post Segment Split for Fix-and-Verify
**Date:** 2026-04-02 (Conv 077)

When a STUMBLE walkthrough encounters a failure, split the instance at the failure point: Pre-segment (steps before) runs in API mode with `snapshot: true` to build DB state fast, Post-segment (failure onward) is walked in browser after restoring the snapshot to verify the fix visually.

**Rationale:** One snapshot per failure point, not N per step. Uses existing infrastructure (API mode, snapshots, browser mode). Segment files are one-off by default but may be promoted to permanent scenarios.

**See:** Conv 077 Decisions.md, `docs/as-designed/stumble-workflow.md`

### Editor Migration: Cursor to VS Code
**Date:** 2026-04-05 (Conv 084)

All editor references migrated from `cursor` to `code` across skills, hooks, config, templates, and docs. VS Code is the standard editor housing the Claude Code terminal.

**Rationale:** User decision to move from Cursor to VS Code. 9 files updated across skills (4), global config (3), template (1), and docs (1). Session logs left as historical records.

> **Insight:** Editor references are scattered across skills, hooks, config templates, permission entries, and docs. When migrating editors, a full-repo search for the old editor command name is necessary — `config.json` alone is not sufficient.

### Structured Commit Tags for Categorical Extraction
**Date:** 2026-04-06 (Conv 085)

Commit messages use prefixed single-line tags (`API:`, `Page:`, `Role:`, `Infra:`) in the commit body. Timecard skills extract these into dedicated sections. Tags are optional and backward-compatible — old commits produce empty sections that get omitted.

**Rationale:** Simple prefix matching on git log output, consistent with existing `User-facing:` / `Admin-facing:` pattern. Avoids parser-maintenance burden of YAML/JSON in commit bodies while remaining human-readable. The commit is the single source of truth; extraction complexity lives in the timecard skills.

> **Insight:** Commit messages as structured data sources follow the Unix philosophy — keep the storage format simple and greppable, push complexity into the extraction tool.

### TodoWrite Mnemonic Short Codes (Global)
**Date:** 2026-04-06 (Conv 089, collision rule Conv 090)

TodoWrite tasks use `[XX] Subject` prefix format (2-3 character mnemonic codes). Added to global `~/.claude/CLAUDE.md` under Work Tracking, not project-specific. On collision within the current task list, append sequential numbers: `[GE]` -> `[GE2]` -> `[GE3]`.

**Rationale:** Convention is project-agnostic — user can say "do PL" in any project to execute the matching task. Collision numbering ensures uniqueness without sacrificing mnemonic readability. Ported from spt-docs.

### Three SPT Governance Directives Ported
**Date:** 2026-04-06 (Conv 089)

Added "Ask Before Deciding" (structural/architectural decisions require user approval), "Preserve `!` Backtick Determinism" (skill pre-computed context is immutable), and "Multi-Session Blocks" (CURRENT-BLOCK-PLAN.md pattern) to peerloop-docs CLAUDE.md.

**Rationale:** Fills governance gaps — Solution Quality override covered solutions but not structural decisions; backtick determinism wasn't documented; CURRENT-BLOCK-PLAN.md existed as skill but wasn't in CLAUDE.md. Ported selectively from spt-docs (not all differences, only actionable rules).

### Claude Code PreToolUse Hook for Timezone Lint Enforcement
**Date:** 2026-04-06 (Conv 091)

A PreToolUse hook (`.claude/hooks/pre-commit-lint-tz.sh`) intercepts `git commit` Bash calls targeting the Peerloop code repo and runs `lint-timezone.sh` before allowing the commit. Violations block the commit with denial; clean runs allow it.

**Rationale:** Claude is currently the sole committer. A git pre-commit hook (husky) would add a build dependency for a single-dev project. The fragility — human commits bypass this gate — is documented in `docs/as-designed/lint-timezone.md` with a mitigation path (add husky + CI when a second developer joins).

**Consequence:** Human commits are ungated. `docs/as-designed/lint-timezone.md` created with full fragility analysis.

### Always Use /r-end for Commits (Never /r-commit Directly)
**Date:** 2026-04-06 (Conv 091)

`/r-commit` should only be used when the user explicitly requests a mid-session save. Default end-of-conv commit path is always `/r-end`.

**Rationale:** `/r-end` runs session documentation agents (learn-decide, update-plan, docs). Committing via `/r-commit` skips those agents, causing overlapped or missing session docs for the next conv. Saved as feedback memory.

### Writer/Reader Tag Contract Must Be Symmetric Across All Readers
**Date:** 2026-04-10 (Conv 099)

When a commit-metadata tag (e.g., `Doc:`, `Infra:`) is added to the writer side (r-commit, r-end), every reader must extract it or content is silently dropped. Readers: `r-timecard-day`, `r-timecard`, `w-git-history`. Symmetric rule also applies in the inverse direction: a reader added without a corresponding writer yields empty sections.

**Rationale:** Conv 098 added `Doc:` extraction to `r-timecard-day` but not to `r-timecard`, leaving r-timecard as a silent orphan for three convs. Fixed in Conv 099 [SS2] by porting the extraction. Checklist: any new writer tag must be traced through every reader; any new reader tag must have a writer emitting it.

### w-sync-docs Audits Expanded: Schema + Cross-Document Consistency
**Date:** 2026-04-10 (Conv 099)

`/w-sync-docs` now covers 5 audit categories (was 3): Test Docs, API Docs, Schema Docs (DB-GUIDE.md vs 0001_schema.sql), CLI Docs, Cross-Document Consistency (5.1 DECISIONS.md/DOC-DECISIONS.md category coverage + mis-routing, 5.2 CLAUDE.md Technology Stack table vs package.json, 5.3 rfc/INDEX.md vs CD-* folders).

**Rationale:** Ported from spt-docs during [SS5] skill-sync with adaptation to Peerloop paths and the DECISIONS/DOC-DECISIONS split. Audits are non-blocking (report-only), no behavior change until invoked.

### w-sync-skills Hardened: DIRECTION Block + Self-Applicable Guardrails
**Date:** 2026-04-10 (Conv 099)

`/w-sync-skills` Step 3 now includes a verbatim DIRECTION block declaring SOURCE/LOCAL, framing every finding as "Source has: … / Local has: …", and treating local-only content as customization to preserve (not a gap). Explore-agent delegations must restate the DIRECTION block and use SOURCE/LOCAL labels (never "project A/B"). Step 5b added: compare CLAUDE.md behavioral directives (including `~/.claude/CLAUDE.md`) in addition to skill files.

**Rationale:** Prevents Claude from suggesting to delete legitimate local customizations as "drift from source". Validated in-session by running the hardened skill on itself ([SS6]), where the rule correctly classified the new DIRECTION block as a local-only customization to preserve.

### PLAN.md Status Markers Must Be Verifiable Against Git State
**Date:** 2026-04-10 (Conv 099)

A PLAN block marked "IN PROGRESS" with a branch name must correspond to a real git branch in the code repo. PACKAGE-UPDATES was marked "IN PROGRESS (Conv 096)" for three convs with zero code changes and no `jfg-package-updates` branch anywhere.

**Rationale:** Silent status drift wastes future-conv cycles (trying to "continue" nonexistent work) or hides missed work. Candidate sanity check: /r-end docs agent or /w-codecheck audit that runs `git branch --list {name}` for any IN PROGRESS block claiming a branch. Tracked as Uncategorized in Conv 099 extract.

---

## 4. Obsidian Vault

### Local .obsidian/ Per User
**Date:** 2026-02-20 (Session 229)

Each user creates their own `.obsidian/` folder locally. It is gitignored and never committed. Users customize their own themes, plugins, and workspace layout independently.

### Markdown Links Over Wikilinks
**Date:** 2026-02-21 (Session 233)

Obsidian configured with `useMarkdownLinks: true` — standard `[text](path)` format, not `[[wikilinks]]`.

**Rationale:** Files are viewed on GitHub (client deliverable), in VS Code, and in CC context. Standard markdown links render correctly everywhere. Wikilinks only work inside Obsidian.

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

### DOC-DECISIONS.md for Docs-Repo Decisions
**Date:** 2026-02-21 (Session 233)

`/w-learn-decide` (migrated to Skills 2 in Session 367) routes decisions to the appropriate file:
- **Peerloop application decisions** (code, schema, UI, API) → `docs/DECISIONS.md`
- **Docs-repo decisions** (organization, workflows, CC config, vault) → `DOC-DECISIONS.md`

Same structured format (trigger, options, rationale, consequences) for both.

> **Insight:** The split between DECISIONS.md and DOC-DECISIONS.md mirrors a distinction that exists in most software projects but is rarely made explicit: product decisions (what we're building) vs process decisions (how we work). By separating them, each file stays focused and navigable. Because DOC-DECISIONS.md tracks docs-repo conventions, it becomes a portable reference — if you start a new client project with a similar docs-first architecture, the playbook carries forward as a template. (Session 233)

### Durable Insight Capture
**Date:** 2026-02-21 (Session 233)

During `/w-learn-decide` processing, `★ Insight` blocks are scanned for durable, informative insights. Qualifying insights are co-located with the decision they illuminate as `> **Insight:**` blockquotes.

**Rationale:** Co-locating insights with decisions follows the same principle as co-locating tests with code — the context you need to understand *why* something exists should be as close as possible to the thing itself. Separate files create cross-referencing overhead.

**Qualification:** An insight is durable if it connects a decision to broader professional context, explains why a convention works well beyond the immediate rationale, or would teach someone starting a similar project.

### Dynamic Tech Doc Sweep in /r-docs
**Date:** 2026-03-05 (Session 334), migrated to Skills 2 (Session 364)

`/r-docs` dynamically discovers tech docs (`docs/reference/*.md`, `docs/as-designed/*.md`) and cross-references against code paths changed in the session. No hard-coded mapping to maintain — new tech docs are automatically included. Originally implemented in `/q-docs-local` section 7; now runs as `tech-doc-sweep.sh` helper script via `!` backtick injection.

**Trigger:** Session 334 missed updating `session-booking.md` during `/q-docs` because the existing checklist only triggered on package/config changes, not domain code changes.

**Options Considered:**
1. Hard-coded code-path → tech-doc table — drifts as tech docs are added
2. Hard-coded table + maintenance skill in `/w-eos` — extra step, easy to forget
3. Dynamic sweep: discover docs, match against session changes ← Chosen

**Rationale:** 31 tech docs and growing. Any static mapping becomes stale. The dynamic approach has zero maintenance cost and catches new tech docs automatically. The heuristic matching (code path patterns → topic keywords) doesn't need to be perfect — it's a reminder check, not a gate.

**See:** `.claude/skills/r-docs/scripts/tech-doc-sweep.sh`

### Feature Tracking Rule: All Features Must Be in PLAN.md
**Date:** 2026-03-05 (Session 342)

Any time a feature is mentioned — in a tech doc, session discussion, RFC, or code comment — it must be added to `PLAN.md`. Where it goes is situational (active block, deferred, sub-task of an existing block). If the feature originated from a tech doc, add a cross-reference noting the PLAN block (e.g., "Tracked in PLAN.md: RATINGS-EXT"). Tech docs describe *how* and *why*; PLAN.md is the single source of truth for *what needs to be done*.

**Trigger:** Scanned all 31 tech docs and found 4 blocks worth of untracked development work (POSTHOG, MOCK-DATA-MIGRATION, RATINGS-EXT, CURRENTUSER-REFRESH) plus 1 missing item in an existing block (SessionHistory in MSG-ACCESS.PHASE2).

**Rationale:** Without this rule, features silently accumulate in tech docs where they're invisible to planning. The cross-reference closes the loop in both directions.

**See:** CLAUDE.md "Feature Tracking Rule" section

### DB-GUIDE.md Replaces DB-SCHEMA.md
**Date:** 2026-03-07 (Session 359)

`docs/reference/_DB-SCHEMA.md` deprecated. Replaced by slim `docs/reference/DB-GUIDE.md` that covers only design rationale — the *why* behind the schema. For column names, types, and constraints, use the SQL source of truth (`../Peerloop/migrations/0001_schema.sql`).

**Trigger:** Capabilities review found DB-SCHEMA.md massively out of sync: TERMINOLOGY renames never applied, 15+ columns undocumented, 23 tables documented but never built. The file duplicated information already in the SQL and always drifted.

**Options Considered:**
1. Full rewrite of DB-SCHEMA.md to match current SQL
2. Drop entirely — just use SQL
3. Replace with slim guide covering only rationale ← Chosen

**Rationale:** Documentation that duplicates code will always drift. The SQL file is what developers reference. The only value worth maintaining is design rationale: why Community > Progression > Course, why capabilities not roles, how the two rating systems work, payment split architecture. DB-GUIDE.md captures that in ~200 lines vs DB-SCHEMA.md's 2000+.

**Consequences:** DB-SCHEMA.md kept with deprecation banner for history. References updated in CLAUDE.md, DOC-DECISIONS.md, docs/DECISIONS.md, q-docs-local.md (now deleted — migrated to Skills 2 `/r-docs`, Session 364). Session logs left as-is.

**See:** `docs/reference/DB-GUIDE.md`, `../Peerloop/migrations/0001_schema.sql`

### Test Doc Paths: Repo-Root-Relative
**Date:** 2026-03-16 (Session 390)

All test file paths in backtick-quoted references across TEST-COVERAGE.md, TEST-COMPONENTS.md, TEST-PAGES.md, TEST-UNIT.md, and TEST-E2E.md use repo-root-relative format: `tests/api/admin/dashboard.test.ts`, not `admin/dashboard.test.ts`.

**Trigger:** Automated diffing of TEST-COVERAGE.md against disk failed because API paths used section-relative format while other categories used full paths. Required an awk normalization script to compare.

**Rationale:** Repo-root-relative paths: (1) work as direct `npx vitest run` arguments, (2) are unambiguous without section context, (3) are grepable across docs, (4) diff cleanly against `find` output.

### Test Doc Family: One Category Per Secondary Doc
**Date:** 2026-03-16 (Session 390)

Each secondary test doc owns exactly one test category. TEST-UNIT.md covers `tests/lib/`, `tests/unit/`, `tests/integration/`, `tests/ssr/` only — not E2E (which has its own dedicated doc at TEST-E2E.md).

**Trigger:** TEST-UNIT.md contained a stale E2E summary ("4 files, 19 tests") that silently drifted while the real E2E suite grew to 25 files/105 tests.

**Rationale:** Duplication across docs causes silent drift. Each doc should be the single source of truth for its category.

### /w-sync-docs Skill for Documentation Drift Detection
**Date:** 2026-03-16 (Session 390)

Created `/w-sync-docs` as a dedicated skill for auditing documentation against the actual codebase. Replaces the generic `/q-sync-docs` command. Includes a 7-point test doc audit (summary counts, phantoms, undocumented files, cross-reference, section headers, path format, blank counts) plus API and CLI audits.

**Trigger:** Session 390 found significant test doc drift: summary said 379 Vitest files but actual was 321, section headers had wrong counts, 1 file missing from listings, paths inconsistent.

**Rationale:** The manual reconciliation workflow done in Session 390 should be repeatable. The skill encodes the exact checks that caught real issues, including the TodoWrite discipline requirement for any unfixed findings.

**See:** `.claude/skills/w-sync-docs/SKILL.md`

### sync-gaps.sh: Two-Level Route Mapping and Fixed-String Matching
**Date:** 2026-03-20 (Conv 022)

`sync-gaps.sh` API route detection upgraded with three fixes that reduced false positive rate from 93% (63 of 67 reported gaps were false) to 0%:

1. **`index.ts` → parent path:** Search for route path (e.g., `admin/analytics`) instead of literal "index"
2. **Fixed-string grep:** `grep -qiF` instead of `grep -qi` to prevent `[id]` being interpreted as a regex character class
3. **Two-level `me/*` mapping:** 15 sub-route entries (e.g., `me/profile|API-USERS.md`, `me/messages|API-MESSAGES.md`) checked before the fallback `me|API-ENROLLMENTS.md`

Also added 12 missing route prefix mappings and dual-notation search (`:id` and `[id]`) to handle the inconsistent param notation across API docs.

**See:** `.claude/skills/r-docs/scripts/sync-gaps.sh`, `.claude/skills/r-docs/scripts/route-mapping.txt`

### Public Endpoints → API-PLATFORM.md
**Date:** 2026-03-20 (Conv 022)

Unauthenticated public endpoints are documented in `API-PLATFORM.md`, not in the domain-specific doc where the authenticated version lives. Example: `/api/certificates/[id]/verify` (public, no auth) → API-PLATFORM.md, while `/api/admin/certificates/*` (admin-only) → API-ADMIN.md.

**Rationale:** API-PLATFORM.md already groups public utility endpoints (`/api/faq`, `/api/stories`, `/api/contact`, `/api/health/*`). Mixing public and admin-only endpoints in the same doc creates confusion about auth requirements.

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

**See:** PLAN.md, `.claude/skills/r-update-plan/SKILL.md`

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
2. Annotate docs/requirements/rfc/CD-036 (historical record, not ideal for living reference)
3. New standalone `AUTHORITY-MAP.md` (yet another file to maintain)

**Rationale:** ROLES.md is already the role reference. The authority map complements the per-role sections (§1-6) by showing the same information from the hierarchy's perspective. Avoids a separate file that duplicates role information.

**See:** `docs/reference/ROLES.md` (§ Content Hierarchy & Authority Map)

### POLICIES.md for Platform Behavior Rules
**Date:** 2026-03-01 (Session 319)

Created `POLICIES.md` for prescriptive platform behavior policies — access control rules, business logic, user capabilities. If code contradicts a policy, the code is the bug.

**Trigger:** Creator access control policies (permission vs state gating, revocation behavior) didn't fit into docs/DECISIONS.md (architectural/implementation) or DOC-DECISIONS.md (docs-repo conventions).

**Options Considered:**
1. Add to docs/DECISIONS.md under a new section
2. Create a separate docs/POLICIES.md ← Chosen

**Rationale:** docs/DECISIONS.md records *how* we build (architecture). docs/POLICIES.md defines *what* the platform does (behavior). The distinction matters because policies are the authority when code is inconsistent — exactly the situation that revealed the creator access bugs.

**Three decision documents now:**
- **docs/POLICIES.md** — How the platform *behaves* (access rules, business logic)
- **docs/DECISIONS.md** — How we *build* it (architecture, tech choices)
- **DOC-DECISIONS.md** — How the *docs repo* works (workflow, conventions)

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

### Generated Docs Must Have a Single Regeneration Command
**Date:** 2026-03-12 (Session 383)

Any documentation artifact that is derived from code (test inventories, route matrices, page connections) must be regenerable with a single `npm run` command. One-off scripts that produce committed artifacts must be folded into permanent tooling in the same session they're created.

**Trigger:** ROUTE-GRID TSVs were created by a one-off `/tmp/build-route-grid.js` (Session 367). By Session 383 the script was gone and the TSVs were stale. Had to reverse-engineer the output format to consolidate into `route-matrix.mjs`.

**Rule:** If the output gets committed to the repo, the script that creates it must be committed too, with an npm script entry. The test: can someone who's never seen the project regenerate all docs by reading package.json?

**See:** `scripts/route-matrix.mjs`, `npm run route-matrix`, PLAN.md DOC-SYNC-STRATEGY block

### Skill Script References Must Be Drift-Proof
**Date:** 2026-03-17 (Conv 003, corrected Conv 005)

All `!` backtick pre-computed context and `git -C` instructions in skill SKILL.md files must use drift-proof paths — never relative paths, never hardcoded home directories.

**Trigger (Conv 003):** `/r-end` failed because cwd had drifted to `../Peerloop` after `cd ../Peerloop && npm test`. Relative paths broke.

**Trigger (Conv 005):** Hardcoded `/Users/jamesfraser/` paths from MacMiniM4-Pro broke on MacMiniM4 (`/Users/livingroom/`). The two machines do NOT share a home directory structure.

**Current approach:** Use `$CLAUDE_PROJECT_DIR` in prose `git -C` instructions (Claude resolves at runtime) and in script references. However, `$CLAUDE_PROJECT_DIR` does **not** expand in `!` backtick pre-computation — it expands to empty string, causing `/.claude/scripts/...` errors.

**Open issue:** Need a mechanism for `!` backtick commands that resolves the docs repo root without hardcoding. Possible approaches: wrapper script using `git rev-parse`, anchor-file detection, or a fix from Anthropic to pass env vars into `!` backtick execution.

**Rule:** CWD is unreliable in a dual-repo session. Never use relative paths. Never hardcode home directories. Use `$CLAUDE_PROJECT_DIR` for prose instructions; `!` backtick resolution is an open problem.

---

### Inline Doc Updates Per PLAN Sub-Block
**Date:** 2026-03-24 (Conv 024)

Every PLAN sub-block that changes code must include a doc update task specifying the target file (`session-room.md`, `session-booking.md`, `API-ADMIN.md`, etc.). Code and docs ship together — doc updates are not deferred to a cleanup phase at the end of the block.

**Rationale:** Batching doc updates to a cleanup phase risks drift and loss of context. The person writing the code has the best understanding of what changed and why — capturing it immediately is cheaper than reconstructing it later.

### CLAUDE.md Overrides System Prompt's "Simplest First" Bias
**Date:** 2026-03-24 (Conv 025)

Added a "Solution Quality" section to CLAUDE.md that explicitly overrides the system prompt's "avoid over-engineering" and "try the simplest approach first" defaults. Claude must present quick, durable, and middle-ground options and let the user choose. The user decides what constitutes over-engineering.

**Rationale:** The system prompt's default simplicity bias led to repeated quick-fix choices without presenting alternatives (e.g., generic message link instead of inline form, silent error swallowing, auth expansion without abuse-case analysis). Accumulated simple fixes create long-term debt in a production codebase.

### Browser Testing Comparison → Reference Doc
**Date:** 2026-04-07 (Conv 094)

Chrome MCP vs Playwright comparison created as `docs/reference/BROWSER-TESTING.md` (standalone reference doc), not appended to `plato.md` or placed in `as-designed/`. Cross-referenced from `CLI-TESTING.md`.

**Rationale:** It's a tool comparison with practical guidance ("when to use which tool"), which matches the reference doc pattern established by `CLI-TESTING.md` and other reference docs.

### `Doc:` and `Infra:` Structured Commit Tags Cleanly Separated (Option B)
**Date:** 2026-04-10 (Conv 098)

Doc-related commits (both content edits and structural reorganization — moves, renames, splits, consolidation) use `Doc:`. `Infra:` is reserved for tooling, scripts, hooks, skills, build config, and dev workflow. No overlap. r-commit, r-end, and r-timecard-day are all consistent on this boundary after porting the `Doc:` tag from spt-docs and adding a tiebreaker rule in r-end (content/structural doc changes → Doc; tooling that manages docs → Infra).

**Rationale:** A clean split is easier to follow than a fuzzy boundary. r-end commits are docs-only and become the primary source of `Doc:` lines. Daily timecards now aggregate doc work into a dedicated `#### Doc Changes` section instead of mixing it into Infra.

### "Doc Reorganization" Added as Important Decision Criterion
**Date:** 2026-04-10 (Conv 098)

Added a 6th row to the "Important Decision Criteria" table in `.claude/skills/r-end/refs/fmt-learn-decide.md`: "Doc reorganization | New doc categories, naming conventions, cross-reference patterns, per-section docs, doc consolidation". Ported verbatim from spt-docs.

**Rationale:** Peerloop does substantial doc reorganization work that doesn't fit the existing criteria (architecture, code style, technology selection, breaking change, thwarted-by-conditions) but is durable and worth recording in DOC-DECISIONS.md. Gives the learn-decide agent explicit grounds to promote such decisions. Closely related to the Doc/Infra separation decision above.
