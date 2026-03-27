# Peerloop Database Guide

**Source of truth:** `../Peerloop/migrations/0001_schema.sql`
**Seed data:** `../Peerloop/migrations/0002_seed_core.sql` (production), `../Peerloop/migrations-dev/0001_seed_dev.sql` (dev)
**TypeScript types:** `../Peerloop/src/lib/db/types.ts`

> This document explains *why* the schema is the way it is. For column names, types, and constraints, read the SQL directly.

---

## Entity Relationship Overview

```
                    ┌──────────────┐
                    │    users     │
                    └──────┬───────┘
           ┌───────────────┼───────────────────────┐
           │               │                       │
           ▼               ▼                       ▼
    ┌─────────────┐  ┌───────────┐   ┌──────────────────────┐
    │  follows    │  │enrollments│   │teacher_certifications│
    └─────────────┘  └─────┬─────┘   └──────────┬───────────┘
                           │                     │
                           ▼                     │
                    ┌─────────────┐              │
                    │   courses   │◄─────────────┘
                    └──────┬──────┘
                           │
                           ▼
                    ┌─────────────┐
                    │progressions │
                    └──────┬──────┘
                           │
                           ▼
                    ┌─────────────┐
                    │ communities │
                    └─────────────┘
```

### The Core Chain: Community > Progression > Course (CD-036)

This is the most important structural decision in the schema:

- **Communities** are topic-focused groups (e.g., "AI & Machine Learning")
- **Progressions** are learning paths within a community — either multi-course sequences ("Web Dev Fundamentals" with 3 courses) or standalone single-course wrappers
- **Courses** always belong to a progression, which always belongs to a community
- **The Commons** is a system community (`is_system=1`) that all users auto-join on registration

This chain means every course is discoverable through community browsing, and every community has a structured learning path. The `progression_position` field orders courses within a multi-course progression.

---

## Permission Model

The schema uses **capability flags**, not role labels. A user's abilities are determined by four independent boolean columns on the `users` table:

| Column | Meaning | Default |
|--------|---------|---------|
| `can_take_courses` | Can enroll as a student | 1 (on) |
| `can_teach_courses` | Can be certified as a Student-Teacher | 0 (off) |
| `can_create_courses` | Can author courses | 0 (off) |
| `can_moderate_courses` | Can be granted moderator rights | 0 (off) |

Plus `is_admin` for platform administrators.

**Why capabilities, not roles:** Users hold multiple roles simultaneously. A Creator who completes another Creator's course and gets certified to teach it is simultaneously a student, a Student-Teacher, and a Creator. Boolean flags compose naturally; exclusive role enums don't.

**How capabilities are granted:**
- `can_take_courses` — on by default for all users
- `can_teach_courses` — set when admin approves a creator application (enables future teacher certifications)
- `can_create_courses` — set when admin approves a creator application
- `can_moderate_courses` — set when admin or creator appoints as moderator
- `is_admin` — manual database operation only

See `docs/GLOSSARY.md` for the identity hierarchy (Visitor > Student > Student-Teacher > Creator > Admin).

---

## The Enrollment Lifecycle

```
enrolled ──> in_progress ──> completed
   │              │              │
   └──> cancelled └──> disputed  │
                                 ▼
                        (recommend as teacher)
```

**State machine:**
- `enrolled` — payment confirmed, not started
- `in_progress` — at least one module completed or session attended
- `completed` — all required modules done, Teacher recommends
- `cancelled` — student or admin cancelled (with `cancel_reason`)
- `disputed` — payment dispute opened via Stripe

**Re-enrollment:** Students can retake a completed course. A new enrollment row is created (the completed row is retained as history). A partial unique index enforces at most one active enrollment per student+course at the DB level:
```sql
CREATE UNIQUE INDEX idx_enrollments_one_active
  ON enrollments(student_id, course_id)
  WHERE status IN ('enrolled', 'in_progress');
```

**Enrollment guards** (enforced in checkout):
- Creator cannot enroll in own course
- Active teacher (is_active=1 AND teaching_active=1) cannot enroll
- Course must have at least one active teacher (zero teachers → block + notify creator/admins)
- Inactive/paused teachers are treated as regular students and can enroll

**Key relationships:**
- `student_id` — the learner
- `assigned_teacher_id` — the Teacher assigned to this enrollment
- `teacher_certification_id` — which specific certification is teaching (links to rating/stats)
- `progress_percent` — denormalized from `module_progress` table (0-100)
- `recommended_as_teacher` — Teacher flagged this student as ready for certification

---

## The Teacher Certification Model

`teacher_certifications` is the bridge between a user and their authority to teach a specific course.

**How someone becomes a Student-Teacher:**
1. Student completes a course
2. Their assigned ST clicks "Recommend for Certification"
3. The course Creator approves the certification
4. A `teacher_certifications` row is created
5. New students enrolling in that course can be assigned to this ST

**Per-course, not global:** A user certified to teach "Intro to AI" cannot teach "Advanced ML" — each certification is course-scoped. A single user can have many certifications across different courses.

**Rating system:** `rating` and `rating_count` on `teacher_certifications` aggregate from `enrollment_reviews` (course-completion reviews), not from `session_assessments` (per-session ratings). This distinction matters — the overall teaching quality rating comes from students who completed the full course.

**`teaching_active`:** User-controlled toggle. A certified ST can pause accepting new students (e.g., on vacation) without losing certification.

---

## Payment Architecture

### Revenue Split Model

When a student pays for a course, revenue is distributed via `payment_splits`:

| Scenario | Recipient Types | Split |
|----------|----------------|-------|
| Student enrolls with Creator teaching directly | `creator_as_instructor` + `platform` | 85% / 15% |
| Student enrolls with a Student-Teacher | `teacher` + `creator_as_author` + `platform` | 70% / 15% / 15% |

**Table chain:** `transactions` (Stripe payment) > `payment_splits` (who gets what) > `payouts` (when they get it)

- `transactions` — one per Stripe checkout, links to `enrollment_id`
- `payment_splits` — one row per recipient per transaction (2-3 rows per purchase)
- `payouts` — aggregated disbursements via Stripe Connect, linked back to splits via `payout_id`

**Stripe Connect:** Users who earn money (`can_teach_courses` or `can_create_courses`) must complete Stripe Connect onboarding. Their `stripe_account_id`, `stripe_account_status`, and `stripe_payouts_enabled` on the `users` table track this.

### Session Credits

`session_credits` provide free sessions as compensation for disputes, promotions, referrals, or goodwill gestures. Each credit tracks its source, who granted it, and whether it's been redeemed against a specific session.

---

## Two Rating Systems

The schema deliberately separates two types of ratings:

### 1. Session Assessments (`session_assessments`)
- **When:** After each 1-on-1 video session
- **Who:** Mutual — both student and ST rate each other
- **Granularity:** Per-session, with optional sub-ratings (teacher_rating, interaction_rating, materials_rating)
- **Feeds into:** Nothing directly (used for flagging problematic sessions)

### 2. Enrollment Reviews (`enrollment_reviews`)
- **When:** At course completion
- **Who:** Student rates their Student-Teacher
- **Granularity:** One review per enrollment (comprehensive)
- **Feeds into:** `teacher_certifications.rating` (the number shown on ST profiles)

### 3. Course Reviews (`course_reviews`)
- **When:** At course completion (alongside enrollment review)
- **Who:** Student rates the course materials
- **Granularity:** Overall + optional sub-ratings (clarity, relevance, depth)
- **Feeds into:** `courses.rating` (the number shown on course cards)

Students rate teaching quality and materials quality independently. An excellent ST teaching a mediocre course (or vice versa) produces accurate, separated ratings.

### Review Responses (`review_responses`)
- Single public response per review (no back-and-forth)
- STs respond to enrollment_reviews, Creators respond to course_reviews

---

## Video Sessions (BigBlueButton)

The `sessions` table manages 1-on-1 tutoring sessions:

- **Scheduling:** `scheduled_start`/`scheduled_end` with conflict detection in application code
- **BBB fields:** `bbb_meeting_id`, `bbb_internal_meeting_id`, `bbb_attendee_pw`, `bbb_moderator_pw` — rooms are created on-demand when the first participant joins (not at booking time)
- **Recording:** `recording_url` (BBB playback page) populated via webhook; `recording_r2_key` (R2 video file) populated if BBB video format is enabled and replication succeeds; `recording_size_bytes` tracks the R2 file size for admin monitoring
- **Module linkage:** `module_id` links a session to a curriculum module (frozen on completion)

### Session Disputes

Sessions have a full dispute subsystem (added migration 0012):
- `dispute_status`: none > reported > investigating > resolved
- `resolution_type`: ranges from `no_action` to `refund`
- Tracks who reported, who resolved, and when

### Availability

Two tables work together:
- `availability` — recurring weekly slots (e.g., "Tuesdays 2-5pm ET")
- `availability_overrides` — date-specific exceptions (e.g., "blocked March 15" or "extra hours March 20")

Application code merges both to compute bookable slots for any given date.

---

## Moderation System

Three-tier moderation (from docs/POLICIES.md):

| Tier | Who | Scope | Tables |
|------|-----|-------|--------|
| 1 | Admin | Platform-wide | `content_flags`, `moderation_actions`, `user_warnings` |
| 2 | Creator-appointed moderators | Single community | `community_moderators` |
| 3 | All users | Report only | `content_flags` (as reporter) |

**Flow:** User flags content (`content_flags`) > Moderator/admin reviews > Takes action (`moderation_actions`) > Optionally warns user (`user_warnings`)

**Moderator invites** (`moderator_invites`): Admins invite by email with a token-based accept/decline flow. Works for both existing and new users.

---

## Community & Social Features

### Community Resources (`community_resources`)
Shared files, links, and videos within a community. Supports pinning (`is_pinned`) and ordering (`display_order`).

### Follows (`follows`)
User-to-user follows. Bidirectional lookup via separate indexes on `follower_id` and `followed_id`. Feeds into Stream.io timeline feed.

### Course Follows (`course_follows`)
Subscribe to course updates without enrolling. Schema exists; feature not yet implemented.

### Messaging (`conversations`, `conversation_participants`, `messages`)
Direct messaging with `last_read_at` for unread tracking. Message permissions enforced in application code per docs/POLICIES.md section 4 (relationship-based access).

---

## Denormalized Stats

Several tables cache computed values for performance:

| Table | Denormalized Fields | Updated By |
|-------|-------------------|------------|
| `user_stats` | students_taught, courses_created, courses_completed, average_rating | Application code |
| `courses` | student_count, rating, rating_count | Application code on enrollment/review |
| `communities` | member_count, post_count | Application code on join/post |
| `progressions` | course_count, total_duration_minutes, student_count | Application code |
| `platform_stats` | Various counters | Admin or scheduled jobs |

These are convenience caches. The source-of-truth data lives in the normalized tables.

---

## Feature Flags (`features`)

Database-driven feature toggles. Each feature has:
- `enabled` — global on/off
- `allowed_roles` — JSON array of role identifiers (or `["*"]` for all)
- `requires` — dependency chain (e.g., video_sessions requires auth)
- `block` — which development block introduced it

Seed data initializes ~10 feature flags. Application code checks `canAccess(featureId)` on page render.

---

## SQLite DateTime Comparison Caveat

**NEVER use `datetime('now', ...)` in comparisons against stored timestamps.** Use `strftime('%Y-%m-%dT%H:%M:%fZ', 'now', ...)` instead.

**Why:** All timestamps are stored as ISO 8601 strings with a `T` separator (`2026-03-24T20:00:00.000Z`). SQLite's `datetime()` function outputs a space separator (`2026-03-24 20:00:00`). Since SQLite compares TEXT values lexicographically, `T` (ASCII 84) always beats ` ` (ASCII 32), making any ISO timestamp sort as "greater than" any `datetime()` output — regardless of actual time values.

| Pattern | Output Format | Safe for Comparison? |
|---------|---------------|---------------------|
| `datetime('now', '-7 days')` | `2026-03-17 20:00:00` | **NO** — space at position 10 |
| `strftime('%Y-%m-%dT%H:%M:%fZ', 'now', '-7 days')` | `2026-03-17T20:00:00.000Z` | **YES** — matches stored format |
| `date('now', '-7 days')` | `2026-03-17` | **YES** — 10-char prefix, sorts correctly |
| Bound JS param via `.toISOString()` | `2026-03-17T20:00:00.000Z` | **YES** — same format |

**Discovered Conv 027.** Fixed in DATETIME-FIX block.

---

## Webhook Logging (`webhook_log`)

Fire-and-forget payload capture for all inbound webhooks (BBB, BBB Analytics, Stripe). Each webhook handler INSERTs a row at the top of processing before any business logic. Used for:
- Debugging webhook delivery issues
- Examining payload variability across providers
- Generating test fixtures from real payloads

Auth headers are redacted (logged as `<redacted>`) for security. Indexed on `source` and `received_at` for querying by provider or time range.

**Added Conv 037.**

---

## Tables by Domain (46 total)

| Domain | Tables | Count |
|--------|--------|-------|
| Users & Profiles | users, user_qualifications, user_expertise, user_stats, user_interests, user_availability, member_profiles, user_topic_interests | 8 |
| Categories & Topics | categories, topics | 2 |
| Communities | communities, community_members, community_resources, community_moderators | 4 |
| Progressions | progressions | 1 |
| Courses & Curriculum | courses, course_tags, course_objectives, course_includes, course_prerequisites, course_target_audience, course_testimonials, course_curriculum, peerloop_features, session_resources | 10 |
| Homework | homework_assignments, homework_submissions | 2 |
| Enrollments & Progress | enrollments, enrollment_reviews, course_reviews, enrollment_expectations, module_progress, teacher_certifications, certificates, course_follows | 8 |
| Sessions & Scheduling | availability, availability_overrides, sessions, session_assessments, session_attendance, intro_sessions, session_invites | 7 |
| Payments | transactions, payouts, payment_splits, session_credits | 4 |
| Social | follows | 1 |
| Messaging | conversations, conversation_participants, messages | 3 |
| Notifications | notifications | 1 |
| Feed Intelligence | feed_visits, feed_activities | 2 |
| Moderation | content_flags, moderation_actions, user_warnings, moderator_invites | 4 |
| Creator Applications | creator_applications | 1 |
| Platform Config | features, platform_stats, review_responses, webhook_log | 4 |
| Marketing | success_stories, team_members, faq_entries, contact_submissions | 4 |
