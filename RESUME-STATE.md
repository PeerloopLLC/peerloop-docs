# State — Conv 285 (2026-06-14 ~20:54)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Completed the **LIST-1COL** block (CD-039 single-column "Twitter-style" listings) — Phases 4–8. Phase 4 converted `/feeds` (5 grids → flex-col + ListingShell placeholder branch); Phases 5 & 6 were marked **subsumed** (their `Explore*Tab`/`Community*Tab` targets are legacy-only; live catalogs already converted in Phases 1–2); Phase 7's 16:9 frame was already compliant (added upload guidance to CommunitySettings); Phase 8 added `ListingShell.test.ts`, ran the full 5-gate baseline (6722 tests + build green), updated docs, and closed RFC CD-039 (21/21). All browser-verified. Block archived to plan/COMPLETED.md (#72). No new feature work pending beyond the carried-forward backlog + one doc-drift task.

## Completed

- [x] [LIST-1COL] Phase 4 — `/feeds` single-column (placeholder right-panel branch; role tabs inline)
- [x] [LIST-1COL] Phases 5 & 6 — subsumed (legacy-only targets; live catalogs already converted)
- [x] [LIST-1COL] Phase 7 — 16:9 frame already compliant; upload guidance added to CommunitySettings
- [x] [LIST-1COL] Phase 8 — ListingShell.test.ts (9 tests); 5 gates green (6722 tests + build); docs; RFC CD-039 closed 21/21
- [x] [LIST-1COL] block COMPLETE; archived to plan/COMPLETED.md
- [x] Browser re-verification of all 4 ListingShell surfaces (no issues)

## Remaining

- [ ] [COMM-TAG-FILTER] #1 — DEFERRED post-production
- [ ] [ROLE-STUDIOS] #2 [Opus] — ⛔ BLOCKED BY CLIENT (old-vs-new dashboard comparison)
- [ ] [RTMIG-4] #3 [Opus] — port ~89 legacy /old/* → root
- [ ] [SSR-LOADER-DEAD] #4 · [CT-RESTYLE] #5 · [PRIM-MATCH-INDEX] #6 · [TXTBTN] #7 · [PROFILE-PRIM-SWEEP] #8 (PAUSED profile cluster)
- [ ] [ICN-NS] #9 · [E2E-MIG] #10 · [E2E-GATE] #11 · [SHOWMORE] #12 · [PREFLIP-WT] #13 (KEEP until client-vet)
- [ ] [TZ-AUDIT] #14 [Opus] · [DOCGEN-SPEC] #15 · [OLD-PORTED-CLEANUP] #16
- [ ] [LEARN-ISLAND-RESTYLE] #17 · [CREATE-ISLAND-RESTYLE] #18 · [TEACH-ISLAND-RESTYLE] #19 · [TRIAGE-RESTYLE] #20
- [ ] [V217-WATCH] #21 · [COURSEDETAIL-DEAD] #22 · [NUDGE-CACHE-FLASH] #23 · [NUDGE-TC-V2] #24 · [TW-V4] #25 · [TEST-FILE-COUNT] #26 · [PLAN-RENUM] #27
- [ ] [COMMONS-DATE] #28 · [DISCCARD-DEL] #29 · [TESTDOC-DRIFT] #30 · [ROUTEMAP-LIT] #31 · [TOWNHALL-TEST] #32
- [ ] [FEED-LANE-RENDER] #33 · [STREAM-PURGE] #34
- [ ] [TESTCOMP-DRIFT] #36 — reconcile TEST-COMPONENTS.md with on-disk tests/components/ (pre-existing drift surfaced by Conv 285 r-end docs agent: 2 stale filenames + category structure divergence)

## TodoWrite Items

- [ ] #1–#34 carried-forward backlog (unchanged this conv) · #36 [TESTCOMP-DRIFT] new this conv · #35 [LIST-1COL] COMPLETED this conv

## Key Context

- **LIST-1COL is DONE** — removed from PLAN.md ACTIVE, archived in plan/COMPLETED.md #72. RFC CD-039 Closed (21/21) in docs/requirements/rfc/CD-039/RFC.md + INDEX.
- **The ListingShell right-panel rule (PLAN learning #6, now in _COMPONENTS.md):** standalone filter rail → right panel; role tabs → inline; no filter island → light-blue placeholder. Don't force an event-bus split just to populate the panel.
- **`.astro` unit-test pattern:** source-assertion via readFileSync (onboarding.test.ts precedent), NOT AstroContainer rendering. `tests/components/layout/ListingShell.test.ts` follows it.
- **Baseline VERIFIED this conv:** tsc / astro check / eslint / npm test (6722/6722, 399 files) / npm run build — all green. (Re-verify in next conv before any fresh baseline claim.)
- **Changes committed in Step 6 (this conv)** — not yet a separate commit hash at write time.
- **#36 [TESTCOMP-DRIFT]** is pre-existing drift (predates Conv 285), not caused by this conv's work.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
