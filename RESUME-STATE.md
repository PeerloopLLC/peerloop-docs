# State — Conv 403 (2026-07-21 ~12:23)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Conv 403 closed two threads. (1) Triaged the `/members` "Monitoring" role badge (`[MMB]`) as **intentional designed behavior** — a `getMemberBadges` fallback for role-less members, first-class in the `MemberRole` type since Conv 111 — and corrected the stale PLATO `expect` at `member-directory.instance.ts:108`; component untouched, `[MMB]` closed. (2) **Root-caused the "Task MCP tools down" issue**: interactive sessions were being misclassified as child sessions because `CLAUDE_CODE_CHILD_SESSION=1` + `AI_AGENT=…agent` leaked in from VS Code's frozen process env, so Claude Code withheld the parent-owned todo tools (`TodoWrite`, `TaskCreate/List/Update/Get`). Hardened both `~/.zshrc` launchers (`peerloop()` + `spt()`) with `env -u`; saved memory `[TASK-TOOLS-DOWN]`.

## Key Context

- **Task backlog lives in `CURRENT-TASKS.md`** — do not re-list here. `[MMB]` is in ✅ Completed-this-conv; no new backlog items added. Top Ordered `[MERGE-BRIAN-JULY7]` still ON HOLD (gate: user's client conversation).

- **⚠️ THIS conv's session was still child-flagged** — the launcher fix takes effect on the *next* `peerloop` launch (tools register at startup). Task MCP tools (`TaskList`/`TaskCreate`/`TaskUpdate`) were unavailable all conv; r-end task ops were driven by hand-editing `CURRENT-TASKS.md`.

- **USER ACTION PENDING:** to clear the current pollution, fully **Cmd-Q VS Code and relaunch from Dock/Spotlight** (not via `code`/`open` from a claude shell). Then `echo $CLAUDE_CODE_CHILD_SESSION` should be empty and the todo tools return. Full diagnosis + fix in memory `[[project_task_tools_child_session_leak]]` (`[TASK-TOOLS-DOWN]`).

- **`~/.zshrc` is a home dotfile** — the launcher edits are NOT in either repo, so r-end did not commit them; they persist on MacMiniM4Pro only. MacMiniM4 would need the same edit if it ever hits the issue.

- **Code stack unchanged** — still `jfg-dev-14` on the Astro 7.1.3 stack from Conv 402. This conv's `npm ci` only reconciled `node_modules` to the committed lockfile (no lockfile change). Baseline NOT re-verified this conv — the only code change was a 1-line test-spec doc-string edit; no gates were run.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.
