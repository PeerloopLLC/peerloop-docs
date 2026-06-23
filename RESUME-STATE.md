# State — Conv 328 (2026-06-23 ~09:40)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-14`, docs: `main`

## ⚠️ CROSS-MACHINE CONCURRENCY — READ FIRST (hand-off to Conv 329 / next reconciler)

**What happened:** M4 Conv 328 paused at its `/r-end` checkpoint; while it waited, a new conv (**Conv 329**) was started on **MacMiniM4Pro** and is **LIVE with material changes**. Conv 329's `/r-start` bumped the counter 328→329 (commit `d02abdf`) and **double-loaded the SAME Conv-327 task list (27 tasks)** that this Conv 328 worked from — so Conv 329 is operating **unaware of everything Conv 328 did**.

**This RESUME-STATE is Conv 328's accurate end-state** (the more-current of the two: it knows what's *done* and the new `#28`/`#29`). It was rebased on top of `d02abdf`, so the counter stays **329** (M4Pro's) and this file is the carry-forward base.

**Conv 329 (M4Pro) is the authoritative live session — it owns the reconciliation.** When it closes, the reconciler MUST:
1. **NOT re-do** the RG-COMMS remainder + RG-WORKSPACES font-weight/colour conformance Conv 328 already SHIPPED (code commits `c058d053`, `565bc4b7`, `90e94eb8`, `73c5d337` — already on `origin/jfg-dev-14`). Treat the "## Completed" items below as DONE.
2. **Carry forward the two NEW tasks** `#28 [WS-GLYPHS]` and `#29 [WS-AVAILCAL] [Opus]` (they do not exist in the Conv-327 list Conv 329 loaded).
3. **Merge** Conv 329's own material changes + task progress with the task set below, then write a single reconciled RESUME-STATE.
4. Expect a RESUME-STATE merge conflict on M4Pro's `/r-end` push — pull this version and reconcile rather than overwrite.

## Summary

Ran **[RTMIG-RECON] #27 Phase 4** (the RTMIG-4 route-conformance reconciliation). Conformed the **RG-COMMS route-owned remainder** (RoleTabBar, CatalogPagination, ListingShell/index radii + the `bg-[#eff6ff]` honest-orphan) and the **RG-WORKSPACES font-weight bulk** (58 hits across 7 data tables, each folded into the size-correct type-token weight variant after per-file size verification), plus 2 clean avatar glyphs → display-avatar regime and EntityPromoComposer → semantic colours. MyFeeds + SessionAnalytics ruled **verified-keep** (documented in-code honest-orphans). Two follow-ups deferred to new tasks: **#28 [WS-GLYPHS]** (5 ambiguous glyph/heading hits) and **#29 [WS-AVAILCAL]** (AvailabilityCalendar colour map + novel Family-C `text-display-micro` mint). 5 code commits, all gated tsc/lint/build green. RG-WORKSPACES route-owned now done except #28/#29; then Phase 5 (ledger backfill) + Phase 6 (re-check 8 groups).

## Completed

- [x] /r-start: counter 327→328, 27 tasks transferred, trackers seeded
- [x] [RTMIG-RECON] Phase 4 — RG-COMMS remainder (RoleTabBar/CatalogPagination font-weights, ListingShell/index radii, `bg-[#eff6ff]` honest-orphan documented); commit `c058d053`
- [x] [RTMIG-RECON] Phase 4 — RG-WORKSPACES font-weight bulk, **58 hits / 7 files** (size-correct type-token variants; UA `<th>` bold caveat handled); commit `565bc4b7`
- [x] [RTMIG-RECON] Phase 4 — 2 clean avatar glyphs → `text-display-avatar-sm`; commit `90e94eb8`
- [x] [RTMIG-RECON] Phase 4 — EntityPromoComposer error/success → semantic tokens; MyFeeds + SessionAnalytics verified-keep; commit `73c5d337`
- [x] Updated deepverify scratch plan + plan/route-migration/README.md with Conv-328 Phase-4 progress

## Remaining

**🔴 RTMIG reconciliation (resume here):** [RTMIG-RECON] #27 [Opus] — Phase 4 mostly done. **Next route-owned = #28 + #29**, then **Phase 5** (re-verify + ledger backfill incl. the new RoleTabBar/CatalogPagination/RG-COMMS-cluster rows + the **verified-keeps** (MyFeeds/SessionAnalytics) recorded as keep-not-residual + the corrected "Conv-310 rounded fixed" header-note re-sync) + **Phase 6** (re-check the 8 confirmed groups for shared-primitive coverage). Full log: `.scratch/2026-06-23-rtmig4-reconciliation-deepverify.md`.

**Deferred this conv (new):**
- [ ] [WS-GLYPHS] #28 — 5 RG-WORKSPACES glyph/heading hits: three 40px avatar fallbacks (inherited glyph size, 3 different bg/text styles), a count badge (TeacherPendingActions:40), a size-less `<h4>` (MaterialsFeedbackView:211). Need DOM-verify or a UserAvatar-primitive adoption (visual change).
- [ ] [WS-AVAILCAL] #29 [Opus] — AvailabilityCalendar.tsx: sparse-ramp `red`/`amber`→`error`/`warning` (8 hits) + the **novel Family-C `text-display-micro` token mint** (open Q: one 10px token + snap 9→10, or mint both 9px and 10px?) + leading/weight cleanup. `sky-*` sanctioned (verify-only).

**Route sweep umbrella + groups:** [RTMIG-4] #1 (in_progress) · [RG-DISCOVER] #2 (PARTIAL 1/3 — `/members` swept; `/feed`+`/feeds` gated on a RETIRE decision) · [RG-ADMIN] #3 (conf OUT) · [RG-PUBLIC] #4 (conf OUT)

**Cross-cutting / shared:** [XCUT-BACKREF] #5 · [TA-SKEL] #6

**Conformance foundations:** [PALETTE-FDN] #7 · [SPACING-4PX-SWEEP] #8 · [SWEEP-SPACING-GREP] #9 · [LAYOUT-SG] #10

**Memory system:** [MEM-CAP-ARCH] #11 [Opus] — MEMORY.md fired 81% bytes again this r-start (20746/25600); architectural fix (do NOT re-prune).

**Process / follow-ups / debt:** [SWEEP-FULLSUITE] #12 (last green 6741/6741 Conv 327, NOT re-verified this conv — this conv's edits were className-only, gated tsc/lint/build) · [VITE-DEDUP] #13 · [PROV-STAMP-GAPS] #14 · [HOME-FIXES] #15 · [COURSES-FIXES] #16 · [E2E-MIG] #17 · [E2E-GATE] #18 · [ICN-NS] #19 · [TZ-AUDIT] #20 [Opus] · [DOCGEN-SPEC] #21 · [V217-WATCH] #22 · [M4-ZGUARD] #23 · [OLD-PORTED-CLEANUP] #24 · [PREFLIP-WT] #25 · [REVIEW-COUNT-SRC] #26

## TodoWrite Items

- [ ] #1 [RTMIG-4] (in_progress) · #2 [RG-DISCOVER] · #3 [RG-ADMIN] · #4 [RG-PUBLIC] · #5 [XCUT-BACKREF] · #6 [TA-SKEL] · #7 [PALETTE-FDN] · #8 [SPACING-4PX-SWEEP] · #9 [SWEEP-SPACING-GREP] · #10 [LAYOUT-SG] · #11 [MEM-CAP-ARCH] [Opus] · #12 [SWEEP-FULLSUITE] · #13 [VITE-DEDUP] · #14 [PROV-STAMP-GAPS] · #15 [HOME-FIXES] · #16 [COURSES-FIXES] · #17 [E2E-MIG] · #18 [E2E-GATE] · #19 [ICN-NS] · #20 [TZ-AUDIT] [Opus] · #21 [DOCGEN-SPEC] · #22 [V217-WATCH] · #23 [M4-ZGUARD] · #24 [OLD-PORTED-CLEANUP] · #25 [PREFLIP-WT] · #26 [REVIEW-COUNT-SRC] · #27 [RTMIG-RECON] [Opus] (in_progress) · #28 [WS-GLYPHS] · #29 [WS-AVAILCAL] [Opus]

## Key Context

- **Resume = [RTMIG-RECON] #27 Phase 4 tail.** Order: #29 (AvailabilityCalendar + Family-C mint) → #28 (glyph tail DOM-verify) → Phase 5 (ledger backfill + verified-keeps + header-note re-sync) → Phase 6 (re-check 8 groups). Full findings + phased plan: `.scratch/2026-06-23-rtmig4-reconciliation-deepverify.md`.
- **Conformance conventions confirmed/used this conv:** (1) raw font-weight folds into the type-token weight variant **at the element's actual rendered size** — verify per-file (EarningsDetail=14px ≠ CreatorEarningsDetail=12px twin). (2) `body-*` weight variants hold size/lh constant; `-medium`=500 (exact), `-bold`=600 (so `font-bold` 700→600 normalization). (3) Token must sit **directly on the element** — UA `<th>{font-weight:bold}` beats row inheritance. (4) §9.2c display-avatar regime: only avatars with an explicit current glyph size map cleanly; off-scale/inherited ones are Tier-2 (#28). (5) **Colour keeps exceptions** — documented in-code honest-orphans (MyFeeds notification red, SessionAnalytics blue/purple quartet, `#eff6ff` blue-50 placeholder) are verified-keep, not residuals.
- **Family-C (`text-display-micro`) still NOT minted** — its first real consumer is AvailabilityCalendar's text-[9px]/[10px] badges (#29). Family-A (`text-display-avatar-*`) minted Conv 327, now in use by 2 more files. Family-B (hero numeral) still documented-not-minted.
- **MEMORY.md at 81% bytes** — #11 [MEM-CAP-ARCH] [Opus] is the architectural fix (do NOT re-prune).
- **Commits this conv (code, jfg-dev-14):** `c058d053`, `565bc4b7`, `90e94eb8`, `73c5d337` + the end-of-conv bookkeeping commit (Step 6). Docs (main): `5b3c29e` (counter start), `33ec829` (RESUME-STATE lifecycle delete) + end-of-conv commit. All code edits gated tsc/lint/build green; **full test suite NOT run this conv** (className-only changes; last green 6741/6741 Conv 327).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
