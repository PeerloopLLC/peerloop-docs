---
name: feedback-conv-tasks-live-sync
description: "Keep .scratch/conv-tasks.md live-synced with TodoWrite during the conv; on task completion prepend \"*DONE* \" to the row's meaning column — never delete the row"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 6b4a6368-f4c2-4625-afd1-68e21318d030
---

`.scratch/conv-tasks.md` (the plain-language TodoWrite companion `/r-start` Step 7.5 generates) must be kept **in sync with TodoWrite during the conversation**, not just at generation time:

- **On completion** — when a task is marked `completed` via TaskUpdate, do **NOT** delete its row from conv-tasks.md. Instead **prepend `*DONE* `** to the start of that row's "what it actually means" column. The row stays visible so the user can see what got done this conv.
- **On new task** — when a task is created mid-conv (TaskCreate), add a row for it under the right theme group so the file stays complete.

**Why:** The user keeps conv-tasks.md open in VS Code as the live "what am I looking at" view. Deleting completed rows mid-conv makes work vanish from their view; a `*DONE*` marker preserves the record while still showing progress at a glance.

**How to apply:** Whenever you call TaskUpdate→completed or TaskCreate, do the matching conv-tasks.md edit in the same stretch of work. Across convs the file is regenerated fresh from the (pending-only) carried-forward set, so `*DONE*` markers naturally fall off next conv — they're a within-conv progress signal. Legend documented in the Step 7.5 header template. Related: [[feedback_resume_state_as_todowrite_persistence]].
