# Page: Student Dashboard

**Code:** SDSH
**URL:** `/dashboard`
**Access:** Authenticated (Student role)
**Priority:** P0
**Status:** In Scope

---

## Purpose

Central hub for students to track their enrolled courses, upcoming sessions, learning progress, and quickly access key actions.

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

| Target | Trigger | Notes |
|--------|---------|-------|
| CCNT | "Continue Learning" on course card | Resume course content |
| SBOK | "Book Session" / "Schedule" | Book next session |
| SROM | "Join Session" | Active session join |
| CDET | Course title click | View course details |
| MSGS | Message icon on ST | Message assigned teacher ✅ |
| FEED | "Community" nav | Go to feed |
| CBRO | "Browse Courses" | Find new courses |
| PROF | "Profile" nav | Edit profile |
| STPR | "Your Teacher" link | View assigned ST |
| NOTF | Notification bell | View all notifications |

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

## User Stories Fulfilled

- US-S009: Access personalized dashboard
- US-P003: View enrolled courses and progress
- US-P060: See upcoming sessions on dashboard

---

## States & Variations

| State | Description |
|-------|-------------|
| New User | No courses, prominent "Browse Courses" CTA |
| Active Student | Courses in progress, sessions scheduled |
| Session Starting | "Join Now" prominently displayed |
| Course Complete | "Congratulations" banner, ST path CTA |
| Multi-Role | May show tabs/sections for other roles (see TDSH) |

---

## Mobile Considerations

- Sessions section at top (most time-sensitive)
- Course cards stack vertically
- Sticky "Join Session" button if session imminent
- Bottom navigation bar

---

## Error Handling

| Error | Display |
|-------|---------|
| Data load fails | "Unable to load dashboard. [Retry]" |
| Session join fails | "Unable to join session. [Try again]" |

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

## API Calls

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/users/me` | Page load | Current user profile |
| `GET /api/enrollments` | Page load | Enrolled courses with progress |
| `GET /api/sessions?upcoming=true&limit=3` | Page load | Next 3 upcoming sessions |
| `GET /api/certificates` | Page load | Earned certificates |
| `GET /api/notifications/count` | Page load | Unread notification count |
| `GET /api/activity?limit=10` | Page load | Recent activity timeline |

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

## Notes

- Consider real-time session countdown
- Push notifications for session reminders
- Multi-role users: Dashboard adapts (see CLAUDE.md Phase 3.7)
- CD-033: "Schedule Later" option should be visible in booking flow
