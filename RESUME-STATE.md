# State — Conv 135 (2026-04-19 ~10:15)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-12`, docs: `main`

## Summary

Conv 135 closed out the DOC-SYNC-STRATEGY Phase 3 follow-ups from the first real SessionStart drift-hook run (9 flags, 11% precision): fixed 1 real gap in `docs/as-designed/session-booking.md` and classified the other 8 via a new DOC-DECISIONS.md entry "Tech Doc Sweep: Vendor/Area Keyword Noise" (4 chronic-noise docs + 4 case-by-case). Promoted the block to a new **Phase 4 — Precision & Coverage** with 3 active tasks (tighten 4 matchers `[DT]`, CI drift-check `[DC]`, stateful `HEAD~5` replacement `[DW]`) and explicit exit criteria. Also migrated two CC-workflow directives from `~/.claude/CLAUDE-SAVED.md` that had been dropped when the global file was cleared: 👉👉👉 question prefix (new `feedback_pointing_emoji_prefix.md`) and mnemonic `[XX]` TodoWrite codes (new `feedback_todowrite_mnemonic_codes.md`). Patched `/r-start` Step 7 and `/r-end` + `/r-end2` `## Remaining` templates so mnemonic codes survive the serialize → deserialize pipeline across conv boundaries.

## Completed

- [x] #1: `persist-project-dir.sh` added to CLAUDE.md §Startup Hooks list (pre-existing gap flagged by docs agent)
- [x] #2: 9 tech-doc-sweep drift flags triaged — 1 real gap fixed (`session-booking.md` month-nav cap), 8 false positives classified via new DOC-DECISIONS.md entry
- [x] `[RS]` #7: /r-start Step 7 updated to assign mnemonic codes during RESUME-STATE → TodoWrite transfer
- [x] `[RE]` #8: /r-end + /r-end2 Remaining section updated to preserve `[XX]` codes from TodoWrite-sourced items
- [x] Directive 3 (👉👉👉) migrated from CLAUDE-SAVED.md → `memory/feedback_pointing_emoji_prefix.md`
- [x] Mnemonic-codes directive saved as `memory/feedback_todowrite_mnemonic_codes.md` + indexed in MEMORY.md
- [x] PLAN.md Phase 4 — Precision & Coverage subsection added under DOC-SYNC-STRATEGY with 3 tasks + exit criteria
- [x] PLAN.md Phase 2 Follow-up (known-noise DOC-DECISIONS entry) checked off
- [x] Block status row (line 14) updated to reflect Phase 4 planned
- [x] Conv 135 decisions (3) routed to DOC-DECISIONS.md and 3 TIMELINE.md entries added (via learn-decide agent)

## Remaining

- [ ] `[DT]` Tighten 4 chronic-noise matchers in docsRegistry — per-doc rule refinements (astrojs → `astro.config.*` only; stream → Stream SDK / `src/lib/stream*`; ratings-feedback → real rating/review tables; react-big-calendar → dep bump / adopter). Add regression tests to `.claude/scripts/test-drift-detection.sh` (positive + negative control per rule). Goal: cut first-run FP rate from ~89% toward 0%.
- [ ] `[DC]` Implement CI drift-check (Option A) proactively — GH Actions workflow on PR / push-to-main, cross-repo checkout, runs `.claude/scripts/tech-doc-sweep.sh`, fails job or comments on PR when drift flags appear. Rationale: CC-only-entry assumption is structurally unverifiable; a single non-CC commit (direct terminal, IDE, web UI, CI automation) silently breaks SessionStart-hook coverage.
- [ ] `[DW]` Extend HEAD~5 window to last-full-sync state — design stored baseline (committed `.claude/.drift-baseline-sha` file or `drift-synced-YYYYMMDD` git tag) that the sweep diffs from, advancing when drift is cleared (manually via `/w-sync-docs` or automatically when a run returns zero flags). Edge cases: merges, branch switches, rebases, force-pushes.
- [ ] `[DV]` Validate SessionStart drift hook reliability over 10+ convs — passive observer. Watch for (a) false-positive fatigue, (b) drift introduced >5 commits ago that escapes the HEAD~5 window. Only meaningful after `[DT]` tames the current 89% FP rate.

## TodoWrite Items

- [ ] #3: [DV] Validate SessionStart drift hook reliability over 10+ convs — DOC-SYNC-STRATEGY Phase 3 follow-up; passive observer
- [ ] #4: [DC] Implement CI drift-check (Option A) proactively — reframed from passive deferral; CC-only-entry assumption unverifiable
- [ ] #5: [DT] Tighten 4 chronic-noise matchers in docsRegistry — per-doc rule refinements + regression tests
- [ ] #6: [DW] Extend HEAD~5 window to last-full-sync state — stored baseline with advancement on drift-clear

## Key Context

- **Phase 4 exit criteria** (per PLAN.md DOC-SYNC-STRATEGY §Phase 4): (a) first-run FP rate below 20% on at least 3 separate drift batches; (b) CI drift-check gating merges to `main`; (c) baseline-SHA advancement mechanism proven across 3+ drift-clear events.
- **Dependency ordering for Phase 4 tasks** (recommended): `[DT]` first (unblocks meaningful `[DV]` signal and prevents `[DC]` CI spam) → `[DC]` (coverage closure) → `[DW]` (design-heavy, may be its own conv) → `[DV]` (passive, elapsed-time).
- **First end-to-end test of `[XX]` code-preservation pipeline** is the next `/r-start`. All 4 pending tasks above carry codes. If Conv 136 `/r-start` presents them with the same codes after passing through `/r-end2` serialize + `/r-start` deserialize, the pipeline is validated. If codes churn, investigate /r-end2 `## Remaining` prose merge.
- **DOC-DECISIONS.md "Tech Doc Sweep: Vendor/Area Keyword Noise"** (Section 3, after Auth-Doc precedent) is the authoritative triage table for the 8 false positives. The next `/r-start` SessionStart hook will re-flag the same 9 docs until the code-repo HEAD~5 window shifts past Conv 131 — those re-flags should be dismissed quickly by reading the DOC-DECISIONS entry.
- **Pipeline-symmetry insight (Learning 2):** Conventions that transit a serialized form between skills need both producer and consumer patched together. The `[RS]` + `[RE]` pair this conv is a live example; future cross-skill conventions should patch all pipeline stages in one go.
- **Sub-agent verification insight (Learning 1):** Before acting on a "REAL GAP" verdict from an Explore sub-agent, read the cited loader's return shape or the actual diff of the triggering change. Group A this conv claimed `feeds.md` was a real gap; 30-second verification proved false.
- **Code repo unchanged** this conv. Commit will be docs-repo only. Staging / production deploys unaffected.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
