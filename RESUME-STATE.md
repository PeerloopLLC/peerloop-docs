# State — Conv 165 (2026-05-20 ~17:38)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-12`, docs: `main`

## Summary

Closed [CRT-1], [CRT-2], and [CRT-3] in a single conv — loader role flags + role-aware API + teacher vertical slice. Mid-[CRT-3] design-time, surfaced and fixed a dual-role regression introduced by [CRT-2]: added an explicit `scope=student|teacher|all` query param to `/api/courses/[id]/sessions` (option A picked over flipping precedence or accepting limitation) so a teacher who is also enrolled can drive student vs teacher scope from the UI. Browser-verified as Guy on `/course/intro-to-n8n/sessions` — TEACHER group + "My Teaching Sessions" tab renders, content shows Guy's teaching sessions with student names. Also hit a serialization bug (React element nodes don't survive Astro→React `client:load` prop boundary) — refactored to pass primitive role flags to `CourseTabs` which builds extra-tab content internally. All 5 baseline gates green (6438/6438 tests).

## Completed

- [x] [CRT-1] Loader role flags — `fetchCourseTabData` returns `isAdmin`, `isCreatorOfCourse`, `isTeacherOfCourse`, `isModeratorOfCommunity`; 7 SSR tests
- [x] [CRT-2] API role-aware paths — `/api/courses/[id]/sessions` rewritten with role precedence; 6 endpoint tests
- [x] [CRT-2.5] `scope` query param on `/api/courses/[id]/sessions` — caller-declared scope disambiguates dual-role users; 10 endpoint tests
- [x] [CRT-3] Teacher vertical slice — `TeacherSessionsTabContent` component + `CourseTabs` extra-tab wiring + browser-verified as Guy

## Remaining

- [ ] **[CRT-4]** Creator + admin + moderator groups on `sessions.astro` — decide scope-prop vs variant for `SessionsTabContent`. The chassis pattern is now locked: pass `isCreatorOfCourse` / `isAdmin` / `isModeratorOfCommunity` flags to `CourseTabs`, build the CREATOR / ADMIN / MODERATOR extra-tab groups inside CourseTabs (do NOT construct React nodes in Astro frontmatter — they don't survive `client:load` serialization).
- [ ] **[CRT-5]** Propagate extraTabs to other course tabs (`resources.astro`, `index.astro`, `feed.astro`, `learn.astro`, `teachers.astro`). Handle `ResourcesTabContent` role split. Follow [CRT-3] pattern: pass role flags as props.
- [ ] **[CRT-6]** Component tests for each role × tab path + full 5-gate baseline.
- [ ] **[CRT-DEDICATED-PAGES]** Direct nav to `/course/<slug>/teaching-sessions` 404s — tab nav clicks update URL via `pushState` but manual refresh hits missing-page case. Decide in [CRT-5]: clone `sessions.astro` per extra tab, or single dynamic catch-all mapping any extra-tab ID back to the course tab page.
- [ ] **[CRT-STUDENT-EXPLICIT-SCOPE]** Update standard student `SessionsTabContent` fetch to pass `scope=student` explicitly. Without this, dual-role users still see teaching-scoped data on the student tab (default precedence picks teacher).
- [ ] **[SEED-PW]** Rotate dev seed-data passwords — `Password1` triggers Chrome breach warnings on every login.
- [ ] **[WRANGLER-CMT]** Fix `wrangler.toml` line 109 comment — claims `--env staging` flag but actual mechanism is `CLOUDFLARE_ENV` env var → `dist/server/wrangler.json`.
- [ ] **[BR-ZERO-REPRO]** Reproduce 0-min "empty-but-published" recording state in next BBB test — needed for [BR-STATUS] enum design.
- [ ] **[BR-STATUS]** Add `sessions.recording_status` column with enum `none | requested | capturing | processing | published | failed | empty` [Opus]. Awaits [BR-ZERO-REPRO] data + Blindside follow-up.
- [ ] **[XMV]** Front-load cross-machine verification (`HOME=/Users/livingroom` simulation) before locking sweep rules into CLAUDE.md or memory.
- [ ] **[MND]** Fix `detect-machine.sh` hostname match for M4Pro — `~/.claude/.machine-name` contains literal `"Unknown (M4Pro.local)"` instead of canonical `"MacMiniM4Pro"`. Surfaced again Conv 165 /r-start; hardcoded "MacMiniM4Pro" workaround still in use.
- [ ] **[AAP]** Astro dev-only absolute-filesystem path leak in `ClientRouter` — WAITING on upstream Astro fix post-6.3.6.
- [ ] **[VITE-DEPS-WATCH]** Watch for recurring Vite missing-chunk warnings (astro/audit/xray/toolbar). Self-resolved Conv 165; investigate only if it surfaces again.

## TodoWrite Items

- [ ] #4: [CRT-4] Creator + admin + moderator groups on sessions.astro
- [ ] #5: [CRT-5] Propagate extraTabs to other course tabs
- [ ] #6: [CRT-6] Component tests for each role × tab path
- [ ] #7: [SEED-PW] Rotate dev seed-data passwords
- [ ] #8: [WRANGLER-CMT] Fix wrangler.toml line 109 comment
- [ ] #9: [BR-ZERO-REPRO] Reproduce 0-min empty-but-published recording state
- [ ] #10: [BR-STATUS] Add sessions.recording_status column with enum [Opus]
- [ ] #11: [XMV] Front-load cross-machine verification
- [ ] #12: [MND] Fix detect-machine.sh hostname match for M4Pro
- [ ] #13: [AAP] Astro dev-only absolute-filesystem path leak in ClientRouter
- [ ] #14: [VITE-DEPS-WATCH] Watch for recurring Vite missing-chunk warnings

## Key Context

**State as of pre-commit:** Code repo will be committed in Step 6 with 8 files changed (TeacherSessionsTabContent.tsx NEW + 7 modified: CourseTabs.tsx, course-tabs/types.ts, ssr/loaders/courses.ts, api/courses/[id]/sessions.ts, course/[slug]/sessions.astro, 2 test files). Docs repo will be committed with PLAN.md update (CRT-1/2/3 checked, 2 new subtasks added), 6 reference doc updates (API-COURSES, CLI-QUICKREF, DEVELOPMENT-GUIDE, TEST-COVERAGE, url-routing, route-api-map, page-connections), 3 new session files (Extract, Learnings, Decisions), DECISIONS.md + TIMELINE.md updated by learn-decide agent, RESUME-STATE.md deletion (transferred at /r-start) + new write (this file), memory mirror sync.

**Block status:** CRT remains ACTIVE — 3 of 6 original phases complete, 1 new phase added (CRT-2.5 done in-conv), 2 new sub-tasks surfaced (CRT-DEDICATED-PAGES, CRT-STUDENT-EXPLICIT-SCOPE).

**API contract locked at `/api/courses/[id]/sessions`:**
- Default scope (no param) = highest-privilege precedence (admin/creator/mod → all; teacher → teacher; enrolled → student; else 403)
- Explicit `scope=student` → 403 unless enrolled
- Explicit `scope=teacher` → 403 unless certified teacher
- Explicit `scope=all` → 403 unless admin/creator/moderator
- Invalid scope → 400
- Response includes `student_id`, `student_name`, `student_avatar_url` (always, all scopes)

**Astro→React client:load anti-pattern (Conv 165 incident):** Constructing React nodes (`createElement(...)` or JSX) in `.astro` frontmatter and passing them as props to a `client:load` component IS BROKEN. The element gets JSON-serialized into a plain `{$$typeof, type, key, props, _owner, _store}` object that React rejects as an invalid child. TypeScript accepts it (ReactNode is the right type) — only runtime catches it. **Correct pattern:** pass primitive descriptors (booleans, strings, IDs) and let the island construct JSX internally. CourseTabs now follows this — it imports `TeacherSessionsTabContent` and renders it based on `isTeacherOfCourse: boolean` prop. Apply the same pattern in [CRT-4] for CREATOR/ADMIN/MODERATOR groups.

**Hydration-safe pattern carries forward:** `useState(null)` + `isHydrated` flag + render guard for any client-side reads of `getCurrentUser()` / `window.__peerloop` / localStorage. Established Conv 164 ([BR-NAVBAR-HYDRATE]) and still applies.

**File path references:**
- Loader (CRT-1): `src/lib/ssr/loaders/courses.ts` — see `fetchCourseTabData` return shape lines 232-236
- API (CRT-2/2.5): `src/pages/api/courses/[id]/sessions.ts` — scope-param logic + 4-query parallel role check
- New teacher tab component: `src/components/courses/course-tabs/TeacherSessionsTabContent.tsx`
- Orchestrator: `src/components/courses/CourseTabs.tsx` — `useMemo`-wrapped `extraTabs` construction from role flags, lines ~95-115
- Entry page: `src/pages/course/[slug]/sessions.astro` — smart `initialTab` + role-flag prop passing
- Tests: `tests/ssr/courses.test.ts` (+7 SSR) + `tests/api/courses/[id]/sessions.test.ts` (+16 in CRT-2 describe block)

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view. **Recommended next task: [CRT-STUDENT-EXPLICIT-SCOPE]** (1-line fetch URL change to `SessionsTabContent`, makes dual-role users see correct scope on student tab — small win) OR jump to **[CRT-4]** to keep momentum on the role-group rollout (CREATOR group is the most-asked-for next).
