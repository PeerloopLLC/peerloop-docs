# Story Dependencies Map

**Created:** 2025-12-25
**Purpose:** Identify which features must be built before others can work.

---

## Dependency Types

| Type | Symbol | Meaning |
|------|--------|---------|
| Hard | `→→` | Cannot start B until A is complete |
| Soft | `→` | B works better with A, but can stub |
| Infrastructure | `⚡` | Underlying system needed by many features |

---

## Infrastructure Dependencies (Build First)

These are foundational systems that many features depend on:

```
⚡ Authentication System
   └── US-P007-P013 (auth stories)
   └── Needed by: ALL authenticated pages

⚡ Database Schema
   └── US-P034-P037 (database stories)
   └── Needed by: ALL data operations

⚡ File Storage
   └── US-P038-P045 (storage stories)
   └── Needed by: Avatars, course content, recordings

⚡ Payment Processing
   └── US-P026-P033 (payment stories)
   └── Needed by: Enrollments, payouts

⚡ Email/Notifications
   └── US-P014-P019 (notification stories)
   └── Needed by: Account verification, booking confirmations
```

---

## Major Dependency Chains

### Chain 1: Course Lifecycle

```
US-C001 Create Course
    →→ US-C002 Publish Course
        →→ US-G005 Browse Courses (public)
            →→ US-S002 View Course Details
                →→ US-S006 Purchase/Enroll
                    →→ US-S026 Access Course Content
                        →→ US-S027 Track Progress
                            →→ Certificate (on completion)
```

**Block Planning Note:** You cannot have students without courses.

---

### Chain 2: Session Lifecycle

```
US-S006 Enroll in Course
    →→ US-T019 ST Certified for Course
        →→ US-T001 ST Sets Availability
            →→ US-S083 View ST Calendar
                →→ US-S084 Book Session
                    →→ US-V001 Join Session Room
                        →→ US-V005 Record Session
                            →→ US-V007 Rate Session
```

**Block Planning Note:** Sessions require enrollment + ST certification + video platform.

---

### Chain 3: Student-Teacher Lifecycle

```
US-S006 Enroll in Course
    →→ US-S027 Track Progress
        →→ Complete Course (100%)
            →→ US-T017 Request Teaching Cert
                →→ US-C009 Creator Reviews/Approves
                    →→ US-T019 Receive Teaching Cert
                        →→ US-T001 Set Availability
                            →→ US-T002 Accept Session Bookings
```

**Block Planning Note:** STs come from students who complete courses.

---

### Chain 4: Payment/Payout Lifecycle

```
US-S006 Purchase Course
    →→ US-P026 Process Payment (Stripe)
        →→ US-P027 Create Enrollment Record
            →→ US-P028 Calculate Revenue Split (85/15)
                →→ US-P029 Track Pending Payout
                    →→ US-A021 Admin Processes Payout
                        →→ US-P030 Transfer to Stripe Connect
```

**Block Planning Note:** Payments must work before real enrollments.

---

### Chain 5: Community Feed

```
US-P002 Stream Integration
    →→ US-S016 View Community Feed
        →→ US-S017 Post to Feed
            →→ US-S018 React to Posts
                →→ US-S019 Comment on Posts
```

**Block Planning Note:** Feed requires Stream.io setup.

---

### Chain 6: Video Platform

```
US-V001 VideoProvider Interface
    →→ BBB Adapter OR PlugNmeet Adapter
        →→ US-V002 Create Room
            →→ US-V003 Generate Join URL
                →→ US-V004 Start Recording
                    →→ US-V005 Get Recording
                        →→ US-P038 Store Recording (R2)
```

**Block Planning Note:** Video platform is critical path for MVP.

---

## Page → Feature Dependencies

Which features must work before a page is usable:

| Page | Required Features | Can Stub? |
|------|-------------------|-----------|
| HOME | None (static content) | N/A |
| CBRO | Course listing API | Yes (seed data) |
| CDET | Course detail API | Yes (seed data) |
| LGIN | Auth system | No - critical |
| SGUP | Auth + email verification | No - critical |
| SDSH | Auth + enrollments | Partial (empty state) |
| SBOK | Enrollments + ST availability | No - needs real data |
| SROM | VideoProvider + session record | No - critical |
| CCNT | Course content storage | No - needs content |
| FEED | Stream.io integration | No - external dep |
| STUD | Course CRUD | No - needs to work |
| ADMN | All CRUD operations | Partial (build incrementally) |

---

## Suggested Block Order

Based on dependencies, here's a logical order for 30-hour blocks:

### Block 0: Foundation
- ⚡ Database schema setup
- ⚡ Authentication (signup, login, password reset)
- ⚡ Basic navigation shell
- **Pages enabled:** LGIN, SGUP, PWRS, HOME (static)

### Block 1: Course Display (Read-Only)
- Course listing API
- Course detail API
- Creator profile display
- **Pages enabled:** CBRO, CDET, CRLS, CPRO

### Block 2: Enrollment Flow
- ⚡ Payment processing (Stripe)
- Enrollment creation
- Basic student dashboard
- **Pages enabled:** SDSH (basic), enrollment on CDET

### Block 3: Course Content
- Course content storage
- Progress tracking
- **Pages enabled:** CCNT, SDSH (with courses)

### Block 4: Video Sessions
- ⚡ VideoProvider integration
- Session booking
- Session room
- **Pages enabled:** SBOK, SROM

### Block 5: Community Feed
- ⚡ Stream.io integration
- Feed display and interaction
- **Pages enabled:** FEED

### Block 6: ST & Certification
- Certificate issuance
- ST role assignment
- ST dashboard
- **Pages enabled:** TDSH, STDR, STPR

### Block 7: Creator Tools
- Creator studio
- Course creation/editing
- Student management
- **Pages enabled:** STUD, CMST, CSES, CDSH

### Block 8: Admin
- Admin dashboard
- CRUD screens
- **Pages enabled:** ADMN, AUSR, ACRS, AENR, ASES, ACRT, APAY

### Block 9: Polish & P1 Features
- Notifications
- Analytics
- Settings
- **Pages enabled:** NOTF, SETT, PROF, CANA

---

## Cross-Cutting Dependencies

Features that affect many pages:

| Feature | Affects | Priority |
|---------|---------|----------|
| Auth | All authenticated pages | Block 0 |
| Notifications | Booking, messages, etc. | Block 5+ |
| Error handling | All pages | Throughout |
| Analytics | All pages | Block 9 |
| Mobile responsive | All pages | Throughout |

---

## Reassessment Points

Each block should reassess:
1. What's blocking the next block?
2. Any P1 features that should pull forward?
3. Any P0 features that should defer?
4. Update SCOPE.md with DONE statuses

---

## Document History

| Date | Changes |
|------|---------|
| 2025-12-25 | Initial dependency mapping |
