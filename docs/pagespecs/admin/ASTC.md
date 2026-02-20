# Screen: Admin Student-Teachers

**Code:** ASTC
**URL:** `/admin/student-teachers` (route within Admin SPA)
**Access:** Authenticated (Admin role)
**Priority:** P0
**Status:** Implemented

---

## Purpose

Manage Student-Teacher certifications, approvals, and performance - review applications, approve/revoke certifications, and monitor S-T activity.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| ADMN | "Student-Teachers" nav item | Admin sidebar |
| ADMN | S-T stat card | Quick access |
| AUSR | "View S-T Status" action | From user detail |
| ACRS | "View S-Ts" action | From course detail |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| AUSR | S-T name click | View user profile |
| ACRS | Course name click | View course |
| ASES | "View Sessions" | Filtered to S-T |
| APAY | "View Earnings" | Filtered to S-T |
| STPR | "View Public Profile" | Opens S-T profile |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| student_teachers | All fields | S-T records |
| users | id, name, email, avatar_url | User info |
| courses | id, title | Course info |
| sessions | count per S-T | Session stats |
| enrollments | count per S-T (as teacher) | Students taught |
| payouts | sum per S-T | Earnings total |

---

## Sections

### Header
- Screen title: "Student-Teacher Management"
- Stats summary: Total, Active, Pending, Suspended
- Export button

### Search & Filters
- **Search:** Name, email, course
- **Status filter:** All / Active / Pending / Suspended / Revoked
- **Course filter:** All courses
- **Rating filter:** Min rating threshold
- **Date filter:** Certified date range

### Student-Teachers Table

| Column | Content |
|--------|---------|
| S-T | Avatar + name |
| Course | Course title |
| Status | Active / Pending / Suspended / Revoked |
| Certified | Certification date |
| Sessions | Count completed |
| Students | Count taught |
| Rating | Average rating (stars) |
| Earnings | Total earned |
| Actions | Approve, Suspend, Revoke |

### S-T Detail Panel / Modal

**View Mode:**
- Full user profile
- Certification details:
  - Course certified for
  - Certification date
  - Certifying creator
  - Status
- Performance stats:
  - Sessions completed
  - Students taught
  - Average rating
  - Total earnings
- Recent sessions (last 5)
- Student feedback summary

**Edit Mode:**
- Status toggle (Active/Suspended)
- Commission rate override (if applicable)
- Admin notes

### Actions

| Action | Description |
|--------|-------------|
| View | Open detail panel |
| Approve | Approve pending certification |
| Suspend | Temporarily suspend (with reason) |
| Unsuspend | Restore suspended S-T |
| Revoke | Permanently revoke certification |
| View Sessions | Navigate to ASES filtered |
| View Earnings | Navigate to APAY filtered |

### Pending Approvals Section
- Highlighted section for pending certifications
- Quick approve/reject workflow
- Creator recommendation visible

---

## API Calls

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/admin/student-teachers` | Page load | Paginated, filterable list |
| `GET /api/admin/student-teachers/:id` | Detail open | Full S-T with stats |
| `POST /api/admin/student-teachers/:id/approve` | Approve | Approve certification |
| `POST /api/admin/student-teachers/:id/suspend` | Suspend | Suspend with reason |
| `POST /api/admin/student-teachers/:id/unsuspend` | Unsuspend | Restore S-T |
| `POST /api/admin/student-teachers/:id/revoke` | Revoke | Permanently revoke |
| `PATCH /api/admin/student-teachers/:id` | Save edit | Update fields |
| `GET /api/admin/student-teachers/export` | Export | CSV export |

**Query Parameters:**
- `q` - Search name/email/course
- `status` - active, pending, suspended, revoked
- `course_id` - Filter by course
- `min_rating` - Minimum rating
- `from`, `to` - Certified date range
- `page`, `limit` - Pagination

---

## States & Variations

| State | Description |
|-------|-------------|
| List | Default S-T list |
| Filtered | Search/filter applied |
| Detail | S-T panel open |
| Pending | Showing pending approvals |
| Confirming | Revoke confirmation |

---

## Error Handling

| Error | Display |
|-------|---------|
| Load fails | "Unable to load student-teachers. [Retry]" |
| Approve fails | "Unable to approve. [Retry]" |
| Revoke blocked | "Cannot revoke S-T with active sessions" |

---

## Workflow: Certification Approval

1. Student completes course
2. Creator recommends for certification
3. Appears in "Pending Approvals"
4. Admin reviews and approves/rejects
5. Approved → S-T can start teaching

---

## Notes

- S-Ts can be certified for multiple courses
- Each certification is a separate record
- Suspension affects all courses; revocation is per-course
- Commission rate is typically 70% (configurable)
- Consider automated approval based on criteria
