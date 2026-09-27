---
name: r-end-discipline-approval-alerts-post-fix-flow
description: /r-commit is autonomous but /r-end always needs approval; /r-end Step 4 alerts must TaskCreate not just display; post-/r-end fixes use /r-start (no /clear) → fix → /r-end
metadata: 
  node_type: memory
  type: feedback
  originSessionId: cdd106f7-aa2e-48e8-8d2f-b6f557bbf760
---

Three operational rules for the conv-close lifecycle. (The separate **RECURRING FAILURE** rule that /r-end must execute ALL 8 steps lives in [[feedback_rend_complete_all_steps]] — kept standalone for prominence.)

## Autonomous /r-commit, guarded /r-end

`/r-commit` can be run autonomously whenever a commit feels warranted — no need to ask first. `/r-end` must **never** run without explicitly asking the user for approval — it closes the conv, creates session docs, and pushes.

**Why:** smooth workflow without commit-approval friction, but `/r-end`'s broader consequences (session close, state capture, push) require user control. Originally (Conv 100) `/r-commit` was only "strategic mid-conv snapshots"; fully autonomous as of Conv 108.

**How to apply:** after a meaningful unit of work, just run `/r-commit`. When the user says "commit" mid-work → `/r-commit`. When they signal end-of-work → ask before `/r-end`.

## /r-end must TaskCreate every surfaced alert

Every 🔴🔴🔴 and 🟠🟠🟠 alert surfaced in /r-end Step 4 MUST be followed by a `TaskCreate` call — displaying the alert without writing to TodoWrite is a known failure mode (the item looks surfaced but doesn't persist to `CURRENT-TASKS.md` via the Step 5 refresh).

**Why:** Conv 062 surfaced a `maybeUpdateActorSession` design flaw as an orange alert but never called TaskCreate; the item vanished when the conv ended and the user caught it. The SKILL.md was updated in Conv 062 to make this explicit.

## Post-/r-end fixes: /r-start (no /clear) → fix → /r-end

When the user spots something to fix after /r-end completes, the pattern is: `/r-start` (without `/clear` first) → fix → `/r-end`. No gates, no topup skills, no changes to /r-end.

**Why:** each fix gets its own conv number with proper session docs; full conversation context is preserved (no /clear); the "cost" of an extra conv number is actually better for traceability.

**How to apply:** never propose adding commit gates or topup skills to /r-end. Don't suggest /clear between convs unless the user asks.
