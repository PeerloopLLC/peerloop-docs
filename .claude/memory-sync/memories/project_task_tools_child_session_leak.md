---
name: project_task_tools_child_session_leak
description: "Task/todo tools (TodoWrite, TaskCreate/List/Update/Get) missing = session misflagged as child via leaked CLAUDE_CODE_CHILD_SESSION from VS Code env; fix in peerloop launcher + clean VS Code restart."
metadata: 
  node_type: memory
  type: project
  originSessionId: 9a6745a4-1775-4651-9f13-259287c75ae1
  modified: 2026-07-21T16:20:01.049Z
---

[TASK-TOOLS-DOWN] When `TodoWrite` + `TaskCreate`/`TaskList`/`TaskUpdate`/`TaskGet` are absent (ToolSearch → "No matching deferred tools found"), the session is being **misclassified as a child/agent session**. Claude Code computes `Lgi = Boolean(CLAUDE_CODE_CHILD_SESSION)` at startup; a child session doesn't own the todo list (the parent does), so those tools are withheld while `TaskOutput`/`TaskStop` (own-process control) remain. They are **not** MCP tools (no `mcp__` prefix) — built-in, present with identical counts in every 2.1.x binary — so it is never a version/removal or a settings-gate issue (permission gating makes a tool *prompt*, not *vanish*).

**Root cause (diagnosed Conv 403):** `CLAUDE_CODE_CHILD_SESSION=1` + `AI_AGENT=claude-code_*_agent` (the `AI_AGENT` var is set only on a CC *agent* spawn — a fingerprint) leak in from **VS Code's frozen process environment**. VS Code was launched (`code` / `open -a`) from inside a Claude Code agent Bash context, so its env carries the child/agent markers; it injects that env into every integrated terminal, so every `peerloop`→`claude` inherits them. Persists for VS Code's whole lifetime → "tools down for the entire conv" across many convs. Ruled out: NOT tmux (CC also probes `tmux show-environment -g CLAUDE_CODE_CHILD_SESSION`, but a non-tmux launch skips it), NOT a shell-profile export, NOT a settings / `terminal.integrated.env` gate, NOT a real parent claude (`ps` ancestry showed `claude → zsh -l → VS Code → launchd`, no claude ancestor).

**Why it matters:** the workflow leans on these tools (r-start Step 7, CLAUDE.md §Task Persistence). Degrading to hand-editing `CURRENT-TASKS.md` is the documented fallback but loses the active-in-flight TodoWrite layer.

**How to apply:** (1) Durable fix is in `~/.zshrc peerloop()` — `env -u CLAUDE_CODE_CHILD_SESSION -u AI_AGENT claude …` strips the markers so every launch starts clean (effective on the *next* launch only; tools register at startup, so it can't retrofit a running session). The sibling `spt()` launcher has the same latent bug — apply the same `env -u` if it recurs there. (2) To clear an already-polluted VS Code, fully Cmd-Q and relaunch from Dock/Spotlight — **not** via `code`/`open` from a claude shell. Verify with `echo $CLAUDE_CODE_CHILD_SESSION` (empty) in a fresh terminal, or by the todo tools reappearing. Standing rule: never launch VS Code from inside a Claude Code Bash call. See [[feedback_current_tasks_persistence]].
