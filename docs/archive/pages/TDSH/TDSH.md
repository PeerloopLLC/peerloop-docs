# TDSH - Student-Teacher Dashboard

**Route:** `/dashboard/teaching`
**Status:** Implemented
**Block:** 7

## Overview

Central hub for Student-Teachers to manage their teaching schedule, track earnings, view their students, and handle teaching-related tasks.

## Implementation

### Files

| Type | Path |
|------|------|
| Astro Page | `src/pages/dashboard/teaching/index.astro` |
| React Component | `src/components/dashboard/TeacherDashboard.tsx` |
| API Endpoint | `src/pages/api/me/teacher-dashboard.ts` |
| Page Spec (JSON) | `src/data/pages/dashboard/teaching/index.json` |

### Features

- [x] Header with greeting and quick stats
- [x] Availability toggle (for "Summon Help" system)
- [x] Earnings overview (pending, this month, total)
- [x] Request payout button (enabled when above threshold)
- [x] Upcoming sessions list (next 5)
- [x] "Join Now" button for sessions starting soon
- [x] My students list grouped by course
- [x] Student progress indicators
- [x] Pending actions section (cert recommendations, intro requests, homework reviews)
- [x] Teaching certifications list
- [x] Quick actions navigation
- [ ] Availability Quick View (weekly calendar) *(Not implemented - links to /settings instead)*
- [ ] Analytics events *(Not implemented)*

### Sections

| Section | Status | Notes |
|---------|--------|-------|
| Header Bar | ✅ | Greeting, availability toggle, quick stats |
| Quick Stats | ✅ | Sessions This Month, Average Rating, Students Helped |
| Earnings Overview | ✅ | Pending, This Month, Total, View Details, Request Payout |
| Upcoming Sessions | ✅ | Shows next sessions with student info, times |
| Pending Actions | ✅ | Cert recommendations, intro requests, homework reviews |
| My Students | ✅ | Grouped by course, progress bars, empty state |
| My Certifications | ✅ | Course name, date, students taught, active status |
| Quick Actions | ✅ | My Students, Session History, Edit Availability |
| Availability Quick View | ❌ | Not implemented - spec called for weekly calendar |

### API Response

```typescript
{
  user: {
    name: string;
    is_available: boolean;
  };
  stats: {
    total_students: number;
    sessions_this_week: number;
    sessions_completed_month: number;
    average_rating: number | null;
    students_helped_total: number;
  };
  earnings: {
    pending_balance: number;
    total_earned: number;
    this_month: number;
    payout_threshold: number;
  };
  pending_counts: {
    cert_recommendations: number;
    intro_requests: number;
    homework_reviews: number;
  };
  certifications: Certification[];
  upcoming_sessions: Session[];
  students: Student[];
}
```

### Database Tables Used

- `student_teachers` - ST certifications per course
- `sessions` - Upcoming teaching sessions
- `session_assessments` - Average rating calculation
- `enrollments` - Students assigned to this ST
- `module_progress` - Student progress calculation
- `payment_splits` - Earnings (recipient_type = 'student_teacher')
- `user_availability` - "Available for Summon" status
- `homework_submissions` - Pending reviews
- `intro_sessions` - Pending intro requests
- `certificates` - Pending cert recommendations

### Access Control

- Requires authentication
- Requires at least one `student_teachers` record (ST certification)

## Interactive Elements

### Buttons (with onClick handlers)

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| Availability toggle | TeacherDashboard | Toggle is_available status | ⚠️ Visual only (no API call) |
| Request Payout | TeacherDashboard | Request payout | ⚠️ Visual only (no API call) |
| Retry (error state) | TeacherDashboard | Re-fetch dashboard data | ✅ Active |

### Links - Navigation

| Element | Target | Status |
|---------|--------|--------|
| View Profile | `/teachers/me` | ⚠️ Uses `/me` but page expects `[handle]` |
| View Details (Earnings) | `/dashboard/teaching/earnings` | ✅ Active |
| View All (Sessions) | `/dashboard/teaching/sessions` | ✅ Active |
| Review (Pending Actions) | `/dashboard/teaching/students` or `/dashboard/teaching/sessions` | ✅ Active |
| View All (Students) | `/dashboard/teaching/students` | ✅ Active |
| My Students (Quick Action) | `/dashboard/teaching/students` | ✅ Active |
| Session History (Quick Action) | `/dashboard/teaching/sessions` | ✅ Active |
| Edit Availability (Quick Action) | `/settings` | ✅ Active |
| Join Now (Session) | `/session/[id]` | ✅ Active (conditional) |

### Target Pages Status

| Target | Page Code | Implemented |
|--------|-----------|-------------|
| `/dashboard/teaching/earnings` | CEAR | 📋 PageSpecView |
| `/dashboard/teaching/sessions` | CSES | 📋 PageSpecView |
| `/dashboard/teaching/students` | CMST | 📋 PageSpecView |
| `/session/[id]` | SROM | 📋 PageSpecView |
| `/teachers/me` | - | ❌ Missing (needs handle) |
| `/settings` | SETT | 📋 PageSpecView |

### Analytics Events (from spec)

| Event | Trigger | Status |
|-------|---------|--------|
| `page_view` | Page load | ❌ Not implemented |
| `join_session` | Join clicked | ❌ Not implemented |
| `recommend_cert` | Recommend clicked | ❌ Not implemented |
| `view_earnings` | Earnings detail clicked | ❌ Not implemented |
| `request_payout` | Payout clicked | ❌ Not implemented |

## Related Pages

- **CMST** - My Students (detailed view)
- **CSES** - Session History
- **CEAR** - Earnings Detail
- **SDSH** - Student Dashboard (if user is also a student)

---

## Verification Notes

**Verified:** 2026-01-08 (Code + Visual + Interactive Elements)

### Discrepancies Found

| Feature | Spec | Reality | Status |
|---------|------|---------|--------|
| Availability Quick View | Weekly calendar | Not implemented | ❌ |
| Availability toggle | Should update via API | Visual only | ⚠️ |
| Request Payout button | Should call payout API | Visual only | ⚠️ |
| View Profile link | Should go to `/teachers/[handle]` | Goes to `/teachers/me` (404) | ⚠️ |
| Analytics events | 5 events specified | None implemented | ❌ |

### Data Observations

- **Earnings:** Total Earned shows $174.30 (from paid payment_split)
- **Pending Balance:** $0.00 (no pending splits in current month)
- **This Month:** $0.00 (no earnings in current month - data is dated 2024)
- **Sessions:** 2 upcoming with Jennifer Kim
- **Pending Actions:** 1 intro session request (from seed data)
- **My Students:** Jennifer Kim (Intro to Claude Code, 0% progress)
- **Certifications:** 1 (AI Tools Overview, active, 8 students taught)

### Components Verified

| Component | File | Status |
|-----------|------|--------|
| TeacherDashboard | `src/components/dashboard/TeacherDashboard.tsx` | ✅ No TODOs |
| StatCard | (internal) | ✅ Clean |
| SessionCard | (internal) | ✅ Clean |
| StudentCard | (internal) | ✅ Clean |
| QuickActionButton | (internal) | ✅ Clean |

### Interactive Elements Summary

| Category | Count | Active | Inactive |
|----------|-------|--------|----------|
| Buttons (onClick) | 3 | 1 | 2 |
| Internal Links | 9 | 8 | 1 |
| Dynamic Links | 1 | 1 | 0 |
| Analytics Events | 5 | 0 | 5 |

**Notes:**
- `/teachers/me` link needs to be changed to use the user's actual handle
- Availability toggle and Request Payout button need API integration
- Analytics events should be added when PostHog is integrated

### Screenshots

| File | Date | Description |
|------|------|-------------|
| `TDSH-2026-01-08-18-02-47.png` | 2026-01-08 | Initial verification (My Students empty - bug) |
| `TDSH-2026-01-08-18-15-37.png` | 2026-01-08 | After fix: Jennifer Kim appears in My Students |
