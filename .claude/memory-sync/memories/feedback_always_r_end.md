---
name: Autonomous /r-commit, guarded /r-end
description: /r-commit can be run autonomously; /r-end always requires user approval
type: feedback
originSessionId: 83441c70-0117-43ac-b18b-de6d150697c6
---
`/r-commit` can be run autonomously whenever a commit feels warranted — no need to ask the user first.

`/r-end` must **never** be executed without explicitly asking the user for approval first — it closes the conv, creates session docs, and pushes.

**Why:** User wants smooth workflow without commit-approval friction. `/r-end` has broader consequences (session close, state capture, push) that require user control. Originally (Conv 100) `/r-commit` was only for "strategic mid-conv snapshots"; as of Conv 108 it's fully autonomous.

**How to apply:** After completing a meaningful unit of work, go ahead and run `/r-commit`. Before any `/r-end`, always ask. When the user says "commit" mid-work, use `/r-commit`. When they signal end-of-work, ask before running `/r-end`.
