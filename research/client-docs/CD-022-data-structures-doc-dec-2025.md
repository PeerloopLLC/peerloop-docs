# CD-022: PeerLoop Data Structures Documentation (Dec 23, 2025)

**Date Uploaded:** 2025-12-23
**Original Date:** 2025-12-23
**Source File:** `Brians DATA_STRUCTURES Dec 23, 2025.md`
**Summary for SPECS.md:**

Formal documentation of data structures from the PeerLoop prototype, complementing CD-021 (database sample). Provides clear field definitions, types, and examples. Includes link to live prototype.

---

## Live Prototype

**URL:** https://brianpeerloop.github.io/Peerloop-v2/
**Source Code:** `src/data/database.js`

---

## New Fields (Not in CD-021)

### Course Fields

| Field | Type | Description | Values |
|-------|------|-------------|--------|
| `ratingCount` | number | Number of reviews for this specific course | e.g., `1892` |
| `badge` | string/null | Promotional badge for course cards | `"Popular"`, `"New"`, `"Bestseller"`, `"Featured"`, `null` |

**Implications:**
- `ratingCount` is per-course, distinct from creator's `totalReviews`
- `badge` enables promotional highlighting on course cards

---

## Confirmed Data Structures (Matches CD-021)

### Instructor/Creator Entity

| Field | Type | Description |
|-------|------|-------------|
| id | number | Unique identifier |
| name | string | Full name |
| title | string | Professional title/role |
| avatar | string | Profile image URL |
| bio | string | Bio paragraph (1-3 sentences) |
| website | string | Personal/company website |
| qualifications | array | Array of credential objects `{id, sentence}` |
| expertise | array | Array of skill tags |
| stats | object | `{studentsTaught, coursesCreated, averageRating, totalReviews}` |
| courses | array | Array of course IDs they created |

### Course Entity

| Field | Type | Description |
|-------|------|-------------|
| id | number | Unique identifier |
| title | string | Course title |
| description | string | Full description |
| duration | string | Course duration (e.g., "6 weeks") |
| level | string | Beginner / Intermediate / Advanced |
| rating | number | Average rating (1.0 - 5.0) |
| ratingCount | number | **NEW** - Number of reviews for this course |
| students | number | Enrolled student count |
| price | string | Price as string (e.g., "$399") |
| badge | string/null | **NEW** - Promotional badge |
| thumbnail | string | Course image URL |
| instructorId | number | Links to instructor by ID |
| category | string | Category name |
| tags | array | Searchable tags |
| learningObjectives | array | What students will learn |
| curriculum | array | Course modules `{title, duration, description}` |

### PeerLoop-Specific Fields (Optional)

| Field | Type | Description |
|-------|------|-------------|
| peerloopFeatures | object | `{oneOnOneTeaching, certifiedTeachers, earnWhileTeaching, teacherCommission}` |
| studentTeachers | array | `{name, studentsTaught, certifiedDate}` |
| includes | array | What's included with enrollment |

---

## Business Model Confirmation

**Flywheel:** Learn → Certify → Teach → Earn

| Step | Description |
|------|-------------|
| 1 | Student enrolls in a course |
| 2 | Student completes curriculum with 1-on-1 sessions |
| 3 | Student gets certified |
| 4 | Student becomes a Student-Teacher |
| 5 | Student-Teacher earns 70% teaching new students |

**Revenue Split:**
- 70% → Student-Teacher
- 15% → Creator
- 15% → PeerLoop

---

## User Types

| Type | Description | Earns |
|------|-------------|-------|
| Creator | Creates courses, sets curriculum | 15% when Student-Teachers teach |
| Student | Enrolls in courses, learns | - |
| Student-Teacher | Completed & certified, teaches others | 70% of session fees |
| Platform | PeerLoop | 15% |

---

## Prototype Source Code Locations

| Component | File |
|-----------|------|
| Database | `src/data/database.js` |
| Course Listing UI | `src/components/MainContent.js` |
| Course Detail UI | `src/components/CourseListing.js` |
| Instructor Profile UI | `src/components/MainContent.js` (renderInstructorProfile) |

---

## Technical Implications

### DB-SCHEMA.md Updates Needed

1. Add `rating_count` field to courses table (per-course review count)
2. Add `badge` field to courses table (promotional badge enum)

### COMPONENTS.md Updates Needed

1. Add `CourseBadge` component for displaying promotional badges
2. Update `CourseCard` to include badge display

### PAGES.md Implications

- Course cards should display badge when present
- Course detail should show both rating and ratingCount

---

## Relationship to Other Documents

| Document | Relationship |
|----------|--------------|
| CD-021 | Confirms and extends - this is formal documentation of same schema |
| DB-SCHEMA.md | Add 2 new fields: rating_count, badge |
| COMPONENTS.md | Add CourseBadge component |

---

## Goals Referenced
- GO-001 (flywheel validation)
- GO-003 (sustainable income)

## Stories Impacted
- US-S005 (course detail view - now includes badge)
- CourseCard component display

---

*This document formalizes the data structures from the PeerLoop prototype. Generated December 2025.*
