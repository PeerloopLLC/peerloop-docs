---
name: r-end
description: End conversation — run end-of-conv sequence, commit both repos, and push
argument-hint: ""
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Skill
---

# End Conversation

**Purpose:** Run the full end-of-conv sequence, commit all changes in both repos (with Conv and Machine metadata), and push both repos to remote.

---

## Pre-computed Context

**Machine:**
!`cat ~/.claude/.machine-name 2>/dev/null || echo "(unknown)"`

**Current conv:**
!`$CLAUDE_PROJECT_DIR/.claude/scripts/conv-read-current.sh`

**Shared timestamp:**
!`echo "MONTH: $(date '+%Y-%m')" && echo "FILENAME: $(date '+%Y%m%d_%H%M')"`

**Repo status:**
!`$CLAUDE_PROJECT_DIR/.claude/scripts/dual-repo-status.sh`

---

## Paths

- Docs repo: `git -C $CLAUDE_PROJECT_DIR ...`
- Code repo: `git -C $CLAUDE_PROJECT_DIR/../Peerloop ...`

---

## Execution Flow

### Step 1: Validate conv is active

Read `.conv-current`. If it's missing or says "MISSING", **HALT** — tell the user to run `/r-start` first. Do not proceed without a locked conv number.

### Step 2: Run end-of-conv sequence

Invoke `/r-eos` via the Skill tool. It runs the 4 sub-skills sequentially:

1. `/r-learn-decide`
2. `/r-dump`
3. `/r-update-plan`
4. `/r-docs`

Wait for it to complete fully.

### Step 3: Save pending work state (if any)

Check the TaskList for pending (not completed) items. If any exist:

1. Invoke `/r-save-state` via the Skill tool
2. Wait for it to complete fully
3. Note in the closing summary: `State saved ✅`

If no pending tasks exist, skip this step and note: `State saved ⏭️  (no pending tasks)`

This ensures TodoWrite items and unfinished work survive across `/clear` boundaries. RESUME-STATE.md will be included in the commit that follows.

### Step 4: Commit both repos

Invoke `/r-commit` via the Skill tool. It commits both repos with Conv + Machine metadata.

### Step 6: Push both repos

```bash
git -C $CLAUDE_PROJECT_DIR push
git -C $CLAUDE_PROJECT_DIR/../Peerloop push
```

This is **mandatory** — it syncs the work and counter state for the other machine. If either push fails, tell the user and do not report success.

### Step 7: Clean up conv lock

```bash
rm $CLAUDE_PROJECT_DIR/.conv-current
```

### Step 8: Display closing summary

```
╔═══════════════════════════════════╗
║  Conv {PADDED_VALUE} closed       ║
╚═══════════════════════════════════╝

End-of-Conv Complete
────────────────────
1. Learn/Decide  ✅
2. Conv Dump      ✅
3. Plan Update    ✅
4. Docs Update    ✅
5. State Saved    ✅ or ⏭️
6. Committed      ✅
7. Pushed         ✅
   Docs: ✅
   Code: ✅

Safe to exit.
```

---

## Rules

- **HALT if no active conv** — `.conv-current` must exist
- **HALT on push failure** — do not report success if either push fails
- Run sub-skills in strict order — do not skip or reorder
- If a sub-skill asks the user a question, wait for their answer before continuing
- Delete `.conv-current` only after successful push of both repos
- After displaying the closing summary, do NOT take further actions — the user should exit
