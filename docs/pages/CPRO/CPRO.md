# CPRO - Creator Profile

| Field | Value |
|-------|-------|
| Route | `/creators/:handle` |
| Access | Public |
| Priority | P0 |
| Status | ✅ Implemented |
| Block | 1 |
| Astro Page | `src/pages/creators/[handle].astro` |
| Component | `src/components/creators/CreatorProfile.tsx` |
| JSON Spec | `src/data/pages/creators/[handle].json` |

---

## Purpose

Display comprehensive creator information including qualifications, expertise, courses, and teaching philosophy to build trust and drive course enrollment.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-G008 | As a visitor, I want to view creator profile so that I can learn about their background | P0 | ✅ |
| US-G010 | As a visitor, I want to see creator qualifications so that I can trust their expertise | P0 | ✅ |
| US-C008 | As a creator, I want a public profile so that students can discover me | P0 | ✅ |
| US-C009 | As a creator, I want my profile to show expertise so that students understand my focus areas | P0 | ✅ |
| US-C036 | As a creator, I want to display expertise tags so that I'm discoverable by topic | P0 | ✅ |

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| CRLS | Creator card click | From creator listing |
| CDET | Creator name/avatar click | From course detail |
| CBRO | Creator name on course card | From browse results |
| SDSH | Creator link on enrolled course | Student viewing creator |
| IFED | Creator header/link | From instructor feed |
| (External) | Direct URL, shared link | `/@brian` or `/creators/brian` |

### Outgoing (users navigate to)

| Target | Trigger | Notes | Status |
|--------|---------|-------|--------|
| CDET | Course card click | View specific course | ✅ |
| CBRO | "View All Courses" | Filtered by this creator | ✅ |
| IFED | "View Feed" (if enrolled in any course) | Access-controlled | ⏳ |
| SGUP | Follow button (logged out) | Redirect to signup | ✅ |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| users | id, name, handle, avatar, title, bio, website, teaching_philosophy | Profile display |
| user_qualifications | sentence, display_order | Credentials section |
| user_expertise | tag | Expertise tags |
| user_stats | students_taught, courses_created, average_rating, total_reviews | Stats bar |
| courses | id, title, slug, thumbnail, price, rating, level | Courses list |
| follows | count where followed_id = creator | Follower count |
| instructor_followers | exists check | Access to IFED |

---

## Features

### Profile Header
- [x] Avatar (large, circular) `[US-G008]`
- [x] Name and handle (@handle) `[US-G008]`
- [x] Title (professional title) `[US-G008]`
- [x] Follow button `[US-G008]` *(UI only - backend not connected)*
- [ ] Follower count `[US-G008]` *(not shown)*
- [x] Website link (external icon) `[US-G008]`

### Stats Bar
- [x] Students taught `[US-G008]`
- [x] Courses created `[US-G008]`
- [x] Average rating (stars + number) `[US-G008]`
- [x] Total reviews `[US-G008]`

### Content Sections
- [x] Bio section (full biography) `[US-G008]`
- [x] Teaching philosophy (quote-styled) `[US-G010]`
- [x] Qualifications (credential list with icons) `[US-G010]`
- [x] Expertise tags (pills) `[US-C009, US-C036]`

### Courses Section
- [x] Grid of course cards by this creator `[US-C008]`
- [x] "View All" link if more than 3 → CBRO?creator=handle `[US-C008]`

---

## Sections

### Profile Header
- **Avatar:** Large circular image
- **Name:** Display name
- **Handle:** @handle
- **Title:** Professional title
- **Follow button:** Follows creator (logged in) or prompts signup
- **Follower count:** "X followers"
- **Website link:** External link icon

### Stats Bar
- Students taught
- Courses created
- Average rating (stars + number)
- Total reviews

### Bio Section
- Full biography text
- Expandable if long

### Teaching Philosophy (if present)
- Quote-styled or highlighted section
- Source: users.teaching_philosophy

### Qualifications
- Credential list with icons
- Source: user_qualifications

### Expertise
- Tag pills
- Source: user_expertise

### Courses by [Creator Name]
- Grid of course cards (same as CBRO)
- Show all courses by this creator
- "View All" if more than 6 → CBRO?creator=handle

### Call to Action
- "Explore [Name]'s Courses" button
- Or featured course highlight

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/creators/:handle` | GET | Creator profile data | ✅ |
| `/api/creators/:handle/courses` | GET | Creator's courses | ✅ |
| `/api/follows` | POST | Follow creator | ⏳ |
| `/api/follows/:id` | DELETE | Unfollow creator | ⏳ |
| `/api/users/me/follows/:creator_id` | GET | Check if following | ⏳ |

**Response includes:**
- Profile: name, handle, avatar, title, bio, teaching_philosophy, website
- Qualifications: user_qualifications array
- Expertise: user_expertise tags
- Stats: students_taught, courses_created, average_rating, follower_count
- Courses: Array of course cards

---

## States & Variations

| State | Description | Status |
|-------|-------------|--------|
| Visitor | Public view, follow prompts signup | ✅ |
| Logged In (Not Following) | Follow button active | ⏳ |
| Logged In (Following) | "Following" state, unfollow option | ⏳ |
| Enrolled in Creator's Course | "View Feed" link visible (→ IFED) | ⏳ |
| Own Profile (Creator viewing self) | "Edit Profile" link → PROF | ⏳ |

---

## Error Handling

| Error | Display |
|-------|---------|
| Creator not found | 404 with "Creator not found" |
| Profile private | "This profile is private" (shouldn't happen for creators) |

---

## Mobile Considerations

- Header stacks vertically
- Stats become 2x2 grid
- Course cards single column
- Sticky "Follow" button at bottom

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `page_view` | Page load | creator_id, source |
| `follow_click` | Follow clicked | creator_id |
| `course_click` | Course card clicked | course_id |
| `website_click` | External link clicked | creator_id |

---

## Implementation Notes

- SSR with dynamic route parameter
- Courses fetched from `/api/creators/:id/courses`
- CD-017: Creator profiles are a key trust signal ($8K-11K estimate)
- Consider verification badge for vetted creators (future)
- SEO: Creator pages should be indexable

---

## Interactive Elements

### Buttons (with onClick handlers)

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| Follow | CreatorProfile | UI only - not connected to backend | ⚠️ Placeholder |

### Links - Breadcrumb

| Element | Target | Status |
|---------|--------|--------|
| Home | / | ✅ Active |
| Creators | /creators | ✅ Active |

### Links - Header Actions

| Element | Target | Status |
|---------|--------|--------|
| Website button | {creator.website} (external) | ✅ Active |

### Links - Courses Section

| Element | Target | Status |
|---------|--------|--------|
| "View all →" | /courses?creator={handle} | ✅ Active |
| Course cards | /courses/{slug} | ✅ Active |

### Links - Not Found State

| Element | Target | Status |
|---------|--------|--------|
| "← Back to creators" | /creators | ✅ Active |

### Links - Navigation (Header/Footer)

Same as other public pages (HOME, CBRO).

### API Calls (triggered by interactions)

| Trigger | Endpoint | Method | Status |
|---------|----------|--------|--------|
| Page load (SSR) | `/api/creators/{handle}` | GET | ✅ Active |

### Target Pages Status

| Target | Page Code | Implemented |
|--------|-----------|-------------|
| / | HOME | ✅ Yes |
| /creators | CRLS | ✅ Yes |
| /courses | CBRO | ✅ Yes |
| /courses/{slug} | CDET | ✅ Yes |

---

## Verification Notes

**Verified:** 2026-01-07 (Code + Visual + Interactive Elements)

**Consolidated:** 2026-01-08
- JSON spec updated to match verified implementation
- 5 discrepancies documented in JSON `_discrepancies` section

### Discrepancies Found

| Feature | Spec | Reality | Status |
|---------|------|---------|--------|
| Follow button | Listed as unchecked | ✅ Shown (UI only, no backend) | ⚠️ Partial |
| Follower count | Planned | Not shown | ⏳ Deferred |
| Website link | Listed as unchecked | ✅ Implemented | ✅ Fixed |
| Total reviews | Listed as unchecked | ✅ Implemented | ✅ Fixed |
| View All link | Listed as unchecked | ✅ Implemented | ✅ Fixed |
| Follow API endpoints | Planned | Not implemented | ⏳ Deferred |
| Analytics events | 4 events specified | None implemented | ❌ Not implemented |

### Components Verified

| Component | File | Status |
|-----------|------|--------|
| CreatorProfile | `src/components/creators/CreatorProfile.tsx` | ✅ No TODOs |
| CourseCard | `src/components/courses/CourseCard.tsx` | ✅ Clean |
| [handle].astro | `src/pages/creators/[handle].astro` | ✅ Clean |

### Interactive Elements Summary

| Category | Count | Active | Inactive |
|----------|-------|--------|----------|
| Buttons (onClick) | 1 | 0 | 1 (Follow) |
| Breadcrumb Links | 2 | 2 | 0 |
| Header Action Links | 1 | 1 | 0 |
| Course Links | 5+ | 5+ | 0 |
| API Endpoints | 1 | 1 | 0 |
| Analytics Events | 4 | 0 | 4 |

**Notes:**
- All display sections working correctly
- Follow button renders but is not connected to backend
- Follower count not displayed (backend not ready)
- "At a Glance" sidebar card duplicates header stats (acceptable)
- View all link shows when >3 courses (not >6 as spec said)

### Screenshots

| File | Date | Description |
|------|------|-------------|
| `CPRO-2026-01-07-06-03-55.png` | 2026-01-07 | Full creator profile page |
