# Ratings & Feedback System

**Type:** Architecture Decision
**Status:** ✅ DECIDED (Core) / 🔄 PLANNING (Extensions)
**Created:** 2026-02-04
**Updated:** 2026-02-04
**Related:** `docs/architecture/messaging.md` (user communication)

---

## Executive Summary

PeerLoop has a multi-level rating system that captures feedback at different touchpoints in the student journey. The key insight is that **session ratings** (quick pulse checks) and **completion ratings** (comprehensive reviews) serve different purposes and feed into different aggregates.

---

## Current State (2026-02-04)

### Rating Levels (Complete Picture)

| Level | What's Rated | Who's Responsible | When | Table | Feeds Into | Comment |
|-------|--------------|-------------------|------|-------|------------|---------|
| **Session** | Individual session | Teacher (mutual) | After session | `session_assessments` | `user_stats` | Optional |
| **Teaching** | Teacher's teaching quality | Teacher | Completion | `enrollment_reviews` | `teacher_certifications.rating` | **Required** |
| **Materials** | Course content quality | Creator | Completion | `course_reviews` | `courses.rating` | **Required** |

### Rating Flow Diagram

```
                          ENROLLMENT
                              │
                    ┌─────────┴─────────┐
                    │                   │
              Capture Expectations     (Post-purchase)
                    │
                    ▼
              ┌───────────┐
              │ Session 1 │──────► Session Rating (Teacher) ──► user_stats
              └───────────┘              │
                    │              Update expectations? (optional)
                    ▼
              ┌───────────┐
              │ Session 2 │──────► Session Rating (Teacher) ──► user_stats
              └───────────┘              │
                    │              Update expectations? (optional)
                    ▼
                   ...
                    │
                    ▼
            ┌─────────────┐
            │ COMPLETION  │
            └─────────────┘
                    │
         ┌──────────┴──────────┐
         │                     │
    Teaching Review       Materials Review
         │                     │
         ▼                     ▼
  teacher_certifications.rating   courses.rating
   (Teacher's per-course)       (Creator's course)
```

### Key Design Decisions

1. **Separate aggregates:** Teaching quality and materials quality are distinct. A great teacher with outdated materials should have those rated separately.

2. **Session ratings are diagnostic:** Quick pulse checks that feed into overall user rating, but don't affect the public Teacher or course ratings.

3. **Completion reviews are evaluative:** Comprehensive reviews with required comments that become the public-facing ratings.

4. **Expectations provide context:** Original and evolving expectations help interpret reviews ("expected hands-on projects, got mostly theory").

---

## Schema

### session_assessments (Existing)
```sql
CREATE TABLE IF NOT EXISTS session_assessments (
  id TEXT PRIMARY KEY,
  session_id TEXT NOT NULL REFERENCES sessions(id),
  assessor_id TEXT NOT NULL REFERENCES users(id),  -- Who rated
  assessee_id TEXT NOT NULL REFERENCES users(id),  -- Who was rated
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,  -- Optional
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);
```

### enrollment_reviews (New - Session 178)
```sql
CREATE TABLE IF NOT EXISTS enrollment_reviews (
  id TEXT PRIMARY KEY,
  enrollment_id TEXT NOT NULL UNIQUE REFERENCES enrollments(id),
  reviewer_id TEXT NOT NULL REFERENCES users(id),  -- The student
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT NOT NULL,  -- Required for completion reviews
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);
```

### teacher_certifications (Updated - Session 178)
```sql
-- Added columns:
rating REAL,                          -- Average from enrollment_reviews (1-5 scale)
rating_count INTEGER NOT NULL DEFAULT 0  -- Number of completion reviews
```

### user_stats (Existing)
```sql
-- Used for overall user rating (from session_assessments):
average_rating REAL NOT NULL DEFAULT 0,
total_reviews INTEGER NOT NULL DEFAULT 0
```

---

## Data Flow

### Session Rating Flow
```
Session ends (status = 'completed')
       ↓
SessionRoom shows SessionCompletedView
       ↓
User clicks stars (1-5) + optional comment
       ↓
POST /api/sessions/:id/rating
       ↓
INSERT INTO session_assessments
       ↓
UPDATE user_stats (assessee's overall rating)
```

### Completion Rating Flow
```
Student marks final module complete
       ↓
LearnTab detects completion (completedCount === totalCount)
       ↓
CourseReviewModal appears (celebration + rating form)
       ↓
User clicks stars (1-5) + required comment
       ↓
POST /api/enrollments/:id/review
       ↓
INSERT INTO enrollment_reviews
       ↓
UPDATE teacher_certifications (Teacher's per-course rating)
```

---

## API Endpoints

### Session Ratings

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/sessions/:id/rating` | POST | Submit session rating |

### Completion Reviews

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/enrollments/:id/review` | GET | Check if review exists |
| `/api/enrollments/:id/review` | POST | Submit completion review |

---

## UI Touchpoints

### 1. SessionCompletedView (Post-Session)
- **Location:** `/session/:id` after session ends
- **UX:** Quick star rating, optional comment
- **Can skip:** Yes (close modal)

### 2. CourseReviewModal (Course Completion)
- **Location:** `/course/:slug/learn` after final module
- **UX:** Celebration header, star rating, required comment
- **Can skip:** Yes ("Skip for now" button)

### 3. StudentDashboard (Review Reminder)
- **Location:** `/dashboard/learning`
- **UX:** Amber banner on completed course cards without reviews
- **CTA:** "Write Review" button

---

## Who Rates Whom?

### Session Assessments (Bidirectional)
- **Student rates Teacher:** After session, student can rate the Teacher
- **Teacher rates Student:** After session, Teacher can rate the student (engagement, punctuality)

Both contribute to `user_stats.average_rating` for each user.

### Completion Reviews (Student → Teacher)
- **Student rates Teacher:** Comprehensive review after completing the course
- Only students can submit completion reviews
- Feeds into `teacher_certifications.rating` (public Teacher rating)

---

## Future Features

### Planned

| Feature | Description | Status |
|---------|-------------|--------|
| **Enrollment Expectations** | Capture student hopes/goals at enrollment | 🔄 Planning |
| **Course Materials Rating** | Rate course content (separate from Teacher) | 🔄 Planning |
| **Review Display on Teacher Profile** | Show completion reviews on Teacher's public profile | 🔄 Planned |
| **Rating Trend Charts** | Show Teacher rating over time in analytics | 🔄 Planned |

### Under Consideration

| Feature | Description | Decision Needed |
|---------|-------------|-----------------|
| **Review Response** | Allow Teachers to respond to reviews | Is this needed? |
| **Review Flagging** | Report inappropriate reviews | Admin moderation flow? |
| **Verified Reviews** | Badge for reviews from verified completions | Already implicit? |
| **Rating Breakdown** | Multi-dimensional ratings (knowledge, communication, patience) | Too complex? |
| **Session Rating Prompts** | Prompt for session rating only on certain conditions | When to trigger? |

---

## Feature: Course Materials Rating

### Purpose

Separate **course content quality** (Creator's work) from **teaching quality** (Teacher's work). This allows:
1. Creators to get feedback specifically on their materials
2. Teachers to not be penalized for weak curriculum they didn't create
3. Students to express nuanced feedback ("great teacher, outdated materials")
4. Platform to surface courses with quality content

### Rating Levels After This Feature

| What | Who's Responsible | Table | Displayed On |
|------|-------------------|-------|--------------|
| **Session** | Teacher (& Student) | `session_assessments` | User profile (overall) |
| **Teaching** | Teacher | `enrollment_reviews` | Teacher profile (per-course) |
| **Materials** | Creator | `course_reviews` | Course page |

### When to Capture

| Timing | Decision |
|--------|----------|
| **Initial** | At course completion (alongside Teacher review) |
| **Updates** | Optional: after completing individual modules |

**UX Integration:** The completion review modal becomes a two-part review:
1. "How was your teacher?" → Teacher rating + comment
2. "How were the course materials?" → Materials rating + comment

### What to Capture

| Field | Type | Required |
|-------|------|----------|
| **Overall materials rating** | 1-5 stars | Yes |
| **Materials comment** | Free text (min 10 chars) | Yes |
| **Content clarity** | 1-5 stars | Optional |
| **Content relevance** | 1-5 stars | Optional |
| **Content depth** | 1-5 stars | Optional |

**Optional sub-ratings** allow more granular feedback:
- **Clarity:** "Was the material easy to understand?"
- **Relevance:** "Was the content practical and applicable?"
- **Depth:** "Was there enough detail for your level?"

### Schema Proposal

```sql
CREATE TABLE IF NOT EXISTS course_reviews (
  id TEXT PRIMARY KEY,
  enrollment_id TEXT NOT NULL UNIQUE REFERENCES enrollments(id) ON DELETE CASCADE,
  reviewer_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  course_id TEXT NOT NULL REFERENCES courses(id) ON DELETE CASCADE,

  -- Main rating
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT NOT NULL,  -- Required

  -- Optional sub-ratings (NULL if not provided)
  clarity_rating INTEGER CHECK (clarity_rating >= 1 AND clarity_rating <= 5),
  relevance_rating INTEGER CHECK (relevance_rating >= 1 AND relevance_rating <= 5),
  depth_rating INTEGER CHECK (depth_rating >= 1 AND depth_rating <= 5),

  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_course_reviews_enrollment_id ON course_reviews(enrollment_id);
CREATE INDEX IF NOT EXISTS idx_course_reviews_course_id ON course_reviews(course_id);
CREATE INDEX IF NOT EXISTS idx_course_reviews_reviewer_id ON course_reviews(reviewer_id);
```

### Course Rating Aggregate

Add to `courses` table:

```sql
-- Add columns to courses table
ALTER TABLE courses ADD COLUMN rating REAL;           -- Average from course_reviews
ALTER TABLE courses ADD COLUMN rating_count INTEGER NOT NULL DEFAULT 0;
```

### API Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/courses/:id/reviews` | GET | List course reviews (public) |
| `/api/enrollments/:id/course-review` | GET | Check if review exists |
| `/api/enrollments/:id/course-review` | POST | Submit course materials review |

### UI Integration

#### Updated Completion Review Modal

```
┌─────────────────────────────────────────────────────────────────┐
│                    🎉 Congratulations!                          │
│           You've completed "React Fundamentals"                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│ Step 1 of 2: Rate your teacher                                  │
│ ─────────────────────────────────────────────────────────────── │
│ How was your experience with Marcus Chen?                       │
│                                                                 │
│              ★ ★ ★ ★ ★                                          │
│                                                                 │
│ ┌─────────────────────────────────────────────────────────────┐ │
│ │ Marcus was patient and explained things clearly...          │ │
│ └─────────────────────────────────────────────────────────────┘ │
│                                                                 │
│                              [ Next → ]                         │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ Step 2 of 2: Rate the course materials                          │
│ ─────────────────────────────────────────────────────────────── │
│ How were the course materials?                                  │
│                                                                 │
│              ★ ★ ★ ★ ☆                                          │
│                                                                 │
│ ┌─────────────────────────────────────────────────────────────┐ │
│ │ Content was good but some examples were outdated...         │ │
│ └─────────────────────────────────────────────────────────────┘ │
│                                                                 │
│ (Optional) Rate specific aspects:                               │
│   Clarity:    ★ ★ ★ ★ ★                                         │
│   Relevance:  ★ ★ ★ ★ ☆                                         │
│   Depth:      ★ ★ ★ ☆ ☆                                         │
│                                                                 │
│                         [ Submit Review ]                       │
└─────────────────────────────────────────────────────────────────┘
```

### Display Locations

| Location | What's Shown |
|----------|--------------|
| **Course Detail Page** | Course materials rating + review excerpts |
| **Course Browse/Search** | Star rating badge on course cards |
| **Creator Dashboard** | Materials feedback for their courses |
| **Creator Analytics** | Rating trends, sub-rating breakdown |

### Design Decisions (Session 178)

| Question | Decision | Rationale |
|----------|----------|-----------|
| When to capture? | At completion (same flow as Teacher review) | Natural moment to reflect |
| Comment required? | Yes (min 10 chars) | Actionable feedback for Creator |
| Sub-ratings? | Optional | Reduces friction while allowing detail |
| Public display? | Yes, on course page | Helps prospective students |

### Open Questions

1. **Module-level ratings?** Should students rate individual modules as they complete them?
2. **Weighting:** Should sub-ratings affect the overall course rating, or just provide context?
3. **Minimum reviews for display:** Show rating only after N reviews? (prevents 1-review skew)

---

## Feature: Enrollment Expectations

### Purpose

Capture student expectations, hopes, and goals **at enrollment time** so that:
1. Creators/Teachers understand what students are hoping to achieve
2. Poor reviews can be contextualized ("expectations were unrealistic" vs "course failed to deliver")
3. Patterns in expectations can inform course improvements
4. Teacher can tailor teaching approach to student goals

### When to Capture

| Timing | Decision |
|--------|----------|
| **Initial capture** | ✅ Post-purchase confirmation page/modal |
| **Updates** | ✅ After each session (expectations evolve) |

**Rationale:** Initial expectations captured at enrollment provide baseline context. Allowing updates after sessions lets students refine their goals as they learn more about what's possible. This creates a timeline of how expectations evolved throughout the course.

### What to Capture

#### Required/Encouraged Fields

| Field | Type | Example |
|-------|------|---------|
| **Primary goal** | Single-select | "Career change", "Skill upgrade", "Personal interest", "Academic requirement" |
| **What do you hope to learn?** | Free text (required, min 20 chars) | "I want to understand React hooks well enough to build my own projects" |
| **Timeline expectation** | Single-select | "< 1 month", "1-3 months", "3-6 months", "No rush" |

#### Optional Fields

| Field | Type | Example |
|-------|------|---------|
| **Prior experience** | Single-select | "Complete beginner", "Some exposure", "Intermediate", "Advanced" |
| **How did you hear about this course?** | Single-select | "Search", "Social", "Referral", "Creator's content" |
| **Anything else?** | Free text | "I'm dyslexic, so I learn better with video than reading" |

### Schema Proposal

```sql
-- Current expectations (can be updated after each session)
CREATE TABLE IF NOT EXISTS enrollment_expectations (
  id TEXT PRIMARY KEY,
  enrollment_id TEXT NOT NULL UNIQUE REFERENCES enrollments(id) ON DELETE CASCADE,

  -- Structured fields
  primary_goal TEXT CHECK (primary_goal IN ('career_change', 'skill_upgrade', 'personal_interest', 'academic', 'other')),
  timeline TEXT CHECK (timeline IN ('under_1_month', '1_to_3_months', '3_to_6_months', 'no_rush')),
  prior_experience TEXT CHECK (prior_experience IN ('beginner', 'some_exposure', 'intermediate', 'advanced')),
  referral_source TEXT CHECK (referral_source IN ('search', 'social', 'referral', 'creator_content', 'other')),

  -- Free text fields
  learning_hopes TEXT NOT NULL,  -- What do you hope to learn? (required)
  additional_notes TEXT,          -- Anything else? (optional)

  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT,  -- Last update timestamp
  update_count INTEGER NOT NULL DEFAULT 0  -- Track how many times updated
);

CREATE INDEX IF NOT EXISTS idx_enrollment_expectations_enrollment_id
  ON enrollment_expectations(enrollment_id);

-- Optional: History of expectation changes (if we want full audit trail)
CREATE TABLE IF NOT EXISTS enrollment_expectations_history (
  id TEXT PRIMARY KEY,
  expectation_id TEXT NOT NULL REFERENCES enrollment_expectations(id) ON DELETE CASCADE,
  session_id TEXT REFERENCES sessions(id),  -- Which session triggered the update (NULL for initial)

  -- Snapshot of fields at this point
  primary_goal TEXT,
  timeline TEXT,
  learning_hopes TEXT,
  additional_notes TEXT,

  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_expectations_history_expectation_id
  ON enrollment_expectations_history(expectation_id);
```

**Note:** The history table is optional but recommended. It lets Creator/Teacher see how a student's expectations evolved: "Initially wanted career change, now focused on specific skills."

### How It Connects to Reviews

When viewing a completion review, the Creator/Teacher can see the student's original expectations:

```
┌─────────────────────────────────────────────────────────────────┐
│ Review from Sarah Chen                              ★★★☆☆ (3/5) │
├─────────────────────────────────────────────────────────────────┤
│ "The course was okay but I was hoping for more hands-on        │
│ projects. Most of it was theory."                               │
├─────────────────────────────────────────────────────────────────┤
│ 📋 Original Expectations (captured at enrollment):              │
│                                                                 │
│ Goal: Skill upgrade                                             │
│ Timeline: 1-3 months                                            │
│ Prior experience: Some exposure                                 │
│                                                                 │
│ "I want to build real projects, not just learn concepts.        │
│ I already know the basics from YouTube."                        │
└─────────────────────────────────────────────────────────────────┘
```

**Insight:** The review makes more sense now - Sarah wanted hands-on projects, had some prior experience, and felt the course was too theoretical. This is actionable feedback.

### API Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/enrollments/:id/expectations` | GET | Get expectations (if exists) |
| `/api/enrollments/:id/expectations` | POST | Submit expectations |
| `/api/enrollments/:id/expectations` | PATCH | Update expectations (if allowed) |

### UI Touchpoints

| Location | Purpose | When |
|----------|---------|------|
| **Post-Purchase Page** | Initial expectations capture | After enrollment completes |
| **Session Rating View** | "Update your goals?" option | After each session ends |
| **Course Learn Page** | Banner if expectations not captured | First visit without expectations |
| **Teacher Pre-Session View** | Show student's expectations | Before/during first session |
| **Creator Dashboard** | View all student expectations | On demand |
| **Teacher Dashboard** | View assigned students' expectations | On demand |
| **Review View** | Show expectations alongside review | When Creator/Teacher views feedback |

### Session Rating Integration

When a student rates a session, include an optional prompt:

```
┌─────────────────────────────────────────────────────────────────┐
│ How was your session with Marcus?                    ★★★★★     │
├─────────────────────────────────────────────────────────────────┤
│ Comment (optional):                                             │
│ ┌─────────────────────────────────────────────────────────────┐ │
│ │ Great session! Finally understanding async/await.          │ │
│ └─────────────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────────┤
│ 📝 Update your learning goals? (optional)                       │
│                                                                 │
│ Your current goal: "Understand React hooks for personal projects"│
│                                                                 │
│ [ Edit Goals ]  [ Keep as is ]                                  │
└─────────────────────────────────────────────────────────────────┘
```

This natural touchpoint after each session lets students refine expectations without a separate prompt.

### Analytics Opportunities

With expectations captured, creators can analyze:

| Metric | Value |
|--------|-------|
| Goal distribution | "60% career change, 30% skill upgrade, 10% personal" |
| Timeline expectations | "Most students expect 1-3 months" |
| Experience level mismatch | "40% of poor reviews from 'beginners' - course may be too advanced" |
| Referral sources | "Search converts better than social" |

### Design Decisions (Session 178)

| Question | Decision | Rationale |
|----------|----------|-----------|
| When to capture? | Post-purchase confirmation | Fresh motivation, separated from payment stress |
| Editable? | Yes, after each session | Expectations evolve as students learn |
| Teacher visibility? | Yes, before first session | Helps Teacher tailor approach to student goals |
| Mid-course check-in? | No | Session ratings with comments provide enough touchpoints |
| Referral source? | Eventually (optional field) | Useful for marketing analytics |

### Open Questions

1. **Privacy:** Should students be able to hide expectations from public review display?
2. **Expectation history:** Should we store a versioned history of expectation changes, or just the current state?
3. **Notification:** Should Teacher be notified when a student updates their expectations?

---

## Design Questions (Open)

### 1. Should session ratings affect Teacher rating at all?

**Current:** No, only completion reviews affect `teacher_certifications.rating`

**Alternative:** Weighted blend (70% completion + 30% session avg)

**Pros of current:** Cleaner, more meaningful, matches industry standards (Airbnb, Coursera)
**Cons of current:** New Teachers have no rating until first completion

### 2. How to handle course content rating?

Should we add a separate rating for the **course itself** (curriculum quality) vs the **Teacher** (teaching quality)?

**Options:**
- A) Single rating covers both (current)
- B) Separate `course_reviews` table for content quality
- C) Add multi-dimensional rating to completion review (course: X, teacher: Y)

### 3. What happens when enrollment has no Teacher assigned?

Currently `enrollment.assigned_teacher_id` can be NULL (self-guided learning).

**Options:**
- A) No review prompt (current implementation checks for teacher)
- B) Still prompt, but rate the course/creator instead
- C) Rate only course content, not teaching

### 4. How to bootstrap Teacher ratings?

New Teachers have no rating until a student completes a course (could be weeks/months).

**Options:**
- A) Show "New Teacher" badge instead of rating
- B) Include session ratings until first completion review
- C) Creator endorsement/rating during certification

---

## Implementation Notes

### Weighted Average Calculation (teacher_certifications)

When a Teacher teaches multiple courses, the API calculates a weighted average:

```sql
SELECT
  CASE WHEN SUM(rating_count) > 0
    THEN SUM(rating * rating_count) / SUM(rating_count)
    ELSE NULL
  END as avg_rating,
  SUM(rating_count) as total_ratings
FROM teacher_certifications
WHERE user_id = ? AND is_active = 1
```

This ensures a Teacher with 50 ratings in one course isn't skewed by 2 ratings in another.

### Review Update Trigger

`updateTeacherRating()` is called after each new enrollment_review:

```typescript
async function updateTeacherRating(db: D1Database, teacherUserId: string, courseId: string) {
  const stats = await queryFirst(db,
    `SELECT AVG(er.rating) as avg_rating, COUNT(*) as total
     FROM enrollment_reviews er
     JOIN enrollments e ON er.enrollment_id = e.id
     WHERE e.assigned_teacher_id = ? AND e.course_id = ?`,
    [teacherUserId, courseId]
  );

  if (stats && stats.total > 0) {
    await db.prepare(
      `UPDATE teacher_certifications
       SET rating = ?, rating_count = ?
       WHERE user_id = ? AND course_id = ?`
    ).bind(stats.avg_rating, stats.total, teacherUserId, courseId).run();
  }
}
```

---

## Related Pages

| Code | Page | Relevance |
|------|------|-----------|
| SROM | `/session/:id` | Session rating after completion |
| CCNT | `/course/:slug/learn` | Completion review modal |
| STDR | `/dashboard/learning` | Review reminder for students |
| TANA | `/teaching/analytics` | Teacher rating display |
| PROF | `/@handle` | Teacher profile rating display |

---

## References

- Session 178: Initial implementation discussion
- `/api/sessions/:id/rating` - Session rating endpoint
- `/api/enrollments/:id/review` - Completion review endpoint
- `CourseReviewModal.tsx` - Completion review UI
- `SessionCompletedView.tsx` - Session rating UI
