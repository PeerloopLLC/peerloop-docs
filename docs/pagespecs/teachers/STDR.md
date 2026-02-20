# Page: Student-Teacher Directory

**Code:** STDR
**URL:** `/student-teachers`
**Access:** Public
**Priority:** P1
**Status:** In Scope

---

## Purpose

Allow visitors and students to discover available Student-Teachers, browse by course specialty, and find teachers before or after course enrollment.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| Nav | "Student-Teachers" link | Global navigation (if shown) |
| CDET | "View All STs" link | From course detail ST section |
| SDSH | "Find a Teacher" link | Student looking for ST |
| HOME | "Become a Teacher" → lands here to see examples | Aspirational path |
| (External) | Direct URL | `/student-teachers` |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| STPR | ST card click | View ST profile |
| CDET | Course badge click on ST card | See the course they teach |
| SBOK | "Book Session" CTA on card | Direct to booking (if enrolled) |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| users (STs) | id, name, handle, avatar, bio_short | ST cards |
| student_teachers | course_id, students_taught, certified_date, is_active | Certification info |
| user_expertise | tag | Expertise display |
| courses | id, title, slug | Course badges on cards |
| user_availability | is_available | "Available Now" indicator |

---

## Sections

### Header
- Page title: "Student-Teachers" or "Learn from Your Peers"
- Subtitle: Explain the ST model briefly

### Search/Filter Bar
- Search by name or expertise
- **Filter by course:** Dropdown of courses with STs
- **Availability:** "Available Now" toggle
- **Sort:** Most Students, Highest Rated, Newest

### ST Grid
- Responsive grid: 3 columns desktop, 2 tablet, 1 mobile
- ST card:
  - Avatar
  - Name
  - Course badges (courses they're certified for)
  - Students taught count
  - Availability indicator (green dot if available)
  - Short bio (truncated)
  - "View Profile" → STPR
  - "Book Session" → SBOK (if user is enrolled in a matching course)

### Empty State
- No STs match filters
- "Try a different filter or check back soon"

### Become a Teacher CTA
- Banner or section at bottom
- "Want to teach? Complete a course and become a Student-Teacher"
- Link to CDET or info page

---

## User Stories Fulfilled

- US-S050: Browse Student-Teachers before selecting one
- US-S051: Filter STs by course
- US-P066: Platform lists available STs

---

## States & Variations

| State | Description |
|-------|-------------|
| Visitor | View-only, "Sign up to book" CTAs |
| Logged In (Not Enrolled) | Can view but "Enroll first" prompts |
| Logged In (Enrolled) | "Book Session" buttons active for matching courses |
| Filtered by Course | Pre-filtered from CDET link |

---

## Mobile Considerations

- Single column cards
- Filters in collapsible drawer
- "Available Now" toggle prominent

---

## Error Handling

| Error | Display |
|-------|---------|
| No STs available | "No Student-Teachers available yet. Check back soon!" |
| Load fails | Retry button |

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `page_view` | Page load | filters |
| `st_card_click` | ST clicked | st_id, position |
| `filter_applied` | Filter changed | filter_type, value |
| `book_session_click` | Book clicked | st_id, course_id |

---

## API Calls

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/student-teachers` | Page load | ST list with stats |
| `GET /api/student-teachers?course=...&available=...` | Filter | Filtered results |
| `GET /api/courses` | Page load | Course filter dropdown options |

**Query Parameters:**
- `q` - Search by name or expertise
- `course` - Filter by course slug
- `available` - Boolean, only show available now
- `sort` - students, rating, newest
- `page`, `limit` - Pagination

**Response includes for each ST:**
- Profile: id, name, handle, avatar, bio_short
- Certifications: Array of { course_id, course_title, certified_date }
- Stats: students_taught, average_rating
- Availability: is_available (boolean)

---

## Notes

- P1 priority: Core flow works via CDET ST section; directory is enhancement
- Genesis Cohort: May have very few STs initially
- Consider "Featured ST" or "Top Teachers" section
