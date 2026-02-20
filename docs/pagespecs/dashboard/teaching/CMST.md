# Page: My Students (Creator)

**Code:** CMST
**URL:** `/studio/students` or `/my-students`
**Access:** Authenticated (Creator role)
**Priority:** P0
**Status:** In Scope

---

## Purpose

Allow Creators to view and manage all students enrolled in their courses, track individual progress, and facilitate communication.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| CDSH | "View All Students" link | From dashboard |
| STUD | "Students" tab/link | From Creator Studio |
| Nav | "My Students" link | Creator navigation |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| PROF | Student name click | View student profile |
| MSGS | "Message" button | Contact student ✅ |
| CDET | Course name click | View course |
| CSES | "View Sessions" on student row | Session history with student |
| CDSH | Back/breadcrumb | Return to dashboard |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| enrollments | id, student_id, course_id, status, enrolled_at, completed_at | Enrollment records |
| users (students) | id, name, avatar, email, handle | Student info |
| courses | id, title (where creator_id = current user) | Course filter |
| module_progress | enrollment_id, is_complete | Progress calculation |
| sessions | enrollment_id, status, scheduled_start | Session counts |
| certificates | user_id, course_id, type | Completion status |
| student_teachers | user_id, course_id | If student became ST |

---

## Sections

### Header
- Page title: "My Students"
- Total count: "X students across Y courses"
- Export button (CSV)

### Filters & Search
- **Search:** By student name or email
- **Course filter:** All courses / specific course
- **Status filter:** All / Active / Completed / Cancelled
- **Sort:** Name, Enrollment date, Progress, Last activity

### Student List/Table

| Column | Content |
|--------|---------|
| Student | Avatar + name + handle |
| Course | Course title |
| Enrolled | Date enrolled |
| Progress | Progress bar (% modules complete) |
| Sessions | X completed / Y scheduled |
| Status | Active / Completed / At Risk |
| Actions | Message, View Sessions, View Profile |

### Student Row Actions
- **Message** → MSGS (pre-filled recipient)
- **View Sessions** → CSES (filtered to this student)
- **View Profile** → PROF
- **Mark at Risk** (flag for follow-up)

### Bulk Actions
- Select multiple students
- Bulk message
- Export selected

### Student Detail Panel (Slide-out or Modal)
When clicking a student row:
- Full student info
- Course progress breakdown by module
- Session history
- Notes (creator's private notes on student)
- Assigned ST info
- Certificate status

---

## User Stories Fulfilled

- US-C039: View enrolled students
- US-C040: Track student progress
- US-C041: Contact students
- US-C042: Export student data

---

## States & Variations

| State | Description |
|-------|-------------|
| Default | All students, sorted by enrollment date |
| Filtered | By course or status |
| Empty | No students yet, "Share your courses" CTA |
| Detail Open | Student detail panel visible |

---

## Mobile Considerations

- Card-based list instead of table
- Filters in collapsible drawer
- Detail panel becomes full screen
- Key actions (message) prominent

---

## Error Handling

| Error | Display |
|-------|---------|
| Load fails | "Unable to load students. [Retry]" |
| Export fails | "Export failed. Try again." |

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `page_view` | Page load | student_count, filter_state |
| `student_viewed` | Detail opened | student_id, course_id |
| `student_messaged` | Message clicked | student_id |
| `export_requested` | Export clicked | count, format |

---

## API Calls

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/creators/me/students` | Page load | Student list |
| `GET /api/creators/me/students/:id` | Detail open | Student detail |
| `GET /api/creators/me/courses` | Filter dropdown | Course options |
| `GET /api/enrollments/:id/progress` | Detail open | Module progress |
| `GET /api/enrollments/:id/sessions` | Detail open | Session history |
| `PUT /api/enrollments/:id/notes` | Save notes | Creator's notes on student |
| `POST /api/enrollments/:id/flag` | Flag student | Mark at-risk |
| `GET /api/creators/me/students/export` | Export | CSV export |

**Query Parameters:**
- `q` - Search by name/email
- `course_id` - Filter by course
- `status` - active, completed, cancelled
- `sort` - name, enrolled_at, progress, last_activity
- `page`, `limit` - Pagination

**Students Response:**
```typescript
GET /api/creators/me/students
{
  students: [{
    id,
    user: { id, name, avatar, handle, email },
    course: { id, title },
    enrollment: {
      id, enrolled_at, completed_at, status
    },
    progress: { completed: number, total: number, percent: number },
    sessions: { completed: number, scheduled: number },
    is_st: boolean,  // Became ST for this course
    is_at_risk: boolean
  }],
  pagination: { page, limit, total, has_more }
}
```

**Student Detail Response:**
```typescript
GET /api/creators/me/students/:id
{
  user: { id, name, avatar, handle, email },
  enrollment: { id, course_id, enrolled_at, status },
  progress: {
    modules: [{ module_id, title, is_complete, completed_at }],
    percent: number
  },
  sessions: [{
    id, scheduled_start, status, st: { name, avatar }
  }],
  assigned_st: { id, name, avatar } | null,
  certificate: { type, issued_at } | null,
  notes: string,  // Creator's private notes
  is_at_risk: boolean
}
```

---

## Notes

- Consider "At Risk" auto-flagging based on inactivity
- Privacy: Only show students enrolled in creator's courses
- Could integrate with email campaigns (future)
