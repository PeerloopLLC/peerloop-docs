# Screen: Admin Courses

**Code:** ACRS
**URL:** `/admin/courses` (route within Admin SPA)
**Access:** Authenticated (Admin role)
**Priority:** P0
**Status:** Implemented

---

## Purpose

CRUD interface for managing all platform courses - view, search, feature/unfeature, approve, and manage course visibility and status.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| ADMN | "Courses" nav item | Admin sidebar |
| ADMN | Courses stat card | Quick access |
| AUSR | "View Courses" action | From user detail |
| AENR | Course name click | From enrollment |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| CDET | "View Course" action | Opens public page |
| AUSR | Creator name click | View creator |
| AENR | "View Enrollments" | Filtered to course |
| ACAT | "Manage Categories" | Category management |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| courses | All fields | Course records |
| users | creator_id → name, email | Creator info |
| categories | id, name, slug | Course categories |
| enrollments | count per course | Enrollment stats |
| course_curriculum | count per course | Module count |

---

## Sections

### Header
- Screen title: "Course Management"
- "Add Course" button (creates draft)
- Export button

### Search & Filters
- **Search:** Title, creator name, slug
- **Status filter:** All / Published / Draft / Archived
- **Badge filter:** All / Featured / Trending / None
- **Category filter:** All categories
- **Date filter:** Created date range

### Courses Table

| Column | Content |
|--------|---------|
| Course | Thumbnail + title |
| Creator | Creator name |
| Category | Category name |
| Status | Published / Draft / Archived |
| Badge | Featured / Trending / None |
| Enrollments | Count |
| Price | Price display |
| Actions | View, Feature, Archive |

### Course Detail Panel / Modal

**View Mode:**
- Full course data
- Thumbnail preview
- Creator info (with link)
- Category assignment
- Status and badge
- Stats:
  - Enrollments (count, link to AENR)
  - Modules (count)
  - Revenue generated
- Created/Updated timestamps

**Edit Mode:**
- Title, slug (editable)
- Description (editable)
- Category (dropdown)
- Price (editable)
- Status toggle (Published/Draft/Archived)
- Badge selection (Featured/Trending/None)
- Thumbnail (upload/URL)

### Actions

| Action | Description |
|--------|-------------|
| View | Open public course page |
| Edit | Open edit mode |
| Feature | Add Featured badge |
| Unfeature | Remove Featured badge |
| Publish | Change status to Published |
| Unpublish | Change status to Draft |
| Archive | Archive course (soft delete) |
| Restore | Restore archived course |

---

## API Calls

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/admin/courses` | Page load | Paginated, filterable list |
| `GET /api/admin/courses/:id` | Detail open | Full course with stats |
| `POST /api/admin/courses` | Add course | Create draft course |
| `PATCH /api/admin/courses/:id` | Save edit | Update course fields |
| `POST /api/admin/courses/:id/feature` | Feature | Add Featured badge |
| `POST /api/admin/courses/:id/unfeature` | Unfeature | Remove badge |
| `POST /api/admin/courses/:id/publish` | Publish | Set is_active = true |
| `POST /api/admin/courses/:id/unpublish` | Unpublish | Set is_active = false |
| `DELETE /api/admin/courses/:id` | Archive | Soft delete |
| `GET /api/admin/courses/export` | Export | CSV export |

**Query Parameters:**
- `q` - Search title/creator/slug
- `status` - published, draft, archived
- `badge` - featured, trending, none
- `category` - Category ID
- `from`, `to` - Created date range
- `page`, `limit` - Pagination

---

## States & Variations

| State | Description |
|-------|-------------|
| List | Default course list |
| Filtered | Search/filter applied |
| Detail | Course panel open |
| Editing | Edit mode active |
| Confirming | Archive confirmation |

---

## Error Handling

| Error | Display |
|-------|---------|
| Load fails | "Unable to load courses. [Retry]" |
| Update fails | "Unable to save changes. [Retry]" |
| Archive blocked | "Cannot archive course with active enrollments" |

---

## Notes

- Featured courses appear on homepage carousel
- Archived courses remain in database but hidden from listings
- Price changes don't affect existing enrollments
- Consider bulk actions for featuring multiple courses
