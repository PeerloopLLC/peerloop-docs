# AENR - Admin Enrollments

| Field | Value |
|-------|-------|
| Route | `/admin/enrollments` |
| Access | Authenticated (Admin role) |
| Priority | P0 |
| Status | ✅ Implemented |
| Block | 8 |
| JSON Spec | `src/data/pages/admin/enrollments.json` |
| Astro Page | `src/pages/admin/enrollments.astro` |
| Component | `src/components/admin/EnrollmentsAdmin.tsx` |

---

## Purpose

CRUD interface for managing enrollments - view, create manual enrollments, cancel, issue refunds, and reassign Student-Teachers.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-A005 | As an Admin, I need to manage enrollments so that I can handle enrollment issues | P1 | ⏳ |
| US-A008 | As an Admin, I need to create manual/comp enrollments so that I can onboard special cases | P1 | ⏳ |
| US-A009 | As an Admin, I need to process refunds so that I can handle cancellations | P0 | ⏳ |
| US-A010 | As an Admin, I need to reassign S-Ts so that I can handle ST issues | P1 | ⏳ |

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| ADMN | "Enrollments" nav item | Admin sidebar |
| AUSR | "View Enrollments" on user | Filtered to user |
| ACRS | "View Enrollments" on course | Filtered to course |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| AUSR | Student/ST name click | View user |
| ACRS | Course name click | View course |
| ASES | "View Sessions" | Filtered to enrollment |
| APAY | "View Transactions" | Related payments |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| enrollments | All fields | Enrollment records |
| users (students) | id, name, email | Student info |
| users (STs) | id, name | Assigned ST |
| courses | id, title, price_cents | Course info |
| transactions | enrollment_id, amount_cents, status | Payment info |
| sessions | enrollment_id, count | Session stats |
| module_progress | enrollment_id | Progress data |

---

## Features

### Viewing & Browsing
- [x] Enrollment listing with sortable columns `[US-A005]`
- [x] Search by student name/email, course title `[US-A005]`
- [x] Filter by course `[US-A005]`
- [x] Filter by status (enrolled/in_progress/completed/cancelled) `[US-A005]`
- [x] Filter by ST assigned/unassigned `[US-A005]`
- [ ] Filter by date range `[US-A005]` *(Not implemented)*
- [x] Pagination controls `[US-A005]`
- [x] Enrollment detail slide-in panel `[US-A005]`
- [x] Stats cards (Total, Active, Completed, Cancelled) *(Not in original spec)*

### Enrollment Actions
- [ ] Create manual/comp enrollment `[US-A008]` *(UI button exists, shows TODO alert)*
- [x] Reassign ST `[US-A010]`
- [x] Cancel enrollment with reason `[US-A009]`
- [x] Full refund (Stripe) `[US-A009]`
- [x] Partial refund (Stripe) `[US-A009]` *(Needs testing + business rules - see note below)*
- [x] Force complete (override) `[US-A005]`
- [ ] Extend access `[US-A005]` *(Not implemented)*

> **Refund UX Consideration:** Current implementation has separate "Full Refund" and "Partial Refund" buttons where admin manually enters amount. A better approach may be:
> - Single "Refund" button
> - Opens modal showing calculated refund amount based on business rules
> - Criteria to define: % of sessions attended, time since enrollment, modules completed, etc.
> - Admin can override calculated amount if needed
> - Requires business decision on refund policy before implementation

### Notifications (requires email integration)
- [ ] Send refund confirmation email to student `[US-A009]` *(After Resend integration)*
- [ ] Send cancellation email to student *(After Resend integration)*
- [ ] Notify old/new ST on reassignment *(After Resend integration)*

### Export
- [ ] Export enrollments (CSV) `[US-A005]` *(Not implemented)*

---

## Sections (from Plan)

### Header
- Screen title: "Enrollment Management"
- "Create Enrollment" button
- Export button

### Enrollments Table

| Column | Content | Implemented |
|--------|---------|-------------|
| Student | Name + email + avatar | ✅ |
| Course | Course title + thumbnail | ✅ |
| ST | Assigned ST name (or "Unassigned") | ✅ |
| Progress | Progress bar with % | ✅ |
| Status | Enrolled / In Progress / Completed / Cancelled | ✅ |
| Enrolled | Date (sortable) | ✅ |
| Actions | View, Force Complete, Cancel | ✅ |
| Sessions | Completed / Scheduled | ❌ Not implemented |
| Payment | Paid / Refunded | ❌ Not implemented |

### Enrollment Detail Panel

**View Mode:**
- Full enrollment info
- Student info (link to AUSR)
- Course info (link to ACRS)
- Assigned ST (link to AUSR)
- Progress breakdown (modules, sessions, last activity)
- Payment details (transaction ID, amount, refund status)
- Timeline (enrolled, first session, last activity, completed)

**Edit Mode:**
- Reassign ST (dropdown)
- Status change (with reason)
- Admin notes

### Create Enrollment Modal
- Select student (search)
- Select course
- Assign ST (optional)
- Payment status (paid/comp/waived)
- Reason (for comp enrollments)
- Send notification toggle

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/admin/enrollments` | GET | Paginated, filterable list | ✅ |
| `/api/admin/enrollments` | POST | Create manual/comp enrollment | ✅ |
| `/api/admin/enrollments/:id` | GET | Full enrollment data | ✅ |
| `/api/admin/enrollments/:id` | PATCH | Update enrollment | ✅ |
| `/api/admin/enrollments/:id` | DELETE | Soft delete | ✅ |
| `/api/admin/enrollments/:id/reassign-st` | POST | Change ST | ✅ |
| `/api/admin/enrollments/:id/cancel` | POST | Cancel enrollment | ✅ |
| `/api/admin/enrollments/:id/refund` | POST | Process refund (Stripe) | ✅ |
| `/api/admin/enrollments/:id/force-complete` | POST | Override complete | ✅ |
| `/api/admin/enrollments/export` | GET | CSV export | ⏳ |

**Query Parameters:**
- `q` - Search student name/email, course title
- `course_id` - Filter by course
- `status` - active, completed, cancelled
- `st_assigned` - true/false
- `from`, `to` - Date range
- `page`, `limit` - Pagination

**Create Enrollment:**
```typescript
POST /api/admin/enrollments
{
  user_id: string,
  course_id: string,
  st_id?: string,
  payment_status: 'paid' | 'comp' | 'waived',
  reason?: string,
  notify: boolean
}
```

**Refund:**
```typescript
POST /api/admin/enrollments/:id/refund
{
  amount?: number,  // cents, optional for partial
  reason: string
}
// Triggers Stripe refund
```

---

## States & Variations

| State | Description |
|-------|-------------|
| List | Default enrollment list |
| Filtered | By user, course, status |
| Detail | Enrollment panel open |
| Creating | New enrollment form |
| Refunding | Refund confirmation flow |

---

## Error Handling

| Error | Display |
|-------|---------|
| Load fails | "Unable to load enrollments. [Retry]" |
| Refund fails | "Refund failed. Check Stripe." |
| No STs available | "No Student-Teachers available for this course" |

---

## Implementation Notes

- Comp enrollments: Admin can enroll without payment
- Refunds go through Stripe
- ST reassignment should notify both old and new ST
- Uses shared admin components (AdminDataTable, AdminFilterBar, AdminDetailPanel)

---

## Interactive Elements

### Buttons (with onClick handlers)

| Element | Location | Action | Status |
|---------|----------|--------|--------|
| Create Enrollment | Header | Shows TODO alert | ❌ Placeholder |
| Retry | Error state | Refetches enrollments | ✅ Active |
| View Details | Row actions | Opens detail panel | ✅ Active |
| View Course | Row actions | Opens course page in new tab | ✅ Active |
| Force Complete | Row actions | Marks enrollment complete | ✅ Active |
| Full Refund | Row actions | Processes full Stripe refund | ✅ Active |
| Partial Refund | Row actions | Processes partial Stripe refund | ✅ Active |
| Cancel (No Refund) | Row actions | Cancels without refund | ✅ Active |
| Force Complete | Detail panel footer | Marks enrollment complete | ✅ Active |
| Full Refund | Detail panel footer | Processes full Stripe refund | ✅ Active |
| Partial Refund | Detail panel footer | Processes partial Stripe refund | ✅ Active |
| Cancel (No Refund) | Detail panel footer | Cancels without refund | ✅ Active |
| ST Reassign dropdown | Detail panel | Reassigns ST on change | ✅ Active |

### Links (href)

| Element | Target | Type | Status |
|---------|--------|------|--------|
| Student profile | `/@{handle}` | Dynamic | ✅ Active |
| Course detail | `/courses/{slug}` | Dynamic | ✅ Active |
| ST profile | `/@{handle}` | Dynamic | ✅ Active |

### Target Pages Status

| Target | Page Code | Implemented |
|--------|-----------|-------------|
| `/@{handle}` | UPRO | 📋 PageSpecView |
| `/courses/{slug}` | CDET | ✅ Yes |

---

## Verification Notes

**Verified:** 2026-01-07 (Code + Visual + Interactive Elements)

**Consolidated:** 2026-01-08
- JSON spec updated to match verified implementation
- 6 discrepancies documented in JSON `_discrepancies` section

### Discrepancies Found

| Feature | Spec | Reality | Status |
|---------|------|---------|--------|
| Export button | In header | Missing | ❌ |
| Date range filter | Yes | Not implemented | ❌ |
| Sessions column | Yes | Not implemented | ❌ |
| Payment column | Yes | Not implemented | ❌ |
| Create Enrollment modal | Full modal | TODO alert | ⚠️ |
| ~~Refund actions~~ | ~~Stripe integration~~ | ~~Implemented~~ | ✅ |
| Extend access | Yes | Not implemented | ❌ |

### Components Verified

| Component | File | Status |
|-----------|------|--------|
| EnrollmentsAdmin | `src/components/admin/EnrollmentsAdmin.tsx` | ⚠️ 1 TODO |

### Interactive Elements Summary

| Category | Count | Active | Inactive |
|----------|-------|--------|----------|
| Buttons (onClick) | 13 | 12 | 1 |
| Internal Links | 0 | 0 | 0 |
| Dynamic Links | 3 | 3 | 0 |
| External Links | 0 | 0 | 0 |
| Analytics Events | 0 | 0 | 0 |

**Notes:**
- Create Enrollment button shows TODO alert (modal not implemented)
- All API endpoints are working except export
- Full and partial refunds via Stripe are fully functional
- Detail panel has full progress breakdown with module-level status
- ST reassignment dropdown populated from available STs for the course

### Screenshots

| File | Date | Description |
|------|------|-------------|
| `AENR-2026-01-07-18-02-30.png` | 2026-01-07 | Full page with 7 enrollments, Content View mode |
