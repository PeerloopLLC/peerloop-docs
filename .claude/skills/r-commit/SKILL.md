---
name: r-commit
description: Commit both repos with Conv and Machine metadata
argument-hint: ""
allowed-tools: Bash, Read, Glob
---

# Commit Both Repos

Commit changes in both peerloop-docs and Peerloop repos. Always commits both (skips silently if one has nothing to commit).

---

## Pre-computed Context

**Machine:**
!`cat ~/.claude/.machine-name 2>/dev/null || echo "(unknown)"`

**Conv:**
!`$CLAUDE_PROJECT_DIR/.claude/scripts/conv-read-current.sh`

**Active blocks:**
!`sed -n '/^### ACTIVE$/,/^### /p' PLAN.md 2>/dev/null | grep '^| [A-Z]' || echo "(none)"`

**Focus block:**
!`grep '^## Active:' PLAN.md 2>/dev/null | head -1 | sed 's/^## //' || echo "(none)"`

**Docs repo (peerloop-docs):**
!`git -C $CLAUDE_PROJECT_DIR status --short 2>/dev/null || echo "(unavailable)"`

**Code repo (Peerloop):**
!`git -C $CLAUDE_PROJECT_DIR/../Peerloop status --short 2>/dev/null || echo "(unavailable)"`

---

## Paths

**CRITICAL:** Always use absolute paths or `-C` flags. Shell cwd drifts after `cd ../Peerloop && npm ...`.

- Docs repo: `git -C $CLAUDE_PROJECT_DIR ...`
- Code repo: `git -C $CLAUDE_PROJECT_DIR/../Peerloop ...`

---

## Workflow

### Step 1: Review Changes

Use the pre-injected repo status above. If more detail is needed:

```bash
git -C $CLAUDE_PROJECT_DIR diff --stat
git -C $CLAUDE_PROJECT_DIR/../Peerloop diff --stat
```

### Step 2: Stage and Commit Both Repos

**Always stage everything.** Do not selectively stage files.

**Commit code repo first, then docs repo.** (Docs commit often references what was done in code.)

For each repo that has changes:

```bash
git -C {REPO_PATH} add .
git -C {REPO_PATH} commit -m "..."
```

If a repo has nothing to commit, skip it silently and note in the output.

### Step 3: Commit Message Format

```
Conv NNN: Concise title describing the change

Changes:
- Specific change with file/component name
- Another change with context

Fixes:
- Bug or issue fixed (if applicable)

Tests:
- What tests were added/fixed (if applicable)

API: METHOD /path — description
Page: /route — description
Role: RoleName — description
Infra: tool/skill/script — description
Doc: file/topic — description

User-facing: visible change
Admin-facing: visible change

Stats: X files changed

Block: BLOCKNAME
Conv: [from pre-computed context]
Machine: [from pre-computed context]

Co-Authored-By: Claude <noreply@anthropic.com>
```

**Title:** Start with `Conv NNN:`, imperative mood, under 72 chars total.

**Conv line:** If Conv shows "MISSING", warn the user that `/r-start` was not run, but proceed with the commit (omit the Conv line).

**Body:** Group bullets by category. Only include relevant sections (skip empty ones). Be specific — name files, components, endpoints.

**Structured tags (API/Page/Role/Infra/User-facing/Admin-facing):**

These tagged lines are extracted by `/r-timecard-day` and `/r-timecard` into dedicated timecard sections. When reviewing the diff, actively look for changes that fit each tag type. Tags are additive — the Changes/Fixes/Tests bullets remain for technical detail.

| Tag | When to include | NOT for |
|-----|----------------|---------|
| `API:` | Endpoint added, removed, or contract changed (new fields, changed behavior) | Internal refactors that don't change API surface |
| `Page:` | Route added/removed, or page received visible UI changes | CSS-only tweaks, internal component refactors |
| `Role:` | Role gained/lost capability, or role-specific behavior changed | Generic changes affecting all roles equally |
| `Infra:` | Skills, hooks, scripts, CLI tools, build config, migrations tooling, dev workflow changes | Application code that happens to be in scripts/; documentation (use `Doc:`) |
| `Doc:` | Reference docs, as-designed/as-built docs, guides, decision records, CLAUDE.md content, CLI-QUICKREF, API-REFERENCE, session docs, doc reorganization (moves, renames, splits, consolidation) | Code comments; inline JSDoc (those are code, not docs) |
| `User-facing:` | Change visible to end users (any role) | Technical/invisible changes |
| `Admin-facing:` | Change visible to admins specifically | Changes affecting all roles equally |

- Only include tags that apply — most commits will have zero or a few
- One item per line, multiple lines of the same type allowed
- A change can appear in multiple tag types (overlap is fine)
- Format: `Tag: brief description` — keep each line concise

**Block line — determination rules:**
1. Look at the actual changes being committed (the diff, not the PLAN.md focus block)
2. Identify which PLAN.md block(s) the changes advance — a block is "advanced" if the work directly relates to one of its items or subtasks
3. Apply these rules:
   - **One block advanced:** `Block: BLOCKNAME`
   - **Multiple blocks advanced:** `Block: BLOCK1, BLOCK2`
   - **No block advanced** (tooling, infra, misc config, docs-only housekeeping): `Block: (misc)`
4. Do NOT default to the Focus block. The Focus block is context for what the user is *currently working on*, but if this commit doesn't advance that block's items, don't claim it

### Step 4: Verify

```bash
git -C $CLAUDE_PROJECT_DIR status
git -C $CLAUDE_PROJECT_DIR/../Peerloop status
```

### Step 5: Report

```
Committed
─────────
Docs: [commit hash] [title]       (or "nothing to commit")
Code: [commit hash] [title]       (or "nothing to commit")
Conv: [NNN]
```

---

## Rules

- **Do NOT push** unless explicitly requested. If pushing, push both repos.
- **Do NOT amend** previous commits unless explicitly requested
- **Do NOT use `--no-verify`** to skip hooks
- **Always commit ALL changes** — use `git add .` without exception
- **Always use `git -C`** — never bare `git`
