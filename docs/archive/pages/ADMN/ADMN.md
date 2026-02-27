# ADMN - Admin Dashboard

| Field | Value |
|-------|-------|
| Route | `/admin` |
| Access | Authenticated (Admin role) |
| Priority | P0 |
| Status | ✅ Implemented |
| Block | 8 |
| JSON Spec | `src/data/pages/admin/index.json` |
| Astro Page | `src/pages/admin/index.astro` |
| Component | `src/components/admin/AdminDashboard.tsx` |

---

## Purpose

Platform administration hub with overview metrics, alerts, quick actions, and recent activity. Central entry point for admin navigation.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-A001 | As an Admin, I need to access admin dashboard so that I can manage the platform | P0 | ✅ |
| US-A002 | As an Admin, I need to view platform metrics so that I can track health | P0 | ✅ |
| US-A003 | As an Admin, I need quick access to admin sections so that I can work efficiently | P0 | ✅ |
| US-A004 | As an Admin, I need to view recent activity so that I can monitor platform usage | P1 | ✅ |

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| LGIN | Successful login (Admin) | Default for admins |
| Nav | "Admin" link | Admin navigation |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| AUSR | Users stat card or quick action | User management |
| ACRS | Courses stat card or quick action | Course management |
| AENR | Enrollments stat card or quick action | Enrollment management |
| ASTC | Student-Teachers stat card or quick action | S-T management |
| ACAT | Categories quick action | Category management |
| MODQ | Moderation Queue quick action | Content moderation |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| users | count, suspended_at, created_at | User metrics |
| courses | count, is_active, badge | Course metrics |
| enrollments | count, status, enrolled_at | Enrollment metrics |
| student_teachers | count, is_active | S-T metrics |
| transactions | sum(amount_cents), status | Revenue metrics |

---

## Features

### Key Metrics Cards
- [x] Total users with active count `[US-A002]`
- [x] New users this week count `[US-A002]`
- [x] Total courses with published count `[US-A002]`
- [x] Enrollments with active count `[US-A002]`
- [x] New enrollments this week `[US-A002]`
- [x] Revenue total and monthly `[US-A002]`

### Secondary Metrics
- [x] Student-Teachers with active/pending counts `[US-A002]`
- [x] Featured courses count `[US-A002]`
- [x] Completed courses with completion rate `[US-A002]`

### Alerts Section
- [x] Suspended users alert `[US-A001]`
- [x] Draft courses alert `[US-A001]`
- [x] Pending S-T alert `[US-A001]`
- [x] Alert links to filtered views `[US-A001]`
- [x] Empty state when no alerts `[US-A001]`

### Quick Actions
- [x] View Users link `[US-A003]`
- [x] View Courses link `[US-A003]`
- [x] View Enrollments link `[US-A003]`
- [x] Manage Categories link `[US-A003]`
- [x] Student-Teachers link `[US-A003]`
- [x] Moderation Queue link `[US-A003]`

### Recent Activity
- [x] New enrollments feed `[US-A004]`
- [x] New users feed `[US-A004]`
- [x] Activity icons by type `[US-A004]`
- [x] Relative timestamps `[US-A004]`
- [x] Links to detail views `[US-A004]`

### Loading & Error States
- [x] Loading skeleton
- [x] Error display with retry
- [x] Refresh button

---

## Sections

### Page Header
- Dashboard title and subtitle
- Refresh button

### Key Metrics Grid (4 columns)
- Users card: total, active, new this week
- Courses card: total, published
- Enrollments card: total, active, new this week
- Revenue card: total, this month

### Secondary Metrics Grid (3 columns)
- Student-Teachers card: total, active, pending
- Featured Courses card: count of published
- Completed Courses card: count, completion rate

### Alerts Section
- Warning/info alert cards
- Links to filtered admin pages
- Empty state when no alerts

### Quick Actions
- Grid of 6 action tiles with icons
- Links to admin sections

### Recent Activity
- Activity feed with icons
- Relative timestamps
- Links to detail views

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/admin/dashboard` | GET | Aggregated metrics, alerts, and activity | ✅ |

**Dashboard Response:**
```typescript
GET /api/admin/dashboard
{
  stats: {
    users: { total, active, suspended, newThisWeek },
    courses: { total, published, draft, featured },
    enrollments: { total, active, completed, newThisWeek },
    studentTeachers: { total, active, pending },
    revenue: { totalRevenue, thisMonth, pendingPayouts }
  },
  alerts: Alert[],      // Dynamic based on data state
  recentActivity: RecentActivity[]  // Last 10 enrollments/users
}
```

---

## States & Variations

| State | Description |
|-------|-------------|
| Loading | Skeleton placeholders while fetching data |
| Loaded | All metrics and activity displayed |
| Error | Error message with retry button |
| With Alerts | Alert cards visible for pending items |
| No Alerts | Empty state in alerts section |

---

## Error Handling

| Error | Display |
|-------|---------|
| API fetch fails | Error card with message and retry button |
| Unauthorized | Redirect to login |

---

## Interactive Elements

### Buttons (onClick handlers)

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| Refresh | AdminDashboard | Reloads page | ✅ Active |
| Retry (error) | AdminDashboard | Reloads page | ✅ Active |

### Links - Stat Cards

| Element | Target | Status |
|---------|--------|--------|
| Total Users | /admin/users | ✅ Active |
| Total Courses | /admin/courses | ✅ Active |
| Enrollments | /admin/enrollments | ✅ Active |
| Student-Teachers | /admin/student-teachers | ✅ Active |
| Featured Courses | /admin/courses?featured=true | ✅ Active |
| Completed Courses | /admin/enrollments?status=completed | ✅ Active |

### Links - Quick Actions

| Element | Target | Status |
|---------|--------|--------|
| View Users | /admin/users | ✅ Active |
| View Courses | /admin/courses | ✅ Active |
| View Enrollments | /admin/enrollments | ✅ Active |
| Manage Categories | /admin/categories | ✅ Active |
| Student-Teachers | /admin/student-teachers | ✅ Active |
| Moderation Queue | /mod | ✅ Active |

### Target Pages Status

| Target | Page Code | Implemented |
|--------|-----------|-------------|
| /admin/users | AUSR | ✅ Yes |
| /admin/courses | ACRS | ✅ Yes |
| /admin/enrollments | AENR | ✅ Yes |
| /admin/categories | ACAT | ✅ Yes |
| /admin/student-teachers | ASTC | ✅ Yes |
| /mod | MODQ | 📋 PageSpecView |

### Analytics Events

| Event | Status |
|-------|--------|
| page_view | ❌ Not implemented |
| admin_refresh | ❌ Not implemented |

---

## Implementation Notes

- Primary desktop-focused admin interface
- Uses AdminLayout with sidebar navigation
- Metrics aggregated server-side for performance
- Revenue calculated from transactions table (amount_cents)
- Alerts dynamically generated based on data state
- REST API fallback works on MBA-2017

---

## Verification Notes

**Verified:** 2026-01-08 (Code + Visual + Interactive Elements)

**Consolidated:** 2026-01-08
- JSON spec updated to match verified implementation
- 1 discrepancy documented in JSON `_discrepancies` section (analytics events)

### Components Verified

| Component | File | Status |
|-----------|------|--------|
| AdminDashboard | src/components/admin/AdminDashboard.tsx | ✅ No TODOs |
| index.astro | src/pages/admin/index.astro | ✅ Clean |

### Interactive Elements Summary

| Category | Count | Active | Inactive |
|----------|-------|--------|----------|
| Buttons (onClick) | 2 | 2 | 0 |
| Internal Links | 12 | 12 | 0 |
| External Links | 0 | 0 | 0 |
| Dynamic Links | 0 | 0 | 0 |
| Analytics Events | 2 | 0 | 2 |

**Notes:**
- All navigation links work correctly
- Analytics events not yet implemented
- /mod page uses PageSpecView placeholder

### Screenshots

| File | Date | Description |
|------|------|-------------|
| ADMN-2026-01-08-13-21-54.png | 2026-01-08 | Full dashboard with metrics, alerts, quick actions, activity |
