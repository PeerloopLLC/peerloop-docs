# PLAYBOOK.md

This document tracks decisions about **how the peerloop-docs repo itself works** — its organization, workflows, conventions, and tooling. For Peerloop application decisions (code, schema, UI), see `DECISIONS.md`.

**Last Updated:** 2026-02-21 Session 236 (SCRIPTS.md reference, /q-docs Scripts Sync Check)

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
│   ├── pagespecs/            # Page design specs
│   ├── pages/                # Page metadata
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
| Page specs (JSON runtime) | `../Peerloop/src/data/pages/` | Yes (code repo) |

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

### CC Hooks Run in Minimal Shell
**Date:** 2026-02-20 (Session 229)

Claude Code hooks execute in a minimal shell that does NOT source `~/.zshrc` or `~/.bash_profile`. Tools managed by nvm, Homebrew (`/opt/homebrew/bin`), or other profile-dependent managers are invisible.

**Pattern:** Hook scripts must explicitly source dependencies:
```bash
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
```

**Consequence:** Diagnostic/informational hooks should always `exit 0`. Non-zero exits are treated as errors by CC.

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

### Deferred Blocks in PLAN.md
**Date:** 2026-02-21 (Session 233)

Work that is planned but not yet needed uses the `Deferred:` prefix in PLAN.md with:
- Context section (current state, what's needed)
- Task checklist
- **Triggers section** — conditions that indicate when to start the work
- **Dependencies section** — what must be in place first

**Example:** `Deferred: SENTRY` — production error tracking, triggered when MVP-GOLIVE begins.

### SCRIPTS.md as Unified Scripts Reference
**Date:** 2026-02-21 (Session 236)

Create `docs/reference/SCRIPTS.md` as the single reference for all npm scripts, script files (`scripts/*.{js,ts,sh,mjs}`), and page test scripts (`scripts/page-tests/test-*.sh`). Organized by category with cross-reference tables mapping npm scripts to underlying script files.

**Trigger:** Audit found 13 of 21 script files had zero documentation. 9 standalone scripts (no npm wrapper) were completely undiscoverable.

**Rationale:** npm scripts were documented across 4 CLI-*.md files but the underlying script files were not. A unified document makes the entire scripts ecosystem discoverable — both "what commands can I run?" and "what do these script files do?"

**Consequences:** Added to CLI-QUICKREF.md navigation table. Added Scripts Sync Check to `/q-docs` global skill (conditional: only runs if SCRIPTS.md exists, keeping the skill portable across projects).

**See:** `docs/reference/SCRIPTS.md`, `~/.claude/commands/q-docs.md`
