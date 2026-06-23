# State — Conv 326 (2026-06-23 ~06:11)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Started as `/r-start` and became a full **RTMIG-4 reconciliation**. Reconciled the 14 route groups (11 done / 1 partial / 2 not-started), then **deep-verified (4 parallel agents)** the 3 groups missing from the conformance ledger (RG-COMMS, RG-PUBPROF `/creator`, RG-WORKSPACES `/teaching*`+`/creating*`) — found all 3 are **NOT cleanly Swept**: genuine forbidden-token residuals + 2 functional bugs + shared-primitive debt that bleeds into the "8 confirmed" groups. Created **[RTMIG-RECON]** to track the cleanup (horizontal / shared-primitives-first ordering). Executed **Phase 1** (2 functional bugs + a green→success map), committed `92481dff`. Phases 3–6 remain.

## Completed

- [x] /r-start: counter 325→326, 26 tasks transferred, trackers seeded
- [x] RTMIG-4 reconciliation produced (14 groups: 11 done / 1 partial / 2 not-started)
- [x] Ground-truth verification of the 11 "done" groups (@stand-in CLEAN; conformance ledger lags README for 3)
- [x] Deep-verify of the 3 ledger-missing groups (4 parallel agents) → residuals found in all 3
- [x] [RTMIG-RECON] Phase 1 — CourseFeed inert `neutral-400/600`→`500/700`, `bg-surface-raised` no-op→`neutral-100`, TeacherDashboard `green-500`→`success-500`; 5 gates + 84 targeted tests green; committed `92481dff`

## Remaining

**Route sweep umbrella + groups:** [RTMIG-4] #1 (in_progress) · [RG-DISCOVER] #2 (PARTIAL 1/3 — `/members` swept; `/feed`+`/feeds` gated on a RETIRE decision, not sweep work) · [RG-ADMIN] #3 (conf OUT) · [RG-PUBLIC] #4 (conf OUT)

**🔴 RTMIG reconciliation cleanup:** [RTMIG-RECON] #27 [Opus] — **RESUME HERE = Phase 3 (shared primitives).** 3 README-Swept groups have residual conformance debt + 2 integrity items. Full plan: `.scratch/2026-06-23-rtmig4-reconciliation-deepverify.md`.

**Cross-cutting / shared:** [XCUT-BACKREF] #5 · [TA-SKEL] #6

**Conformance foundations:** [PALETTE-FDN] #7 · [SPACING-4PX-SWEEP] #8 · [SWEEP-SPACING-GREP] #9 · [LAYOUT-SG] #10

**Memory system:** [MEM-CAP-ARCH] #11 [Opus] — MEMORY.md fired 81% bytes again this r-start; architectural fix (do NOT re-prune).

**Process / follow-ups / debt:** [SWEEP-FULLSUITE] #12 · [VITE-DEDUP] #13 · [PROV-STAMP-GAPS] #14 · [HOME-FIXES] #15 · [COURSES-FIXES] #16 · [E2E-MIG] #17 · [E2E-GATE] #18 · [ICN-NS] #19 · [TZ-AUDIT] #20 [Opus] · [DOCGEN-SPEC] #21 · [V217-WATCH] #22 · [M4-ZGUARD] #23 · [OLD-PORTED-CLEANUP] #24 · [PREFLIP-WT] #25 · [REVIEW-COUNT-SRC] #26

## TodoWrite Items

- [ ] #1 [RTMIG-4] (in_progress) · #2 [RG-DISCOVER] · #3 [RG-ADMIN] · #4 [RG-PUBLIC] · #5 [XCUT-BACKREF] · #6 [TA-SKEL] · #7 [PALETTE-FDN] · #8 [SPACING-4PX-SWEEP] · #9 [SWEEP-SPACING-GREP] · #10 [LAYOUT-SG] · #11 [MEM-CAP-ARCH] [Opus] · #12 [SWEEP-FULLSUITE] · #13 [VITE-DEDUP] · #14 [PROV-STAMP-GAPS] · #15 [HOME-FIXES] · #16 [COURSES-FIXES] · #17 [E2E-MIG] · #18 [E2E-GATE] · #19 [ICN-NS] · #20 [TZ-AUDIT] [Opus] · #21 [DOCGEN-SPEC] · #22 [V217-WATCH] · #23 [M4-ZGUARD] · #24 [OLD-PORTED-CLEANUP] · #25 [PREFLIP-WT] · #26 [REVIEW-COUNT-SRC] · #27 [RTMIG-RECON] [Opus] (in_progress)

## Key Context

- **Resume = [RTMIG-RECON] #27 Phase 3 (shared primitives).** Full findings + phased plan: `.scratch/2026-06-23-rtmig4-reconciliation-deepverify.md`. Agent IDs (resumable): RG-COMMS a183f0b1cb97a221e · /creator a207cef72d950e211 · teaching ac3c68c65c2869bb5 · creating a2a4294af29af2765.
- **Cleanup ordering DECIDED: horizontal (shared-primitives-first).** Phases: **3** shared primitives (`UserAvatar` [13+ consumers], `form/Input·Select·Textarea`, `ui/Modal`, `PromoteButton` [fully unmigrated], chart primitives) → **4** route-owned residuals per group → **5** re-verify + conformance-ledger backfill + fix false header notes + re-sync README↔ledger → **6** re-check the 8 confirmed groups.
- **Ruling SETTLED:** raw `font-medium`/`font-bold` + `UserAvatar` initials `text-xs/sm/lg` COUNT as conformance violations (in-scope). (Emoji-glyph `text-[Npx]` and chart.js config hex are NOT violations — ledger already sanctions them.)
- **SoT divergence:** the conformance ledger (`plan/typo-fdn/migration-ledger.md`) lags the route-migration README since ~Conv 317 — no rows for RG-COMMS, RG-PUBPROF `/creator`, RG-WORKSPACES `/teaching*`+`/creating*`. Backfill = Phase 5 (deliberately untouched this conv).
- **🔴 Integrity items:** (1) CourseFeed `neutral-400/600` was inert — FIXED Phase 1. (2) `CommunityMembersTab`/`CommunityResourcesTab`/`AddCommunityResourceModal` headers FALSELY claim "rounded fixed Conv 310" but still carry `rounded-lg` — fix code in Phase 4, correct the notes in Phase 5.
- **RG-DISCOVER #2 is PARTIAL (1/3):** `/members` swept; `/feed`+`/feeds` gated on a RETIRE decision (SmartFeed permanent on Home, Conv 291) — open question, deferred.
- **MEMORY.md at 81% bytes** — #11 [MEM-CAP-ARCH] [Opus] is the architectural fix (do NOT re-prune).
- **Commits this conv:** code `92481dff` (Phase 1) on jfg-dev-14; docs `8b05c03` (start) + `45270c4` (RESUME-STATE deletion) + this end-of-conv bookkeeping commit on main.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
