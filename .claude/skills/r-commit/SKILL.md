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
!`grep '^## In Progress:' PLAN.md 2>/dev/null | head -1 | sed 's/^## //' || echo "(none)"`

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

Stats: X files changed

Block: BLOCKNAME (if applicable)
Conv: [from pre-computed context]
Machine: [from pre-computed context]

Co-Authored-By: Claude <noreply@anthropic.com>
```

**Title:** Start with `Conv NNN:`, imperative mood, under 72 chars total.

**Conv line:** If Conv shows "MISSING", warn the user that `/r-start` was not run, but proceed with the commit (omit the Conv line).

**Body:** Group bullets by category. Only include relevant sections (skip empty ones). Be specific — name files, components, endpoints.

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
