# State — Conv 049 (2026-03-28 ~16:46)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-8`, docs: `main`

## Summary

Conv 049 completed TAG-TAXONOMY Phase 2 (API Read Paths) — all 25 API endpoint files and 4 SSR loaders updated to use the new schema (topics, tags, user_tags, course_tags). Route renames done (/api/categories→/api/topics, /api/topics→/api/tags, admin categories→topics). Phase 2 scope expanded to cover write handlers in moved files, reducing Phase 3's remaining scope.

## Completed

- [x] TAG-TAXONOMY Phase 2: API Read Paths — all GET endpoints renamed/updated (25 files modified, 5 new, 5 deleted)
- [x] TAG-TAXONOMY Phase 2: Route renames — /api/categories→/api/topics, /api/topics→/api/tags, /api/admin/categories→/api/admin/topics
- [x] TAG-TAXONOMY Phase 2: SSR loaders updated — courses, home, static, creators
- [x] TAG-TAXONOMY Phase 2: Onboarding profile rewritten for user_tags
- [x] TAG-TAXONOMY Phase 2: Recommendations rewritten for tag-overlap scoring
- [x] TAG-TAXONOMY Phase 2: Feeds discover rewritten for user_tags→course_tags matching
- [x] TAG-TAXONOMY Phase 2: mock-data.ts updated — removed category_id from interfaces and data

## Remaining

### TAG-TAXONOMY Phases 3-7
- [ ] Phase 3: Verify all remaining write paths are correct (scope reduced — admin topics CRUD, onboarding POST, course create POST already done in Phase 2)
- [ ] Phase 4: Add topic-level weighting to tag-overlap scoring (graduated scoring). Basic tag-overlap already implemented.
- [ ] Phase 5: Components + Pages — TopicPicker→TagPicker, CategoriesAdmin→TopicsAdmin, CourseFilterSidebar, ExploreCourses, CourseEditor, discover pages
- [ ] Phase 6: Tests — mechanical category_id removal (~150 files) + targeted rewrites (6 test files)
- [ ] Phase 7: New features — "My Interests" button, "Clear" button, feeds empty state CTA, settings tag editor
- [ ] Update API docs for TAG-TAXONOMY endpoint renames (during Phase 2) — partially done by docs agent
- [ ] Update stale API docs referencing /api/categories (_API.md, _SERVER.md, DB-API.md)
- [ ] Update url-routing.md for /admin/categories → /admin/topics (when Phase 5 renames frontend page)

### User Action Items
- [ ] Email Blindside Networks: webcam policy (instructor-only) + analytics callback JWT confirmation (draft ready from Conv 038)
- [ ] Verify staging webhook setup end-to-end (after Blindside email response + deploy)

### Client Decisions
- [ ] Confirm with client: remove /courses, /feeds, /communities (MyXXX pages) — now enclosed in /discover routes

## TodoWrite Items

- [ ] #2: Phase 3: API Write Paths
- [ ] #3: Phase 4: Recommendation + Smart Feed Engine
- [ ] #4: Phase 5: Components + Pages
- [ ] #5: Phase 6: Tests
- [ ] #6: Phase 7: New features
- [ ] #7: Update API docs for TAG-TAXONOMY endpoint renames
- [ ] #8: Email Blindside Networks
- [ ] #9: Verify staging webhook setup end-to-end
- [ ] #10: Confirm with client: remove MyXXX pages
- [ ] #11: Update stale API docs referencing /api/categories
- [ ] #12: Update url-routing.md for /admin/categories → /admin/topics

## Key Context

- App is still in broken state — schema changed but components still reference old types/endpoints. Must complete Phase 5 minimum before app boots fully.
- Phase 3 scope is significantly reduced: admin topics CRUD, onboarding-profile POST, and course create POST were all updated during Phase 2 (files were being moved). Phase 3 is now mostly a verification pass.
- Phase 4 basic tag-overlap scoring is already in place (recommendations + feeds/discover). Phase 4 adds graduated topic-level weighting.
- mock-data.ts `Category` interface and `categories` array remain (stale mock data used by ~15 component files). Phase 5 will clean these up.
- ID convention: `cat-XXX` → `top-XXX` (topics), `top-XXX` → `tag-XXX` (tags)
- EXISTS subquery pattern used consistently for topic-based course filtering (5+ endpoints)
- 350 test files, 6182 tests — currently broken due to schema changes, will need mechanical sweep in Phase 6

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
