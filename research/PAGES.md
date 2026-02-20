# PeerLoop - Page Inventory

**Version:** v1
**Last Updated:** 2025-12-23
**Status:** GATHER Phase - Accumulating from source documents
**Primary Source:** CD-021 (Database Schema Sample), CD-002 (Feature Summary)

> This document inventories all pages/screens in the application. During RUN phase, scenarios may add or remove pages based on feature scope.

---

## Page Overview

```
Public (No Auth)              Authenticated                    Role-Specific
─────────────────────────────────────────────────────────────────────────────
Homepage                      Dashboard (Student)              Creator Studio
Course Browse                 Dashboard (ST)                   Admin Dashboard
Course Detail                 Dashboard (Creator)              Moderator Queue
Creator Listing               My Community (Feed)
Creator Profile (public)      Messages
ST Directory                  Profile (own)
Login / Signup                Settings
Password Reset                Notifications
                              Session Room (BBB)
                              Scheduling/Booking
```

---

## Public Pages (No Authentication Required)

### Homepage
| Attribute | Value |
|-----------|-------|
| **URL** | `/` |
| **Purpose** | Landing page explaining PeerLoop value proposition |
| **Data Sources** | Static content, featured courses (courses), testimonials |
| **User Stories** | US-G001, US-G002, US-G004 |
| **Access** | Public |
| **Key Elements** | Hero section, How It Works, Value proposition (Learn/Teach/Earn), Featured courses, CTA to signup |

---

### Course Browse / Listing
| Attribute | Value |
|-----------|-------|
| **URL** | `/courses` |
| **Purpose** | Browse and filter available courses |
| **Data Sources** | courses, categories, course_tags |
| **User Stories** | US-G005, US-S001, US-S003, US-S057, US-S058 |
| **Access** | Public |
| **Key Elements** | Course cards (thumbnail, title, level, price, rating), Filters (level, category, price range), Search, Sort options |

**Filters from CD-021:**
- Level: Beginner, Intermediate, Advanced
- Category: 15 categories identified
- Price range
- Duration

---

### Course Detail
| Attribute | Value |
|-----------|-------|
| **URL** | `/courses/:slug` or `/courses/:id` |
| **Purpose** | Full course information for enrollment decision |
| **Data Sources** | courses, course_curriculum, course_objectives, course_includes, course_tags, student_teachers, users (creator) |
| **User Stories** | US-G006, US-G007, US-S005, US-S059, US-S060, US-S061 |
| **Access** | Public (enrolled content may be gated) |
| **Key Elements** | |

**Section: Hero**
- Title, description, thumbnail
- Price, duration, level badge
- CTA buttons: Enroll, Follow Course, Explore Teaching

**Section: Creator Card**
- Creator name, avatar, title
- Stats: students taught, courses created, rating
- Link to creator profile

**Section: What You'll Learn** (from CD-021)
- Learning objectives list (course_objectives)

**Section: What's Included** (from CD-021)
- Included items list (course_includes)

**Section: Curriculum**
- Module list with titles, durations, descriptions
- Video/reading counts if available

**Section: Student-Teachers** (from CD-021)
- List of certified STs for this course
- Name, students taught, certified date
- CTA to book with specific ST

**Section: Reviews/Ratings**
- Average rating, review count
- Individual reviews (future)

**Section: Related Courses**
- Similar courses by category/tags

---

### Creator Listing
| Attribute | Value |
|-----------|-------|
| **URL** | `/creators` |
| **Purpose** | Browse and search course creators |
| **Data Sources** | users (creators), user_expertise, user_stats |
| **User Stories** | US-S004, US-G008 |
| **Access** | Public |
| **Key Elements** | Creator cards (avatar, name, title, expertise tags, stats), Search by name/expertise, Filter by expertise area |

---

### Creator Profile (Public)
| Attribute | Value |
|-----------|-------|
| **URL** | `/creators/:handle` or `/@:handle` |
| **Purpose** | Full creator profile and course listing |
| **Data Sources** | users, user_qualifications, user_expertise, user_stats, courses |
| **User Stories** | US-G008, US-G010, US-C008, US-C009, US-C036 |
| **Access** | Public |
| **Key Elements** | |

**Section: Profile Header**
- Avatar, name, title
- Bio
- Website link
- Follow button, follower count

**Section: Qualifications** (from CD-021)
- List of credentials (user_qualifications)

**Section: Expertise** (from CD-021)
- Expertise tags (user_expertise)

**Section: Stats** (from CD-021)
- Students taught, courses created, average rating, total reviews

**Section: Courses Created**
- List of courses by this creator
- Course cards with key info

---

### Student-Teacher Directory
| Attribute | Value |
|-----------|-------|
| **URL** | `/student-teachers` |
| **Purpose** | Browse available Student-Teachers |
| **Data Sources** | users (STs), student_teachers, user_expertise |
| **User Stories** | US-S050, US-S051, US-P066 |
| **Access** | Public (or authenticated only) |
| **Key Elements** | ST cards (avatar, name, courses certified, students taught), Search by name/interests, Filter by course |

---

### Student-Teacher Profile
| Attribute | Value |
|-----------|-------|
| **URL** | `/@:handle` (same as user profile) |
| **Purpose** | View ST credentials and availability |
| **Data Sources** | users, student_teachers, certificates, availability |
| **User Stories** | US-G009, US-T003, US-T004, US-T020, US-T021, US-T022 |
| **Access** | Public (if privacy_public = true) |
| **Key Elements** | Profile info, Teaching badge, Courses certified to teach, Students taught count, Availability calendar, Book session CTA |

---

### Login
| Attribute | Value |
|-----------|-------|
| **URL** | `/login` |
| **Purpose** | User authentication |
| **Data Sources** | users |
| **User Stories** | US-G012, US-P008 |
| **Access** | Public (redirects if logged in) |
| **Key Elements** | Email input, Password input, Submit button, Forgot password link, Sign up link, Social login (future) |

---

### Sign Up
| Attribute | Value |
|-----------|-------|
| **URL** | `/signup` |
| **Purpose** | New user registration |
| **Data Sources** | users |
| **User Stories** | US-G011, US-P007 |
| **Access** | Public (redirects if logged in) |
| **Key Elements** | Name input, Email input, Password input, Role selection (Student/Creator), Terms acceptance, Submit button |

---

### Password Reset
| Attribute | Value |
|-----------|-------|
| **URL** | `/reset-password` |
| **Purpose** | Password recovery |
| **Data Sources** | users |
| **User Stories** | US-G013, US-P009 |
| **Access** | Public |
| **Key Elements** | Email input, Submit button, Confirmation message |

---

## Authenticated Pages

### Student Dashboard
| Attribute | Value |
|-----------|-------|
| **URL** | `/dashboard` |
| **Purpose** | Student home - enrolled courses, next session, progress |
| **Data Sources** | enrollments, courses, sessions, module_progress, certificates |
| **User Stories** | US-S009, US-P003, US-P060 |
| **Access** | Authenticated (Student role) |
| **Key Elements** | |

**Section: Welcome/Quick Stats**
- Greeting, courses in progress, next session countdown

**Section: Enrolled Courses**
- Course cards with progress bar
- Next module to complete
- CTA: Continue learning, Schedule session

**Section: Upcoming Sessions**
- Next 3-5 scheduled sessions
- Join button, reschedule option

**Section: Recent Activity**
- Recent completions, certificates earned

**Section: Quick Actions**
- Browse courses, View certificates, Update profile

---

### Student-Teacher Dashboard
| Attribute | Value |
|-----------|-------|
| **URL** | `/dashboard` (role-aware) |
| **Purpose** | ST home - teaching sessions, earnings, students |
| **Data Sources** | sessions, student_teachers, payment_splits, enrollments |
| **User Stories** | US-S009, US-T013, US-T023 |
| **Access** | Authenticated (Student-Teacher role) |
| **Key Elements** | |

**Section: Earnings Overview**
- Pending balance, total earned
- Recent payouts

**Section: Upcoming Teaching Sessions**
- Scheduled sessions with students
- Join button

**Section: My Students**
- Students currently enrolled with this ST
- Progress indicators

**Section: Certification Recommendations**
- Students ready for completion
- Recommend for certification button (US-P061)

**Section: Availability**
- Quick view/edit of availability slots

---

### Creator Dashboard
| Attribute | Value |
|-----------|-------|
| **URL** | `/dashboard` (role-aware) |
| **Purpose** | Creator home - course management, approvals, earnings |
| **Data Sources** | courses, enrollments, student_teachers, certificates, payment_splits |
| **User Stories** | US-P003, US-C033, US-P062, US-P063, US-P064, US-C035 |
| **Access** | Authenticated (Creator role) |
| **Key Elements** | |

**Section: Earnings Overview**
- Pending balance, total earned
- Royalty breakdown

**Section: Pending Approvals**
- Certification requests (US-P062)
- ST applications (US-P063)
- Payout approvals (US-P064)

**Section: Course Performance**
- Enrollments per course
- Completion rates
- Student progress overview

**Section: Student-Teachers**
- Active STs per course
- Performance metrics

**Section: Quick Actions**
- Creator Studio, View courses, Update availability

---

### My Community (Feed)
| Attribute | Value |
|-----------|-------|
| **URL** | `/community` or `/feed` |
| **Purpose** | X.com-style algorithmic feed of followed content |
| **Data Sources** | posts, follows, course_follows (via getstream.io) |
| **User Stories** | US-S025, US-P002, US-S036-S041 |
| **Access** | Authenticated |
| **Key Elements** | |

**Section: Feed**
- Posts from followed users, courses, creators
- Algorithmic sorting by relevance/recency

**Section: Post Composer**
- Create new post
- Post type selection (Q&A, update, tip, availability)

**Section: Interactions**
- Like, bookmark, reply, repost buttons
- Flag inappropriate content

**Section: Sidebar**
- Suggested follows
- Trending topics
- Upcoming sessions

---

### Messages
| Attribute | Value |
|-----------|-------|
| **URL** | `/messages` |
| **Purpose** | Private messaging inbox |
| **Data Sources** | conversations, conversation_participants, messages |
| **User Stories** | US-P004, US-S016, US-S018, US-S019 |
| **Access** | Authenticated |
| **Key Elements** | Conversation list, Message thread view, Compose new message, Unread indicators |

---

### Profile (Own)
| Attribute | Value |
|-----------|-------|
| **URL** | `/profile` or `/@:handle` |
| **Purpose** | View and edit own profile |
| **Data Sources** | users, user_qualifications, user_expertise, user_interests, user_stats, user_goodwill |
| **User Stories** | US-P005, US-S008, US-S047, US-S048, US-S049, US-S067, US-S068 |
| **Access** | Authenticated |
| **Key Elements** | |

**Section: Profile Display**
- All public profile fields
- Edit button

**Section: Privacy Toggle**
- Public/private profile setting (US-S047)

**Section: Followers/Following**
- Follower count, following count
- View lists

**Section: ST Toggle** (if certified)
- "Available as Student-Teacher" toggle (US-T020)

**Section: Goodwill Points (Block 2+)** *(from CD-023)*

*Public View:*
- Total earned points (e.g., "847 earned")
- Breakdown: students helped, questions answered, referrals

*Private View (own profile only):*
- Total Earned
- Spent (given to helpers)
- Available to Award (balance)
- Transaction history link

**Section: Available to Help Toggle (Block 2+)** *(from CD-023)*
- "Available to Help" toggle for S-Ts (US-T024)
- Shows in S-T directory when on

---

### Settings
| Attribute | Value |
|-----------|-------|
| **URL** | `/settings` |
| **Purpose** | Account and notification preferences |
| **Data Sources** | users, notification preferences |
| **User Stories** | US-P018, US-P010 |
| **Access** | Authenticated |
| **Key Elements** | Email/password change, Notification preferences, Payment settings, Logout |

---

### Notifications
| Attribute | Value |
|-----------|-------|
| **URL** | `/notifications` |
| **Purpose** | View all notifications |
| **Data Sources** | notifications |
| **User Stories** | US-P017 |
| **Access** | Authenticated |
| **Key Elements** | Notification list, Mark as read, Filter by type |

---

### Session Booking
| Attribute | Value |
|-----------|-------|
| **URL** | `/courses/:id/book` or `/book/:st_id` |
| **Purpose** | Book a tutoring session |
| **Data Sources** | availability, sessions, student_teachers |
| **User Stories** | US-S044, US-S045, US-S046, US-P006, US-P020, US-P024 |
| **Access** | Authenticated (enrolled students) |
| **Key Elements** | |

**Section: ST Selection** (if not pre-selected)
- Available STs for course
- ST cards with availability preview

**Section: Calendar View**
- Date picker
- Available time slots for selected date

**Section: Confirmation**
- Session details summary
- Confirm booking button

---

### Session Room
| Attribute | Value |
|-----------|-------|
| **URL** | `/session/:id` |
| **Purpose** | Video conferencing room (BBB embed or redirect) |
| **Data Sources** | sessions |
| **User Stories** | US-S042, US-S043, US-V001, US-T007 |
| **Access** | Authenticated (session participants only) |
| **Key Elements** | BBB/Jitsi embed or external link, Session info header, End session button |

---

### Course Content (Enrolled)
| Attribute | Value |
|-----------|-------|
| **URL** | `/learn/:course_id` |
| **Purpose** | Course content for enrolled students |
| **Data Sources** | courses, course_curriculum, module_progress, enrollments, user_availability |
| **User Stories** | US-S052, US-S053, US-S054, US-S055, US-S056, US-S062, US-S063 |
| **Access** | Authenticated (enrolled students only) |
| **Key Elements** | |

**Section: Course Navigation**
- Module list with completion checkboxes
- Current progress indicator

**Section: Module Content**
- Video player (external embed)
- Document links
- Mark complete checkbox

**Section: Summon Help (Block 2+)** *(from CD-023)*
- "Summon Help" button
- Available helpers count (e.g., "3 online")
- Opens summon modal when clicked

**Section: Actions**
- Schedule next session
- Back to dashboard

---

### Course Chat Room (Block 2+)
| Attribute | Value |
|-----------|-------|
| **URL** | `/courses/:id/chat` |
| **Purpose** | Course-specific community chat with help queue |
| **Data Sources** | posts (course-filtered), users, user_goodwill |
| **User Stories** | US-S065, US-S066, US-T028 |
| **Access** | Authenticated (enrolled students and certified S-Ts) |
| **Source** | CD-023 |
| **Key Elements** | |

**Section: Chat Messages**
- Real-time chat messages
- "Mark as Question" button on own messages
- "This Helped" button on answers (awards 5 points)

**Section: Help Queue**
- Questions marked for help
- Who's available to answer

**Section: Participants**
- Online users in this course chat
- S-T badges for certified helpers

---

### Summon Help Modal (Block 2+)
| Attribute | Value |
|-----------|-------|
| **URL** | Modal overlay on Course Content |
| **Purpose** | Request and receive help from certified S-Ts |
| **Data Sources** | help_summons, user_availability, users |
| **User Stories** | US-S062, US-S064, US-T025, US-T026 |
| **Access** | Authenticated (enrolled students) |
| **Source** | CD-023 |
| **Key Elements** | |

**State: Waiting**
- "Looking for a helper..." spinner
- Cancel button

**State: Connected**
- Helper info (name, avatar)
- Chat/video interface
- Timer for session duration

**State: Complete**
- Session summary
- Points slider (10-25) to award helper
- Submit and close

---

### Instructor Feed
| Attribute | Value |
|-----------|-------|
| **URL** | `/instructors/:handle/feed` or `/@:handle/feed` |
| **Purpose** | Feed for current and former students of an instructor (across all courses) |
| **Data Sources** | posts (instructor-filtered), instructor_followers, users |
| **User Stories** | US-S070, US-C037, US-C038 |
| **Access** | Authenticated (users who have purchased any course from this instructor) |
| **Source** | CD-024 |
| **Key Elements** | |

**Section: Feed**
- Posts from the instructor
- Posts from any of the instructor's courses
- Algorithmic sorting

**Section: Post Composer** (if authorized)
- Create post to instructor feed
- Promote to main feed option (using points)

**Section: Sidebar**
- Instructor profile summary
- List of instructor's courses
- Current students count

**Access Control:**
- Must have purchased at least one course from this instructor
- Access granted automatically on first enrollment
- Persists even after course completion

---

## Role-Specific Pages

### Creator Studio
| Attribute | Value |
|-----------|-------|
| **URL** | `/studio` |
| **Purpose** | Course creation and management |
| **Data Sources** | courses, course_curriculum, course_objectives, course_includes |
| **User Stories** | US-C001, US-C002, US-C003, US-C010, US-C034 |
| **Access** | Authenticated (Creator role) |
| **Key Elements** | Course list, Create new course, Edit course details, Manage curriculum, Preview course |

---

### Admin Dashboard
| Attribute | Value |
|-----------|-------|
| **URL** | `/admin` |
| **Purpose** | Platform administration and oversight |
| **Data Sources** | users, transactions, payment_splits, payouts, sessions |
| **User Stories** | US-A001-A030 |
| **Access** | Authenticated (Admin role) |
| **Key Elements** | |

**Section: Payout Management** (from CD-020)
- Pending payouts by recipient
- Process payout button
- Batch payout option
- Payout history

**Section: User Management**
- User list, search, filter
- Enroll/cancel users
- Vet certificates

**Section: Analytics**
- Platform metrics
- Conversion rates
- Revenue tracking

---

### Moderator Queue
| Attribute | Value |
|-----------|-------|
| **URL** | `/moderate` |
| **Purpose** | Content moderation dashboard |
| **Data Sources** | content_flags, posts |
| **User Stories** | US-M001-M009 |
| **Access** | Authenticated (Moderator role) |
| **Key Elements** | Flagged content queue, Review/dismiss/action buttons, Ban user option, Pin post option |

---

## Page Count Summary

| Category | Count |
|----------|-------|
| Public Pages | 10 |
| Authenticated Pages | 14 |
| Role-Specific Pages | 3 |
| **Total** | **27** |

---

## Document Lineage

| Source Document | Pages Derived |
|-----------------|---------------|
| CD-021 | Course Detail (objectives, includes, ST list), Creator Profile (qualifications, expertise, stats), Course Browse (level/category filters) |
| CD-002 | Navigation structure, Dashboard, My Community, Messages, Profile |
| CD-013 | My Community (feed functionality) |
| CD-014, CD-015 | Session Room, Session Booking |
| CD-018 | Profile (social features, ST signaling) |
| CD-019 | Course Content (enrolled view) |
| CD-020 | Admin Dashboard (payout section) |
| CD-012 | Dashboard approval workflows |
| CD-023 | Course Chat Room, Summon Help Modal, Profile (goodwill sections), Course Content (summon button) |
| CD-024 | Instructor Feed (access-controlled feed for instructor's students) |

---

## Notes for Implementation

1. **URL Patterns:** Consider SEO-friendly slugs vs. UUIDs
2. **Role-Aware Pages:** Dashboard adapts based on user's active role(s)
3. **Progressive Disclosure:** Course Detail shows more to enrolled users
4. **Mobile Responsive:** All pages must work on mobile
5. **getstream.io:** Feed page will use Stream SDK components

---

## Page Version History

| Version | Date | Changes |
|---------|------|---------|
| v1 | 2025-12-23 | Initial page inventory from CD-021 and existing docs |
