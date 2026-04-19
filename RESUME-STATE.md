# State — Conv 136 (2026-04-19 ~13:21)

**Conv:** ended
**Machine:** MacMiniM4-Pro
**Branch:** code: `jfg-dev-12`, docs: `main`

## Summary

Conv 136 promoted all three v2 skill pairs to replace their v1 counterparts: r-commit2 → r-commit, r-end2 → r-end, r-timecard-day2 → r-timecard-day. Supporting files (scripts/, refs/) were identical so only SKILL.md needed replacement; v2 directories deleted. CLAUDE.md skills table updated. Also validated the `[XX]` mnemonic code pipeline end-to-end — all 4 DOC-SYNC-STRATEGY Phase 4 task codes survived the Conv 135 → 136 round-trip intact.

## Completed

- [x] v2 skill promotion: r-commit2 → r-commit, r-end2 → r-end, r-timecard-day2 → r-timecard-day
- [x] CLAUDE.md skills table updated (removed v2 rows, updated descriptions)
- [x] `[XX]` pipeline validated (all 4 codes survived Conv 135→136 round-trip)
- [x] npm install run (package-lock.json drift resolved)

## Remaining

- [ ] `[DT]` Tighten 4 chronic-noise matchers in docsRegistry — per-doc rule refinements (astrojs → `astro.config.*` only; stream → Stream SDK / `src/lib/stream*`; ratings-feedback → real rating/review tables; react-big-calendar → dep bump / adopter). Add regression tests to `.claude/scripts/test-drift-detection.sh` (positive + negative control per rule). Goal: cut first-run FP rate from ~89% toward 0%.
- [ ] `[DC]` Implement CI drift-check (Option A) proactively — GH Actions workflow on PR / push-to-main, cross-repo checkout, runs `.claude/scripts/tech-doc-sweep.sh`, fails job or comments on PR when drift flags appear.
- [ ] `[DW]` Extend HEAD~5 window to last-full-sync state — design stored baseline (committed `.claude/.drift-baseline-sha` file or `drift-synced-YYYYMMDD` git tag) that the sweep diffs from, advancing when drift is cleared.
- [ ] `[DV]` Validate SessionStart drift hook reliability over 10+ convs — passive observer. Only meaningful after `[DT]` tames the current 89% FP rate.

## TodoWrite Items

- [ ] #1: [DT] Tighten 4 chronic-noise matchers in docsRegistry — per-doc rule refinements + regression tests
- [ ] #2: [DC] Implement CI drift-check (Option A) proactively — GH Actions workflow on PR/push-to-main
- [ ] #3: [DW] Extend HEAD~5 window to last-full-sync state — stored baseline design
- [ ] #4: [DV] Validate SessionStart drift hook reliability over 10+ convs — passive observer

## Key Context

- **Dependency ordering for Phase 4 tasks** (recommended): `[DT]` first → `[DC]` → `[DW]` → `[DV]` (passive, elapsed-time).
- **Phase 4 exit criteria:** (a) first-run FP rate below 20% on at least 3 separate drift batches; (b) CI drift-check gating merges to `main`; (c) baseline-SHA advancement mechanism proven across 3+ drift-clear events.
- **CC autocomplete** will still show r-end2/r-commit2/r-timecard-day2 until user restarts Claude Code — stale cache, not a file-system issue. Files are deleted.
- **Skill promotion pattern** established: overwrite SKILL.md in-place, delete v2 dir — preserves directory name, supporting files, all cross-references.
- **docs/as-designed/skills-system.md** updated by docs agent this conv (skill count 16 → 13, Consolidation History entry added).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
