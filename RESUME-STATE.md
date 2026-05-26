# State — Conv 194 (2026-05-25 ~21:37)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

NAV-RETROFIT continuation + course-tab visual verification, demo-prep. Deleted dead MoreSlidePanel (the [MSP-COUPLING] task was a phantom — file was orphaned, superseded by UserAccountDropdown, zero feature loss). Verified both navbars logged-in ([LH-VERIFY]: AppNavbar as Guy, AdminNavbar as Brian — 220px rails, MattIcons, 0 dashed). Audited course-tab cluster: [ENTITY-VIS-AUDIT] clean, [MATT-ICON-SWAP] inline-SVG goal met, [CRS-MOBILE] tabs fine. Found and FIXED [MPB] — AppNavbar slide-out panels bleed over content below lg (closed-state was only occluded by the rail; fixed with inline off-viewport transform). Found but did NOT fix [ADMIN-REDIRECT-BLANK] — non-admin gets blank /admin/* instead of redirect.

## Completed

- [x] [MSP-COUPLING] — resolved by deleting dead MoreSlidePanel.tsx (+ barrel export, AppLayout comment, 256px→220px drift)
- [x] [LH-VERIFY] — both navbars DOM+visually verified (AppNavbar/Guy + AdminNavbar/Brian)
- [x] [ENTITY-VIS-AUDIT] — course Overview + Teachers clean (hero contrast flags were gradient false-positives)
- [x] [MATT-ICON-SWAP] — inline-SVG goal met; live-hero→MattIcon residual folded into #4
- [x] [CRS-MOBILE] — course SubNav + tabs verified fine at mobile (no overflow/clip/wrap)
- [x] [MPB] — AppNavbar slide-out panel bleed below lg FIXED (inline `translateX(calc(-100% - 220px))` in DiscoverSlidePanel + UserAccountDropdown)

## Remaining

**Carried, Opus-tagged:**
- [ ] [DISC-UNIFY] Migrate /discover/courses onto fetchCourseBrowseData (add primary_topic_id to loader) [Opus]
- [ ] [NAV-APP-A] Approach-A component swap — replace legacy AppNavbar with Matt Sidebar [Opus]
- [ ] [MATT-EXEC-PG2] Matt exec page 2 — Enroll/Session families [Opus]
- [ ] [MATT-EXEC-EXT] Phase 6 responsive/mobile-drawer + live-hero→MattIcon residual [Opus]
- [ ] [RTB] Role Tab Bar design [Opus]
- [ ] [ADMIN-REDIRECT-BLANK] Non-admin hitting /admin/* gets blank 15-byte page instead of redirect to '/'. Unauth → clean 302; authed non-admin (Guy, is_admin=0) → AdminLayout L37 `Astro.redirect('/')` yields blank 200. Mechanism unexplained (don't guess — dep-cache hypothesis already falsified). Likely fix: move admin guard to middleware. [Opus]

**Matt / MMP blocks:**
- [ ] [MMP-PH5] roll-forward — re-render remaining 11 Phase-5 pages via Figma MCP
- [ ] [MATT-EXEC-GRD] Matt exec graduation
- [ ] [MMP-PH3] Verify status (PLAN marks complete Conv 185, likely stale)

**Course-tab (build/deferred):**
- [ ] [SHOWMORE] Show-More affordance for Teachers/Reviews/Feed (build; confirmed absent on Teachers, matches spec)
- [ ] [CH-VARIANTS] CourseHeader Enrolled (597:6504) + Scheduled (685:13240) variants (Figma build, enrolled-state)

**Harvests / tooling / watches:**
- [ ] [HOWTOREG-ICN] / [PLAY-CIRCLE-ICN] / [ASSET-SWEEP-GATE] / [FIGMA-MCP-DOC-HARVEST] / [MFRD-LOOKUP] / [ESOT-STRUCTURE] / [BROWSER-FALLBACK] / [TXTBTN] / [MEM-CAP-WATCH] (MEMORY.md ~81% byte cap) / [MCFRAME] / [ICN-NS]
- [ ] [RA-STALE] Drop MoreSlidePanel from role-audit-2026-04-15.md on next refresh (dated snapshot, low priority)

## TodoWrite Items

- [ ] #1 [DISC-UNIFY] [Opus] / #2 [NAV-APP-A] [Opus] / #3 [MATT-EXEC-PG2] [Opus] / #4 [MATT-EXEC-EXT] [Opus] / #5 [RTB] [Opus]
- [ ] #6 [MMP-PH5] / #7 [MATT-EXEC-GRD] / #8 [MMP-PH3]
- [ ] #10 [SHOWMORE] / #12 [CH-VARIANTS]
- [ ] #15 [HOWTOREG-ICN] / #16 [PLAY-CIRCLE-ICN] / #17 [ASSET-SWEEP-GATE] / #18 [FIGMA-MCP-DOC-HARVEST] / #19 [MFRD-LOOKUP] / #20 [ESOT-STRUCTURE] / #21 [BROWSER-FALLBACK] / #22 [TXTBTN]
- [ ] #24 [MEM-CAP-WATCH] / #25 [MCFRAME] / #26 [ICN-NS] / #27 [ADMIN-REDIRECT-BLANK] [Opus] / #29 [RA-STALE]

## Key Context

- **[MPB] fix pattern (NEW):** closed slide-panels now hide via inline `style={{ transform: isOpen ? 'translateX(0)' : 'translateX(calc(-100% - 220px))' }}` — clears own width + the 220px left anchor, viewport-independent, survives Astro View-Transition swaps (arbitrary translate classes get dropped). In DiscoverSlidePanel.tsx + UserAccountDropdown.tsx. Documented as VT-pitfall #4 in DEVELOPMENT-GUIDE.md.
- **Latent-bug lesson:** an element "hidden" only by being occluded behind another (the 220px rail) breaks the moment the cover moves (responsive). Hide states must be self-sufficiently off-viewport.
- **[ADMIN-REDIRECT-BLANK] context:** /matt/ is a separate full-document layout (matt/AppLayout.astro, Sidebar) — NOT shared with legacy AppLayout (AppNavbar). View-Transition swap correctly removes legacy nav (instrumented 181 frames, 0 leak). The bug is purely the legacy AdminLayout guard's non-admin redirect.
- **Browser rig caveat:** Chrome macOS clamps min window width to ~500px — true phone width (375/390) not reachable via resize. <640 (sm) still engages mobile rules.
- **Local admin accounts:** brian@peerloop.com (Brian) + admin@peerloop.com (Admin), both is_admin=1. Guy Rymberg (guy-rymberg) is_admin=0 (student/teacher/creator).
- Commits land in /r-end Step 6 (this state written pre-commit). Code branch jfg-dev-13-matt.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
