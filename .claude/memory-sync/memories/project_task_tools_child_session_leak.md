---
name: project_task_tools_child_session_leak
description: "[TASK-TOOLS-VERIFY] Conv 406 ROOT-CAUSED: Task*/TodoWrite killed by an UNDOCUMENTED server-side gate uZ() reading remote config tengu_vellum_ash, matching the model ID — not our config, not a version bump. Project HARD-DETACHED to write-through CURRENT-TASKS.md. Grep/Glob = separate known upstream bug."
metadata: 
  node_type: memory
  type: project
  originSessionId: 9a6745a4-1775-4651-9f13-259287c75ae1
  modified: 2026-07-21T21:41:53.445Z
---

[TASK-TOOLS-VERIFY] **Root cause FOUND (Conv 406, binary decompile of CC 2.1.214/215/216).** `TaskCreate`/`TaskList`/`TaskUpdate`/`TaskGet`/`TodoWrite` are killed by a **second, undocumented gate** beyond `CLAUDE_CODE_ENABLE_TASKS`:

```js
function uH(){ if(Z.CLAUDE_CODE_ENABLE_TASKS===false) return false; return true }          // the documented env gate
function uZ(){ let e=Je("tengu_vellum_ash",[]); ...; let t=Di(); return e.some(r=>t.includes(r)) } // UNDOCUMENTED
// Task*:      isEnabled(){ return  uH() && !uZ() }
// TodoWrite:  isEnabled(){ return !uH() && !uZ() }
```

`uZ()` reads **remote dynamic config `tengu_vellum_ash`** and returns true if the **current model ID (`Di()`) contains** any string in that list. Because it appears on **both** branches, a true `uZ()` kills `Task*` AND `TodoWrite` at once — a combination **no local setting can produce** (`ENABLE_TASKS` only swaps which family you get). `uH()` is provably true now (var removed Conv 405, verified absent) → **`uZ()` is true**. Binary **identical** across 2.1.214/215/216; `~/.claude/tasks/` last written 07-21 07:21 (AFTER the 2.1.216 install) then stopped → **server-side gate, NOT a version bump, NOT our config.** `vellum` = **0 hits** in the entire changelog (2.1.0→2.1.216). Sibling flag: `tengu_vellum_siding`.

**One live probe left (untested):** the gate substring-matches `claude-opus-4-8[1m]`. If the list targets the **1M variant**, selecting the **non-1M Opus 4.8 via `/model`** would restore `Task*`. NOTE `CLAUDE_CODE_DISABLE_1M_CONTEXT=1` does **NOT** work for this — traced `mi()`/`Tb()`/`kD()`: that var flips 1M *detection* but the suffix is never stripped, so `Di()` still returns `[1m]`. Negative probe → gate targets Opus 4.8 broadly → no local workaround → `/feedback`.

**✅ DECISION (Conv 406): the project HARD-DETACHED from the Task subsystem** — don't chase the tools back. CLAUDE.md §Task Persistence / §Issue Surfacing, the 3 lifecycle skills (`r-start`/`r-end`/`r-update-tasks`), the secondary skills, and `check-output-reminder.sh` were rewritten to **write-through `CURRENT-TASKS.md` directly** (a file edit is as verifiable as the old tool call). `CURRENT-TASKS.md` was also **redesigned** (TOC + stable alphabetical bodies). See [[feedback_current_tasks_persistence]]. So this watch no longer blocks work; keep it only to record the gate + optionally run the `/model` probe.

**Prior-conv history (still valid):**
- `CLAUDE_CODE_ENABLE_TASKS=0` was a **trap** — Conv 404 set it chasing `TodoWrite`; it didn't restore TodoWrite and it *also* fired `uH()` OFF. Removed Conv 405. (We now know `uZ()` was suppressing TodoWrite regardless, so the experiment was confounded.)
- **`Grep`/`Glob` absence is a SEPARATE, older upstream bug** — built-ins vanish from the registry under tool-search deferral and aren't ToolSearch-discoverable: issues **#52121** + **#63525**, both OPEN. Both tools still shipped + documented. Unrelated to `uZ()`.
- **Conv-403 `CLAUDE_CODE_CHILD_SESSION` leak theory was FALSE** — that var is injected by the harness into the Bash tool's *own* child shells (present in every healthy session), so `echo $VAR` from Bash can never diagnose it. `env -u` guards reverted Conv 404; MacMiniM4 may still carry stale ones (harmless — clean when next on it).

**How to apply:** (1) To diagnose a missing built-in, **decompile the installed binary** (`strings -a ~/.local/share/claude/versions/<v>`) and grep for the tool's `isEnabled(){…}` — that revealed `uZ()`. Also probe the *claude process's* env (`ps -wwwE -p $(pgrep -n claude)`), never `echo $VAR` from Bash. (2) **Scan session JSONLs** to date when a tool vanished (count `"name":"<Tool>"` per file vs each file's `"version"`). (3) Read the **local cached changelog** `~/.claude/cache/changelog.md` before theorizing a version cause. See [[feedback_current_tasks_persistence]], [[feedback_external_source_of_truth_first]].
