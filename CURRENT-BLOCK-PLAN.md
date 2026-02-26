# CURRENT-BLOCK-PLAN.md — RATINGS Block

**Block:** RATINGS (Multi-Level Rating & Feedback System)
**Created:** 2026-02-26 Session 291
**Status:** 🔄 IN PROGRESS (20/42 items — 3 of 6 sub-blocks complete)
**Last updated:** 2026-02-26 Session 292

> Delete this file when the full RATINGS block is complete and transfer knowledge to permanent docs.

---

## Progress

| Sub-block | Done | Remaining |
|-----------|------|-----------|
| SCHEMA | 7/7 | 0 |
| SESSION-FEEDBACK | 6/6 | 0 |
| MATERIALS | 7/7 | 0 |
| EXPECTATIONS | 0/7 | 7 |
| DISPLAY | 0/8 | 8 |
| TESTING | 0/7 | 7 |

---

## Design Decisions (Session 291)

**Decision 1: Per-session sub-ratings for ongoing Creator feedback.**
Creators need feedback on their STs and materials *as the course progresses*, not just at completion. Expand `session_assessments` with 3 optional sub-rating columns: `teacher_rating`, `interaction_rating`, `materials_rating` (each 1-5). This gives Creators ongoing visibility into teaching quality and materials effectiveness. Attrition signals emerge naturally (students who stop rating = potential dropout). Sub-ratings are optional (student→teacher direction only; teacher→student keeps single rating).

**Decision 2: Sub-ratings are context only — no relative weighting.**
The 3 per-session sub-ratings and 3 per-course sub-ratings (clarity, relevance, depth) provide qualitative context for Creators. They do NOT affect the overall rating calculation. `student_teachers.rating` = AVG(enrollment_reviews.rating). `courses.rating` = AVG(course_reviews.rating). No weighting formula. The student's experience evolves session to session, making fixed weights unreliable. If weighting is ever needed, it should be Creator-configurable (deferred).

**Decision 3: Sessions ≠ Modules — distinct concepts, properly separated.**
- **Module**: A unit of course curriculum. Created by the Creator. Has content, order, type. Static.
- **Session**: A live tutoring interaction. Scheduled between student and ST. Has a time, duration, recording. Dynamic.
- They are NOT 1:1. One session may cover multiple modules. One module may require multiple sessions. Some modules need no session (self-study).
- Ratings happen at the **session** level (natural touchpoint after live interaction) and at **course completion** level (evaluative summary).
- Future: link sessions to modules for tracking (out of scope for RATINGS).
- Note: EXTRA-SESSIONS added to PLAN.md deferred list (students purchase additional sessions with same teacher).

**Decision 4: Minimum 3 reviews before displaying ratings.**
Below 3 completed reviews, show a "New Teacher" or "New Course" badge instead of a star rating. Prevents single-outlier skew. Applies to both `student_teachers.rating` display and `courses.rating` display. At 3+ reviews the average becomes meaningful. Industry standard (Amazon, Airbnb, Coursera).

**Decision 5: One review response per review (ST or Creator).**
STs can post ONE public response to each enrollment review. Creators can post ONE public response to each course review. Standard on Airbnb, Google Maps, Etsy. Responses are public (prospective students see them). No back-and-forth — not a conversation thread. New `review_responses` table.

**Decision 6: Expectations are private (ST + Creator only).**
Enrollment expectations captured at purchase are internal teaching context. NOT shown publicly alongside the review. Visible to: the student (own), assigned ST, course Creator, admins. Encourages honest goal-setting ("I'm struggling with basics") without public exposure.

**Decision 7: Expectations — current state only, no history table.**
Skip `enrollment_expectations_history` table. The `update_count` + `updated_at` fields track that expectations evolved. Full version history adds complexity without clear MVP benefit. Can be added later if Creators want "show me how this student's goals changed."

---

## Key Concept: Rating Levels

```
ENROLLMENT
    │
    ├─ Capture Expectations (post-purchase, private)
    │
    ├─ Session 1 → Session Rating (overall 1-5)
    │              └─ Sub-ratings: teacher, interaction, materials (1-5 each)
    │              └─ "Update your goals?" prompt
    │
    ├─ Session 2 → Session Rating + Sub-ratings
    │
    └─ ... more sessions ...
    │
    └─ COMPLETION
        ├─ Step 1: Teaching Review (ST rating 1-5 + comment) → student_teachers.rating
        │   └─ ST can post one response
        │
        └─ Step 2: Materials Review (course rating 1-5 + comment) → courses.rating
            └─ Optional sub-ratings: clarity, relevance, depth
            └─ Creator can post one response
```

### Who Rates Whom

| Level | From → To | When | Feeds Into | Required? |
|-------|-----------|------|------------|-----------|
| Session (overall) | Student ↔ ST (mutual) | After each session | `user_stats.average_rating` | Optional |
| Session (sub-ratings) | Student → ST | After each session | Creator analytics | Optional |
| Teaching (completion) | Student → ST | Course completion | `student_teachers.rating` | Prompted |
| Materials (completion) | Student → Course | Course completion | `courses.rating` | Prompted |

### Who Sees What

| Data | Visitors | Students | STs | Creators | Admins |
|------|----------|----------|-----|----------|--------|
| Course rating (3+ reviews) | Star + count | Star + count | Star + count | Star + count + reviews | All |
| Course rating (< 3 reviews) | "New Course" badge | "New Course" badge | "New Course" badge | Raw data + count | All |
| ST rating (3+ reviews) | Star + count | Star + count | Own star + reviews | Their STs' stars + reviews | All |
| ST rating (< 3 reviews) | "New Teacher" badge | "New Teacher" badge | Own raw data | Their STs' raw data | All |
| Completion review comments | Public | Public | Own received | Own course reviews | All |
| Review responses | Public | Public | Own responses | Own responses | All |
| Session sub-ratings | Never | Own only | Own received | Aggregated per-ST | All |
| Expectations | Never | Own only | Assigned students | Own course students | All |

---

## Schema Changes

### Expand `session_assessments` — add sub-ratings:

| Column | Type | Notes |
|--------|------|-------|
| `teacher_rating` | INTEGER CHECK (1-5) | **New** — ST teaching quality (student→teacher only, NULL for teacher→student) |
| `interaction_rating` | INTEGER CHECK (1-5) | **New** — Session interaction quality |
| `materials_rating` | INTEGER CHECK (1-5) | **New** — Course materials quality as presented |

### New table — `course_reviews`:

| Column | Type | Notes |
|--------|------|-------|
| `id` | TEXT PK | Generated ID |
| `enrollment_id` | TEXT FK → enrollments(id) UNIQUE | One review per enrollment |
| `reviewer_id` | TEXT FK → users(id) | The student |
| `course_id` | TEXT FK → courses(id) | The course |
| `rating` | INTEGER NOT NULL CHECK (1-5) | Overall materials rating |
| `comment` | TEXT NOT NULL | Required (min 10 chars) |
| `clarity_rating` | INTEGER CHECK (1-5) | Optional sub-rating |
| `relevance_rating` | INTEGER CHECK (1-5) | Optional sub-rating |
| `depth_rating` | INTEGER CHECK (1-5) | Optional sub-rating |
| `created_at` | TEXT | ISO timestamp |

### Verify `courses` table — rating columns:

| Column | Type | Notes |
|--------|------|-------|
| `rating` | REAL | Already exists in schema — fed by course_reviews |
| `rating_count` | INTEGER DEFAULT 0 | Already exists in schema — count of course_reviews |

### New table — `enrollment_expectations`:

| Column | Type | Notes |
|--------|------|-------|
| `id` | TEXT PK | Generated ID |
| `enrollment_id` | TEXT FK → enrollments(id) UNIQUE | One per enrollment |
| `primary_goal` | TEXT CHECK (enum) | career_change, skill_upgrade, personal_interest, academic, other |
| `timeline` | TEXT CHECK (enum) | under_1_month, 1_to_3_months, 3_to_6_months, no_rush |
| `prior_experience` | TEXT CHECK (enum) | beginner, some_exposure, intermediate, advanced |
| `referral_source` | TEXT CHECK (enum) | search, social, referral, creator_content, other |
| `learning_hopes` | TEXT NOT NULL | Free text (min 20 chars) |
| `additional_notes` | TEXT | Optional free text |
| `created_at` | TEXT | ISO timestamp |
| `updated_at` | TEXT | Last update |
| `update_count` | INTEGER DEFAULT 0 | How many times updated |

### New table — `review_responses`:

| Column | Type | Notes |
|--------|------|-------|
| `id` | TEXT PK | Generated ID |
| `review_type` | TEXT NOT NULL CHECK (enum) | 'enrollment' or 'course' |
| `review_id` | TEXT NOT NULL | FK to enrollment_reviews.id or course_reviews.id |
| `responder_id` | TEXT FK → users(id) | The ST or Creator responding |
| `response` | TEXT NOT NULL | Response text (min 10 chars) |
| `created_at` | TEXT | ISO timestamp |
| UNIQUE | (review_type, review_id) | One response per review |

---

## SCHEMA
*Database tables, types, indexes*

- [x] Add `teacher_rating`, `interaction_rating`, `materials_rating` columns to `session_assessments` in `0001_schema.sql`
- [x] Add `course_reviews` table to `0001_schema.sql` with indexes (enrollment_id, course_id, reviewer_id)
- [x] Verify `courses.rating` and `courses.rating_count` columns exist in schema (already present per DB-SCHEMA.md)
- [x] Add `enrollment_expectations` table to `0001_schema.sql` with index (enrollment_id)
- [x] Add `review_responses` table to `0001_schema.sql` with index (review_type + review_id) and UNIQUE constraint
- [x] Add/update TypeScript types in `src/lib/db/types.ts`: CourseReview, EnrollmentExpectation, ReviewResponse, expand SessionAssessment + fixed EnrollmentReview (missing) + fixed StudentTeacher.rating/rating_count (missing)
- [x] Update seed data in `migrations-dev/0001_seed_dev.sql`: added course_reviews (5), enrollment_expectations (4), review_responses (2), session assessment sub-ratings

## SESSION-FEEDBACK
*Expand per-session ratings with 3 sub-rating dimensions*

- [x] Update `POST /api/sessions/:id/rating` to accept optional `teacher_rating`, `interaction_rating`, `materials_rating` — validates 1-5, stores NULL for teacher→student direction
- [x] Update `SessionCompletedView` UI: collapsible "Rate details" section with Teaching Quality, Interaction, Materials star rows
- [x] Sub-ratings only prompted for student→teacher direction (hidden when teacher rates student, server enforces NULL)
- [x] Session sub-ratings feed into Creator analytics via st-performance endpoint LEFT JOIN on session_assessments
- [x] Add session sub-rating data to `/api/me/creator-analytics/st-performance` — avg teacher/interaction/materials per ST with count
- [x] Update existing session rating tests (+8 API sub-rating tests, +6 UI sub-rating tests, all 15 existing tests still pass)

## MATERIALS
*Course completion materials review (course_reviews table)*

- [x] Create `POST /api/enrollments/:id/course-review` endpoint — auth, validation, duplicate 409, sub-ratings, updateCourseRating()
- [x] Create `GET /api/enrollments/:id/course-review` endpoint — has_review, can_review, review data
- [x] Update `GET /api/courses/:id/reviews` endpoint — now queries course_reviews (was course_testimonials), includes reviewer_name/avatar, paginated
- [x] Implement `updateCourseRating()` function: AVG(course_reviews.rating) → courses.rating, COUNT → courses.rating_count
- [x] Update `CourseReviewModal` to two-step flow: Step 1 = ST review, Step 2 = Materials review, with StarRating component
- [x] Each step has independent "Skip for now" — backdrop click also skips, step counter shown
- [x] Materials review includes optional sub-ratings (clarity, relevance, depth) in collapsible "Rate details" section

## EXPECTATIONS
*Student expectations capture at enrollment (private)*

- [ ] Create `POST /api/enrollments/:id/expectations` endpoint (auth: enrolled student only, validation: learning_hopes min 20 chars)
- [ ] Create `GET /api/enrollments/:id/expectations` endpoint (auth: student, assigned ST, course Creator, or admin)
- [ ] Create `PATCH /api/enrollments/:id/expectations` endpoint (auth: enrolled student only, increments update_count)
- [ ] Add expectations capture UI to post-purchase confirmation flow (modal or inline form after enrollment success)
- [ ] Add "Update your goals?" prompt to `SessionCompletedView` — show current learning_hopes, offer edit
- [ ] Display expectations alongside reviews in Creator/ST dashboard (private context card above review)
- [ ] Expectations capture is encouraged but skippable (student can dismiss and fill in later)

## DISPLAY
*Rating display, badges, and review responses*

- [ ] Course rating on course detail page: star + count when ≥3 reviews, "New Course" badge when <3
- [ ] Course rating badge on browse/search course cards: star + count when ≥3, "New" chip when <3
- [ ] ST rating on ST profile (`/@handle`): star + count when ≥3 reviews, "New Teacher" badge when <3
- [ ] Completion reviews list on ST profile: show review text, rating, date, reviewer name (paginated)
- [ ] Materials feedback view on Creator dashboard: per-course reviews with sub-rating breakdown
- [ ] Session sub-rating trends for Creator analytics: average teacher/interaction/materials per ST over time (simple table or chart)
- [ ] Review response endpoint: `POST /api/reviews/:type/:id/response` (auth: ST for enrollment reviews, Creator for course reviews, one response max)
- [ ] Display review responses inline below the review they respond to (public)

## TESTING

- [ ] Tests for expanded session rating endpoint (sub-ratings accepted, optional, validated 1-5, backward compatible)
- [ ] Tests for `POST /api/enrollments/:id/course-review` (auth, validation, duplicate 409, rating range, comment min length)
- [ ] Tests for `GET /api/courses/:id/reviews` (public listing, pagination, empty state)
- [ ] Tests for expectations endpoints (POST auth, GET privacy, PATCH update_count increment)
- [ ] Tests for `updateCourseRating()` aggregate (correct AVG, correct count, handles first review)
- [ ] Tests for review response endpoint (auth: only ST/Creator, one response max 409, min length)
- [ ] Tests for 3-review minimum display threshold (helper function: returns rating or null based on count)
