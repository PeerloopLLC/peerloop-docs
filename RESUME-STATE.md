# State — Conv 329 (2026-06-23 ~11:41)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Began as `/r-start` (counter 328→329, 27 tasks transferred; reconciled a stale Conv-323 conv-tasks.md 32→27). Most of the conv was an unplanned **cross-machine salvage**: the RTMIG-RECON deep-verify plan was machine-local on M4, and reading it revealed a whole **Conv 328** had run on M4, shipped 4 conformance commits, and never `/r-end`ed (blocked by a persistent Anthropic API 500) — its work stranded on M4 local. Resolved cleanly: M4 pushed the 4 code commits (pulled here) and properly closed its docs (`5341657`+`8cb6186`, pulled via clean FF), preserving the Conv-328 timecard. Then completed **[WS-GLYPHS] #28** (the 5 deferred RG-WORKSPACES glyphs → display-regime/role tokens, commit `99ef1798`, gates green) and reconciled peerloop-docs per the cross-machine hand-off note. Both repos clean + synced at close.

## Completed

- [x] /r-start: counter 328→329, 27 tasks transferred; conv-tasks.md 32→27 reconciliation (6 `/creating`-cluster codes confirmed resolved Convs 323–326)
- [x] Conv-328 cross-machine salvage — diagnosed stranded commits (`git cat-file`), pulled code (`73c5d337`), reconciled docs (FF `8cb6186`); timecard preserved
- [x] [WS-GLYPHS] #28 — 5 deferred glyphs conformed: 3× 40px avatars + count badge → `text-display-avatar-sm`, h4 → `text-body-default-medium`; commit `99ef1798`; tsc/lint/astro 0-0-0(1437)/build green
- [x] peerloop-docs git reconciliation per the `## ⚠️ CROSS-MACHINE CONCURRENCY` hand-off note (discard superseded local RESUME-STATE deletion → FF to `8cb6186`)

## Remaining

**🔴 RTMIG reconciliation (resume here):** [RTMIG-RECON] #27 [Opus] — Phase 4 tail. **Next = #29 [WS-AVAILCAL]** (AvailabilityCalendar + novel Family-C `text-display-micro` mint; **open Q: one ~10px token (snap 9→10) or two 9px+10px?** — resolve at #29 start) → **Phase 5** (re-verify + ledger backfill: new RoleTabBar/CatalogPagination/RG-COMMS-cluster rows + verified-keeps MyFeeds/SessionAnalytics as keep-not-residual + corrected "Conv-310 rounded fixed" header-note re-sync + the WS-GLYPHS rows) → **Phase 6** (re-check the 8 confirmed groups for shared-primitive coverage). Full plan: `.scratch/2026-06-23-rtmig4-reconciliation-deepverify.md` (⚠️ machine-local; lives on M4Pro now).

**New (discovered this conv):**
- [ ] [RG-SESSION] #30 — `/session/[id]` (SessionHistory.tsx + AvailabilityEditor.tsx) appears fully unconformed (legacy `secondary-*`/`text-xs`); likely a SEPARATE unswept route group. Triage which RG-* it belongs to (or its own), then sweep.

**Route sweep umbrella + groups:** [RTMIG-4] #1 (in_progress) · [RG-DISCOVER] #2 (PARTIAL 1/3 — `/members` swept; `/feed`+`/feeds` gated on a RETIRE decision) · [RG-ADMIN] #3 (conf OUT) · [RG-PUBLIC] #4 (conf OUT)

**Deferred glyph follow-on (Conv 328):** [WS-AVAILCAL] #29 [Opus] (above; AvailabilityCalendar Family-C mint)

**Cross-cutting / shared:** [XCUT-BACKREF] #5 · [TA-SKEL] #6

**Conformance foundations:** [PALETTE-FDN] #7 · [SPACING-4PX-SWEEP] #8 · [SWEEP-SPACING-GREP] #9 · [LAYOUT-SG] #10

**Memory system:** [MEM-CAP-ARCH] #11 [Opus] — MEMORY.md fired 81% bytes again this r-start (20746/25600); architectural fix (do NOT re-prune).

**Process / follow-ups / debt:** [SWEEP-FULLSUITE] #12 (last green 6741/6741 Conv 327; this conv's edits className-only, gated tsc/lint/astro/build) · [VITE-DEDUP] #13 · [PROV-STAMP-GAPS] #14 · [HOME-FIXES] #15 · [COURSES-FIXES] #16 · [E2E-MIG] #17 · [E2E-GATE] #18 · [ICN-NS] #19 · [TZ-AUDIT] #20 [Opus] · [DOCGEN-SPEC] #21 · [V217-WATCH] #22 · [M4-ZGUARD] #23 · [OLD-PORTED-CLEANUP] #24 · [PREFLIP-WT] #25 · [REVIEW-COUNT-SRC] #26

## TodoWrite Items

- [ ] #1 [RTMIG-4] (in_progress) · #2 [RG-DISCOVER] · #3 [RG-ADMIN] · #4 [RG-PUBLIC] · #5 [XCUT-BACKREF] · #6 [TA-SKEL] · #7 [PALETTE-FDN] · #8 [SPACING-4PX-SWEEP] · #9 [SWEEP-SPACING-GREP] · #10 [LAYOUT-SG] · #11 [MEM-CAP-ARCH] [Opus] · #12 [SWEEP-FULLSUITE] · #13 [VITE-DEDUP] · #14 [PROV-STAMP-GAPS] · #15 [HOME-FIXES] · #16 [COURSES-FIXES] · #17 [E2E-MIG] · #18 [E2E-GATE] · #19 [ICN-NS] · #20 [TZ-AUDIT] [Opus] · #21 [DOCGEN-SPEC] · #22 [V217-WATCH] · #23 [M4-ZGUARD] · #24 [OLD-PORTED-CLEANUP] · #25 [PREFLIP-WT] · #26 [REVIEW-COUNT-SRC] · #27 [RTMIG-RECON] [Opus] (in_progress) · #29 [WS-AVAILCAL] [Opus] · #30 [RG-SESSION]

(#28 [WS-GLYPHS] COMPLETED this conv — commit `99ef1798`.)

## Key Context

- **Resume = [RTMIG-RECON] #27 → #29 [WS-AVAILCAL].** #29 opens with the Family-C `text-display-micro` mint decision (one ~10px token vs two 9/10px). Then Phase 5 (ledger backfill) + Phase 6 (re-check 8 groups). Full findings: `.scratch/2026-06-23-rtmig4-reconciliation-deepverify.md` (machine-local on M4Pro; the M4 copy is the same content).
- **Cross-machine reconciliation is DONE** — Conv 328 fully on origin (code `73c5d337`; docs `8cb6186`). Conv 329 code = `99ef1798` (jfg-dev-14, pushed). No outstanding divergence. The Conv-328 hand-off note in the prior RESUME-STATE has been fully executed and is intentionally dropped from this state.
- **Display-regime conventions confirmed this conv:** inherited-size glyph (no explicit text-size) renders at the **16px** base (body sets no font-size); 16px has no token (sm=14/md=18 gap) → snap to nearest UserAvatar tier (32px→sm, 48px→md), consistency-first. "Ties round up" is **spacing-axis-only** — type doesn't borrow it (40px stayed on `sm` with the Conv-328 32/36px precedent). `UserAvatar.tsx` sizeClasses = canonical circle→token map. `-bold` variants = wt 600 (so `font-bold` 700→600 normalization); `-medium` = 500.
- **🟠 [RG-SESSION] #30:** `/session/[id]` looks unswept (SessionHistory/AvailabilityEditor on legacy `secondary-*`). Triage before assuming it's an RG-WORKSPACES gap.
- **MEMORY.md at 81% bytes** — #11 [MEM-CAP-ARCH] [Opus] is the architectural fix (do NOT re-prune).
- **Commits this conv:** code `99ef1798` (jfg-dev-14, pushed); docs = this end-of-conv bookkeeping commit (Step 6) + the pulled Conv-328 `8cb6186`. Code edits gated tsc/lint/astro/build; full suite NOT run (className-only; last green 6741/6741 Conv 327).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
