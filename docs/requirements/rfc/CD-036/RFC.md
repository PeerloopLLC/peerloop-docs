# RFC: CD-036 - Communities, Progressions & Feeds

**Status:** In Progress
**Created:** 2026-02-03
**Updated:** 2026-02-04
**Items:** 32
**Completed:** 32

---

## Pre-Implementation (Answered)

- [x] Clarify: Can a course belong to multiple communities? → **No, one only (via progression)**
- [x] Clarify: Can a course exist without a community? → **No, must have progression → community**
- [x] Clarify: Who can post to community feeds? → **Members only. Commons = anyone.**
- [x] Clarify: Can visitors view community feeds? → **TBD, design for flexibility**
- [x] Clarify: Is community membership automatic with enrollment? → **Yes**
- [x] Clarify: Can a course be in multiple progressions? → **No, copy the course instead**
- [x] Clarify: How many feeds per community? → **1 feed per community (community IS the feed)**
- [x] Clarify: How handle Announcements/Help within The Commons? → **Tags on posts, not separate feeds**
- [x] Clarify: Where do Creator feeds live? → **`/creator/[handle]/feed` (IFED)**
- [x] Clarify: Where do Course feeds live? → **`/course/[slug]/feed`**

---

## Schema Changes

### Stage 1 (Session 181) - Communities Foundation ✅

- [x] Create `communities` table
- [x] Create `community_members` table
- [x] Create `community_resources` table
- [x] Seed: The Commons (system community)
- [x] Seed: Sample communities (AI Tools, n8n, Vibe Coding)
- [x] Seed: Community members with roles
- [x] Seed: Community resources (files, links, videos)

### Stage 2 (Session 182) - Progressions & Course Restructure ✅

- [x] Create `progressions` table
- [x] Add `progression_id` to `courses` table (nullable for migration flexibility)
- [x] Add `progression_position` to `courses` table
- [x] Add `source_course_id` (nullable) to `courses` for copying
- [x] Add `is_archived` to `courses` table
- [x] ~~Remove `community_id` from `courses`~~ (was never added - correct, derived via progression)
- [x] Migrate existing courses to progressions (via seed data)

---

## API Endpoints

### Stage 1 (Session 181) ✅

- [x] `GET /api/communities` - List communities (filter: mine/all/discover)
- [x] `GET /api/communities/[slug]` - Community detail with members & resources

### Stage 2 (Session 182)

- [x] `GET /api/communities/[slug]/progressions` - Progressions in community
- [ ] `POST /api/communities` - Create community (creator)
- [ ] `PATCH /api/communities/[slug]` - Update community
- [ ] `GET /api/progressions/[slug]` - Progression detail with courses
- [ ] `POST /api/progressions` - Create progression
- [ ] `POST /api/courses/[id]/copy` - Copy a course

---

## Routing (per tech-021, Session 181 updates)

- [x] Add `/community` hub page (My Communities, mirrors slideout)
- [x] Add `/community/[slug]` page (community = its feed, tabbed UI)
- [x] Create `CommunityTabs` component (Feed, Courses, Resources, Members)
- [x] Update `FeedSlidePanel` routes to `/community/[slug]`
- [x] Add `/discover/communities` route
- [x] Add `/course/[slug]/feed` route
- [x] Add `/creator/[handle]/feed` route (IFED)
- [ ] Update `/course/[slug]` to show progression
- [ ] Add `/creating/communities` routes
- [ ] Add `/creating/progressions` routes
- [x] Update url-routing.md with community routes

---

## UI Components

- [ ] Progression card (with badge: Learning Path / Stand-alone)
- [ ] Progression detail page (course sequence)
- [x] Community page (feed + progressions) - CommunityTabs with Courses tab
- [ ] Course position indicator ("Course 2 of 3")

---

## Documentation

- [x] Update DB-SCHEMA.md with new entities
- [x] PAGES-MAP.md → ORIG-PAGES-MAP.md (archived as pre-Twitter UI reference)
- [x] Routes documented in url-routing.md (source of truth for routes)
