# SDSH - Student Dashboard

| Field | Value |
|-------|-------|
| Route | `/dashboard/learning` |
| Access | Authenticated (Student role) |
| Priority | P0 |
| Status | ✅ Implemented |
| Block | 2 |
| Astro Page | `src/pages/dashboard/learning/index.astro` |
| Component | `src/components/dashboard/StudentDashboard.tsx` |
| JSON Spec | `src/data/pages/dashboard/learning/index.json` |

---

## Purpose

Central hub for students to track their enrolled courses, upcoming sessions, learning progress, and quickly access key actions.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-S009 | As a student, I want to access a personalized dashboard so that I can see my learning at a glance | P0 | ✅ |
| US-P003 | As a user, I want to view enrolled courses and progress so that I can track my learning | P0 | ✅ |
| US-P060 | As a student, I want to see upcoming sessions on my dashboard so that I don't miss appointments | P0 | ⏳ |

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| LGIN | Successful login (Student role) | Default post-login destination |
| SGUP | Successful signup | After onboarding |
| Nav | "Dashboard" link | Global navigation |
| SROM | "Back to Dashboard" | After session ends |
| CCNT | "Dashboard" link | From course content |
| Any page | Logo click (logged in) | May go to dashboard |

### Outgoing (users navigate to)

| Target | Trigger | Notes | Status |
|--------|---------|-------|--------|
| CCNT | "Continue Learning" on course card | Resume course content | ✅ |
| SBOK | "Book Session" / "Schedule" | Book next session | ⏳ |
| SROM | "Join Session" | Active session join | ⏳ |
| CDET | Course title click | View course details | ✅ |
| FEED | "Community" nav | Go to feed | ⏳ |
| CBRO | "Browse Courses" | Find new courses | ✅ |
| PROF | "Profile" nav | Edit profile | ✅ |
| STPR | "Your Teacher" link | View assigned ST | ⏳ |
| NOTF | Notification bell | View all notifications | ⏳ |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| enrollments | id, course_id, student_teacher_id, status, enrolled_at | Enrolled courses list |
| courses | id, title, thumbnail, slug | Course display |
| module_progress | enrollment_id, is_complete | Progress calculation |
| course_curriculum | id, course_id | Total modules for progress |
| sessions | id, scheduled_start, status, teacher_id | Upcoming sessions |
| certificates | id, type, course_id, issued_at | Earned certificates |
| users (ST) | name, avatar | Assigned teacher display |
| notifications | count where is_read = false | Notification badge |

---

## Features

### Course Display
- [x] Enrolled courses grid `[US-S009]`
- [x] Progress bars (% complete) `[US-P003]`
- [x] Continue learning CTA `[US-S009]`
- [x] Status grouping (in progress, completed) `[US-P003]`
- [x] Empty state (no enrollments) `[US-S009]`

### Sessions (Pending)
- [ ] Upcoming sessions list `[US-P060]`
- [ ] Join session button (active if within 15 min) `[US-P060]`
- [ ] Session countdown `[US-P060]`
- [ ] Reschedule link `[US-P060]`

### Additional Features (Pending)
- [ ] Greeting with user name `[US-S009]`
- [ ] Notification bell with unread count `[US-S009]`
- [ ] Quick stats (courses, sessions) `[US-S009]`
- [ ] Recent activity timeline `[US-S009]`
- [ ] Certificates & achievements grid `[US-S009]`
- [ ] Assigned ST display `[US-P003]`

---

## Sections

### Header Bar
- Greeting: "Welcome back, [Name]!"
- Notification bell with unread count → NOTF
- Quick stats: X courses, Y upcoming sessions

### Upcoming Sessions
- **Priority section** - shows next 3 sessions
- Each session card:
  - Date/time (with countdown if within 24h)
  - Course title
  - Teacher name + avatar
  - "Join" button (active if within 15 min of start) → SROM
  - "Reschedule" link → SBOK
- "View All Sessions" → separate sessions view or modal
- Empty state: "No sessions scheduled. [Book one now]"

### My Courses (Enrolled)
- Grid or list of enrolled courses
- Each course card:
  - Thumbnail
  - Title (clickable → CDET)
  - Progress bar (% complete)
  - "Continue Learning" → CCNT
  - "Book Session" → SBOK
  - Assigned ST avatar + name
- Empty state: "You haven't enrolled in any courses. [Browse courses]"

### Recent Activity
- Timeline of recent actions:
  - Module completions
  - Session completions
  - Certificates earned
- Last 5-10 items

### Certificates & Achievements
- Grid of earned certificates
- Each shows:
  - Certificate type badge
  - Course name
  - Date earned
  - "View" to see/download certificate
- "Become a Student-Teacher" CTA if eligible

### Quick Actions
- "Browse Courses" → CBRO
- "View Certificates" → section anchor or separate page
- "Update Profile" → PROF

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/users/me` | GET | Current user profile | ✅ |
| `/api/enrollments` | GET | Enrolled courses with progress | ✅ |
| `/api/sessions?upcoming=true&limit=3` | GET | Next 3 upcoming sessions | ⏳ |
| `/api/certificates` | GET | Earned certificates | ⏳ |
| `/api/notifications/count` | GET | Unread notification count | ⏳ |
| `/api/activity?limit=10` | GET | Recent activity timeline | ⏳ |

**Enrollments Response:**
```typescript
GET /api/enrollments
{
  enrollments: [{
    id, course_id, status, enrolled_at,
    course: { id, title, slug, thumbnail },
    student_teacher: { id, name, avatar },
    progress: { completed: number, total: number, percent: number }
  }]
}
```

**Sessions Response:**
```typescript
GET /api/sessions?upcoming=true&limit=3
{
  sessions: [{
    id, scheduled_start, status,
    course: { id, title },
    teacher: { id, name, avatar },
    can_join: boolean  // true if within 15 min of start
  }]
}
```

---

## States & Variations

| State | Description | Status |
|-------|-------------|--------|
| New User | No courses, prominent "Browse Courses" CTA | ✅ |
| Active Student | Courses in progress, sessions scheduled | ✅ |
| Session Starting | "Join Now" prominently displayed | ⏳ |
| Course Complete | "Congratulations" banner, ST path CTA | ⏳ |
| Multi-Role | May show tabs/sections for other roles | ⏳ |

---

## Error Handling

| Error | Display |
|-------|---------|
| Data load fails | "Unable to load dashboard. [Retry]" |
| Session join fails | "Unable to join session. [Try again]" |

---

## Mobile Considerations

- Sessions section at top (most time-sensitive)
- Course cards stack vertically
- Sticky "Join Session" button if session imminent
- Bottom navigation bar

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `page_view` | Page load | courses_count, sessions_count |
| `continue_learning` | Continue clicked | course_id, progress_pct |
| `book_session` | Book clicked | course_id |
| `join_session` | Join clicked | session_id |
| `browse_courses` | Browse clicked | from_empty_state |

---

## Implementation Notes

- Requires authentication
- Progress calculated from `module_progress` table
- Links to course learning page
- Consider real-time session countdown
- Push notifications for session reminders
- Multi-role users: Dashboard adapts (see TDSH)
- CD-033: "Schedule Later" option should be visible in booking flow

---

## Interactive Elements

### Buttons (with onClick handlers)

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| "Retry" button | StudentDashboard | Retries API fetch | ✅ Active |

### Links - Empty State

| Element | Target | Status |
|---------|--------|--------|
| "Browse Courses" | /courses | ✅ Active |

### Links - Enrollment Cards

| Element | Target | Status |
|---------|--------|--------|
| "Continue" button | /courses/{slug}/learn | ✅ Active |
| "Review" button (completed) | /courses/{slug}/learn | ✅ Active |
| "Book Session" button | /courses/{slug}/book | ✅ Active |

### Links - Sidebar (via AppLayout)

| Element | Target | Status |
|---------|--------|--------|
| Dashboard | /dashboard/learning | ✅ Active |
| My Courses | /dashboard/courses | ✅ Active |
| Sessions | /dashboard/sessions | ✅ Active |
| Community | /dashboard/community | ✅ Active |
| Settings | /settings | ✅ Active |

### Links - Header (via AppLayout)

| Element | Target | Status |
|---------|--------|--------|
| Peerloop logo | / | ✅ Active |
| Notification bell | - | ⚠️ Visual only |
| User dropdown | Profile menu | ✅ Active |

### Links - Breadcrumb

| Element | Target | Status |
|---------|--------|--------|
| Dashboard | /dashboard/learning | ✅ Active |

### API Calls (triggered by interactions)

| Trigger | Endpoint | Method | Status |
|---------|----------|--------|--------|
| Page load | `/api/me/enrollments` | GET | ✅ Active |

### Target Pages Status

| Target | Page Code | Implemented |
|--------|-----------|-------------|
| / | HOME | ✅ Yes |
| /courses | CBRO | ✅ Yes |
| /courses/{slug}/learn | CCNT | ✅ Yes |
| /courses/{slug}/book | SBOK | 📋 PageSpecView |
| /dashboard/courses | - | 📋 Not implemented |
| /dashboard/sessions | - | 📋 Not implemented |
| /dashboard/community | FEED | 📋 PageSpecView |
| /settings | PROF | ✅ Yes |

---

## Verification Notes

**Verified:** 2026-01-07 (Code + Visual + Interactive Elements)

**Consolidated:** 2026-01-08
- JSON spec updated to match verified implementation
- 7 discrepancies documented in JSON `_discrepancies` section

### Discrepancies Found

| Feature | Spec | Reality | Status |
|---------|------|---------|--------|
| Greeting with user name | Planned | Not implemented | ⏳ Deferred |
| Notification bell functionality | Planned | Visual only (with dot) | ⚠️ Partial |
| Quick stats | Planned | Not implemented | ⏳ Deferred |
| Upcoming sessions list | Planned | Not implemented | ⏳ Deferred |
| Recent activity timeline | Planned | Not implemented | ⏳ Deferred |
| Certificates section | Planned | Not implemented | ⏳ Deferred |
| Assigned ST display | Planned | ✅ Implemented in cards | ✅ Done |
| Analytics events | 5 events specified | None implemented | ❌ Not implemented |

### Components Verified

| Component | File | Status |
|-----------|------|--------|
| StudentDashboard | `src/components/dashboard/StudentDashboard.tsx` | ✅ No TODOs |
| index.astro | `src/pages/dashboard/learning/index.astro` | ✅ Clean |

### Interactive Elements Summary

| Category | Count | Active | Inactive |
|----------|-------|--------|----------|
| Buttons (onClick) | 1 | 1 | 0 |
| Empty State Links | 1 | 1 | 0 |
| Card Action Links | 3 | 3 | 0 |
| Sidebar Links | 5 | 5 | 0 |
| Header Elements | 3 | 2 | 1 (notification) |
| API Endpoints | 1 | 1 | 0 |
| Analytics Events | 5 | 0 | 5 |

**Notes:**
- Core enrollment/progress functionality complete
- Shows loading skeleton, error, empty, and populated states
- Error state has "Retry" button
- Enrollment cards show progress bars, creator, and ST info
- "Book Session" only shows for in-progress courses
- Notification bell visual only (red dot visible)
- D1 REST API fallback working on MBA-2017

### Screenshots

| File | Date | Description |
|------|------|-------------|
| `SDSH-2026-01-07-06-47-19.png` | 2026-01-07 | Student dashboard with error state (before D1 fix) |
| `SDSH-2026-01-07-06-56-25.png` | 2026-01-07 | Student dashboard empty state (D1 REST working) |
