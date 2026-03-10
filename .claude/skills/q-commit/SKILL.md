---
name: q-commit
description: Stage and commit changes
argument-hint: ""
allowed-tools: Read, Edit, Bash, Glob
---

# Commit Changes

Standard workflow for staging and committing changes in Peerloop's dual-repo architecture.

---

## Pre-computed Context

!`cat .claude/config.json 2>/dev/null || echo "(no config)"`

**Machine:**
!`cat ~/.claude/.machine-name 2>/dev/null || echo "(unknown)"`

**Session:**
!`grep '^## Session' SESSION-INDEX.md 2>/dev/null | tail -1 | sed 's/## //' || echo "(unknown)"`

**Active blocks:**
!`sed -n '/^### ACTIVE$/,/^### /p' PLAN.md 2>/dev/null | grep '^| [A-Z]' || echo "(none)"`

**Focus block:**
!`grep '^## In Progress:' PLAN.md 2>/dev/null | head -1 | sed 's/^## //' || echo "(none)"`

**Session start:**
!`grep -A1 '^## Session' SESSION-INDEX.md 2>/dev/null | tail -1 | sed 's/- Time Start: //' || echo "(unknown)"`

**Docs repo (peerloop-docs):**
!`git status --short 2>/dev/null || echo "(unavailable)"`

**Code repo (Peerloop):**
!`git -C ../Peerloop status --short 2>/dev/null || echo "(unavailable)"`

---

## Project Root

**CRITICAL:** The shell cwd may drift during a session (e.g., after `cd ../Peerloop && npm ...`). Always use the primary working directory from your environment context, NOT the current shell cwd.

**Docs repo root:** Use primary working directory (where `.claude/` lives)
**Code repo root:** `../Peerloop`

---

## Workflow

### Step 1: Review Changes

Use the pre-injected repo status above. If more detail is needed:

```bash
git diff --stat
git -C ../Peerloop diff --stat
```

### Step 2: Stage and Commit

**Always stage everything.** Do not selectively stage files.

| Scenario | Action |
|----------|--------|
| **Doc changes only** | git add . && git commit |
| **Code changes only** | git -C ../Peerloop add . && git -C ../Peerloop commit |
| **Both repos changed** | Commit code first, then docs. Same session number in both. |

### Step 3: Commit Message Format

Messages should be **15-20 lines** with detailed, grouped content. Use the pre-computed session number, machine name, and active block.

```
Session NNN: Concise title describing the change

Changes:
- Specific change with file/component name affected
- Another change with context

Fixes:
- Bug or issue fixed and what was wrong

Tests:
- What tests were added/fixed (with counts)

Scripts:
- Any scripts created or modified

Stats: X files changed, Y tests added, Z tests passing

User-facing: [What changed from user perspective]
Admin-facing: [What changed for admins]

Block: BLOCKNAME (section X of Y)
Date: YYYY-MM-DD
Start: HH:MM
End: HH:MM
Machine: [from pre-computed context]

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

**Title:** Start with `Session NNN:`, imperative mood, under 72 chars total.

**Body:** Group bullets by category. Only include relevant sections (skip empty ones). Be specific — name files, components, endpoints, test counts. Focus on "what" and "why".

**Client perspective:** Add `User-facing:` / `Admin-facing:` for user-visible changes (new pages, features, admin tools). Skip for purely technical commits.

**Block reference:** Include `Block: BLOCKNAME` when work relates to a PLAN.md block.

**Timing:** Always include `Date:`, `Start:`, and `End:`. Parse the pre-computed "Session start" value (format: `Mon DD, YYYY HH:MM`) — extract the date for `Date:` and the time for `Start:`. For `End:`, run `date +%H:%M` at commit time.

### Step 4: Verify

```bash
git status
git -C ../Peerloop status
```

Confirm working tree is clean and commit was successful.

---

## Rules

- **Do NOT push** unless explicitly requested. If pushing, push both repos if both had commits.
- **Do NOT amend** previous commits unless explicitly requested
- **Do NOT use `--no-verify`** to skip hooks unless explicitly requested
- **Always commit ALL changes** — use `git add .` without exception
