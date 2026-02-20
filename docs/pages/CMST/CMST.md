# CMST - My Students

| Field | Value |
|-------|-------|
| Route | `/studio/students` or `/my-students` |
| Access | Authenticated (Creator role) |
| Priority | P0 |
| Status | 📋 Spec Only |
| Block | 3 |
| JSON Spec | `src/data/pages/dashboard/teaching/students.json` |
| Astro Page | `src/pages/dashboard/teaching/students.astro` |

---

## Purpose

Allow Creators to view and manage all students enrolled in their courses, track individual progress, and facilitate communication.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-C039 | As a Creator, I need to view my enrolled students so that I can monitor their progress | P0 | 📋 |
| US-C040 | As a Creator, I need to track student progress so that I can provide targeted support | P0 | 📋 |
| US-C041 | As a Creator, I need to contact students so that I can communicate important updates | P0 | 📋 |
| US-C042 | As a Creator, I need to export student data so that I can analyze enrollments offline | P1 | 📋 |

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| CDSH | "View All Students" link | From dashboard |
| STUD | "Students" tab/link | From Creator Studio |
| Nav | "My Students" link | Creator navigation |

### Outgoing (users navigate to)

| Target | Trigger | Notes | Status |
|--------|---------|-------|--------|
| PROF | Student name click | View student profile | 📋 |
| MSGS | "Message" button | Contact student | 📋 |
| CDET | Course name click | View course | 📋 |
| CSES | "View Sessions" on student row | Session history with student | 📋 |
| CDSH | Back/breadcrumb | Return to dashboard | 📋 |

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

## Features

### Viewing & Browsing
- [ ] Student table with avatar, name, handle, course, enrollment date `[US-C039]`
- [ ] Progress bar (% modules complete) `[US-C039]`
- [ ] Session count: X completed / Y scheduled `[US-C039]`
- [ ] Status indicator: Active / Completed / At Risk `[US-C039]`
- [ ] Total count display: "X students across Y courses" `[US-C039]`

### Search & Filters
- [ ] Search by student name or email `[US-C039]`
- [ ] Filter by course (All courses / specific course) `[US-C039]`
- [ ] Filter by status (All / Active / Completed / Cancelled) `[US-C039]`
- [ ] Sort options: Name, Enrollment date, Progress, Last activity `[US-C039]`
- [ ] Pagination controls `[US-C039]`

### Student Actions
- [ ] Message student → MSGS `[US-C041]`
- [ ] View sessions → CSES `[US-C039]`
- [ ] View profile → PROF `[US-C039]`
- [ ] Mark at risk (flag for follow-up) `[US-C040]`

### Bulk Actions
- [ ] Select multiple students `[US-C042]`
- [ ] Bulk message `[US-C041]`
- [ ] Export selected (CSV) `[US-C042]`

### Student Detail Panel
- [ ] Full student info (slide-out or modal) `[US-C040]`
- [ ] Course progress breakdown by module `[US-C040]`
- [ ] Session history `[US-C040]`
- [ ] Creator's private notes on student `[US-C040]`
- [ ] Assigned ST info `[US-C040]`
- [ ] Certificate status `[US-C040]`

---

## Sections (from Plan)

### Header
- Page title: "My Students"
- Total count: "X students across Y courses"
- Export button (CSV)

### Filters & Search
- Search input with placeholder
- Course dropdown filter
- Status dropdown filter
- Sort dropdown

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

### Student Detail Panel (Slide-out)
**View Mode:**
- Full student info
- Course progress breakdown by module
- Session history list
- Creator's private notes
- Assigned ST info (if any)
- Certificate status

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/creators/me/students` | GET | Student list | 📋 |
| `/api/creators/me/students/:id` | GET | Student detail | 📋 |
| `/api/creators/me/courses` | GET | Course options for filter | 📋 |
| `/api/enrollments/:id/progress` | GET | Module progress | 📋 |
| `/api/enrollments/:id/sessions` | GET | Session history | 📋 |
| `/api/enrollments/:id/notes` | PUT | Save creator's notes | 📋 |
| `/api/enrollments/:id/flag` | POST | Mark at-risk | 📋 |
| `/api/creators/me/students/export` | GET | CSV export | 📋 |

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

## States & Variations

| State | Description |
|-------|-------------|
| Default | All students, sorted by enrollment date |
| Filtered | By course or status |
| Empty | No students yet, "Share your courses" CTA |
| Detail Open | Student detail panel visible |

---

## Error Handling

| Error | Display |
|-------|---------|
| Load fails | "Unable to load students. [Retry]" |
| Export fails | "Export failed. Try again." |

---

## Mobile Considerations

- Card-based list instead of table
- Filters in collapsible drawer
- Detail panel becomes full screen
- Key actions (message) prominent

---

## Implementation Notes

- Consider "At Risk" auto-flagging based on inactivity
- Privacy: Only show students enrolled in creator's courses
- Could integrate with email campaigns (future)
- Notes are private to creator, not visible to students or STs
