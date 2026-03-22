# ROUTE-STORIES.md

**Purpose:** Canonical mapping of current routes to user stories
**Created:** Session 306 (2026-02-27)
**Source of truth for:** Which user stories are served by which routes
**Route source:** [docs/as-designed/url-routing.md](url-routing.md)
**Story source:** [user-stories-map.md](../requirements/user-stories-map.md) (391 stories)

---

## Summary

| Category | Stories |
|----------|---------|
| Mapped to routes (§1-§8) | 298 |
| Cross-cutting / platform-wide (§9) | 72 |
| On-hold / deferred features (§10) | 30 |
| Gap / needs design (§11) | 2 |
| **Total unique story IDs** | **402** |

*Note: USER-STORIES-MAP.md header says "391" but the actual ID count is 402 (T030-T038 and P101-P108 were added after the header was written). This document covers all 402.*

*Some stories are marked "also:" to show they apply to multiple routes (e.g., feed interactions). Each story appears in exactly one table row and is counted once.*

---

## Table of Contents

1. [Marketing Routes](#1-marketing-routes)
2. [Auth Routes](#2-auth-routes)
3. [Discovery Routes](#3-discovery-routes)
4. [Personal Routes](#4-personal-routes)
5. [Resource Routes](#5-resource-routes)
6. [Settings Routes](#6-settings-routes)
7. [Admin Routes](#7-admin-routes)
8. [Other Routes](#8-other-routes)
9. [Cross-Cutting Stories](#9-cross-cutting-stories) — 72 stories
10. [On-Hold Stories](#10-on-hold-stories) — 30 stories
11. [Gap Stories](#11-gap-stories) — 2 stories

---

## 1. Marketing Routes

Public marketing pages. Most have no dedicated stories; they fulfill promotional aspects of visitor stories.

### `/` — Homepage

| Story | Description | Priority |
|-------|-------------|----------|
| US-G001 | View homepage with value proposition | P0 |
| US-G002 | See promotional content (how it works, benefits, pricing) | P0 |
| US-G004 | See the Learn-Teach-Earn value proposition | P0 |

### `/pricing` — Pricing

| Story | Description | Priority |
|-------|-------------|----------|
| US-G007 | See course pricing without logging in | P0 |
| US-G018 | View tiered pricing options | P1 |

### `/stories` — Success Stories

| Story | Description | Priority |
|-------|-------------|----------|
| US-G003 | See success stories or testimonials | P1 |
| US-C025 | Share student success stories (creator posts here) | P2 |

### Routes with no dedicated stories

These marketing pages are implied by US-G002 (promotional content) but have no individual story:

`/about`, `/how-it-works`, `/faq`, `/for-creators`, `/become-a-teacher`, `/contact`, `/privacy`, `/terms`, `/testimonials`

---

## 2. Auth Routes

### `/login` — Login

| Story | Description | Priority |
|-------|-------------|----------|
| US-G012 | Log in to existing account | P0 |
| US-P008 | Log in securely | P0 |
| US-P011 | Social login options (Google, etc.) | P2 |

### `/signup` — Sign Up

| Story | Description | Priority |
|-------|-------------|----------|
| US-G011 | Sign up for an account | P0 |
| US-G014 | See prompt to sign up when trying to enroll | P0 |
| US-P007 | Create account with email/password | P0 |

### `/reset-password` — Password Reset

| Story | Description | Priority |
|-------|-------------|----------|
| US-G013 | Reset password if forgotten | P0 |
| US-P009 | Reset password via email | P0 |

### `/welcome` — Post-Signup Welcome

No dedicated stories. Post-signup landing.

### `/onboarding` — Interests & Preferences

| Story | Description | Priority |
|-------|-------------|----------|
| US-S080 | Onboarding flow to capture interests for feed personalization | P1 |
| US-P094 | Collect user interests during onboarding | P1 |

---

## 3. Discovery Routes

### `/discover` — Discovery Hub

| Story | Description | Priority |
|-------|-------------|----------|
| US-P001 | Browse Menu for course and creator search | P0 |

### `/discover/courses` — Course Catalog

| Story | Description | Priority |
|-------|-------------|----------|
| US-G005 | Browse available courses | P0 |
| US-S001 | See what tutor courses are available | P0 |
| US-S003 | Search for courses | P0 |
| US-S057 | Filter courses by difficulty level | P1 |
| US-S058 | Filter/browse courses by category | P1 |

### `/discover/creators` — Creator Directory

| Story | Description | Priority |
|-------|-------------|----------|
| US-G008 | View creator profiles (public info) | P0 |
| US-S004 | Search for Creators/Instructors with detailed profiles | P0 |
| US-G010 | See creator credentials and course stats | P1 |

### `/discover/teachers` — Teacher Directory

| Story | Description | Priority |
|-------|-------------|----------|
| US-G009 | See Teacher profiles (public info) | P1 |
| US-S050 | Browse Teacher directory | P0 |
| US-S051 | Search for Teachers by name or interests | P1 |
| US-P055 | Show Teacher profiles for selection | P1 |
| US-P066 | Teacher directory showing all users with Teacher toggle ON | P0 |

### `/discover/students` — Student Directory

No dedicated stories.

### `/discover/communities` — Community Discovery

No dedicated stories. Implied by community architecture.

### `/discover/leaderboard` — Leaderboard

| Story | Description | Priority | Notes |
|-------|-------------|----------|-------|
| US-P053 | Display leaderboards/rankings | P3 | On-hold: goodwill feature |
| US-P082 | Unlock rewards at point thresholds | P3 | On-hold: goodwill feature |

---

## 4. Personal Routes

Bare routes for logged-in users. "My stuff."

### `/learning` — Student Dashboard

| Story | Description | Priority |
|-------|-------------|----------|
| US-S009 | Unified dashboard for student/teacher activity tracking | P0 |
| US-S010 | Calendar view to manage schedule | P1 |
| US-S011 | Quick action buttons for common tasks | P1 |
| US-S013 | Reschedule a session with teacher | P1 |
| US-S014 | Cancel a session | P1 |
| US-S015 | Cancel a course (with reason) | P1 |
| US-S020 | Apply for teacher status (transition to earning) | P0 |
| US-S034 | Opt out of a Teacher relationship | P1 |
| US-S042 | Join video sessions directly from dashboard | P0 |
| US-S086 | Request a refund | P0 |
| US-S091 | Access recordings of sessions attended | P0 |
| US-V010 | Access transcripts of sessions | P1 |
| US-V011 | Search within session transcripts | P2 |
| US-P060 | Home/landing page showing enrolled courses, next session, progress | P0 |
| US-P059 | Handle bidirectional opt-out for Teacher relationships | P1 |

### `/teaching` — Teacher Dashboard

| Story | Description | Priority |
|-------|-------------|----------|
| US-T020 | "Available as Teacher" toggle | P0 |
| US-T033 | Offer custom coaching/mentoring sessions | P2 |
| US-P101 | Unified dashboard showing all user roles | P0 |

### `/teaching/students` — My Students

| Story | Description | Priority |
|-------|-------------|----------|
| US-T006 | Grant certificates to students | P0 |
| US-T014 | Opt out of a student relationship | P1 |
| US-T034 | See pending homework submissions | P0 |
| US-T035 | Review and provide feedback on homework | P0 |
| US-T036 | Approve submissions or request resubmission | P0 |
| US-P061 | Teacher recommend student for certification | P0 |

### `/teaching/sessions` — My Sessions

| Story | Description | Priority |
|-------|-------------|----------|
| US-T002 | Cancel a scheduled session | P1 |
| US-T019 | Access recordings of teaching sessions | P1 |
| US-T037 | Upload materials after a session | P0 |
| US-T038 | Share slides and notes with students | P1 |
| US-C007 | Cancel a scheduled session (Creator who also teaches) | P1 |

### `/teaching/earnings` — My Earnings

| Story | Description | Priority |
|-------|-------------|----------|
| US-S012 | Earnings tracking (student who also teaches) | P0 |
| US-T013 | Earnings dashboard | P0 |
| US-T023 | See running balance (pending earnings) | P0 |

### `/teaching/analytics` — Teaching Stats

No dedicated stories beyond dashboard metrics in US-T013.

### `/teaching/availability` — Availability Management

| Story | Description | Priority |
|-------|-------------|----------|
| US-T001 | Offer times for tutoring via calendar | P0 |
| US-T031 | Mark availability slots as "free intro available" | P1 |
| US-C006 | Offer times for tutoring (Creator who also teaches) | P0 |
| US-P025 | Sync availability with external calendars | P2 |

### `/creating` — Creator Dashboard

| Story | Description | Priority |
|-------|-------------|----------|
| US-C010 | "Creator Studio" button to access course management | P1 |
| US-C011 | Vet student-turned-teachers | P0 |
| US-C012 | Monitor/assess student-turned-teachers | P1 |
| US-C013 | Cancel a student for cause | P1 |
| US-C033 | Monitor student completion progress | P0 |
| US-C043 | Receive and respond to visitor inquiries | P0 |
| US-C048 | Basic free promotion options | P1 |
| US-C053 | Grade assignments with points | P1 |
| US-C054 | Review student homework submissions | P0 |
| US-C055 | Provide feedback on homework | P0 |
| US-P062 | Creator see certification requests in dashboard | P0 |
| US-P063 | Creator see Teacher applications in dashboard | P0 |
| US-P073 | Show creator dashboard of student progress | P0 |

### `/creating/apply` — Creator Application

No dedicated stories. New route for potential creators.

### `/creating/studio` — Course Builder

| Story | Description | Priority |
|-------|-------------|----------|
| US-C001 | Enter courses, training syllabi, quizzes, reference materials | P0 |
| US-C002 | Define criteria for successful completion | P0 |
| US-C003 | Set training progression and criteria to level up | P0 |
| US-C004 | Retire a course | P2 |
| US-C005 | Flexible assessments | P1 |
| US-C034 | Organize course content into modules | P0 |
| US-C039 | Add prerequisites with priority levels | P1 |
| US-C041 | Define target audience segments | P1 |
| US-C042 | Manage course testimonials | P2 |
| US-C046 | Pay per-course fee when publishing | P2 |
| US-C049 | Create homework assignments | P0 |
| US-C050 | Link homework to specific modules | P1 |
| US-C051 | Set assignments as required or optional | P1 |
| US-C052 | Set due dates for homework | P1 |
| US-C056 | Upload course-level resources | P0 |
| US-C057 | Manage course resources (view, delete, organize) | P1 |
| US-P044 | Upload course materials (PDFs, videos) | P0 |

### `/creating/communities` — Community Management

| Story | Description | Priority |
|-------|-------------|----------|
| US-C021 | Community hubs with forums | P1 |
| US-C030 | Build a loyal community | P2 |

### `/creating/communities/[slug]` — Community Detail

| Story | Description | Priority |
|-------|-------------|----------|
| US-C022 | Assign Community Roles (paid assistants) | P2 |
| US-C023 | Control community organization and content delivery | P2 |
| US-C027 | Appoint Community Moderators | P1 |
| US-C038 | See which students have access to feed | P2 |

### `/creating/analytics` — Course Stats

| Story | Description | Priority |
|-------|-------------|----------|
| US-C028 | Extended course analytics | P1 |
| US-C029 | Access student feedback on each Teacher | P1 |
| US-C044 | Inquiry analytics (questions, response time, conversion) | P2 |

### `/creating/earnings` — Creator Earnings

| Story | Description | Priority |
|-------|-------------|----------|
| US-C035 | See running balance (pending earnings) | P0 |
| US-P064 | Approve payout requests for Teachers | P0 |

### `/community` — My Communities Hub

| Story | Description | Priority |
|-------|-------------|----------|
| US-S024 | Access gated communities based on credentials | P1 |

### `/community/[slug]` — Community Feed

| Story | Description | Priority | Notes |
|-------|-------------|----------|-------|
| US-S036 | Create text posts in community feed | P0 | Also: /course/[slug]/feed |
| US-S037 | Like posts | P0 | Also: /feed, /course/[slug]/feed |
| US-S038 | Bookmark posts | P1 | Also: /feed, /course/[slug]/feed |
| US-S039 | Reply to posts | P0 | Also: /feed, /course/[slug]/feed |
| US-S040 | Repost content | P1 | Also: /feed, /course/[slug]/feed |
| US-S041 | Flag inappropriate content | P1 | Also: /feed, /course/[slug]/feed |
| US-S070 | Access instructor's public feed after paying | P1 | Community = instructor feed |
| US-T017 | Post availability to community feed | P0 | Teacher posting |
| US-T018 | Share teaching tips in feed | P1 | Teacher posting |
| US-C024 | Host AMA sessions | P2 | Creator in community |
| US-C031 | Post course announcements to feed | P0 | Creator posting |
| US-C037 | Instructor-level feed for students | P1 | Community = instructor feed |
| US-M001 | Answer questions in community chats | P1 | Moderator |
| US-M002 | Troubleshoot common issues | P1 | Moderator |
| US-M003 | Moderate course-related chats | P1 | Moderator |
| US-M006 | Delete inappropriate posts | P0 | Also: /mod |
| US-M008 | Pin important posts | P1 | Moderator |

### `/courses` — My Enrolled Courses

No dedicated stories. List view; dashboard stories are on `/learning`.

### `/messages` — My Messages

| Story | Description | Priority |
|-------|-------------|----------|
| US-S016 | Message teachers | P0 |
| US-S017 | Message other students | P2 |
| US-S018 | Message AP (support) | P0 |
| US-S019 | Private messaging system (1-on-1) | P0 |
| US-T008 | Message students (Teacher) | P0 |
| US-T009 | Message AP (Teacher) | P0 |
| US-C017 | Message students (Creator) | P0 |
| US-C018 | Message AP (Creator) | P0 |
| US-A010 | Message teachers (Admin) | P0 |
| US-A011 | Message students (Admin) | P0 |
| US-E005 | Message AP (Employer) | P1 |
| US-E006 | Message funded students (Employer) | P2 |
| US-P004 | Messages section accessible | P0 |

### `/notifications` — My Notifications

| Story | Description | Priority |
|-------|-------------|----------|
| US-P017 | In-app notifications for messages, sessions, updates | P0 |

### `/feed` — Aggregated Personalized Feed

| Story | Description | Priority |
|-------|-------------|----------|
| US-S025 | X.com-style algorithmic feed of followed content | P1 |
| US-P002 | "My Community" feed (X.com-style) | P1 |
| US-S076 | Pin posts/authors in feed companion UI | P2 |
| US-S077 | See original pinned post + latest thread comment | P2 |
| US-S078 | See "recent posters" panel with 24hr counts | P2 |
| US-S079 | AI Chat component in feed | P3 |
| US-P091 | Feed companion UI for pinned posts | P2 |
| US-P092 | Display original + latest for pinned items | P2 |
| US-P093 | Show recent posters panel with 24hr counts | P2 |

### `/profile` — Redirect

Redirects to `/@[handle]`. No dedicated stories.

---

## 5. Resource Routes

Public detail pages using singular nouns. Adapt based on viewer's relationship.

### `/course/[slug]` — Course Detail

| Story | Description | Priority |
|-------|-------------|----------|
| US-G006 | View course details (description, curriculum, price) | P0 |
| US-G016 | Send inquiry/question to Creator before enrolling | P0 |
| US-S002 | Pay for tutors (enrollment) | P0 |
| US-S005 | View course detail pages with curriculum and time estimates | P0 |
| US-S006 | Action buttons (Enroll, Explore Teaching, Follow, Join Community) | P0 |
| US-S007 | Related courses suggestions | P2 |
| US-S044 | Click "Schedule Session" from course listing | P0 |
| US-S056 | Schedule next session from course page | P0 |
| US-S059 | See learning objectives | P1 |
| US-S060 | See what's included (materials, sessions, certificates) | P0 |
| US-S072 | See course prerequisites | P1 |
| US-S073 | See target audience descriptions | P1 |
| US-S074 | See course testimonials | P2 |
| US-S075 | See course format (session count, duration) | P0 |
| US-G017 | Book free 15-min intro session with Teacher | P1 |
| US-E001 | Employer pays for student course | P1 |

### `/course/[slug]/learn` — Course Content

| Story | Description | Priority |
|-------|-------------|----------|
| US-S021 | Earn Learning Certificate upon completion | P0 |
| US-S052 | Course page with organized module structure | P0 |
| US-S053 | Access video content via external links | P0 |
| US-S054 | Access document links (Google Drive/Notion) | P0 |
| US-S055 | Self-mark module progress (checkboxes) | P0 |
| US-S087 | View homework assignments | P0 |
| US-S088 | Submit homework with text/file attachments | P0 |
| US-S089 | See feedback on submitted homework | P0 |
| US-S090 | Resubmit homework if requested | P1 |
| US-P071 | Display module-based course pages with links | P0 |
| US-P072 | Track student progress checkboxes per module | P0 |

### `/course/[slug]/feed` — Course Discussion Feed

| Story | Description | Priority |
|-------|-------------|----------|
| US-S069 | Access course community feed after paying | P0 |
| US-C032 | Pin posts to course feed section | P1 |

*Feed interaction stories (S036-S041) shared with `/community/[slug]`.*

### `/course/[slug]/book` — Session Booking

| Story | Description | Priority |
|-------|-------------|----------|
| US-S035 | Select Teacher by schedule availability | P1 |
| US-S045 | See available Teacher time slots for selected day | P0 |
| US-S082 | Request additional tutoring sessions | P2 |
| US-S083 | See Teacher availability calendar during enrollment | P0 |
| US-S084 | See list of available Teachers with their times | P0 |
| US-S085 | "Schedule Later" option during enrollment | P0 |
| US-P006 | Session booking integrated with teacher discovery | P0 |
| US-P020 | Display available time slots from teacher calendars | P0 |
| US-P024 | Select from available time slots when booking | P0 |
| US-P054 | Teacher matchmaking with random default | P1 |

### `/course/[slug]/teachers` — Course Teacher Directory

| Story | Description | Priority |
|-------|-------------|----------|
| US-S029 | Select a Teacher Student (random as default) | P1 |
| US-S061 | See available Teachers for a specific course | P1 |

### `/course/[slug]/resources` — Course Materials

| Story | Description | Priority |
|-------|-------------|----------|
| US-S092 | Download materials shared by Teacher | P0 |
| US-S093 | Access course-level resources (slides, docs) | P0 |

### `/course/[slug]/success` — Enrollment Success

No dedicated stories. Confirmation page after enrollment.

### `/creator/[handle]` — Creator Profile

| Story | Description | Priority |
|-------|-------------|----------|
| US-S028 | Follow creator before enrolling | P0 |
| US-C009 | Profile card with stats (Active Teachers, badges) | P1 |
| US-C016 | Teaching certificate displayed on profile | P1 |
| US-C036 | Display expertise/specialty tags on profile | P1 |

### `/teacher/[handle]` — Teacher Profile

| Story | Description | Priority |
|-------|-------------|----------|
| US-T003 | Enter profile with pictures, videos, PDFs | P0 |
| US-T004 | Public profile showing credentials | P0 |
| US-T016 | Verifiable mastery credentials for career advancement | P1 |
| US-T022 | Display list of courses certified to teach | P0 |

### `/@[handle]` — Universal Profile

| Story | Description | Priority |
|-------|-------------|----------|
| US-S008 | Enter profile with picture (public/private sections) | P0 |
| US-S023 | Teaching Certificate dynamically updates with student count | P1 |
| US-S048 | Follow other users | P0 |
| US-S049 | View followers and following lists | P1 |
| US-T021 | "Teaching" badge displayed on profile | P0 |
| US-P005 | Profile section accessible | P0 |
| US-P068 | Display follower/following counts | P0 |
| US-P069 | Display reputation (average star rating) | P1 |
| US-P070 | Profile strength/completion indicator | P2 |

### `/verify/[id]` — Certificate Verification

No dedicated stories. Implied by certification system (US-S021, US-S022).

### `/session/[id]` — Live Session Room

| Story | Description | Priority |
|-------|-------------|----------|
| US-S027 | Ask AI for assistance during session | P1 |
| US-S043 | Join video sessions from email notification links | P0 |
| US-V001 | Handle video chat experience | P0 |
| US-V002 | Limit number of participants | P1 |
| US-V003 | Allow messages and files during session | P0 |
| US-V004 | Monitor time for billing | P0 |
| US-V005 | Record conversations | P1 |
| US-V006 | Enable end-of-session assessment | P0 |
| US-V007 | AI-powered session summaries & transcripts | P1 |
| US-T007 | Conduct video sessions with screen sharing | P0 |
| US-T011 | Ask AI for assistance (Teacher) | P1 |
| US-T030 | Conduct free 15-min intro sessions | P1 |
| US-C020 | Ask AI for assistance (Creator) | P1 |
| US-A014 | Video calls with recording potential (Admin oversight) | P0 |
| US-A017 | Screen sharing in sessions | P0 |

---

## 6. Settings Routes

### `/settings` — Settings Hub

No dedicated stories. Navigation page.

### `/settings/profile` — Edit Profile

| Story | Description | Priority |
|-------|-------------|----------|
| US-S047 | Privacy toggle (public/private) on profile | P0 |
| US-S094 | Profile private by default | P0 |
| US-S095 | Choose to make profile public | P1 |
| US-C008 | Enter profile with pictures, videos, PDFs (Creator) | P0 |
| US-C040 | Add teaching philosophy to profile | P2 |
| US-E004 | Enter a profile (Employer) | P1 |
| US-P045 | Upload profile pictures and videos | P0 |

### `/settings/notifications` — Notification Preferences

| Story | Description | Priority |
|-------|-------------|----------|
| US-P018 | Manage notification preferences | P1 |

### `/settings/payments` — Payment & Payout Setup

| Story | Description | Priority |
|-------|-------------|----------|
| US-C045 | Pay monthly subscription (Creator) | P2 |
| US-P031 | Connect bank account/payment method | P0 |

### `/settings/security` — Password, 2FA

No dedicated stories. Password change and 2FA are implied by auth infrastructure (US-P008, US-P012). Account deletion has no dedicated story.

---

## 7. Admin Routes

### `/admin` — Admin Dashboard

| Story | Description | Priority |
|-------|-------------|----------|
| US-A031 | Set monthly subscription fees for creators | P2 |
| US-A032 | Set per-course publishing fees | P2 |
| US-A040 | View platform overview dashboard | P0 |
| US-A041 | See key metrics (users, courses, revenue, sessions) | P0 |
| US-A042 | Quick access to all admin tools | P0 |

### `/admin/users` — User Management

| Story | Description | Priority |
|-------|-------------|----------|
| US-A002 | Cancel a teacher (with reason) | P1 |
| US-A003 | Cancel a student (with reason) | P1 |
| US-A033 | Grant lifetime memberships to first 10-20 creators | P2 |
| US-A043 | View all users with search and filter | P0 |
| US-A044 | Edit user details | P0 |
| US-A045 | Manage user roles | P0 |
| US-A046 | Suspend or ban users | P0 |

### `/admin/courses` — Course Management

| Story | Description | Priority |
|-------|-------------|----------|
| US-A047 | View all courses with search and filter | P0 |
| US-A048 | Suspend or unsuspend courses | P0 |
| US-A049 | Feature or unfeature courses | P0 |

### `/admin/enrollments` — Enrollment Management

| Story | Description | Priority |
|-------|-------------|----------|
| US-A006 | Refund students if they cancel | P0 |
| US-A008 | Allow third party to pay for students | P1 |
| US-A050 | View all enrollments with search and filter | P0 |
| US-A051 | Process refund requests | P0 |
| US-A052 | Override enrollment status | P1 |

### `/admin/teachers` — Teacher Management

No stories beyond A001/A004 (which map to creator-applications and certificates).

### `/admin/payouts` — Payout Management

| Story | Description | Priority |
|-------|-------------|----------|
| US-A005 | Pay teachers from student enrollments (15/15/70 split) | P0 |
| US-A007 | Chargeback teachers for cancellations | P1 |
| US-A026 | Payout dashboard showing pending payouts by recipient | P0 |
| US-A027 | "Process Payout" button per recipient | P0 |
| US-A028 | Batch payout option ("Pay All") | P1 |
| US-A029 | Payout history and audit trail | P0 |
| US-P076 | Admin approve fund releases from escrow | P0 |

### `/admin/sessions` — Session Management

| Story | Description | Priority |
|-------|-------------|----------|
| US-A013 | Facilitate tutor sessions for any teacher-student combo | P0 |
| US-A015 | AI-powered session summaries & transcripts | P1 |
| US-A016 | Monitored session time for billing accuracy | P0 |
| US-A053 | View all sessions with search and filter | P0 |
| US-A054 | Access session recordings | P0 |
| US-A055 | Handle session disputes | P1 |

### `/admin/certificates` — Certificate Management

| Story | Description | Priority |
|-------|-------------|----------|
| US-A004 | Vet teacher certificates | P0 |
| US-A056 | View all certificates with search and filter | P0 |
| US-A057 | Issue certificates manually | P1 |
| US-A058 | Revoke certificates | P0 |

### `/admin/creator-applications` — Creator Application Review

| Story | Description | Priority |
|-------|-------------|----------|
| US-A001 | Enroll teachers (Creators) on the platform | P0 |

### `/admin/categories` — Category Management

| Story | Description | Priority |
|-------|-------------|----------|
| US-A059 | Manage course categories (create, edit, delete) | P1 |
| US-A060 | Reorder categories | P1 |

### `/admin/analytics` — Platform Analytics

| Story | Description | Priority |
|-------|-------------|----------|
| US-A019 | Monitor user time on site and retention | P1 |
| US-A020 | Monitor courses/teacher/creator stats | P1 |
| US-A021 | Monitor fees paid, distributed, income per creator | P0 |
| US-A022 | Monitor session status (cancel, complete) | P1 |
| US-A023 | Monitor student to teacher conversion | P0 |
| US-A024 | Monitor percentage grade averages | P1 |
| US-A025 | Determine user acquisition source | P2 |
| US-A030 | Monthly summary reports | P1 |
| US-P087 | Track inquiry→enrollment conversion | P1 |
| US-P089 | Track intro session→enrollment conversion | P1 |

### `/admin/moderation` — Moderation Queue (Admin)

No additional stories beyond /mod.

### `/admin/moderators` — Moderator Management

| Story | Description | Priority |
|-------|-------------|----------|
| US-A034 | Invite users to become moderators | P0 |
| US-A035 | See pending moderator invites | P1 |
| US-A036 | Resend moderator invite emails | P1 |
| US-A037 | Cancel pending moderator invites | P1 |
| US-A038 | See moderator invite history | P2 |
| US-A039 | Remove moderator status from users | P1 |

---

## 8. Other Routes

### `/mod` — Moderator Queue (Non-Admin)

| Story | Description | Priority |
|-------|-------------|----------|
| US-M005 | Support dashboard for pending questions/issues | P1 |
| US-M007 | Ban users from posting (temp or permanent) | P1 |
| US-M009 | See queue of flagged content | P0 |

### `/invite/mod/[token]` — Moderator Invite Acceptance

| Story | Description | Priority |
|-------|-------------|----------|
| US-P104 | Accept a moderator invitation | P0 |
| US-P105 | Decline a moderator invitation | P1 |
| US-P106 | Create account while accepting moderator invite | P0 |

---

## 9. Cross-Cutting Stories

Stories that affect the entire platform rather than a specific route. These are grouped by subsystem.

### Navigation & Architecture

| Story | Description | Priority |
|-------|-------------|----------|
| US-P003 | Dashboard view for activity at a glance | P0 |
| US-G015 | Gated content indicators on restricted pages | P1 |
| US-T005 | "Switch User" button to toggle student/teacher modes | P0 |

### Authentication & Session Management

| Story | Description | Priority |
|-------|-------------|----------|
| US-P010 | Log out to secure session | P0 |
| US-P012 | Manage user sessions securely | P0 |
| US-P013 | Verify email addresses | P0 |
| US-P100 | Feature flags to hide/show features | P1 |

### Email & Notifications Infrastructure

| Story | Description | Priority |
|-------|-------------|----------|
| US-S046 | Receive email and in-app notifications for booking | P0 |
| US-T032 | Receive notifications for booked intro sessions | P1 |
| US-P014 | Send transactional emails (welcome, receipts, confirmations) | P0 |
| US-P015 | Send session reminder emails | P0 |
| US-P016 | Send payment confirmation emails | P0 |
| US-P019 | Send certificate notification emails | P1 |
| US-P086 | Deliver visitor inquiries to creators via email | P0 |
| US-P090 | Send reminders for upcoming free intro sessions | P1 |
| US-P102 | Send moderator invite emails with unique tokens | P0 |
| US-P103 | Validate invite tokens and check expiration | P0 |

### Scheduling Infrastructure

| Story | Description | Priority |
|-------|-------------|----------|
| US-P021 | Prevent double-booking of sessions | P0 |
| US-P022 | Handle timezone conversions | P0 |
| US-P023 | Send calendar invites (ICS) for booked sessions | P1 |

### Payment Infrastructure

| Story | Description | Priority |
|-------|-------------|----------|
| US-T012 | Receive 70% of session fees (system behavior) | P0 |
| US-P026 | Process credit card payments securely | P0 |
| US-P027 | Split payments automatically (15/15/70) | P0 |
| US-P028 | Hold funds until session completion | P0 |
| US-P029 | Process payouts to Teachers/Creators | P0 |
| US-P030 | Handle refund requests | P0 |
| US-P032 | Generate tax documents (1099s) | P1 |
| US-P033 | Employer pay via invoice/PO | P2 |
| US-P074 | Hold funds in escrow until milestone completion | P0 |
| US-P075 | Clear release criteria for escrowed funds | P0 |
| US-P098 | Process payments for additional coaching sessions | P2 |

### Database & Storage Infrastructure

| Story | Description | Priority |
|-------|-------------|----------|
| US-P034 | Relational database for users, courses, sessions, transactions | P0 |
| US-P035 | Database backups and point-in-time recovery | P0 |
| US-P036 | Database connection pooling | P1 |
| US-P037 | Encrypt sensitive data at rest | P0 |
| US-P038 | Object storage for large files | P0 |
| US-P039 | Secure file upload endpoints | P0 |
| US-P040 | File type validation and virus scanning | P0 |
| US-P041 | Signed URLs for private file access | P0 |
| US-P042 | Store BBB session recordings | P0 |
| US-P043 | File size limits and quota management | P1 |

### Image Optimization

| Story | Description | Priority |
|-------|-------------|----------|
| US-P046 | Automatic image resizing and thumbnail generation | P0 |
| US-P047 | Image format conversion (WebP, AVIF) | P1 |
| US-P048 | Responsive image variants (srcset) | P1 |
| US-P049 | Image CDN delivery | P0 |
| US-P050 | Lazy loading for images | P1 |

### Feed Infrastructure

| Story | Description | Priority |
|-------|-------------|----------|
| US-P083 | Track enrollment-based feed access levels | P0 |
| US-P084 | Grant instructor feed access on course purchase | P1 |
| US-P095 | Use interests (not private discussions) for AI suggestions | P1 |
| US-P096 | Process paid course promotion requests | P2 |

### Social & Profile Infrastructure

| Story | Description | Priority |
|-------|-------------|----------|
| US-P067 | Track follow relationships (social graph) | P0 |
| US-P107 | Set new profiles to private by default | P0 |
| US-P108 | Exclude private profiles from public directories | P0 |

### Certification System

| Story | Description | Priority |
|-------|-------------|----------|
| US-S022 | Earn Teaching Certificate when becoming a teacher | P0 |
| US-S032 | Earn Certificate of Mastery (separate from completion) | P1 |
| US-C014 | Grant certificates to students of completion | P0 |
| US-C015 | Capture and send assessments of students | P1 |
| US-P056 | Issue Certificates of Mastery | P1 |
| US-P065 | Generate BBB links when sessions are booked | P0 |

### Referral & Miscellaneous

| Story | Description | Priority |
|-------|-------------|----------|
| US-S026 | Refer potential students to AP | P2 |
| US-S033 | Request content that doesn't exist | P2 |
| US-T010 | Refer potential students (Teacher) | P2 |
| US-C019 | Refer potential students (Creator) | P2 |
| US-A009 | Send success/failure assessments to funders | P1 |
| US-A012 | Contact potential students by email | P1 |
| US-A018 | Store tutor sessions with date/time/people | P0 |
| US-V008 | Transcribe recorded sessions to text | P1 |
| US-V009 | Generate session summaries from transcripts | P1 |
| US-P057 | Process content requests from students | P2 |
| US-P088 | Create BBB rooms for free intro sessions | P1 |

### Employer Notification Stories

| Story | Description | Priority |
|-------|-------------|----------|
| US-E002 | Receive student progress and completion status | P1 |
| US-E003 | Receive certification copy | P1 |

---

## 10. On-Hold Stories

Deferred features with no current route. Grouped by deferred system.

### Goodwill Points System (23 stories)

*Feature deferred to Block 2+. No current routes.*

| Story | Description | Priority |
|-------|-------------|----------|
| US-S030 | Earn goodwill points through participation | P2 |
| US-S031 | See power user level/tier | P2 |
| US-S062 | Summon help from certified peers | P2 |
| US-S063 | See how many helpers are available | P2 |
| US-S064 | Award goodwill points (10-25 slider) to helpers | P2 |
| US-S066 | Award "This Helped" points (5) to helpful chat answers | P2 |
| US-S067 | See goodwill balance and history | P2 |
| US-S068 | See total earned goodwill on public profile | P2 |
| US-T015 | Earn points for teaching activity | P2 |
| US-T024 | Toggle "Available to Help" status | P2 |
| US-T025 | Receive notifications for summon requests | P2 |
| US-T026 | Respond to summon requests, join chat/video | P2 |
| US-T027 | Earn goodwill points (10-25) for Summon help | P2 |
| US-T028 | Earn goodwill points (5) for chat answers | P2 |
| US-T029 | Earn availability bonus points (5/day) | P2 |
| US-P051 | Track goodwill points for user actions | P2 |
| US-P052 | Calculate power user tiers based on points | P2 |
| US-P058 | Track Teacher points for activity | P2 |
| US-P077 | Track goodwill point transactions | P2 |
| US-P078 | Enforce anti-gaming rules (caps, cooldowns) | P2 |
| US-P079 | Auto-award points for certain actions | P2 |
| US-P080 | Display available helpers count per course | P2 |
| US-P081 | Track summon help requests | P2 |

### Course Chat (2 stories)

*Deferred real-time chat. Superseded by community feeds.*

| Story | Description | Priority |
|-------|-------------|----------|
| US-S065 | Mark messages as questions in course chat | P2 |
| US-M004 | Add users to closed/private chats | P2 |

### Sub-Community (2 stories)

*User-created sub-communities deferred.*

| Story | Description | Priority |
|-------|-------------|----------|
| US-S081 | Create sub-community with invites | P3 |
| US-P097 | Support user-created sub-communities | P3 |

### Feed Promotion (2 stories)

*Goodwill-based feed promotion deferred.*

| Story | Description | Priority |
|-------|-------------|----------|
| US-S071 | Spend goodwill points to promote post | P3 |
| US-P085 | Process feed promotion requests | P3 |

### Creator Newsletters (1 story)

*Deferred newsletter feature.*

| Story | Description | Priority |
|-------|-------------|----------|
| US-C026 | Publish newsletters (with subscription payments) | P3 |

*Note: US-P053 and US-P082 appear under `/discover/leaderboard` with on-hold annotations. The route exists but these stories are effectively blocked until the goodwill system is built.*

---

## 11. Gap Stories

Stories that imply functionality with no current route.

### New Route Needed

| Story | Description | Priority | Suggested Route |
|-------|-------------|----------|-----------------|
| US-P099 | Changelog page for feature announcements | P2 | `/changelog` |

### Employer Role

The Employer/Funder role has 6 stories but no dedicated routes or dashboard. All stories are served through existing routes: E001 via `/course/[slug]`, E004 via `/settings/profile`, E005-E006 via `/messages`, E002-E003 via cross-cutting notifications.

### Creator Pricing (P2, needs design)

| Story | Description | Priority | Notes |
|-------|-------------|----------|-------|
| US-C047 | Pay for promoted placement in feeds | P2 | Could be in `/creating/studio` or `/creating` |

---

## Verification Checklist

- [ ] All 391 story IDs from docs/requirements/user-stories-map.md appear in this document
- [ ] Every route from docs/as-designed/url-routing.md appears in this document
- [ ] Cross-cutting stories are clearly categorized by subsystem
- [ ] On-hold stories are grouped by deferred feature
- [ ] Gap stories have suggested resolutions

---

## References

- [docs/as-designed/url-routing.md](url-routing.md) — Route source of truth
- [docs/requirements/user-stories-map.md](../requirements/user-stories-map.md) — All 391 stories with priorities
- [docs/reference/OLD-CODE-TO-NEW-ROUTE.md](../reference/OLD-CODE-TO-NEW-ROUTE.md) — Translation table
- [docs/as-designed/orig-pages-map.md](orig-pages-map.md) — Original page codes (pre-Twitter pivot)
- [docs/as-designed/run-001/SCOPE.md](run-001/SCOPE.md) — Old page-based story assignments (deprecated)
