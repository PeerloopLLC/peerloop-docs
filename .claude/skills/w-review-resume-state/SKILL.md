---
name: w-review-resume-state
description: Load and present RESUME-STATE.md so the user can decide what to do with it
argument-hint: ""
allowed-tools: Read, Bash, Glob
---

# Review Resume State

**Purpose:** Load the saved session state from `RESUME-STATE.md` and present it to the user with options for how to proceed.

---

## Step 1: Check for State File

Look for `RESUME-STATE.md` in the docs repo root:

```
/Users/jamesfraser/projects/peerloop-docs/RESUME-STATE.md
```

If the file does **not** exist:

```
No RESUME-STATE.md found — nothing to review.
```

Stop here.

---

## Step 2: Load and Present

Read the full `RESUME-STATE.md` file, then present a summary to the user:

```
Resume State Found
──────────────────────────────────────────

Session: [number]  |  Saved: [date]
Branch: code: `[branch]`, docs: `[branch]`

Summary:
[2-3 sentence summary from the file]

Completed: [count] items
Remaining: [count] items

[List the remaining items with their checkbox status]

──────────────────────────────────────────
Options:
  1. Resume this work
  2. Delete state file and start fresh
  3. Keep state file but ignore for now
──────────────────────────────────────────
```

Wait for the user to choose before taking any action.

---

## Step 3: Act on Choice

- **Option 1 (Resume):** Begin working through the **Remaining** items in order. Read the **Key Context** section first to avoid re-discovering gotchas.
- **Option 2 (Delete):** Remove `RESUME-STATE.md` and confirm deletion.
- **Option 3 (Ignore):** Do nothing — leave the file in place for a future session.
