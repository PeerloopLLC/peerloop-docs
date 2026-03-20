---
name: r-save-state
description: Save current work state for cross-session continuity
argument-hint: ""
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Save Session State

**Purpose:** Capture everything needed to resume the current session's work after `/clear` or in a new session.

---

## Pre-computed Context

**Existing state file:**
!`$CLAUDE_PROJECT_DIR/.claude/scripts/resume-state-check.sh`

**Conv counter:**
!`$CLAUDE_PROJECT_DIR/.claude/scripts/conv-read-counter.sh`

**Active conv:**
!`$CLAUDE_PROJECT_DIR/.claude/scripts/conv-read-current.sh`

**Machine:**
!`cat ~/.claude/.machine-name 2>/dev/null || echo "(unknown)"`

---

## Step 1: Check for Existing State

If `RESUME-STATE.md` already exists:

```
Existing state file found (saved [date])
─────────────────────────────────────────
[First 3 lines of ## Summary section]

Options:
1. Overwrite with current state
2. View full file first
3. Abort (keep existing)
4. Append (add new state block below existing)
```

Wait for user choice before proceeding.

### Option 4 — Append Mode

When the user chooses Append:

1. **Label the existing first block** (if not already labeled). The file's first heading should be `# State — Conv NNN (YYYY-MM-DD ~HH:MM)`. If the file starts with `# Resume State` instead, rewrite that heading using the `**Saved:**` and `**Conv:**` values found in the existing content.

2. **Add the new block** at the end of the file:

```markdown

---

# State — Conv NNN (YYYY-MM-DD ~HH:MM)

**Conv:** [from pre-computed context]
**Machine:** [from pre-computed context]

## Summary
...
```

The new block uses the same internal structure as a normal save (Summary, Completed, Remaining, TodoWrite Items, Key Context) but **omits** the `## Resume Command` section — that only appears once, at the very end of the file after the last block.

3. **Write/update the Resume Command** at the very bottom of the file (after the last block):

```markdown

---

## Resume Command

To continue: run `/r-resume`, which will consolidate all state blocks and present a unified view.
```

**Important:** The maximum number of blocks in the file should be **2**. `/r-resume` consolidates back to 1 on resume. If the file already contains 2 blocks (detected by counting `# State — Conv` headings), do NOT append — instead warn the user:

```
⚠️  RESUME-STATE.md already has 2 unconsolidated blocks.
Run /r-resume first to consolidate before saving new state.
```

---

## Step 2: Scan the Session

Review the full conversation **and** the active TaskList to identify:

- **What we were working on** — the high-level task or goal
- **What's done** — completed items (brief, bulleted)
- **What's remaining** — incomplete items with enough detail to resume
- **Key context** — decisions made, gotchas discovered, important file paths — anything a fresh session would need to avoid re-discovering
- **Open questions** — anything unresolved that needs user input
- **TodoWrite items** — scan the full conversation for any items tracked in TodoWrite; these only exist in conversation memory and will be lost on `/clear` or exit

**IMPORTANT — Always call `TaskList` before writing the state file.** Prune completed tasks first, then carry forward remaining tasks into the Remaining section.

**Be thorough.** The goal is that a new session with zero prior context can read this file and continue seamlessly. Include file paths and specific details.

---

## Step 3: Write RESUME-STATE.md

Create in the docs repo root. Use the conv-labeled heading format:

```markdown
# State — Conv NNN (YYYY-MM-DD ~HH:MM)

**Conv:** [from pre-computed context — NNN if active, or "ended" if .conv-current was cleaned up]
**Machine:** [from pre-computed context]
**Branch:** code: `[branch]`, docs: `[branch]`

## Summary

[2-3 sentence description of what this session was doing and where it stopped]

## Completed

- [Bulleted list of what's done — keep brief]

## Remaining

### [Group 1 name]
- [ ] Item with enough detail to act on
- [ ] Another item — include file paths

### [Group 2 name]
- [ ] More items...

## TodoWrite Items

[All items from TodoWrite at time of save. These exist only in conversation memory and will be lost on /clear or exit. Include status and context.]

- [ ] Item description — context
- [ ] Another item — context

If no TodoWrite items exist, write: "No TodoWrite items active."

## Key Context

[Paragraph or bullets with critical knowledge needed to resume:]
- Decisions made and why
- Gotchas discovered
- Files being modified
- Any workarounds in place

## Resume Command

To continue: run `/r-resume`, which will consolidate state and present a unified view.
```

---

## Step 4: All-Done Check

Before confirming, check whether **all** items in the Remaining section are checked (`[x]`). If so:

1. Display:
```
✅ All remaining items are done — nothing to carry forward.
   Deleting RESUME-STATE.md (state is preserved in git history and PLAN.md).
```

2. Delete `RESUME-STATE.md` (or skip writing it if this is a fresh save).

---

## Step 5: Clear TodoWrite Tasks

After writing RESUME-STATE.md, **mark all TodoWrite tasks as completed** (using TaskUpdate with status `completed`). This prevents stale pending-task indicators from lingering after the conv ends — the tasks are now persisted in RESUME-STATE.md and will be restored by `/r-start` Step 7.

Display:

```
📦 {N} TodoWrite tasks captured in RESUME-STATE.md — cleared from task list.
```

This confirms to the user that outstanding work was not lost, just transferred to durable storage.

---

## Step 6: Confirm

```
State saved → RESUME-STATE.md

Summary: [1-line summary]
Remaining items: [count]
```

---

## Writing Guidelines

- **Be specific** — file paths, function names, concrete details
- **Include "why" not just "what"** — context behind decisions saves re-discovery time
- **Group remaining items** logically (by priority, by topic, by phase)
- **Use checkboxes** (`- [ ]`) for remaining items so progress is trackable
- **Keep Completed section brief** — it's for orientation, not documentation
- **Key Context is the most important section** — this is what prevents a new session from hitting the same walls
