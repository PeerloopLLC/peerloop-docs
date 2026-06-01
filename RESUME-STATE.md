# State — Conv 234 (2026-06-01 ~17:43)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Continued MATT-DESIGN-PUSH Phase 5 by porting the booking route. Read the legacy SoT + probed Matt's Figma frames (discovering Matt has no course-hosted booking page — his scheduler lives on the teacher profile), then shipped a **tactical `@stand-in` rehost** of `/course/[slug]/book` onto the Matt shell (legacy `SessionBooking` wizard untouched) so the enroll→success→book funnel walks end-to-end. Fixed `[TW-GRAD]`. The booking page also gained the course SubNav rail. Surfaced and **spec'd a larger IA redesign — `[ENROLL-NAV]`** (dual-zone course SubNav: Explore tabs + gated enrollment "Journey" zone) to `plan/enroll-nav/README.md`, build deferred. 5 gates green; authed render verified.

## Completed

- [x] /r-start (Conv 234; 37 tasks transferred; conv-tasks.md regenerated; memory synced; MEMORY.md flagged 81% cap → #33)
- [x] [BOOK-ROUTE] #37 — `@stand-in` `/course/[slug]/book` on Matt shell + course SubNav rail; legacy server logic verbatim; 5 gates green; authed render verified (David Rodriguez / intro-to-n8n)
- [x] [TW-GRAD] #39 — `PrecheckoutContent.astro:91` `bg-gradient-to-b`→`bg-linear-to-b`; Tailwind gate clean
- [x] [ENROLL-NAV] #38 — design SPEC complete (`plan/enroll-nav/README.md`); PLAN DEFERRED #25 + STANDIN-MATT #24 note updated
- [x] Route docs regenerated both repos (new `/book`); 1 decision routed to docs/decisions/11-new-routing.md

## Remaining

- [ ] [ENROLL-NAV] #38 — **build** the dual-zone SubNav (spec done; dedicated conv). Make `SubNav.astro` + `_course-tabs.ts` zone- + enrollment-state aware; gate state-machine; flag dual-zone IA + "1:1 Sessions" tab + choose-among-teachers divergences to Matt.
- [ ] [BOOK-ROUTE follow-on] — graduate `/book` `@stand-in → @matt-inspired` when ENROLL-NAV lands (restyle wizard to Matt `622:15671` calendar+suggested-times pattern; lives in CALENDAR/ENROLL-NAV territory).
- [ ] [MEM-CAP] #33 — MEMORY.md at 81% of SessionStart auto-load cap; run `/r-prune-memory` soon.
- [ ] (all other carried tasks below)

## TodoWrite Items

- [ ] #1: [PRIM-MATCH-INDEX] Deterministic per-primitive match index [Opus]
- [ ] #2: [PRIM-DOC] Document primitive-definition + pre-primitive tier (matt-provenance.md §12)
- [ ] #3: [RTMIG-TIER] Adopt Tier-1/Tier-2 page-conversion strategy across RTMIG-4
- [ ] #4: [PRIM-ORPHAN-ACK] @prov-orphan suppression marker for prim-treewalk sensor
- [ ] #5: [RTMIG-4] Port ~89 legacy /old/* pages to root in Matt shell [Opus]
- [ ] #6: [E2E-MIG] Re-point Playwright e2e onto new root routes
- [ ] #7: [E2E-GATE] Structural-change tier + goto-target resolver [Opus]
- [ ] #8: [PREFLIP-WT] Tear down Peerloop-preflip reference worktree + peerloop-ref alias
- [ ] #9: [MATT-EXEC-PG2] Phase 5 remaining pages — Session family + routes [Opus]
- [ ] #10: [MATT-EXEC-EXT] Phase 6 lazy extrapolation primitives [Opus]
- [ ] #11: [ADMIN-REDIRECT-BLANK] Non-admin /admin/* returns blank 15-byte 200 instead of redirect [Opus]
- [ ] #12: [MMP-PH5] Phase 5 graduation — roll forward ~11 pages via Figma MCP [Opus]
- [ ] #13: [MATT-EXEC-GRD] Phase 7 graduate design-system docs at block close
- [ ] #14: [SHOWMORE] Show-More affordance on Teachers + Reviews tabs
- [ ] #15: [CH-VARIANTS] CourseHeader Scheduled variant (Enrolled done Conv 233)
- [ ] #16: [ICN-NS] Converge ~204 legacy icon usages onto MattIcon registry
- [ ] #17: [HOWTOREG-ICN] How-to-register-an-icon doc for MattIcon registry
- [ ] #18: [ASSET-SWEEP-GATE] Figma-URL grep guard as /w-codecheck Check 9
- [ ] #19: [MFRD-LOOKUP] Maintain Matt frames-ready-for-dev lookup
- [ ] #20: [TXTBTN] Extract TextButton primitive on Rule-of-Three
- [ ] #21: [SETTINGS-WATCHER] Find process rewriting settings.local.json on M4Pro
- [ ] #22: [PROFILE-PRIM-SWEEP] Tier-2 remainder of profile sweep (PAUSED) [Opus]
- [ ] #23: [PRIM-COURSES-DISMISS] Vet/primitivize /courses Dismiss button
- [ ] #24: [MW-COMMUNITY-STALE] Stale /community protected-prefix in middleware:45 (no root route yet)
- [ ] #25: [API-USERS-DRIFT] Reconcile /api/members doc block in API-USERS.md
- [ ] #26: [DOM-FIRST] Reinforce dom-truth-first on first visual-bug report
- [ ] #27: [SELECT-AUDIT] Spot-check all Select instances render single caret post-forms-fix
- [ ] #28: [BAK-ARTIFACT] Track down what creates stray .bak files in code repo
- [ ] #29: [DOCS-ROUTES-STALE] Fix stale `npm run docs:routes` reference
- [ ] #30: [GARBLE-WATCH] Re-test TERM-GARBLE when upstream fixes parallel tool-result delivery
- [ ] #31: [HOME-FEEDSHUB-VIS] Visitor/public variant of FeedsHub on `/`
- [ ] #32: [REND-DEDUP-GUARD] r-end Step 2 must dedup scratch notes vs un-compacted history
- [ ] #33: [MEM-CAP] Prune MEMORY.md — at 81% of SessionStart auto-load cap
- [ ] #34: [PRECHECKOUT-MATT-CONFIRM] Run /benefits SubNav-tab addition past Matt
- [ ] #35: [PREPLAN-CHECKOUT-NOTE] Annotate matt-pre-plan.md /checkout placeholder as resolved
- [ ] #36: [SUCCESS-COMMUNITY] Phase 2 success-page milestone composer
- [ ] #38: [ENROLL-NAV] Dual-zone course SubNav — Explore tabs + gated enrollment Journey zone [Opus]

## Key Context

- **`/course/[slug]/book` (`jfg-dev-13-matt`, committed this conv):** NEW `@stand-in` page — legacy server logic ported VERBATIM (auth→enrollment guards, teacher+eligibility queries, redirects) onto Matt `AppLayout`; `noNav`; breadcrumb header-bar; **course SubNav rail** (`<SubNav slot="sub-nav">` + `buildCourseTabs`, `currentPath=""` so no tab false-highlights since `/book` isn't an Explore tab). Renders the UNTOUCHED legacy `SessionBooking` wizard island.
- **ENROLL-NAV spec** (`plan/enroll-nav/README.md`): dual-zone course SubNav. ▲ Explore (browse anytime; +"1:1 Sessions" list tab when enrolled; "Modules" name kept). ▼ Journey (gated funnel Enroll→Payment→Book→Prepare→Complete, always shown). 5 locked decisions: keep one assigned teacher / Modules+1:1Sessions separate / Book = own Journey item targeting /book / Journey always-shown-gated / 1:1Sessions list ABOVE, Book BELOW. Diverges from Matt → flag.
- **Key Figma findings** (`.scratch/book-route-figma-findings.md`, gitignored): `667:12040`="Course Teachers Enrolled" (Teachers tab, not booking); `622:17884`="Session Prepare"; `622:15671`="Teacher Schedule" (real date-picker, creator-side, NOT RFD — reference for the future Matt restyle). Matt has NO course-hosted booking page.
- **Matt rewrite dropped** the enrolled-operational tabs (legacy Sessions/Learn/role views) — ENROLL-NAV re-homes them.
- Dev server running on :4321 (standing). Browser logged in as David Rodriguez (dev-login).
- Changes committed in Step 6 of this r-end (this Key Context is the pre-commit snapshot).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
