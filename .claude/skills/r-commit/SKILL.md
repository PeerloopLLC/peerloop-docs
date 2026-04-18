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

**Enabled commit tags:**
!`node -e "console.log(require('$CLAUDE_PROJECT_DIR/.claude/config.json').commitTags.join(', '))" 2>/dev/null || echo "(config unavailable)"`

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

**Canonical spec:** `docs/reference/COMMIT-MESSAGE-FORMAT.md`. Read it if in doubt — the rules below are the author-time digest.

```
Conv NNN: Concise imperative title, under 72 chars

Changes:
- Specific change with file/component name
Fixes:
- Bug or issue fixed
Tests:
- Tests added/fixed

API: METHOD /path — description
Page: /route — description
Role: RoleName — description
Infra: tool/skill/script — description
Doc: file/topic — description
Test: subject — description
User-facing: visible change
Admin-facing: visible change

Stats: X files changed

Block-summary: One sentence describing what this commit achieved toward its Block.

Block: BLOCKNAME
Conv: [from pre-computed context]
Machine: [from pre-computed context]

Co-Authored-By: Claude <noreply@anthropic.com>
```

**Field order is fixed.** Blank lines separate the groups above; no blank lines within a group.

**Subject** — `Conv NNN:` prefix, imperative, < 72 chars. If Conv shows "MISSING", warn the user that `/r-start` was not run but proceed without the prefix and omit the `Conv:` line.

**Body bullets** — group by `Changes:` / `Fixes:` / `Tests:`. Omit empty sections. Be specific — name files, components, endpoints.

**Content tags** — emit only from the enabled set shown in **Enabled commit tags** (pre-computed context above). For each enabled tag, actively consider whether the diff has changes that fit it. One tag per line; multiple lines of the same type allowed.

| Tag | When to include | NOT for |
|-----|----------------|---------|
| `API:` | Endpoint added, removed, or contract changed (new fields, changed behavior) | Internal refactors that don't change API surface |
| `Page:` | Route added/removed, or page received visible UI changes | CSS-only tweaks, internal component refactors |
| `Role:` | Role gained/lost capability, or role-specific behavior changed | Generic changes affecting all roles equally |
| `Infra:` | Skills, hooks, scripts, CLI tools, build config, migrations tooling, dev workflow changes | Application code that happens to be in scripts/; documentation (use `Doc:`) |
| `Doc:` | Reference docs, as-designed/as-built docs, guides, decision records, CLAUDE.md content, CLI-QUICKREF, API-REFERENCE, session docs, doc reorganization (moves, renames, splits, consolidation) | Code comments; inline JSDoc (those are code, not docs) |
| `Test:` | Test files added, removed, or significantly changed | Minor test tweaks alongside a larger feature change |
| `User-facing:` | Change visible to end users (any role) | Technical/invisible changes |
| `Admin-facing:` | Change visible to admins specifically | Changes affecting all roles equally |

Key reminders:
- `Doc:` does NOT apply to session-tracking files: `docs/sessions/**`, `PLAN.md`, `COMPLETED_PLAN.md`, `TIMELINE.md`, `DECISIONS.md`, `DOC-DECISIONS.md`, `RESUME-STATE.md`. Only tag `Doc:` when the commit authored content in `docs/reference/`, `docs/guides/`, `docs/as-designed/`, `docs/as-built/`, or CLAUDE.md-level files.
- `Test:` is for test-file changes. Commits that only touched tests often need just `Test:` (no `Infra:` / `Doc:`).
- Only include tags that apply — most commits will have zero or a few
- A change can appear in multiple tag types (overlap is fine)

**`Block-summary:`** — one-line prose summary, written from the Block's perspective ("Landed X"; "Replaced Y with Z"; "Unblocked ABC").

- **Required** when Block is NOT `(misc)`. If Block is `(misc)`, may be omitted.
- **Single line**, 80–150 chars preferred.
- **One per commit** — same sentence applies under every Block in multi-Block commits.
- Synthesis, not a bullet re-list. Don't enumerate what's already in `Changes:` — summarize.

**`Type:`** — omit on `/r-commit` commits. (Reserved for `/r-end` end-of-conv marker.)

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
