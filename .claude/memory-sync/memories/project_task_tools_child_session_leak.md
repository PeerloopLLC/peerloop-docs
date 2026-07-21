---
name: project_task_tools_child_session_leak
description: "[TASK-TOOLS-DOWN] Conv 405 — CLAUDE_CODE_ENABLE_TASKS=0 did NOT restore TodoWrite and DID kill Task*; var removed, default restored. Conv-403 'leaked CLAUDE_CODE_CHILD_SESSION' theory was FALSE. Grep/Glob absence is a separate, older, undocumented problem."
metadata: 
  node_type: memory
  type: project
  originSessionId: 9a6745a4-1775-4651-9f13-259287c75ae1
  modified: 2026-07-21T20:25:48.830Z
---

[TASK-TOOLS-DOWN] **Don't chase `TodoWrite` — it is deprecated and we don't need it.** Claude Code disabled `TodoWrite` by default in **v2.1.142**, superseding it with `TaskCreate`/`TaskGet`/`TaskList`/`TaskUpdate` (`code.claude.com/docs/en/tools-reference.md`). This project's CLAUDE.md and skills already use the `Task*` tools throughout, so **the only thing worth restoring is `Task*`**.

**⚠️ `CLAUDE_CODE_ENABLE_TASKS=0` is a trap — it makes things worse.** The docs say `0` re-enables `TodoWrite`. Conv 404 set it in `~/.claude/settings.json` `env`; Conv 405 launched fresh on CC 2.1.216 and observed: **no `TodoWrite`** (the doc's promise did not hold) **and no `Task*`** (the var did exactly what its name says — turned the Task tools off). Net effect: a working tool set was traded for nothing. **The var was REMOVED in Conv 405**, restoring the documented default (Task* on, TodoWrite off). Empirical proof it was the cause: a scan of 78 session JSONLs (v2.1.183 → 2.1.216) shows `Task*` used healthily every conv through **07-21 09:08**, then **zero** from 07-21 11:55 on — the Conv-403/404 window, not a CC upgrade.

**⚠️ Two unrelated problems were conflated. `Grep`/`Glob` absence is OLDER and still unexplained.** The same 78-transcript scan shows **zero** `Grep`/`Glob` calls across the *entire* retained window (2026-06-22 → 07-21) — so it long predates Conv 403/404 and is not a task-tools issue. Ruled out: no `--tools`/`--disallowedTools` in the `peerloop` alias, no `permissions.deny` in any settings scope, no `managed-settings.json`, ripgrep 14.1.1 present and working. Docs confirm both tools are current in 2.1.216 (only bugfixes in the changelog) and that tool-search deferral is **MCP-only** — yet this session's deferred pool holds built-ins (`Monitor`, `WebFetch`, `EnterPlanMode`, `Cron*`), so the deferral is broader than documented. **Verdict: undocumented harness behavior, `/feedback` candidate.** Impact is degradation not blockage — Bash `grep`/`find`/`rg` and the `Explore` agent all work.

**⚠️ The Conv-403 root cause was WRONG — do not act on it or re-derive it.** Conv 403 blamed a `CLAUDE_CODE_CHILD_SESSION=1` + `AI_AGENT=…` leak from VS Code's frozen process env and prescribed `env -u` in the `~/.zshrc` launchers plus a Cmd-Q relaunch. Conv 404 falsified it with `ps -wwwE -p <pid>`:

| Process | `CLAUDE_CODE_CHILD_SESSION` / `AI_AGENT` |
|---|---|
| the `claude` process itself | **absent** |
| its parent `zsh -l` | **absent** |
| VS Code | **absent** |
| a **Bash-tool subprocess** | **present** |

**The probe was measuring the wrong process.** Those vars are injected by Claude Code *into the Bash tool's own child shells* — the harness marking its subprocesses. `echo $CLAUDE_CODE_CHILD_SESSION` from the Bash tool therefore prints `1` in **every** healthy session and can never diagnose anything. Both `peerloop()` and `spt()` were reverted to plain `claude …` in Conv 404 (backup `~/.zshrc.bak-conv404`). Do not re-add the guards. MacMiniM4 may still carry them — clean up when next on that machine.

**How to apply:** (1) To diagnose a missing built-in tool, probe the **claude process's own env** (`ps -wwwE -p $(pgrep -n claude)`), never `echo $VAR` from the Bash tool — *the Bash tool's environment is not the session's environment*. (2) **Scan the session JSONLs** (`~/.claude/projects/<slug>/*.jsonl`, count `"name": *"<Tool>"` per file against each file's `"version"`) to date when a tool vanished — this is what separated the Task* regression from the older Grep/Glob one. Ignore `~/.claude.json` `toolUsage`: its counters froze on 2026-02-26 and are stale. (3) Check official docs before theorizing — `claude-code-guide` (agent) is the fast path — but **verify the doc's claim empirically**; the `ENABLE_TASKS=0` promise did not hold here. See [[feedback_current_tasks_persistence]], [[feedback_external_source_of_truth_first]].
