# State — Conv 273 (2026-06-12 ~11:54)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Built **[FEED-U2]** — the discovery-rendering unit of the feed reassembly (build order U2): home-feed discovery sample-posts now render as `FeedPost` with an embedded `Course`/`CommunityAnchor` carrying real entity metadata (course creator/level/**real rating** from `courses.rating`; community icon/members/14d-vitality) + the intent-preserving CTA; dismiss preserved via a SmartFeed wrapper; removed `getDiscoveryCandidates` (zero callers) + deleted orphan `FeedsHubPanel`. 5 gates green (6643 tests), browser-verified (authed render). Committed code `9379a85a`. Then ran an in-conv trial of routing all decisions through `AskUserQuestion`, and per the [QLINT-TRIAL] decision **dropped QLINT entirely** — removed the Stop-hook + its settings registration + sentinel + calibration, and rewrote CLAUDE.md §User-Facing-Questions / §Recurring-Failures #1 + MEMORY.md + `feedback_option_phrasing.md` to the AskUserQuestion model.

## Completed

- [x] [FEED-U2] discovery-rendering unit — built, 5 gates green (6643 tests), browser-verified, committed (code 9379a85a)
- [x] [QLINT-TRIAL] decided → dropped QLINT entirely; prose/memory rewritten to "route all decisions (incl. yes/no) through AskUserQuestion"

## Remaining

**Feed group (canonical plan: `plan/home-feed-merge/REASSEMBLY-CONV271.md`; U2 done → U3 next):**
- [ ] [FEED-U3] #2 [Opus] — promotion system (U3a substrate: schema+cron+dials+announcement · U3b entity-promo · U3c admin · U3d PromoteNudge LAST). **NEXT.**
- [ ] [SYS-NAMING] #3 — owner-based feed naming (display strings only per reassembly plan; decide rollout scope)
- [ ] [PROMOTE-IDEMP] #4 · [API-DISC-DOC] #5 · [SYS-GET-GATE] #6 — independent cleanups
- [ ] [COMM-TAG-FILTER] #7 · [SUCCESS-COMMUNITY-VERIFY] #8 — PARKED (needs-spec)

**Other backlog:**
- [ ] [ROLE-STUDIOS] #9 [Opus] (⛔ BLOCKED BY CLIENT) · [RTMIG-4] #10 [Opus] · [SSR-LOADER-DEAD] #11 · [CT-RESTYLE] #12 · [PRIM-MATCH-INDEX] #13 · [TXTBTN] #14 · [PROFILE-PRIM-SWEEP] #15 (PAUSED)
- [ ] [ICN-NS] #16 · [E2E-MIG] #17 · [E2E-GATE] #18 · [SHOWMORE] #19 · [PREFLIP-WT] #20 (KEEP until client-vet)
- [ ] [TZ-AUDIT] #21 [Opus] · [MEM-CAP] #22 (MEMORY.md ~89% → /r-prune-memory) · [DOCGEN-SPEC] #23 · [OLD-PORTED-CLEANUP] #24
- [ ] [LEARN-ISLAND-RESTYLE] #25 · [CREATE-ISLAND-RESTYLE] #26 · [TEACH-ISLAND-RESTYLE] #27 · [TRIAGE-RESTYLE] #28
- [ ] [V217-WATCH] #29 · [COURSEDETAIL-DEAD] #30 · [NUDGE-CACHE-FLASH] #31 · [NUDGE-TC-V2] #32 · [TW-V4] #33 (incl. StickySignupBar.astro `backdrop-blur-sm`, SuggestionCard.tsx `flex-shrink-0`) · [TEST-FILE-COUNT] #34 · [PLAN-RENUM] #35
- [ ] [COMMONS-DATE] #36 — fixed early founding date for comm-the-commons in dev seed
- [ ] [DISCCARD-DEL] #38 — delete orphaned DiscoveryCard.tsx after FEED-U2 client-vet

## TodoWrite Items

- [ ] #2 [FEED-U3] [Opus] (next) · #3 [SYS-NAMING] · #4 #5 #6 cleanups · #7 #8 PARKED
- [ ] #9 [ROLE-STUDIOS] [Opus] (BLOCKED) · #10 [RTMIG-4] [Opus] · #11–#20 · #21 [TZ-AUDIT] [Opus] · #22–#36 · #38 [DISCCARD-DEL]

## Key Context

- **QLINT is GONE** — decisions now route through the `AskUserQuestion` tool (reasoning in prose above, picker below; user selects, incl. yes/no). The Stop-hook, its `settings.json` registration, the `.scratch/qlint-off` sentinel, and the calibration harness were all removed this conv. Rule lives in CLAUDE.md §User-Facing-Questions + §Recurring-Failures #1; history in `memory/feedback_option_phrasing.md`. Open-ended free-text questions still use inline `👉👉👉`.
- **FEED-U2 done** — `discoveryContext.anchor` is now on every sample-post (`enrichment.ts fetchDiscoveryAnchors`). `getDiscoveryCandidates` removed; `FeedsHubPanel` deleted; `DiscoveryCard` kept-but-orphaned (→ #38).
- **Baseline verified THIS conv** = full 5-gate green (tsc / astro 0-0-0 / lint / test 389 files 6643 tests / build) after FEED-U2.
- **Local D1 was reseeded on this machine** (MacMiniM4Pro) via `db:setup:local:dev` — discovery rails populated for the browser-verify.
- **MEMORY.md still ~89%** of the SessionStart byte cap → [MEM-CAP] #22 (`/r-prune-memory`).
- Code committed (9379a85a); the QLINT-drop docs changes are committed by this /r-end.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view. **Then start `[FEED-U3]` #2 (U3a backend substrate) — the next feed unit.**
