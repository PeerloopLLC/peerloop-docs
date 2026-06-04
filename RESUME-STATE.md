# State — Conv 240 (2026-06-04 ~15:33)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Built **[JOURNEY-LOOP]** — the two-tier course Journey (design locked Conv 239). The course SubNav Journey zone is now **one-time gates** (Enroll ✓ / Payment ✓ / Certificate) bracketing a recurring **Sessions cluster** (`kind:'cluster'`: meter "X/N" via the `@matt-inspired` ProgressBar + indented children My Sessions / Book / Prepare-Join). "My Sessions" moved Explore→Journey; Certificate gates on `completed == total`. **No SQL/schema** — `computeCourseJourney()` already emitted every count. 5 gates green (suite **6459**, +12 `tests/unit/journey-loop-tabs.test.ts`); prov:sweep unchanged at its 6-error debt baseline; browser-verified as David on 3 routes. Also started the dev server + Chrome bridge at the user's request.

## Completed

- [x] [JOURNEY-LOOP] Two-tier course Journey BUILT — `_course-tabs.ts` new `CourseTabNavLink|CourseTabNavCluster` union; `SubNav.astro` cluster render (meter header reusing ProgressBar + indented children) + active-matching walks cluster children; My Sessions removed from Explore. 5 gates green; browser-verified (`/course/[slug]` meter 1/6 fill 17%, `/sessions` + `/session/[id]` active-match). Docs: PLAN.md #26 → BUILT, `plan/enroll-nav/README.md § EVOLVED + BUILT`, `plan/matt/phase-5-pg2.md` reconciled.

## Remaining

Carried-forward backlog (unchanged this conv except Opus re-tagging of #14/#22/#44):
- [ ] [COMM-TAG-FILTER] Build real Commons tag filtering [Opus] · [CT-RESTYLE] · [COMM-LEAVE] · [MOD-TOGGLE]
- [ ] [MATT-EXEC-PG2] Phase 5 remaining pages (~5 routes; /book → CALENDAR2) · [MATT-EXEC-EXT] · [MMP-PH5] · [MATT-EXEC-GRD] · [CH-VARIANTS] · [SUCCESS-COMMUNITY] · [MFRD-LOOKUP] · [PRECHECKOUT-MATT-CONFIRM] · [ENROLL-NAV-MATT-CONFIRM]
- [ ] [RTMIG-TIER] Decide Tier-1/Tier-2 route-migration strategy [Opus] · [RTMIG-4] port ~89 /old/* pages
- [ ] [PRIM-MATCH-INDEX] · [PRIM-DOC] · [PRIM-ORPHAN-ACK] · [TXTBTN] · [PROFILE-PRIM-SWEEP] (PAUSED) · [PRIM-COURSES-DISMISS]
- [ ] [ICN-NS] Icon namespace convergence [Opus] · [HOWTOREG-ICN] · [ASSET-SWEEP-GATE]
- [ ] [E2E-MIG] · [E2E-GATE]
- [ ] [SHOWMORE] · [SELECT-AUDIT]
- [ ] [ADMIN-REDIRECT-BLANK] [Opus] · [SETTINGS-WATCHER] · [BAK-ARTIFACT]
- [ ] [PREFLIP-WT] · [REND-DEDUP-GUARD] · [MEM-CAP] (run /r-prune-memory) · [GARBLE-WATCH]
- [ ] [API-USERS-DRIFT] · [DOCS-ROUTES-STALE] · [PREPLAN-CHECKOUT-NOTE]
- [ ] [HOME-FEEDSHUB-VIS] · [DOM-FIRST]
- [ ] [PROV-SWEEP-DEBT] · [DASH-COURSES-LINK]
- [ ] [CALENDAR2] Matt restyle of booking wizard SessionBooking.tsx (/book stays @stand-in) [Opus]

## TodoWrite Items

- [ ] #1: [COMM-TAG-FILTER] [Opus] · #2: [CT-RESTYLE] · #3: [COMM-LEAVE] · #4: [MOD-TOGGLE]
- [ ] #5: [MATT-EXEC-PG2] · #6: [MATT-EXEC-EXT] · #7: [MMP-PH5] · #8: [MATT-EXEC-GRD] · #9: [CH-VARIANTS] · #10: [SUCCESS-COMMUNITY] · #11: [MFRD-LOOKUP] · #12: [PRECHECKOUT-MATT-CONFIRM] · #13: [ENROLL-NAV-MATT-CONFIRM]
- [ ] #14: [RTMIG-TIER] [Opus] · #15: [RTMIG-4]
- [ ] #16: [PRIM-MATCH-INDEX] · #17: [PRIM-DOC] · #18: [PRIM-ORPHAN-ACK] · #19: [TXTBTN] · #20: [PROFILE-PRIM-SWEEP] · #21: [PRIM-COURSES-DISMISS]
- [ ] #22: [ICN-NS] [Opus] · #23: [HOWTOREG-ICN] · #24: [ASSET-SWEEP-GATE]
- [ ] #25: [E2E-MIG] · #26: [E2E-GATE]
- [ ] #27: [SHOWMORE] · #28: [SELECT-AUDIT]
- [ ] #29: [ADMIN-REDIRECT-BLANK] [Opus] · #30: [SETTINGS-WATCHER] · #31: [BAK-ARTIFACT]
- [ ] #32: [PREFLIP-WT] · #33: [REND-DEDUP-GUARD] · #34: [MEM-CAP] · #35: [GARBLE-WATCH]
- [ ] #36: [API-USERS-DRIFT] · #37: [DOCS-ROUTES-STALE] · #38: [PREPLAN-CHECKOUT-NOTE]
- [ ] #39: [HOME-FEEDSHUB-VIS] · #40: [DOM-FIRST]
- [ ] #41: [PROV-SWEEP-DEBT] · #42: [DASH-COURSES-LINK]
- [ ] #44: [CALENDAR2] [Opus]

## Key Context

- **`/course/[slug]` SubNav is now two-tier.** The model lives in `src/pages/course/[slug]/_course-tabs.ts` (`buildCourseTabs` → `CourseTabNavItem = CourseTabNavLink | CourseTabNavCluster`); the render + active-matching live in `src/components/SubNav.astro` (the cluster branch reuses `ProgressBar` for the meter; the matt-sourced `SubNavItem` row primitive is untouched). 4 callers (`[...tab].astro`, `success.astro`, `book.astro`, `session/[id].astro`) just pass the result into `<SubNav>`.
- **Flat `CourseJourneyState` was kept** (not nested into gates/sessions) — it already carried every count. Deliberate deviation from the literal scope wording, documented in `plan/enroll-nav/README.md`.
- **`/book` dev-render quirk (NOT a regression):** in `npm run dev`, `/book` can drop its whole layout (incl. the rail) due to a pre-existing "more than one copy of React" SSR error from the heavy `SessionBooking client:load` island. Production `npm run build` renders `/book` clean. Resolves when the wizard leaves `@stand-in` in **[CALENDAR2]** (#44). The Book child href was DOM-verified correct.
- **Overlap-dedup deferred to [CALENDAR2]:** the rail Sessions cluster is now the canonical book-hub; the wizard's own "Book Next / all-booked" copy reconciliation is folded into the [CALENDAR2] wizard rewrite (editing the 888-line `@stand-in` now would be throwaway).
- **Route docs regenerated this conv** (both repos — code `tests/plato/route-map.generated.ts` + docs route docs/TSVs); also caught up the latent Conv-239 `/session/[id]` route-map entries. Committed in Step 6.
- prov:sweep still RED at 6 errors ([PROV-SWEEP-DEBT] #41, not in the 5-gate baseline); MEMORY.md at 83% of byte cap ([MEM-CAP] #34 — run /r-prune-memory).
- **Branch state (pre-commit):** code + docs changes committed in Step 6; code on `jfg-dev-13-matt`. Dev server left running on :4321 at the user's request.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
