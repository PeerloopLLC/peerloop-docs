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

### Prefix Convention: w-* vs q-*

Project skills use the `w-*` prefix; global commands retain `q-*`. This eliminates autocomplete collisions in the Claude Code UI, where identically-named project and global skills appeared as ambiguous `(project)` / `(user)` options. The prefix makes origin immediately obvious: `w-*` is always project-local, `q-*` is always global.

Skills 2 solves the technical problems: a single `SKILL.md` replaces the two-file split, and `!` backtick injection runs shell scripts *before* the prompt is assembled, injecting data directly.

---

## Directory Layout

### Per-Project (Peerloop)

```
.claude/skills/r-docs/
├── SKILL.md              # Merged instructions (what Claude sees)
├── .sync                 # Drift metadata (last sync with canonical)
├── .last-qdocs-run       # Marker: HEAD SHAs from last run (committed)
└── scripts/
    ├── detect-changes.sh   # Changed files since last /r-docs run
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
*(since last /r-docs run)*
### Code repo (Peerloop)
src/pages/api/me/full.ts
tests/lib/current-user-cache.test.ts
...
```

**Effect:** Instructions shrank 68% (629 → 200 lines). Total prompt grew (~1000 lines of injected data) but eliminates dozens of runtime tool calls. Claude's role shifts from detective to editor.

### Marker-Anchored Detection

`detect-changes.sh` writes a marker file (`.last-qdocs-run`) containing the HEAD SHAs of both repos after each run. The next run diffs from that marker forward, showing only changes since the last `/r-docs` execution.

| Scenario | Behavior |
|----------|----------|
| First run (no marker) | Falls back to `--since "24 hours ago"` |
| Subsequent runs | Diffs from marker SHA to HEAD + uncommitted |
| Marker SHA not found locally | Falls back to `--since` (e.g., other machine ahead) |
| Manual reset | `detect-changes.sh --reset` deletes marker |

The marker is **committed to git**, not gitignored. This is intentional — Peerloop development happens across two Mac Minis, so the "last documented up to here" pointer needs to travel with the repo. Mac A runs `/r-docs`, commits the marker; Mac B pulls and continues from that point.

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

`sync-gaps.sh` reads it programmatically. `SKILL.md` references it as the authoritative source.

---

## Skill Reference

### Currently Converted to Skills 2

| Skill | Location | Purpose | Helper Scripts |
|-------|----------|---------|----------------|
| `/r-docs` | `.claude/skills/r-docs/` | End-of-conv documentation updates | detect-changes, sync-gaps, tech-doc-sweep, dev-env-scan |
| `/w-codecheck` | `.claude/skills/w-codecheck/` | Code quality checks (TS + ESLint + Tailwind + Astro) | — |
| `/w-prune-claude` | `.claude/skills/w-prune-claude/` | Optimize CLAUDE.md by offloading reference content | — |
| `/w-git-history` | `.claude/skills/w-git-history/` | Extract and format commit history | — |
| `/w-timecard` | `.claude/skills/w-timecard/` | Generate conv timecard for client billing | — |
| `/r-eos` | `.claude/skills/r-eos/` | End-of-conv sequence (orchestrator) | — |
| `/r-dump` | `.claude/skills/r-dump/` | Create development conv log | — |
| `/r-update-plan` | `.claude/skills/r-update-plan/` | Update PLAN.md with current progress | plan-status-header, plan-open-questions |
| `/r-learn-decide` | `.claude/skills/r-learn-decide/` | Document conv learnings & decisions | session-files-learn-decide |
| `/r-commit` | `.claude/skills/r-commit/` | Commit both repos with Conv metadata | dual-repo-status, conv-read-current |
| `/r-save-state` | `.claude/skills/r-save-state/` | Save work state for cross-conv continuity | resume-state-check |
| `/w-timecard-dual` | `.claude/skills/w-timecard-dual/` | Merged dual-repo timecard for client billing | — |
| `/w-add-client-note` | `.claude/skills/w-add-client-note/` | Process client notes into RFC checklists | — |
| `/w-schema-dump` | `.claude/skills/w-schema-dump/` | Export table schema to TSV | — |
| `/r-end2` | `.claude/skills/r-end2/` | End conversation (collector + agent dispatch) | refs/fmt-learn-decide, refs/fmt-dump, refs/fmt-update-plan, refs/fmt-docs |

### Migration Complete

All project-specific skills have been migrated to Skills 2 format (14 skills). No remaining old-format command pairs. `.claude/commands/` is empty.

**Migration history:** See `COMPLETED_PLAN.md` (SKILLS-MIGRATE entry, Sessions 364-369).

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
.claude/skills/r-docs/scripts/detect-changes.sh --reset
```

Deletes `.last-qdocs-run`, forcing the next `/r-docs` run to use the 24-hour time-based fallback instead of marker-anchored detection.
