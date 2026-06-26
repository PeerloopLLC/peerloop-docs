# State — Conv 338 (2026-06-26 ~19:45)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

RTMIG-4 cleanup-tail conv. Closed **PROV-STAMP-GAPS** (page axis — verified 0 gaps, 46/46 non-legacy pages already marked) and **PROV-COMP-STAMP** (component axis — `prov:sweep` exit 0, the "5 components" claim was a stale PLAN line). Did the **OLD-PORTED-CLEANUP** component slice (deleted 2 genuine orphans HomeFeed + UserCardCompact + barrel/doc cleanup; audit corrected the carried scope: 74 /old pages not 44, FeedAllTab/FeedRoleTab are LIVE) and re-scoped the /old page deletion to a per-page vetting follow-on. Established the **git-history recovery convention** (commit `608346a2`, no archive folder) + a retirement ledger in the route-migration README. Did **SESSHIST Phase 1** — harvested status/date filters + attendance into the live `TeacherSessionsList` (dropped sort/pagination), leaving SessionHistory alive until Phase 2 tests + verifies it. 3 work commits (2 code + 1 docs), all gates green where run.

## Completed

- [x] [PROV-STAMP-GAPS] #6 — VERIFIED 0 gaps (page axis): all 46 non-legacy root pages carry a real top-of-file marker (43 @matt-inspired, 2 @matt-source, 1 @stand-in). Detector gotcha logged: use `grep -oE '@(stand-in|matt-source|matt-inspired)' | head -1` (first token in doc order) — marker names appear in graduation prose.
- [x] [PROV-COMP-STAMP] #21 (created+resolved this r-end) — component axis clean: `npm run prov:sweep` exit 0; PLAN line-22 "5 components" claim stale (registered Convs 226/308); InterestsSettings unmarked = valid state.
- [x] [OLD-PORTED-CLEANUP] component slice — deleted HomeFeed (→SmartFeed) + UserCardCompact (→UserCard) + 2 barrel exports + 5 @see doc-comments; 5 gates green; tombstone code `232e5e2e` + docs ledger `f2a88cf`. Carried scope corrected (74 pages, FeedAllTab/FeedRoleTab LIVE).
- [x] [SESSHIST] #19 Phase 1 — harvested status+date filters (server-side) + per-session expandable detail (info/feedback/attendance) into TeacherSessionsList; reused @components/form/Select; tsc/lint/test 6737/6737 green; commit `0661e596`.
- [x] Fixed stale "44 deletable" memory note (`project_old_pages_no_delete_until_vetted` body + frontmatter + MEMORY.md line).

## Remaining

- [ ] [RTMIG-4] #1 (in_progress) — route-sweep umbrella at its planned stopping point (all canonical groups swept; only RG-PUBLIC parked). SoT `plan/route-migration/README.md`.
- [ ] [RG-PUBLIC] #2 — public/marketing route group, parked-by-decision until the marketing redesign.
- [ ] [LAYOUT-SG] #3 — `/course/[slug]` hero inset-vs-full-bleed decision (needs a design call).
- [ ] [MEM-CAP-ARCH] #4 [Opus] — MEMORY.md now 85% of the 25 KB SessionStart cap; architectural fix, do NOT re-run /r-prune-memory.
- [ ] [VITE-DEDUP] #5 — durable fix for the Vite SSR "multiple copies of React" cold-start crash (workaround: `rm -rf node_modules/.vite`).
- [ ] [HOME-FIXES] #7 · [COURSES-FIXES] #8 — deferred per-route fix buckets.
- [ ] [E2E-MIG] #9 · [E2E-GATE] #10 — migrate E2E tests post-flip + restore the E2E gate.
- [ ] [ICN-NS] #11 — icon-namespace cleanup across the two icon systems + MattIcon registry.
- [ ] [TZ-AUDIT] #12 [Opus] — timezone-correctness audit (recurring `new Date()`; low confidence).
- [ ] [DOCGEN-SPEC] #13 — document the regen binding + r-end Step 5c gate in doc-sync-strategy.md.
- [ ] [V217-WATCH] #14 — watch the [TERM-GARBLE] upstream CC bug for a fix.
- [ ] [M4-ZGUARD] #15 — M4-machine z-index/guard follow-up (thin).
- [ ] [OLD-PORTED-CLEANUP] #16 — RE-SCOPED: per-page vetting of the 74 /old pages (only 12 exact-twins; parked RG-PUBLIC = only-copy KEEP) + the FeedAllTab/FeedRoleTab/ExploreFeeds chain (dies only when /old/discover/feeds retires) + the /creator dead trio (FeaturedCourses/CourseBrowse/CourseDetail) + EnrollButton legacy path. Recovery = git history + commit `608346a2`. Ledger: route-migration README § OLD-PORTED-CLEANUP.
- [ ] [PREFLIP-WT] #17 — teardown the preflip worktree (`~/projects/Peerloop-preflip` @608346a2 on :4331). Machine-local. NOTE: keep alive until /old-page cleanup (#16) + client-vetting done — it's the recovery worktree.
- [ ] [REVIEW-COUNT-SRC] #18 — verify/fix the review-count source (thin).
- [ ] [SESSHIST] #19 (in_progress) — PHASE 2: (a) adapt SessionHistory's 42-case test (`tests/components/teaching/SessionHistory.test.tsx`) onto TeacherSessionsList (currently UNTESTED) — keep Rendering/Filtering/Expandable/Error-Empty, drop Sorting/Pagination, ADD Attendance; (b) browser-verify `/teaching` sessions tab (filters + expand + attendance render); (c) THEN delete `SessionHistory.tsx` (919 ln) + its test (966 ln) + the `workspace/index.ts` barrel line. Keep the attendance API (now has a live consumer).
- [ ] [SWEEP-FULLTEST] #20 — process reminder: run the FULL suite once after broad class-conformance sweeps.
- [ ] [PROV-SWEEP-MI] (existing, README-tracked) — teach `prov-sweep.ts`/page-report the first-token-in-doc-order page-marker detection so it doesn't over-count stand-ins from graduation prose.

## TodoWrite Items

- [ ] #1 [RTMIG-4] (in_progress) · #2 [RG-PUBLIC] · #3 [LAYOUT-SG] · #4 [MEM-CAP-ARCH] [Opus] · #5 [VITE-DEDUP] · #7 [HOME-FIXES] · #8 [COURSES-FIXES] · #9 [E2E-MIG] · #10 [E2E-GATE] · #11 [ICN-NS] · #12 [TZ-AUDIT] [Opus] · #13 [DOCGEN-SPEC] · #14 [V217-WATCH] · #15 [M4-ZGUARD] · #16 [OLD-PORTED-CLEANUP] · #17 [PREFLIP-WT] · #18 [REVIEW-COUNT-SRC] · #19 [SESSHIST] (in_progress) · #20 [SWEEP-FULLTEST]

## Key Context

- **Test baseline GREEN 6737/6737** (re-verified this conv; tsc/check 0-0-0/lint/build also green). The harvest + deletions were additive/dead-code, no regressions.
- **`/old`-retirement recovery convention (DECIDED Conv 338):** git history, NOT an archive folder. Permanent anchor = pre-flip snapshot **commit `608346a2`** (also live as the preflip worktree :4331). Restore: `git checkout 608346a2 -- <path>`. The worktree dir is a convenience over the commit; even after [PREFLIP-WT] teardown the commit anchor persists. Codified in route-migration README § OLD-PORTED-CLEANUP.
- **SESSHIST harvest design:** `TeacherSessionsList` is GROUPED (course→student→session) — the deliberately-chosen model. Sort/pagination were DROPPED (flat-table affordances that fight the hierarchy). Filters MUST be server-side (only 50 sessions fetched client-side; `/api/me/teacher-sessions` supports `status`/`date_from`/`date_to`). Attendance via `/api/sessions/[id]/attendance` (lazy fetch on row expand).
- **Carried-scope lesson:** the OLD-PORTED-CLEANUP backlog note ("44 deletable + 4 dead components") was materially wrong — always re-audit a "delete these" note before acting. 2 of 4 named "dead" components (FeedAllTab/FeedRoleTab) were LIVE.
- **Provenance has TWO axes:** page (top-of-file `@`-marker doc-comment; PROV-STAMP-GAPS) and component (`data-prov`/registry; `prov:sweep`). Both verified clean this conv. Don't conflate them.
- **MEMORY.md at 85%** of the 25 KB SessionStart cap — [MEM-CAP-ARCH] #4 [Opus], architectural fix; do NOT re-prune.
- **Commits this conv:** code `232e5e2e` (orphan deletions) + `0661e596` (SESSHIST harvest); docs `f2a88cf` (ledger) + the start heartbeat `c159e4c` + this end-of-conv bookkeeping pair. All to be pushed at Step 7.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
