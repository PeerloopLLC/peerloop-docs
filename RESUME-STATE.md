# State — Conv 450 (2026-09-21 ~18:56)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-16`, docs: `main`

## Summary

Conv 450 imported the client's `brian-sep-05` work into a **new `jfg-dev-16` branch** (off `jfg-dev-15`). Brian (client) had pushed 14 commits on top of `jfg-dev-15` (a linear superset); we cherry-picked the 11 keep-candidates in original order (`-x`, authorship preserved, zero conflicts) and pruned the 3 he told us to ignore (EMBED-CHECKOUT, CREATOR-TEACHER, COVER-UPLOAD — the exact tip). Applied a `data-prov` fix, preserved the FILTER-STRIP'd Level/Length/Available-soon filters as a **dormant `CoursesFilterPanel`** (+ commented consumer block + guarded endpoint) per the user's "don't lose it, comment it out" ask, verified the baseline green (6520 tests), and confirmed via a 375px iframe harness that mobile is clean (the earlier "lost mobile" was browser-cache staleness, not a regression). Pushed `jfg-dev-16` to the shared origin at close.

## Key Context

- **`jfg-dev-16` = `jfg-dev-15` + 13 commits** (11 Brian cherry-picks + `bb19cd25` data-prov fix + `2f4bf7e1` filter-preservation). Pushed to origin this conv.
- **Dormant-component pattern** (new): deleted-but-wanted functionality preserved as a compiling, never-mounted component + commented consumer block + re-enable checklist header + endpoint guard comment. See `src/components/courses/CoursesFilterPanel.tsx` and the commented block in `CoursesCatalog.tsx`.
- **`/api/courses/availability-batch.ts`** is intentionally retained (guard comment) for the dormant Available-soon filter — do NOT sweep it as dead.
- **Brian's task codes were his own** (not our board); the related MERGE-BRIAN block is CLOSED (Conv 428, different branch).
- Three follow-ons logged to `CURRENT-TASKS.md`: `[CARD-ARBVAL]`, `[SEARCH-SORT-SPREAD]`, `[INSTANT-TAB-GAPS]`.
- New memory: `[BRIDGE-CONNECT]` (`reference_chrome_bridge_connection_recovery.md`) — bridge "extension not connected" recovery; #1 cause = not signed into the Claude extension.
- Dev server (`npm run dev`, localhost:4321) was left running/daemonized on `jfg-dev-16` — `npx astro dev stop` from `~/projects/Peerloop` to kill it.
- MEMORY.md ~81%+ of the auto-load byte cap — `[MEM-PRUNE]`/`[MEM-CAP]` owed.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context. Note the code repo is on `jfg-dev-16`.
