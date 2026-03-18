---
name: r-pre-clear
description: Save state and increment conv — user must run /clear manually after
argument-hint: ""
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Skill
---

# Pre-Clear: Prepare for Warm Restart

**Purpose:** Save current work state and increment the conversation counter. The user must then run `/clear` manually (Claude Code cannot execute built-in CLI commands like `/clear` programmatically).

---

## Pre-computed Context

**Machine:**
!`cat ~/.claude/.machine-name 2>/dev/null || echo "(unknown)"`

**Conv counter:**
!`$CLAUDE_PROJECT_DIR/.claude/scripts/conv-read-counter.sh`

**Active conv:**
!`$CLAUDE_PROJECT_DIR/.claude/scripts/conv-read-current.sh`

---

## Execution Flow

### Step 1: Validate conv is active

Read `.conv-current`. If it's missing or says "MISSING", warn the user — they may not have run `/r-start`. Ask whether to proceed anyway (the state save is still useful even without a conv number).

### Step 2: Save state

Invoke `/r-save-state` via the Skill tool. Wait for it to complete fully.

### Step 3: Increment conv counter

Read `CONV-COUNTER`. Increment by 1. Format as zero-padded 3-digit string.

Write the new integer (unpadded) to `CONV-COUNTER`:

```bash
echo {NEW_VALUE} > CONV-COUNTER
```

Write the zero-padded value to `.conv-current`:

```bash
echo {PADDED_VALUE} > .conv-current
```

**Do NOT commit or push.** This is a local-only increment. The next `/r-end` will commit and push everything.

### Step 4: Display instructions

Display:

```
╔═══════════════════════════════════════════════╗
║  Conv {OLD_CONV} saved · Conv {NEW_CONV} ready  ║
╚═══════════════════════════════════════════════╝

State saved → RESUME-STATE.md
Next conv: {NEW_CONV}

Now run these two commands manually:
  1. /clear
  2. /r-start
```

**STOP HERE.** Do not take any further action. The user will run `/clear` and `/r-start` themselves.

---

## Rules

- **STOP after displaying instructions** — do not attempt to run `/clear` (it is a built-in CLI command that cannot be invoked by skills or tools)
- **Do NOT commit or push** — the conv counter increment is local; `/r-end` handles sync
- **Do NOT skip `/r-save-state`** — the whole point is preserving state across the clear
- If `/r-save-state` asks the user about an existing RESUME-STATE.md, wait for their answer
