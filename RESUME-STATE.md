# State — Conv 351 (2026-06-30 ~09:50)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Single-thread infra conv: executed **[CURTASKS] Phases 2–3** — the **atomic skill cutover** from the `RESUME-STATE.md`-Remaining + machine-local `.scratch/conv-tasks.md` split to the git-tracked `CURRENT-TASKS.md` task-persistence model (the sibling spt project's design, decided Conv 350). Built `/r-update-tasks` (preserve-then-overlay engine, dry-run-verified), flipped `/r-start` read path (active-only hydration), `/r-end` Step 5 write path (this narrative-only RESUME-STATE), and `/r-commit` Step 0 (boundary refresh). Committed `217b8ad`; the write path was live-tested via `/r-commit` Step 0 and this `/r-end`. Phases 4–5 (scripts/config + docs/memory) deferred to a follow-up conv.

## Key Context

- **This is the FIRST narrative-only RESUME-STATE** — the cutover is now live. There is intentionally **no `## Remaining` / `## TodoWrite Items` section**; the task backlog lives in `CURRENT-TASKS.md`. **The next `/r-start` exercises the NEW read path for the first time** (active-only Step 7, repurposed Step 7.5, Step 8 reading `CURRENT-TASKS.md § 🔥 Ordered`) — worth watching for any first-run rough edge.
- **Task state: `CURRENT-TASKS.md`** (repo root, git-tracked). 15 tasks: `[CURTASKS]` Ordered/🔄 Active, `[MEM-CAP-ARCH]` ★ Next, 9 backlog, 4 Parked. TodoWrite starts **empty** next conv (active-only) — pull a row via `TaskCreate` when you start it.
- **CURTASKS Phases 4–5 remain** (the [CURTASKS] row stays Active): Phase 4 = scripts/config (`resume-state-check.sh` narrowing, `config.json` timecard entries, `w-review-resume-state` retarget, commit-format exclusion lists already done); Phase 5 = docs (`CLAUDE.md`, `skills-system.md` — the heaviest, a driftCheck doc the docs-agent flagged-but-deferred) + memory (3 core + ~10 incidental rewrites) + fully retire `.scratch/conv-tasks.md` references (e.g. `r-end` SKILL line ~111 still names it as a filtered example). SoT: **PLAN § CURTASKS**.
- **`conv-branch-check.sh` needs no change** — RESUME-STATE keeps its `Branch` line (the only field the cutover preserved here).
- **Baseline NOT re-verified this conv** — the Peerloop code repo was untouched + clean all conv; last green was Conv 349 (not re-run).
- This conv's cc-workflow decision routed to `DOC-DECISIONS.md §3`; a milestone was added to `TIMELINE.md`.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.
