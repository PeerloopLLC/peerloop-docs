# ASTC - Admin Student-Teachers

**Route:** `/admin/student-teachers`
**Access:** Admin only
**Block:** 8

## Metadata

| Field | Value |
|-------|-------|
| Page Code | ASTC |
| Route | `/admin/student-teachers` |
| Astro Page | `src/pages/admin/student-teachers.astro` |
| Component | `src/components/admin/StudentTeachersAdmin.tsx` |
| JSON Spec | `src/data/pages/admin/student-teachers.json` |
| Layout | AdminLayout |

## Purpose

CRUD interface for managing Student-Teacher certifications - view, activate/deactivate, revoke, and monitor teaching activity.

## Features

- [x] Page header with title and description
- [x] Stats cards (Total STs, Active STs, Students Taught, Avg Rating)
- [x] Search bar (name, email, course)
- [x] Course filter dropdown
- [x] Status filter dropdown (Active/Inactive)
- [ ] Date filter (certification date range) *(Not implemented)*
- [x] Data table with sortable columns
- [x] ST avatar with initials fallback
- [x] Certification date with "time ago" display
- [x] Students count (total + active)
- [x] Sessions count
- [x] Rating display (or dash if none)
- [x] Status badge (Active/Inactive)
- [x] Row click to open detail panel
- [x] Actions menu (3-dot menu)
- [x] Detail panel slide-in
- [x] Pagination
- [x] Error state with retry button
- [x] Loading state

### Detail Panel Features

- [x] ST name and handle
- [x] Status badge
- [x] ST contact info (name, handle, email)
- [x] Course info (title, certified date, time as ST, approved by)
- [x] Teaching stats (total students, active, completed, sessions, avg rating)
- [x] Recent students list (up to 5)
- [x] Recent sessions list (up to 5)
- [x] Metadata (IDs)
- [x] Footer with View Profile and Activate/Deactivate buttons

### Actions

| Action | Implemented | Notes |
|--------|-------------|-------|
| View Details | [x] | Opens detail panel |
| View Profile | [x] | Navigate to `/admin/users?user={id}` |
| View Students | [x] | Navigate to `/admin/enrollments?st={id}` |
| View Sessions | [x] | Navigate to `/admin/sessions?st={id}` *(target page is PageSpecView)* |
| Activate | [x] | Enable ST to accept students |
| Deactivate | [x] | Disable with confirmation if has active students |
| Revoke Certification | [x] | Delete with confirmation, blocked if has active students |

## Sections

### Header
- Title: "Student-Teacher Management"
- Subtitle: "Manage ST certifications, monitor teaching activity"

### Stats Cards (4)
1. Total STs - count from API
2. Active - count of active STs
3. Students Taught - sum of all students_taught
4. Avg Rating - average rating across all STs (or "-" if none)

### Filter Bar
- Search input with placeholder "Search by name, email, or course..."
- Course dropdown (All Courses / specific courses)
- Status dropdown (All Statuses / Active / Inactive)

### Data Table Columns
1. Student-Teacher - avatar + name + @handle
2. Course - course title
3. Certified - date + "X ago"
4. Students - N total (+ "N active" if any)
5. Sessions - count
6. Rating - star + number or "-"
7. Status - Active/Inactive badge
8. Actions - 3-dot menu

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/admin/student-teachers` | GET | List with pagination/filters | [x] |
| `/api/admin/student-teachers/:id` | GET | Detail with stats | [x] |
| `/api/admin/student-teachers/:id/activate` | POST | Enable ST | [x] |
| `/api/admin/student-teachers/:id/deactivate` | POST | Disable ST | [x] |
| `/api/admin/student-teachers/:id` | DELETE | Revoke certification | [x] |

## Connections

### Incoming

| Source | Route | Trigger |
|--------|-------|---------|
| Admin Sidebar | - | "Student-Teachers" nav item |
| AUSR | `/admin/users` | "View ST Certifications" *(not implemented yet)* |
| ACRS | `/admin/courses` | "View Student-Teachers" *(not implemented yet)* |

### Outgoing

| Target | Route | Trigger | Target Status |
|--------|-------|---------|---------------|
| AUSR | `/admin/users?user={id}` | "View Profile" action | ✅ Implemented |
| AENR | `/admin/enrollments?st={id}` | "View Students" action | ✅ Implemented |
| ASES | `/admin/sessions?st={id}` | "View Sessions" action | 📋 PageSpecView |
| Creator Profile | `/creators/{handle}` | "View Public Profile" button | ✅ Implemented |

---

## Interactive Elements

### Buttons (with onClick handlers)

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| Retry button | Error state | `fetchStudentTeachers()` | ✅ Active |
| View Public Profile | Detail footer | Navigate to `/creators/{handle}` | ✅ Active |
| Deactivate | Detail footer | `handleDeactivate()` | ✅ Active |
| Activate | Detail footer | `handleActivate()` | ✅ Active |

### Row Actions Menu

| Element | Action | Status |
|---------|--------|--------|
| View Details | `fetchSTDetail(id)` | ✅ Active |
| View Profile | Navigate to `/admin/users?user={id}` | ✅ Active |
| View Students | Navigate to `/admin/enrollments?st={id}` | ✅ Active |
| Deactivate/Activate | `handleDeactivate/Activate()` | ✅ Active |
| Revoke Certification | `handleRevoke()` | ✅ Active |

### Internal Links

| Element | Target | Status |
|---------|--------|--------|
| View all students → | `/admin/enrollments?st={id}` | ✅ Active |
| View all sessions → | `/admin/sessions?st={user_id}` | ✅ Active |

### Target Pages Status

| Target | Page Code | Implemented |
|--------|-----------|-------------|
| `/admin/users` | AUSR | ✅ Yes |
| `/admin/enrollments` | AENR | ✅ Yes |
| `/admin/sessions` | ASES | 📋 PageSpecView |
| `/creators/{handle}` | CPRO | ✅ Yes |

---

## Verification Notes

**Verified:** 2026-01-08 (Code + Visual + Interactive Elements)

**Consolidated:** 2026-01-08
- JSON spec updated to match verified implementation
- Added v1.1 schema sections: `features`, `interactiveElements`, `verificationNotes`
- 7 discrepancies documented in JSON `_discrepancies` section

### Components Verified

| Component | File | Status |
|-----------|------|--------|
| StudentTeachersAdmin | `src/components/admin/StudentTeachersAdmin.tsx` | ✅ No TODOs in component |
| Astro Page | `src/pages/admin/student-teachers.astro` | ✅ Clean |

### API TODOs (Deferred)

| File | TODOs | Notes |
|------|-------|-------|
| `[id]/activate.ts` | 2 | Send notification, log action |
| `[id]/deactivate.ts` | 3 | Check other certs, send notification, log action |
| `[id].ts` (DELETE) | 2 | Send notification, log action |

*These are deferred to Block 9 (Notifications) and future admin audit logging.*

### Discrepancies Found

| Feature | Spec | Reality | Status |
|---------|------|---------|--------|
| Date filter | In JSON spec | Not implemented | ⚠️ Missing |
| Approved By column | In JSON spec table | Not in table (in detail panel only) | ⚠️ Different |

### Interactive Elements Summary

| Category | Count | Active | Inactive |
|----------|-------|--------|----------|
| Buttons (onClick) | 4 | 4 | 0 |
| Row Actions | 5 | 5 | 0 |
| Internal Links | 2 | 2 | 0 |
| External Links | 0 | 0 | 0 |
| Analytics Events | 0 | 0 | 0 |

**Notes:**
- All interactive elements are working
- `/admin/sessions` target is PageSpecView placeholder (acceptable)
- No analytics events implemented (not required for admin pages)

### Screenshots

| File | Date | Description |
|------|------|-------------|
| `ASTC-2026-01-08_07-35-45.png` | 2026-01-08 | Main list view with 3 STs |
