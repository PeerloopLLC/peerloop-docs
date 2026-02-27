# CDSH - Creator Dashboard

| Field | Value |
|-------|-------|
| Route | `/dashboard/creator` |
| Access | Authenticated (Creator role) |
| Priority | P0 |
| Status | ✅ Implemented |
| Block | 8 |
| JSON Spec | `src/data/pages/dashboard/creator/index.json` |
| Astro Page | `src/pages/dashboard/creator/index.astro` |
| Component | `src/components/dashboard/CreatorDashboard.tsx` |

---

## Purpose

Central hub for Creators to manage their courses, track earnings, approve Student-Teachers, monitor course performance, and handle creator-specific workflows.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-P003 | As a Creator, I need a dashboard for course management | P0 | ✅ |
| US-C033 | As a Creator, I need to view course analytics | P1 | ⏳ *(basic stats only)* |
| US-P062 | As a Creator, I need to approve student certifications | P0 | ⏳ *(Block 6)* |
| US-P063 | As a Creator, I need to approve ST applications | P0 | ⏳ *(Block 7)* |
| US-C035 | As a Creator, I need to view earnings and royalties | P0 | ✅ |

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| LGIN | Successful login (Creator role) | Default post-login |
| Nav | "Dashboard" link | Global navigation |
| STUD | "Dashboard" link | From Creator Studio |
| CPRO | "Dashboard" link | From own profile |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| STUD | "Creator Studio" / "Manage Courses" | Course management |
| CPRO | "View Public Profile" | See public creator profile |
| CDET | Course card click | View course detail |
| CANA | "View Analytics" | Detailed analytics |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| courses | id, title, student_count, rating, is_active | Course list |
| enrollments | course_id, status | Enrollment counts |
| student_teachers | course_id, user_id, is_active | ST count |
| payment_splits | amount_cents, status (where creator) | Earnings |

---

## Features

### Earnings Overview
- [x] Royalty balance (pending 15%) `[US-C035]`
- [x] Total earned (lifetime) `[US-C035]`
- [x] This month earnings `[US-C035]`
- [x] "Request Payout" button `[US-C035]` *(UI only, not wired to API)*
- [x] "View Details" link

### Pending Approvals
- [ ] ST applications with approve/decline `[US-P063]` *(Block 7)*
- [ ] Certification requests with issue/decline `[US-P062]` *(Block 6)*
- [ ] Homework reviews with approve/request resubmit *(Block 3.5 enhancement)*
- [x] Badge count for pending items `[US-P003]`
- [x] Empty state: "No pending approvals"

### Course Performance
- [x] Course grid with stats `[US-C033]`
- [x] Active students per course `[US-C033]`
- [ ] Completion rate per course `[US-C033]` *(not shown)*
- [x] Rating per course `[US-C033]`
- [ ] Revenue per course `[US-C035]` *(not shown)*
- [ ] Sort by students/revenue/rating `[US-C033]`
- [x] View/Edit buttons per course
- [x] Active/Draft status badge

### Student-Teacher Overview
- [ ] List of STs certified for creator's courses `[US-P003]` *(Block 7)*
- [ ] Students taught count per ST `[US-P003]` *(Block 7)*

### Recent Activity
- [ ] Timeline of enrollments, completions, certifications `[US-P003]` *(future)*

### Quick Actions
- [x] "Create Course" button (header)
- [x] "Creator Studio" quick action
- [x] "Edit Profile" quick action
- [x] "View Analytics" quick action

---

## Sections (Implemented)

### Header Bar
- Greeting: "Welcome back, [First Name]!"
- Subtitle: "Here's how your courses are performing"
- "Create Course" button

### Quick Stats (3 cards)
- Total Courses (with icon)
- Total Students (with icon)
- Active Student-Teachers (with icon)

### Earnings Overview (card)
- Pending Balance, This Month, Total Earned
- Minimum payout threshold display
- "Request Payout" button (enabled when balance >= threshold)
- "View Details" link

### Pending Approvals (card)
- Badge with count when items pending
- Empty state with checkmark icon

### Your Courses (grid)
- Course cards with thumbnail placeholder
- Student count, rating display
- Active/Draft badge
- View/Edit action buttons
- "Manage All" link

### Quick Actions (card)
- Creator Studio, Edit Profile, View Analytics

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/me/creator-dashboard` | GET | Aggregated dashboard data | ✅ |
| `/api/creators/me/earnings` | GET | Detailed earnings breakdown | ⏳ |
| `/api/student-teachers/:id/approve` | POST | Approve ST application | ⏳ |
| `/api/certificates/:id/issue` | POST | Issue certification | ⏳ |
| `/api/payouts/request` | POST | Initiate payout | ⏳ |

**Dashboard Response:**
```typescript
GET /api/me/creator-dashboard
{
  user: { name: string },
  stats: {
    courses_count: number,
    total_students: number,
    active_st_count: number
  },
  earnings: {
    pending_balance: number,     // cents
    total_earned: number,
    this_month: number,
    payout_threshold: number
  },
  pending_counts: {
    st_applications: number,
    cert_requests: number,
    homework_reviews: number
  },
  courses: [{
    id, title, slug, thumbnail_url,
    is_active, student_count, rating, rating_count, price_cents
  }]
}
```

---

## States & Variations

| State | Description | Status |
|-------|-------------|--------|
| New Creator | No courses yet, prominent "Create Course" CTA | ✅ |
| Active Creator | Courses live, students enrolled | ✅ |
| Pending Actions | Badge on Pending Approvals | ✅ |
| Payout Available | Highlight royalty balance | ✅ |
| Loading | Skeleton animation | ✅ |
| Error | Retry button | ✅ |

---

## Error Handling

| Error | Display | Status |
|-------|---------|--------|
| Data load fails | "Unable to load dashboard. [Retry]" | ✅ |
| Approval fails | "Unable to process. Please try again." | ⏳ |

---

## Interactive Elements

### Buttons (onClick handlers)

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| Retry | CreatorDashboard | Refetch dashboard data | ✅ Active |
| Request Payout | CreatorDashboard | Request payout | ⚠️ UI only |

### Internal Links

| Element | Target | Status |
|---------|--------|--------|
| Create Course | /dashboard/creator/studio | 📋 PageSpecView |
| View Details (earnings) | /dashboard/creator/earnings | ❌ Missing |
| Manage All | /dashboard/creator/studio | 📋 PageSpecView |
| Creator Studio | /dashboard/creator/studio | 📋 PageSpecView |
| Edit Profile | /profile | 📋 PageSpecView |
| View Analytics | /dashboard/creator/analytics | 📋 PageSpecView |
| View (course) | /courses/[slug] | ✅ Implemented |
| Edit (course) | /dashboard/creator/studio/[id] | ❌ Missing |
| Create Your First Course | /dashboard/creator/studio | 📋 PageSpecView |

### Target Pages Status

| Target | Page Code | Status |
|--------|-----------|--------|
| /dashboard/creator/studio | STUD | 📋 PageSpecView |
| /dashboard/creator/earnings | - | ❌ Missing |
| /dashboard/creator/analytics | CANA | 📋 PageSpecView |
| /profile | PROF | 📋 PageSpecView |
| /courses/[slug] | CDET | ✅ Implemented |

---

## Implementation Notes

- CD-020: Creator gets 15% royalty
- Creators may also be Students/STs (multi-role dashboard)
- Email notifications for pending approvals via Resend (future)
- Payout requires active Stripe Connect (see SETT)
- Request Payout button shows UI but POST endpoint not implemented yet

---

## Verification Notes

**Verified:** 2026-01-08 (Code + Visual + Interactive Elements)

**Consolidated:** 2026-01-08
- JSON spec updated to match verified implementation
- 9 discrepancies documented in JSON `_discrepancies` section

### Discrepancies Found

| Feature | Spec | Reality | Status |
|---------|------|---------|--------|
| Completion rate | Per-course display | Not shown | ❌ |
| Revenue per course | Per-course display | Not shown | ❌ |
| Sort courses | By students/revenue/rating | Not implemented | ❌ |
| ST Overview | List of STs | Not implemented (Block 7) | ⏳ |
| Recent Activity | Timeline | Not implemented | ⏳ |
| Request Payout | POST /api/payouts/request | UI only, not wired | ⚠️ |

### Components Verified

| Component | File | Status |
|-----------|------|--------|
| CreatorDashboard | src/components/dashboard/CreatorDashboard.tsx | ⚠️ Has placeholders |

**Markers found:**
- Line 8: "Pending approvals (placeholder for future blocks)"
- Line 246: "Future: List of pending items"

### Interactive Elements Summary

| Category | Count | Active | Inactive |
|----------|-------|--------|----------|
| Buttons (onClick) | 2 | 1 | 1 |
| Internal Links | 9 | 1 | 8 |
| Dynamic Links | 2 | 1 | 1 |
| Analytics Events | 0 | 0 | 0 |

**Notes:**
- `/dashboard/creator/earnings` page doesn't exist - link broken
- `/dashboard/creator/studio/[id]` dynamic route doesn't exist
- Request Payout button shows but doesn't call API
- 8 links point to PageSpecView placeholder pages

### Screenshots

| File | Date | Description |
|------|------|-------------|
| `CDSH-2026-01-08-16-34-18.png` | 2026-01-08 | Full page showing all sections, Guy Rymberg logged in with 4 courses |
