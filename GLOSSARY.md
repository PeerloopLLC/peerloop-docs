# GLOSSARY.md

Official terminology for the Peerloop platform. This document is **prescriptive** — if code, UI text, documentation, or conversation uses a term inconsistently with this glossary, the glossary is correct.

**Scope:** All code, schema, component names, API routes, UI-facing text, and living documentation must conform to these terms. Historical documents (session logs, learnings, decisions) are exempt — they reflect the terminology at the time they were written.

**Last Updated:** 2026-03-05 Session 346

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
| **Moderator** | A member with content moderation rights. Can be platform-wide (Tier 1, admin-appointed) or community-scoped (Tier 2, creator-appointed). | Member + `can_moderate_courses = 1` or row in `community_moderators` | "Mod" badge (amber) |
| **Admin** | A platform administrator with full oversight and management capabilities. | Member + `is_admin = 1` | Admin navbar, admin tools |

### Key Principles

- **"User" in code, "member" in UI:** The database table is `users` and code variables use `user`, `userId`, `currentUser`. This is the universal convention for auth/identity systems. However, all **UI-facing text** (labels, headings, notifications, emails) should say "member" when referring to an authenticated person generically.
- **"Visitor" for unauthenticated:** Never call a non-logged-in person a "user" or "member" in UI text. They are a "visitor" or "guest."
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
| **Course** | A structured learning program created by a Creator. Has curriculum modules, a price, and enrolled students. The atomic unit of learning on the platform. | `courses` | |
| **Module** | A unit within a course curriculum (e.g., "Week 1: Introduction"). Contains learning objectives, topics, and optional assessments. | `course_curriculum` | Table name is `course_curriculum`, not `modules` — this is a known inconsistency to address |
| **Progression** | An ordered sequence of courses within a community. Can be a "learning path" (multi-course) or "standalone" (single course). | `progressions` | |
| **Learning Path** | A progression containing multiple courses in a specific order. Displayed with a "Learning Path" badge. | `progressions` where `badge = 'learning_path'` | Subtype of Progression |
| **Community** | A topic-focused group with feeds, resources, and members. Every community has at least one progression. "The Commons" is the system community all members join. | `communities` | |

### Enrollment & Progress

| Term | Definition | DB Table | Notes |
|------|-----------|----------|-------|
| **Enrollment** | A student's registration in a specific course, including their assigned teacher and progress. The central relationship linking students to courses. | `enrollments` | |
| **Certification** | A record that a member is certified to teach a specific course. One row per (member, course) pair. This is NOT the same as a certificate. | `teacher_certifications` (currently `student_teachers`) | Rename pending |
| **Certificate** | A formal document issued to a student upon course completion, mastery, or teaching certification. Downloadable/verifiable. | `certificates` | |
| **Recommendation** | When a teacher recommends their student for teaching certification. Starts the certification approval flow. | `certificates` where `type = 'teaching'` + `recommended_by` | |

### Teaching & Sessions

| Term | Definition | DB Table | Notes |
|------|-----------|----------|-------|
| **Teaching Session** | A scheduled 1-on-1 video call between a teacher and a student. Not to be confused with auth sessions or browser sessions. | `sessions` | In UI: always "Session" (context makes it clear). In code comments: "teaching session" if ambiguous. |
| **Auth Session** | The server-side authentication state (JWT token, cookie). Managed by `src/lib/auth/session.ts`. | N/A (JWT-based, no DB table) | Never visible in UI. In code: use `authSession` or `sessionToken` to distinguish from teaching sessions. |
| **Intro Session** | A free 15-minute introductory call between a visitor/student and a teacher, before enrollment. | `intro_sessions` | |
| **Availability** | A teacher's recurring or one-time time slots when they can accept bookings. | `availability`, `availability_overrides` | |
| **Booking** | The act of scheduling a teaching session within a teacher's available slots. | Part of `sessions` creation flow | Not a separate table — "booking" is the action, "session" is the result |

### Financial Terms

| Term | Definition | DB Table | Notes |
|------|-----------|----------|-------|
| **Transaction** | A payment made by a student for a course enrollment. Processed via Stripe. | `transactions` | |
| **Payment Split** | The distribution of a transaction amount among recipients (platform 15%, creator 15% royalty, teacher 70%). | `payment_splits` | |
| **Payout** | A transfer of earned funds to a teacher or creator's Stripe Connect account. | `payouts` | |
| **Commission** | The percentage of a course fee that a teacher earns (70%) or a creator earns as royalty (15%). | Calculated from `payment_splits` | Not a DB field — derived from the split percentages |
| **Session Credit** | A free session granted as compensation (dispute resolution, promotion, referral, goodwill). | `session_credits` | |

### Social & Community

| Term | Definition | DB Table | Notes |
|------|-----------|----------|-------|
| **Feed** | A Stream.io activity feed where members post content. Exists at community level, course level (discussion), and townhall (global). | Stream.io (external) | |
| **Post** | A message published to a feed. Can include text and images. | Stream.io (external) | |
| **Follow** | A member-to-member social connection. Following someone shows their activity in your feed. | `follows` | |
| **Course Follow** | A member subscribing to updates about a specific course (without enrolling). | `course_follows` | |
| **Flag** | A report that content (post, comment, profile) violates community guidelines. Enters the moderation queue. | `content_flags` | |

### Messaging

| Term | Definition | DB Table | Notes |
|------|-----------|----------|-------|
| **Conversation** | A private message thread between two members. | `conversations` | Currently 1:1 only |
| **Message** | A single text message within a conversation. | `messages` | |
| **Direct Message (DM)** | Synonym for starting or continuing a conversation with a specific member. Used in UI buttons/links. | N/A | UI term, not a DB concept |

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

## 7. Ambiguous Terms to Avoid

| Ambiguous Usage | Clarify As | Context |
|----------------|-----------|---------|
| "session" (standalone in code) | "teaching session" or "auth session" | Use full term in comments, variable names when both exist nearby |
| "ID" without table context | "{table}_{column}" pattern | e.g., `certification_id` not just `id` when aliasing |
| "rating" (standalone) | "course rating" or "teacher rating" or "session rating" | Three distinct rating systems exist |
| "review" (standalone) | "enrollment review" (rates teacher) or "course review" (rates materials) | Two review types at course completion |
| "member" in code | Community member vs platform member | "community member" for `community_members` rows; "member" for authenticated users in UI |
| "active" | `is_active` (certification/course) vs `teaching_active` (accepting students) | Two different booleans on `teacher_certifications` |

---

## 8. Financial Model Quick Reference

For clarity in code comments and documentation:

| Flow | Who Pays | Who Receives | Split |
|------|----------|-------------|-------|
| Student enrolls | Student pays course price | Platform (15%), Creator (15% royalty), Teacher (70%) | Via `payment_splits` |
| Teacher earns | N/A | Teacher receives 70% per enrollment | Via `payouts` |
| Creator earns | N/A | Creator receives 15% royalty per enrollment | Via `payouts` |

---

## 9. Glossary Governance

- **This document is the source of truth.** If code uses a term differently, the code should be updated (or this document amended by explicit decision).
- **New terms** should be added here before being used in code or docs.
- **Term changes** require updating this document first, then propagating to code/docs via a PLAN.md block.
- **Historical documents** (session logs, learnings, decisions) are exempt from retroactive updates — they reflect the language at the time of writing.
