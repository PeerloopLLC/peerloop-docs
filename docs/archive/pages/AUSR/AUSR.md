# AUSR - Admin Users

| Field | Value |
|-------|-------|
| Route | `/admin/users` |
| Access | Authenticated (Admin role) |
| Priority | P0 |
| Status | ✅ Implemented |
| Block | 8 |
| Astro Page | `src/pages/admin/users.astro` |
| Component | `src/components/admin/UsersAdmin.tsx` |
| JSON Spec | `src/data/pages/admin/users.json` |
| Implemented | 2025-12-29 |

---

## Purpose

CRUD interface for managing all platform users - view, search, filter, suspend, unsuspend, and delete users.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-A044 | As an Admin, I need to view all users with search and filter so that I can find and manage users | P0 | ✅ |
| US-A045 | As an Admin, I need to suspend or unsuspend users so that I can address policy violations | P0 | ✅ |
| US-A046 | As an Admin, I need to view user details and activity so that I can investigate issues | P0 | ✅ |

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| ADMN | "Users" nav item | Admin sidebar |
| ACRS | Creator name click | From course management |

### Outgoing (users navigate to)

| Target | Trigger | Notes | Status |
|--------|---------|-------|--------|
| PROF | "View Profile" action | Opens /@{handle} in new tab | ✅ |
| ACRS | "View Courses" | Filtered to creator | ⏳ Pending |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| users | All fields | User records |
| enrollments | count per user | Enrollment stats |
| sessions | count per user | Session stats |
| courses | count per creator | Courses created |

---

## Features

### Viewing & Browsing
- [x] User listing with avatar, name, handle, email `[US-A044]`
- [x] Sortable columns (name, email, joined) `[US-A044]`
- [x] Search by name/email/handle `[US-A044]`
- [x] Filter by role (admin/creator/student-teacher/student/moderator) `[US-A044]`
- [x] Filter by status (active/suspended/unverified) `[US-A044]`
- [x] Role badges display `[US-A044]`
- [x] Status badges (active/suspended/unverified) `[US-A044]`
- [x] Pagination controls with items-per-page selector `[US-A044]`

### User Detail Panel
- [x] User detail slide-in panel `[US-A046]`
- [x] Avatar + name + email + roles display `[US-A046]`
- [x] Account status section (status, email verified, suspend info) `[US-A046]`
- [x] Profile section (title, location, bio, website, public profile) `[US-A046]`
- [x] Stats section (enrollments, sessions, courses created) `[US-A046]`
- [x] Dates section (joined, last updated) `[US-A046]`

### User Actions
- [x] Suspend user with reason (prompt) `[US-A045]`
- [x] Unsuspend user `[US-A045]`
- [x] Delete user (soft delete with confirmation) `[US-A045]`
- [x] View public profile (opens in new tab) `[US-A046]`

### Shared Components
- [x] AdminDataTable shared component
- [x] AdminFilterBar shared component
- [x] AdminDetailPanel shared component
- [x] AdminActionMenu shared component
- [x] AdminPagination shared component

### Pending Features
- [ ] Add User modal *(button exists, shows TODO alert)*
- [ ] Bulk actions (suspend multiple) `[—]`
- [ ] Export users (CSV/JSON) `[—]`
- [ ] Impersonate user `[—]`

---

## Sections

### Header
- [x] Screen title: "User Management"
- [x] Subtitle: "Manage all platform users"
- [ ] "Add User" button *(placeholder - shows TODO alert)*

### Filter Bar
- [x] Search input (name, email, handle)
- [x] Role dropdown (All Roles, Admin, Creator, Student-Teacher, Student, Moderator)
- [x] Status dropdown (All Statuses, Active, Suspended, Unverified)

### Users Table

| Column | Content | Sortable | Status |
|--------|---------|----------|--------|
| User | Avatar + name + @handle | ✅ | ✅ |
| Email | Email address | ✅ | ✅ |
| Roles | Role badges | ❌ | ✅ |
| Status | Status badge | ❌ | ✅ |
| Joined | Date | ✅ | ✅ |
| Actions | Menu button | ❌ | ✅ |

### User Detail Panel

**Header:**
- Avatar + name + email + role badges

**Sections:**
- Account Status: Status badge, Email Verified, Suspended info (if applicable)
- Profile: Title, Location, Bio, Website, Public Profile
- Stats: Enrollments, Sessions, Courses Created
- Dates: Joined, Last Updated

**Footer:**
- Suspend/Unsuspend button (context-dependent)
- Delete button

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/admin/users` | GET | List users (paginated, filterable, sortable) | ✅ |
| `/api/admin/users/:id` | GET | Get user detail with stats | ✅ |
| `/api/admin/users/:id` | DELETE | Soft delete user | ✅ |
| `/api/admin/users/:id/suspend` | POST | Suspend user with reason | ✅ |
| `/api/admin/users/:id/unsuspend` | POST | Unsuspend user | ✅ |

**Query Parameters:**
- `search` - Search name, email, handle
- `role` - admin, creator, student_teacher, student, moderator
- `status` - active, suspended, unverified
- `sort` - Column to sort by
- `order` - asc, desc
- `page`, `limit` - Pagination

---

## States & Variations

| State | Description | Status |
|-------|-------------|--------|
| List | Default user list | ✅ |
| Filtered | Search/filter applied | ✅ |
| Sorted | Column sorting active | ✅ |
| Detail | User panel open | ✅ |
| Loading | Data fetching | ✅ |
| Error | API error with retry | ✅ |

---

## Error Handling

| Error | Display |
|-------|---------|
| Load fails | "Unable to load users. [Retry]" |
| Access denied | "Access denied. Admin role required." |
| Delete fails | Alert with error message |
| Suspend fails | Console error (should show alert) |

---

## Implementation Notes

- First admin page implemented, established shared component patterns
- Soft delete via `deleted_at` column
- Suspend stores reason in `suspended_reason` column
- Role badges show all active roles (admin can have multiple)
- Student badge only shows if no other roles active

---

## Interactive Elements

### Buttons (with onClick handlers)

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| Add User | UsersAdmin | Shows TODO alert | ⚠️ Placeholder |
| Error retry | UsersAdmin | Retries `fetchUsers()` | ✅ Active |
| Table row click | AdminDataTable | Opens detail panel for user | ✅ Active |
| View Details (row action) | AdminActionMenu | Opens detail panel | ✅ Active |
| View Profile (row action) | AdminActionMenu | Opens /@{handle} in new tab | ✅ Active |
| Suspend (row action) | AdminActionMenu | Prompts for reason, POST suspend API | ✅ Active |
| Unsuspend (row action) | AdminActionMenu | POST unsuspend API | ✅ Active |
| Delete (row action) | AdminActionMenu | Confirm + DELETE API | ✅ Active |
| Suspend (panel footer) | AdminDetailPanel | Prompts for reason, POST suspend API | ✅ Active |
| Unsuspend (panel footer) | AdminDetailPanel | POST unsuspend API | ✅ Active |
| Delete (panel footer) | AdminDetailPanel | Confirm + DELETE API | ✅ Active |
| Panel close | AdminDetailPanel | Closes slide-in panel | ✅ Active |

### Filter Controls

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| Search input | AdminFilterBar | Updates `search` state, triggers API refetch | ✅ Active |
| Role dropdown | AdminFilterBar | Filters by role | ✅ Active |
| Status dropdown | AdminFilterBar | Filters by status | ✅ Active |

### Sorting Controls

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| User column header | AdminDataTable | Sorts by name | ✅ Active |
| Email column header | AdminDataTable | Sorts by email | ✅ Active |
| Joined column header | AdminDataTable | Sorts by created_at | ✅ Active |

### Pagination

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| Previous page | AdminPagination | Decrements page number | ✅ Active |
| Next page | AdminPagination | Increments page number | ✅ Active |
| Page numbers | AdminPagination | Sets specific page | ✅ Active |
| Items per page | AdminPagination | Changes limit (20, 50, 100) | ✅ Active |

### Links - Admin Sidebar (via AdminLayout)

| Element | Target | Status |
|---------|--------|--------|
| Dashboard | /admin | 📋 PageSpecView |
| Users | /admin/users | ✅ Implemented (current) |
| Courses | /admin/courses | ✅ Implemented |
| Categories | /admin/categories | ✅ Implemented |
| Enrollments | /admin/enrollments | 📋 PageSpecView |
| Sessions | /admin/sessions | 📋 PageSpecView |
| Payouts | /admin/payouts | 📋 PageSpecView |
| Moderation Queue | /admin/moderation | 📋 PageSpecView |
| Moderators | /admin/moderators | 📋 PageSpecView |
| Back to App | / | ✅ Active |

### External Links (new tab)

| Element | Target | Status |
|---------|--------|--------|
| View Profile | /@{handle} | ✅ Active (opens in new tab) |

### API Calls (triggered by interactions)

| Trigger | Endpoint | Method | Status |
|---------|----------|--------|--------|
| Page load / filter change | `/api/admin/users` | GET | ✅ Active |
| View Details click | `/api/admin/users/{id}` | GET | ✅ Active |
| Suspend click | `/api/admin/users/{id}/suspend` | POST | ✅ Active |
| Unsuspend click | `/api/admin/users/{id}/unsuspend` | POST | ✅ Active |
| Delete click | `/api/admin/users/{id}` | DELETE | ✅ Active |

### Target Pages Status

| Target | Page Code | Implemented |
|--------|-----------|-------------|
| /admin | ADMN | 📋 PageSpecView |
| /admin/users | AUSR | ✅ Yes (current) |
| /admin/courses | ACRS | ✅ Yes |
| /admin/categories | ACAT | ✅ Yes |
| /@{handle} | PROF | 📋 PageSpecView |
| / | HOME | ✅ Yes |

---

## Verification Notes

**Verified:** 2026-01-07 (Code + Visual + Interactive Elements)

**Consolidated:** 2026-01-08
- JSON spec updated to match verified implementation
- 4 discrepancies documented in JSON `_discrepancies` section

### Discrepancies Found

| Feature | Spec | Reality | Status |
|---------|------|---------|--------|
| Add User button | Should open modal | Shows TODO alert | ⚠️ Placeholder |
| Bulk actions | Planned | Not implemented | ⏳ Deferred |
| Export users | Planned | Not implemented | ⏳ Deferred |
| Impersonate user | Planned | Not implemented | ⏳ Deferred |
| Analytics events | Not specified | None implemented | ℹ️ Not planned |

### Components Verified

| Component | File | Status |
|-----------|------|--------|
| UsersAdmin | `src/components/admin/UsersAdmin.tsx` | ⚠️ Has 1 TODO |
| users.astro | `src/pages/admin/users.astro` | ✅ Clean |

### Interactive Elements Summary

| Category | Count | Active | Inactive |
|----------|-------|--------|----------|
| Buttons (onClick) | 12 | 11 | 1 (Add User) |
| Filter Controls | 3 | 3 | 0 |
| Sorting Controls | 3 | 3 | 0 |
| Pagination Controls | 4 | 4 | 0 |
| Admin Sidebar Links | 10 | 10 | 0 |
| External Links | 1 | 1 | 0 |
| API Endpoints | 5 | 5 | 0 |
| Analytics Events | 0 | 0 | 0 |

**Notes:**
- Add User button is placeholder (shows TODO alert)
- All core admin functionality is working (list, filter, sort, detail, actions)
- Suspend prompts for reason via browser prompt (could be improved with modal)
- Categories link now visible in sidebar (fixed earlier)

### Screenshots

| File | Date | Description |
|------|------|-------------|
| `AUSR-2026-01-07-05-45-03.png` | 2026-01-07 | User list view with filters |
| `AUSR-2026-01-07-05-45-38.png` | 2026-01-07 | User detail panel |
