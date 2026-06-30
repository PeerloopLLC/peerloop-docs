---
name: current-tasks-persistence
description: "CURRENT-TASKS.md (git-tracked root file) is the persistent task store; RESUME-STATE.md is narrative-only; TodoWrite is active-only (empty at /r-start, TaskCreate on start); refresh is checkpoint preserve-then-overlay"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: eead624e-8f3a-40a7-a699-84b79d1b19fe
---

**Task persistence = `CURRENT-TASKS.md` (git-tracked, repo root), NOT RESUME-STATE.md** ([CURTASKS] cutover, Conv 351; adopted the sibling spt model). This **retired** the old split — the machine-local `.scratch/conv-tasks.md` companion + RESUME-STATE-as-TodoWrite-persistence — which was stale-on-return after multi-conv stints on the other machine (and systematically false-halted the old no-shrink guard on every machine switch).

**The three roles split (they do NOT merge):**
- **`CURRENT-TASKS.md`** — the durable backlog. Three load-bearing H2 anchors: `## 🔥 Ordered` (execution sequence, top = next) / `## 📋 Unordered backlog` (with a blockquoted `> ## ⏸️ PARKED` divider *inside* it — never a real H2) / `## ✅ Completed this conv`. `[CODE]`-keyed H3 tasks (no numeric IDs). **Hand-editable, git-tracked, never deleted** — identical on both machines via push/pull.
- **`RESUME-STATE.md`** — **narrative-only** per-conv handoff (Summary / Key Context / **Branch**). Written at `/r-end`, read-for-context + deleted at `/r-start`. **Keeps its Branch line** so `conv-branch-check.sh` / `[RSTART-DIFFGATE]` need no repointing. No task data lives here anymore.
- **TodoWrite** — **active-only** (DEC-350-2). `/r-start` leaves it **empty**; `TaskCreate` (reusing the row's `[CODE]`) only when an item is STARTED. The backlog is CURRENT-TASKS.md, not TodoWrite.

**Refresh = checkpoint preserve-then-overlay** (DEC-350-3, NOT live-sync): refreshed at `/r-commit` (Step 0), `/r-end` (Step 5), and `/r-update-tasks`. The engine reads the old file → `TaskList` → reconstructs the WHOLE file preserving every unmatched row + all `Why:` prose verbatim → overlays live statuses by `[CODE]` → appends new tasks → moves completed to `## ✅ Completed this conv` → full `Write` (never `Edit`/delete/reorder).

**Crash recovery is now trivial:** CURRENT-TASKS.md is git-tracked + refreshed every `/r-commit`/`/r-end`, so a mid-conv crash loses only the small in-flight TodoWrite delta — **re-reading CURRENT-TASKS.md IS the recovery**. No `.scratch/conv-tasks.md` stranded-backlog reconstruction, no no-shrink reconciliation guard (both retired with the old model).

**How to apply:** never tell the user to "check RESUME-STATE.md" for the backlog — the task surface is CURRENT-TASKS.md (they keep it open / hand-edit it). Pull a backlog row into active work via `TaskCreate` reusing its `[CODE]`. SoT: `PLAN.md § CURTASKS` · `DOC-DECISIONS.md` (Conv 350/351 entries). Related: [[feedback_todowrite_mnemonic_codes]].
