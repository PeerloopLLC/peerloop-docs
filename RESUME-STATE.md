# State — Conv 243 (2026-06-06 ~11:06)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Single-feature conv: closed **[SUCCESS-COMMUNITY]** — the final feature of the CALENDAR2→CH-VARIANTS→SUCCESS-COMMUNITY sequence and the last Matt feature of the enrollment funnel. Built a focused **`MilestoneComposer`** island (`@matt-source 729:15940`) that posts a real enrollment milestone to the course feed via a new shared `postCourseFeed()` helper (also adopted by `MattCourseFeed`), with `CourseEmbedCard` gaining a `showCta` prop. 5 gates green (suite 6458, no regressions), prov:sweep incidentally improved 6→4. Two follow-ups surfaced: a route-map scanner blind-spot (`[APIMAP-LIB-BLIND]`) and the deferred browser-verification (`[SUCCESS-COMMUNITY-VERIFY]`).

## Completed

- [x] [SUCCESS-COMMUNITY] — `MilestoneComposer` island (`@matt-source 729:15940`); real post to course feed via new shared `src/lib/feeds.ts` `postCourseFeed()` (MattCourseFeed refactored onto it); `CourseEmbedCard` `showCta` (default true); wired into `success.astro` (built `courseEmbed`+`currentUser`, replaced placeholder). Finishes the Matt enrollment funnel.
- [x] prov:sweep 6→4 — `gen:registries` registered MilestoneComposer AND self-healed stale PrecheckoutContent entry.

## Remaining

Carried backlog (largely unchanged) + 2 new spinoffs this conv ([APIMAP-LIB-BLIND] #45, [SUCCESS-COMMUNITY-VERIFY] #46). The funnel-feature sequence is now COMPLETE — next focus is open (route-migration strategy [RTMIG-TIER] or the 5 remaining Phase-5 routes [MATT-EXEC-PG2] are the natural large blocks).

- [ ] [COMM-TAG-FILTER] [Opus] · [CT-RESTYLE] · [COMM-LEAVE] · [MOD-TOGGLE]
- [ ] [MATT-EXEC-PG2] [Opus] Phase 5 remaining pages (~5 routes: /matt, /login, /teacher/[handle], /teacher/[handle]/schedule, /certification/[id]) · [MATT-EXEC-EXT] · [MMP-PH5] · [MATT-EXEC-GRD]
- [ ] [MFRD-LOOKUP] · [PRECHECKOUT-MATT-CONFIRM] · [ENROLL-NAV-MATT-CONFIRM]
- [ ] [RTMIG-TIER] [Opus] · [RTMIG-4] [Opus] port ~89 /old/* pages
- [ ] [PRIM-MATCH-INDEX] · [PRIM-DOC] · [PRIM-ORPHAN-ACK] · [TXTBTN] · [PROFILE-PRIM-SWEEP] (PAUSED) · [PRIM-COURSES-DISMISS]
- [ ] [ICN-NS] [Opus] · [HOWTOREG-ICN] · [ASSET-SWEEP-GATE]
- [ ] [E2E-MIG] · [E2E-GATE]
- [ ] [SHOWMORE] · [SELECT-AUDIT]
- [ ] [ADMIN-REDIRECT-BLANK] [Opus] · [SETTINGS-WATCHER] · [BAK-ARTIFACT]
- [ ] [PREFLIP-WT] · [REND-DEDUP-GUARD] · [MEM-CAP] (run /r-prune-memory) · [GARBLE-WATCH]
- [ ] [API-USERS-DRIFT] · [DOCS-ROUTES-STALE] · [PREPLAN-CHECKOUT-NOTE]
- [ ] [HOME-FEEDSHUB-VIS] · [DOM-FIRST]
- [ ] [PROV-SWEEP-DEBT] now 4 errors (av-timer/verified icon-provenance + SubNav/MySessionsTab untracked stamps) · [DASH-COURSES-LINK]
- [ ] [STG-SEED] · [OUTLINE-V4]
- [ ] [TZ-AUDIT] [Opus] systematic TZ audit + sensor + policy + gate
- [ ] [APIMAP-LIB-BLIND] route-api-map.mjs scanner blind to @lib/ helper-indirected fetch (NEW this conv)
- [ ] [SUCCESS-COMMUNITY-VERIFY] browser-verify the milestone composer real POST (NEW this conv)

## TodoWrite Items

- [ ] #1: [COMM-TAG-FILTER] [Opus] · #2: [CT-RESTYLE] · #3: [COMM-LEAVE] · #4: [MOD-TOGGLE]
- [ ] #5: [MATT-EXEC-PG2] [Opus] · #6: [MATT-EXEC-EXT] · #7: [MMP-PH5] · #8: [MATT-EXEC-GRD]
- [ ] #10: [MFRD-LOOKUP] · #11: [PRECHECKOUT-MATT-CONFIRM] · #12: [ENROLL-NAV-MATT-CONFIRM]
- [ ] #13: [RTMIG-TIER] [Opus] · #14: [RTMIG-4] [Opus]
- [ ] #15: [PRIM-MATCH-INDEX] · #16: [PRIM-DOC] · #17: [PRIM-ORPHAN-ACK] · #18: [TXTBTN] · #19: [PROFILE-PRIM-SWEEP] · #20: [PRIM-COURSES-DISMISS]
- [ ] #21: [ICN-NS] [Opus] · #22: [HOWTOREG-ICN] · #23: [ASSET-SWEEP-GATE]
- [ ] #24: [E2E-MIG] · #25: [E2E-GATE]
- [ ] #26: [SHOWMORE] · #27: [SELECT-AUDIT]
- [ ] #28: [ADMIN-REDIRECT-BLANK] [Opus] · #29: [SETTINGS-WATCHER] · #30: [BAK-ARTIFACT]
- [ ] #31: [PREFLIP-WT] · #32: [REND-DEDUP-GUARD] · #33: [MEM-CAP] · #34: [GARBLE-WATCH]
- [ ] #35: [API-USERS-DRIFT] · #36: [DOCS-ROUTES-STALE] · #37: [PREPLAN-CHECKOUT-NOTE]
- [ ] #38: [HOME-FEEDSHUB-VIS] · #39: [DOM-FIRST]
- [ ] #40: [PROV-SWEEP-DEBT] (now 4) · #41: [DASH-COURSES-LINK]
- [ ] #42: [STG-SEED] · #43: [OUTLINE-V4]
- [ ] #44: [TZ-AUDIT] [Opus]
- [ ] #45: [APIMAP-LIB-BLIND] · #46: [SUCCESS-COMMUNITY-VERIFY]

## Key Context

- **Funnel fully Matt + composer live:** Course tabs → /precheckout → /success (now incl. MilestoneComposer) → /book → /session/[id] all `@matt-inspired`. The success-page composer posts to the EXISTING `POST /api/feeds/course/[slug]` via the new shared `src/lib/feeds.ts` `postCourseFeed()` — no new endpoint.
- **Component fork resolved (Conv 243):** the plan's "composer-only mode of MattCourseFeed" was superseded — the Figma frame `729:15940` diverges (milestone meta + CTA-less embed), so a focused `MilestoneComposer` was built instead of a mode prop. Shared post logic via `postCourseFeed()`.
- **[APIMAP-LIB-BLIND] #45 root cause:** `route-api-map.mjs:215` skips `@lib/` imports when tracing fetch calls. Refactoring the feed POST into `postCourseFeed()` made the scanner lose the `POST /api/feeds/course/[param]` mapping (still made from MattCourseFeed + MilestoneComposer). Regenerated docs are faithful-to-scanner but now under-report; durable fix is a scanner enhancement. Generated files (route-api-map.md, route-map.generated.ts) NOT hand-patched.
- **[SUCCESS-COMMUNITY-VERIFY] #46:** real POST not browser-verified. To verify: log in as enrolled student → `/course/[slug]/success` directly (no Stripe flow) → post → confirm activity in `/course/[slug]/feed`.
- **Baseline:** 5 gates green at close — tsc/astro/lint 0, suite **6458** (= Conv 242), build clean. prov:sweep **4** (debt, [PROV-SWEEP-DEBT] #40, down from 5).
- **MEMORY.md ~83%** of the 25KB auto-load cap — [MEM-CAP] #33, run /r-prune-memory.
- **Route docs regenerated** both repos this conv (docs agent): page-connections.md captured the new real `/success → /feed` link; route-api-map under-reports per [APIMAP-LIB-BLIND].
- **Governing principle (carried):** Matt is happy-path-only; legacy = functional source of truth, Matt = the skin. See `memory/project_matt_phaseout_inspired_default.md`.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
