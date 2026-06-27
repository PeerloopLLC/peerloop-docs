# State — Conv 340 (2026-06-27 ~10:00)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Cleanup-tail + doc-reconciliation conv following Conv 339's `/old` retirement. Opened with a **full task review** (3 read-only agents): caught and overturned **2 false-CLOSE agent recommendations** (#18, #5 still genuinely pending), closed #1 RTMIG-4 + #16 REVIEW-COUNT-SRC, dropped #14 M4-ZGUARD + #17 SWEEP-FULLTEST → 20→16. Then completed the **doc-reconciliation pair**: **#18 OLD-DOCS-RECON** (url-routing.md 9-area rewrite + route-stories.md /dashboard banner) and **#19 OLD-DOCS-COMP** (5 component/architecture docs reconciled to the deleted AppNavbar/feed-cluster; the r-end docs agent also fixed API-MESSAGES.md). Fixed **#20 TEST-FILE-COUNT** (grand-total 94→95 / 2,473→2,488). Deleted **11 orphaned component files** (#21 UnifiedDashboard subtree minus 4 shared; #22 FeedsHub + FeedDirectoryCard) — **all 5 baseline gates GREEN, 6697/6697**. The **RTMIG-4 route-sweep umbrella is CLOSED** (PLAN ROUTE-MIGRATION → 🟢 SWEEP COMPLETE). Commits land in Step 6.

## Completed

- [x] Full task review — closed #1 RTMIG-4, #16 REVIEW-COUNT-SRC; dropped #14 M4-ZGUARD, #17 SWEEP-FULLTEST; verified-kept #18, #5 against agent false-CLOSEs
- [x] [OLD-DOCS-RECON] #18 — url-routing.md (status banner + §8 + file-tree compressed to 14 marketing pages + Impl-Status + 2 AppNavbar refs + changelog) + route-stories.md /dashboard retirement banner
- [x] [OLD-DOCS-COMP] #19 — state-management.md (AppNavbar→headless CurrentUserInit + Sidebar; AdminNavbar kept), _COMPONENTS.md (feed-cluster tombstone), feeds.md, data-fetching.md, auth-sessions.md
- [x] [TEST-FILE-COUNT] #20 — TEST-COMPONENTS.md grand-total corrected to 95 / 2,488 (reversed an agent miscount)
- [x] [UNIFIED-DASH-RM] #21 — deleted 9 orphaned unified/ files; KEPT 4 shared (PriorityHeader/NeedsAttention/types→TriageStrip, CollapsibleSection→MyFeeds)
- [x] [FEEDSHUB-RM] #22 — deleted FeedsHub.tsx + FeedDirectoryCard.tsx
- [x] Memory: saved alert-disposition rule (feedback_surface_and_track_all_issues + index)
- [x] r-end docs agent fixed API-MESSAGES.md (stale AppNavbar count claims)

## Remaining

- [ ] [RG-PUBLIC] #2 — public/marketing route group, parked until the marketing redesign (the explicit `/old` keep-set: 14 pages on LandingLayout, 404 at root by design)
- [ ] [LAYOUT-SG] #3 — `/course/[slug]` hero inset-vs-full-bleed design call
- [ ] [MEM-CAP-ARCH] #4 [Opus] — MEMORY.md ~85% of the 25 KB SessionStart cap; architectural fix; do NOT re-run /r-prune-memory
- [ ] [VITE-DEDUP] #5 — durable fix for the Vite SSR "multiple copies of React" cold-start crash (workaround `rm -rf node_modules/.vite`). **Verified still pending Conv 340** — the only astro.config fix (commit f94793aa, Conv 177) predates the Conv-322 crash; a real `resolve.dedupe ['react','react-dom']` / ssr config is still needed
- [ ] [HOME-FIXES] #6 · [COURSES-FIXES] #7 — deferred per-route fix buckets
- [ ] [E2E-MIG] #8 · [E2E-GATE] #9 — migrate E2E tests post-flip + restore the gate; folds the PLATO test nav-model rebuild (tests/plato/navigation-helper.ts → canonical Sidebar)
- [ ] [ICN-NS] #10 — icon-namespace cleanup across the two icon systems + MattIcon registry
- [ ] [TZ-AUDIT] #11 [Opus] — timezone-correctness audit
- [ ] [DOCGEN-SPEC] #12 — document the regen binding + r-end Step 5c gate in doc-sync-strategy.md
- [ ] [V217-WATCH] #13 — watch the [TERM-GARBLE] upstream CC bug
- [ ] [PREFLIP-WT] #15 — teardown the preflip worktree (unblocked Conv 339; recovery rests on commit 608346a2; consequential + machine-local, do on user say-so)
- [ ] [ROUTEGEN-NAV] #23 — **NEW Conv 340.** `scripts/route-matrix.mjs` + `scripts/route-api-map.mjs` still hardcode the deleted AppNavbar/DiscoverSlidePanel/UserAccountDropdown nav model → generated route docs (route-api-map.md, page-connections.md, ROUTE-*.tsv, tests/plato/route-map.generated.ts) encode a phantom nav graph. Update generators to the Sidebar model + re-run Step-5c regen. DISTINCT from #8 (PLATO test nav-model)

## TodoWrite Items

- [ ] #2 [RG-PUBLIC] · #3 [LAYOUT-SG] · #4 [MEM-CAP-ARCH] [Opus] · #5 [VITE-DEDUP] · #6 [HOME-FIXES] · #7 [COURSES-FIXES] · #8 [E2E-MIG] · #9 [E2E-GATE] · #10 [ICN-NS] · #11 [TZ-AUDIT] [Opus] · #12 [DOCGEN-SPEC] · #13 [V217-WATCH] · #15 [PREFLIP-WT] · #23 [ROUTEGEN-NAV]

## Key Context

- **Test baseline GREEN 6697/6697** (full suite re-verified this conv after the 11-file deletion; tsc/astro-check 0-0-0/lint/build 6.30s also green). Deletions were dead-code removals — no behavioral regressions, test count unchanged.
- **RTMIG-4 CLOSED Conv 340** — all 13 canonical RG-* groups swept; only **RG-PUBLIC #2** parked (marketing redesign). PLAN.md ROUTE-MIGRATION row = 🟢 SWEEP COMPLETE; detail in `plan/route-migration/README.md` (Conv-340 ledger entry).
- **`/old` is retired to 14 marketing pages** (about, blog, careers, contact, cookies, faq, for-creators, help, how-it-works, pricing, privacy, stories, terms, testimonials) on LandingLayout. Recovery: `git checkout 608346a2 -- <path>`.
- **AppNavbar replacement (for future doc/code work):** the APP shell init was extracted from the deleted AppNavbar into a headless **`CurrentUserInit`** island (`src/components/auth/CurrentUserInit.tsx`, mounted in AppLayout). Visible nav = `Sidebar` (SSR `sidebarUser` prop, persists as `matt-sidebar`). **AdminNavbar is still live** (admin shell still uses navbar-inits). Window-focus refresh was NOT re-wired (version polling covers it); session-expired re-login is modal-only now (accepted simplification).
- **UnifiedDashboard kept-4:** `CollapsibleSection`, `NeedsAttention`, `PriorityHeader`, `types.ts` remain in `src/components/dashboard/unified/` (shared with TriageStrip on Home + MyFeeds). The other 9 are deleted.
- **Process lesson saved:** every 🔴/🟠 alert must carry an explicit disposition (resolved / task#N / your-decision / FYI-only) + owner — no vague "handle at r-end" promises (`feedback_surface_and_track_all_issues`).
- **Agent-reliability data point:** the task-review agents had a ~15% false-CLOSE rate (2 of ~13), both caught by self-verification. Verify agent CLOSE/delete recommendations before acting.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
