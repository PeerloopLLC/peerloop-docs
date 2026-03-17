---
name: r-start
description: Start a new conversation — check repos clean, pull both, increment conv, push, resume
argument-hint: ""
allowed-tools: Read, Bash, Glob, Grep, Skill
---

# Start Conversation

**Purpose:** Verify both repos are clean, sync from remote, increment the conversation counter, push the new counter, then present resumption context. This is the **only** entry point for all conversations — both cold starts and warm restarts after `/r-pre-clear` → `/clear`.

---

## Pre-computed Context

**Machine:**
!`cat ~/.claude/.machine-name 2>/dev/null || echo "(unknown)"`

**Current CONV-COUNTER value (before increment):**
!`/Users/jamesfraser/projects/peerloop-docs/.claude/scripts/conv-read-counter.sh`

**Existing .conv-current:**
!`test -f .conv-current && echo "WARNING: .conv-current already exists (value: $(cat .conv-current)) — a previous session may not have ended cleanly" || echo "(none — clean state)"`

**Repo status:**
!`/Users/jamesfraser/projects/peerloop-docs/.claude/scripts/dual-repo-status.sh`

---

## Paths

- Docs repo: `git -C /Users/jamesfraser/projects/peerloop-docs ...`
- Code repo: `git -C /Users/jamesfraser/projects/Peerloop ...`

---

## Execution Flow

### Step 1: Check both repos for uncommitted changes

Use the pre-computed repo status above. If **either** repo shows DIRTY:

```
⚠️  Uncommitted changes detected — cannot start cleanly.

Docs repo:
[status output]

Code repo:
[status output]

Options:
1. Commit changes first (run /r-commit)
2. Stash changes and proceed
3. Discard changes (destructive!)
```

**HALT** and wait for user decision. Do not proceed with dirty repos.

### Step 2: Pull both repos

```bash
git -C /Users/jamesfraser/projects/peerloop-docs pull --ff-only
git -C /Users/jamesfraser/projects/Peerloop pull --ff-only
```

If either pull fails (diverged branches, network error), **HALT** and tell the user. Do not proceed — the conv counter will be out of sync.

### Step 3: Read and increment the counter

Read `CONV-COUNTER`. It contains a single integer (e.g. `3`).

Compute the next value: current + 1.

Format as zero-padded 3-digit string (e.g. `004`).

### Step 4: Write the new counter and lock it

Write the new integer (unpadded) to `CONV-COUNTER`:

```bash
echo {NEW_VALUE} > CONV-COUNTER
```

Write the zero-padded value to `.conv-current`:

```bash
echo {PADDED_VALUE} > .conv-current
```

### Step 5: Commit and push the counter

```bash
git -C /Users/jamesfraser/projects/peerloop-docs add CONV-COUNTER
git -C /Users/jamesfraser/projects/peerloop-docs commit -m "Conv {PADDED_VALUE} start — {MACHINE}"
git -C /Users/jamesfraser/projects/peerloop-docs push
```

If the push fails, **HALT** and tell the user. The counter increment is not synced until pushed.

### Step 6: Display conversation header

```
╔═══════════════════════════════════╗
║  Conv {PADDED_VALUE}  ·  {MACHINE}  ║
╚═══════════════════════════════════╝
```

### Step 7: Resume work context

Invoke `/r-resume` via the Skill tool to present the current work position and recommended next action.

---

## Rules

- **HALT on dirty repos** — never proceed with uncommitted changes
- **HALT on pull failure** — never increment without a successful pull of both repos
- **HALT on push failure** — the counter must be pushed before any work begins
- If `.conv-current` already exists, warn the user (prior session didn't run `/r-end`) but proceed — the counter in `CONV-COUNTER` (post-pull) is the source of truth
- The `CONV-COUNTER` file stores an unpadded integer; `.conv-current` stores a zero-padded 3-digit string
- Do NOT begin any project work until Steps 1–6 are complete
