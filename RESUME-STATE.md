# State — Conv 271 (2026-06-12 ~08:10)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Re-planned the whole **feed/promotion/discovery group**: the user diagnosed the recurring "missed fundamentals" as a *decomposition* failure (pseudo-isolated fragments that each needed a piece of a sibling), so the 14 fragments were **reassembled into 3 cohesive units** — U1 Seed / U2 Discovery-Rendering / U3 Promotion-System + independent cleanups (canonical plan: `plan/home-feed-merge/REASSEMBLY-CONV271.md`). Then built **FEED-U1's data layer** (seed consolidation verified: 19/19 real Stream IDs in D1). Also: agreed to build a deterministic **Stop-hook linter** (`[QLINT]`) to enforce the `👉👉👉`/`A)B)` question rules Claude keeps violating — **this is the explicit FIRST task next conv.**

## Completed

- [x] Reassembled feed/promotion/discovery group into 3 cohesive units (U1/U2/U3) + cleanups; 4-rule isolation principle; plan approved + persisted to `plan/home-feed-merge/REASSEMBLY-CONV271.md`
- [x] TodoWrite restructured to the unit model (10 fragments merged into unit parents w/ codes preserved as sub-checklists); #5/#16 parked; created #46 QLINT, #47 SYS-NAMING (re-scoped)
- [x] **FEED-U1 data layer:** removed 28 dangling SQL `feed_activities` rows; made `seed-feeds.mjs` canonical + wired into `db:setup:local:dev` (creds-resilient); broadened (+intro-q-system & variety); `compute.ts` `feed_public=1` fix; fixed `feed_type='townhall'`→`'system'` CHECK bug. **Verified: 19/19 real Stream UUIDs in D1** (tsc clean; discovery-rails 18/18; FeedPost+orchestrator 16/16)
- [x] Memory: `feedback_decompose_by_cohesion_not_pseudo_isolation.md` + MEMORY.md index line
- [x] Decided to build `[QLINT]` Stop-hook (deterministic enforcement of the question-format rules)

## Remaining

**▶ FIRST TASK NEXT CONV (user directive):**
- [ ] [QLINT] #46 — Build the Stop-hook linter (settings.json, via update-config skill): block turn-end when the final message has a `?` + mid-sentence ` or ` but no `👉👉👉`/no `A)`/`B)` labels. Watch false-positives on rhetorical "or". Respect [SETTINGS-GUARD] + project-portable settings.

**FEED-U1 #42 closers (in progress — data layer DONE):**
- [ ] Browser density verify — `/api/discovery/rails` + home marketing feed render full & varied with real bodies (dev server + Chrome bridge). May drive a bit more seed-broadening if rails look thin. NOTE: local D1 was re-seeded this conv → real Stream IDs already present.
- [ ] 5-gate `/w-codecheck` to close U1 (run once, after any density-driven seed tweak).

**Feed group (build order U1 → U2 → U3; canonical plan = `plan/home-feed-merge/REASSEMBLY-CONV271.md`):**
- [ ] [FEED-U2] #43 [Opus] — pipeline metadata + CommunityAnchor + FeedPost render swap + remove getDiscoveryCandidates + delete FeedsHubPanel. Dep: U1 (verify).
- [ ] [FEED-U3] #44 [Opus] (blocked by #43) — U3a substrate (schema+cron+dials+announcement) · U3b entity-promo · U3c admin · U3d PromoteNudge (LAST).
- [ ] [SYS-NAMING] #47 [Opus] — owner-based feed naming ("no feed has a name; `<owner> feed`"; system owner="System"). Cross-cutting: FeedPost/FeedActivityCard/enrichment/SocialPost/current-user + ~10 test fixtures + seed; /old pages ASK-PER-PAGE during port. DECIDE the `<owner> feed` rollout scope first. (Partial U1 naming edits were reverted this conv.)
- [ ] [PROMOTE-IDEMP] #45 · [API-DISC-DOC] #32 · [SYS-GET-GATE] #35 — independent cleanups.
- [ ] [COMM-TAG-FILTER] #5 · [SUCCESS-COMMUNITY-VERIFY] #16 — PARKED needs-spec (excluded from group closure).

**Other backlog (unchanged):**
- [ ] [ROLE-STUDIOS] #1 [Opus] (⛔ BLOCKED BY CLIENT) · [RTMIG-4] #2 [Opus] · [SSR-LOADER-DEAD] #4 · [CT-RESTYLE] #6 · [PRIM-MATCH-INDEX] #7 · [TXTBTN] #8 · [PROFILE-PRIM-SWEEP] #9 (PAUSED)
- [ ] [ICN-NS] #10 · [E2E-MIG] #11 · [E2E-GATE] #12 · [SHOWMORE] #13 · [PREFLIP-WT] #14 (KEEP until client-vet)
- [ ] [TZ-AUDIT] #15 [Opus] · [MEM-CAP] #17 (MEMORY.md ~87% → /r-prune-memory) · [DOCGEN-SPEC] #18 · [OLD-PORTED-CLEANUP] #19
- [ ] [LEARN-ISLAND-RESTYLE] #20 · [CREATE-ISLAND-RESTYLE] #21 · [TEACH-ISLAND-RESTYLE] #22 · [TRIAGE-RESTYLE] #23
- [ ] [V217-WATCH] #24 · [COURSEDETAIL-DEAD] #25 · [NUDGE-CACHE-FLASH] #26 · [NUDGE-TC-V2] #27 · [TW-V4] #37 · [TEST-FILE-COUNT] #40 · [PLAN-RENUM] #41

## TodoWrite Items

- [ ] #46 [QLINT] [FIRST] · #42 [FEED-U1] (in progress) · #43 [FEED-U2] [Opus] · #44 [FEED-U3] [Opus] (blocked by #43) · #47 [SYS-NAMING] [Opus]
- [ ] #45 [PROMOTE-IDEMP] · #32 [API-DISC-DOC] · #35 [SYS-GET-GATE] · #5 [COMM-TAG-FILTER] PARKED · #16 [SUCCESS-COMMUNITY-VERIFY] PARKED
- [ ] #1 [ROLE-STUDIOS] [Opus] (BLOCKED) · #2 [RTMIG-4] [Opus] · #4 · #6 · #7 · #8 · #9 (PAUSED) · #10 · #11 · #12 · #13 · #14
- [ ] #15 [TZ-AUDIT] [Opus] · #17 · #18 · #19 · #20 · #21 · #22 · #23 · #24 · #25 · #26 · #27 · #37 · #40 · #41

## Key Context

- **QLINT #46 is FIRST next conv** (user directive). It's the deterministic fix for Claude's repeated `X, or Y?`/missing-👉 violations — passive rules in CLAUDE.md §Recurring-Failures + memory weren't enough.
- **The reassembly is the headline:** decompose by COHESION, not pseudo-isolation. A unit must own its full stack + have a standalone done-test; deps are whole-unit + unidirectional. Saved to `memory/feedback_decompose_by_cohesion_not_pseudo_isolation.md`. Canonical group plan: `plan/home-feed-merge/REASSEMBLY-CONV271.md` (the old 14-fragment sequence in the README is SUPERSEDED).
- **Premise-Check Gate** (run before building each unit): trace the real code path; missing data/schema/infra it needs is part of THIS unit's scope; validate external-service (Stream/KV/cron) assumptions against working code. It caught 2 issues this conv (the townhall CHECK bug + the SYS-NAMING under-scope).
- **FEED-U1 is WIP, not closed:** data layer verified (real Stream IDs) but **browser density verify + full 5-gate `/w-codecheck` remain.** Baseline verified THIS conv = tsc clean + discovery-rails 18/18 + FeedPost/orchestrator 16/16 ONLY — full suite/lint/astro/build NOT run (do at U1 close).
- **`db:setup:local:dev` now needs Stream creds** (chains `db:seed:feeds:local`); both machines have them; offline machines skip gracefully. The script accumulates orphan activities in the Stream DEV app on each run (only the newest batch is D1-referenced) — pre-existing, harmless.
- **SYS-NAMING #47 decision pending:** does `<owner> feed` roll out across ALL feed labels or just retire "The Commons"? Decide at #47 start. /old pages: ask per-page during RTMIG-4 port.
- Code changes this conv will be committed in Step 6 (not yet a hash); 4 code files + docs.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view. **Then start `[QLINT]` #46 (user-designated first task).**
