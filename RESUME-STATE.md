# State — Conv 330 (2026-06-24 ~10:39)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Closed the entire **[RTMIG-RECON] #27** arc (all 6 phases) plus the two follow-ons it spawned. Began at the resume point #27 → #28: minted display/glyph-regime **Family C** (`text-display-micro`) and conformed AvailabilityCalendar ([WS-AVAILCAL] #28). Then Phase 5 backfilled the conformance ledger (3 new sections — RG-COMMS, RG-WORKSPACES studio, Shared primitives cross-group — + 3 derived rows) and re-synced the route-migration README (3 group-notes 🔴→✅). Phase 6 re-checked the 8 confirmed groups: the 6 named cross-cutting primitives are clean, but a pervasive "raw-form-of-token" class surfaced → ruled **enforce** → [WEIGHT-NORM] #30 normalized 11 spots / 8 primitives (zero visual change), and [SHARED-COLOUR] #31 audited shared dirs down to one live fix (ProgressBar). Four commits (code `b4b58893`+`65791c49`, docs `791d04b`+`67e7b6d`); all gates green throughout; both repos clean + pushed at close.

## Completed

- [x] [WS-AVAILCAL] #28 — Family-C micro token mint (`text-display-micro`/`-medium`, §9.2c) + AvailabilityCalendar conformed (6 type + 8 colour spots; sky kept)
- [x] [RTMIG-RECON] #27 — all 6 phases: P5 ledger backfill (3 sections + README re-sync), P6 shared-primitive re-check (8 groups confirmed no longer overstated)
- [x] [WEIGHT-NORM] #30 — 11 raw-form-of-token spots normalized across 8 shared/ui primitives (font-weight→variant, text-[Npx]→size token); zero visual change
- [x] [SHARED-COLOUR] #31 — ProgressBar bg-secondary-100→bg-neutral-100 (audit closed the rest as dead/unswept/legacy)

## Remaining

**Route sweep umbrella + groups:** [RTMIG-4] #1 (in_progress — the route-presentation sweep continues) · [RG-DISCOVER] #2 (PARTIAL 1/3 — /members swept; /feed+/feeds gated on a RETIRE decision) · [RG-ADMIN] #3 (conf OUT) · [RG-PUBLIC] #4 (conf OUT)

**🆕 [RG-SESSION] #29** — triage `/session/[id]` (SessionHistory.tsx + AvailabilityEditor.tsx). ⚠️ The r-end update-plan agent found this OVERLAPS the already-Swept **RG-SESSIONS** `/session/[id]` (Conv 308 covered the SessionRoom island tree but NOT SessionHistory/AvailabilityEditor). Decide: re-open RG-SESSIONS vs treat as a separate surface. Note recorded on the RG-SESSIONS ledger row.

**Cross-cutting / shared:** [XCUT-BACKREF] #5 · [TA-SKEL] #6 (fix skeleton `w-80`/`w-96` → `[80px]`/`[96px]`)

**Conformance foundations:** [PALETTE-FDN] #7 · [SPACING-4PX-SWEEP] #8 · [SWEEP-SPACING-GREP] #9 · [LAYOUT-SG] #10

**Memory system:** [MEM-CAP-ARCH] #11 [Opus] — MEMORY.md fired 81% bytes AGAIN this r-start (20746/25600); architectural fix (do NOT re-prune).

**Process / follow-ups / debt:** [SWEEP-FULLSUITE] #12 (full suite last green 6741/6741 Conv 327; this conv was className/token-only — gated tsc/lint/astro/build) · [VITE-DEDUP] #13 · [PROV-STAMP-GAPS] #14 · [HOME-FIXES] #15 · [COURSES-FIXES] #16 · [E2E-MIG] #17 · [E2E-GATE] #18 · [ICN-NS] #19 · [TZ-AUDIT] #20 [Opus] · [DOCGEN-SPEC] #21 · [V217-WATCH] #22 · [M4-ZGUARD] #23 · [OLD-PORTED-CLEANUP] #24 (now also covers dead UserCardCompact + HomeFeed + FeedsHub-on-/old) · [PREFLIP-WT] #25 · [REVIEW-COUNT-SRC] #26

## TodoWrite Items

- [ ] #1 [RTMIG-4] (in_progress) · #2 [RG-DISCOVER] · #3 [RG-ADMIN] · #4 [RG-PUBLIC] · #5 [XCUT-BACKREF] · #6 [TA-SKEL] · #7 [PALETTE-FDN] · #8 [SPACING-4PX-SWEEP] · #9 [SWEEP-SPACING-GREP] · #10 [LAYOUT-SG] · #11 [MEM-CAP-ARCH] [Opus] · #12 [SWEEP-FULLSUITE] · #13 [VITE-DEDUP] · #14 [PROV-STAMP-GAPS] · #15 [HOME-FIXES] · #16 [COURSES-FIXES] · #17 [E2E-MIG] · #18 [E2E-GATE] · #19 [ICN-NS] · #20 [TZ-AUDIT] [Opus] · #21 [DOCGEN-SPEC] · #22 [V217-WATCH] · #23 [M4-ZGUARD] · #24 [OLD-PORTED-CLEANUP] · #25 [PREFLIP-WT] · #26 [REVIEW-COUNT-SRC] · #29 [RG-SESSION]

(#27 [RTMIG-RECON], #28 [WS-AVAILCAL], #30 [WEIGHT-NORM], #31 [SHARED-COLOUR] COMPLETED this conv.)

## Key Context

- **RTMIG-RECON is fully closed** (all 6 phases). The route-migration **RTMIG-4 umbrella sweep continues** — RTMIG-RECON was the verification/backfill layer, now done. Closure recorded in `plan/route-migration/README.md` (RTMIG-RECON header flipped 🔴 OPEN→✅ CLOSED Conv 330), not COMPLETED.md (sub-task of the active umbrella).
- **Display/glyph regime now has Family C** (`text-display-micro` 10/400 + `-medium` 500, lh 1.0, ls 0) in `tokens-typography.css` + bridge; documented §9.2c. Family A (avatar) + Family C (micro) minted; B (hero numeral) still pending. Verify new display utilities emit via `grep '.text-display-X{' dist/**/*.css` after build.
- **Conformance rulings recorded in migration-ledger Open-decisions:** #4 = raw-form-of-token (font-weight-on-token + text-[Npx]) ENFORCE/normalize. Colour rule: "keep only what has no token home" (sky kept = no info token; red→error, amber→warning have homes). `warning-500`==Tailwind `amber-700` exact; `error-*` = house carmine (Conv 296).
- **🟠 RG-SESSION #29 ↔ RG-SESSIONS overlap** — resolve before sweeping: re-open the Conv-308 Swept claim vs separate surface. SessionHistory.tsx + AvailabilityEditor.tsx are on legacy `secondary-*`/`text-xs`.
- **Dead code confirmed (audit):** `UserCardCompact.tsx` = 0 importers; `HomeFeed.tsx` = only /old/feed.astro; `FeedsHub.tsx` = not on `/` (comment-only), lives on /feed,/feeds (RG-DISCOVER) + /old. → [OLD-PORTED-CLEANUP] / RG-DISCOVER RETIRE.
- **MEMORY.md at 81% bytes** — #11 [MEM-CAP-ARCH] [Opus] is the architectural fix; do NOT re-prune.
- **Commits this conv:** code `b4b58893` (WS-AVAILCAL) + `65791c49` (WEIGHT-NORM+SHARED-COLOUR); docs `791d04b` (Phase 5) + `67e7b6d` (ledger Open-decision) + this end-of-conv bookkeeping commit (Step 6). All pushed. Code gated tsc/lint/astro(1437)/build; full Vitest suite NOT run (className/token-only).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
