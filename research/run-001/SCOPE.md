# RUN-001 Feature Scope Tracker

**Run:** RUN-001 (Stream + VideoProvider)
**Created:** 2025-12-25
**Purpose:** Track feature implementation status as development progresses in 30-hour blocks.

> **Note (Session 307):** For the canonical route→story mapping, see [ROUTE-STORIES.md](../../docs/architecture/route-stories.md) (402 stories mapped to current routes). This file's page-based story assignments use old page codes; ROUTE-STORIES.md uses current routes from `docs/architecture/url-routing.md`.

---

## Status Legend

| Status | Meaning |
|--------|---------|
| `MVP` | In scope for MVP (will be built) |
| `POST-MVP` | Deferred to post-MVP (documented but not built now) |
| `DONE` | Implementation complete |
| `BLOCKED` | Cannot proceed (dependency or decision needed) |
| `PARTIAL` | Some sub-features implemented, others deferred |

---

## How to Use This Document

1. **Features = User Stories** - Each US-* from USER-STORIES.md is a trackable feature
2. **Grouped by Page** - Features organized by the page where they appear
3. **Update as you code** - When starting a 30-hour block, mark features as MVP or POST-MVP
4. **Mark DONE when complete** - Update status as features are implemented
5. **Cross-page features** - Some stories appear on multiple pages; marked with "(also: PAGE, PAGE)"

---

## Scope by Page

### Legend for Priority Column
- **P0** = MVP Core
- **P1** = Important
- **P2** = Block 2+
- **P3** = Future

---

## Public Pages

### HOME - Homepage
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-G001 | View homepage with value proposition | P0 | MVP | |
| US-G002 | See featured courses | P0 | MVP | |
| US-G003 | See featured creators | P0 | MVP | |
| US-G004 | Read promotional content/testimonials | P0 | MVP | |

### CBRO - Course Browse
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-G005 | Browse available courses | P0 | MVP | |
| US-G006 | Filter courses by category/price/rating | P0 | MVP | |
| US-G007 | Search for courses | P0 | MVP | |
| US-S001 | Browse courses with full filters | P0 | MVP | |

### CDET - Course Detail
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-S002 | View course details and pricing | P0 | MVP | |
| US-S003 | See course curriculum/modules | P0 | MVP | |
| US-S004 | See instructor info | P0 | MVP | |
| US-S005 | See student reviews | P0 | MVP | |
| US-S006 | Purchase/enroll in course | P0 | MVP | |

### CRLS - Creator Listing
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-G008 | Browse creator profiles | P0 | MVP | |
| US-G009 | See creator expertise areas | P0 | MVP | |

### CPRO - Creator Profile
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-G010 | View creator's courses and credentials | P0 | MVP | |
| US-S028 | Follow creator before enrolling | P1 | MVP | |

### STDR - Teacher Directory
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-S007 | Browse available Teachers | P1 | MVP | |
| US-S008 | Filter Teachers by course/rating/availability | P1 | MVP | |

### STPR - Teacher Profile
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-S009 | View Teacher credentials and reviews | P0 | MVP | |
| US-S010 | See Teacher availability | P0 | MVP | |

### LGIN - Login
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-G011 | Log in with email/password | P0 | MVP | |
| US-G012 | Log in with social OAuth | P0 | MVP | |
| US-P007 | Secure authentication | P0 | MVP | |

### SGUP - Sign Up
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-G013 | Create new account | P0 | MVP | |
| US-P008 | Email verification | P0 | MVP | |

### PWRS - Password Reset
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-P009 | Request password reset | P0 | MVP | |
| US-P010 | Reset password via email link | P0 | MVP | |

---

## Authenticated Pages

### SDSH - Student Dashboard
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-S011 | View enrolled courses | P0 | MVP | |
| US-S012 | See course progress | P0 | MVP | |
| US-S013 | View upcoming sessions | P0 | MVP | |
| US-S014 | Access learning history | P0 | MVP | |

### TDSH - Teacher Dashboard
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-T001 | View teaching schedule | P0 | MVP | |
| US-T002 | See upcoming sessions | P0 | MVP | |
| US-T003 | View student requests | P0 | MVP | |
| US-T004 | Access earnings summary | P0 | MVP | |

### CDSH - Creator Dashboard
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-C001 | View course performance | P0 | MVP | |
| US-C002 | See enrollment stats | P0 | MVP | |
| US-C003 | Access revenue summary | P0 | MVP | |

### FEED - Community Feed
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-S016 | View community feed | P0 | MVP | |
| US-S017 | Post to feed | P0 | MVP | |
| US-S018 | React to posts | P0 | MVP | |
| US-S019 | Comment on posts | P0 | MVP | |
| US-S071 | Spend points to promote post | P3 | POST-MVP | Goodwill feature |
| US-S079 | AI Chat component in feed | P3 | POST-MVP | Feed companion |
| US-P085 | Process feed promotion requests | P3 | POST-MVP | Backend for promotion |

### MSGS - Messages
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-S020 | Send/receive direct messages | P0 | MVP | |
| US-S021 | View message history | P0 | MVP | |

### PROF - Profile
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-S022 | Edit profile information | P0 | MVP | |
| US-S023 | Upload profile photo | P0 | MVP | |
| US-S024 | Set visibility preferences | P0 | MVP | |

### SETT - Settings
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-S025 | Manage notification preferences | P0 | MVP | |
| US-P011 | Change password | P0 | MVP | |
| US-P012 | Manage connected accounts | P0 | MVP | |
| US-P013 | Delete account | P0 | MVP | |

### NOTF - Notifications
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-P014 | View notifications | P0 | MVP | |
| US-P015 | Mark as read | P0 | MVP | |
| US-P016 | Clear notifications | P0 | MVP | |

### SBOK - Session Booking
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-S083 | View Teacher availability calendar | P0 | MVP | |
| US-S084 | Book session with Teacher | P0 | MVP | |
| US-S085 | Select "Schedule Later" option | P0 | MVP | |
| US-S086 | Receive booking confirmation | P0 | MVP | |

### SROM - Session Room
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-V001 | Join video session | P0 | MVP | |
| US-V002 | Share screen | P0 | MVP | |
| US-V003 | Use whiteboard | P0 | MVP | |
| US-V004 | Chat during session | P0 | MVP | |
| US-V005 | Record session | P0 | MVP | |
| US-V006 | End session | P0 | MVP | |
| US-V007 | Rate session afterward | P0 | MVP | |

### CCNT - Course Content
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-S026 | Access course materials | P0 | MVP | |
| US-S027 | Track progress | P0 | MVP | |

### CHAT - Course Chat
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-S029 | Chat with course peers | P2 | POST-MVP | Goodwill feature |
| US-S030 | Ask questions in chat | P2 | POST-MVP | |

### HELP - Summon Help
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-S031 | Request help using goodwill points | P2 | POST-MVP | Goodwill feature |
| US-P054 | Match help requests to available Teachers | P2 | POST-MVP | |

### IFED - Instructor Feed
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-S032 | View instructor-specific feed | P1 | MVP | |
| US-S033 | Interact with instructor posts | P1 | MVP | |

### LEAD - Leaderboard
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-P053 | Display leaderboards/rankings | P3 | POST-MVP | Goodwill feature |
| US-P082 | Unlock rewards at point thresholds | P3 | POST-MVP | |

### SUBCOM - Sub-Community
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-S081 | Create sub-community with invites | P3 | POST-MVP | Future feature |
| US-P097 | Support user-created sub-communities | P3 | POST-MVP | |

---

## Creator Pages

### STUD - Creator Studio
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-C004 | Access course management | P0 | MVP | |
| US-C005 | Create new course | P0 | MVP | |
| US-C006 | Edit course content | P0 | MVP | |

### CMST - My Students
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-C007 | View all enrolled students | P0 | MVP | |
| US-C008 | See student progress | P0 | MVP | |
| US-C009 | Contact students | P0 | MVP | |

### CSES - Session History
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-C010 | View all sessions | P0 | MVP | |
| US-C011 | See session recordings | P0 | MVP | |
| US-C012 | Review session feedback | P0 | MVP | |

### CANA - Creator Analytics
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-C013 | View enrollment trends | P1 | MVP | |
| US-C014 | See revenue analytics | P1 | MVP | |
| US-C015 | Track student engagement | P1 | MVP | |

### CEAR - Earnings Detail
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-C016 | View earnings breakdown | P0 | MVP | |
| US-C017 | See payout history | P0 | MVP | |
| US-C018 | Request payout | P0 | MVP | |

### CNEW - Creator Newsletters
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-C026 | Publish newsletters | P3 | POST-MVP | Future feature |

---

## Admin Pages

### ADMN - Admin Dashboard
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-A040 | View platform overview | P0 | MVP | |
| US-A041 | See key metrics | P0 | MVP | |
| US-A042 | Access admin tools | P0 | MVP | |

### AUSR - Admin Users
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-A043 | View all users | P0 | MVP | |
| US-A044 | Edit user details | P0 | MVP | |
| US-A045 | Manage user roles | P0 | MVP | |
| US-A046 | Suspend/ban users | P0 | MVP | |

### ACRS - Admin Courses
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-A047 | View all courses | P0 | MVP | |
| US-A048 | Suspend/unsuspend courses | P0 | MVP | |
| US-A049 | Feature courses | P0 | MVP | |

### AENR - Admin Enrollments
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-A050 | View all enrollments | P0 | MVP | |
| US-A051 | Process refunds | P0 | MVP | |
| US-A052 | Override enrollment status | P1 | MVP | |

### ASES - Admin Sessions
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-A053 | View all sessions | P0 | MVP | |
| US-A054 | Access session recordings | P0 | MVP | |
| US-A055 | Handle disputes | P1 | MVP | |

### ACRT - Admin Certificates
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-A056 | View all certificates | P0 | MVP | |
| US-A057 | Issue certificates manually | P1 | MVP | |
| US-A058 | Revoke certificates | P0 | MVP | |

### APAY - Admin Payouts
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-A026 | View pending payouts | P0 | MVP | Canonical ID |
| US-A027 | Process payouts | P0 | MVP | Canonical ID |
| US-A029 | View payout history | P0 | MVP | Canonical ID |

### ACAT - Admin Categories
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-A059 | Manage course categories | P1 | MVP | |
| US-A060 | Reorder categories | P1 | MVP | |

### MODQ - Moderator Queue
| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-M001 | View flagged content | P1 | MVP | |
| US-M002 | Take moderation action | P1 | MVP | |
| US-M003 | Document decisions | P1 | MVP | |

---

## Cross-Cutting Features (Platform-wide)

These stories don't belong to a specific page but affect the whole platform:

| Story | Description | Priority | Status | Notes |
|-------|-------------|----------|--------|-------|
| US-P017 | Email notifications | P0 | MVP | |
| US-P018 | Push notifications | P1 | MVP | |
| US-P019 | SMS notifications | P2 | POST-MVP | |
| US-P020 | Calendar sync | P1 | MVP | |
| US-P021 | Mobile responsiveness | P0 | MVP | |
| US-P022 | Accessibility (WCAG) | P0 | MVP | |
| US-P023 | Analytics tracking | P0 | MVP | |
| US-P024 | Error logging | P0 | MVP | |
| US-P025 | Rate limiting | P0 | MVP | |

---

## Summary Statistics

| Priority | Total | MVP | POST-MVP | DONE |
|----------|-------|-----|----------|------|
| P0 | ~144 | 144 | 0 | 0 |
| P1 | ~106 | TBD | TBD | 0 |
| P2 | ~71 | TBD | TBD | 0 |
| P3 | 8 | 0 | 8 | 0 |
| **Total** | ~329 | TBD | TBD | 0 |

*Note: This is a representative sample. Full story counts are in USER-STORIES.md.*

---

## Block Progress Log

Track 30-hour development blocks here:

| Block | Dates | Focus | Stories Completed | Notes |
|-------|-------|-------|-------------------|-------|
| Block 1 | TBD | TBD | 0 | Not started |

---

## Document History

| Date | Changes |
|------|---------|
| 2025-12-25 | Initial creation with feature tracking structure |
