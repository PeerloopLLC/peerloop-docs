---
name: feedback_skill_body_stale_after_self_pull
description: "A skill's in-context rendered body is a pre-pull snapshot; if Step 2's git pull updates that same SKILL.md, re-read the on-disk file before executing later steps"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: d7bf206d-09fe-425d-a0da-5b9513a60976
---

When a slash-command skill is invoked, the SKILL.md body Claude sees is rendered **at SessionStart / invocation time** — a snapshot. `/r-start` (and any skill whose own steps `git pull`) can therefore pull a **newer version of itself** mid-run: Step 2's `git pull` updated `.claude/skills/r-start/SKILL.md` on disk, but the copy in Claude's context stayed the old (pre-pull) version. Result: steps added on the other machine are silently skipped.

**Why:** Convs 218 ran the Conv-214-era `/r-start` body, which had no `Step 7.5` (the `.scratch/conv-tasks.md` task-companion generator). Step 7.5 was added in **Conv 215** (commit `411ddaf`) on the other machine and arrived via Step 2's pull this conv — too late for the rendered body. The user caught the missing file ("won't you supposed to create a .scratch folder file…?"). This is **staleness, not truncation** — the echo was a faithful copy of an older skill.

**How to apply:**
- After `/r-start` Step 2's pull, if the pull modified the running skill's own `SKILL.md`, **re-read the on-disk file** before continuing — don't trust the invocation-time body. (Conv 218 added a Step-2 self-update check to `r-start/SKILL.md` to enforce this; see [[feedback_current_tasks_persistence]] for the related task-persistence model.)
- The principle generalizes to **any self-pulling skill** (`/r-commit`, `/r-end` if they pull): the on-disk `SKILL.md` post-pull is the source of truth, not the rendered echo. Same family as [[feedback_external_source_of_truth_first.md]] — probe the authoritative artifact, don't infer from a stale copy.
- When a user says "aren't you supposed to do X" about a skill, grep the on-disk SKILL.md (not memory of it) before answering.
