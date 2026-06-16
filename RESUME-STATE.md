# State — Conv 289 (2026-06-15 ~20:13)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

LAYOUT-SG conv. Shipped the margin-jar fix (AppLayout 1248 shell cap + centering; ListingShell utility panel moved right→left per client **Q2=LEFT**; `/courses` → H1) — DOM-verified content=964px exact, `/courses` + `/course/[slug]` now pixel-identical. Then ran a read-only Figma **layout-extraction pass** locking the foundation spec (`08-layout-and-margins.md` §8.3.3: floating-pill geometry 353/345/498-6icon, hero full-bleed-top rule, mobile-bg correction to white) + `md:px-32` tablet padding. Two **strategic decisions** landed and were recorded (decision-log + memory): **Matt's Figma is now LAYOUT-ONLY** (no more page-frame ports; CC owns page consistency); **tablet = wider-mobile**. The layout foundation is now locked — page conversion (RTMIG-4, Tier-1/Tier-2) builds on it next.

## Completed

- [x] [LAYOUT-SG] Q2=left recorded + jar fix (1248 cap, filters left, /courses H1) — DOM-verified, committed `bdb50b83`/`ffe6c9c`
- [x] [LAYOUT-SG] Figma layout-extraction pass: pill geometry, hero full-bleed-top rule, mobile-bg correction (white)
- [x] [LAYOUT-SG] md:px-32 tablet padding — committed `b13c2b55`/`1f3a2e9`
- [x] [LAYOUT-SG] §8.3.3 foundation spec locked
- [x] Strategic decisions → decision-log.md + memory `project_matt_phaseout_inspired_default` + MEMORY.md

## Remaining

- [ ] [LAYOUT-SG] Foundation residuals (deal-with-as-they-come): md pill icon-spacing 238→498; course-detail hero → entity-header slot (full-bleed top, @matt-source CourseHeader variant logic); §8.5.4 rhythm tokens; §8.5.5 hero-slot abstraction; right-panel→left slot rename
- [ ] [RTMIG-4] [Opus] — port ~89 legacy /old/* → root (Tier-1/Tier-2) on the now-locked layout foundation; **next phase**
- [ ] [ROLE-STUDIOS] [Opus] — ⛔ BLOCKED BY CLIENT (old-vs-new dashboard sign-off)
- [ ] [E2E-MIG] — residual ~45 UI-structure-drift failures; [E2E-GATE] transitively blocked
- [ ] [TZ-AUDIT] [Opus] · [DOCGEN-SPEC] · [OLD-PORTED-CLEANUP] (delete 44 ported /old copies)
- [ ] Profile cluster PAUSED: [SSR-LOADER-DEAD] [CT-RESTYLE] [PRIM-MATCH-INDEX] [TXTBTN] [PROFILE-PRIM-SWEEP]
- [ ] Island restyles: [LEARN-ISLAND-RESTYLE] [CREATE-ISLAND-RESTYLE] [TEACH-ISLAND-RESTYLE] [TRIAGE-RESTYLE]
- [ ] Held until client-vet: [ICN-NS] [SHOWMORE] [PREFLIP-WT]
- [ ] Bugs/misc: [COURSEDETAIL-DEAD] [NUDGE-CACHE-FLASH] [COMMONS-DATE] [DISCCARD-DEL] [FEED-LANE-RENDER] [STREAM-PURGE] [COMM-TAG-FILTER] [V217-WATCH]
- [ ] [MEM-PRUNE] — MEMORY.md at 80% of SessionStart auto-load cap; run /r-prune-memory

## TodoWrite Items

- [ ] #1 [COMM-TAG-FILTER] · #2 [ROLE-STUDIOS] [Opus] · #3 [RTMIG-4] [Opus] · #4 [SSR-LOADER-DEAD] · #5 [CT-RESTYLE] · #6 [PRIM-MATCH-INDEX] · #7 [TXTBTN] · #8 [PROFILE-PRIM-SWEEP] · #9 [ICN-NS] · #10 [E2E-MIG] · #11 [E2E-GATE] · #12 [SHOWMORE] · #13 [PREFLIP-WT] · #14 [TZ-AUDIT] [Opus] · #15 [DOCGEN-SPEC] · #16 [OLD-PORTED-CLEANUP] · #17 [LEARN-ISLAND-RESTYLE] · #18 [CREATE-ISLAND-RESTYLE] · #19 [TEACH-ISLAND-RESTYLE] · #20 [TRIAGE-RESTYLE] · #21 [V217-WATCH] · #22 [COURSEDETAIL-DEAD] · #23 [NUDGE-CACHE-FLASH] · #24 [COMMONS-DATE] · #25 [DISCCARD-DEL] · #26 [FEED-LANE-RENDER] · #27 [STREAM-PURGE] · #28 [MEM-PRUNE] · #29 [LAYOUT-SG] (foundation residuals; [Opus] stripped this conv)

## Key Context

- **Layout foundation is LOCKED** (spec: `docs/as-designed/matt-design-system/08-layout-and-margins.md`, esp. §8.3.3 + §8.5). Desktop: 1248 shell cap + centering, 964 content, white card on grey, left SubNav, **hero full-bleed across full card width at top, SubNav+content row below**. Mobile/tablet: white bg (NOT grey — grey is desktop-shell-only), padding 16/16/32 (base/sm/md), centered floating pills (Header Bar 353×44, Mobile Nav 345; md Nav Bar 498/6-icon). Tablet (md) = wider-mobile.
- **Matt's Figma = LAYOUT-ONLY** now (Conv 289 decision, decision-log.md). No more porting Matt *page* frames; CC owns page consistency with Matt's layout system + tokens. Sole exception: mobile treatment (novel, Matt-framed). The no-`/old/*`-function-loss floor + legacy=behavior-truth rules still hold.
- **Next phase = page conversion (RTMIG-4)** on the locked foundation, via Tier-1 (Matt shell + left SubNavbar + tokens + existing-primitive swaps; sections→subnav items) → Tier-2 (exact Matt styling). Canonical Tier def: `docs/decisions/11-new-routing.md` §Tier-1/Tier-2.
- **Course-detail hero deviation** (per-page, tracked): the live `/course/[slug]` renders the `@matt-source` CourseHeader hero inset in the content column (x=623), but Matt's spec is full-bleed-top in the `entity-header` slot. Has variant logic (Default/Enrolled/Scheduled + viewer-local time) — careful per-page fix.
- **Baseline:** this conv's code commits passed all 5 gates (tsc/astro-check 0-0-0/lint/tailwind/build) — verified this conv. No test-suite run (changes were CSS-layout only).
- Code repo CLEAN at conv close (all 4 Conv-289 commits done before /r-end); docs repo committed by /r-end.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
