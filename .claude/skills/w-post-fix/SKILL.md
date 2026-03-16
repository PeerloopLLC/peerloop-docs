---
name: w-post-fix
description: Lightweight end-of-session for bug-fix sessions — record, update docs, commit
argument-hint: ""
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Post-Fix Wrap-Up

Lightweight alternative to `/w-eos` for sessions where you fixed a bug or made a small targeted change. Combines learning capture, targeted doc update, and commit into one fast pass.

**Use when:** Session was a bug fix, small feature tweak, or config change (1-3 files changed). The commit message is the session record.

**Use `/w-eos` instead when:** Session had significant design decisions, new features, multiple work items, or PLAN.md block progress.

---

## Pre-computed Context

**Machine:**
!`cat ~/.claude/.machine-name 2>/dev/null || echo "(unknown)"`

**Session:**
!`grep '^## Session' SESSION-INDEX.md 2>/dev/null | tail -1 | sed 's/## //' || echo "(unknown)"`

**Timestamp:**
!`echo "MONTH: $(date '+%Y-%m')" && echo "FILENAME: $(date '+%Y%m%d_%H%M')" && echo "DATE: $(date '+%Y-%m-%d')" && echo "TIME: $(date '+%H:%M')"`

**Session start:**
!`grep -o 'started at .*' SESSION-INDEX.md 2>/dev/null | tail -1 | sed 's/started at //' || echo "(unknown)"`

**Code repo changes:**
!`git -C ../Peerloop diff --stat HEAD 2>/dev/null || echo "(no code changes)"`

**Docs repo changes:**
!`git diff --stat HEAD 2>/dev/null || echo "(no docs changes)"`

---

## Workflow

Run all 3 steps in order. The entire skill should complete in under a minute.

### Step 1: Quick Learning Capture

Create a **single** combined file: `docs/sessions/{MONTH}/{FILENAME} Fix.md`

```markdown
# Fix Log - YYYY-MM-DD

## What Broke
[1-2 sentences: symptom the user reported]

## Root Cause
[1-2 sentences: why it broke]

## Fix
[1-2 sentences: what was changed and why this approach]

## Learning
[Optional — only if the fix revealed something non-obvious worth remembering.
Skip this section entirely if the fix was straightforward.]

## Decision
[Optional — only if a design choice was made between alternatives.
If included, note whether it should be routed to DECISIONS.md or PLAYBOOK.md.
Skip this section entirely if no real decision was involved.]
```

**Rules:**
- This replaces both Learnings.md and Decisions.md — do NOT create separate files
- Keep it terse. The commit message has the details.
- If a decision IS noteworthy (architectural, changes existing behavior), update DECISIONS.md or PLAYBOOK.md inline — don't just note it

### Step 2: Targeted Doc Update

Check ONLY the docs directly affected by the changed files. Do NOT run full sync-gap detection.

**Quick lookup:** Match changed `src/pages/api/` files to their doc using this mapping:

| Route contains | Update |
|---------------|--------|
| `auth` | `docs/reference/API-AUTH.md` |
| `courses` | `docs/reference/API-COURSES.md` |
| `users`, `creators` | `docs/reference/API-USERS.md` |
| `enrollments`, `me` | `docs/reference/API-ENROLLMENTS.md` |
| `checkout`, `stripe`, `webhooks` | `docs/reference/API-PAYMENTS.md` |
| `sessions`, `teachers` | `docs/reference/API-SESSIONS.md` |
| `homework`, `submissions` | `docs/reference/API-HOMEWORK.md` |
| `admin` | `docs/reference/API-ADMIN.md` |
| `communities`, `feeds` | `docs/reference/API-COMMUNITY.md` |

**For each matched doc:** Read the relevant endpoint section. If the fix changed behavior (new error code, different validation, changed response), update it. If the fix was internal-only (refactor, perf), skip.

**Also check:** If the fix touches `docs/POLICIES.md` behavior (access control, business rules), update that too.

**Skip entirely if:** Only test files, config, or non-API code changed.

### Step 3: Commit Both Repos

Stage and commit everything. Code repo first, then docs repo.

**Commit message format (shorter than /w-commit):**

```
Session NNN: [imperative description of the fix]

Fix: [what was wrong and what was changed]
Files: [list of changed source files, not tests]

[Optional] User-facing: [what users will notice]

Date: YYYY-MM-DD
Start: HH:MM
End: HH:MM
Machine: [machine name]

Co-Authored-By: Claude <noreply@anthropic.com>
```

**Docs repo commit:**
```
Session NNN: Fix log + docs for [fix description]

Date: YYYY-MM-DD
Machine: [machine name]

Co-Authored-By: Claude <noreply@anthropic.com>
```

**After committing:** Show both commit hashes. Do NOT push unless the user asks.

---

## What This Skips (vs /w-eos)

| /w-eos step | Why skipped |
|-------------|-------------|
| `/w-dump` (Dev.md) | Commit message is the transcript for a 2-3 prompt session |
| `/w-update-plan` | Fixes rarely change PLAN block status |
| `/w-docs` full sync-gap scan | Only the affected API doc needs checking |
| `/w-learn-decide` separate files | Combined into single Fix.md |

---

## Output

```
Post-Fix Complete
─────────────────
Fix log:    docs/sessions/{MONTH}/{FILENAME} Fix.md
Docs:       [updated doc or "none needed"]
DECISIONS:  [updated entry or "no"]
Code:       [commit hash] [title]
Docs:       [commit hash] [title]
```
