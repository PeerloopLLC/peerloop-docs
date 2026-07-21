---
name: project_task_tools_child_session_leak
description: "[TASK-TOOLS-DOWN] CORRECTED Conv 404 — TodoWrite is DISABLED BY DEFAULT since CC 2.1.142 (superseded by Task* tools); the Conv-403 'leaked CLAUDE_CODE_CHILD_SESSION' diagnosis was FALSE — that var is injected by CC into its own Bash-tool shells, so probing it from Bash proves nothing."
metadata: 
  node_type: memory
  type: project
  originSessionId: 9a6745a4-1775-4651-9f13-259287c75ae1
  modified: 2026-07-21T17:20:33.205Z
---

[TASK-TOOLS-DOWN] When `TodoWrite` is absent, the ordinary cause is that **Claude Code disabled it by default in v2.1.142**, superseding it with the structured `TaskCreate`/`TaskGet`/`TaskList`/`TaskUpdate` tools. This is documented behavior, not a fault — see `code.claude.com/docs/en/tools-reference.md` and `…/agent-sdk/todo-tracking.md`. Re-enable with the env var **`CLAUDE_CODE_ENABLE_TASKS=0`** (counter-intuitive polarity: `0` turns the *Task tools* off and brings `TodoWrite` back). There is no `settings.json` key for it — it is env-only, so it goes in the `env` block of `~/.claude/settings.json`, and it takes effect at the **next launch** (tools register at startup).

**⚠️ The Conv-403 root cause was WRONG — do not act on it.** Conv 403 concluded the session was being "misclassified as a child session" via a `CLAUDE_CODE_CHILD_SESSION=1` + `AI_AGENT=claude-code_*_agent` leak from VS Code's frozen process env, and prescribed `env -u` in the `~/.zshrc` launchers plus a Cmd-Q VS Code relaunch. Conv 404 falsified this by probing the **real** process environments with `ps -wwwE -p <pid>`:

| Process | `CLAUDE_CODE_CHILD_SESSION` / `AI_AGENT` |
|---|---|
| the `claude` process itself | **absent** |
| its parent `zsh -l` | **absent** |
| VS Code | **absent** |
| a **Bash-tool subprocess** | **present** |

**The probe was measuring the wrong process.** Those variables are injected by Claude Code *into the Bash tool's own child shells* — they are the harness marking its subprocesses, and they are expected there. Running `echo $CLAUDE_CODE_CHILD_SESSION` from the Bash tool therefore **always** prints `1` in every healthy session and can never diagnose anything. The prescribed Cmd-Q VS Code relaunch was never needed, and the `env -u` edits were no-ops that stripped vars which were never set — **both `peerloop()` and `spt()` were reverted to plain `claude …` in Conv 404** (backup `~/.zshrc.bak-conv404`; `zsh -n` clean, both functions verified resolving in a fresh login shell). Do not re-add them.

**How to apply:** (1) To diagnose a missing built-in tool, probe the **claude process's own env** — `ps -wwwE -p $(pgrep -n claude)` — never `echo $VAR` from the Bash tool, whose env is deliberately different from its parent's. This is the general lesson: *the Bash tool's environment is not the session's environment.* (2) Check the official docs for a default-off flag before theorizing about leaks or misclassification — `claude-code-guide` (agent) is the fast path and cites `code.claude.com/docs`. (3) `CLAUDE_CODE_ENABLE_TASKS=0` lives in `~/.claude/settings.json` `env` (added Conv 404). (4) **Residual unknown:** on CC 2.1.216 the `Task*` tools were *also* absent, as were `Grep`/`Glob` — not explained by settings, CLI flags, or output styles; if it recurs, treat the pruned tool set as the question, not the child-session theory. See [[feedback_current_tasks_persistence]], [[feedback_external_source_of_truth_first]].
