# State — Conv 048 (2026-03-28 ~16:13)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-8`, docs: `main`

## Summary

Conv 048 designed and began the TAG-TAXONOMY refactor — simplifying the 5-table taxonomy system (categories, topics, user_topic_interests, user_interests, course_tags) into 3 clean tables (topics, tags, user_tags) plus a restructured course_tags. Phase 1 (schema, seeds, types) is complete and verified. The app won't compile until Phases 2-5 complete.

## Completed

- [x] TAG-TAXONOMY Phase 1: Schema changes (categories→topics, topics→tags, drop user_interests/user_topic_interests, create user_tags, restructure course_tags FK-based, remove courses.category_id)
- [x] TAG-TAXONOMY Phase 1: Core seed data updated (cat-XXX→top-XXX, top-XXX→tag-XXX, platform_stats key renamed)
- [x] TAG-TAXONOMY Phase 1: Dev seed data updated (course_tags FK-based, user_tags replaces user_interests/user_topic_interests, category_id removed from courses)
- [x] TAG-TAXONOMY Phase 1: TypeScript types updated (Category→Topic, Topic→Tag, UserInterest/UserTopicInterest dropped, UserTag added, CourseTag updated, category_id removed from Course)
- [x] TAG-TAXONOMY Phase 1: Verified DB setup passes (15 topics, 55 tags, 11 user_tags, 15 course_tags, old tables absent)

## Remaining

### TAG-TAXONOMY Phases 2-7
- [ ] Phase 2: API Read Paths — rename/update all GET endpoints (/api/categories→/api/topics, /api/topics→/api/tags, admin, onboarding, course, SSR loaders)
- [ ] Phase 3: API Write Paths — update POST/PUT (onboarding-profile, course edit, admin topics CRUD)
- [ ] Phase 4: Recommendation + Smart Feed Engine — replace category matching with tag overlap (graduated scoring)
- [ ] Phase 5: Components + Pages — TopicPicker→TagPicker, CategoriesAdmin→TopicsAdmin, CourseFilterSidebar, ExploreCourses, CourseEditor, discover pages
- [ ] Phase 6: Tests — mechanical category_id removal (~150 files) + targeted rewrites (6 test files)
- [ ] Phase 7: New features — "My Interests" button, "Clear" button, feeds empty state CTA, settings tag editor
- [ ] Update API docs for TAG-TAXONOMY endpoint renames (during Phase 2)

### User Action Items
- [ ] Email Blindside Networks: webcam policy (instructor-only) + analytics callback JWT confirmation (draft ready from Conv 038)
- [ ] Verify staging webhook setup end-to-end (after Blindside email response + deploy)

### Client Decisions
- [ ] Confirm with client: remove /courses, /feeds, /communities (MyXXX pages) — now enclosed in /discover routes

## TodoWrite Items

- [ ] #1: Email Blindside Networks: webcam policy + analytics JWT confirmation
- [ ] #2: Verify staging webhook setup end-to-end
- [ ] #3: Confirm with client: remove /courses, /feeds, /communities (MyXXX pages)
- [ ] #5: Phase 2: API Read Paths
- [ ] #6: Phase 3: API Write Paths
- [ ] #7: Phase 4: Recommendation + Smart Feed Engine
- [ ] #8: Phase 5: Components + Pages
- [ ] #9: Phase 6: Tests
- [ ] #10: Update API docs for TAG-TAXONOMY endpoint renames (Phase 2)

## Key Context

- Plan file at `.claude/plans/expressive-juggling-wand.md` has full phase details including file lists and scoring formula changes
- App is in broken state — schema changed but API/components still reference old tables. TypeScript compilation will fail. Must complete Phases 2-3 minimum before app boots.
- `courses.level` (beginner/intermediate/advanced) is UNRELATED to dropped `experience_level` — don't confuse during test sweep
- Smart feed scoring changes: `feedCategoryMap: Map<string, string>` → `feedTagsMap: Map<string, Set<string>>`, binary match → graduated overlap
- ID convention: `cat-XXX` → `top-XXX` (topics), `top-XXX` → `tag-XXX` (tags)
- 350 test files, 6182 tests — currently broken due to schema changes, will need mechanical sweep

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
