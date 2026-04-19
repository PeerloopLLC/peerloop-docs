---
name: r-commit
description: Commit both repos using v2 commit format (H3 sections + Format v2 trailer) for multi-H4 timecard parsing
argument-hint: ""
allowed-tools: Bash, Read, Glob
---

# Commit Both Repos (v2 format)

Commit changes in both peerloop-docs and Peerloop repos using the **v2 commit message format**. Always commits both (skips silently if one has nothing to commit).

**Canonical commit-format spec:** `docs/reference/COMMIT-MESSAGE-FORMAT.md`.

**Difference from `/r-commit` (v1):** bullets are grouped under `### SECTION` H3 headers matching the timecard's H4 section titles, and a `Format: v2` trailer marks the commit so `/r-timecard-day2` can read bullets directly from their H3 sections. Write each bullet once — the timecard parser replicates each bullet into every H4 whose inclusion predicate matches (e.g., a bullet mentioning an API path and a doc file appears in both API Changes and Doc Changes).

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

### Step 3: Commit Message Format (v2)

**Canonical spec:** `docs/reference/COMMIT-MESSAGE-FORMAT.md`. Read it for edge cases — the rules below are the author-time digest.

```
Conv NNN: Concise imperative title, under 72 chars

### Work Effort
- [TAG] bullet describing an effort thread

### User-facing
- visible change for regular users

### Admin-facing
- admin-only change

### API Changes
- METHOD /path — description

### Page Changes
- /route — description

### Role Changes
- RoleName — description

### Infra Changes
- tool/skill/script — description

### Doc Changes
- docfile.md — description

### DB Changes
- migrations/N_schema.sql — description

### Testing
- tests/path.test.ts — description

### Code Changes
- src/path.ts — description

Stats: X files changed
Block: BLOCKNAME
Conv: [from pre-computed context]
Machine: [from pre-computed context]
Format: v2
Block-summary: One sentence describing what this commit achieved toward its Block.

Co-Authored-By: Claude <noreply@anthropic.com>
```

**Field order is fixed.** Blank lines separate subject from body, body-H3s from trailers, and trailers from the `Co-Authored-By` footer. Blank lines do NOT appear between bullets within an H3 or between trailer lines.

**Subject** — `Conv NNN:` prefix, imperative, < 72 chars. If Conv shows "MISSING", warn the user that `/r-start` was not run but proceed without the prefix and omit the `Conv:` line.

**H3 sections — all optional.** Only emit an H3 that has content. Never emit an empty header.

### Authoring rule: write each bullet ONCE, in the H3 that best describes what the bullet fundamentally is.

The `/r-timecard-day2` parser evaluates each H4 section's inclusion predicate independently over every bullet and **replicates** matching bullets into every H4. A bullet under `### Work Effort` that mentions `/api/foo` and `API-REFERENCE.md` will render in the timecard's Work Effort, API Changes, *and* Doc Changes. You don't need to duplicate the bullet in the commit body. You *may* duplicate it under multiple H3s if you want to force placement when a predicate wouldn't otherwise match; the parser dedups per-H4 by exact text.

| H3 | When to place a bullet here |
|----|-----------------------------|
| `### Work Effort` | Default home for narrative bullets. Often `[TAG]`-prefixed. Most multi-faceted bullets go here. |
| `### User-facing` | Visible to end users (any role). Format: `Component/Area — description`. |
| `### Admin-facing` | Visible to admins specifically. Same format. |
| `### API Changes` | Endpoint added, removed, or contract changed. Format: `METHOD /path — description`. NOT for test-only API work (use Testing). |
| `### Page Changes` | Route added/removed, or page received visible UI changes. Format: `/route — description`. NOT for CSS-only or internal refactors. |
| `### Role Changes` | Role gained/lost capability, or role-specific behavior changed. |
| `### Infra Changes` | Skills, hooks, scripts, CLI tools, build config, migrations tooling, dev workflow changes. |
| `### Doc Changes` | Reference docs under `docs/reference/`, `docs/guides/`, `docs/as-designed/`, `docs/as-built/`, or CLAUDE.md-level files. |
| `### DB Changes` | Schema, migration, or seed work. Format: `migrations/NNNN_name.sql — description` or `Schema:` / `Seed:` / `Migration:` prefixed prose. |
| `### Testing` | Test files added, removed, or significantly changed (including `tests/api/*`). |
| `### Code Changes` | Internal refactors under `src/` not visible through a higher-signal section above. Most bullets will NOT use this section — prefer Work Effort or a specific section. |

**Doc exclusion list.** `### Doc Changes` does NOT apply to:
- `docs/sessions/**` (Extract / Learnings / Decisions)
- `PLAN.md`, `COMPLETED_PLAN.md`, `TIMELINE.md`
- `DECISIONS.md`, `DOC-DECISIONS.md`
- `RESUME-STATE.md`, `CONV-INDEX.md`, `SESSION-INDEX.md`

Mentions of these files in any bullet are filtered out by the timecard's `routineStrip` filter, so you don't need to avoid mentioning them — just don't create a `### Doc Changes` bullet whose only content is one of these files.

**H5/H6 are dynamic.** The parser derives `#####` / `######` sub-groupings algorithmically from bullet content. Authors only emit `### H3` section headers in commits.

**`Block-summary:`** — one-line prose summary, written from the Block's perspective ("Landed X"; "Replaced Y with Z"; "Unblocked ABC").

- **Required** when Block is NOT `(misc)`. If Block is `(misc)`, may be omitted.
- **Single line**, 80–150 chars preferred.
- **One per commit** — same sentence applies under every Block in multi-Block commits.
- Synthesis, not a bullet re-list. Don't enumerate what's already in the H3 sections — summarize.

**`Format: v2`** — mandatory trailer on all `/r-commit2` commits. The timecard parser uses this marker to detect v2 format.

**`Type:`** — omit on `/r-commit2` commits. (Reserved for `/r-end2` end-of-conv marker.)

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
