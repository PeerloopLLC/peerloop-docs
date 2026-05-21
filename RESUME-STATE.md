# State — Conv 166 (2026-05-20 ~20:40)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-12`, docs: `main`

## Summary

Closed the entire CRT block in one conv — 5 phases ([CRT-STUDENT-EXPLICIT-SCOPE], [CRT-4], [CRT-5], [CRT-6], [CRT-DEDICATED-PAGES]) all delivered with full 5-gate baseline green (6453/6453, +15 tests). Net: 2 new files (`AllSessionsTabContent.tsx`, dynamic `[tab].astro` catch-all), 8 edits across CourseTabs + ResourcesTabContent + 6 course .astro pages, 15 new component tests. Browser-verified as Guy (creator+teacher) and Brian (admin). CRT block moved from PLAN.md to COMPLETED_PLAN.md entry #67. Two new pre-existing latent bugs surfaced as follow-up tasks ([CAP-DEFEND], [RM-PARAM-BUG]) plus one diagnostic ([RAM-NO-NAV]).

## Completed

- [x] [CRT-STUDENT-EXPLICIT-SCOPE] — 2-site fetch fix (`CourseTabs.tsx:131` + `ResourcesTabContent.tsx:71` now pass `scope=student` explicitly)
- [x] [CRT-4] — CREATOR + ADMIN + MODERATOR groups on sessions.astro (shared AllSessionsTabContent)
- [x] [CRT-5] — Propagated 4 role flags to 5 course-tab pages + ResourcesTabContent role split (canSeeAllResources predicate)
- [x] [CRT-6] — 15 component tests added; full 5-gate baseline green (6453/6453, +15 from Conv 165 baseline)
- [x] [CRT-DEDICATED-PAGES] — single [tab].astro catch-all with whitelist + access gates; CRT block fully closed

## Remaining

- [ ] **[SEED-PW]** Rotate dev seed-data passwords — `Password1` triggers Chrome breach warnings on every login.
- [ ] **[WRANGLER-CMT]** Fix `wrangler.toml` line 109 comment — claims `--env staging` flag but actual mechanism is `CLOUDFLARE_ENV` env var → `dist/server/wrangler.json`.
- [ ] **[BR-ZERO-REPRO]** Reproduce 0-min "empty-but-published" recording state in next BBB test — needed for [BR-STATUS] enum design.
- [ ] **[BR-STATUS]** Add `sessions.recording_status` column with enum `none | requested | capturing | processing | published | failed | empty` [Opus]. Awaits [BR-ZERO-REPRO] data + Blindside follow-up.
- [ ] **[XMV]** Front-load cross-machine verification (`HOME=/Users/livingroom` simulation) before locking sweep rules into CLAUDE.md or memory.
- [ ] **[MND]** Fix `detect-machine.sh` hostname match for M4Pro — `~/.claude/.machine-name` contains literal `"Unknown (M4Pro.local)"` instead of canonical `"MacMiniM4Pro"`. Surfaced again Conv 166 /r-start; hardcoded "MacMiniM4Pro" workaround still in use.
- [ ] **[AAP]** Astro dev-only absolute-filesystem path leak in `ClientRouter` — WAITING on upstream Astro fix post-6.3.6.
- [ ] **[VITE-DEPS-WATCH]** Watch for recurring Vite missing-chunk warnings (astro/audit/xray/toolbar). Self-resolved Conv 165; investigate only if it surfaces again.
- [ ] **[CAP-DEFEND]** `CourseAvailabilityPreview.tsx:122` crashes async on `data.teachers.map` when fetch returns `{}` shape. Pre-existing latent bug; surfaced during Conv 166 CRT-6 test runs. Fix: defensive check + typed empty-state branch.
- [ ] **[RM-PARAM-BUG]** `scripts/route-matrix.mjs` link-resolution regex mangles `/course/[slug]/[tab]` to `/course/[slug][param]` — bad rows committed in `docs/as-designed/page-connections.md` lines 50 and 684. Pre-existing script bug newly exposed by Conv 166 [tab].astro route. Fix the regex; regenerate page-connections.md.
- [ ] **[RAM-NO-NAV]** `route-api-map.mjs` warns `/course/[slug]/[tab]` has no discovered nav path. Route IS reachable via pushState clicks inside CourseTabs (not as standalone nav anchors). Verify warning is benign vs. add a nav surface; decide whether to silence or wire.

## TodoWrite Items

- [ ] #6: [SEED-PW] Rotate dev seed-data passwords
- [ ] #7: [WRANGLER-CMT] Fix wrangler.toml line 109 comment
- [ ] #8: [BR-ZERO-REPRO] Reproduce 0-min empty-but-published recording state in next BBB test
- [ ] #9: [BR-STATUS] Add sessions.recording_status column with enum [Opus]
- [ ] #10: [XMV] Front-load cross-machine verification
- [ ] #11: [MND] Fix detect-machine.sh hostname match for M4Pro
- [ ] #12: [AAP] Astro dev-only absolute-filesystem path leak in ClientRouter
- [ ] #13: [VITE-DEPS-WATCH] Watch for recurring Vite missing-chunk warnings
- [ ] #14: [CAP-DEFEND] CourseAvailabilityPreview undefined-shape crash
- [ ] #15: [RM-PARAM-BUG] route-matrix.mjs mangles [tab] route to /course/[slug][param]
- [ ] #16: [RAM-NO-NAV] route-api-map warns /course/[slug]/[tab] has no discovered nav path

## Key Context

**State at conv close (pre-commit):** Code repo will be committed in Step 6 with 9 modified files + 2 new files (AllSessionsTabContent.tsx + [tab].astro + new tests directory). Docs repo committed with PLAN.md (CRT block moved out), COMPLETED_PLAN.md (CRT entry #67 added), 8 doc updates (TEST-COVERAGE, TEST-COMPONENTS, API-COURSES, DEVELOPMENT-GUIDE, url-routing, route-api-map, page-connections, ROUTE-* TSVs), DECISIONS.md/TIMELINE.md updates, 3 new session files, RESUME-STATE.md (this file) + memory mirror sync.

**CRT block status:** ✅ COMPLETE. All 6 phases delivered. Archived in COMPLETED_PLAN.md.

**API contract `/api/courses/[id]/sessions`** (locked Conv 165, exercised Conv 166):
- Default scope (no param) = highest-privilege precedence (admin/creator/mod → all; teacher → teacher; enrolled → student; else 403)
- Explicit `scope=student` requires enrollment; `scope=teacher` requires certification; `scope=all` requires admin/creator/moderator
- 4 UI consumers now: `SessionsTabContent` (via CourseTabs, scope=student), `TeacherSessionsTabContent` (scope=teacher), `AllSessionsTabContent` (scope=all, CREATOR/ADMIN/MODERATOR tabs), `ResourcesTabContent` (scope=student for past-sessions list)

**New routing pattern (Conv 166):** `/course/[slug]/[tab].astro` dynamic catch-all with role-aware whitelist. Astro static-route precedence keeps existing 7 static .astro files unaffected. Future role tabs are 1-line entries in `roleTabMap` + `tabLabels` — no new file needed.

**Astro→React `client:load` anti-pattern (carried from Conv 165):** Constructing React nodes in `.astro` frontmatter and passing as props to a `client:load` component IS BROKEN (silent serialization → React rejects). Pattern: pass primitive descriptors (booleans, strings, IDs) and let island construct JSX internally. CRT-4 implementation confirmed this pattern.

**File path references:**
- Shared role-tab component: `src/components/courses/course-tabs/AllSessionsTabContent.tsx`
- Dynamic catch-all: `src/pages/course/[slug]/[tab].astro`
- Orchestrator: `src/components/courses/CourseTabs.tsx` (extraTabs useMemo, lines ~106-138)
- Resources role-split: `src/components/courses/course-tabs/ResourcesTabContent.tsx` (canSeeAllResources predicate)
- 6 entry pages all pass 4 role flags: `src/pages/course/[slug]/{index,sessions,feed,learn,resources,teachers}.astro`
- New tests: `tests/components/courses/CourseTabs.test.tsx` (+8) and `tests/components/courses/course-tabs/ResourcesTabContent.test.tsx` (NEW, 7)

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view. **Strong candidates for next conv:** [CAP-DEFEND] (defensive fix, surfaced as side-effect of CRT-6), [RM-PARAM-BUG] (script regex fix, bad rows in committed docs), [SEED-PW] / [WRANGLER-CMT] (small wins).
