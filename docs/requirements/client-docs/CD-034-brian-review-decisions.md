# CD-034: Brian Review Decisions (2025-12-26)

**Date:** 2025-12-26
**Source:** Brian Review Session - RUN-001 Final Review
**Type:** Scope Changes & Clarifications

---

## Purpose

This document captures decisions made during Brian's review of RUN-001 that changed the scope or clarified requirements. These decisions were applied directly to technical documents but need formal extraction into GOALS.md and USER-STORIES.md.

---

## Decision 1: Homework System → MVP

**Previous State:** Question #20 - "Excluding from MVP"
**New State:** Homework is MVP scope (Block 4)

### What This Means

Creators and Student-Teachers can create homework assignments for their courses. Students can submit homework, and it gets reviewed with feedback.

### Requirements

1. **Homework Assignments**
   - Creators can create homework assignments for courses
   - Assignments can be linked to specific modules (optional)
   - Assignments can be required or optional for course completion
   - Assignments can have due dates (relative: "X days after assigned")
   - Assignments can be graded (optional max points)
   - Assignments have title, description, and detailed instructions

2. **Homework Submissions**
   - Students can view homework assignments for enrolled courses
   - Students can submit homework (text content and/or file upload)
   - Students can update submissions before review
   - Students see feedback after review
   - Students can resubmit if requested

3. **Homework Review**
   - Creators and STs see pending submissions on dashboards
   - Reviewers can approve, provide feedback, or request resubmit
   - Reviewers can assign points (if graded assignment)

### User Interactions
- **Student:** Views assignments, submits work, sees feedback
- **Creator:** Creates assignments, reviews submissions, provides feedback
- **Student-Teacher:** Reviews submissions for students they teach, provides feedback

---

## Decision 2: Session Resources → R2 Storage

**Previous State:** Question #21 - "External links (like course content)"
**New State:** Full R2 storage for session recordings, slides, and files

### What This Means

Session resources (recordings, slides, documents) are stored in Cloudflare R2, not just external links. This includes automatic recording storage from PlugNmeet sessions.

### Requirements

1. **Recording Storage**
   - Session recordings from PlugNmeet are replicated to R2
   - Recordings are linked to specific sessions
   - Students can access recordings after sessions
   - Recordings show duration

2. **Session Materials**
   - STs can upload session materials (slides, notes, follow-up docs)
   - Materials are stored in R2
   - Students can download materials

3. **Course Resources**
   - Creators can upload course-level resources
   - Resources are available to all enrolled students
   - Resources grouped by type (slides, documents, videos)

### User Interactions
- **Student:** Downloads resources, watches recordings
- **Creator:** Uploads course-level resources
- **Student-Teacher:** Uploads session-specific materials post-session

---

## Decision 3: Moderator Invites → Two-Step Flow

**Previous State:** Question #25 - "Post-MVP per CD-032"
**New State:** Included in scope with two-step invite flow

### What This Means

Admins can invite moderators via email. Invitees receive an email with a link to accept or decline. If they don't have an account, they create one during acceptance.

### Requirements

1. **Invite Flow**
   - Admin enters email address to invite
   - System sends invite email via Resend
   - Invite has unique token and expiration (e.g., 7 days)
   - Admin can view pending invites
   - Admin can resend or cancel invites

2. **Acceptance Flow**
   - Invitee receives email with unique link
   - Link leads to acceptance page (MINV)
   - If invitee has account: can accept immediately after login
   - If invitee new: creates account, then accepts
   - Accepting sets `is_moderator = true` on user

3. **Decline Flow**
   - Invitee can decline invitation
   - No account required to decline

### User Interactions
- **Admin:** Sends invites, manages pending/history
- **Invitee (new):** Receives email, creates account, becomes moderator
- **Invitee (existing):** Receives email, logs in, accepts, becomes moderator

---

## Decision 4: Privacy Default → Private

**Previous State:** Question #10 - "Assuming Public default"
**New State:** Default is Private (`privacy_public = false`)

### What This Means

New user profiles are private by default. Users must explicitly opt-in to make their profile publicly visible.

### Requirements

1. Users are private by default on signup
2. Users can toggle visibility in settings
3. Private profiles are not shown in public directories
4. Private users can still participate (enroll, teach, etc.)

### User Interactions
- **All Users:** Can toggle profile visibility in settings
- **Default:** New accounts are private until user chooses otherwise

---

## Implied Goals

These decisions imply the following goals that may not be explicitly captured:

1. **Homework supports mastery verification** - Homework helps verify student understanding beyond just watching content
2. **Session recordings enable async learning** - Students can review sessions they attended
3. **Resource sharing enhances teaching** - STs can share materials to support their teaching
4. **Controlled moderator onboarding** - Moderators are invited, not self-selected, ensuring quality
5. **Privacy by default** - Users control their visibility, building trust

---

## Implied User Stories

### Homework (Student Role)
- As a student, I want to see homework assignments for my enrolled courses
- As a student, I want to submit homework with text and/or file attachments
- As a student, I want to see feedback on my submitted homework
- As a student, I want to resubmit homework if the reviewer requests changes

### Homework (Creator Role)
- As a creator, I want to create homework assignments for my courses
- As a creator, I want to link assignments to specific modules
- As a creator, I want to set assignments as required or optional
- As a creator, I want to set due dates for assignments
- As a creator, I want to grade assignments with points
- As a creator, I want to review student submissions
- As a creator, I want to provide feedback on submissions

### Homework (Student-Teacher Role)
- As a student-teacher, I want to see pending homework to review from students I teach
- As a student-teacher, I want to review and provide feedback on submissions
- As a student-teacher, I want to approve submissions or request resubmission

### Session Resources (Student Role)
- As a student, I want to access recordings of sessions I attended
- As a student, I want to download materials shared by my ST
- As a student, I want to access course-level resources

### Session Resources (Creator Role)
- As a creator, I want to upload course-level resources (slides, docs)
- As a creator, I want to manage course resources

### Session Resources (Student-Teacher Role)
- As a student-teacher, I want to upload materials after a session
- As a student-teacher, I want to share follow-up notes with students

### Moderator Invites (Admin Role)
- As an admin, I want to invite users to become moderators via email
- As an admin, I want to see pending moderator invites
- As an admin, I want to resend invite emails
- As an admin, I want to cancel pending invites
- As an admin, I want to see invite history

### Moderator Invites (Invitee)
- As an invite recipient, I want to accept a moderator invitation
- As an invite recipient, I want to decline a moderator invitation
- As a new user, I want to create an account while accepting an invite

### Privacy (All Users)
- As a user, I want my profile to be private by default
- As a user, I want to choose to make my profile public

---

## Technical Implementation Complete

The following technical documents have been updated to support these decisions:

| Document | Updates |
|----------|---------|
| DB-SCHEMA.md (v3) | homework_assignments, homework_submissions, session_resources, moderator_invites tables |
| DB-API.md (v2) | 24 new endpoints |
| FEATURE-FLAGS.md | HOMEWORK feature (MVP, Block 4) |
| Page Files | CCNT, CDSH, TDSH, STUD, SROM, ADMN updated; MINV created |

---

## Next Steps

1. Extract formal goals from "Implied Goals" → GOALS.md
2. Extract formal user stories from "Implied User Stories" → USER-STORIES.md
3. Cross-reference technical docs to ensure completeness
