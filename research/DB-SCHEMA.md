# PeerLoop - Database Schema (DEPRECATED)

> **DEPRECATED — Session 359 (2026-03-07)**
> This file is no longer maintained. Use these instead:
> - **Schema (source of truth):** `../Peerloop/migrations/0001_schema.sql`
> - **Design rationale:** `research/DB-GUIDE.md`
> - **TypeScript types:** `../Peerloop/src/lib/db/types.ts`
>
> This file is kept for historical reference only. It contains stale column names (pre-TERMINOLOGY rename) and documents 23 tables that were never built.

**Version:** v7 (FINAL — no further updates)
**Primary Source:** CD-021 (Database Schema Sample), Service Research Docs

---

## Entity Overview

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   users     │────<│enrollments  │>────│  courses    │
└─────────────┘     └─────────────┘     └─────────────┘
      │                                       │
      │ 1:N                              N:1  │
      ▼                                       ▼
┌─────────────┐                        ┌─────────────┐
│qualifications│                        │progressions │
└─────────────┘                        └─────────────┘
      │                                       │
      │ 1:N                              N:1  │
      ▼                                       ▼
┌─────────────┐                        ┌─────────────┐
│  expertise  │                        │ communities │
│   (tags)    │                        └─────────────┘
└─────────────┘                               │
      │                                       │ 1:N
      └──────────────────┬────────────────────┘
                         ▼
                  ┌─────────────┐
                  │ community_  │
                  │  members    │
                  └─────────────┘
```

**Community → Progression → Course Chain (CD-036):**
- Communities contain progressions (learning paths)
- Progressions contain courses (ordered sequence)
- Users join communities and enroll in courses

---

## Core Entities

### users

Primary user table. Roles are additive via boolean flags (`is_student`, `is_teacher`, `is_creator`, `is_admin`, `is_moderator`) - users can hold multiple roles simultaneously.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | CD-021 | Primary key |
| email | string | Yes | US-P007 | Unique, for auth |
| password_hash | string | Yes | US-P007 | Hashed password |
| name | string | Yes | CD-021 | Display name |
| handle | string | Yes | CD-018 | Unique @handle (e.g., @gabriel) |
| title | string | No | CD-021 | Professional title |
| avatar_url | string | No | CD-021 | Profile image URL |
| bio | text | No | CD-021 | Extended biography |
| bio_short | string(160) | No | CD-018 | Short bio for cards |
| teaching_philosophy | text | No | CD-025 | Instructor's teaching approach (for creators) |
| website | string | No | CD-021 | External website URL |
| is_student | boolean | Yes | CD-003 | Can enroll in courses (default: true) |
| is_teacher | boolean | Yes | CD-018 | Certified to teach courses (default: false) |
| is_creator | boolean | Yes | CD-017 | Can create courses (default: false) |
| is_admin | boolean | Yes | CD-003 | Platform admin (default: false) |
| is_moderator | boolean | Yes | CD-010 | Community moderator (default: false) |
| privacy_public | boolean | Yes | CD-018 | Profile visibility toggle (default: false = Private) |
| email_verified | boolean | Yes | US-P013 | Email verification status |
| email_status | enum | No | tech-004 | valid, bounced (from Resend webhooks) |
| marketing_opt_out | boolean | No | tech-004 | Opted out via spam complaint |
| stripe_account_id | string | No | tech-003 | Stripe Connect account ID |
| stripe_account_status | enum | No | tech-003 | pending, active, restricted |
| stripe_payouts_enabled | boolean | No | tech-003 | Can receive payouts |
| instructor_feed_enabled | boolean | No | 2026-01-20 | Instructor feed enabled (Stream.io) |
| instructor_feed_created_at | timestamp | No | 2026-01-20 | When instructor feed was first enabled |
| created_at | timestamp | Yes | - | Record creation |
| updated_at | timestamp | Yes | - | Last update |

**Indexes:** email (unique), handle (unique), stripe_account_id (unique)

**Source:** CD-021 (instructorsDatabase), CD-018 (Student Profile System), tech-003 (Stripe Connect), tech-004 (Resend)

---

### user_qualifications

Creator/instructor credentials and certifications.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| user_id | uuid | Yes | CD-021 | FK to users |
| sentence | text | Yes | CD-021 | Full credential statement |
| display_order | int | Yes | - | Sort order on profile |
| created_at | timestamp | Yes | - | Record creation |

**Source:** CD-021 (qualifications array)

---

### user_expertise

Expertise/specialty tags for creators and teachers.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| user_id | uuid | Yes | CD-021 | FK to users |
| tag | string | Yes | CD-021 | Expertise tag (e.g., "AI Prompting") |

**Indexes:** user_id, tag (unique together)

**Source:** CD-021 (expertise array), US-C036

---

### user_stats

Aggregated statistics for users (may be computed view or cached).

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| user_id | uuid | Yes | CD-021 | FK to users, primary key |
| students_taught | int | Yes | CD-021 | Total students taught |
| courses_created | int | Yes | CD-021 | Courses created (creators) |
| courses_completed | int | Yes | - | Courses completed (students) |
| average_rating | decimal | Yes | CD-021 | Average rating received |
| total_reviews | int | Yes | CD-021 | Total reviews received |
| updated_at | timestamp | Yes | - | Last calculation |

**Note:** Consider implementing as computed view for real-time accuracy.

**Source:** CD-021 (stats object), CD-018

---

### user_interests

Student interest tags for content matching.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| user_id | uuid | Yes | CD-018 | FK to users |
| tag | string | Yes | CD-018 | Interest tag |

**Source:** CD-018 (3-5 interest tags per student)

---

### moderator_invites

Two-step moderator invite flow: Admin invites by email → invitee accepts/declines.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| email | string | Yes | Brian Review | Invitee email address |
| invited_by_user_id | uuid | Yes | Brian Review | FK to users (admin who sent invite) |
| token | string | Yes | Brian Review | Unique invite token for URL |
| status | enum | Yes | Brian Review | pending, accepted, declined, expired |
| accepted_by_user_id | uuid | No | Brian Review | FK to users (when accepted) |
| sent_at | timestamp | Yes | Brian Review | When invite was sent |
| accepted_at | timestamp | No | Brian Review | When invite was accepted |
| expires_at | timestamp | Yes | Brian Review | Token expiration (e.g., 7 days) |
| created_at | timestamp | Yes | - | Record creation |

**Indexes:** email, token (unique), status

**Flow:**
1. Admin creates invite → record created with status=pending, email sent via Resend
2. Invitee clicks link → token validated, shown accept/decline UI
3. If user exists: account linked as moderator
4. If new user: signup flow → account created with is_moderator=true
5. Status updated to accepted/declined

**Source:** Brian Review 2025-12-26

---

### creator_applications

Self-service creator application workflow. Users apply to become creators; admins review and approve or deny.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| user_id | uuid | Yes | Session 244 | FK to users (applicant) |
| expertise_areas | string | Yes | Session 244 | Comma-separated subject tags |
| teaching_experience | text | Yes | Session 244 | Free text |
| course_ideas | text | Yes | Session 244 | Free text |
| portfolio_url | string | No | Session 244 | Optional external link |
| motivation | text | Yes | Session 244 | Free text |
| status | enum | Yes | Session 244 | pending, approved, denied |
| submitted_at | timestamp | Yes | Session 244 | When application was submitted |
| reviewed_at | timestamp | No | Session 244 | When admin reviewed |
| reviewed_by_user_id | uuid | No | Session 244 | FK to users (admin reviewer) |
| admin_notes | text | No | Session 244 | Internal admin notes |
| denial_reason | text | No | Session 244 | User-facing denial feedback |
| created_at | timestamp | Yes | - | Record creation |
| updated_at | timestamp | Yes | - | Record update |

**Indexes:** user_id, status, submitted_at

**No UNIQUE on user_id** — denied users can reapply. One pending application at a time enforced at API layer.

**Flow:**
1. User submits application → status=pending, admins notified
2. Admin reviews → approve (sets users.can_create_courses=1) or deny (with optional reason)
3. Denied users can submit new applications

**Source:** Session 244

---

### follows

Social graph - who follows whom.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| follower_id | uuid | Yes | CD-018 | FK to users (who is following) |
| followed_id | uuid | Yes | CD-018 | FK to users (who is followed) |
| created_at | timestamp | Yes | - | When follow occurred |

**Indexes:** follower_id, followed_id (unique together)

**Source:** CD-018 (social graph), US-S048

---

### course_follows

Users following courses (not enrolled, just following).

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| user_id | uuid | Yes | CD-018 | FK to users |
| course_id | uuid | Yes | CD-018 | FK to courses |
| created_at | timestamp | Yes | - | When follow occurred |

**Source:** CD-018, US-S006 (Follow Course action)

---

## Course Entities

### courses

Core course information.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | CD-021 | Primary key |
| creator_id | uuid | Yes | CD-021 | FK to users (instructorId) |
| title | string | Yes | CD-021 | Course title |
| slug | string | Yes | CD-025 | URL-friendly identifier (e.g., "intro-to-claude-code") |
| tagline | string(150) | No | CD-025 | Short marketing text (e.g., "Master AI-powered coding...") |
| description | text | Yes | CD-021 | Extended description |
| duration | string | Yes | CD-021 | Human-readable (e.g., "6 weeks") |
| duration_weeks | int | No | CD-021 | Numeric weeks for filtering |
| total_duration | string | No | CD-025 | Total time (e.g., "3 hours") for short courses |
| session_count | int | No | CD-025 | Number of live sessions (e.g., 2) |
| module_count | int | No | CD-025 | Number of modules |
| lesson_count | int | No | CD-025 | Number of lessons |
| format | string | No | CD-025 | Delivery format (e.g., "Live 1-on-1 sessions") |
| level | enum | Yes | CD-021 | beginner, intermediate, advanced |
| price_cents | int | Yes | CD-021 | Price in cents (e.g., 39900 = $399) |
| currency | string(3) | Yes | CD-025 | Currency code (e.g., "USD") - default "USD" |
| thumbnail_url | string | No | CD-021 | Course image URL |
| category_id | uuid | Yes | CD-021 | FK to categories |
| rating | decimal | No | CD-021 | Average rating (4.5-5.0) |
| rating_count | int | No | CD-022 | Number of reviews for this course |
| student_count | int | Yes | CD-021 | Enrollment count |
| badge | enum | No | CD-022 | Promotional badge: popular, new, bestseller, featured, null |
| lifetime_access | boolean | Yes | CD-025 | Lifetime access to materials (default true) |
| has_certificate | boolean | Yes | CD-025 | Awards certificate on completion |
| certificate_name | string | No | CD-025 | Certificate title (e.g., "Certificate of Completion") |
| is_active | boolean | Yes | CD-004 | Course available for enrollment |
| is_retired | boolean | Yes | US-C004 | Course retired by creator |
| discussion_feed_enabled | boolean | No | 2026-01-20 | Course discussion feed enabled (Stream.io) |
| discussion_feed_created_at | timestamp | No | 2026-01-20 | When discussion feed was first enabled |
| created_at | timestamp | Yes | - | Record creation |
| updated_at | timestamp | Yes | - | Last update |

**Indexes:** creator_id, category_id, level, is_active, slug (unique)

**Source:** CD-021 (coursesDatabase), CD-025 (real course data)

---

### categories

Course category taxonomy.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| name | string | Yes | CD-021 | Category name |
| slug | string | Yes | - | URL-friendly name |
| display_order | int | Yes | - | Sort order |

**Sample data from CD-021:** AI & Product Management, Machine Learning, Computer Vision, NLP, Data Science, Business Analytics, Backend Development, Cloud Computing, Full-Stack Development, DevOps, System Design, AI & Robotics, AI in Healthcare, AI Coding, AI & Prompt Engineering

**Source:** CD-021 (category field), US-S058

---

### course_tags

Course topic tags for search and filtering.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| course_id | uuid | Yes | CD-021 | FK to courses |
| tag | string | Yes | CD-021 | Topic tag |

**Source:** CD-021 (tags array)

---

### topics

Curated subtopics linked to parent categories. Used for member onboarding interest selection and discover page filtering.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key (top-NNN) |
| category_id | uuid | Yes | Session 252 | FK to categories |
| name | string | Yes | Session 252 | Topic display name |
| slug | string | Yes | Session 252 | URL-friendly name (unique) |
| display_order | int | Yes | Session 252 | Sort order within category |
| is_active | boolean | Yes | Session 252 | Soft toggle (default: 1) |

**Note:** ~3-5 topics per category, ~55 total. Admin-controlled curated taxonomy.

**Source:** Session 252 (member onboarding feature)

---

### member_profiles

Member onboarding questionnaire answers. One row per user, created on first onboarding save.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| user_id | uuid | Yes | Session 252 | PK, FK to users |
| primary_goal | enum | No | Session 252 | learn, teach, both |
| referral_source | string | No | Session 252 | How they found Peerloop |
| profession | string | No | Session 252 | Freeform, max 100 chars |
| onboarding_completed_at | timestamp | No | Session 252 | NULL = not completed |
| created_at | timestamp | Yes | - | Record creation |
| updated_at | timestamp | Yes | - | Last update |

**Source:** Session 252 (member onboarding feature)

---

### user_topic_interests

Links users to topics with per-category experience level. Populated during onboarding.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| user_id | uuid | Yes | Session 252 | FK to users |
| topic_id | uuid | Yes | Session 252 | FK to topics |
| experience_level | enum | Yes | Session 252 | beginner, intermediate, advanced |
| created_at | timestamp | Yes | - | Record creation |

**Unique constraint:** (user_id, topic_id)

**Source:** Session 252 (member onboarding feature)

---

### course_objectives

Learning objectives ("What you'll learn").

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| course_id | uuid | Yes | CD-021 | FK to courses |
| objective | text | Yes | CD-021 | Learning objective statement |
| display_order | int | Yes | - | Sort order |

**Source:** CD-021 (learningObjectives array), US-S059

---

### course_includes

What's included with the course.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| course_id | uuid | Yes | CD-021 | FK to courses |
| item | string | Yes | CD-021 | Included item description |
| display_order | int | Yes | - | Sort order |

**Sample items from CD-021:** Full course access, 1-on-1 peer teaching sessions, Certificate on completion, Lifetime access to materials, Access to prompt library templates, Discord community access

**Source:** CD-021 (includes array), US-S060

---

### course_prerequisites

Course prerequisites with tiered categorization (from CD-025).

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| course_id | uuid | Yes | CD-025 | FK to courses |
| type | enum | Yes | CD-025 | required, nice_to_have, not_required |
| content | string | Yes | CD-025 | Prerequisite statement |
| display_order | int | Yes | - | Sort order within type |

**Sample data from CD-025 (Intro to Claude Code):**
- **required:** "Computer with terminal (Windows or Mac)", "Claude account (Pro or Max plan)"
- **nice_to_have:** "Basic computer navigation skills"
- **not_required:** "No coding experience needed", "No command-line knowledge required"

**Source:** CD-025 (prerequisites section)

---

### course_target_audience

Who the course is designed for.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| course_id | uuid | Yes | CD-025 | FK to courses |
| description | string | Yes | CD-025 | Target audience description |
| display_order | int | Yes | - | Sort order |

**Sample data from CD-025:**
- "Non-coders wanting to use AI for development"
- "Vibe coders looking to enhance productivity"
- "Professionals wanting to automate tasks with AI"
- "Beginners curious about AI coding tools"

**Source:** CD-025 (target_audience section)

---

### course_testimonials

Student testimonials for courses.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| course_id | uuid | Yes | CD-025 | FK to courses |
| quote | text | Yes | CD-025 | Testimonial quote |
| student_name | string | Yes | CD-025 | Student first name |
| student_role | string | No | CD-025 | Student role/title (e.g., "Course Graduate", "Entrepreneur") |
| is_featured | boolean | Yes | - | Show on course page |
| created_at | timestamp | Yes | - | When submitted |

**Sample data from CD-025:**
- "I went from knowing nothing about coding to building my first web app in just two sessions." - Sarah, Course Graduate
- "The hands-on approach is perfect. You're not just watching - you're building real things from day one." - Marcus, Now a Teacher

**Source:** CD-025 (curriculum.md testimonials section)

---

### course_curriculum

Course modules/lessons structure.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| course_id | uuid | Yes | CD-021 | FK to courses |
| session_number | int | No | CD-025 | Live session grouping (e.g., 1, 2) |
| title | string | Yes | CD-021 | Module title |
| description | text | Yes | CD-021 | Module description |
| duration | string | Yes | CD-021 | Duration (e.g., "2h 30min", "Week 1", "20 min") |
| learning_objectives | text | No | CD-025 | Module-level objectives (bullet points or JSON array) |
| topics_covered | text | No | CD-025 | Topics covered in module (bullet points or JSON array) |
| hands_on_exercise | text | No | CD-025 | Description of hands-on exercise |
| video_count | int | No | CD-021 | Number of videos |
| reading_count | int | No | CD-021 | Number of readings |
| has_assessment | boolean | No | CD-021 | Module has assessment |
| module_order | int | Yes | - | Sort order within course |
| video_url | string | No | CD-019 | External video link (YouTube/Vimeo) |
| document_url | string | No | CD-019 | External doc link (Google Drive/Notion) |

**Note:** `session_number` groups modules for live session courses (e.g., Session 1 contains modules 1-4, Session 2 contains modules 5-7).

**Source:** CD-021 (curriculum array), CD-019 (Course Content Delivery), CD-025 (real course data)

---

### peerloop_features

PeerLoop-specific course features (1-on-1 teaching model).

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| course_id | uuid | Yes | CD-021 | FK to courses, primary key |
| one_on_one_teaching | boolean | Yes | CD-021 | Supports 1-on-1 peer teaching |
| certified_teachers | boolean | Yes | CD-021 | Has certified Teachers |
| earn_while_teaching | boolean | Yes | CD-021 | Students can earn by teaching |
| teacher_commission | int | Yes | CD-021 | Commission % (e.g., 70) |

**Source:** CD-021 (peerloopFeatures object)

---

## Enrollment & Progress

### enrollments

Student course enrollments.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| student_id | uuid | Yes | - | FK to users |
| course_id | uuid | Yes | - | FK to courses |
| assigned_teacher_id | uuid | No | US-S061 | FK to users (assigned teacher's user ID) |
| teacher_certification_id | uuid | No | Session 328 | FK to teacher_certifications (teacher certification record active at enrollment) |
| status | enum | Yes | - | enrolled, in_progress, completed, cancelled |
| enrolled_at | timestamp | Yes | - | Enrollment date |
| completed_at | timestamp | No | - | Completion date |
| cancelled_at | timestamp | No | - | Cancellation date |
| cancel_reason | text | No | US-S015 | Reason for cancellation |

**Source:** CD-003, CD-019

---

### module_progress

Student progress through course modules.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| enrollment_id | uuid | Yes | - | FK to enrollments |
| module_id | uuid | Yes | - | FK to course_curriculum |
| is_complete | boolean | Yes | CD-019 | Self-marked completion |
| completed_at | timestamp | No | - | When marked complete |

**Source:** CD-019 (checkbox progress tracking), US-S055

---

### teacher_certifications

Teacher certifications per course.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| user_id | uuid | Yes | CD-021 | FK to users |
| course_id | uuid | Yes | CD-021 | FK to courses |
| certified_date | date | Yes | CD-021 | When certified |
| students_taught | int | Yes | CD-021 | Count of students taught |
| is_active | boolean | Yes | - | Admin-controlled certification status |
| approved_by_user_id | uuid | Yes | CD-012 | FK to users (creator who approved) |
| rating | real | No | - | Average rating (1-5), NULL if unrated |
| rating_count | int | Yes | - | Number of ratings received |
| teaching_active | boolean | Yes | S-T-CALENDAR | User-controlled: 1 = accepting students, 0 = paused |

**Source:** CD-021 (studentTeachers array), CD-018, S-T-CALENDAR block (historical block name)

**Two "active" fields:** `is_active` is admin-controlled (suspend/restore certification). `teaching_active` is user-controlled (pause/resume accepting students for this course). See `docs/as-designed/availability-calendar.md`.

---

## Sessions & Scheduling

### availability

Teacher availability slots (recurring weekly patterns with optional duration).

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| user_id | uuid | Yes | CD-015 | FK to users (Teacher or Creator) |
| day_of_week | int | Yes | - | 0-6 (Sunday-Saturday) |
| start_time | time | Yes | - | Slot start time (HH:MM) |
| end_time | time | Yes | - | Slot end time (HH:MM) |
| timezone | string | Yes | US-P022 | User's timezone |
| is_recurring | boolean | Yes | - | Weekly recurring slot |
| start_date | date | No | Session 288 | First occurrence (ISO), NULL = indefinite |
| repeat_weeks | int | No | Session 288 | Weeks to repeat, NULL = indefinite |

**Source:** CD-015 (Calendar/Scheduling), US-C006, US-T001

### availability_overrides

Date-specific availability changes that override recurring rules.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| user_id | uuid | Yes | Session 288 | FK to users (Teacher or Creator) |
| date | date | Yes | - | Specific date (ISO, e.g., "2026-03-15") |
| start_time | time | No | - | HH:MM, NULL if blocking |
| end_time | time | No | - | HH:MM, NULL if blocking |
| is_available | boolean | Yes | - | 1 = available with times, 0 = blocked |
| created_at | timestamp | Yes | - | Auto-set |

**Index:** `(user_id, date)` for efficient date lookup
**Source:** Session 288 (S-T-CALENDAR block)

---

### sessions

Booked tutoring sessions.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| enrollment_id | uuid | Yes | - | FK to enrollments |
| teacher_id | uuid | Yes | - | FK to users (Teacher or Creator) |
| student_id | uuid | Yes | - | FK to users |
| scheduled_start | timestamp | Yes | CD-015 | Scheduled start time |
| scheduled_end | timestamp | Yes | - | Scheduled end time |
| started_at | timestamp | No | tech-006 | Actual start (from webhook) |
| ended_at | timestamp | No | tech-006 | Actual end (from webhook) |
| status | enum | Yes | - | scheduled, in_progress, completed, cancelled |
| module_id | uuid | No | Session 331 | FK to course_curriculum — NULL while scheduled (computed positionally), set on completion |
| bbb_meeting_id | string | No | tech-001 | BBB meeting identifier |
| bbb_internal_meeting_id | string | No | tech-001 | BBB internal meeting ID |
| recording_url | string | No | US-V005 | Session recording URL (R2) |
| cancelled_by_user_id | uuid | No | - | FK to users (who cancelled) |
| cancel_reason | text | No | - | Cancellation reason |
| cancelled_at | timestamp | No | Session 333 | When the cancellation occurred |
| is_late_cancel | integer | Yes (0) | Session 333 | 1 if cancelled < 24h before start |
| reschedule_count | integer | Yes (0) | Session 333 | Times rescheduled (max 2) |
| created_at | timestamp | Yes | - | Booking time |

**Module assignment:** Positional — the Nth non-cancelled session (by `scheduled_start`) teaches the Nth module (by `module_order`). `module_id` is NULL while `scheduled` and frozen when `completed`. See `src/lib/booking.ts`.

**Indexes:** enrollment_id, teacher_id, student_id, bbb_meeting_id

**Source:** CD-015 (Calendar/Scheduling), tech-001 (BigBlueButton)

---

### session_assessments

Post-session mutual assessments.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| session_id | uuid | Yes | - | FK to sessions |
| assessor_id | uuid | Yes | US-V006 | FK to users (who gave assessment) |
| assessee_id | uuid | Yes | - | FK to users (who received) |
| rating | int | Yes | - | 1-5 stars |
| comment | text | No | - | Optional feedback |
| teacher_rating | int | No | Session 292 | 1-5, student→teacher only (NULL for teacher→student) |
| interaction_rating | int | No | Session 292 | 1-5, session interaction quality |
| materials_rating | int | No | Session 292 | 1-5, course materials as presented |
| created_at | timestamp | Yes | - | Assessment time |

**Source:** CD-003 (US-V006), CD-018, Session 292 (RATINGS block)

---

### course_reviews

Course materials reviews submitted at course completion. Separate from enrollment_reviews (which rate the Teacher). Feeds into courses.rating.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| enrollment_id | uuid | Yes | Session 292 | FK to enrollments (UNIQUE — one per enrollment) |
| reviewer_id | uuid | Yes | - | FK to users (the student) |
| course_id | uuid | Yes | - | FK to courses |
| rating | int | Yes | - | 1-5 overall materials rating |
| comment | text | Yes | - | Required (min 10 chars) |
| clarity_rating | int | No | - | 1-5 optional sub-rating |
| relevance_rating | int | No | - | 1-5 optional sub-rating |
| depth_rating | int | No | - | 1-5 optional sub-rating |
| created_at | timestamp | Yes | - | Review time |

**Source:** Session 292 (RATINGS block)

---

### enrollment_expectations

Private student goal-setting captured post-purchase. Visible to student, assigned Teacher, Creator, admins.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| enrollment_id | uuid | Yes | Session 292 | FK to enrollments (UNIQUE) |
| primary_goal | enum | Yes | - | career_change, skill_upgrade, personal_interest, academic, other |
| timeline | enum | Yes | - | under_1_month, 1_to_3_months, 3_to_6_months, no_rush |
| prior_experience | enum | Yes | - | beginner, some_exposure, intermediate, advanced |
| referral_source | enum | Yes | - | search, social, referral, creator_content, other |
| learning_hopes | text | Yes | - | Free text (min 20 chars) |
| additional_notes | text | No | - | Optional |
| created_at | timestamp | Yes | - | Created time |
| updated_at | timestamp | Yes | - | Last update |
| update_count | int | Yes | - | Times updated (default 0) |

**Source:** Session 292 (RATINGS block)

---

### review_responses

One public response per review. Teachers respond to enrollment_reviews, Creators respond to course_reviews.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| review_type | enum | Yes | Session 292 | 'enrollment' or 'course' |
| review_id | uuid | Yes | - | FK to enrollment_reviews.id or course_reviews.id |
| responder_id | uuid | Yes | - | FK to users (Teacher or Creator) |
| response | text | Yes | - | Response text (min 10 chars) |
| created_at | timestamp | Yes | - | Response time |

**Constraints:** UNIQUE(review_type, review_id) — one response per review.

**Source:** Session 292 (RATINGS block)

---

### session_attendance

Participant attendance tracking from PlugNmeet webhooks.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| session_id | uuid | Yes | tech-006 | FK to sessions |
| user_id | uuid | Yes | tech-006 | FK to users (participant) |
| joined_at | timestamp | Yes | tech-006 | When participant joined (webhook) |
| left_at | timestamp | No | tech-006 | When participant left (webhook) |
| duration_seconds | int | No | tech-006 | Computed from join/leave times |

**Indexes:** session_id, user_id (unique together for active attendance)

**Note:** Created via `participant_joined` webhook, updated via `participant_left` webhook. A user may have multiple attendance records if they leave and rejoin.

**Source:** tech-006 (PlugNmeet webhooks)

---

### session_resources

Resources attached to sessions or courses (recordings, slides, files) stored in R2.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| session_id | uuid | No | Brian Review | FK to sessions (null for course-level) |
| course_id | uuid | Yes | Brian Review | FK to courses |
| created_by_user_id | uuid | Yes | - | FK to users (uploader) |
| type | enum | Yes | Brian Review | recording, slide, document, other |
| name | string | Yes | - | Display file name |
| r2_key | string | Yes | Brian Review | Cloudflare R2 object key |
| size_bytes | bigint | No | - | File size in bytes |
| mime_type | string | No | - | MIME type (video/webm, application/pdf) |
| duration_seconds | int | No | Brian Review | For recordings only |
| is_public | boolean | Yes | - | Visible to all enrolled students |
| created_at | timestamp | Yes | - | Upload time |

**Indexes:** session_id, course_id, type

**Note:** Recordings from PlugNmeet are replicated to R2 and tracked here. Session recordings link to specific sessions; course-level slides/docs have null session_id.

**Source:** Brian Review 2025-12-26

---

## Homework

### homework_assignments

Homework/practice assignments created by creators or Teachers.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| course_id | uuid | Yes | Brian Review | FK to courses |
| module_id | uuid | No | Brian Review | FK to course_curriculum (optional) |
| created_by_user_id | uuid | Yes | Brian Review | FK to users (creator or teacher) |
| title | string | Yes | Brian Review | Assignment title |
| description | text | No | Brian Review | Brief description |
| instructions | text | Yes | Brian Review | Detailed instructions |
| due_within_days | int | No | Brian Review | Days after assigned (null = no due date) |
| is_required | boolean | Yes | Brian Review | Required for course completion |
| max_points | int | No | Brian Review | Maximum points (null = no grading) |
| is_active | boolean | Yes | - | Currently accepting submissions |
| created_at | timestamp | Yes | - | Record creation |
| updated_at | timestamp | Yes | - | Last update |

**Indexes:** course_id, module_id, created_by_user_id

**Source:** Brian Review 2025-12-26

---

### homework_submissions

Student submissions for homework assignments.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| assignment_id | uuid | Yes | Brian Review | FK to homework_assignments |
| student_user_id | uuid | Yes | Brian Review | FK to users |
| enrollment_id | uuid | Yes | Brian Review | FK to enrollments |
| content | text | No | Brian Review | Text submission/notes |
| file_url | string | No | Brian Review | R2 file attachment URL |
| status | enum | Yes | Brian Review | submitted, reviewed, resubmit_requested |
| submitted_at | timestamp | Yes | Brian Review | When submitted |
| reviewed_by_user_id | uuid | No | Brian Review | FK to users (teacher or creator) |
| reviewed_at | timestamp | No | Brian Review | When reviewed |
| feedback | text | No | Brian Review | Review feedback |
| points | int | No | Brian Review | Awarded points |
| created_at | timestamp | Yes | - | Record creation |
| updated_at | timestamp | Yes | - | Last update |

**Indexes:** assignment_id, student_user_id, enrollment_id, status

**Unique:** assignment_id + student_user_id (one submission per student per assignment, can be updated)

**Source:** Brian Review 2025-12-26

---

## Payments & Transactions

### transactions

Payment records.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| enrollment_id | uuid | Yes | - | FK to enrollments |
| amount_cents | int | Yes | CD-020 | Total payment amount |
| stripe_payment_id | string | Yes | CD-020 | Stripe payment intent ID |
| stripe_charge_id | string | No | tech-003 | Stripe charge ID (for transfers) |
| transfer_group | string | No | tech-003 | Links charge to transfers |
| status | enum | Yes | - | pending, completed, refunded, failed |
| paid_at | timestamp | No | - | Payment confirmation time |
| created_at | timestamp | Yes | - | Record creation |

**Indexes:** enrollment_id, stripe_payment_id, transfer_group

**Source:** CD-020 (Payment & Escrow), tech-003 (Stripe Connect)

---

### payment_splits

Revenue split tracking. Split varies by instructor type:
- **Creator teaches:** 15% Platform, 85% Creator
- **Teacher teaches:** 15% Platform, 15% Creator (as author), 70% Teacher

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| enrollment_id | uuid | Yes | tech-003 | FK to enrollments |
| transaction_id | uuid | Yes | - | FK to transactions |
| recipient_id | uuid | No | CD-020 | FK to users (null for platform) |
| recipient_type | enum | Yes | tech-003 | platform, creator_as_instructor, creator_as_author, teacher |
| amount_cents | int | Yes | CD-020 | Split amount |
| percentage | int | Yes | CD-020 | Split % (15, 15, 70, or 85) |
| stripe_transfer_id | string | No | tech-003 | Stripe transfer ID (null for platform) |
| status | enum | Yes | - | pending, paid, reversed |
| created_at | timestamp | Yes | - | When split was created |
| paid_at | timestamp | No | tech-003 | When transfer completed (from webhook) |

**Indexes:** enrollment_id, transaction_id, stripe_transfer_id

**Note:** `creator_as_author` is used when a teacher teaches - the creator receives 15% as a royalty. `creator_as_instructor` is used when the creator teaches directly (85%).

**Source:** CD-020, tech-003 (Stripe Connect)

---

### payouts

Payout records to recipients.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| recipient_id | uuid | Yes | - | FK to users |
| amount_cents | int | Yes | CD-020 | Payout amount |
| stripe_transfer_id | string | No | CD-020 | Stripe transfer ID |
| status | enum | Yes | - | pending, processing, completed, failed |
| approved_by_user_id | uuid | Yes | CD-020 | FK to users (admin who approved) |
| approved_at | timestamp | Yes | - | Approval time |
| paid_at | timestamp | No | - | Payment time |
| created_at | timestamp | Yes | - | Record creation |

**Source:** CD-020 (Admin payout dashboard)

---

## Certificates

### certificates

Issued certificates.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| user_id | uuid | Yes | - | FK to users |
| course_id | uuid | Yes | - | FK to courses |
| type | enum | Yes | CD-011 | completion, mastery, teaching |
| issued_at | timestamp | Yes | - | Issue date |
| issued_by_user_id | uuid | Yes | CD-012 | FK to users (creator who issued) |
| recommended_by_user_id | uuid | No | CD-012 | FK to users (teacher who recommended) |
| certificate_url | string | No | - | Generated certificate file |

**Source:** CD-011 (dual certificate system), CD-012, US-S021, US-S022, US-S032

---

## Feed Access (from CD-024)

### instructor_followers

Track users who have ever purchased any course from an instructor (grants instructor feed access).

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| instructor_id | uuid | Yes | CD-024 | FK to users (creator) |
| follower_id | uuid | Yes | CD-024 | FK to users (student) |
| first_enrollment_at | timestamp | Yes | CD-024 | When first course was purchased |
| created_at | timestamp | Yes | - | Record creation |

**Note:** Created automatically when a user enrolls in any course from an instructor. Used to determine instructor feed access.

**Indexes:** instructor_id, follower_id (unique together)

**Source:** CD-024, US-P084

---

### promoted_posts

Posts promoted from course feeds to the main Peer Loop feed (using goodwill points).

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| post_id | uuid | Yes | CD-024 | FK to posts |
| promoted_by | uuid | Yes | CD-024 | FK to users |
| points_spent | int | Yes | CD-024 | Goodwill points used for promotion |
| promoted_at | timestamp | Yes | - | When promoted |
| expires_at | timestamp | No | - | When promotion ends (optional) |

**Source:** CD-024, US-P085

---

## Communities & Progressions (CD-036)

Communities are topic-focused groups with feeds, resources, and learning paths (progressions).
Progressions organize courses into structured learning journeys.

**Hierarchy:** Community → Progression → Course

### communities

Topic-focused groups (e.g., "AI Tools & Strategy", "n8n Automation").

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| creator_id | uuid | No | CD-036 | FK to users (NULL for system communities) |
| name | text | Yes | CD-036 | Display name |
| slug | text | Yes | CD-036 | URL slug, unique |
| description | text | No | CD-036 | Community description |
| cover_image_url | text | No | - | Header image |
| icon | text | No | - | Emoji or icon identifier |
| is_public | boolean | Yes | CD-036 | Visible to non-members |
| is_system | boolean | Yes | CD-036 | Platform community (The Commons) |
| is_archived | boolean | Yes | - | Hidden but not deleted |
| member_count | int | Yes | - | Denormalized count |
| post_count | int | Yes | - | Denormalized count |
| created_at | timestamp | Yes | - | Creation time |
| updated_at | timestamp | Yes | - | Last update |

**Special:** The Commons (`is_system=1`) is the platform-wide community where all users are members.

**Source:** CD-036

---

### community_members

User membership in communities with role tracking.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| community_id | uuid | Yes | CD-036 | FK to communities |
| user_id | uuid | Yes | CD-036 | FK to users |
| member_role | enum | Yes | CD-036 | creator, teacher, member |
| joined_via | enum | No | CD-036 | enrollment, invite, system, manual |
| joined_at | timestamp | Yes | - | When joined |

**Constraint:** UNIQUE(community_id, user_id)

**Source:** CD-036

---

### community_moderators

Per-community moderator appointments. Tier 2 of the two-tier moderation model — Creator-appointed, scoped to one community and its course feeds (via Community → Progression → Course chain).

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| community_id | uuid | Yes | Session 263 | FK to communities |
| user_id | uuid | Yes | Session 263 | FK to users |
| appointed_by_user_id | uuid | Yes | Session 263 | FK to users (Creator or Admin who appointed) |
| appointed_at | timestamp | Yes | Session 263 | When appointed (default: now) |
| is_active | boolean | Yes | Session 263 | Currently active moderator (default: 1) |
| revoked_by_user_id | uuid | No | Session 263 | FK to users (who revoked, if revoked) |
| revoked_at | timestamp | No | Session 263 | When moderation authority was revoked |
| revoke_reason | text | No | Session 263 | Why moderation was revoked |
| notes | text | No | Session 263 | Internal appointment notes |
| created_at | timestamp | Yes | - | Record creation |

**Constraint:** UNIQUE(community_id, user_id)

**Indexes:** community_id, user_id, is_active

**Design rationale (separate table, not enum):**
- Follows the `teacher_certifications` pattern — per-entity relationships with their own metadata
- Avoids dual-role problem: user keeps their `community_members` row as `member` AND gets a `community_moderators` row
- Appointment metadata (`appointed_by_user_id`, `revoked_by_user_id`) doesn't belong on generic `community_members`

**Scope inheritance:** A community moderator can moderate the community feed AND all course feeds within that community. Course feeds are reached via the chain: Community → Progressions → Courses.

**Source:** Session 263 (Two-Tier Moderator Model)

---

### community_resources

Files, links, and videos shared within a community.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| community_id | uuid | Yes | CD-036 | FK to communities |
| uploaded_by_user_id | uuid | Yes | CD-036 | FK to users |
| title | text | Yes | CD-036 | Resource title |
| description | text | No | CD-036 | Resource description |
| type | enum | Yes | CD-036 | file, link, video |
| url | text | Yes | CD-036 | Resource URL |
| file_size | int | No | - | Bytes (for files) |
| mime_type | text | No | - | MIME type (for files) |
| download_count | int | Yes | - | Engagement metric |
| is_pinned | boolean | Yes | - | Featured at top |
| display_order | int | Yes | - | Sort order |
| created_at | timestamp | Yes | - | Upload time |
| updated_at | timestamp | Yes | - | Last update |

**Source:** CD-036

---

### progressions

Learning paths within communities. Courses belong to progressions.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| community_id | uuid | Yes | CD-036 | FK to communities |
| creator_id | uuid | Yes | CD-036 | FK to users |
| name | text | Yes | CD-036 | Display name (e.g., "AI Fundamentals") |
| slug | text | Yes | CD-036 | URL slug, unique |
| description | text | No | CD-036 | Progression description |
| thumbnail_url | text | No | - | Progression image |
| badge | enum | Yes | CD-036 | learning_path (multi-course), standalone (single) |
| course_count | int | Yes | - | Denormalized count |
| total_duration_minutes | int | Yes | - | Combined course duration |
| student_count | int | Yes | - | Students enrolled in any course |
| display_order | int | Yes | - | Order within community |
| is_active | boolean | Yes | - | Published state |
| is_archived | boolean | Yes | - | Hidden but not deleted |
| deleted_at | timestamp | No | - | Soft delete |
| created_at | timestamp | Yes | - | Creation time |
| updated_at | timestamp | Yes | - | Last update |

**Note:** Courses link to progressions via `courses.progression_id`.

**Source:** CD-036

---

### courses (progression fields)

These fields were added to the existing `courses` table:

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| progression_id | uuid | No | CD-036 | FK to progressions |
| progression_position | int | Yes | CD-036 | Order within progression (1, 2, 3...) |
| source_course_id | uuid | No | CD-036 | FK to courses (if copied) |
| is_archived | boolean | Yes | - | Hidden but not deleted |

**Note:** `progression_id` is nullable to allow migration flexibility, but all courses should have a progression.

**Source:** CD-036

---

## Community Feed

### posts

Community feed posts.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| author_id | uuid | Yes | CD-013 | FK to users |
| course_id | uuid | No | CD-013 | FK to courses (if course-specific) |
| content | text | Yes | CD-013 | Post content |
| post_type | enum | Yes | CD-013 | post, announcement, teaching_tip, availability |
| is_pinned | boolean | Yes | CD-013 | Pinned by moderator/creator |
| parent_id | uuid | No | - | FK to posts (for replies) |
| created_at | timestamp | Yes | - | Post time |
| updated_at | timestamp | No | - | Edit time |

**Note:** Will integrate with getstream.io for feed infrastructure.

**Source:** CD-013 (Community Feed)

---

### post_interactions

Likes, bookmarks, reposts.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| post_id | uuid | Yes | CD-013 | FK to posts |
| user_id | uuid | Yes | CD-013 | FK to users |
| type | enum | Yes | CD-013 | like, bookmark, repost |
| created_at | timestamp | Yes | - | Interaction time |

**Source:** CD-013, US-S037, US-S038, US-S040

---

### content_flags

Flagged content for moderation. Supports posts, comments, and profiles via content_type polymorphism.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| content_type | enum | Yes | Session 263 | `post`, `comment`, `profile` |
| stream_activity_id | text | No | Session 263 | Stream activity ID (for posts) |
| stream_reaction_id | text | No | Session 263 | Stream reaction ID (for comments) |
| target_user_id | uuid | No | Session 263 | FK to users (for profiles, or post/comment author) |
| community_id | uuid | No | Session 268 | FK to communities. Nullable; null for townhall/profile. ON DELETE SET NULL |
| feed_group | enum | No | Session 268 | `townhall`, `community`, `course`. Nullable; null for profile flags |
| content_snapshot | text | No | Session 263 | JSON snapshot of content at flag time |
| flagged_by_user_id | uuid | Yes | CD-013 | FK to users |
| reason | enum | Yes | - | `spam`, `harassment`, `inappropriate`, `misinformation`, `other` |
| reason_details | text | No | Session 263 | Additional context from flagger |
| status | enum | Yes | - | `pending`, `dismissed`, `actioned` |
| priority | enum | Yes | Session 263 | `low`, `normal`, `high`, `urgent` (auto-calculated) |
| reviewed_by_user_id | uuid | No | - | FK to users (moderator) |
| reviewed_at | timestamp | No | - | Review time |
| created_at | timestamp | Yes | - | Flag time |

**Indexes:** community_id, flagged_by_user_id, status+priority

**Notes:**
- `community_id` + `feed_group` enable Tier 2 community moderator scoping (Session 268)
- Nullable `community_id` excludes townhall/profile flags from Tier 2 views (SQL IN clause excludes NULLs)
- ON DELETE SET NULL preserves flag history if community deleted

**Source:** CD-013, US-S041, US-M009, `migrations/0001_schema.sql`

---

### moderation_actions

Log of every moderation action taken on flagged content. Multiple actions can occur per flag (e.g., dismiss then re-open then remove).

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| flag_id | uuid | Yes | Session 263 | FK to content_flags |
| action_type | enum | Yes | Session 263 | dismiss, remove_content, warn_user, suspend_1d, suspend_7d, suspend_30d, suspend_permanent |
| performed_by_user_id | uuid | Yes | Session 263 | FK to users (moderator or admin) |
| notes | text | No | Session 263 | Internal moderator/admin notes |
| created_at | timestamp | Yes | - | Action time |

**Indexes:** flag_id, performed_by_user_id, created_at

**Note:** `suspend_permanent` requires Admin role (moderators limited to temporary suspensions: 1d, 7d, 30d).

**Source:** Three-Table Moderation Design (docs/DECISIONS.md), `migrations/0001_schema.sql`

---

### user_warnings

Warning records linked to users for escalation tracking. Separate from `moderation_actions` to enable per-user warning history queries.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| user_id | uuid | Yes | Session 263 | FK to users (warned user) |
| flag_id | uuid | No | Session 263 | FK to content_flags (originating flag, if any) |
| action_id | uuid | No | Session 263 | FK to moderation_actions (linked action) |
| reason | text | Yes | Session 263 | Warning reason (shown to user) |
| issued_by_user_id | uuid | Yes | Session 263 | FK to users (moderator or admin) |
| acknowledged_at | timestamp | No | Session 263 | When user saw/acknowledged the warning |
| created_at | timestamp | Yes | - | Warning time |

**Indexes:** user_id, created_at

**Note:** Warning history is used for escalation decisions — repeated warnings may justify temporary or permanent suspension.

**Source:** Three-Table Moderation Design (docs/DECISIONS.md), `migrations/0001_schema.sql`

---

## Messaging

### conversations

Direct message conversations.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| created_at | timestamp | Yes | - | Conversation start |
| updated_at | timestamp | Yes | - | Last message time |

**Source:** CD-002, US-S019

---

### conversation_participants

Who is in each conversation.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| conversation_id | uuid | Yes | - | FK to conversations |
| user_id | uuid | Yes | - | FK to users |
| joined_at | timestamp | Yes | - | When joined |
| last_read_at | timestamp | No | - | Last read timestamp |

---

### messages

Individual messages.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| conversation_id | uuid | Yes | - | FK to conversations |
| sender_id | uuid | Yes | - | FK to users |
| content | text | Yes | - | Message content |
| created_at | timestamp | Yes | - | Send time |

**Source:** CD-003, US-S016, US-S017, US-S018

---

## Employer/Funder

### employer_sponsorships

Employer-sponsored enrollments.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| employer_id | uuid | Yes | CD-003 | FK to users (employer) |
| student_id | uuid | Yes | - | FK to users |
| enrollment_id | uuid | Yes | - | FK to enrollments |
| created_at | timestamp | Yes | - | Sponsorship date |

**Source:** CD-003 (Employer/Funder role), US-E001

---

## Notifications

### notifications

User notifications.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| user_id | uuid | Yes | - | FK to users |
| type | enum | Yes | - | session_reminder, payment, message, certificate, etc. |
| title | string | Yes | - | Notification title |
| body | text | Yes | - | Notification body |
| action_url | string | No | - | Click target URL |
| is_read | boolean | Yes | - | Read status |
| created_at | timestamp | Yes | - | Notification time |

**Source:** US-P017, US-P018

---

## Goodwill Points System (Block 2+)

*Note: Not MVP - Goodwill points are a community currency replacing 5-star reviews.*

### user_goodwill

Goodwill point balances per user.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| user_id | uuid | Yes | CD-023 | FK to users, primary key |
| total_earned | int | Yes | CD-023 | Lifetime total (public) |
| balance | int | Yes | CD-023 | Available to give (private) |
| spent | int | Yes | CD-023 | Given to others (private) |
| last_awarded_to_user_id | uuid | No | CD-023 | Anti-gaming tracking |
| last_awarded_at | timestamp | No | CD-023 | Cooldown tracking |
| updated_at | timestamp | Yes | - | Last update |

**Formula:** `balance = total_earned - spent`

**Source:** CD-023

---

### goodwill_transactions

Transaction log for all goodwill point transfers.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| from_user_id | uuid | No | CD-023 | FK to users (null for system awards) |
| to_user_id | uuid | Yes | CD-023 | FK to users (recipient) |
| points | int | Yes | CD-023 | Points transferred (5-100) |
| reason | enum | Yes | CD-023 | Transaction reason |
| course_id | uuid | No | CD-023 | FK to courses (if course-related) |
| summon_id | uuid | No | CD-023 | FK to help_summons (if from summon) |
| created_at | timestamp | Yes | - | Transaction time |

**Reason Enum:**
- `summon_help` - Responded to a Summon request (10-25 points)
- `question_answer` - Answered a question in chat (5 points)
- `first_session_mentor` - Helped new Teacher through first session (50 points)
- `referral` - Referred a student who enrolled (100 points)
- `remedial_volunteer` - Volunteered for remedial session (30 points)
- `availability_bonus` - Daily bonus for being available (5 points)

**Source:** CD-023

---

### help_summons

Help summon requests from students to Teachers.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| student_id | uuid | Yes | CD-023 | FK to users (requester) |
| course_id | uuid | Yes | CD-023 | FK to courses |
| module_id | uuid | No | CD-023 | FK to course_curriculum (specific module) |
| status | enum | Yes | CD-023 | pending, responded, completed, cancelled |
| responder_id | uuid | No | CD-023 | FK to users (teacher who responded) |
| responded_at | timestamp | No | - | When Teacher responded |
| completed_at | timestamp | No | - | When session completed |
| points_awarded | int | No | CD-023 | Points given (10-25) |
| session_duration_mins | int | No | CD-023 | Duration for 5-min minimum check |
| created_at | timestamp | Yes | - | Summon request time |

**Status Flow:** pending → responded → completed (or cancelled)

**Source:** CD-023

---

### user_availability

Teacher availability status for help summons.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| user_id | uuid | Yes | CD-023 | FK to users, primary key |
| is_available | boolean | Yes | CD-023 | "Available to Help" toggle |
| last_available_at | timestamp | No | CD-023 | For daily availability bonus |
| updated_at | timestamp | Yes | - | Status change time |

**Source:** CD-023

---

### goodwill_rewards

Reward thresholds and unlocks.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| points_threshold | int | Yes | CD-023 | Points required (500, 1000, 2500, 5000) |
| reward_type | enum | Yes | CD-023 | badge, discount, free_session, revenue_bonus |
| reward_value | string | Yes | CD-023 | "Community Helper", "10%", "5%" |
| description | text | Yes | CD-023 | Reward description |

**Thresholds (from CD-023):**
- 500 points → Badge: "Community Helper"
- 1,000 points → 10% discount on next course
- 2,500 points → Free 1-on-1 session with any Creator
- 5,000 points → Revenue share bonus (extra 5% on teaching)

**Source:** CD-023

---

### user_reward_unlocks

Track which users have unlocked which rewards.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| user_id | uuid | Yes | CD-023 | FK to users |
| reward_id | uuid | Yes | CD-023 | FK to goodwill_rewards |
| unlocked_at | timestamp | Yes | - | When unlocked |
| redeemed_at | timestamp | No | - | When used (if applicable) |

**Source:** CD-023

---

## Trust-Building Entities (from CD-029)

*Brian's review identified that new platforms need trust-building mechanisms before asking for high-ticket purchases.*

### visitor_inquiries

Track pre-enrollment questions from visitors to creators.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| visitor_email | string | Yes | CD-029 | Visitor's email (may not have account yet) |
| visitor_name | string | No | CD-029 | Visitor's name if provided |
| course_id | uuid | No | CD-029 | FK to courses (if course-specific inquiry) |
| creator_id | uuid | Yes | CD-029 | FK to users (creator receiving inquiry) |
| message | text | Yes | CD-029 | The inquiry/question |
| status | enum | Yes | CD-029 | pending, responded, converted |
| responded_at | timestamp | No | - | When creator responded |
| converted_to_enrollment | boolean | No | CD-029 | True if inquiry led to enrollment |
| created_at | timestamp | Yes | - | When inquiry was submitted |

**Source:** CD-029

---

### intro_sessions

Track free 15-minute intro sessions between visitors and Teachers.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| visitor_email | string | Yes | CD-029 | Visitor's email |
| visitor_name | string | No | CD-029 | Visitor's name if provided |
| teacher_id | uuid | Yes | CD-029 | FK to users (teacher conducting intro) |
| course_id | uuid | No | CD-029 | Course being discussed |
| scheduled_at | timestamp | Yes | CD-029 | When intro session is scheduled |
| bbb_room_url | string | No | - | BigBlueButton (or PlugNmeet) room URL |
| status | enum | Yes | CD-029 | scheduled, completed, cancelled, no_show |
| duration_minutes | integer | No | CD-029 | Actual duration (max 15) |
| converted_to_enrollment | boolean | No | CD-029 | True if intro led to enrollment |
| created_at | timestamp | Yes | - | When booked |

**Source:** CD-029

---

## System Configuration Tables

### features

Feature flags for controlling feature visibility and rollout.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | string | Yes | - | Primary key ('video_sessions', 'newsletters') |
| name | string | Yes | - | Display name |
| description | text | No | - | What the feature does |
| enabled | boolean | Yes | - | Global on/off switch |
| allowed_roles | string[] | Yes | - | ['student', 'creator'] or ['*'] for all |
| block | integer | No | - | Implementation block (0-9) |
| requires | string[] | No | - | Other feature IDs this depends on |
| created_at | timestamp | Yes | - | Record creation |
| updated_at | timestamp | Yes | - | Last update |

**Source:** FEATURE-FLAGS.md

---

### chat_rooms

Course-specific chat rooms (for COURSE_CHAT feature).

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| course_id | uuid | Yes | - | FK to courses |
| name | string | Yes | - | Room name (usually course title) |
| is_active | boolean | Yes | - | Whether chat is enabled |
| created_at | timestamp | Yes | - | Record creation |

**Source:** FEATURE-FLAGS.md (course_chat feature)

---

### chat_messages

Messages in course chat rooms.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| room_id | uuid | Yes | - | FK to chat_rooms |
| user_id | uuid | Yes | - | FK to users |
| content | text | Yes | - | Message content |
| reply_to_id | uuid | No | - | FK to chat_messages (for threads) |
| is_deleted | boolean | Yes | - | Soft delete flag |
| created_at | timestamp | Yes | - | Message timestamp |

**Indexes:** room_id + created_at (for fetching history)

**Source:** FEATURE-FLAGS.md (course_chat feature)

---

### help_requests

Summon help requests from students.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| student_id | uuid | Yes | - | FK to users |
| course_id | uuid | Yes | - | FK to courses |
| module_id | uuid | No | - | FK to course_curriculum |
| message | text | No | - | What they need help with |
| status | enum | Yes | - | pending, accepted, completed, expired |
| helper_id | uuid | No | - | FK to users (Teacher who accepted) |
| points_spent | integer | No | - | Goodwill points used |
| created_at | timestamp | Yes | - | Request time |
| accepted_at | timestamp | No | - | When helper accepted |
| completed_at | timestamp | No | - | When help session ended |

**Source:** FEATURE-FLAGS.md (summon_help feature), CD-023

---

### newsletters

Creator newsletter posts.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| creator_id | uuid | Yes | - | FK to users |
| title | string | Yes | - | Newsletter title |
| content | text | Yes | - | Newsletter body (HTML/markdown) |
| status | enum | Yes | - | draft, scheduled, sent |
| tier_id | uuid | No | - | FK to newsletter_tiers (null = all) |
| scheduled_for | timestamp | No | - | Send time (if scheduled) |
| sent_at | timestamp | No | - | Actual send time |
| opens_count | integer | No | - | Tracking metric |
| clicks_count | integer | No | - | Tracking metric |
| created_at | timestamp | Yes | - | Record creation |
| updated_at | timestamp | Yes | - | Last update |

**Source:** FEATURE-FLAGS.md (newsletters feature)

---

### newsletter_subscribers

Newsletter subscription records.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| creator_id | uuid | Yes | - | FK to users (creator) |
| user_id | uuid | Yes | - | FK to users (subscriber) |
| tier_id | uuid | No | - | FK to newsletter_tiers |
| subscribed_at | timestamp | Yes | - | When subscribed |
| unsubscribed_at | timestamp | No | - | When unsubscribed |

**Unique:** creator_id + user_id

**Source:** FEATURE-FLAGS.md (newsletters feature)

---

### newsletter_tiers

Paid subscription tiers for newsletters (future).

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| creator_id | uuid | Yes | - | FK to users |
| name | string | Yes | - | Tier name |
| price_cents | integer | Yes | - | Monthly price in cents |
| description | text | No | - | What's included |
| is_active | boolean | Yes | - | Available for subscription |
| created_at | timestamp | Yes | - | Record creation |

**Source:** FEATURE-FLAGS.md (newsletters feature)

---

### leaderboard_entries

Gamification leaderboard data.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| user_id | uuid | Yes | - | FK to users |
| leaderboard_type | enum | Yes | - | weekly_points, monthly_helper, etc. |
| period | string | Yes | - | '2025-W01', '2025-01' |
| score | integer | Yes | - | Points/count for ranking |
| rank | integer | No | - | Calculated rank |
| created_at | timestamp | Yes | - | Record creation |
| updated_at | timestamp | Yes | - | Last update |

**Unique:** user_id + leaderboard_type + period

**Source:** FEATURE-FLAGS.md (leaderboard feature)

---

### sub_communities

Topic-based community spaces.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| name | string | Yes | - | Community name |
| slug | string | Yes | - | URL slug |
| description | text | No | - | What it's about |
| cover_image_url | string | No | - | Banner image |
| is_public | boolean | Yes | - | Anyone can join vs invite-only |
| creator_id | uuid | Yes | - | FK to users |
| created_at | timestamp | Yes | - | Record creation |

**Source:** FEATURE-FLAGS.md (sub_communities feature)

---

### sub_community_members

Membership in sub-communities.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| community_id | uuid | Yes | - | FK to sub_communities |
| user_id | uuid | Yes | - | FK to users |
| role | enum | Yes | - | member, moderator, admin |
| joined_at | timestamp | Yes | - | When joined |

**Unique:** community_id + user_id

**Source:** FEATURE-FLAGS.md (sub_communities feature)

---

## Marketing & Content Entities

These entities support the public-facing marketing pages (About, Blog, Careers, FAQ, etc.).

---

### team_members

Team members displayed on the About page.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| name | string | Yes | Marketing Pages | Display name |
| role | string | Yes | Marketing Pages | Job title/role |
| bio | text | No | Marketing Pages | Extended biography |
| avatar_url | string | No | Marketing Pages | Profile photo URL |
| linkedin_url | string | No | Marketing Pages | LinkedIn profile URL |
| display_order | int | Yes | - | Sort order on page |
| is_active | boolean | Yes | - | Show on About page |
| created_at | timestamp | Yes | - | Record creation |

**Source:** About page (ABOU)

---

### platform_stats

Aggregated platform statistics for marketing displays.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| key | string | Yes | Marketing Pages | Stat identifier (students_count, completion_rate) |
| value | string | Yes | Marketing Pages | Current value (formatted for display) |
| label | string | Yes | Marketing Pages | Display label |
| display_order | int | No | - | Sort order |
| updated_at | timestamp | Yes | - | Last calculation |

**Indexes:** key (unique)

**Sample keys:** students_count, teachers_count, courses_count, completion_rate, total_payouts, countries_reached

**Source:** About (ABOU), Homepage (HOME), Stories (STOR)

---

### success_stories

Case studies and testimonials from students, teachers, and creators.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| user_id | uuid | No | Marketing Pages | FK to users (if linked to real user) |
| type | enum | Yes | Marketing Pages | student, teacher, creator |
| name | string | Yes | Marketing Pages | Person's name |
| location | string | No | Marketing Pages | City, Country |
| photo_url | string | No | Marketing Pages | Photo URL |
| headline | string | Yes | Marketing Pages | Short headline quote |
| short_quote | text | No | Marketing Pages | 1-2 sentence pull quote |
| full_story | text | Yes | Marketing Pages | Full narrative |
| stats | jsonb | No | Marketing Pages | {"before": "...", "after": "...", "earnings": "..."} |
| course_id | uuid | No | Marketing Pages | FK to courses (if applicable) |
| video_url | string | No | Marketing Pages | Video testimonial URL |
| is_featured | boolean | Yes | - | Show on homepage |
| display_order | int | Yes | - | Sort order |
| published_at | timestamp | No | - | When published |
| created_at | timestamp | Yes | - | Record creation |

**Indexes:** type, is_featured, published_at

**Source:** Success Stories page (STOR)

---

### faq_entries

Frequently asked questions and answers.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| question | text | Yes | Marketing Pages | The question |
| answer | text | Yes | Marketing Pages | The answer (supports markdown) |
| category | enum | Yes | Marketing Pages | general, students, teachers, creators, payments, technical |
| display_order | int | Yes | - | Sort order within category |
| is_published | boolean | Yes | - | Show on FAQ page |
| created_at | timestamp | Yes | - | Record creation |
| updated_at | timestamp | Yes | - | Last update |

**Indexes:** category, is_published

**Source:** FAQ page (FAQP)

---

### contact_submissions

Contact form submissions from visitors.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| name | string | Yes | Marketing Pages | Submitter's name |
| email | string | Yes | Marketing Pages | Submitter's email |
| category | enum | Yes | Marketing Pages | general, support, billing, partnership, press, creator, other |
| subject | string | Yes | Marketing Pages | Brief subject |
| message | text | Yes | Marketing Pages | Full message |
| status | enum | Yes | - | new, in_progress, responded, closed |
| responded_by_user_id | uuid | No | - | FK to users (admin who responded) |
| responded_at | timestamp | No | - | When response was sent |
| created_at | timestamp | Yes | - | Submission time |

**Indexes:** status, category, created_at

**Source:** Contact page (CONT)

---

### blog_categories

Blog post categories.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| name | string | Yes | Marketing Pages | Category name |
| slug | string | Yes | Marketing Pages | URL-friendly slug |
| description | text | No | Marketing Pages | Category description |
| display_order | int | Yes | - | Sort order |
| created_at | timestamp | Yes | - | Record creation |

**Indexes:** slug (unique)

**Sample categories:** Learning Tips, Teaching Tips, Success Stories, Product Updates, Industry Insights

**Source:** Blog page (BLOG)

---

### blog_posts

Blog articles for content marketing.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| slug | string | Yes | Marketing Pages | URL-friendly slug |
| title | string | Yes | Marketing Pages | Post title |
| excerpt | text | No | Marketing Pages | Short summary for listings |
| content | text | Yes | Marketing Pages | Full post content (HTML/markdown) |
| featured_image_url | string | No | Marketing Pages | Header image URL |
| author_id | uuid | Yes | Marketing Pages | FK to users |
| category_id | uuid | Yes | Marketing Pages | FK to blog_categories |
| tags | string[] | No | Marketing Pages | Tag array for filtering |
| read_time_minutes | int | No | Marketing Pages | Estimated read time |
| is_featured | boolean | Yes | - | Show as featured post |
| is_published | boolean | Yes | - | Visible on blog |
| published_at | timestamp | No | - | Publication date |
| created_at | timestamp | Yes | - | Record creation |
| updated_at | timestamp | Yes | - | Last update |

**Indexes:** slug (unique), author_id, category_id, is_published, published_at

**Source:** Blog page (BLOG)

---

### job_listings

Open job positions for careers page.

| Field | Type | Required | Source | Notes |
|-------|------|----------|--------|-------|
| id | uuid | Yes | - | Primary key |
| title | string | Yes | Marketing Pages | Job title |
| department | enum | Yes | Marketing Pages | engineering, product, marketing, operations, customer |
| location | string | Yes | Marketing Pages | Location (e.g., "Remote (US)") |
| employment_type | enum | Yes | Marketing Pages | full_time, part_time, contract |
| description | text | Yes | Marketing Pages | Role description |
| requirements | text[] | No | Marketing Pages | Array of requirements |
| apply_url | string | No | Marketing Pages | External application URL or mailto |
| salary_range | string | No | Marketing Pages | Salary range if disclosed |
| is_active | boolean | Yes | - | Currently accepting applications |
| posted_at | timestamp | Yes | - | When posted |
| expires_at | timestamp | No | - | When listing expires |
| created_at | timestamp | Yes | - | Record creation |

**Indexes:** department, is_active, posted_at

**Source:** Careers page (CARE)

---

## Document Lineage

| Source Document | Entities Derived |
|-----------------|------------------|
| CD-021 | users, user_qualifications, user_expertise, user_stats, courses, categories, course_tags, course_objectives, course_includes, course_curriculum, peerloop_features, teacher_certifications |
| CD-022 | courses.rating_count, courses.badge (new fields) |
| CD-023 | user_goodwill, goodwill_transactions, help_summons, user_availability, goodwill_rewards, user_reward_unlocks |
| CD-024 | instructor_followers, promoted_posts (feed access states, feed promotion) |
| CD-025 | courses (12 new fields: slug, tagline, currency, format, etc.), course_prerequisites, course_target_audience, course_testimonials, course_curriculum (session_number, learning_objectives, etc.), users.teaching_philosophy |
| CD-018 | user_interests, follows, course_follows, privacy fields |
| CD-019 | module_progress, external video/doc URLs |
| CD-020 | transactions, payment_splits, payouts |
| CD-015 | availability, sessions |
| CD-013 | posts, post_interactions, content_flags |
| CD-003 | enrollments, certificates, messages, employer_sponsorships |
| CD-011 | certificate types (mastery vs completion) |
| CD-029 | visitor_inquiries, intro_sessions |
| tech-003 | users.stripe_*, transactions.transfer_group, payment_splits.stripe_transfer_id |
| tech-004 | users.email_status, users.marketing_opt_out |
| tech-006 | sessions.plugnmeet_*, session_attendance (new table) |
| Brian Review | homework_assignments, homework_submissions, session_resources, moderator_invites, users.privacy_public default |
| Session 263 | community_moderators (two-tier moderation), moderation_actions + user_warnings (documentation gap fill) |
| Session 268 | content_flags.community_id + content_flags.feed_group (community-scoped moderation) |
| Marketing Pages | team_members, platform_stats, success_stories, faq_entries, contact_submissions, blog_categories, blog_posts, job_listings |

---

## Notes for Implementation

1. **UUIDs vs Integer IDs:** UUIDs recommended for distributed systems and security
2. **Timestamps:** Use UTC, handle timezone display in application layer
3. **Soft Deletes:** Consider `deleted_at` columns for audit trail
4. **Computed Fields:** user_stats may be better as computed view
5. **getstream.io:** Posts/feed may be managed externally; local tables for reference data
6. **Stripe:** transactions link to Stripe via payment_id for reconciliation

---

## Schema Version History

| Version | Date | Changes |
|---------|------|---------|
| v1 | 2025-12-23 | Initial schema from CD-021 analysis |
| v2 | 2025-12-26 | Added service integration fields (RUN-001 Amendment Step 4): users (Stripe + email fields), sessions (PlugNmeet fields), session_attendance (new), transactions (transfer_group), payment_splits (stripe_transfer_id) |
| v3 | 2025-12-26 | Brian Review updates: homework_assignments, homework_submissions, session_resources, moderator_invites tables; users.privacy_public default = false |
| v4 | 2025-12-26 | Marketing Pages: team_members, platform_stats, success_stories, faq_entries, contact_submissions, blog_categories, blog_posts, job_listings tables for landing pages |
| v5 | 2026-01-20 | Feed flags: users (instructor_feed_enabled, instructor_feed_created_at), courses (discussion_feed_enabled, discussion_feed_created_at) for Stream.io community feeds |
| v6 | 2026-02-23 | Two-tier moderation: community_moderators table; documented moderation_actions + user_warnings (existed in SQL, missing from docs) |
| v7 | 2026-03-07 | Terminology renames: `student_teachers` → `teacher_certifications`, `_by` → `_by_user_id` actor columns, `is_student_teacher` → `is_teacher`, `community_members.role` → `member_role`, `payment_splits.recipient_type` enum values updated, `enrollments` FK renames, `homework_submissions.student_id` → `student_user_id`, `intro_sessions.student_teacher_id` → `teacher_id` |
