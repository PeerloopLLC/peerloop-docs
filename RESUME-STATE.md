# State — Conv 406 (2026-07-21 ~20:25)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Root-caused the Task-subsystem outage (an **undocumented server-side gate** `uZ()` reading remote config `tengu_vellum_ash` against the model ID — not our config, not a version bump) and, on the user's call, **hard-detached the project from the Task subsystem**: all task tracking is now **write-through** to `CURRENT-TASKS.md`, which was also **redesigned** (a `🎯 Now` / `⏸️ Parked` table-of-contents drives ordering; `### [CODE]` bodies live alphabetically under `## Tasks` and never move; `✅ Done this conv`). Built a task-board **test suite** (5 scripts, 29 assertions) and wired it into the r-commit + r-end boundary gates. No code-repo changes.

## Key Context

- **The detach is complete and self-defending.** `TaskCreate`/`TaskList`/`TaskUpdate`/`TodoWrite` are gone from every skill, CLAUDE.md, the hook, and memory. To add/track a task, **edit `CURRENT-TASKS.md` directly** (a `### [CODE]` body + a `## 🎯 Now` or `## ⏸️ Parked` line). Do NOT reach for the Task tools — they're server-gated off (see `[TASK-TOOLS-VERIFY]` on the board + `memory/project_task_tools_child_session_leak.md`).
- **Board format** (four load-bearing anchors): `## 🎯 Now` (ordered TOC, top = next) · `## ⏸️ Parked` (gated TOC) · `## Tasks` (alphabetical `### [CODE]` bodies; status on a `- **State:**` bullet; ` · [Opus]` marks tier) · `## ✅ Done this conv` (cleared each /r-start). Anchor slug = code lowercased, brackets stripped (`[A11Y]`→`#a11y`).
- **Testing:** `.claude/scripts/test-task-board.sh` runs the validator + self-test + lifecycle harness + detach-lint (29 assertions, ~1s). r-commit Step 0 and r-end Step 5 now run it as a gate.
- **One untested hypothesis** (`[TASK-TOOLS-VERIFY]`, optional): the gate substring-matches `claude-opus-4-8[1m]`; selecting the non-1M Opus 4.8 via `/model` *might* restore the tools. `CLAUDE_CODE_DISABLE_1M_CONTEXT` does NOT work for this (traced — the suffix isn't stripped).
- **Cross-machine:** MacMiniM4 still carries stale Conv-403 `~/.zshrc` `env -u` guards (harmless no-ops) — clean next time on it.
- For the task backlog, see `CURRENT-TASKS.md` (do not re-list here). This conv pushed 4 commits (`588c273` start → `7065a39`) plus the end-of-conv commit.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.
