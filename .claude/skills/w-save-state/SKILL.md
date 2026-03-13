---
name: w-save-state
description: Save current work state to RESUME-STATE.md for cross-session continuity
argument-hint: ""
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Save Session State

**Purpose:** Capture everything needed to resume the current session's work after `/compact` or in a new session. Can be called at any time — mid-task, before compact, or at end of session.

---

## How It Works

1. Scan the conversation for incomplete work, open questions, and key context
2. Write a structured `RESUME-STATE.md` that a future session can act on immediately
3. The startup hook (`check-resume-state.sh`) will detect this file and prompt Claude to present resume options

---

## Step 1: Check for Existing State

If `RESUME-STATE.md` already exists in the docs repo root:

```
Existing state file found (saved [date])
─────────────────────────────────────────
[First 3 lines of ## Summary section]

Options:
1. Overwrite with current state
2. View full file first
3. Abort (keep existing)
```

Wait for user choice before proceeding.

---

## Step 2: Scan the Session

Review the full conversation **and** the active TaskList to identify:

- **What we were working on** — the high-level task or goal
- **What's done** — completed items (brief, bulleted)
- **What's remaining** — incomplete items with enough detail to resume
- **Key context** — decisions made, gotchas discovered, important file paths, test patterns, mock shapes — anything a fresh session would need to avoid re-discovering
- **Open questions** — anything unresolved that needs user input

**IMPORTANT — Always call `TaskList` before writing the state file.** Then:

1. **Prune completed tasks first.** Review each task against the conversation — if it was actually completed during this session, mark it completed (or delete it). Don't carry forward work that's already done.
2. **Carry forward remaining tasks.** Any pending or in-progress tasks MUST appear in the Remaining section of RESUME-STATE.md. These often capture issues, opportunities, and follow-up work that would otherwise be lost.

**Be thorough.** The goal is that a new session with zero prior context can read this file and continue seamlessly. Include file paths, function names, and specific details.

---

## Step 3: Write RESUME-STATE.md

Create in the docs repo root (`/Users/jamesfraser/projects/peerloop-docs/RESUME-STATE.md`):

```markdown
# Resume State

**Session:** [number]
**Saved:** [YYYY-MM-DD ~HH:MM]
**Branch:** code: `[branch]`, docs: `[branch]`

## Summary

[2-3 sentence description of what this session was doing and where it stopped]

## Completed

- [Bulleted list of what's done — keep brief]
- [Include test counts, file names, key milestones]

## Remaining

### [Group 1 name]
- [ ] Item with enough detail to act on
- [ ] Another item — include file paths, function names

### [Group 2 name]
- [ ] More items...

## Key Context

[Paragraph or bullets with critical knowledge needed to resume:]
- Decisions made and why
- Gotchas discovered (e.g., "mock shape must use nested `course: { slug }` not flat `course_slug`")
- File paths being modified
- Test patterns in use (e.g., "beforeEach cleans up sessions to avoid booking limit")
- Any workarounds in place

## Resume Command

To continue: read this file, then work through the **Remaining** items in order.
```

---

## Step 4: Confirm

```
State saved → RESUME-STATE.md

Summary: [1-line summary]
Remaining items: [count]

The startup hook will detect this file in the next session.
```

---

## Writing Guidelines

- **Be specific** — file paths, line numbers, function names, test counts
- **Include "why" not just "what"** — context behind decisions saves re-discovery time
- **Group remaining items** logically (by priority, by file, by feature)
- **Use checkboxes** (`- [ ]`) for remaining items so progress is trackable
- **Keep Completed section brief** — it's for orientation, not documentation
- **Key Context is the most important section** — this is what prevents a new session from hitting the same walls
