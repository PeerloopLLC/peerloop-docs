# State — Conv 327 (2026-06-23 ~08:06)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Began as `/r-start` (counter 326→327, 27 tasks transferred) and ran **[RTMIG-RECON] Phase 3 + start of Phase 4**. Phase 3 (shared primitives) is **complete**: resolved the UserAvatar Conv-316-vs-Conv-326 SoT contradiction by **minting a new display/glyph type regime** (§9.2c, `text-display-avatar-*`) rather than preserving an ad-hoc exception — then conformed PromoteButton (+ fixed a 4px icon-shrink bug), form/Input·Select·Textarea, ui/Modal, and FunnelChart. Full suite 6741/6741 + all 5 gates green; committed `93e27e34` (code) / `e7e11d5` (docs). Phase 4 (route-owned) **started**: conformed the RG-COMMS community-detail cluster (3 tabs + `[...tab].astro`) radii and corrected the integrity-item false "Conv-310 rounded fixed" header notes in-file; committed `ac8b6765`. Stopped after the community cluster.

## Completed

- [x] /r-start: counter 326→327, 27 tasks transferred, trackers seeded
- [x] [RTMIG-RECON] **Phase 3 COMPLETE** — UserAvatar (display-regime mint §9.2c), PromoteButton (3-axis + 4px icon-shrink fix), form/Input·Select·Textarea, ui/Modal, FunnelChart; suite 6741/6741; commits `93e27e34`/`e7e11d5`
- [x] Minted display/glyph type regime §9.2c (Family A `text-display-avatar-{xs..xl}`) + documented home for B/C/D
- [x] [RTMIG-RECON] **Phase 4 (partial)** — RG-COMMS community-detail cluster radii + 3 in-file integrity-note corrections; commit `ac8b6765`
- [x] Routed display-regime decision to `docs/decisions/05-ui-ux-components.md` (+ log + INDEX) + TIMELINE

## Remaining

**Route sweep umbrella + groups:** [RTMIG-4] #1 (in_progress) · [RG-DISCOVER] #2 (PARTIAL 1/3 — `/members` swept; `/feed`+`/feeds` gated on a RETIRE decision) · [RG-ADMIN] #3 (conf OUT) · [RG-PUBLIC] #4 (conf OUT)

**🔴 RTMIG reconciliation cleanup:** [RTMIG-RECON] #27 [Opus] — **RESUME HERE = Phase 4 continuation.** Phase 3 done; Phase 4 community cluster done. Next: `RoleTabBar`/`CatalogPagination` (raw font-medium/semibold) → `ListingShell.astro` (`bg-[#eff6ff]` raw hex — needs token-vs-honest-orphan judgment) → RG-WORKSPACES route-owned (`AvailabilityCalendar` red/amber→error/warning + text-[9/10px] + font-weight; `MyFeeds` blue/red palette; `SessionAnalytics` blue/purple stat cards; `EntityPromoComposer` red/green→error/success; ~55 raw font-weight hits in data tables). Then **Phase 5** (re-verify + ledger backfill + README↔ledger re-sync + **re-sync the corrected header notes into ledger/README**) + **Phase 6** (re-check the 8 confirmed groups). Full plan: `.scratch/2026-06-23-rtmig4-reconciliation-deepverify.md`.

**Display-regime follow-on:** Families **B** (hero numeral `text-6xl`→`text-display-numeral`) + **C** (sub-12 micro-badge `text-[10px]`→`text-display-micro`, has a medium-vs-bold weight fork) documented in §9.2c but NOT minted; **D** (icon/emoji glyph) stays on icon `size-*`. Mint B/C when their sweep reaches them.

**Cross-cutting / shared:** [XCUT-BACKREF] #5 · [TA-SKEL] #6

**Conformance foundations:** [PALETTE-FDN] #7 · [SPACING-4PX-SWEEP] #8 · [SWEEP-SPACING-GREP] #9 · [LAYOUT-SG] #10

**Memory system:** [MEM-CAP-ARCH] #11 [Opus] — MEMORY.md fired 81% bytes again this r-start (20746/25600); architectural fix (do NOT re-prune).

**Process / follow-ups / debt:** [SWEEP-FULLSUITE] #12 (last green: 6741/6741 THIS conv) · [VITE-DEDUP] #13 · [PROV-STAMP-GAPS] #14 · [HOME-FIXES] #15 · [COURSES-FIXES] #16 · [E2E-MIG] #17 · [E2E-GATE] #18 · [ICN-NS] #19 · [TZ-AUDIT] #20 [Opus] · [DOCGEN-SPEC] #21 · [V217-WATCH] #22 · [M4-ZGUARD] #23 · [OLD-PORTED-CLEANUP] #24 · [PREFLIP-WT] #25 · [REVIEW-COUNT-SRC] #26

## TodoWrite Items

- [ ] #1 [RTMIG-4] (in_progress) · #2 [RG-DISCOVER] · #3 [RG-ADMIN] · #4 [RG-PUBLIC] · #5 [XCUT-BACKREF] · #6 [TA-SKEL] · #7 [PALETTE-FDN] · #8 [SPACING-4PX-SWEEP] · #9 [SWEEP-SPACING-GREP] · #10 [LAYOUT-SG] · #11 [MEM-CAP-ARCH] [Opus] · #12 [SWEEP-FULLSUITE] · #13 [VITE-DEDUP] · #14 [PROV-STAMP-GAPS] · #15 [HOME-FIXES] · #16 [COURSES-FIXES] · #17 [E2E-MIG] · #18 [E2E-GATE] · #19 [ICN-NS] · #20 [TZ-AUDIT] [Opus] · #21 [DOCGEN-SPEC] · #22 [V217-WATCH] · #23 [M4-ZGUARD] · #24 [OLD-PORTED-CLEANUP] · #25 [PREFLIP-WT] · #26 [REVIEW-COUNT-SRC] · #27 [RTMIG-RECON] [Opus] (in_progress)

## Key Context

- **Resume = [RTMIG-RECON] #27 Phase 4 continuation.** Order: RoleTabBar/CatalogPagination (font-weight) → ListingShell hex judgment → RG-WORKSPACES route-owned → Phase 5 (ledger backfill + README↔ledger re-sync incl. the header-note corrections) → Phase 6 (re-check 8 groups). Full findings + phased plan: `.scratch/2026-06-23-rtmig4-reconciliation-deepverify.md`. Agent IDs (resumable): RG-COMMS a183f0b1cb97a221e · /creator a207cef72d950e211 · teaching ac3c68c65c2869bb5 · creating a2a4294af29af2765.
- **New: display/glyph type regime (§9.2c in `09-typography.md`).** Third regime beyond §9.1's dense/prose. Family A `text-display-avatar-{xs,sm,md,lg,xl}` (12/14/18/24/30px, wt 600, lh 1.0) minted in `tokens-typography.css` + bridge; applied inside UserAvatar (conforms all 15 consumers, no churn). The §9.4 SOP gained a 4th branch (non-prose glyph → §9.2c, never a role token). Weight on a qualifying glyph folds into the token (not a raw-weight violation).
- **brand ramp is sparse {100,300,500}** (brand IS the indigo/violet family; brand-300 = #584DF4). No brand-700 — don't reach for it (inert). indigo→brand by tonal order (see Decisions.md).
- **🔴 NAV-RETROFIT bridge-shrink still live in unmigrated components:** `w-4 h-4` icons render at 4px. Grep `w-4 h-4` on every Phase-4 file → `size-16`.
- **Integrity items:** #1 (CourseFeed neutral) fixed Conv 326 Phase 1. #2 (community-tab false "rounded fixed" headers) — code fixed + in-file notes corrected Conv 327; **ledger/README note re-sync still owed in Phase 5.**
- **Commits this conv:** code `93e27e34` (Phase 3) + `ac8b6765` (Phase 4) on jfg-dev-14; docs `63ecea2` (start) + `e7e11d5` (Phase 3 docs) + this end-of-conv bookkeeping commit on main. All gated green; **not yet pushed at save time — Step 7 pushes.**
- **MEMORY.md at 81% bytes** — #11 [MEM-CAP-ARCH] [Opus] is the architectural fix (do NOT re-prune).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
