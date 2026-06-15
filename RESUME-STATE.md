# State — Conv 284 (2026-06-14 ~19:56)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Client RFC + build conv. Processed a new client directive (single-column "Twitter-style" listings) into **CD-039**, resolved all 6 open questions live with the client, added a tracked **LIST-1COL** block to PLAN.md, then built Phases 1–3 of an 8-phase plan: the `ListingShell.astro` shell primitive + converting `/communities`, `/courses`, and `/members` from card grids to a single centered column + sticky right-panel filters. `/members` required an event-bus refactor (monolithic island → filters + list islands). All DOM/functionally verified; tsc/astro check/eslint green (full suite + build NOT run — owed at Phase 8).

## Completed

- [x] [CD-039] RFC created (original.txt + CD-039.md + RFC.md, 21 items) + INDEX row; all 6 client questions resolved and folded in
- [x] [LIST-1COL] block added to PLAN.md (ACTIVE row + `## LIST-1COL` section, 8 phases + Conv-284 learnings)
- [x] [LIST-1COL] Phase 1 — `ListingShell.astro` primitive + `/communities` pilot
- [x] [LIST-1COL] Phase 2 — `/courses` (CoursesFilters → vertical rail; fixed 44px overflow)
- [x] [LIST-1COL] Phase 3 — `/members` event-bus refactor (MembersFilters + list islands); functionally verified
- [x] [LIST-1COL] ListingShell mobile-reflow fix (filters on top on mobile, not hidden — repaired communities/courses)

## Remaining

- [ ] [LIST-1COL] #35 — **Phases 4–8 remain.** Ph4 `/feeds` (FeedsDiscoveryGrid + FeedAllTab/FeedRoleTab) · Ph5 discover course tabs (Explore*Tab ×5) · Ph6 discover community tabs (Community*Tab ×5) · Ph7 image-frame 16:9 sweep + upload guidance · Ph8 `ListingShell` unit test + full 5-gate codecheck + docs (_COMPONENTS.md, url-routing.md) + check off RFC/INDEX. Recipe + mobile contract + monolith-split pattern in PLAN.md § LIST-1COL learnings.
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

## TodoWrite Items

- [ ] #1–#34 carried-forward backlog (unchanged this conv) · #35 [LIST-1COL] (Phases 1–3 done, Ph4 next)

## Key Context

- **LIST-1COL is mid-block (3 of 6 surfaces).** Resume at **Phase 4 (`/feeds`)**. SoT: PLAN.md § LIST-1COL (8 phases + 5 Conv-284 learnings) + `docs/requirements/rfc/CD-039/RFC.md` (21-item checklist).
- **The shell primitive:** `src/components/layout/ListingShell.astro`. Slots: default = column, `right-panel` = filters/placeholder. Mobile contract: FILLED panels reflow to TOP (`order-1 lg:order-2`); EMPTY placeholder is desktop-only (`hidden lg:block`).
- **Per-surface recipe:** (1) wrap page section in `<ListingShell>`, move filter island into `<Fragment slot="right-panel">`; (2) in the catalog component swap `grid grid-cols-1 … sm:grid-cols-2 xl:grid-cols-3` → `flex flex-col gap-16` and make `<li>` wrappers plain block (drop `className="flex"`); (3) if the filter bar is a wide horizontal row, restructure vertical for the 320px rail.
- **Monolithic-filter surfaces** (filters = internal island state, like /members was) → split into the event-bus two-island pattern: `MembersFilters.tsx` + list, coordinating via `members:filterchange`/`members:clearfilters`; both seed initial state from the same source (`?roles=`) to avoid a mount race; skip the filter island's mount dispatch to avoid double-fetch. Check whether `/feeds` is monolithic before Phase 4.
- **Column idiom:** `min-w-0 lg:flex-1` + inline `max-width:640px` (NOT `w-full` — collapses under `justify-center`). Light-blue panel = `bg-[#eff6ff]`.
- **Images already 16:9** on existing cards (`aspect-video` + `object-cover`); Phase 7 is a consistency sweep across remaining card types.
- **Baseline:** tsc / astro check / eslint green this conv. Full test suite + `npm run build` NOT run — re-verify at Phase 8 before any baseline-green claim. No unit tests reference the changed components (only a generated route-map ref to MembersDirectory).
- Changes committed in Step 6 (this conv) — not yet a separate commit hash at write time.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
