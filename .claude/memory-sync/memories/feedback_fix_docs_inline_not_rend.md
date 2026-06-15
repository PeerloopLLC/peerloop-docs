---
name: fix-docs-inline-not-rend
description: "Do NOT rely on /r-end to clean up doc references / stale mentions — fix them inline in the same conv you create them. r-end's update-plan agent only reconciles ACTIVE-block subtasks + status cells, so buried references in completed/migrated blocks slip through. Also: don't TaskCreate trivial doc-cleanups — it bloats TodoWrite with low-signal items."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 199120ba-722a-484e-85fc-f8376272534a
---

When a doc reference goes stale during a conv (e.g. a task closes but PLAN.md / a tech doc still mentions it as open), **fix the reference inline in the same conv** — do NOT hand it off to `/r-end` and do NOT TaskCreate it as a follow-up.

**Why:**
1. **`/r-end` won't reliably catch it.** The update-plan agent is scoped to ACTIVE-block subtask check-offs + Block-Sequence status cells (it explicitly does *not* deep-edit completed/migrated-block narrative — see r-end SKILL.md "update only the table-row status cell"). A stale mention buried inside a *completed* or migrated block's prose has no trigger and slips through. The Extract feeding the agent records "task X closed" but never instructs "scrub every prose reference to X."
2. **TaskCreating trivial cleanups bloats TodoWrite.** Minor doc-fix tasks accumulate as low-signal rows that become hard to assess as convs progress — the opposite of what the backlog is for. A one-line doc edit you can do now should never become a carried-forward task.

**How to apply:** task closes / scope changes → immediately `grep` the docs (PLAN.md especially) for stale references to it and fix them in-conv with a surgical edit. Reconcile all places the item lives (TodoWrite + `.scratch/conv-tasks.md` + PLAN.md / tech docs) in the same turn. Only TaskCreate a doc-fix if it's genuinely non-trivial (multi-file audit, needs a decision). This refines [[feedback_surface_and_track_all_issues]] (which says "TodoWrite anything not immediately resolved") — the carve-out is that trivial doc references *can* be immediately resolved, so resolve them rather than tracking them. Sibling anti-pattern: [[reference_generated_doc_regen]] (don't TaskCreate regen tasks either). Origin: Conv 286 — closed `[TW-V4]`, almost left a stale "open follow-up" mention inside the completed HOME-FEED-MERGE block in PLAN.md; user flagged that r-end wouldn't catch it.
