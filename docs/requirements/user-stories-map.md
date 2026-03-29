# User Stories Map

**Purpose:** Master index of all user stories for page-to-story assignment
**Total Stories:** 402
**Source:** [USER-STORIES.md](USER-STORIES.md) and [stories/](stories/)

> **Route Mapping:** For the canonical route→story assignment, see [ROUTE-STORIES.md](../docs/as-designed/route-stories.md) (402 stories mapped to current routes, created Session 306).

---

## Quick Navigation

| Role | Code | Stories | P0 | P1 | P2 | P3 | Jump |
|------|------|---------|----|----|----|----|------|
| [Visitor/Guest](#visitor-guest-us-g) | G | 18 | 11 | 7 | 0 | 0 | [US-G](#visitor-guest-us-g) |
| [Student](#student-us-s) | S | 95 | 43 | 29 | 21 | 2 | [US-S](#student-us-s) |
| [Teacher](#teacher-us-t) | T | 35 | 16 | 9 | 10 | 0 | [US-T](#teacher-us-t) |
| [Creator-Instructor](#creator-instructor-us-c) | C | 57 | 16 | 25 | 14 | 1 | [US-C](#creator-instructor-us-c) |
| [Admin](#admin-us-a) | A | 60 | 35 | 19 | 6 | 0 | [US-A](#admin-us-a) |
| [Employer/Funder](#employer-funder-us-e) | E | 6 | 0 | 5 | 1 | 0 | [US-E](#employer-funder-us-e) |
| [Moderator](#moderator-us-m) | M | 9 | 2 | 6 | 1 | 0 | [US-M](#moderator-us-m) |
| [Video/Session](#video-session-us-v) | V | 11 | 4 | 6 | 1 | 0 | [US-V](#video-session-us-v) |
| [Platform](#platform-us-p) | P | 100 | 57 | 19 | 19 | 5 | [US-P](#platform-us-p) |
| **Total** | | **402** | **184** | **125** | **73** | **8** | |

---

## Priority Legend

- **P0:** MVP critical - required for Genesis Cohort launch (184 stories)
- **P1:** High priority - needed for full flywheel validation (125 stories)
- **P2:** Medium priority - enhances experience (73 stories)
- **P3:** Nice to have - future consideration (8 stories)

---

## Visitor / Guest (US-G)

**Source:** [stories/stories-G-visitor.md](stories/stories-G-visitor.md)
**Description:** Non-logged in user browsing public site
**Count:** 18 stories (P0: 11, P1: 7)

### Homepage & Promotional Content

| ID | Story | Priority |
|----|-------|----------|
| US-G001 | As a Visitor, I need to view the homepage so that I can understand what PeerLoop offers | P0 |
| US-G002 | As a Visitor, I need to see promotional content (how it works, benefits, pricing info) so that I can decide if PeerLoop is right for me | P0 |
| US-G003 | As a Visitor, I need to see success stories or testimonials so that I can trust the platform | P1 |
| US-G004 | As a Visitor, I need to see the value proposition (Learn, Teach, Earn) so that I understand the unique model | P0 |

### Course Discovery

| ID | Story | Priority |
|----|-------|----------|
| US-G005 | As a Visitor, I need to browse available courses so that I can see what I could learn | P0 |
| US-G006 | As a Visitor, I need to view course details (description, curriculum outline, price) so that I can evaluate courses | P0 |
| US-G007 | As a Visitor, I need to see course pricing without logging in so that I can assess affordability | P0 |

### Creator/Teacher Discovery

| ID | Story | Priority |
|----|-------|----------|
| US-G008 | As a Visitor, I need to view creator profiles (public info) so that I can evaluate their expertise | P0 |
| US-G009 | As a Visitor, I need to see Teacher profiles (public info) so that I can see who might teach me | P1 |
| US-G010 | As a Visitor, I need to see creator credentials and course stats so that I can trust the instructors | P1 |

### Authentication Actions

| ID | Story | Priority |
|----|-------|----------|
| US-G011 | As a Visitor, I need to sign up for an account so that I can enroll in courses | P0 |
| US-G012 | As a Visitor, I need to log in to my existing account so that I can access my enrolled courses | P0 |
| US-G013 | As a Visitor, I need to reset my password if forgotten so that I can recover my account | P0 |

### Access Restrictions

| ID | Story | Priority |
|----|-------|----------|
| US-G014 | As a Visitor, I need to see a prompt to sign up when I try to enroll so that I understand registration is required | P0 |
| US-G015 | As a Visitor, I need to see gated content indicators (e.g., "Sign in to view community") so that I know what requires login | P1 |

### Trust-Building Before Purchase

| ID | Story | Priority |
|----|-------|----------|
| US-G016 | As a Visitor, I need to send an inquiry/question to a Creator before enrolling so that I can build trust before committing to payment | P0 |
| US-G017 | As a Visitor, I need to book a free 15-minute intro session with a Teacher so that I can experience the platform's live 1-on-1 format before paying | P1 |
| US-G018 | As a Visitor, I need to view course pricing as tiered options (e.g., $150 per course level) so that I can start with a lower commitment and upgrade if satisfied | P1 |

---

## Student (US-S)

**Source:** [stories/stories-S-student.md](stories/stories-S-student.md)
**Description:** Learner progressing through courses
**Count:** 95 stories (P0: 43, P1: 29, P2: 21, P3: 2)

### Discovery & Enrollment

| ID | Story | Priority |
|----|-------|----------|
| US-S001 | As a Student, I need to see what tutor courses are available so that I can choose what to learn | P0 |
| US-S002 | As a Student, I need to pay for tutors so that I can access learning | P0 |
| US-S003 | As a Student, I need to search for courses so that I can find relevant content | P0 |
| US-S004 | As a Student, I need to search for Creators/Instructors with detailed profiles so that I can evaluate teachers | P0 |
| US-S005 | As a Student, I need to view course detail pages with curriculum outline and time estimates so that I understand the commitment | P0 |
| US-S006 | As a Student, I need action buttons (Enroll, Explore Teaching, Follow Course, Join Community) so that I can take next steps | P0 |
| US-S007 | As a Student, I need related courses suggestions so that I can continue learning | P2 |
| US-S083 | As a Student, I need to see Teacher availability calendar (with dots on available dates) during enrollment so that I know when tutoring is available before purchasing | P0 |
| US-S084 | As a Student, I need to see a list of available Teachers with their times during enrollment so that I can choose who to book | P0 |
| US-S085 | As a Student, I need a "Schedule Later" option during enrollment so that I can purchase without immediately booking a session | P0 |
| US-S086 | As a Student, I need to be able to request a refund at any time so that I can exit if the tutoring doesn't meet my needs | P0 |

### Profile & Account

| ID | Story | Priority |
|----|-------|----------|
| US-S008 | As a Student, I need to enter a profile with picture (public and private sections) so that I control my visibility | P0 |
| US-S009 | As a Student, I need a unified dashboard for student/teacher activity tracking so that I see my progress | P0 |
| US-S010 | As a Student, I need a calendar view so that I can manage my schedule | P1 |
| US-S011 | As a Student, I need quick action buttons so that common tasks are accessible | P1 |
| US-S012 | As a Student, I need earnings tracking so that I can see my teaching income | P0 |

### Session Management

| ID | Story | Priority |
|----|-------|----------|
| US-S013 | As a Student, I need to reschedule a session with teacher so that I can handle conflicts | P1 |
| US-S014 | As a Student, I need to cancel a session so that I can handle emergencies | P1 |
| US-S015 | As a Student, I need to cancel a course (with reason) so that I can exit if needed | P1 |

### Communication

| ID | Story | Priority |
|----|-------|----------|
| US-S016 | As a Student, I need to message teachers so that I can ask questions | P0 |
| US-S017 | As a Student, I need to message other students so that I can collaborate (noted as tricky) | P2 |
| US-S018 | As a Student, I need to message AP so that I can get support | P0 |
| US-S019 | As a Student, I need a private messaging system so that I can have 1-on-1 conversations | P0 |

### Progression & Certification

| ID | Story | Priority |
|----|-------|----------|
| US-S020 | As a Student, I need to apply for teacher status so that I can transition to earning | P0 |
| US-S021 | As a Student, I need to earn a Learning Certificate upon completion so that my achievement is recognized | P0 |
| US-S022 | As a Student, I need to earn a Teaching Certificate when I become a teacher so that my teaching ability is credentialed | P0 |
| US-S023 | As a Student, I need my Teaching Certificate to dynamically update with student count so that my experience is visible | P1 |
| US-S024 | As a Student, I need access to gated communities based on credentials so that I can join advanced groups | P1 |

### Community & Discovery

| ID | Story | Priority |
|----|-------|----------|
| US-S025 | As a Student, I need an X.com-style algorithmic feed of followed content so that I discover relevant posts | P1 |
| US-S026 | As a Student, I need to refer potential students to AP re: courses and teachers so that I can help others | P2 |
| US-S027 | As a Student, I need to ask AI for assistance when both teacher and student are stumped so that learning continues | P1 |
| US-S028 | As a Student, I need to follow creators so that their content appears in my feed before I enroll | P0 |
| US-S029 | As a Student, I need to select a Teacher Student (with random as default) so that I can choose my mentor | P1 |
| US-S030 | As a Student, I need to earn goodwill points through participation so that my engagement is recognized | P2 |
| US-S031 | As a Student, I need to see my power user level/tier so that I can track my community standing | P2 |
| US-S032 | As a Student, I need to earn a Certificate of Mastery (separate from completion) so that I can prove deeper understanding | P1 |
| US-S033 | As a Student, I need to request content that doesn't exist so that gaps in course offerings are filled | P2 |
| US-S034 | As a Student, I need to opt out of a Teacher Student relationship at any point so that I can find a better match | P1 |
| US-S035 | As a Student, I need to select a Teacher Student by schedule availability so that I can book convenient times | P1 |

### Community Feed Interactions

| ID | Story | Priority |
|----|-------|----------|
| US-S036 | As a Student, I need to create text posts in the community feed so that I can share questions and updates | P0 |
| US-S037 | As a Student, I need to like posts so that I can show appreciation | P0 |
| US-S038 | As a Student, I need to bookmark posts so that I can save content for later | P1 |
| US-S039 | As a Student, I need to reply to posts so that I can engage in discussions | P0 |
| US-S040 | As a Student, I need to repost content so that I can share valuable posts with my followers | P1 |
| US-S041 | As a Student, I need to flag inappropriate content so that moderators can review it | P1 |

### Video Session & Scheduling

| ID | Story | Priority |
|----|-------|----------|
| US-S042 | As a Student, I need to join video sessions directly from my dashboard so that I don't need external links | P0 |
| US-S043 | As a Student, I need to join video sessions from email notification links so that I can connect quickly | P0 |
| US-S044 | As a Student, I need to click "Schedule Session" from a course listing so that I can book a tutoring session | P0 |
| US-S045 | As a Student, I need to see a list of available Teacher time slots for a selected day so that I can choose a convenient time | P0 |
| US-S046 | As a Student, I need to receive both email and in-app notifications when I book a session so that I have confirmation | P0 |

### Student Profile Features

| ID | Story | Priority |
|----|-------|----------|
| US-S047 | As a Student, I need a privacy toggle (public/private) on my profile so that I control my visibility | P0 |
| US-S048 | As a Student, I need to follow other users (students, Teachers) so that I can build connections | P0 |
| US-S049 | As a Student, I need to view my followers and following lists so that I can see my network | P1 |
| US-S050 | As a Student, I need to browse a Teacher directory so that I can discover who can teach me | P0 |
| US-S051 | As a Student, I need to search for Teachers by name or interests so that I can find a good match | P1 |

### Course Content & Discovery

| ID | Story | Priority |
|----|-------|----------|
| US-S052 | As a Student, I need a course page with organized module structure so that I can see the full learning path | P0 |
| US-S053 | As a Student, I need to access video content via external links (YouTube/Vimeo) so that I can watch lessons | P0 |
| US-S054 | As a Student, I need to access document links (Google Drive/Notion) so that I can read course materials | P0 |
| US-S055 | As a Student, I need to self-mark module progress (checkboxes) so that I can track my completion | P0 |
| US-S056 | As a Student, I need to schedule my next session from the course page so that I can continue my learning rhythm | P0 |
| US-S057 | As a Student, I need to filter courses by difficulty level (Beginner/Intermediate/Advanced) so that I can find courses appropriate for my skill level | P1 |
| US-S058 | As a Student, I need to browse/filter courses by category so that I can find courses in my area of interest | P1 |
| US-S059 | As a Student, I need to see learning objectives on the course detail page so that I understand what I'll learn | P1 |
| US-S060 | As a Student, I need to see what's included with a course (materials, sessions, certificates) so that I understand the value | P0 |
| US-S061 | As a Student, I need to see available Teachers for a specific course so that I can choose who to learn from | P1 |

### Goodwill Points System

*Note: Block 2+ feature - NOT included in MVP.*

| ID | Story | Priority |
|----|-------|----------|
| US-S062 | As a Student, I need to summon help from certified peers when I'm stuck so that I can get assistance on course content | P2 |
| US-S063 | As a Student, I need to see how many helpers are available on my course page so that I know if help is accessible | P2 |
| US-S064 | As a Student, I need to award goodwill points (10-25 slider) to helpers after a summon session so that I can recognize their contribution | P2 |
| US-S065 | As a Student, I need to mark messages as questions in course chat so that helpers can identify where help is needed | P2 |
| US-S066 | As a Student, I need to award "This Helped" points (5) to helpful answers in chat so that I can thank helpers | P2 |
| US-S067 | As a Student, I need to see my goodwill balance and history (private view) so that I can track my community participation | P2 |
| US-S068 | As a Student, I need to see my total earned goodwill points on my public profile so that my credibility is visible | P2 |

### Feed Access & Promotion

| ID | Story | Priority |
|----|-------|----------|
| US-S069 | As a Student, I need to access a course's community feed after paying for the course so that I can see posts from other students and Teachers in that course | P0 |
| US-S070 | As a Student, I need to access an Instructor's public feed after paying for ANY of their courses so that I can stay connected with the instructor's broader community | P1 |
| US-S071 | As a Student, I need to spend goodwill points to promote my post to the main Peer Loop feed so that my helpful content reaches a wider audience | P3 |

### Course Display Enhancement

| ID | Story | Priority |
|----|-------|----------|
| US-S072 | As a Student, I need to see course prerequisites (required, nice-to-have, not-required) so that I know what I need before enrolling | P1 |
| US-S073 | As a Student, I need to see target audience descriptions so that I know if the course is right for me | P1 |
| US-S074 | As a Student, I need to see course testimonials from past students so that I can gauge course quality and satisfaction | P2 |
| US-S075 | As a Student, I need to see the course format (e.g., "Live 1-on-1 sessions", session count, duration) so that I understand how the course is delivered | P0 |

### Feed Companion & Noise Reduction

| ID | Story | Priority |
|----|-------|----------|
| US-S076 | As a Student, I need to pin posts/authors in a feed companion UI so that I can track specific content without losing it in the scroll | P2 |
| US-S077 | As a Student, I need to see the original pinned post plus only the latest thread comment so that I can stay updated without noise | P2 |
| US-S078 | As a Student, I need to see a "recent posters" panel showing the 10 most recent users with 24hr post counts so that I can quickly find active discussions | P2 |
| US-S079 | As a Student, I need an AI Chat component in the feed so that I can ask for what I want to see | P3 |

### Onboarding & Additional Features

| ID | Story | Priority |
|----|-------|----------|
| US-S080 | As a Student, I need an onboarding flow to capture my interests so that my feed is personalized from day one | P1 |
| US-S081 | As a Student, I need to create a sub-community and invite specific users so that I can form study groups or interest clusters | P3 |
| US-S082 | As a Student, I need to request additional tutoring sessions beyond my course allocation so that I can get extra help if needed | P2 |

### Homework

| ID | Story | Priority |
|----|-------|----------|
| US-S087 | As a Student, I need to view homework assignments for my enrolled courses so that I know what work is expected | P0 |
| US-S088 | As a Student, I need to submit homework with text and/or file attachments so that I can complete assignments | P0 |
| US-S089 | As a Student, I need to see feedback on my submitted homework so that I can learn from the review | P0 |
| US-S090 | As a Student, I need to resubmit homework if the reviewer requests changes so that I can improve my work | P1 |

### Session Resources

| ID | Story | Priority |
|----|-------|----------|
| US-S091 | As a Student, I need to access recordings of sessions I attended so that I can review the material | P0 |
| US-S092 | As a Student, I need to download materials shared by my ST so that I can reference them later | P0 |
| US-S093 | As a Student, I need to access course-level resources (slides, docs) so that I have additional learning materials | P0 |

### Privacy

| ID | Story | Priority |
|----|-------|----------|
| US-S094 | As a Student, I need my profile to be private by default so that I control who sees my information | P0 |
| US-S095 | As a Student, I need to choose to make my profile public so that I can be discovered by others when ready | P1 |

---

## Teacher (US-T)

**Source:** [stories/stories-T-st.md](stories/stories-T-st.md)
**Description:** Graduate who teaches peers (earns 70%)
**Count:** 35 stories (P0: 16, P1: 9, P2: 10)

### Scheduling & Availability

| ID | Story | Priority |
|----|-------|----------|
| US-T001 | As a Teacher, I need to offer times for tutoring via a calendar of availability so that students can book me | P0 |
| US-T002 | As a Teacher, I need to cancel a particular scheduled session with a student so that I can handle conflicts | P1 |

### Trust-Building / Free Intro Sessions

| ID | Story | Priority |
|----|-------|----------|
| US-T030 | As a Teacher, I need to conduct free 15-minute intro sessions with potential students so that visitors can experience the platform before enrolling | P1 |
| US-T031 | As a Teacher, I need to mark specific availability slots as "free intro available" so that potential students can find intro session times | P1 |
| US-T032 | As a Teacher, I need to receive notifications for booked intro sessions so that I can prepare for them | P1 |

### Profile & Presence

| ID | Story | Priority |
|----|-------|----------|
| US-T003 | As a Teacher, I need to enter a profile with pictures, videos, PDFs so that students can evaluate me | P0 |
| US-T004 | As a Teacher, I need a public profile showing my credentials so that students trust my expertise | P0 |
| US-T005 | As a Teacher, I need a "Switch User" button to toggle between student and teacher modes so that I can use both functions | P0 |

### Teaching & Certification

| ID | Story | Priority |
|----|-------|----------|
| US-T006 | As a Teacher, I need to grant certificates to students of successful completion so that I can certify learners | P0 |
| US-T007 | As a Teacher, I need to conduct video sessions with screen sharing so that I can teach effectively | P0 |

### Communication & Support

| ID | Story | Priority |
|----|-------|----------|
| US-T008 | As a Teacher, I need to message students so that I can provide support | P0 |
| US-T009 | As a Teacher, I need to message AP so that I can get platform support | P0 |
| US-T010 | As a Teacher, I need to refer potential students to AP re: my courses so that I can grow my student base | P2 |
| US-T011 | As a Teacher, I need to ask AI for assistance when both I and student are stumped so that learning continues | P1 |

### Earnings

| ID | Story | Priority |
|----|-------|----------|
| US-T012 | As a Teacher, I need to receive 70% of session fees so that I earn from teaching | P0 |
| US-T013 | As a Teacher, I need an earnings dashboard so that I can track my income | P0 |
| US-T014 | As a Teacher, I need to opt out of a student relationship at any point so that I can manage difficult situations | P1 |
| US-T015 | As a Teacher, I need to earn points for teaching activity so that my engagement is recognized | P2 |
| US-T016 | As a Teacher, I need verifiable mastery credentials for career advancement so that teaching experience has professional value | P1 |

### Feed Interactions

| ID | Story | Priority |
|----|-------|----------|
| US-T017 | As a Teacher, I need to post my availability to the community feed so that potential students can find me | P0 |
| US-T018 | As a Teacher, I need to share teaching tips in the feed so that I can build my reputation | P1 |

### Video Session & Profile

| ID | Story | Priority |
|----|-------|----------|
| US-T019 | As a Teacher, I need to access recordings of my teaching sessions so that I can review and improve | P1 |
| US-T020 | As a Teacher, I need an "Available as Teacher" toggle so that I appear in the Teacher directory | P0 |
| US-T021 | As a Teacher, I need a "Teaching" badge displayed on my profile so that my role is visible | P0 |
| US-T022 | As a Teacher, I need to display my list of courses certified to teach so that students know my qualifications | P0 |

### Earnings Visibility

| ID | Story | Priority |
|----|-------|----------|
| US-T023 | As a Teacher, I need to see my running balance (pending earnings) so that I know what I will be paid | P0 |

### Goodwill Points System

*Note: Block 2+ feature - NOT included in MVP.*

| ID | Story | Priority |
|----|-------|----------|
| US-T024 | As a Teacher, I need to toggle my "Available to Help" status so that I can receive summon requests when I'm ready | P2 |
| US-T025 | As a Teacher, I need to receive notifications for summon requests so that I can respond to students needing help | P2 |
| US-T026 | As a Teacher, I need to respond to summon requests and join chat/video so that I can help students | P2 |
| US-T027 | As a Teacher, I need to earn goodwill points (10-25) for helping via Summon so that my contributions are recognized | P2 |
| US-T028 | As a Teacher, I need to earn goodwill points (5) for answering chat questions so that helpful answers are rewarded | P2 |
| US-T029 | As a Teacher, I need to earn availability bonus points (5/day) for being available so that I'm incentivized to help | P2 |

### Additional Coaching

| ID | Story | Priority |
|----|-------|----------|
| US-T033 | As a Teacher, I need to offer custom coaching/mentoring sessions so that I can earn additional income from students needing extra help | P2 |

### Homework Review

| ID | Story | Priority |
|----|-------|----------|
| US-T034 | As a Teacher, I need to see pending homework submissions from students I teach so that I can review their work | P0 |
| US-T035 | As a Teacher, I need to review and provide feedback on homework submissions so that students learn from the review | P0 |
| US-T036 | As a Teacher, I need to approve submissions or request resubmission so that I can ensure work quality | P0 |

### Session Resources

| ID | Story | Priority |
|----|-------|----------|
| US-T037 | As a Teacher, I need to upload materials after a session so that students have follow-up resources | P0 |
| US-T038 | As a Teacher, I need to share slides and notes with students I taught so that they can reference the session | P1 |

---

## Creator-Instructor (US-C)

**Source:** [stories/stories-C-creator.md](stories/stories-C-creator.md)
**Description:** Course creator who may also teach directly
**Count:** 57 stories (P0: 16, P1: 25, P2: 14, P3: 1)

### Course Management

| ID | Story | Priority |
|----|-------|----------|
| US-C001 | As a Creator, I need to enter courses, training syllabi, quizzes, reference materials so that students have structured learning paths | P0 |
| US-C002 | As a Creator, I need to define criteria for successful completion so that certification is meaningful | P0 |
| US-C003 | As a Creator, I need to set training progression and criteria to level up so that students advance appropriately | P0 |
| US-C004 | As a Creator, I need to retire a course so that outdated content is removed | P2 |
| US-C005 | As a Creator, I need flexible assessments so that I can test understanding in various ways | P1 |

### Scheduling & Availability

| ID | Story | Priority |
|----|-------|----------|
| US-C006 | As a Creator, I need to offer times for tutoring via a calendar of availability so that students can book sessions | P0 |
| US-C007 | As a Creator, I need to cancel a particular scheduled session with a student so that I can handle conflicts | P1 |

### Profile & Presence

| ID | Story | Priority |
|----|-------|----------|
| US-C008 | As a Creator, I need to enter a profile with pictures, videos, PDFs so that students can evaluate my expertise | P0 |
| US-C009 | As a Creator, I need a profile card with stats (Active Teachers, Avg Taught per Teacher, badges) so that my success is visible | P1 |
| US-C010 | As a Creator, I need a "Creator Studio" button to access course management so that I can easily edit content | P1 |

### Teacher Management

| ID | Story | Priority |
|----|-------|----------|
| US-C011 | As a Creator, I need to vet student-turned-teachers so that teaching quality is maintained | P0 |
| US-C012 | As a Creator, I need to monitor/assess student-turned-teachers so that I can ensure ongoing quality | P1 |
| US-C013 | As a Creator, I need to cancel a student for cause so that I can remove problematic learners | P1 |

### Certification & Assessment

| ID | Story | Priority |
|----|-------|----------|
| US-C014 | As a Creator, I need to grant certificates to students of successful completion so that achievement is recognized | P0 |
| US-C015 | As a Creator, I need to capture and send assessments of students on progress/completion so that progress is documented | P1 |
| US-C016 | As a Creator, I need to earn a teaching certificate for each course taught (displayed on profile) so that my expertise is credentialed | P1 |

### Communication & Support

| ID | Story | Priority |
|----|-------|----------|
| US-C017 | As a Creator, I need to message students so that I can provide guidance and support | P0 |
| US-C018 | As a Creator, I need to message AP so that I can get platform support | P0 |
| US-C019 | As a Creator, I need to refer potential students to AP re: my courses so that I can grow my audience | P2 |
| US-C020 | As a Creator, I need to ask AI for assistance when both teacher and student are stumped so that learning continues | P1 |

### Community Management

| ID | Story | Priority |
|----|-------|----------|
| US-C021 | As a Creator, I need community hubs with forums so that students can interact | P1 |
| US-C022 | As a Creator, I need to assign Community Roles (paid assistants with revenue sharing) so that I can scale my community | P2 |
| US-C023 | As a Creator, I need control over community organization and content delivery so that I can customize the experience | P2 |
| US-C024 | As a Creator, I need to host AMA sessions so that I can build excitement and answer student questions | P2 |
| US-C025 | As a Creator, I need to share student success stories so that I can attract new students | P2 |
| US-C026 | As a Creator, I need to publish newsletters (potentially with subscription payments) so that I can engage my audience | P3 |
| US-C027 | As a Creator, I need to appoint Community Moderators so that I can scale community support | P1 |
| US-C028 | As a Creator, I need extended course analytics so that I can monitor student activity on my courses | P1 |
| US-C029 | As a Creator, I need to access student feedback on each Teacher Student so that I can monitor teaching quality | P1 |
| US-C030 | As a Creator, I need to build a loyal community with high switching cost so that my audience stays engaged | P2 |

### Feed Interactions

| ID | Story | Priority |
|----|-------|----------|
| US-C031 | As a Creator, I need to post course announcements to the feed so that students are informed | P0 |
| US-C032 | As a Creator, I need to pin posts to my course's feed section so that important content is visible | P1 |

### Creator Course Monitoring

| ID | Story | Priority |
|----|-------|----------|
| US-C033 | As a Creator, I need to monitor student completion progress so that I can see how students are advancing | P0 |
| US-C034 | As a Creator, I need to organize course content into modules so that learning is structured | P0 |

### Earnings Visibility

| ID | Story | Priority |
|----|-------|----------|
| US-C035 | As a Creator, I need to see my running balance (pending earnings) so that I know what I will be paid | P0 |

### Profile Discovery

| ID | Story | Priority |
|----|-------|----------|
| US-C036 | As a Creator, I need to display my expertise/specialty tags on my profile so that students can find me by topic | P1 |

### Feed Access

| ID | Story | Priority |
|----|-------|----------|
| US-C037 | As a Creator, I need an instructor-level feed for my current and former students so that I can maintain ongoing community with all my students across courses | P1 |
| US-C038 | As a Creator, I need to see which students have access to my instructor feed so that I know my audience | P2 |

### Course Display Enhancement

| ID | Story | Priority |
|----|-------|----------|
| US-C039 | As a Creator, I need to add prerequisites with different priority levels (required, nice-to-have, not-required) so that students understand requirements clearly | P1 |
| US-C040 | As a Creator, I need to add my teaching philosophy to my profile so that students understand my approach and style | P2 |
| US-C041 | As a Creator, I need to define target audience segments for my course so that the right students find my course | P1 |
| US-C042 | As a Creator, I need to manage course testimonials (add, feature, remove) so that I can showcase student success | P2 |

### Trust-Building

| ID | Story | Priority |
|----|-------|----------|
| US-C043 | As a Creator, I need to receive and respond to visitor inquiries so that I can build trust with potential students | P0 |
| US-C044 | As a Creator, I need to see inquiry analytics (questions asked, response time, conversion) so that I can optimize my pre-enrollment communication | P2 |

### Creator Pricing & Subscription

| ID | Story | Priority |
|----|-------|----------|
| US-C045 | As a Creator, I need to pay a monthly subscription to maintain my creator account so that I can publish and manage courses | P2 |
| US-C046 | As a Creator, I need to pay a per-course fee when publishing a new course so that my course becomes available on the platform | P2 |
| US-C047 | As a Creator, I need to pay for promoted placement of my courses in feeds so that I can increase visibility | P2 |
| US-C048 | As a Creator, I need basic free promotion options so that I can promote without paying | P1 |

### Homework Management

| ID | Story | Priority |
|----|-------|----------|
| US-C049 | As a Creator, I need to create homework assignments for my courses so that students can practice and demonstrate understanding | P0 |
| US-C050 | As a Creator, I need to link homework assignments to specific modules so that assignments align with course structure | P1 |
| US-C051 | As a Creator, I need to set assignments as required or optional for course completion so that I control certification requirements | P1 |
| US-C052 | As a Creator, I need to set due dates for homework assignments so that students have clear deadlines | P1 |
| US-C053 | As a Creator, I need to grade assignments with points so that I can assess student work | P1 |
| US-C054 | As a Creator, I need to review student homework submissions so that I can evaluate their work | P0 |
| US-C055 | As a Creator, I need to provide feedback on homework submissions so that students learn from reviews | P0 |

### Course Resources

| ID | Story | Priority |
|----|-------|----------|
| US-C056 | As a Creator, I need to upload course-level resources (slides, docs, videos) so that students have additional materials | P0 |
| US-C057 | As a Creator, I need to manage course resources (view, delete, organize) so that I can maintain the resource library | P1 |

---

## Admin (US-A)

**Source:** [stories/stories-A-admin.md](stories/stories-A-admin.md)
**Description:** Platform operations and oversight
**Count:** 60 stories (P0: 35, P1: 19, P2: 6)

### Enrollment & Account Management

| ID | Story | Priority |
|----|-------|----------|
| US-A001 | As an Admin, I need to enroll teachers (Creators) so that they can offer courses on the platform | P0 |
| US-A002 | As an Admin, I need to cancel a teacher (with reason) so that I can remove problematic instructors | P1 |
| US-A003 | As an Admin, I need to cancel a student (with reason) so that I can enforce community standards | P1 |
| US-A004 | As an Admin, I need to vet teacher certificates so that only qualified instructors teach | P0 |

### Financial Operations

| ID | Story | Priority |
|----|-------|----------|
| US-A005 | As an Admin, I need to pay teachers from student enrollments so that the 15/15/70 revenue split is distributed | P0 |
| US-A006 | As an Admin, I need to refund students if they cancel so that we maintain customer satisfaction | P0 |
| US-A007 | As an Admin, I need to chargeback teachers for cancellations so that creators bear responsibility for their commitments | P1 |
| US-A008 | As an Admin, I need to allow third party organizations to pay for students so that employers can sponsor learning | P1 |
| US-A009 | As an Admin, I need to send success/failure assessments to funders so that sponsors can track ROI | P1 |

### Communication

| ID | Story | Priority |
|----|-------|----------|
| US-A010 | As an Admin, I need to message teachers so that I can communicate platform updates and issues | P0 |
| US-A011 | As an Admin, I need to message students so that I can provide support and announcements | P0 |
| US-A012 | As an Admin, I need to contact potential students by email re: courses and teachers referred by users so that referrals convert to enrollments | P1 |

### Session Facilitation

| ID | Story | Priority |
|----|-------|----------|
| US-A013 | As an Admin, I need to facilitate tutor sessions for any teacher-student combination so that peer learning can happen | P0 |
| US-A014 | As an Admin, I need video calls with recording potential so that sessions can be reviewed | P0 |
| US-A015 | As an Admin, I need AI-powered session summaries & transcripts so that learning is documented | P1 |
| US-A016 | As an Admin, I need monitored session time so that billing is accurate | P0 |
| US-A017 | As an Admin, I need screen sharing in sessions so that teachers can demonstrate concepts | P0 |
| US-A018 | As an Admin, I need to store tutor sessions with date/time/people parameters so that session history is maintained | P0 |

### Analytics & Monitoring

| ID | Story | Priority |
|----|-------|----------|
| US-A019 | As an Admin, I need to monitor user time on site and retention so that I can measure engagement | P1 |
| US-A020 | As an Admin, I need to monitor courses taken by user, teacher, creator stats so that I can track platform health | P1 |
| US-A021 | As an Admin, I need to monitor fees paid, distributed, income per creator so that I can ensure financial accuracy | P0 |
| US-A022 | As an Admin, I need to monitor session status (cancel, complete) so that I can track service delivery | P1 |
| US-A023 | As an Admin, I need to monitor student to teacher conversion so that I can validate the flywheel | P0 |
| US-A024 | As an Admin, I need to monitor percentage grade averages so that I can track learning quality | P1 |
| US-A025 | As an Admin, I need to determine where new users originate from so that I can optimize acquisition | P2 |

### Admin Payout Dashboard

| ID | Story | Priority |
|----|-------|----------|
| US-A026 | As an Admin (Brian), I need a payout dashboard showing all pending payouts by recipient so that I can see who needs to be paid | P0 |
| US-A027 | As an Admin (Brian), I need a "Process Payout" button per recipient so that I can trigger individual payouts | P0 |
| US-A028 | As an Admin (Brian), I need a batch payout option ("Pay All") so that I can process all pending payouts at once | P1 |
| US-A029 | As an Admin (Brian), I need payout history and audit trail so that I can track what was paid and when | P0 |
| US-A030 | As an Admin (Brian), I need monthly summary reports so that I can review platform financial activity | P1 |

### Creator Pricing

| ID | Story | Priority |
|----|-------|----------|
| US-A031 | As an Admin (Brian), I need to set monthly subscription fees for creators so that the platform generates recurring revenue | P2 |
| US-A032 | As an Admin (Brian), I need to set per-course publishing fees so that course creation generates revenue | P2 |
| US-A033 | As an Admin (Brian), I need to grant lifetime memberships to the first 10-20 creators so that early adopters are incentivized | P2 |

### Moderator Management

| ID | Story | Priority |
|----|-------|----------|
| US-A034 | As an Admin, I need to invite users to become moderators via email so that I can control who moderates | P0 |
| US-A035 | As an Admin, I need to see pending moderator invites so that I can track invitation status | P1 |
| US-A036 | As an Admin, I need to resend moderator invite emails so that I can remind invitees | P1 |
| US-A037 | As an Admin, I need to cancel pending moderator invites so that I can revoke access before acceptance | P1 |
| US-A038 | As an Admin, I need to see moderator invite history so that I can audit past invitations | P2 |
| US-A039 | As an Admin, I need to remove moderator status from users so that I can revoke access when needed | P1 |

### Admin Dashboard - ADMN

| ID | Story | Priority |
|----|-------|----------|
| US-A040 | As an Admin, I need to view a platform overview dashboard so that I can see the health of the platform at a glance | P0 |
| US-A041 | As an Admin, I need to see key metrics (users, courses, revenue, sessions) so that I can monitor platform performance | P0 |
| US-A042 | As an Admin, I need quick access to all admin tools from the dashboard so that I can navigate efficiently | P0 |

### Admin Users - AUSR

| ID | Story | Priority |
|----|-------|----------|
| US-A043 | As an Admin, I need to view all users with search and filter so that I can find specific accounts | P0 |
| US-A044 | As an Admin, I need to edit user details (name, email, profile) so that I can correct account information | P0 |
| US-A045 | As an Admin, I need to manage user roles (student, ST, creator, admin) so that I can control access levels | P0 |
| US-A046 | As an Admin, I need to suspend or ban users so that I can enforce platform policies | P0 |

### Admin Courses - ACRS

| ID | Story | Priority |
|----|-------|----------|
| US-A047 | As an Admin, I need to view all courses with search and filter so that I can find and manage course content | P0 |
| US-A048 | As an Admin, I need to suspend or unsuspend courses so that I can hide problematic content from the platform | P0 |
| US-A049 | As an Admin, I need to feature or unfeature courses so that I can curate promoted content on the homepage | P0 |

### Admin Enrollments - AENR

| ID | Story | Priority |
|----|-------|----------|
| US-A050 | As an Admin, I need to view all enrollments with search and filter so that I can track student registrations | P0 |
| US-A051 | As an Admin, I need to process refund requests so that I can handle cancellation requests | P0 |
| US-A052 | As an Admin, I need to override enrollment status so that I can manually adjust enrollment states when needed | P1 |

### Admin Sessions - ASES

| ID | Story | Priority |
|----|-------|----------|
| US-A053 | As an Admin, I need to view all sessions with search and filter so that I can monitor tutoring activity | P0 |
| US-A054 | As an Admin, I need to access session recordings so that I can review session quality and handle disputes | P0 |
| US-A055 | As an Admin, I need to handle session disputes so that I can resolve conflicts between students and teachers | P1 |

### Admin Certificates - ACRT

| ID | Story | Priority |
|----|-------|----------|
| US-A056 | As an Admin, I need to view all certificates with search and filter so that I can audit credential issuance | P0 |
| US-A057 | As an Admin, I need to issue certificates manually so that I can correct certification errors | P1 |
| US-A058 | As an Admin, I need to revoke certificates so that I can invalidate fraudulent or erroneous credentials | P0 |

### Admin Topics - ATOP

| ID | Story | Priority |
|----|-------|----------|
| US-A059 | As an Admin, I need to manage course topics (create, edit, delete) so that I can organize course taxonomy | P1 |
| US-A060 | As an Admin, I need to reorder topics so that I can control how topics appear to users | P1 |

---

## Employer / Funder (US-E)

**Source:** [stories/stories-E-employer.md](stories/stories-E-employer.md)
**Description:** Third party paying for student enrollment
**Count:** 6 stories (P0: 0, P1: 5, P2: 1)

### Employer Stories

| ID | Story | Priority |
|----|-------|----------|
| US-E001 | As an Employer, I need to pay for a student to take a course so that I can sponsor employee learning | P1 |
| US-E002 | As an Employer, I need to receive a copy of student progress and completion status so that I can track sponsored learners | P1 |
| US-E003 | As an Employer, I need to receive a copy of certification so that I have proof of completion | P1 |
| US-E004 | As an Employer, I need to enter a profile (possibly all private) so that I can manage my account | P1 |
| US-E005 | As an Employer, I need to message AP so that I can get support | P1 |
| US-E006 | As an Employer, I need to message my funded students for their funded courses so that I can check on progress | P2 |

---

## Moderator (US-M)

**Source:** [stories/stories-M-moderator.md](stories/stories-M-moderator.md)
**Description:** Course community support staff (appointed by Creator)
**Count:** 9 stories (P0: 2, P1: 6, P2: 1)

### Community Support

| ID | Story | Priority |
|----|-------|----------|
| US-M001 | As a Community Moderator, I need to answer questions in community chats so that students get timely support | P1 |
| US-M002 | As a Community Moderator, I need to troubleshoot common issues so that students aren't blocked | P1 |
| US-M003 | As a Community Moderator, I need to moderate course-related chats so that community standards are maintained | P1 |
| US-M004 | As a Community Moderator, I need to add users to closed/private chats so that access is managed | P2 |
| US-M005 | As a Community Moderator, I need a support dashboard so that I can see pending questions and issues | P1 |

### Feed Moderation

| ID | Story | Priority |
|----|-------|----------|
| US-M006 | As a Community Moderator, I need to delete inappropriate posts in the community feed so that community standards are maintained | P0 |
| US-M007 | As a Community Moderator, I need to ban users from posting (temp or permanent) so that repeat offenders are handled | P1 |
| US-M008 | As a Community Moderator, I need to pin important posts so that key announcements are visible | P1 |
| US-M009 | As a Community Moderator, I need to see a queue of flagged content so that I can review and act on reports | P0 |

---

## Video / Session (US-V)

**Source:** [stories/stories-V-video.md](stories/stories-V-video.md)
**Description:** Automated video session functionality
**Count:** 11 stories (P0: 4, P1: 6, P2: 1)

### Core Video Session Stories

| ID | Story | Priority |
|----|-------|----------|
| US-V001 | As a System, I need to handle the video chat experience so that tutoring can happen | P0 |
| US-V002 | As a System, I need to possibly limit the number of participants so that sessions stay focused | P1 |
| US-V003 | As a System, I need to allow messages and files to pass between participants so that resources can be shared | P0 |
| US-V004 | As a System, I need to monitor time so that sessions are tracked for billing | P0 |
| US-V005 | As a System, I need to record conversations so that sessions can be reviewed | P1 |
| US-V006 | As a System, I need to enable assessment by each participant at end of session so that quality is tracked | P0 |
| US-V007 | As a System, I need AI-powered session summaries and transcripts so that learning is captured | P1 |

### AI Transcription

| ID | Story | Priority |
|----|-------|----------|
| US-V008 | As a System, I need to transcribe recorded sessions to text so that content is searchable | P1 |
| US-V009 | As a System, I need to generate session summaries from transcripts so that key points are captured | P1 |
| US-V010 | As a Student, I need to access transcripts of my sessions so that I can review what was discussed | P1 |
| US-V011 | As a Student, I need to search within session transcripts so that I can find specific topics | P2 |

---

## Platform (US-P)

**Source:** [stories/stories-P-platform.md](stories/stories-P-platform.md)
**Description:** Platform infrastructure and automation
**Count:** 100 stories (P0: 57, P1: 19, P2: 19, P3: 5)

### Navigation Stories

| ID | Story | Priority |
|----|-------|----------|
| US-P001 | As a User, I need a Browse Menu for course and creator search so that I can discover content | P0 |
| US-P002 | As a User, I need a "My Community" feed (X.com-style) so that I see followed content | P1 |
| US-P003 | As a User, I need a Dashboard view so that I see my activity at a glance | P0 |
| US-P004 | As a User, I need a Messages section so that I can access conversations | P0 |
| US-P005 | As a User, I need a Profile section so that I can manage my account | P0 |
| US-P006 | As a User, I need session booking/purchasing integrated with teacher discovery so that I can easily book | P0 |

### Authentication & Identity

| ID | Story | Priority |
|----|-------|----------|
| US-P007 | As a User, I need to create an account with email/password so that I can access the platform | P0 |
| US-P008 | As a User, I need to log in securely so that I can access my account | P0 |
| US-P009 | As a User, I need to reset my password via email so that I can recover my account | P0 |
| US-P010 | As a User, I need to log out so that I can secure my session | P0 |
| US-P011 | As a User, I need social login options (Google, etc.) so that I can sign up quickly | P2 |
| US-P012 | As a System, I need to manage user sessions securely so that accounts are protected | P0 |
| US-P013 | As a System, I need to verify email addresses so that accounts are legitimate | P0 |

### Email & Notifications

| ID | Story | Priority |
|----|-------|----------|
| US-P014 | As a System, I need to send transactional emails (welcome, receipts, confirmations) so that users are informed | P0 |
| US-P015 | As a System, I need to send session reminder emails so that users don't miss appointments | P0 |
| US-P016 | As a System, I need to send payment confirmation emails so that financial transactions are documented | P0 |
| US-P017 | As a User, I need in-app notifications for messages, sessions, and updates so that I stay informed | P0 |
| US-P018 | As a User, I need to manage my notification preferences so that I control what alerts I receive | P1 |
| US-P019 | As a System, I need to send certificate notification emails so that achievements are celebrated | P1 |

### Calendar & Scheduling Infrastructure

| ID | Story | Priority |
|----|-------|----------|
| US-P020 | As a System, I need to display available time slots from teacher calendars so that students can book | P0 |
| US-P021 | As a System, I need to prevent double-booking of sessions so that schedules don't conflict | P0 |
| US-P022 | As a System, I need to handle timezone conversions so that global users see correct times | P0 |
| US-P023 | As a System, I need to send calendar invites (ICS) for booked sessions so that users can add to their calendars | P1 |
| US-P024 | As a Student, I need to select from available time slots when booking so that I can choose convenient times | P0 |
| US-P025 | As a Teacher, I need to sync my availability with external calendars so that my schedule stays current | P2 |

### Payment Infrastructure

| ID | Story | Priority |
|----|-------|----------|
| US-P026 | As a System, I need to process credit card payments securely so that students can pay for courses | P0 |
| US-P027 | As a System, I need to split payments automatically (15% AP, 15% Creator, 70% Teacher) so that revenue is distributed correctly | P0 |
| US-P028 | As a System, I need to hold funds until session completion so that refunds can be processed if needed | P0 |
| US-P029 | As a System, I need to process payouts to Teachers/Creators so that they receive their earnings | P0 |
| US-P030 | As a System, I need to handle refund requests so that cancellations are processed financially | P0 |
| US-P031 | As a Teacher, I need to connect my bank account/payment method so that I can receive payouts | P0 |
| US-P032 | As a System, I need to generate tax documents (1099s) for teachers/creators so that tax obligations are met | P1 |
| US-P033 | As an Employer, I need to pay via invoice/PO so that corporate purchasing is supported | P2 |

### Database Infrastructure

| ID | Story | Priority |
|----|-------|----------|
| US-P034 | As a System, I need a relational database to store user accounts, courses, sessions, and transactions so that data is persisted reliably | P0 |
| US-P035 | As a System, I need database backups and point-in-time recovery so that data loss is prevented | P0 |
| US-P036 | As a System, I need database connection pooling so that the application scales under load | P1 |
| US-P037 | As a System, I need to encrypt sensitive data at rest so that user information is protected | P0 |

### File & Object Storage

| ID | Story | Priority |
|----|-------|----------|
| US-P038 | As a System, I need object storage for large files (videos, PDFs, recordings) so that media is stored cost-effectively | P0 |
| US-P039 | As a System, I need secure file upload endpoints so that users can upload profile media and course materials | P0 |
| US-P040 | As a System, I need file type validation and virus scanning so that malicious uploads are blocked | P0 |
| US-P041 | As a System, I need signed URLs for private file access so that only authorized users can download files | P0 |
| US-P042 | As a System, I need to store BBB session recordings so that recorded sessions are accessible after the session ends | P0 |
| US-P043 | As a System, I need file size limits and quota management so that storage costs are controlled | P1 |
| US-P044 | As a Creator, I need to upload course materials (PDFs, videos) so that students can access learning resources | P0 |
| US-P045 | As a User, I need to upload profile pictures and videos so that my profile is personalized | P0 |

### Image Optimization

| ID | Story | Priority |
|----|-------|----------|
| US-P046 | As a System, I need automatic image resizing and thumbnail generation so that images load quickly | P0 |
| US-P047 | As a System, I need image format conversion (WebP, AVIF) so that modern browsers get optimized formats | P1 |
| US-P048 | As a System, I need responsive image variants (srcset) so that appropriate sizes are served per device | P1 |
| US-P049 | As a System, I need image CDN delivery so that images load fast globally | P0 |
| US-P050 | As a System, I need lazy loading for images so that page load performance is optimized | P1 |

### Gamification System

| ID | Story | Priority |
|----|-------|----------|
| US-P051 | As a System, I need to track goodwill points for user actions so that engagement is gamified | P2 |
| US-P052 | As a System, I need to calculate power user tiers based on points so that progression is visible | P2 |
| US-P053 | As a System, I need to display leaderboards/rankings so that community standing is transparent | P3 |

### Teacher Matchmaking

| ID | Story | Priority |
|----|-------|----------|
| US-P054 | As a System, I need to provide Teacher Student matchmaking with random default so that students can find teachers | P1 |
| US-P055 | As a System, I need to show Teacher Student profiles for selection so that students can choose deliberately | P1 |

### Credentialing & Content Requests

| ID | Story | Priority |
|----|-------|----------|
| US-P056 | As a System, I need to issue Certificates of Mastery (separate from completion) so that deeper understanding is credentialed | P1 |
| US-P057 | As a System, I need to process content requests from students so that gaps in offerings are tracked | P2 |
| US-P058 | As a System, I need to track Teacher Student points for activity so that gamification motivates teachers | P2 |
| US-P059 | As a System, I need to handle bidirectional opt-out for Teacher relationships so that both parties can exit gracefully | P1 |

### MVP Gap Stories

| ID | Story | Priority |
|----|-------|----------|
| US-P060 | As a Student, I need a home/landing page showing enrolled courses, next session, and progress at a glance so that I can quickly see my status | P0 |
| US-P061 | As a Teacher, I need to recommend a student for certification so that the Creator can approve completion | P0 |
| US-P062 | As a Creator, I need to see certification requests in my dashboard so that I can approve student completions | P0 |
| US-P063 | As a Creator, I need to see Teacher applications in my dashboard so that I can approve new teachers for my course | P0 |
| US-P064 | As a Creator, I need to approve payout requests in my dashboard so that Teachers receive their earnings | P0 |
| US-P065 | As a System, I need to generate and deliver BBB links when sessions are booked so that participants can join | P0 |

### Profile System Infrastructure

| ID | Story | Priority |
|----|-------|----------|
| US-P066 | As a System, I need a Teacher directory showing all users with Teacher toggle ON so that discovery is enabled | P0 |
| US-P067 | As a System, I need to track follow relationships (social graph) so that network effects can be measured | P0 |
| US-P068 | As a System, I need to display follower/following counts on profiles so that social proof is visible | P0 |
| US-P069 | As a System, I need to display reputation (average star rating, rating count) on profiles (read-only in MVP) so that quality is visible | P1 |
| US-P070 | As a System, I need a profile strength/completion indicator so that users are encouraged to complete profiles | P2 |

### Course Content Infrastructure

| ID | Story | Priority |
|----|-------|----------|
| US-P071 | As a System, I need to display module-based course pages with video and document links so that content is accessible | P0 |
| US-P072 | As a System, I need to track student progress checkboxes per module so that completion can be monitored | P0 |
| US-P073 | As a System, I need to show Creator a dashboard of student progress across their courses so that they can monitor completion | P0 |

### Escrow & Release

| ID | Story | Priority |
|----|-------|----------|
| US-P074 | As a System, I need to hold funds in escrow until milestone completion so that payouts are tied to course completion | P0 |
| US-P075 | As a System, I need clear release criteria for escrowed funds so that payout triggers are defined | P0 |
| US-P076 | As an Admin (Brian), I need to approve fund releases from escrow so that payouts require manual verification | P0 |

### Goodwill System Infrastructure

| ID | Story | Priority |
|----|-------|----------|
| US-P077 | As a System, I need to track goodwill point transactions so that points are accurately recorded | P2 |
| US-P078 | As a System, I need to enforce anti-gaming rules (daily caps, cooldowns, 5-min minimums) so that the system isn't abused | P2 |
| US-P079 | As a System, I need to auto-award points for certain actions (availability, first mentoring, referrals) so that consistent behavior is rewarded | P2 |
| US-P080 | As a System, I need to display available helpers count per course so that students know help is accessible | P2 |
| US-P081 | As a System, I need to track summon help requests (create, respond, complete) so that help sessions are managed | P2 |
| US-P082 | As a System, I need to unlock rewards at point thresholds (500, 1000, 2500, 5000) so that goodwill points have tangible value | P3 |

### Feed Access Infrastructure

| ID | Story | Priority |
|----|-------|----------|
| US-P083 | As a System, I need to track enrollment-based feed access levels so that users only see feeds they're entitled to | P0 |
| US-P084 | As a System, I need to grant instructor feed access when a user purchases any course from that instructor so that the access upgrade happens automatically | P1 |
| US-P085 | As a System, I need to process feed promotion requests (spend points to boost post) so that users can increase their visibility | P3 |

### Trust-Building Infrastructure

| ID | Story | Priority |
|----|-------|----------|
| US-P086 | As a System, I need to deliver visitor inquiries to Creators via email so that Creators can respond to potential students | P0 |
| US-P087 | As a System, I need to track inquiry → enrollment conversion so that trust-building effectiveness can be measured | P1 |
| US-P088 | As a System, I need to create BBB rooms for free intro sessions (limited to 15 min) so that visitors can meet Teachers before enrolling | P1 |
| US-P089 | As a System, I need to track free intro session → enrollment conversion so that flywheel funnel can be measured | P1 |
| US-P090 | As a System, I need to send reminders for upcoming free intro sessions so that both parties attend | P1 |

### Feed Companion Infrastructure

| ID | Story | Priority |
|----|-------|----------|
| US-P091 | As a System, I need to maintain a feed companion UI for pinned posts/authors so that users can track specific content | P2 |
| US-P092 | As a System, I need to display original post + latest thread comment for pinned items so that noise is reduced | P2 |
| US-P093 | As a System, I need to show a "recent posters" panel with 24hr counts so that activity is visible | P2 |

### Onboarding & Personalization

| ID | Story | Priority |
|----|-------|----------|
| US-P094 | As a System, I need to collect user interests during onboarding so that feeds can be personalized | P1 |
| US-P095 | As a System, I need to use interests (not private discussions) for AI suggestions so that privacy is respected | P1 |

### Course Promotion

| ID | Story | Priority |
|----|-------|----------|
| US-P096 | As a System, I need to process paid course promotion requests so that promoted courses appear in more feeds | P2 |

### Sub-Communities & Additional Features

| ID | Story | Priority |
|----|-------|----------|
| US-P097 | As a System, I need to support user-created sub-communities with invite functionality so that users can organize privately | P3 |
| US-P098 | As a System, I need to process payments for additional coaching sessions so that extra tutoring generates revenue | P2 |
| US-P099 | As a System, I need a Changelog page so that users can see what features have been added or changed | P2 |
| US-P100 | As a System, I need feature flags to hide/show features so that incomplete features can be deployed but hidden | P1 |

### Unified Dashboard

| ID | Story | Priority |
|----|-------|----------|
| US-P101 | As a System, I need a unified dashboard that shows all user roles so that users don't need separate logins per role | P0 |

### Moderator Invites

| ID | Story | Priority |
|----|-------|----------|
| US-P102 | As a System, I need to send moderator invite emails with unique tokens so that invitees can accept securely | P0 |
| US-P103 | As a System, I need to validate invite tokens and check expiration so that only valid invites are accepted | P0 |
| US-P104 | As an invite recipient, I need to accept a moderator invitation so that I become a moderator | P0 |
| US-P105 | As an invite recipient, I need to decline a moderator invitation so that I can refuse the role | P1 |
| US-P106 | As a new user, I need to create an account while accepting a moderator invite so that I can join as a moderator | P0 |

### Privacy Settings

| ID | Story | Priority |
|----|-------|----------|
| US-P107 | As a System, I need to set new user profiles to private by default so that privacy is protected from signup | P0 |
| US-P108 | As a System, I need to exclude private profiles from public directories so that user privacy is respected | P0 |

---

## Story ID Format Reference

**Format:** `US-[Role][NNN]`

| Code | Role | Example |
|------|------|---------|
| G | Visitor/Guest | US-G001 |
| S | Student | US-S001 |
| T | Teacher | US-T001 |
| C | Creator-Instructor | US-C001 |
| A | Admin | US-A001 |
| E | Employer/Funder | US-E001 |
| M | Moderator | US-M001 |
| V | Video/Session | US-V001 |
| P | Platform | US-P001 |

---

## Source Documents

All stories trace back to source documents (CD-001 through CD-034). See [USER-STORIES.md](USER-STORIES.md) for the full source document index.
