# ACRS - Admin Courses

| Field | Value |
|-------|-------|
| Route | `/admin/courses` |
| Access | Authenticated (Admin role) |
| Priority | P0 |
| Status | ✅ Implemented |
| Block | 8 |
| Astro Page | `src/pages/admin/courses.astro` |
| Component | `src/components/admin/CoursesAdmin.tsx` |
| JSON Spec | `src/data/pages/admin/courses.json` |
| Implemented | 2026-01-06 |

---

## Purpose

CRUD interface for managing all courses - view, edit, feature, suspend, and oversee course content and settings.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-A047 | As an Admin, I need to view all courses with search and filter so that I can find and manage course content | P0 | ✅ |
| US-A048 | As an Admin, I need to suspend or unsuspend courses so that I can hide problematic content from the platform | P0 | ✅ |
| US-A049 | As an Admin, I need to feature or unfeature courses so that I can curate promoted content on the homepage | P0 | ✅ |
| US-A020 | As an Admin, I need to monitor courses taken by user, teacher, creator stats so that I can track platform health | P1 | ✅ |

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| ADMN | "Courses" nav item | Admin sidebar |
| AENR | Course name click | From enrollment |
| AUSR | "View Courses" on creator | Filtered to creator |

### Outgoing (users navigate to)

| Target | Trigger | Notes | Status |
|--------|---------|-------|--------|
| CDET | "View Public Page" | Opens in new tab | ✅ |
| AENR | "View Enrollments" | Filtered to course | ⏳ Pending |
| ASES | "View Sessions" | Filtered to course | ⏳ Pending |
| AUSR | Creator name click | View creator | ⏳ Pending |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| courses | All fields | Course records |
| users (creators) | id, name | Creator info |
| enrollments | count per course | Enrollment stats |
| student_teachers | count per course | ST count |
| categories | id, name | Category reference |

---

## Features

### Viewing & Browsing
- [x] Course listing with thumbnail, title, creator, category, price, students, rating `[US-A047]`
- [x] Search by title/description/creator name `[US-A047]`
- [x] Filter by category `[US-A047]`
- [x] Filter by status (active/inactive/retired) `[US-A047]`
- [x] Filter by level (beginner/intermediate/advanced) `[US-A047]`
- [x] Filter by featured `[US-A047]`
- [x] Pagination controls `[US-A047]`
- [x] Course detail slide-in panel `[US-A047]`
- [x] Creator info in detail (name, handle, email) `[US-A047]`
- [x] Curriculum display (modules list) `[US-A047]`
- [x] Learning objectives display `[US-A047]`

### Stats & Metrics
- [x] Course stats (enrollments, active, completed, STs, rating) `[US-A047, US-A020]`
- [x] Stats cards (total courses, active, featured, total enrollments) `[US-A047, US-A020]`

### Course Actions
- [x] Feature/unfeature courses (badge toggle) `[US-A049]`
- [x] Set promotional badge (popular/new/bestseller/featured/none) `[US-A049]`
- [x] Suspend course (deactivate) `[US-A048]`
- [x] Unsuspend course (reactivate) `[US-A048]`
- [x] Delete course (enrollment-protected) `[US-A048]`
- [x] View public page (opens in new tab) `[US-A047]`

### Pending Features
- [ ] Edit course form (inline editing) `[US-A048]`
- [ ] View enrollments link (filtered to course) `[US-A050]`
- [ ] Transfer course ownership `[—]` *(Planned, not implemented)*
- [ ] Bulk actions `[—]` *(Planned, not implemented)*
- [ ] Export courses (CSV/JSON) `[—]` *(Planned, not implemented)*

---

## Sections (from Plan)

### Header
- Screen title: "Course Management"
- "Add Course" button (rarely used by admin)
- Export button *(not implemented)*

### Courses Table

| Column | Content | Status |
|--------|---------|--------|
| Course | Thumbnail + title | ✅ |
| Creator | Creator name | ✅ |
| Category | Category name | ✅ |
| Price | Price display | ✅ |
| Students | Enrollment count | ✅ |
| Rating | Stars + count | ✅ |
| Status | Published / Draft / Suspended | ✅ |
| Featured | Star icon | ✅ |
| Actions | Edit, Feature, Suspend | ✅ |

### Course Detail Panel

**View Mode:**
- [x] Full course info
- [x] Creator info (link to AUSR)
- [x] Curriculum summary
- [x] Stats (enrollments, active STs, sessions completed, revenue)
- [ ] Moderation notes *(planned, not implemented)*

**Edit Mode:** *(not implemented - planned feature)*
- Title, description (editable)
- Price (editable)
- Category (editable)
- Status (published/suspended)
- Featured toggle
- Badge assignment
- Admin notes

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/admin/courses` | GET | List courses (paginated, filterable) | ✅ |
| `/api/admin/courses` | POST | Create course (rarely used) | ✅ |
| `/api/admin/courses/:id` | GET | Get course detail with stats | ✅ |
| `/api/admin/courses/:id` | PATCH | Update course | ✅ |
| `/api/admin/courses/:id` | DELETE | Soft delete course | ✅ |
| `/api/admin/courses/:id/feature` | POST | Add featured badge | ✅ |
| `/api/admin/courses/:id/feature` | DELETE | Remove featured badge | ✅ |
| `/api/admin/courses/:id/suspend` | POST | Deactivate course | ✅ |
| `/api/admin/courses/:id/unsuspend` | POST | Reactivate course | ✅ |
| `/api/admin/courses/:id/badge` | POST | Set promotional badge | ✅ |
| `/api/admin/courses/:id/transfer` | POST | Change owner | ⏳ Planned |

**Query Parameters:**
- `q` - Search title, creator name
- `category_id` - Filter by category
- `status` - published, draft, suspended, retired
- `level` - beginner, intermediate, advanced
- `featured` - true/false
- `page`, `limit` - Pagination

**Course Response:**
```typescript
GET /api/admin/courses/:id
{
  course: { ...all fields... },
  creator: { id, name },
  stats: {
    enrollments: number,
    active_sts: number,
    sessions_completed: number,
    revenue: number
  }
}
```

---

## States & Variations

| State | Description | Status |
|-------|-------------|--------|
| List | Default course list | ✅ |
| Filtered | Search/filter applied | ✅ |
| Detail | Course panel open | ✅ |
| Editing | Edit mode active | ⏳ Planned |

---

## Error Handling

| Error | Display |
|-------|---------|
| Load fails | "Unable to load courses. [Retry]" |
| Update fails | "Unable to save changes. [Retry]" |
| Delete blocked | "Cannot delete course with enrollments" |

---

## Gap Analysis

| Feature | Suggested Story |
|---------|-----------------|
| Transfer course ownership | US-A061: Admin can transfer course to different creator |
| Bulk suspend/feature | US-A062: Admin can perform bulk actions on multiple courses |
| Export courses | US-A063: Admin can export course list as CSV/JSON |

---

## Implementation Notes

- Uses shared admin components (AdminDataTable, AdminFilterBar, AdminDetailPanel)
- Courses with enrollments cannot be deleted (soft delete protection)
- Badge selector allows quick promotional badge changes
- Suspend/unsuspend controls `is_active` flag
- "Approve/reject" workflow not implemented - courses are created as active or inactive by creators

---

## Plan vs Implementation

| Planned Feature | Implementation Status |
|-----------------|----------------------|
| Export button | Not implemented |
| Edit Mode in detail panel | Not implemented |
| Moderation notes | Not implemented |
| Transfer ownership | Not implemented |
| Cross-page links (AENR, ASES, AUSR) | Partially implemented |

---

## Interactive Elements

### Buttons (with onClick handlers)

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| Error retry | CoursesAdmin | Retries `fetchCourses()` | ✅ Active |
| View Details (row action) | AdminActionMenu | Opens detail panel for course | ✅ Active |
| View Public Page (row action) | AdminActionMenu | Opens `/courses/{slug}` in new tab | ✅ Active |
| Set/Remove Featured (row action) | AdminActionMenu | POST/DELETE `/api/admin/courses/{id}/feature` | ✅ Active |
| Suspend (row action) | AdminActionMenu | POST `/api/admin/courses/{id}/suspend` with confirm | ✅ Active |
| Unsuspend (row action) | AdminActionMenu | POST `/api/admin/courses/{id}/unsuspend` | ✅ Active |
| Delete (row action) | AdminActionMenu | DELETE `/api/admin/courses/{id}` with confirm | ✅ Active |
| Table row click | AdminDataTable | Opens detail panel for course | ✅ Active |
| View Public Page (panel footer) | AdminDetailPanel | Opens `/courses/{slug}` in new tab | ✅ Active |
| Suspend/Unsuspend (panel footer) | AdminDetailPanel | POST suspend/unsuspend API | ✅ Active |
| Set Featured (panel footer) | AdminDetailPanel | POST/DELETE feature API | ✅ Active |
| Badge selector buttons (x5) | AdminDetailPanel | POST `/api/admin/courses/{id}/badge` | ✅ Active |
| Panel close | AdminDetailPanel | Closes slide-in panel | ✅ Active |

### Filter Controls

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| Search input | AdminFilterBar | Updates `search` state, triggers API refetch | ✅ Active |
| Category dropdown | AdminFilterBar | Filters by `category_id` | ✅ Active |
| Status dropdown | AdminFilterBar | Filters by status (active/inactive/retired) | ✅ Active |
| Level dropdown | AdminFilterBar | Filters by level (beginner/intermediate/advanced) | ✅ Active |
| Featured toggle | AdminFilterBar | Filters to featured courses only | ✅ Active |

### Pagination

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| Previous page | AdminPagination | Decrements page number | ✅ Active |
| Next page | AdminPagination | Increments page number | ✅ Active |
| Page numbers | AdminPagination | Sets specific page | ✅ Active |

### Links - Admin Sidebar (via AdminLayout)

| Element | Target | Status |
|---------|--------|--------|
| Dashboard | /admin | 📋 PageSpecView |
| Users | /admin/users | ✅ Implemented |
| Courses | /admin/courses | ✅ Implemented (current) |
| Enrollments | /admin/enrollments | 📋 PageSpecView |
| Sessions | /admin/sessions | 📋 PageSpecView |
| Payouts | /admin/payouts | 📋 PageSpecView |
| Moderation Queue | /admin/moderation | 📋 PageSpecView |
| Moderators | /admin/moderators | 📋 PageSpecView |
| Back to App | / | ✅ Active |

### External Links (new tab)

| Element | Target | Status |
|---------|--------|--------|
| View Public Page | /courses/{slug} | ✅ Active (opens in new tab) |

### API Calls (triggered by interactions)

| Trigger | Endpoint | Method | Status |
|---------|----------|--------|--------|
| Page load / filter change | `/api/admin/courses` | GET | ✅ Active |
| View Details click | `/api/admin/courses/{id}` | GET | ✅ Active |
| Categories load | `/api/categories` | GET | ✅ Active |
| Set Featured | `/api/admin/courses/{id}/feature` | POST | ✅ Active |
| Remove Featured | `/api/admin/courses/{id}/feature` | DELETE | ✅ Active |
| Suspend | `/api/admin/courses/{id}/suspend` | POST | ✅ Active |
| Unsuspend | `/api/admin/courses/{id}/unsuspend` | POST | ✅ Active |
| Set Badge | `/api/admin/courses/{id}/badge` | POST | ✅ Active |
| Delete | `/api/admin/courses/{id}` | DELETE | ✅ Active |

### Target Pages Status

| Target | Page Code | Implemented |
|--------|-----------|-------------|
| /admin | ADMN | 📋 PageSpecView |
| /admin/users | AUSR | ✅ Yes |
| /admin/courses | ACRS | ✅ Yes (current) |
| /admin/enrollments | AENR | 📋 PageSpecView |
| /admin/sessions | ASES | 📋 PageSpecView |
| /admin/payouts | APAY | 📋 PageSpecView |
| /admin/moderation | MODQ | 📋 PageSpecView |
| /admin/moderators | MINV | 📋 PageSpecView |
| /courses/{slug} | CDET | ✅ Yes |
| / | HOME | ✅ Yes |

---

## Verification Notes

**Verified:** 2026-01-07 (Code + Visual + Interactive Elements)

**Consolidated:** 2026-01-08
- JSON spec updated to match verified implementation
- 6 discrepancies documented in JSON `_discrepancies` section

### Discrepancies Found

| Feature | Spec | Reality | Status |
|---------|------|---------|--------|
| Edit course form | Planned | Not implemented | ⏳ Deferred |
| View enrollments link | Planned | Not implemented (AENR not ready) | ⏳ Deferred |
| Moderation notes | Planned | Not implemented | ⏳ Deferred |
| Transfer ownership | Planned | Not implemented | ⏳ Deferred |
| Export button | Planned | Not implemented | ⏳ Deferred |
| Creator name click → AUSR | Spec mentions | Not linked | ⚠️ Missing |
| Analytics events | Not specified | None implemented | ℹ️ Not planned |

### Components Verified

| Component | File | Status |
|-----------|------|--------|
| CoursesAdmin | `src/components/admin/CoursesAdmin.tsx` | ✅ No TODOs |
| courses.astro | `src/pages/admin/courses.astro` | ✅ Clean |

### Interactive Elements Summary

| Category | Count | Active | Inactive |
|----------|-------|--------|----------|
| Buttons (onClick) | 13 | 13 | 0 |
| Filter Controls | 5 | 5 | 0 |
| Pagination Controls | 3 | 3 | 0 |
| Admin Sidebar Links | 9 | 9 | 0 |
| External Links | 1 | 1 | 0 |
| API Endpoints | 9 | 9 | 0 |
| Analytics Events | 0 | 0 | 0 |

**Notes:**
- All core admin functionality is working (list, filter, detail, actions)
- Row actions and detail panel actions all functional
- Creator name in table not clickable (spec says should link to AUSR)
- Admin sidebar shows notification badge for Moderation Queue
- Some target pages are PageSpecView placeholders (AENR, ASES, APAY, MODQ, MINV)

### Screenshots

| File | Date | Description |
|------|------|-------------|
| `ACRS-2026-01-07-05-26-24.png` | 2026-01-07 | Course list view with filters and stats |
| `ACRS-2026-01-07-05-31-25.png` | 2026-01-07 | Course detail panel (slide-in) |
