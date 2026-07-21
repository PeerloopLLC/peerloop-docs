---
name: current-tasks-persistence
description: "CURRENT-TASKS.md (git-tracked root file) is the write-through task board — CC edits it directly (no Task-tool overlay; subsystem server-gated off Conv 406). Format: 🎯 Now / ⏸️ Parked TOCs + alphabetical Tasks bodies + ✅ Done this conv. RESUME-STATE.md is narrative-only."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: eead624e-8f3a-40a7-a699-84b79d1b19fe
  modified: 2026-07-21T21:40:36.798Z
---

**Task state = `CURRENT-TASKS.md` (git-tracked, repo root), NOT RESUME-STATE.md** ([CURTASKS] cutover Conv 351; **Task-tool detach + format redesign Conv 406**). Retired first the machine-local `.scratch/conv-tasks.md` companion (Conv 351), then the TodoWrite/TaskList overlay itself (Conv 406, when the Task subsystem was found **server-gated off** for this model — see [[project_task_tools_child_session_leak]] `[TASK-TOOLS-VERIFY]`).

**Write-through model (Conv 406):** `CURRENT-TASKS.md` **IS** the state — CC edits the file directly the moment a task changes. There is **no** `TodoWrite`/`TaskList`/`TaskCreate` overlay to hydrate or reconcile (a file edit is as verifiable as the old tool call was, so the discipline forcing-function survives). `RESUME-STATE.md` stays **narrative-only** (Summary / Key Context / **Branch** — keep the Branch line for `conv-branch-check.sh`/`[RSTART-DIFFGATE]`); written at `/r-end`, read-for-context + deleted at `/r-start`.

**The four load-bearing `## ` H2 anchors (redesigned Conv 406 — TOC + stable bodies so tasks don't move on state change):**
- **`## 🎯 Now`** — ordered execution TOC (`N. [CODE](#slug) — title`, top = next). Reprioritise by reordering *here* only.
- **`## ⏸️ Parked`** — gated TOC (`- [CODE](#slug) — gate: …`).
- **`## Tasks`** — one `### [CODE]` body per task, **alphabetical by code**, opening with a `- **State:** …` bullet (`🔄 active` / `📋 queued` / `👀 watch` / `⏸️ parked`; ` · [Opus]` marks tier). **Bodies never move** as state changes — only the TOC line + State bullet change. Anchor slug = code lowercased, brackets stripped (`[A11Y]`→`#a11y`).
- **`## ✅ Done this conv`** — one-liners; `/r-start` Step 7.5 clears it each conv.

**Task lifecycle (all zero-movement except completion):** reprioritise = reorder a `🎯 Now` line · start = flip State to 🔄 · park = move line `Now→Parked` + set State ⏸️ · **complete = delete body from Tasks + add a line to `✅ Done this conv`**.

**Boundary skills just VALIDATE now (not regenerate):** `/r-commit` Step 0, `/r-end` Step 5, `/r-update-tasks` run `.claude/scripts/current-tasks-check.sh` (TOC↔body consistency: dangling links / orphan bodies / slug mismatches) and tidy — they never rebuild task content from a tool. Crash recovery = re-read the git-tracked file.

**How to apply:** never tell the user to "check RESUME-STATE.md" for tasks — the surface is CURRENT-TASKS.md (they keep it open / hand-edit it). To add/track a task, **edit the file** (a `### [CODE]` body + a `🎯 Now`/`⏸️ Parked` line) — do NOT reach for `TaskCreate`/`TodoWrite` (server-gated off). Edit safely per `[EDITSAFE]` (unique anchors, no serializer round-trips on this file). SoT: `CLAUDE.md §Task Persistence` · `PLAN.md § CURTASKS` · `DOC-DECISIONS.md`. Related: [[feedback_todowrite_mnemonic_codes]], [[project_task_tools_child_session_leak]], [[feedback_surface_and_track_all_issues]].
