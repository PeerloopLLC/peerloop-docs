# Skills System Architecture

**Created:** 2026-03-10 (Session 364)
**Status:** Active

## Overview

Peerloop uses Claude Code **Skills 2** for development workflow automation. Skills are directory-based units that live in `.claude/skills/<name>/` and contain a `SKILL.md` (instructions + frontmatter) plus optional supporting files (scripts, data files, metadata).

A canonical template repository (`~/skills-canon/`) holds portable skill templates. Each project gets a **real copy** that can diverge — drift is managed, not prevented.

### Why Skills 2

The previous system used paired command files — a global `~/.claude/commands/q-docs.md` plus a local `.claude/commands/q-docs-local.md`. The global file contained portable logic; the local file added project-specific context. This had three problems:

1. **Handoff fragility.** The global file had to say "now read the local file." Claude sometimes didn't.
2. **No pre-computation.** All data gathering (find changed files, compare routes, etc.) happened at runtime via tool calls — slow, non-deterministic, and expensive in tokens.
3. **Unclear ownership.** Bug fixes and improvements had to be applied in the right file (global vs local). Some logic was duplicated. The interplay between "global does X, then calls local for Y" was hard to reason about and easy to break when either file changed independently.

### Architecture: Local-Only with Marked Sections

Skills 2 abandons the global/local interplay. Each project skill is a **single, self-contained SKILL.md** that owns its entire workflow. There is no runtime delegation to a second file.

**Project-specific content is inlined** using `<!-- PROJECT -->` comment markers in the canonical template. When a skill is installed in a project, these markers indicate where to add project configuration — file paths, topic lists, route mappings, output formats. Everything else is portable across projects.

```markdown
## Topics (Priority Areas)
<!-- PROJECT: Add project-specific scan topics below -->
| Topic | Scan For |
|-------|----------|
| `d1` | Cloudflare D1, SQLite, migrations |
| `stripe` | Payments, Connect, webhooks |
<!-- END PROJECT -->
```

**Why this works better:**
- **One file to read, one file to fix.** No cross-file dependencies to trace.
- **Customization is visible.** `<!-- PROJECT -->` markers clearly delineate what's portable vs project-specific. A developer (or drift tool) can instantly see what was customized.
- **Global commands still exist** in `~/.claude/commands/` as fallbacks for projects that haven't migrated. They are never called by project skills — they're a separate, independent layer.

### Prefix Convention: r-* vs w-* vs q-*

Project skills use two prefixes: `r-*` for conv lifecycle skills (start, end, commit, timecard) and `w-*` for Peerloop-specific work skills (codecheck, schema-dump, etc.). Global commands retain `q-*`. This eliminates autocomplete collisions in the Claude Code UI, where identically-named project and global skills appeared as ambiguous `(project)` / `(user)` options. The prefix makes origin immediately obvious: `r-*` is conv lifecycle, `w-*` is project-local, `q-*` is always global.

Skills 2 solves the technical problems: a single `SKILL.md` replaces the two-file split, and `!` backtick injection runs shell scripts *before* the prompt is assembled, injecting data directly.

---

## Directory Layout

### Per-Project (Peerloop)

```
.claude/skills/r-end/
├── SKILL.md              # Consolidated end-of-conv skill (collector + agent dispatch)
├── refs/
│   ├── fmt-docs.md         # Format rules for docs agent
│   ├── fmt-learn-decide.md # Format rules for learn-decide agent
│   └── fmt-update-plan.md  # Format rules for update-plan agent
└── scripts/
    ├── detect-changes.sh   # Changed files since last run
    ├── sync-gaps.sh        # CLI/API/test doc coverage gaps
    ├── tech-doc-sweep.sh   # Vendor/architecture docs needing review
    ├── dev-env-scan.sh     # Machine-specific mentions in sessions
    └── route-mapping.txt   # API route → doc file mapping (shared data)
```

### Canonical Repository

```
~/skills-canon/
├── q-docs/
│   ├── SKILL.md              # Portable template with <!-- PROJECT --> markers
│   └── CUSTOMIZATION-GUIDE.md # What to change per project
└── tools/
    ├── drift-report.sh       # Section-level divergence detection
    ├── skill-patch.sh        # Interactive surgical sync
    └── install.sh            # Deploy skill to a new project
```

---

## Key Concepts

### `!` Backtick Injection

Skills 2 runs shell commands in `` !`...` `` blocks before assembling the prompt. The command's stdout replaces the block. Claude sees *data*, not *instructions to gather data*.

```markdown
### What Changed
!`${CLAUDE_SKILL_DIR}/scripts/detect-changes.sh 2>/dev/null || echo "(unavailable)"`
```

At invocation, this becomes:

```markdown
### What Changed
## Changed Files
*(since last /r-end run)*
### Code repo (Peerloop)
src/pages/api/me/full.ts
tests/lib/current-user-cache.test.ts
...
```

**Effect:** Instructions shrank 68% (629 → 200 lines). Total prompt grew (~1000 lines of injected data) but eliminates dozens of runtime tool calls. Claude's role shifts from detective to editor.

### Marker-Anchored Detection

`detect-changes.sh` writes a marker file containing the HEAD SHAs of both repos after each run. The next run diffs from that marker forward, showing only changes since the last `/r-end` execution.

| Scenario | Behavior |
|----------|----------|
| First run (no marker) | Falls back to `--since "24 hours ago"` |
| Subsequent runs | Diffs from marker SHA to HEAD + uncommitted |
| Marker SHA not found locally | Falls back to `--since` (e.g., other machine ahead) |
| Manual reset | `detect-changes.sh --reset` deletes marker |

The marker is **committed to git**, not gitignored. This is intentional — Peerloop development happens across two Mac Minis, so the "last documented up to here" pointer needs to travel with the repo. Mac A runs `/r-end`, commits the marker; Mac B pulls and continues from that point.

### Drift Management

Each project gets a **real copy** of skill files from `skills-canon`. Drift is inevitable — projects evolve at different rates and need project-specific modifications. The system makes drift *visible and manageable*, not prevented.

| Tool | Purpose |
|------|---------|
| `drift-report.sh` | Section-level divergence detection between project copy and canonical |
| `skill-patch.sh` | Interactive sync — select sections to push (project → canonical) or pull (canonical → project) |
| `install.sh` | Deploy a canonical skill to a new project |
| `.sync` metadata | Tracks last reconciliation date, divergence status, and notes |

The canonical template uses `<!-- PROJECT -->` comment markers to indicate expected customization points. Sections outside these markers are portable; sections inside are project-specific by design.

### Shared Data Files

When both a SKILL.md and a helper script need the same data (e.g., API route → doc file mapping), the data lives in a shared file rather than being duplicated.

`route-mapping.txt` uses a simple `prefix|doc_file` format:

```
auth|API-AUTH.md
courses|API-COURSES.md
users|API-USERS.md
...
```

`sync-gaps.sh` reads it programmatically. The docs agent format reference (`refs/fmt-docs.md`) points to it as the authoritative source.

---

## Skill Reference

### Current Skills (16 total)

**Conv lifecycle (r-* prefix):**

| Skill | Location | Purpose | Helper Files |
|-------|----------|---------|--------------|
| `/r-start` | `.claude/skills/r-start/` | Start conversation — pull, increment, resume | — |
| `/r-end` | `.claude/skills/r-end/` | End conversation — collector + 3 parallel agents (learn-decide, update-plan, docs) | refs/fmt-*, scripts/* |
| `/r-commit` | `.claude/skills/r-commit/` | Commit both repos with Conv metadata | dual-repo-status, conv-read-current |
| `/r-timecard` | `.claude/skills/r-timecard/` | Merged dual-repo timecard for client billing | — |
| `/r-timecard-day` | `.claude/skills/r-timecard-day/` | Daily timecard with gap grouping and rounding | — |
| `/r-prune-claude` | `.claude/skills/r-prune-claude/` | Optimize CLAUDE.md by offloading reference content | — |

**Peerloop-specific (w-* prefix):**

| Skill | Location | Purpose | Helper Files |
|-------|----------|---------|--------------|
| `/w-codecheck` | `.claude/skills/w-codecheck/` | Code quality checks (TS + ESLint + Tailwind + Astro) | — |
| `/w-timecard` | `.claude/skills/w-timecard/` | Generate single-repo conv timecard | — |
| `/w-git-history` | `.claude/skills/w-git-history/` | Extract and format commit history | — |
| `/w-add-client-note` | `.claude/skills/w-add-client-note/` | Process client notes into RFC checklists | — |
| `/w-schema-dump` | `.claude/skills/w-schema-dump/` | Export table schema to TSV | — |
| `/w-post-fix` | `.claude/skills/w-post-fix/` | Lightweight end-of-conv for bug-fix conversations | — |
| `/w-sync-docs` | `.claude/skills/w-sync-docs/` | Audit docs for drift against codebase | — |
| `/w-sync-skills` | `.claude/skills/w-sync-skills/` | Port skill improvements from another dual-repo project | — |
| `/w-review-resume-state` | `.claude/skills/w-review-resume-state/` | Review RESUME-STATE.md for staleness | — |
| `/w-test-env` | `.claude/skills/w-test-env/` | Validate skill environment variables | — |

### Consolidation History

**Conv 035 (2026-03-27):** Major skill consolidation back-ported from spt-docs project. Reduced from 22 to 14 skills. Key changes:
- `/r-end` absorbed 8 skills: r-end2, r-eos, r-docs, r-dump, r-learn-decide, r-update-plan, r-save-state, and the old r-end
- `/r-start` absorbed r-resume (inline resume logic)
- `/r-timecard` replaced w-timecard-dual
- `/r-prune-claude` renamed from w-prune-claude
- Agent format references stored in `r-end/refs/` subdirectory (fan-out/fan-in pattern)
- Docs scripts co-located with r-end in `r-end/scripts/`

**Sessions 364-369:** Initial migration from old command-pair format to Skills 2. See `COMPLETED_PLAN.md` (SKILLS-MIGRATE entry).

---

## Skills 2 Format Reference

### SKILL.md Frontmatter

```yaml
---
name: r-docs
description: Update all project documentation
argument-hint: "[--recreate] - use session artifacts for context"
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
---
```

| Field | Purpose |
|-------|---------|
| `name` | Skill name (matches directory name) |
| `description` | Shown in skill listing |
| `argument-hint` | Displayed after the skill name in autocomplete |
| `allowed-tools` | Restricts which tools the skill can use |

### Scoping Rules

Skills 2 has a precedence hierarchy:

1. **Project** `.claude/skills/` — highest priority
2. **Personal** `~/.claude/commands/` — fallback

A project skill with the same name as a global command **shadows** it — but only in that project. Other projects continue using the global command. This allows per-project migration without breaking anything.

### `${CLAUDE_SKILL_DIR}`

Resolves to the skill's directory at runtime. Use it for script paths:

```markdown
!`${CLAUDE_SKILL_DIR}/scripts/my-script.sh`
```

---

## Adding a New Skill

### From Scratch

1. Create `.claude/skills/<name>/SKILL.md` with frontmatter
2. Add helper scripts in `.claude/skills/<name>/scripts/` if needed
3. Reference scripts via `!` backtick injection in SKILL.md
4. Test with `/<name>`

### From Canonical Template

```bash
~/skills-canon/tools/install.sh q-docs ~/projects/new-project
```

This copies the canonical SKILL.md and CUSTOMIZATION-GUIDE.md, creates a `.sync` metadata file, and prints what to customize.

### Migrating an Old Command Pair

1. Read the global (`~/.claude/commands/<name>.md`) and local (`.claude/commands/<name>-local.md`)
2. Merge into a single `SKILL.md` — eliminate duplicated tables, forward references, handoff instructions
3. Identify runtime tool-call work that can become `!` backtick scripts
4. Create `.claude/skills/<name>/SKILL.md` — the project skill shadows the global command
5. Delete the orphaned local file (`.claude/commands/<name>-local.md`)
6. Keep the global file for other projects still using it
7. Optionally add canonical template to `skills-canon`

---

## Maintenance

### Checking for Drift

```bash
~/skills-canon/tools/drift-report.sh q-docs ~/projects/peerloop-docs
```

Shows section-level differences between the project copy and canonical template.

### Syncing Changes

```bash
~/skills-canon/tools/skill-patch.sh q-docs ~/projects/peerloop-docs
```

Interactive — shows divergent sections and lets you push (project → canonical) or pull (canonical → project) each one.

### Resetting the Detection Marker

```bash
.claude/skills/r-end/scripts/detect-changes.sh --reset
```

Deletes the marker file, forcing the next `/r-end` run to use the 24-hour time-based fallback instead of marker-anchored detection.

---

## Skill Interplay

How the 16 Peerloop skills relate to each other: lifecycle, shared state, dependencies, and alternatives.

### Conversation Lifecycle

Every work session follows a strict sequence. Two skills own the entry and exit:

```
/r-start → [work] → /r-end or /w-post-fix → /clear → /r-start
```

| Skill | Role | What It Does |
|-------|------|-------------|
| `/r-start` | **Entry (required)** | Check repos clean, pull both, increment Conv counter, push, transfer RESUME-STATE.md → TodoWrite, present resume context |
| `/r-end` | **Exit (full)** | Extract conversation record, dispatch 3 agents in parallel, prune extract, save state (TodoWrite → RESUME-STATE.md), commit + push both repos, delete `.conv-current` |
| `/w-post-fix` | **Exit (lightweight)** | Record fix + targeted doc update, commit both repos. No agents, no extract, no full sync. Use for bug fixes touching 1-3 files |

**When to use which exit:**

| Scenario | Use |
|----------|-----|
| Design decisions, PLAN.md block progress, multiple items | `/r-end` |
| Bug fix, small config tweak, single-issue conv | `/w-post-fix` |

### Mid-Session Skills

These run during the work portion of a conversation. None require a specific order.

| Skill | Purpose | Conv-Aware? |
|-------|---------|-------------|
| `/r-commit` | Commit both repos with Conv + Machine + structured tags | Yes — reads `.conv-current` |
| `/r-prune-claude` | Move low-priority CLAUDE.md sections to offload file | No |
| `/r-timecard` | Generate merged dual-repo timecard (by Conv or commit count) | No |
| `/r-timecard-day` | Generate daily timecard with gap grouping and rounding | No |
| `/w-add-client-note` | Process client note → RFC folder with checklist | No |
| `/w-codecheck` | Run TypeScript + ESLint + Vitest, create TodoWrite for failures | No |
| `/w-git-history` | Extract commit history as formatted markdown | No |
| `/w-schema-dump` | Export database table schema to TSV | No |
| `/w-sync-docs` | Audit docs for drift against actual codebase | No |
| `/w-sync-skills` | Port skill improvements from another dual-repo project | No |
| `/w-review-resume-state` | Load and present RESUME-STATE.md for user review | No |
| `/w-timecard` | Generate single-repo conv timecard | No |
| `/w-test-env` | Diagnostic: report available environment variables in `!` backticks | No |

### Shared State

#### Primary State Files

```
CONV-COUNTER          ← r-start reads, increments, writes
.conv-current         ← r-start creates, r-end deletes
                        r-commit / w-post-fix read for metadata

RESUME-STATE.md       ← r-end creates (if pending tasks)
                        r-start reads, transfers to TodoWrite, deletes
                        w-review-resume-state reads (for user review)

PLAN.md               ← r-start reads (resume context)
                        r-commit reads (active block for tags)
                        r-end → update-plan agent writes
                        r-timecard-day reads (block-aware grouping)
```

#### Session Files (docs/sessions/YYYY-MM/)

| File | Created By | Content |
|------|-----------|---------|
| `{Conv} Extract.md` | `/r-end` Step 2 | Conversation record (read by all 3 agents) |
| `{Conv} Learnings.md` | `/r-end` → learn-decide agent | Patterns, anti-patterns, observations |
| `{Conv} Decisions.md` | `/r-end` → learn-decide agent | Only if decisions were made |
| `{Conv} Fix.md` | `/w-post-fix` | Combined learning + decision (replaces both above) |

#### Project-Level Docs Modified by Skills

| File | Written By | Read By |
|------|-----------|---------|
| `DECISIONS.md` | r-end → learn-decide, w-post-fix | w-add-client-note |
| `DOC-DECISIONS.md` | r-end → learn-decide | — |
| `TIMELINE.md` | r-end → learn-decide | — |
| `COMPLETED_PLAN.md` | r-end → update-plan | — |

#### Temporary / Ephemeral Files

| File | Purpose | Lifecycle |
|------|---------|-----------|
| `.timecard.md` | Timecard output (gitignored) | r-timecard / r-timecard-day → editor review |
| `/tmp/git-history.md` | History extract | w-git-history → editor review |
| `/tmp/extract-manifest.txt` | Agent coordination | r-end agents write consumed lines → r-end reads for pruning → deleted |

### r-end Agent Dispatch

`/r-end` is the only skill that dispatches agents. All three run in parallel from a single message:

```
/r-end
  │
  ├── Agent 1: learn-decide
  │     Reads:  Extract, refs/fmt-learn-decide.md
  │     Writes: Learnings.md, Decisions.md (optional),
  │             DECISIONS.md, DOC-DECISIONS.md, TIMELINE.md
  │     Coord:  Appends consumed lines to /tmp/extract-manifest.txt
  │
  ├── Agent 2: update-plan
  │     Reads:  Extract, refs/fmt-update-plan.md, PLAN.md
  │     Writes: PLAN.md, COMPLETED_PLAN.md (if block completes)
  │
  └── Agent 3: docs
        Reads:  Extract, refs/fmt-docs.md
        Runs:   4 scripts (detect-changes, sync-gaps, tech-doc-sweep, dev-env-scan)
        Writes: Various doc files
        Coord:  Reports gaps → r-end creates TodoWrite items
```

Supporting files in `.claude/skills/r-end/`:
- `refs/fmt-learn-decide.md` — Topics, routing rules, templates
- `refs/fmt-update-plan.md` — Block terminology, completion rules
- `refs/fmt-docs.md` — Change detection matrix, script paths
- `scripts/` — 4 shell scripts run by docs agent

### TodoWrite Routing

Multiple skills create TodoWrite items. The lifecycle is:

```
During conv:
  w-codecheck → TodoWrite (failing checks)
  w-sync-docs → TodoWrite (unfixed doc gaps)
  w-sync-skills → TodoWrite (undecided ports)
  r-end → TodoWrite (extract uncategorized items, doc agent gaps)

End of conv:
  r-end → pending TodoWrite items → RESUME-STATE.md

Start of next conv:
  r-start → RESUME-STATE.md → TodoWrite (transferred back)
```

### Alternatives and Overlaps

| Pair | Relationship |
|------|-------------|
| `/r-end` ↔ `/w-post-fix` | Full vs lightweight exit. Mutually exclusive per conv |
| `/r-end` ↔ `/r-commit` | r-end includes a commit. r-commit is for mid-session saves without ending |
| `/r-timecard` ↔ `/r-timecard-day` | Simple extraction vs daily grouping with gap analysis. Choose based on billing granularity |
| `/r-timecard` ↔ `/w-timecard` | Merged dual-repo vs single-repo timecard. Use r-timecard for client billing, w-timecard for code-repo-only history |

### Config Dependencies

`config.json` is read by 7 skills, written by none:

| Config Key | Used By |
|-----------|---------|
| `billing.currentCode` | r-timecard, r-timecard-day |
| `codeRepo` | r-timecard, r-timecard-day, w-git-history |
| `editor` | r-timecard, r-timecard-day, w-git-history |
| `thresholds.claudeMd` | r-prune-claude |
| `paths.claudeOffload` | r-prune-claude |
| `skillSync.sources[].replacements` | w-sync-skills |
| `features.*` | w-codecheck |

### Prefix Convention

- **`r-` (routine):** Conversation lifecycle and recurring operations (start, end, commit, timecard)
- **`w-` (workflow):** Task-specific utilities invoked as needed (codecheck, schema-dump, sync, history)
