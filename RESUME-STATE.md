# State — Conv 418 (2026-07-26 ~11:55)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Closed four tasks — M2 `[CANMSG]`, M3 `[MSG-ICON]`, M4 `[MSG-ADOPT-A]` of the MESSAGES mini-plan, plus `[CMDEL]` raised and closed at the r-end checkpoint. The through-line: messaging a person no longer costs a network round-trip per row, no longer costs the reader their page, and no longer shows people who have been deleted. Three code commits landed and were pushed mid-conv (`3b3310cd`, `1d0e740a`, `148ac48d`); the `[CMDEL]` fix plus all docs/bookkeeping land in the end-of-conv commit. Suite ended at **6584**, 5 gates green throughout.

## Key Context

- **The MESSAGES programme can legitimately stop here.** M1–M4 are done and the preamble in `CURRENT-TASKS.md § 🎯 Now` says so. M5 `[MSG-ADOPT-B]` trades scroll position rather than work, so it is genuinely optional; M6 `[MSG-CLEANUP]` is a debt sweep that carries one real decision (keep or delete `GET /api/me/can-message/:userId`, which now has no UI caller).
- **M5 is a pure repeat of M4's pattern** — `appearance="bare"`, site `className` + icon element + `title` verbatim, and **omit `signedIn`** (it self-resolves). The nine files in commit `148ac48d` are worked examples. Do not re-derive it.
- **Two task premises turned out to be wrong this conv, in the same way.** `[CANMSG]` said the client gate was vacuous (it wasn't, on 3 of 4 surfaces); `[MSG-ADOPT-A]` said to thread `signedIn` through (the components had no viewer knowledge, so that meant hardcoding a constant 11 times). Both were written from reading the *function* rather than the *call sites*. Worth expecting on M5/M6.
- **`[CMDEL]` was caught by the r-end docs agent, not by the sweep** — it read the API docs rather than the diff and spotted the one member query the sweep missed. The generalisation is recorded in Learnings §6: enumerating call sites is the right boundary for deciding whether a guard is removable, but the wrong boundary for the fix that follows.
- **Four of M4's 11 affordances were never live-verified**, by the user's explicit call, with each precondition named in `plan/merge-brian/README.md` (booking wizard at confirm step ×2, a live session, a `moderation_actions` row with a resolvable `targetUser`). That is a setup checklist, not an open question.
- **Dev server:** running, but the fresh `astro dev` daemon binds `[::1]` only — use **`localhost:4321`**, not `127.0.0.1:4321`. A stale `node_modules/.vite` cache caused a route-specific 500 mid-conv; that third `[DEVSRV-STALE]` variant is now written up on the task, and the diagnosis has been re-derived four times, so the memo it asks for is overdue.
- **MEMORY.md is at 77% of the 25 KB auto-load cap** — under the 80% trigger but the two big Conv-396 levers are already spent, so `[MEM-PRUNE]` will need extraction or consolidation next time rather than trimming.
- For the task backlog, see `CURRENT-TASKS.md` — do not re-list here.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.
