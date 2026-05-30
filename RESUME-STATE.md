# State — Conv 219 (2026-05-30 ~16:33)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Resumed Conv 219 after a terminal-render crash (no counter bump). Built the `prim-treewalk` v2 primitive-candidate sensor + the `/w-prim-candidates` skill (deterministic clickable signals + agent-narrated table → `.scratch` report). Did StripeConnect Tier-1 (SkeletonCard `leadingBadge`, new `ErrorRetryCard` pre-primitive, loading/error swaps, purple honest-orphan). Designed + first-ran the **JFG annotation protocol**. Adopted the **Tier-1/Tier-2 page-conversion strategy** (compose obvious existing primitives now; defer new/extended primitives to a Rule-of-Three pass) — pauses PROFILE-PRIM-SWEEP, with `[PROFILE-TIER1]` as the next-conv start. Recovered 22 stranded backlog tasks (crash had emptied TodoWrite) and hardened `/r-start` against recurrence. All six gates green; work uncommitted at save time (committed in Step 6).

## Completed

- [x] prim-treewalk v2 (3 stacking signals; HOLES→candidates reframe) + narrowed strong/weak report
- [x] `/w-prim-candidates` skill + `.scratch/prim-candidates-<slug>.md` output (overwrites on re-run)
- [x] StripeConnect Tier-1: SkeletonCard `leadingBadge` + `ErrorRetryCard` pre-primitive + loading/error swaps + purple orphan marked
- [x] JFG annotation protocol (`.scratch/JFG.md`) + first live run on TopicPicker (resolved A, zero residue)
- [x] Tier-1/Tier-2 conversion strategy decided + recorded in PLAN.md
- [x] Recovered 22 stranded tasks; TodoWrite restored to 28; conv-tasks.md refreshed
- [x] `/r-start` crash-survivor restore branch + Step-7.5 no-shrink backstop
- [x] Memory updated (conv-tasks.md crash-restore property); SCRIPTS.md + CLI-QUICKREF.md document prim:treewalk
- [x] Six gates green: tsc 0 · astro check 1294 0/0/0 · lint · prov:sweep · test 6456/6456 · build

## Remaining

- [ ] [PROFILE-TIER1] **START HERE next conv** — Tier-1 styling of the 5 /profile islands (Matt tokens + obvious primitive swaps; defer Tier-2). Order: Notification → Stripe (finish `:271`, browser-verify loading/error) → TopicPicker (level→Select) → Security → Profile. Worklist: `.scratch/prim-candidates-pages-profile-tab.md`.
- [ ] [PRIM-MATCH-INDEX] [Opus] — deterministic per-primitive match index (upgrade path for /w-prim-candidates)
- [ ] [PRIM-DOC] — §12 primitive-definition + pre-primitive note
- [ ] [RTMIG-TIER] — apply Tier-1/Tier-2 strategy across RTMIG-4
- [ ] [PRIM-ORPHAN-ACK] — sensor `@prov-orphan` suppression marker
- [ ] [PROFILE-PRIM-SWEEP] [Opus] — Tier-2 remainder (vetted re-skin + extract shared `<Switch>`); deferred under RTMIG-TIER
- [ ] [TERM-GARBLE] — recurring CC terminal-render garble forces unclean exits (env hazard)
- [ ] (+ standing backlog — see TodoWrite Items below; unchanged this conv)

## TodoWrite Items

- [ ] #1: [PRIM-MATCH-INDEX] Deterministic primitive-match index (upgrade path for /w-prim-candidates) [Opus]
- [ ] #2: [PRIM-DOC] Add primitive-definition note to matt-provenance.md §12 (+ pre-primitive)
- [ ] #3: [PROFILE-TIER1] Tier-1 styling sweep of the /profile settings islands — START NEXT CONV
- [ ] #4: [RTMIG-TIER] Adopt Tier-1/Tier-2 page-conversion strategy for RTMIG-4
- [ ] #5: [PRIM-ORPHAN-ACK] Suppress acknowledged orphans in prim-treewalk
- [ ] #6: [DISC-DROP] Finish discover-page migration Stages 3+4 [Opus]
- [ ] #7: [DISC-RTB-RECONCILE] Reconcile discover role-tabs vs Matt Role-Tab-Bar slot [Opus]
- [ ] #8: [RTMIG-4] Per-page /old→root conversion via Matt-shell loop [Opus]
- [ ] #9: [E2E-MIG] Re-point e2e to new routes incrementally
- [ ] #10: [E2E-GATE] Structural-change tier + goto-target resolver check [Opus]
- [ ] #11: [PREFLIP-WT] Remove pre-flip reference worktree when RTMIG-4 inspection done
- [ ] #12: [MATT-EXEC-PG2] Phase 5 remaining pages (Enroll/Session families + 5 routes) [Opus]
- [ ] #13: [MATT-EXEC-EXT] Phase 6 extrapolation primitives (build lazily per page) [Opus]
- [ ] #14: [RTB] Design the Role Tab Bar component (design-spec doc) [Opus]
- [ ] #15: [ADMIN-REDIRECT-BLANK] Non-admin /admin/* yields blank 200 instead of redirect [Opus]
- [ ] #16: [MMP-PH5] Phase 5 graduation — roll forward ~11 pages via MCP (machine-pinned M4) [Opus]
- [ ] #17: [MATT-EXEC-GRD] Phase 7 doc graduation
- [ ] #18: [SHOWMORE] Show-More affordance for Teachers + Reviews tabs
- [ ] #19: [CH-VARIANTS] CourseHeader Enrolled + Scheduled variants (597:6504 / 685:13240)
- [ ] #20: [ICN-NS] 204-file legacy→MattIcon convergence
- [ ] #21: [HOWTOREG-ICN] How-to-register-icon doc
- [ ] #22: [ASSET-SWEEP-GATE] Figma-URL grep guard as /w-codecheck Check 9
- [ ] #23: [MFRD-LOOKUP] Matt frames-ready-for-dev lookup
- [ ] #24: [TXTBTN] Watch — TextButton primitive if 3+ inline-text-button instances appear in Phase 5
- [ ] #25: [SETTINGS-WATCHER] Investigate external rewriter of .claude/settings.local.json on M4Pro
- [ ] #26: [PROFILE-PRIM-SWEEP] Re-skin /profile/* legacy settings islands to vetted primitives [Opus]
- [ ] #27: [PRIM-COURSES-DISMISS] /courses "Dismiss recommendations" button is unvetted (uncovered interactive)
- [ ] #28: [TERM-GARBLE] Recurring CC terminal-render garbling forces unclean exits

## Key Context

- **Next-conv start = [PROFILE-TIER1]** (Tier-1 only; Tier-2 deferred). The Tier-1/Tier-2 strategy ([RTMIG-TIER]) governs all RTMIG-4 conversion now.
- **Tier-1** = Matt shell + SubNavbar + Matt tokens + OBVIOUS existing-primitive swaps + 404-honest routing (do per page). **Tier-2** = extract new / extend existing primitives, only on Rule-of-Three evidence (deferred consolidation pass). The `prim-treewalk` sensor + `.scratch/prim-candidates-*.md` reports are the deferral's candidate memory.
- **JFG protocol** (`.scratch/JFG.md`): user annotates `/* JFG: <lines> | <act|discuss> | intent */` in source; CC acts + strips/promotes; a JFG command never survives into a commit. First run succeeded.
- **Pre-primitive tier**: ErrorRetryCard composes vetted primitives (FormBanner+Button), carries no `data-prov` stamp, inlines card chrome (Card is Astro-only, can't be used in React islands). `_pending/` is the quarantine folder for not-sure extractions.
- **StripeConnect open**: `:271` dark Action CTA → Button (pending); browser-verify the new loading (SkeletonCard) + error (ErrorRetryCard) states — both folded into [PROFILE-TIER1].
- **Crash-recovery lesson**: `.scratch/conv-tasks.md` survives mid-conv and is the restore source if a conv dies before /r-end; resume-without-/r-start should rehydrate TodoWrite from it FIRST. `/r-start` now hardened.
- **Gates** green this conv (test 6456/6456, build clean) — uncommitted at save; committed in Step 6.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
