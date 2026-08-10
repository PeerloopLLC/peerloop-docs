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
- **System** is a system community (`is_system=1`, formerly "The Commons") that is **admin-only** since SYS-RENAME (Conv 259); auto-join on registration was retired and it is excluded from member feeds and badges

This chain means every course is discoverable through community browsing, and every community has a structured learning path. The `progression_position` field orders courses within a multi-course progression.

### Topic & Tag Taxonomy (Conv 048)

Course discovery and user interest matching use a two-level taxonomy:

- **Topics** (15 rows) — display groups for browsing (e.g., "Full-Stack Development", "AI Coding"). Formerly called "categories."
- **Tags** (55 rows) — atomic interest items within a topic (e.g., "React & Frontend", "AI-Assisted Development"). Formerly called "topics."

**Matching model:** Users select tags during onboarding (`user_tags`). Courses are tagged with tags (`course_tags`, FK-based many-to-many). Communities are tagged the same way (`community_tags`, added Conv 432). Smart feed scoring uses graduated tag overlap: `intersectionCount(courseTags, userTags) / courseTags.size`.

**Why no `courses.category_id`:** The old model had a single FK on `courses` pointing to one category. The new model derives topic membership from `course_tags → tags.topic_id`, allowing a course to appear under multiple topics. One source of truth for course-topic relationships.

**Tag-level storage, topic-level reads.** Every tagged entity stores *tags* and rolls up to *topics* at read time via `tags.topic_id` — `user_tags` (`api/me/full.ts`), `course_tags` (`discovery-rails/compute.ts`, the `/courses` and `/creators` SSR loaders) and `community_tags`. There is no denormalized topic column on any of them.

**`community_tags` (Conv 432, [COMM-TOPICS]):** Explicit interest tags on a community. A community's topics are **explicit ∪ derived** — the derived half walks `progressions → courses → course_tags`, so a community genuinely relates to its courses' topics and self-corrects as those tags change, while the explicit half closes the cold-start hole (a brand-new community with no courses yet). `compute.ts` emits the union as two concatenated correlated scalar subqueries (SQLite has no LATERAL) and `parseTopicIdList` dedupes — the dedupe is load-bearing, since a duplicate would inflate `overlapCount` in `discovery-rails/lanes.ts`.

**Why `courses.primary_topic_id` was removed (Conv 432, reversing Conv 108):** The column's only writer anywhere in the repo was the dev seed — neither create endpoint set it and no PATCH accepted it — so every course created through the product had it NULL and was permanently invisible to the `/courses` topic filter, while the seeded courses responded normally. Conv 108 had re-added it for exactly that filter on the rationale that "all seed courses assigned a topic ID", which was true only because seed courses *were* the whole population. Both catalogs now read the `course_tags → tags.topic_id` roll-up and match **any** claimed topic. A missing column fails loudly; a seed-only-populated one demos perfectly and is broken for all real data.

**Claim caps on other-affecting tag writes:** `src/lib/entity-tags.ts` enforces `MAX_ENTITY_TAGS = 5` and `MAX_ENTITY_TOPICS = 3` on `course_tags` and `community_tags`. Two axes, not one, because over-claiming has two independent payoffs at two granularities: `discovery-rails/lanes.ts` ranks For You by *distinct topic* overlap while `smart-feed/scoring.ts` scores at *tag* granularity, so a cap on either axis alone leaves the other open. `user_tags` is deliberately **uncapped** — interests only change what that user is shown, so over-claiming there is self-limiting. User claims are *rejected* (400); system-chosen defaults (creation pre-seed, derivation backfill) are *truncated* round-robin across topics, which preserves the widest topic coverage that fits.

**Dropped tables:** `user_interests` (was a denormalized sync copy), `user_topic_interests` (replaced by `user_tags`).

**Level column:** `user_tags.level` (beginner/intermediate/advanced) stores a per-tag self-assessment set during onboarding. The TopicPicker enforces the same level for all tags within a topic (per-topic conceptually, per-tag in storage). Designed for future Smart Feed level matching (see PLAN.md: LEVEL-MATCH).

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
- `teaching_request_sent_at` — when the **student** asked to be certified to teach this course (Conv 434 `[TEACH-REQ]`). Deliberately a **separate column** from `recommended_as_teacher`, not an overload: the two sides of the same conversation can be true independently, and the student-facing CTA needs to know which one happened — this stamp is what flips "Teach this course" → "Request sent" on the course card and detail page, and it is also the idempotency guard on `POST /api/me/courses/[courseId]/teaching-request`

---

## The Teacher Certification Model

`teacher_certifications` is the bridge between a user and their authority to teach a specific course.

**How someone becomes a Student-Teacher:**
1. Student completes a course
2. *(optional, Conv 434 `[TEACH-REQ]`)* The student **asks** — `POST /api/me/courses/[courseId]/teaching-request` messages + notifies the course **creator** and stamps `enrollments.teaching_request_sent_at`. This is the flywheel's entry point: certification can only be *initiated* by someone vouching **for** the student, so before this there was no way for them to start it themselves. The creator's queue is `/creating/requests`
3. A **certified Teacher of that course, or the course's Creator**, clicks "Recommend for Certification" (`POST /api/me/certificates/recommend` → a `pending` `certificates` row). The creator arm was added Conv 434 — creators are not reliably certified for their own courses, so without it a request routed to the creator would arrive at someone with no button to press
4. An admin approves the recommendation and the certificate is issued
5. A `teacher_certifications` row is created
6. New students enrolling in that course can be assigned to this ST

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

### Session Attendance (`session_attendance`)

Tracks individual participant join/leave events for each session. Multiple rows per (session, user) pair are allowed to model join → leave → rejoin cycles:

- Each `participant_joined` webhook delivery INSERTs a row with `left_at IS NULL` (open).
- Each `participant_left` delivery closes the most recent open row by setting `left_at`.
- A **partial unique index** (`idx_session_attendance_open_unique ON session_attendance(session_id, user_id) WHERE left_at IS NULL`) enforces at most one *open* row per participant per session. Once a row is closed (`left_at` set), it falls out of the index and a new open row is permitted.
- The INSERT uses `INSERT OR IGNORE` so duplicate `participant_joined` webhook deliveries are silent atomic no-ops — no application-level check required.

`detectOrphanedParticipants()` (Conv 142) scans for sessions past `scheduled_end` that still have open rows and queries BBB to confirm the room is inactive before force-closing them.

**Added partial index + INSERT OR IGNORE:** Conv 142.

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

### Session Analytics (`session_analytics`)

Stores per-session learning analytics delivered by BBB's Learning Analytics callback. When a meeting room is created, the `meta_analytics-callback-url` metadata parameter tells BBB where to POST engagement data after the meeting ends.

**How data arrives:** After a BBB meeting ends, the server sends a JWT-authenticated POST to `/api/webhooks/bbb-analytics`. The handler verifies the HS512 JWT (signed with the BBB shared secret), looks up the session by `meeting_id`, and upserts the analytics row.

**Key columns:**
- `session_id` (UNIQUE, FK → `sessions`) — one analytics row per session
- `analytics_json` — the full BBB analytics payload stored as JSON text. Contains per-attendee metrics: talk time, chat message count, attendance duration, emoji reactions, poll responses, and raise-hand counts
- `duration_seconds` — meeting duration extracted from the payload for quick queries without JSON parsing
- `attendee_count` — number of attendees, also extracted for convenience

**Upsert pattern:** The INSERT uses `ON CONFLICT(session_id) DO UPDATE` because BBB may retry the callback if it doesn't receive a timely 200 response. Retries overwrite the previous row with the latest payload rather than creating duplicates.

**Error handling:** The webhook handler returns HTTP 200 even on internal errors to prevent BBB from entering an unbounded retry loop. Errors are logged server-side.

**Added Conv 037.**

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
Shared files and external links within a community. Schema is parity-aligned with `session_resources`:

- `type` CHECK enum: `document | image | audio | video_link | other`
- Storage split: `r2_key` (file uploads, served via `/api/community-resources/[id]/download`) OR `external_url` (links / video embeds). Exactly one is populated per row.
- File metadata: `size_bytes`, `mime_type` (both nullable; populated for R2-backed rows only)
- `is_pinned` (boolean), `display_order` (int, append-on-insert)
- `download_count` increments on each successful file stream

Upload auth (MVP): community creator OR platform admin (`users.is_admin=1`) only. Download auth: any authenticated community member plus creator/admin. Public/private community flag does not affect download auth.

SSR loaders pre-compute a `downloadUrl` field on each resource: `r2_key ? /api/community-resources/{id}/download : external_url`. The UI renders `href={resource.downloadUrl}` without branching on storage type.

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

## Row Types vs Display Types

When a TypeScript interface maps directly to a database table row, it uses the `Row` suffix (e.g., `CourseTagRow`). When a related interface represents a joined/enriched shape used in UI rendering, it uses the plain name (e.g., `CourseTag`).

| Convention | Example | Shape | Usage |
|------------|---------|-------|-------|
| `*Row` | `CourseTagRow` | `{ course_id, tag_id }` — mirrors the junction table exactly | SQL inserts, raw query results |
| Plain name | `CourseTag` | `{ tag_id, name }` — joined with `tags` table | `.astro` pages, React components, mock data |

**When to apply:** Use the `*Row` suffix when the raw table shape differs from what consumers need and both shapes coexist in the codebase. If only one shape is needed (most tables), use the plain name directly — no `Row` suffix required.

**Established Conv 104** when `CourseTag` was consolidated from inconsistent definitions across the codebase.

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

## Tables by Domain (70 total)

| Domain | Tables | Count |
|--------|--------|-------|
| Users & Profiles | users, user_qualifications, user_expertise, user_stats, user_tags, user_availability, member_profiles | 7 |
| Topics & Tags | topics, tags | 2 |
| Communities | communities, community_members, community_resources, community_moderators | 4 |
| Progressions | progressions | 1 |
| Courses & Curriculum | courses, course_tags, course_objectives, course_includes, course_prerequisites, course_target_audience, course_testimonials, course_curriculum, peerloop_features, session_resources | 10 |
| Homework | homework_assignments, homework_submissions | 2 |
| Enrollments & Progress | enrollments, enrollment_reviews, course_reviews, enrollment_expectations, module_progress, teacher_certifications, certificates, course_follows | 8 |
| Sessions & Scheduling | availability, availability_overrides, sessions, session_assessments, session_attendance, session_analytics, intro_sessions, session_invites | 8 |
| Payments | transactions, payouts, payment_splits, session_credits | 4 |
| Social | follows | 1 |
| Messaging | conversations, conversation_participants, messages | 3 |
| Notifications | notifications | 1 |
| Feed Intelligence | feed_visits, feed_activities, smart_feed_dismissals | 3 |
| Promotions & Announcements | post_promotions, announcements, announcement_dismissals | 3 |
| Moderation | content_flags, moderation_actions, user_warnings, moderator_invites | 4 |
| Creator Applications | creator_applications | 1 |
| Platform Config | features, platform_stats, review_responses, webhook_log | 4 |
| Marketing | success_stories, team_members, faq_entries, contact_submissions | 4 |
