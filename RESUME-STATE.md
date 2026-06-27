# State — Conv 339 (2026-06-26 ~21:06)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Cleanup-tail conv that landed two big retirements. **SESSHIST Phase 2** closed: wrote `TeacherSessionsList.test.tsx` (32 tests adapted from the retired 42-case SessionHistory suite — recomputed grouped render-order indices, RecordingLink title→text), browser-verified `/teaching` with real data, then deleted `SessionHistory.tsx`+test (committed `44dc11d2`/`f65eb46`). Then a `/old`-reference **audit** found + deleted an orphaned legacy-shell trio (`LegacyAppLayout`+`AppHeader`). Then, on user directive, **OLD-PORTED-CLEANUP full retirement**: per-page vetted all 74 `/old` pages, **deleted 60 non-marketing pages + 9 coupled components + 1 test, kept the 14 RG-PUBLIC marketing pages**; 5 gates green incl. full suite 6697/6697. The big deletion (75 code files, 8885 deletions) + orphan trio + docs are **uncommitted at this point — committed in Step 6**.

## Completed

- [x] [SESSHIST] #18 Phase 2 — TeacherSessionsList test (32) + browser-verify + delete SessionHistory (919+966 ln). Committed `44dc11d2`/`f65eb46`.
- [x] Orphaned legacy-shell trio deleted (LegacyAppLayout.astro + AppHeader.tsx + barrel export).
- [x] [OLD-PORTED-CLEANUP] #15 — full /old retirement (60 pages + 9 components + 1 test deleted; 14 RG-PUBLIC kept; full suite 6697/6697). Recovery = `git checkout 608346a2 -- <path>`.
- [x] Memory: corrected `project_navigation_architecture`; reversed `project_role_studios_deconstruct_nudges` (dashboard comparison-keep REVOKED — client discarded the combined-roles dashboard).

## Remaining

- [ ] [RTMIG-4] #1 (in_progress) — route-sweep umbrella at its planned stopping point (canonical groups swept; only RG-PUBLIC parked). SoT `plan/route-migration/README.md`.
- [ ] [RG-PUBLIC] #2 — public/marketing route group, parked until the marketing redesign. **Now the explicit `/old` keep-set** (the 14 marketing pages on LandingLayout).
- [ ] [LAYOUT-SG] #3 — `/course/[slug]` hero inset-vs-full-bleed design call.
- [ ] [MEM-CAP-ARCH] #4 [Opus] — MEMORY.md ~85% of the 25 KB SessionStart cap; architectural fix; do NOT re-run /r-prune-memory.
- [ ] [VITE-DEDUP] #5 — durable fix for the Vite SSR "multiple copies of React" cold-start crash (workaround `rm -rf node_modules/.vite`).
- [ ] [HOME-FIXES] #6 · [COURSES-FIXES] #7 — deferred per-route fix buckets.
- [ ] [E2E-MIG] #8 · [E2E-GATE] #9 — migrate E2E tests post-flip + restore the gate. **NEW residual:** the PLATO nav-model (`navigation-helper.ts`/`types.ts`) + instances name the now-deleted `AppNavbar`/`DiscoverSlidePanel` — fold the nav-model rebuild (→ canonical Sidebar) into E2E-MIG.
- [ ] [ICN-NS] #10 — icon-namespace cleanup across the two icon systems + MattIcon registry.
- [ ] [TZ-AUDIT] #11 [Opus] — timezone-correctness audit.
- [ ] [DOCGEN-SPEC] #12 — document the regen binding + r-end Step 5c gate in doc-sync-strategy.md.
- [ ] [V217-WATCH] #13 — watch the [TERM-GARBLE] upstream CC bug.
- [ ] [M4-ZGUARD] #14 — M4-machine z-index/guard follow-up (thin).
- [ ] [PREFLIP-WT] #16 — teardown the preflip worktree. **UNBLOCKED Conv 339** (its precondition — /old cleanup + client-vetting — is met; recovery now rests on commit `608346a2`, not the worktree). Safe on user say-so; not auto-done (consequential + machine-local).
- [ ] [REVIEW-COUNT-SRC] #17 — verify/fix the review-count source (thin).
- [ ] [SWEEP-FULLTEST] #19 — process reminder (satisfied this conv; standing reminder for future broad sweeps).
- [ ] [OLD-DOCS-RECON] #20 — reconcile hand-written driftCheck ROUTE docs (`url-routing.md` §8, `route-stories.md`) that still list deleted /old pages. Generated maps self-clear at r-end Step 5c — do NOT hand-edit.
- [ ] [OLD-DOCS-COMP] #21 — reconcile COMPONENT/architecture driftCheck docs referencing deleted components (`state-management.md` ~125–462 [describes deleted AppNavbar as canonical CurrentUser-init navbar — identify Matt-shell replacement FIRST], `auth-sessions.md:192`, `feeds.md:235`, `_COMPONENTS.md` ~1688–1721, `data-fetching.md:190,194` flag-only).
- [ ] [TEST-FILE-COUNT] #22 — reconcile TEST-COMPONENTS.md grand-total (94 vs 95 header/TEST-COVERAGE); pre-existing, low priority.

## TodoWrite Items

- [ ] #1 [RTMIG-4] (in_progress) · #2 [RG-PUBLIC] · #3 [LAYOUT-SG] · #4 [MEM-CAP-ARCH] [Opus] · #5 [VITE-DEDUP] · #6 [HOME-FIXES] · #7 [COURSES-FIXES] · #8 [E2E-MIG] · #9 [E2E-GATE] · #10 [ICN-NS] · #11 [TZ-AUDIT] [Opus] · #12 [DOCGEN-SPEC] · #13 [V217-WATCH] · #14 [M4-ZGUARD] · #16 [PREFLIP-WT] · #17 [REVIEW-COUNT-SRC] · #19 [SWEEP-FULLTEST] · #20 [OLD-DOCS-RECON] · #21 [OLD-DOCS-COMP] · #22 [TEST-FILE-COUNT]

## Key Context

- **Test baseline GREEN 6697/6697** (full suite, re-verified this conv after the deletion; tsc/astro-check 0-0-0/lint/build also green). The deletions were dead-code/route-endpoint removals — no behavioral regressions.
- **`/old` is now retired to its keep-set:** only the **14 RG-PUBLIC marketing pages** remain under `src/pages/old/` (about, blog, careers, contact, cookies, faq, for-creators, help, how-it-works, pricing, privacy, stories, terms, testimonials), served by `LandingLayout` (NOT the legacy app shell, which was deleted). Their root paths 404 by design until the marketing redesign.
- **Recovery convention:** `git checkout 608346a2 -- <path>` (pre-flip snapshot). PREFLIP-WT worktree is a convenience over the commit; the commit anchor persists after teardown → #16 unblocked.
- **Scope-corrections found during the vet (do not re-trust the old ledger blindly):** `CourseDetail.tsx` is LIVE (real consumer) — NOT deleted; root `/feed`+`/feeds` were already retired Conv 331; the legacy shell (AppNavbar/DiscoverSlidePanel/UserAccountDropdown/layouts-old-AppLayout) fully orphaned only because the kept marketing pages use LandingLayout.
- **Real-importer grep discipline:** use `^\s*import\b[^=]*\bName\b` (import-anchored) — a substring/keyword grep matches prose ("from the legacy AppNavbar") and lies. Check `export … from './X'` barrel re-exports SEPARATELY (an import-anchored grep misses them — the `marketing/welcome/index.ts` re-export slipped past `build` but `tsc`/`astro check` caught it).
- **Two doc-reconciliation follow-ups split by kind:** #20 = route docs (url-routing/route-stories), #21 = component/architecture docs (state-management etc.). Generated route maps auto-clear at r-end Step 5c.
- **Commits this conv:** SESSHIST `44dc11d2` (code) + `f65eb46` (docs); plus this end-of-conv bookkeeping pair (Step 6).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
