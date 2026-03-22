# RUN-001 Access Matrix

**Created:** 2025-12-25
**Purpose:** Define which user roles can access which pages/screens.

---

## Role Definitions

| Code | Role | Description |
|------|------|-------------|
| **V** | Visitor | Non-logged in user |
| **S** | Student | Enrolled learner |
| **T** | Teacher | Certified to teach a course |
| **C** | Creator | Course creator/instructor |
| **M** | Moderator | Community moderator (appointed by Creator) |
| **A** | Admin | Platform administrator |

**Multi-Role Note:** Users can hold multiple roles simultaneously:
- Student (S) is the base role for all authenticated users
- Adding T, C, M doesn't remove S privileges
- Common combinations: S+T, S+C, S+T+C

---

## Access Legend

| Symbol | Meaning |
|--------|---------|
| ✅ | Full access |
| 👁️ | View only (limited features) |
| 🔒 | Conditional access (see notes) |
| ❌ | No access |

---

## Public Pages (No Authentication Required)

| Code | Page | V | S | T | C | M | A | Notes |
|------|------|---|---|---|---|---|---|-------|
| HOME | Homepage | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | All users |
| CBRO | Course Browse | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | All users |
| CDET | Course Detail | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | Enroll button varies by auth state |
| CRLS | Creator Listing | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | All users |
| CPRO | Creator Profile | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | Follow button requires auth |
| STDR | Teacher Directory | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | Book button requires auth |
| STPR | Teacher Profile | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | Book button requires auth |
| LGIN | Login | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | Redirects if already logged in |
| SGUP | Sign Up | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | Redirects if already logged in |
| PWRS | Password Reset | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | Available to all |

---

## Authenticated Pages (Login Required)

### Core Authenticated Pages

| Code | Page | V | S | T | C | M | A | Notes |
|------|------|---|---|---|---|---|---|-------|
| SDSH | Student Dashboard | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ | Shows student role section |
| TDSH | Teacher Dashboard | ❌ | ❌ | ✅ | ✅ | ❌ | ✅ | Only if user is certified Teacher |
| CDSH | Creator Dashboard | ❌ | ❌ | ❌ | ✅ | ❌ | ✅ | Only if user is Creator |
| FEED | Community Feed | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ | All authenticated users |
| MSGS | Messages | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ | All authenticated users |
| PROF | Profile | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ | All authenticated users |
| SETT | Settings | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ | All authenticated users |
| NOTF | Notifications | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ | All authenticated users |

### Course/Learning Pages

| Code | Page | V | S | T | C | M | A | Notes |
|------|------|---|---|---|---|---|---|-------|
| SBOK | Session Booking | ❌ | 🔒 | 🔒 | 🔒 | ❌ | ✅ | Must be enrolled in Teacher's course |
| SROM | Session Room | ❌ | 🔒 | 🔒 | 🔒 | ❌ | ✅ | Must be session participant |
| CCNT | Course Content | ❌ | 🔒 | 🔒 | ✅ | 🔒 | ✅ | Must be enrolled or Creator owns course |
| CHAT | Course Chat | ❌ | 🔒 | 🔒 | ✅ | 🔒 | ✅ | Must be enrolled (P2) |
| HELP | Summon Help | ❌ | 🔒 | ❌ | ❌ | ❌ | ❌ | Students enrolled in course (P2) |
| IFED | Instructor Feed | ❌ | 🔒 | 🔒 | ✅ | ❌ | ✅ | Must have purchased from this creator |

### P3 Pages (Future)

| Code | Page | V | S | T | C | M | A | Notes |
|------|------|---|---|---|---|---|---|-------|
| LEAD | Leaderboard | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ | All authenticated (P3) |
| SUBCOM | Sub-Community | ❌ | 🔒 | 🔒 | 🔒 | 🔒 | ✅ | Members only or public (P3) |

---

## Creator Pages (Creator Role Required)

| Code | Page | V | S | T | C | M | A | Notes |
|------|------|---|---|---|---|---|---|-------|
| STUD | Creator Studio | ❌ | ❌ | ❌ | ✅ | ❌ | ✅ | Creator only |
| CMST | My Students | ❌ | ❌ | ❌ | ✅ | ❌ | ✅ | Creator only |
| CSES | Session History | ❌ | ❌ | ❌ | ✅ | ❌ | ✅ | Creator only |
| CANA | Creator Analytics | ❌ | ❌ | ❌ | ✅ | ❌ | ✅ | Creator only |
| CEAR | Earnings Detail | ❌ | ❌ | ❌ | ✅ | ❌ | ✅ | Creator only |
| CNEW | Creator Newsletters | ❌ | ❌ | ❌ | ✅ | ❌ | ✅ | Creator only (P3) |

---

## Moderator Pages

| Code | Page | V | S | T | C | M | A | Notes |
|------|------|---|---|---|---|---|---|-------|
| MODQ | Moderator Queue | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ | Moderator or Admin |

---

## Admin Pages (Admin Role Required)

| Code | Page | V | S | T | C | M | A | Notes |
|------|------|---|---|---|---|---|---|-------|
| ADMN | Admin Dashboard | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | Admin only |
| AUSR | Admin Users | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | Admin only |
| ACRS | Admin Courses | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | Admin only |
| AENR | Admin Enrollments | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | Admin only |
| ASES | Admin Sessions | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | Admin only |
| ACRT | Admin Certificates | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | Admin only |
| APAY | Admin Payouts | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | Admin only |
| ACAT | Admin Categories | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | Admin only |

---

## Conditional Access Details

### 🔒 Enrollment-Based Access

| Condition | Pages Affected | Check |
|-----------|----------------|-------|
| Enrolled in course | CCNT, CHAT, HELP | `enrollments.user_id = current_user AND enrollments.course_id = :course_id` |
| Enrolled in Teacher's course | SBOK | `enrollments.user_id = current_user AND teacher.course_id = enrollments.course_id` |
| Purchased from creator | IFED | `enrollments.user_id = current_user AND courses.creator_id = :creator_id` |

### 🔒 Session-Based Access

| Condition | Pages Affected | Check |
|-----------|----------------|-------|
| Session participant | SROM | `sessions.student_id = current_user OR sessions.st_id = current_user` |

### 🔒 Membership-Based Access

| Condition | Pages Affected | Check |
|-----------|----------------|-------|
| Sub-community member | SUBCOM | `sub_community_members.user_id = current_user` OR visibility = 'public' |

---

## Multi-Role Dashboard Access

When a user has multiple roles, they see multiple dashboard sections:

| User Roles | Dashboard Experience |
|------------|---------------------|
| S only | Student dashboard only |
| S + T | Student section + Teacher section |
| S + C | Student section + Creator section |
| S + T + C | All three sections |
| S + M | Student section + Moderator link |
| A | Admin dashboard (separate from user dashboards) |

**Implementation:** Single `/dashboard` URL with role-aware sections. See Q5 for section layout.

---

## Navigation Visibility

These items appear in navigation based on role:

| Nav Item | Visible To | Leads To |
|----------|-----------|----------|
| Dashboard | All auth | SDSH/TDSH/CDSH (role-aware) |
| Community | All auth | FEED |
| Messages | All auth | MSGS |
| Studio | Creator only | STUD |
| Moderate | Moderator only | MODQ |
| Admin | Admin only | ADMN |

---

## Document History

| Date | Changes |
|------|---------|
| 2025-12-25 | Initial creation from page analysis |
