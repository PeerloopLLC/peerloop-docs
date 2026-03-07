# GLOSSARY.md

Official terminology for the Peerloop platform. This document is **prescriptive** — if code, UI text, documentation, or conversation uses a term inconsistently with this glossary, the glossary is correct.

**Scope:** All code, schema, component names, API routes, UI-facing text, and living documentation must conform to these terms. Historical documents (session logs, learnings, decisions) are exempt — they reflect the terminology at the time they were written.

**Last Updated:** 2026-03-06 Session 348

---

## 1. Identity Hierarchy

These terms describe a person's relationship to the platform. They are **progressive** — each level builds on the previous one. They are also **non-exclusive** — a single person can simultaneously hold multiple roles.

| Term | Definition | DB Representation | UI Display |
|------|-----------|-------------------|------------|
| **Visitor** | A person browsing the platform without being logged in. No account exists, or they are not authenticated. | No row in `users`, or unauthenticated browser session | N/A (no identity shown) |
| **Member** | A person who has created an account and can log in. This is the base authenticated identity. Every logged-in person is a member. | Row in `users` table | Display name + avatar |
| **Student** | A member who is enrolled in (or has completed) at least one course. | Member + row(s) in `enrollments` | "Student" badge where applicable |
| **Teacher** | A member who is certified to teach at least one course. Formerly called "Student-Teacher" or "S-T." All teachers were once students — the prefix is redundant. | Member + row(s) in `teacher_certifications` table | "Teacher" badge (blue) |
| **Creator** | A member who has created at least one course. Creators design curriculum and certify teachers. | Member + `can_create_courses = 1` + row(s) in `courses` | "Creator" badge (purple) |
| **Moderator** | A member with content moderation rights. Two tiers exist (see §1a below). | Member + `can_moderate_courses = 1` (Tier 1) or row in `community_moderators` (Tier 2) | "Mod" badge (amber) |
| **Admin** | A platform administrator with full oversight and management capabilities. | Member + `is_admin = 1` | Admin navbar, admin tools |

### 1a. Moderator Tiers

| Tier | Name | Appointed By | Scope | DB Representation |
|------|------|-------------|-------|-------------------|
| **Tier 1** | Platform Moderator | Admin | Platform-wide — all community feeds and all course feeds | `users.can_moderate_courses = 1` |
| **Tier 2** | Community Moderator | Creator | Scoped to one community — that community's feed and the course feeds within it | Row in `community_moderators` |

Both tiers can moderate content in community feeds and course feeds. The difference is scope: Tier 1 moderators work across the entire platform, while Tier 2 moderators are limited to the community they were appointed to (and its courses).

### Key Principles

- **"User" in code, "member" in UI:** The database table is `users` and code variables use `user`, `userId`, `currentUser`. This is the universal convention for auth/identity systems. However, all **UI-facing text** (labels, headings, notifications, emails) should say "member" when referring to an authenticated person generically.
- **"Visitor" for unauthenticated:** Never call a non-logged-in person a "user" or "member" in UI text. They are a "visitor."
- **Roles are capabilities, not categories:** A person can be a Student + Teacher + Creator + Moderator simultaneously. The flywheel depends on this progression.
- **"Teacher" replaces "Student-Teacher":** The term "Student-Teacher" (and abbreviations "S-T", "ST") is retired. Use "Teacher" everywhere. The hyphenated form was confusing — "student-teacher" could mean "a student who teaches" or "a teacher of students." Since all teachers on Peerloop are former students, the "student" prefix adds no information.

### What NOT to Use

| Deprecated Term | Use Instead | Reason |
|----------------|-------------|--------|
| Student-Teacher | **Teacher** | Redundant — all teachers were students |
| S-T | **Teacher** | Abbreviation of deprecated term |
| ST (as prefix) | **Teacher** | Component/variable prefix of deprecated term |
| User (in UI text) | **Member** (authenticated) or **Visitor** (unauthenticated) | Too generic; doesn't convey relationship to platform |
| Guest | **Visitor** | "Guest" implies invitation; "visitor" is more accurate for someone browsing |

---

## 2. Core Domain Terms

### Learning Structure

| Term | Definition | DB Table | Notes |
|------|-----------|----------|-------|
| **Course** | A structured learning program created by a Creator. Has curriculum, a price, and enrolled students. Each course has its own discussion feed (via Stream.io). The atomic unit of learning on the platform. | `courses` | |
| **Curriculum** | The structured content of a course — its modules, learning objectives, topics, and assessments. Curriculum is a part of a course, not the whole course (courses also have pricing, enrollment, feeds, etc.). | Stored across `course_curriculum` rows | |
| **Module** | A unit within a course's curriculum (e.g., "Week 1: Introduction"). Contains learning objectives, topics, and optional assessments. | `course_curriculum` | Table name is `course_curriculum`, not `modules` — this is a known inconsistency to address |
| **Learning Path** | An ordered sequence of one or more courses within a community. Can be multi-course (displayed with a "Learning Path" badge) or standalone (single course). Use "learning path" in docs and UI; the database table is `progressions`. | `progressions` | |
| **Community** | A topic-focused group with members and resources. Each community has one community feed (created with the community) and one feed per course in the community. Communities start empty and have learning paths and courses added over time. "The Commons" is the system community all members join. | `communities` | |

### Enrollment & Progress

| Term | Definition | DB Table | Notes |
|------|-----------|----------|-------|
| **Enrollment** | A student's registration in a specific course, including their assigned teacher and progress. Created after payment is received (not before). American spelling used throughout codebase. | `enrollments` | |
| **Certification** | A record that a member is certified to teach a specific course. One row per (member, course) pair. This is NOT the same as a certificate. | `teacher_certifications` (currently `student_teachers`) | Rename pending |
| **Certificate** | A formal document issued to a student upon course completion, mastery, or teaching certification. Downloadable/verifiable. | `certificates` | |
| **Recommendation** | When a teacher recommends their student for certification (completion, mastery, or teaching). The teacher submits via `POST /api/me/certificates/recommend`, creating a `certificates` row with `status = 'pending'`. The creator or admin then approves or denies. Pending recommendations appear on the teacher's dashboard. | `certificates` with `recommended_by` set | |

### Teaching & Sessions

| Term | Definition | DB Table | Notes |
|------|-----------|----------|-------|
| **Teaching Session** | A scheduled 1-on-1 video call between a teacher and a student. Not to be confused with auth sessions or browser sessions. Always qualify as "teaching session" in code — see §7. | `sessions` | In UI: "Session" (context makes it clear). In code: always "teaching session" or prefix with `teaching`/`lesson`. |
| **Auth Session** | The server-side authentication state (JWT token, cookie). Managed by `src/lib/auth/session.ts`. The code convention is `authSession` for the variable returned by `getSession()`. | N/A (JWT-based, no DB table) | Never visible in UI. In code: use `authSession` to distinguish from teaching sessions. |
| **Intro Session** | A free 15-minute introductory call between a visitor/student and a teacher, before enrollment. | `intro_sessions` | Schema exists; feature not yet built (tracked in PLAN as ON-HOLD) |
| **Availability** | A teacher's recurring weekly time slots when they can accept bookings. Teachers set availability by day of week (e.g., "Mondays 2-5pm, Wednesdays 10am-1pm") with timezone. Slots can be indefinite or time-limited via `start_date`/`repeat_weeks`. | `availability` | |
| **Availability Override** | A one-off exception to a teacher's recurring availability — either adding extra hours on a specific date or blocking a date as unavailable. | `availability_overrides` | Schema exists; feature not yet built (tracked in PLAN) |
| **Booking** | The act of scheduling a teaching session within a teacher's available slots. | Part of `sessions` creation flow | Not a separate table — "booking" is the action, "session" is the result |

### Financial Terms

| Term | Definition | DB Table | Notes |
|------|-----------|----------|-------|
| **Transaction** | An incoming payment made by a student for a course enrollment. Processed via Stripe. Transactions are strictly incoming — refunds and payouts are tracked separately. | `transactions` | |
| **Refund** | A reversal of a transaction, returning funds to the student. May be full or partial. | `transactions` (status field) or separate tracking | Distinct from a transaction — always qualify as "refund" |
| **Payment Split** | The distribution of a transaction amount among recipients. Each split row identifies the recipient and their capacity via `recipient_type`. See recipient types below. | `payment_splits` | |

**Payment Split Recipient Types** (`payment_splits.recipient_type`):

Two scenarios exist depending on who teaches:

*Scenario 1 — Creator teaches their own course (no separate teacher):*

| `recipient_type` | Recipient | Share | Target Name |
|---|---|---|---|
| `'platform'` | Platform | 15% | `'platform'` (no change) |
| `'creator'` | Creator (as instructor) | 85% | `'creator_as_instructor'` |

*Scenario 2 — Teacher teaches (creator earns royalty only):*

| `recipient_type` | Recipient | Share | Target Name |
|---|---|---|---|
| `'platform'` | Platform | 15% | `'platform'` (no change) |
| `'creator_royalty'` | Creator (as course author) | 15% | `'creator_as_author'` |
| `'student_teacher'` | Teacher | 70% | `'teacher'` |

The "Target Name" column shows the planned enum values after Phase 3 (TERMINOLOGY.SCHEMA). The current values are ambiguous — `'creator'` vs `'creator_royalty'` doesn't clearly convey that the same person receives different shares depending on whether they're teaching or not.
| **Payout** | An outbound transfer of earned funds to a teacher or creator's Stripe Connect account. Not a transaction — payouts are platform-initiated disbursements, not student payments. | `payouts` | |
| **Commission** | The percentage of a course fee that a teacher earns (70%) or a creator earns as royalty (15%). | Calculated from `payment_splits` | Not a DB field — derived from the split percentages |
| **Session Credit** | A free session granted as compensation (dispute resolution, promotion, referral, goodwill). | `session_credits` | Schema exists; feature not yet built (tracked in PLAN as DEFERRED) |

### Social & Community

| Term | Definition | DB Table | Notes |
|------|-----------|----------|-------|
| **Feed** | A Stream.io activity feed where members post content. Exists at three levels: community feed, course feed (discussion), and townhall (global). Always qualify which feed — see §7. | Stream.io (external) | |
| **Townhall** | The global platform feed visible to all members. Always present — acts as the "home" feed for cross-community discussion and announcements. | Stream.io (external) | Endpoint: `/api/feeds/townhall`. UI: `TownHallFeed.tsx` |
| **Post** | A message published to a feed. Can include text and images. | Stream.io (external) | |
| **Follow** (member) | A member-to-member social connection. Following someone shows their activity in your feed. Your followers and who you follow are visible on your profile. | `follows` | Implemented |
| **Course Follow** | A member subscribing to updates about a specific course (without enrolling). | `course_follows` | Schema exists; feature not yet built (tracked in PLAN as DEFERRED) |
| **Flag** | A report that content (post, comment, profile) violates community guidelines. Enters the moderation queue. | `content_flags` | |

### Messaging

| Term | Definition | DB Table | Notes |
|------|-----------|----------|-------|
| **Conversation** | A private message thread between two members. Access is restricted: at least one participant must be a teacher, creator, moderator, or admin. New members and students cannot message each other. Threading is shown via nested replies. | `conversations` | Currently 1:1 only |
| **Message** | A single text message within a conversation. | `messages` | |
| **Direct Message (DM)** | Synonym for starting or continuing a conversation with a specific member. Used in UI buttons/links. | N/A | UI term, not a DB concept |

### Notifications

| Term | Definition | Notes |
|------|-----------|-------|
| **Notification** | A system-generated alert informing a member of an event (new enrollment, session booked, review received, certification approved, etc.). Distinct from messages (private, member-initiated) and posts (public, member-initiated). Notifications are platform-initiated. | Two delivery channels: in-app and email |
| **In-App Notification** | A notification displayed within the platform UI (bell icon, notification panel). | Not yet implemented (PLAN Block 9) |
| **Email Notification** | A notification delivered via email (Resend). Includes transactional emails (enrollment confirmation, session reminders) and digest-style updates. | Partially implemented via `src/lib/email.ts` |

---

## 3. User Story Role Codes

User stories use single-letter role codes that predate the current terminology. These codes are **frozen** — do not rename existing story IDs.

| Code | Original Label | Current Term | Story ID Pattern |
|------|---------------|-------------|-----------------|
| G | Visitor/Guest | **Visitor** | US-G### |
| A | Admin (AP Rep) | **Admin** | US-A### |
| C | Creator-Instructor | **Creator** | US-C### |
| S | Student | **Student** | US-S### |
| T | Student-Teacher | **Teacher** | US-T### |
| E | Employer/Funder | **Sponsor** (see below) | US-E### |
| V | Session (System) | **Teaching Session (System)** | US-V### |
| P | Platform/System | **Platform** | US-P### |
| M | Community Moderator | **Moderator** | US-M### |

**Note on US-T stories:** The code `T` remains `T` (not renamed to match "Teacher") because these IDs are embedded in 370+ stories, ROUTE-STORIES.md, and all session docs. Renaming would create traceability chaos for zero functional benefit.

**Note on "Employer/Funder" → "Sponsor":** This role is P1/P2 (not in MVP). When implemented, "Sponsor" is clearer than "Employer/Funder" — a sponsor pays for someone else's enrollment regardless of employment relationship.

---

## 4. Database Table Naming

### Current → Target Table Names

Tables that need renaming to match glossary terminology:

| Current Table | Target Table | Reason |
|--------------|-------------|--------|
| `student_teachers` | `teacher_certifications` | Rows are per-course certifications, not people. "Student-Teacher" → "Teacher" |

Tables that stay as-is:

| Table | Why It's Fine |
|-------|--------------|
| `users` | Universal convention for auth/identity. "Member" is UI-only. |
| `enrollments` | Correct — describes the student-course relationship |
| `sessions` | Correct — context (teaching) is clear from surrounding columns |
| `courses`, `communities`, `progressions` | Already match glossary terms |
| `certificates` | Already matches glossary |
| `community_members` | Correct — "member" here means community member, which is domain-appropriate |
| `community_moderators` | Correct |
| `conversations`, `messages` | Correct |

---

## 5. Component & File Naming

### Naming Conventions (after rename)

| Pattern | Convention | Example |
|---------|-----------|---------|
| **Components about teachers** | `Teacher*` prefix | `TeacherCard`, `TeacherDirectory`, `TeacherProfile` |
| **Components about members** | `Member*` or `User*` prefix | `MemberRow`, `UserSettings` |
| **API routes for teachers** | `/api/teachers/` or `/api/me/teacher-*` | `/api/teachers/[id]/reviews` |
| **Lib files for teachers** | `teacher-*.ts` or `teachers.ts` | `src/lib/ssr/loaders/teachers.ts` |
| **TypeScript types** | `Teacher*` | `TeacherCertification`, `TeacherListItem` |

### Current → Target (Key Components)

| Current | Target | Location |
|---------|--------|----------|
| `STCard` | `TeacherCard` | `src/components/student-teachers/` → `src/components/teachers/` |
| `STDirectory` | `TeacherDirectory` | Same move |
| `STProfile` | `TeacherProfile` | Same move |
| `STListItem` | `TeacherListItem` | Interface in TeacherDirectory |
| `CourseSTList` | `CourseTeacherList` | `src/components/courses/` |
| `STDetailContent` | `TeacherDetailContent` | `src/components/admin/` |
| `StudentTeachersAdmin` | `TeachersAdmin` | `src/components/admin/` |

### Directory Structure Change

```
src/components/student-teachers/  →  src/components/teachers/
```

---

## 6. URL Routes

### Current → Target (Key Routes)

| Current Route | Target Route | Notes |
|--------------|-------------|-------|
| `/teacher/[handle]` | `/teacher/[handle]` | Already correct! |
| `/discover/teachers` | `/discover/teachers` | Already correct (page title says "Student-Teachers" — fix text only) |
| `/api/student-teachers/*` | `/api/teachers/*` | API route rename |
| `/api/me/st-sessions` | `/api/me/teacher-sessions` | |
| `/api/me/st-earnings` | `/api/me/teacher-earnings` | |
| `/api/me/st-students` | `/api/me/teacher-students` | |
| `/api/me/st-analytics/*` | `/api/me/teacher-analytics/*` | |
| `/api/admin/student-teachers/*` | `/api/admin/teachers/*` | |
| `/api/me/student-teacher/[courseId]/toggle` | `/api/me/teacher/[courseId]/toggle` | |

---

## 7. Ambiguous Terms — Always Qualify

These terms are ambiguous and must **always** be qualified in code comments, variable names, and documentation — regardless of surrounding context. This applies to new code; existing code will be updated during Phase 4 (TERMINOLOGY.SURFACES).

### Critical (multiple systems, high bug risk)

| Ambiguous Usage | Always Clarify As | Code Convention | Context |
|----------------|-------------------|----------------|---------|
| "session" | **"teaching session"** or **"auth session"** | Variables: `teachingSession`/`authSession`. Never bare `session` in variable names or comments. | Six schema tables use "session" (`sessions`, `session_resources`, `session_assessments`, `session_attendance`, `intro_sessions`, `session_credits`). All are teaching-related, but confusion with auth sessions has caused bugs. |
| "rating" | **"course rating"**, **"teacher rating"**, or **"session rating"** | Variables: `courseRating`, `teacherRating`, `sessionRating`. Never bare `rating` or `avgRating`. | Three distinct rating systems: `course_reviews.rating` → `courses.rating`, `enrollment_reviews.rating` → `teacher_certifications.rating`, `session_assessments.rating` (does not feed into averages). |
| "review" | **"enrollment review"** (student rates their teacher's teaching) or **"course review"** (student rates the creator's course materials) | Variables: `enrollmentReview`, `courseReview`. Never bare `review`. | Two review types at course completion — one evaluates the teacher, the other evaluates the curriculum. Schema tables: `enrollment_reviews`, `course_reviews`. |
| "status" | Always qualify with table name | Variables: `enrollmentStatus`, `sessionStatus`, `payoutStatus`, etc. Never bare `status` in comments or variable names. | 16 tables have `status` columns with distinct enum values (e.g., enrollments: 5 values, transactions: 7 values, sessions: 5 values). Using the wrong enum string is a silent bug — SQL won't error, it just returns 0 rows. |

### High (role/type distinctions)

| Ambiguous Usage | Always Clarify As | Code Convention | Context |
|----------------|-------------------|----------------|---------|
| "moderator" | **"platform moderator"** (Tier 1) or **"community moderator"** (Tier 2) | Variables: `platformMod`/`communityMod` when both in scope. | Tier 1: `users.can_moderate_courses = 1` (platform-wide). Tier 2: row in `community_moderators` (scoped to one community). API paths already disambiguate. |
| "certificate" | **"completion certificate"**, **"mastery certificate"**, or **"teaching certificate"** | Variables: qualify via `cert.type` checks. In comments: always state the type. | `certificates.type` IN ('completion', 'mastery', 'teaching'). "Teaching certificate" is distinct from "certification" (the `teacher_certifications` table). |
| "member" in code | **"community member"** or **"platform member"** | Variables: `communityMember` for `community_members` rows; `member` for authenticated users in UI. | "Community member" = membership in a specific community. "Member" = any authenticated user (UI term for `users` table). |
| "active" | **`is_active`** (certification/course status) or **`teaching_active`** (accepting new students) | Use the column name directly — never abbreviate to bare `active`. | Two different booleans on `teacher_certifications` with different meanings. |
| "ID" without table context | `{table}_{column}` pattern | e.g., `certification_id` not just `id` when aliasing in SQL. | Prevents wrong-table JOIN bugs (like the original `/discover/teachers` bug that triggered this block). |

### Medium (features with deferred implementation)

| Ambiguous Usage | Always Clarify As | Code Convention | Context |
|----------------|-------------------|----------------|---------|
| "follow" | **"member follow"** or **"course follow"** | Variables: `memberFollow`/`courseFollow`. | `follows` table (member-to-member, implemented) vs `course_follows` table (subscribe to course, DEFERRED). |
| "feed" | **"community feed"**, **"course feed"**, or **"townhall feed"** | Variables: include scope prefix. Endpoints already disambiguate (`/feeds/townhall`, `/feeds/course/[slug]`). | Three feed levels via Stream.io, each with different visibility and moderation rules. |
| "notification" | **"in-app notification"** or **"email notification"** | Variables: `inAppNotification`/`emailNotification` when channel matters. | In-app: `notifications` table, bell icon. Email: Resend service, `src/lib/email.ts`. Different delivery, different implementation. |

---

## 8. Financial Model Quick Reference

For clarity in code comments and documentation. Two scenarios exist depending on who teaches:

**Scenario 1 — Teacher teaches (standard flywheel):**

| Flow | Who Pays | Who Receives | Split |
|------|----------|-------------|-------|
| Student enrolls | Student pays course price | Platform (15%), Creator (15% royalty), Teacher (70%) | Via `payment_splits` |
| Teacher earns | N/A | Teacher receives 70% per enrollment | Via `payouts` |
| Creator earns | N/A | Creator receives 15% royalty per enrollment | Via `payouts` |

**Scenario 2 — Creator teaches their own course:**

| Flow | Who Pays | Who Receives | Split |
|------|----------|-------------|-------|
| Student enrolls | Student pays course price | Platform (15%), Creator (85% as instructor) | Via `payment_splits` |
| Creator earns | N/A | Creator receives 85% per enrollment (no separate teacher) | Via `payouts` |

---

## 9. Glossary Governance

- **This document is the source of truth.** If code uses a term differently, the code should be updated (or this document amended by explicit decision).
- **New terms** should be added here before being used in code or docs.
- **Term changes** require updating this document first, then propagating to code/docs via a PLAN.md block.
- **Historical documents** (session logs, learnings, decisions) are exempt from retroactive updates — they reflect the language at the time of writing.
