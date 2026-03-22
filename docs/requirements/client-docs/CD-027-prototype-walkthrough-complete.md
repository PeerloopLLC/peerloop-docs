# CD-027: PeerLoop Prototype Walkthrough - Complete Analysis

**Date:** 2025-12-24
**Type:** Prototype Analysis
**Source:** Live prototype at https://peerloopllc.github.io/Peerloop-v2/
**Context:** Brian (client) vibe-coded a prototype with mock data to explore page layouts and information architecture. This document captures observations from walking through ALL personas.

**Important Note:** Brian is a new vibe coder learning as he goes. The prototype is incomplete and inconsistent across personas. We focus on intended features and page structure, not implementation artifacts.

---

## Prototype Overview

**Demo Mode:** The prototype uses persona selection to demonstrate different user experiences:

| Persona | Role | Status | Notes |
|---------|------|--------|-------|
| New User (NU) | New User | ✅ Reviewed | Baseline - empty states |
| Sarah Miller (SM) | Student | ✅ Reviewed | Populated student experience |
| Alex Sanders (AS) | Student & Teacher | ✅ Reviewed | Dual role - same as Student |
| Jamie Chen (JC) | Creator | ✅ Reviewed | Same as Student-Teacher (gap) |
| Marcus Johnson (MJ) | Admin | ⚠️ Not Implemented | Shows Teacher view (gap) |

**Key Finding:** All personas share the same demo data. No role-specific differentiation implemented yet.

---

## Navigation Structure Discovered

### Left Sidebar (Persistent)

**DISCOVER Section:**
| Item | Purpose |
|------|---------|
| How It Works | Platform explainer / value proposition |
| Communities | Browse instructor communities |
| Courses | Browse course catalog |

**MY STUFF Section:**
| Item | Purpose |
|------|---------|
| My Communities | Joined communities feed |
| My Courses | Enrolled courses |
| Notifications | Activity notifications |
| Dashboard | Learning & Teaching hub |
| Messages | Direct messaging |
| Profile | User profile & settings |

### Top Navigation Patterns

**Community Switcher (My Communities):**
- Horizontal scrollable tabs showing joined communities
- Town Hall (platform) + instructor communities
- "+ Find" button for discovery

**Course Detail Tabs:**
- Course Feed | Overview | Curriculum | Reviews

**Profile Tabs:**
- Overview | Bookmarks | History | Settings | Privacy & Security | Help & Support | Edit

---

## Pages Documented (13 Total)

### Page 1: Demo Account Selector (Mobile)
- **Purpose:** Select persona for demo experience
- **URL:** Root landing for demo mode
- **Note:** Mobile layout; all subsequent pages are desktop

### Page 2: Login
- **Purpose:** User authentication
- **URL pattern:** `/login`
- **Fields:** Email, Password
- **Schema:** Standard - covered

### Page 3: Topic Selection (Onboarding)
- **Purpose:** Capture user learning interests
- **URL pattern:** `/onboarding/interests`
- **UI:** Multi-select chip/tag picker
- **Topics observed:** Vibe Coding, AI & Machine Learning, Web Development, Python, Data Science, Mobile Development, UI/UX Design, Blockchain, Game Development, Cloud Computing, Cybersecurity, No-Code Tools
- **KEEPER:** Topic/interest tracking system

### Page 4: How It Works
- **Purpose:** Platform explainer (static content)
- **URL pattern:** `/how-it-works`
- **Content:** Learn-Teach-Earn flywheel visualization, usage steps
- **Business rule confirmed:** 70% revenue share for student-teachers
- **Schema:** Minimal - static content

### Page 5: Communities (Browse)
- **Purpose:** Discover and join instructor communities
- **URL pattern:** `/communities`
- **UI:** Search + card list
- **Community card:** Instructor avatar/name/title + community bio/tags/stats
- **Stats shown:** Members, Rating, Course count
- **Insight:** Community = Instructor's community (1:1 relationship for instructors)

### Page 6: Courses (Browse)
- **Purpose:** Discover and browse courses
- **URL pattern:** `/courses`
- **UI:** Search + course cards + instructor community sidebar
- **Course card:** Badge, Title, Instructor, Duration, Description, Rating, Students, Level
- **Badges observed:** BESTSELLER, POPULAR
- **Sidebar:** Instructor community preview (reinforces course→community connection)

### Page 7: Course Detail (Unenrolled)
- **Purpose:** Course information + enrollment CTA
- **URL pattern:** `/courses/:slug`
- **Header:** Title, description, instructor, price, "Enroll for $X" CTA
- **Tabs:** Course Feed (gated) | Overview | Curriculum | Reviews
- **KEEPER:** Course Feed is enrollment-gated

### Page 8: Course Detail - Overview Tab
- **Content:** Video preview, full description, "What you'll learn" list
- **Sidebar:** Instructor card, Course Details (modules, lessons, lifetime access, certificate)
- **KEEPER:** Video preview, learning outcomes list

### Page 9: Course Detail - Curriculum Tab
- **Content:** Numbered module list with titles and durations
- **Sample:** 6 modules ranging 45min to 2hr

### Page 10: Course Detail - Reviews Tab
- **Content:** Empty state - "No Reviews Yet"
- **KEEPER:** Course reviews system

### Page 11: My Courses (Empty State)
- **Purpose:** Show enrolled courses
- **URL pattern:** `/my-courses`
- **Empty state:** "No courses yet" + "Browse Courses" CTA

### Page 12: My Communities (With Data)
- **Purpose:** View/interact with joined communities
- **URL pattern:** `/my-communities`
- **Key finding:** New users auto-join Town Hall + some instructor communities
- **Top:** Community switcher (tabs for each joined community)
- **Content:** Post composer + feed with posts
- **Post structure:** Avatar, name, @username, timestamp, badges, content, engagement stats
- **Badges:** Pinned, community source (e.g., "Jane's Town Hall")
- **Engagement:** Comments, Reposts, Likes, Bookmark, Share
- **Platform accounts:** @peerloop (Team), @peerloop_events (Events)

### Page 13: Notifications
- **Purpose:** Activity notifications
- **URL pattern:** `/notifications`
- **Tabs:** All | Mentions
- **Notification types observed:**
  - Likes (heart icon)
  - Replies (speech bubble)
  - Mentions (@ icon)
  - Reposts (repost icon)
  - Community joins (person icon)
  - Session bookings (calendar icon) **KEEPER**
  - Course enrollments (graduation cap)
  - Achievements (star icon) - "Student-Teacher certification" **KEEPER**
- **UI:** Stacked avatars for multiple actors, blue unread dot, timestamps

### Page 14: Dashboard
- **Purpose:** Central hub for learning & teaching activity
- **URL pattern:** `/dashboard`
- **Top right:** Availability toggle ("Available" in green) **KEEPER**
- **Tabs:** Learning | Teaching **KEEPER**
- **Empty state (Learning):** "No courses yet" + scheduled sessions mention
- **KEEPER:** Dual-mode dashboard (learner + teacher views)

### Page 15: Messages (Empty State)
- **Purpose:** Direct messaging
- **URL pattern:** `/messages`
- **Empty state:** Generic placeholder ("No content available")
- **Note:** Page likely not fully built out

### Page 16: Profile
- **Purpose:** User profile & account settings
- **URL pattern:** `/profile`
- **Tabs:** Overview | Bookmarks | History | Settings | Privacy & Security | Help & Support | Edit
- **Profile fields:** Name, @username, bio, joined date, last active, email, location, website
- **Stats (for creators/teachers):** Content Created, Students, Rating
- **KEEPERS:** Bookmarks tab, History tab, Last active indicator
- **Demo control:** "Switch User" button

---

## Additional Pages from Other Personas

### Profile Tabs (Complete) - New User

**Profile - Bookmarks Tab:**
- Header: "Bookmarked Content"
- Content types: Course, Article (multiple types supported)
- Card structure: Title, Bookmarked date, Type, Recency indicator
- **Schema:** `user_bookmarks` with polymorphic content_type, content_id

**Profile - History Tab:**
- Header: "Learning History"
- Shows: Completed courses with grades, in-progress courses with percentage
- Fields: Session title, date, status (Completed/Started), time spent, grade (A+, A, etc.)
- **KEEPER:** Letter grades (A+, A, B+), time spent tracking (hours)

**Profile - Settings Tab:**
- Sections: Notifications, Display
- Notification toggles: Email, Push, Course updates
- Display toggles: Dark Mode, Show progress bars

**Profile - Privacy & Security Tab:**
- Profile Visibility dropdown (Public/Private/Followers Only)
- Two-Factor Authentication toggle
- Change Password button

**Profile - Help & Support Tab:**
- FAQ, Contact Support, Documentation links

**Profile - Edit:**
- Global toggle (UX concern - should be per-section)

---

### My Courses (Populated) - Sarah Miller (Student)

**Tabs:** All Courses (3) | In Progress (3) | Completed (0) + Search

**Course Card (Enrolled):**
| Element | Details |
|---------|---------|
| Status badge | ▶ IN PROGRESS (green) |
| Title | Course name |
| Instructor | Name + duration + "Go to Community" link |
| Rating/Students | ⭐ 4.8 | 👥 15,678 students |
| Progress | 81% with visual bar |
| Lessons | 5/20 lessons |
| CTA | "Continue →" |

**KEEPER:** Lesson-level progress tracking ("5/20 lessons")

---

### Course Progress Page (Enrolled View) - Jamie Chen

**THE RICHEST PAGE - Accessed via "Continue" on enrolled course**

**Instructor Header:**
- Avatar, name, title, stats (rating, students, courses)
- Buttons: ✓ Joined, View All Courses, Go to Community

**Course Header:**
- 🎓 ENROLLED COURSE badge
- ✓ ENROLLED · Started [date]

**UPCOMING SESSION:**
- Session name, date/time, instructor
- Actions: Join Session, Add to Calendar, Reschedule

**HOMEWORK DUE:**
- Assignment name with due date countdown
- Actions: View Assignment, Submit

**YOUR PROGRESS:**
| Metric | Example |
|--------|---------|
| Sessions Completed | 3/8 |
| Homework Submitted | 2/3 |
| Average Score | 90% |

**SESSION LIST:**
| Status | Display |
|--------|---------|
| Completed | Date · Completed | HW: 92% |
| Scheduled | Date · Time | 🗓 After session |
| Not scheduled | "Not scheduled" |

**RESOURCES (per session):**
- 🎥 Recording, 📄 Slides, 💻 Code Files
- "Download All Materials" button

**NEED EXTRA HELP?:**
- "Book a 1-on-1 tutoring session with a Student-Teacher"
- "Browse Student-Teachers →" CTA

**CLASS DISCUSSION:**
- "5 new posts since Session 3"
- "View Discussion →"

**CERTIFICATE OF COMPLETION:**
- Progress bar toward certificate
- "Complete X more sessions to earn your certificate"

**KEEPERS from this page:**
1. Session-based course structure (8 sessions)
2. Homework tracking with due dates and scores
3. Per-session resources (Recording, Slides, Code Files)
4. Browse Student-Teachers CTA
5. Class Discussion with "new since last session" count
6. Certificate progress visualization

---

### Dashboard - Learning Tab (Populated) - Sarah Miller

**Stats Row:** 3 in progress | 0 completed | 0 certificates

**COURSES IN PROGRESS:**
- Compact cards: Title, Instructor, Module progress, "Continue" button

---

### Dashboard - Teaching Tab (Populated) - Sarah Miller / All Users

**Stats Row:** $420 pending | 4 students | 8 sessions this week

**Weekly Availability:**
- "Set when students can book sessions with you"
- "Set Hours" button

**ACTION NEEDED (red):**
- 🎓 "[Student] ready for certification" → "Review" button
- 💬 "X unread messages" → "View" button

**TODAY'S SESSIONS:**
| Time | Course | Student | Actions |
|------|--------|---------|---------|
| 2:00 PM | Python Basics | John Miller | Join BBB, Message, Cancel |

**UPCOMING:**
- Future sessions with date/time
- **KEEPER:** Group Session support ("Group Session · 4 students")

**MY STUDENTS:**
| Student | Course | Progress | Action |
|---------|--------|----------|--------|
| John Miller | Python Basics | Module 3 of 6 | Message |
| Sarah Kim | Data Analysis | Complete ✓ | **Recommend** |
| Emily Zhang | Python Basics | Module 1 of 6 | Message |

**EARNINGS:**
| Metric | Amount |
|--------|--------|
| Pending Balance | $420.00 |
| This Month | $1,680.00 |
| All Time | $2,520.00 |
| Next payout | Dec 20, 2025 · $380.00 (70%) |

**KEEPERS from Teaching Dashboard:**
1. Weekly availability management
2. Action needed alerts (certification queue)
3. Today's Sessions with Join BBB + Message + Cancel
4. Group sessions (not just 1:1)
5. "Recommend" button for certification workflow
6. Earnings dashboard with 70% payout display

---

## Keepers (New Features to Document)

### From Topic Selection (Page 3)
1. **Topics/Interests System**
   - Users select learning interests during onboarding
   - Multi-select from predefined list
   - "You can change these later"
   - Used for algorithmic feed relevance

### From Town Hall / My Communities (Page 12)
2. **Community as Flexible Entity**
   - Communities can be owned by: platform (Town Hall), instructors, courses, possibly users
   - Core function: Subscribe/invite → access to discussions, news, Q&A
   - Architecture must accommodate future community types

3. **Post Engagement Actions**
   - Comments, Reposts, Likes, Bookmarks, Shares
   - Stacked avatars for multiple actors
   - Pinned posts

### From Course Detail (Pages 7-10)
4. **Course Feed (Gated)**
   - Each course has a community/feed
   - Access requires enrollment
   - Separate from instructor-level feed

5. **Video Preview**
   - Course has preview video on Overview tab
   - Shows thumbnail with play button

6. **Learning Outcomes**
   - "What you'll learn" bullet list on Overview
   - Separate from curriculum

7. **Course Reviews**
   - Reviews tab with rating system
   - Implies `course_reviews` table

### From Notifications (Page 13)
8. **Session Booking System**
   - "Rachel Green booked a session with you"
   - Includes course context + datetime
   - 1-on-1 session scheduling

9. **Student-Teacher Certification**
   - Achievement notification: "You've been certified as a Student-Teacher"
   - Milestone in the learn-teach-earn flow

### From Dashboard (Page 14)
10. **Availability Toggle**
    - Users can indicate Available/Unavailable status
    - Presumably for teaching sessions
    - Green indicator when available

11. **Learning vs Teaching Tabs**
    - Dashboard splits between learner mode and teacher mode
    - Embodies dual-role nature of platform

12. **Scheduled Sessions Display**
    - "Your scheduled sessions will appear here"
    - Dashboard is central hub for session management

### From Profile (Page 16)
13. **Bookmarks**
    - Separate tab for saved/bookmarked content
    - Ties to bookmark action on posts

14. **History**
    - Activity history tab
    - User can review past activity

15. **Creator/Teacher Stats**
    - Content Created count
    - Students count
    - Rating display

---

## Schema Implications

### New Tables Needed

| Table | Purpose |
|-------|---------|
| `topics` | Predefined learning topics/interests |
| `user_topics` | Junction: user_id, topic_id |
| `communities` | Flexible entity (platform/instructor/course/user owned) |
| `community_members` | Junction with role, joined_at |
| `posts` | Community posts with engagement tracking |
| `post_likes` | Junction: user_id, post_id |
| `post_bookmarks` | Junction: user_id, post_id |
| `post_reposts` | Junction with created_at |
| `course_reviews` | Course ratings and reviews |
| `course_learning_outcomes` | "What you'll learn" items |
| `sessions` | Booked 1-on-1 sessions |
| `user_availability` | Availability status for teaching |

### New Fields on Existing Tables

| Table | Field | Type | Notes |
|-------|-------|------|-------|
| `users` | username | string | @handle format |
| `users` | is_available | boolean | Teaching availability toggle |
| `users` | last_active_at | timestamp | Activity indicator |
| `users` | is_system_account | boolean | For @peerloop, @peerloop_events |
| `courses` | preview_video_url | string | Overview tab video |
| `posts` | is_pinned | boolean | Sticky posts |
| `posts` | community_id | uuid | FK to communities |
| `posts` | comment_count | int | Denormalized |
| `posts` | repost_count | int | Denormalized |
| `posts` | like_count | int | Denormalized |
| `communities` | owner_type | enum | platform, instructor, course, user |
| `communities` | owner_id | uuid | Polymorphic FK |
| `communities` | member_count | int | Denormalized |

---

## Questions for Brian

1. **Community Structure:** Is instructor community the same as `instructor_followers` from CD-024, or a separate entity?

2. **Channels within Communities:** Are "Everyone" and "creator-2" (seen in post badges) channels/sub-groups, or test artifacts?

3. **Auto-join Rules:** Which communities do new users automatically join? Just Town Hall, or also some instructors?

4. **Course vs Instructor Feed:** User pays for course → gets course feed access. User pays for ANY course from instructor → gets instructor feed access. Correct?

5. **Availability States:** Just Available/Unavailable, or more states (Busy, etc.)?

6. **Session Booking Integration:** Is this BBB, or a scheduling-first flow that leads to BBB?

---

## Prototype Gaps & Issues for Brian

### Critical Gaps

| Gap | Description | Impact |
|-----|-------------|--------|
| **Admin not implemented** | Marcus Johnson (Admin) shows same view as Teacher | No admin dashboard, user management, analytics |
| **Creator same as ST** | Jamie Chen (Creator) has identical Dashboard to Student-Teacher | No course management, creator analytics, ST approval queue |
| **No user menu in header** | No avatar/icon showing current user, no logout | Users can't see who they're logged in as or log out |

### UX Issues

| Issue | Current State | Suggested Fix |
|-------|---------------|---------------|
| No user indicator | No header element shows current user | Add user avatar dropdown in top-right |
| No logout | No way to log out visible | Add to user dropdown menu |
| Settings buried | Settings only in Profile tabs | Add Settings shortcut to user dropdown |
| Global Edit toggle | Edit button toggles mode for all Profile tabs | Per-section inline editing or separate Edit page |
| Mentions tab broken | Clicking Mentions tab does nothing | Implement or hide if not ready |

### Missing Features for Roles

**Creator Dashboard should include:**
- My Created Courses (courses they own)
- Course analytics (enrollments, completions, revenue)
- Student-Teacher management for their courses
- Certification approval queue (per CD-019)
- Course revenue (15% royalty) vs teaching earnings (70%)

**Admin Dashboard should include:**
- User management (create, suspend, change roles)
- Platform analytics
- Content moderation queue
- Payment/payout oversight
- System settings

### Data Inconsistencies

- Progress percentages vary between My Courses and Dashboard for same courses
- All personas share identical demo data (no role-specific differentiation)
- Some test artifacts visible ("in creator-2", "in Everyone" badges)

---

## Updated Questions for Brian

### Original Questions
1. **Community Structure:** Is instructor community the same as `instructor_followers` from CD-024, or a separate entity?
2. **Channels within Communities:** Are "Everyone" and "creator-2" (seen in post badges) channels/sub-groups, or test artifacts?
3. **Auto-join Rules:** Which communities do new users automatically join? Just Town Hall, or also some instructors?
4. **Course vs Instructor Feed:** User pays for course → gets course feed access. User pays for ANY course from instructor → gets instructor feed access. Correct?
5. **Availability States:** Just Available/Unavailable, or more states (Busy, etc.)?
6. **Session Booking Integration:** Is this BBB, or a scheduling-first flow that leads to BBB?

### New Questions from Walkthrough
7. **Creator Dashboard:** Does Creator need separate "Creator Studio" or third tab beyond Learning/Teaching?
8. **Admin Features:** What admin capabilities are needed for MVP vs post-MVP?
9. **User Menu:** Confirm need for header user dropdown with avatar, settings, logout?
10. **Group Sessions:** Are group sessions (4+ students) part of MVP? Prototype shows "Group Session · 4 students"
11. **Homework System:** Is homework submission/grading part of MVP? Prototype shows detailed homework tracking
12. **Session Resources:** Are per-session resources (Recording, Slides, Code Files) stored in platform or external links?

---

## Next Steps

1. ✅ **All personas reviewed** - Complete
2. **Review gaps with Brian** - Confirm which are prototype limitations vs design gaps
3. **Update DB-SCHEMA.md** with confirmed new tables/fields
4. **Update PAGES.md** with page inventory (20+ pages discovered)
5. **Update COMPONENTS.md** with UI patterns discovered
6. **Prioritize keepers** - Which are MVP vs post-MVP?

---

## Summary Statistics

| Metric | Count |
|--------|-------|
| Personas reviewed | 5 (all) |
| Pages documented | 20+ |
| Keepers identified | 30+ |
| New tables implied | 15+ |
| New fields implied | 25+ |
| Gaps identified | 5 critical |
| UX issues | 5 |
| Questions for Brian | 12 |

---

## Appendix: Complete Keepers List

### Core Features (15 from baseline)
1. Topics/Interests system
2. Community as flexible entity
3. Post engagement (comments, reposts, likes, bookmarks, shares)
4. Course Feed (enrollment-gated)
5. Video preview on courses
6. Learning outcomes list
7. Course reviews system
8. Session booking system
9. Student-Teacher certification
10. Availability toggle
11. Learning vs Teaching dashboard tabs
12. Scheduled sessions display
13. Bookmarks (polymorphic)
14. History (learning)
15. Creator/Teacher stats

### Additional Features (15+ from other personas)
16. Lesson-level progress tracking
17. Letter grades (A+, A, B+)
18. Time spent tracking (hours)
19. Session-based course structure
20. Homework tracking with due dates and scores
21. Per-session homework scores
22. Session resources (Recording, Slides, Code Files)
23. Download All Materials
24. Browse Student-Teachers CTA
25. Class Discussion with "new since last session"
26. Certificate progress visualization
27. Weekly availability management
28. Action needed alerts
29. Group sessions (not just 1:1)
30. "Recommend" button for certification
31. Earnings dashboard with pending/monthly/all-time
