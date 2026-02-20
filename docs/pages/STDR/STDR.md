# STDR - ST Directory

| Field | Value |
|-------|-------|
| Route | `/student-teachers` |
| Access | Public |
| Priority | P1 |
| Status | 📋 Spec Only |
| Block | 7 |
| JSON Spec | `src/data/pages/teachers/index.json` |
| Astro Page | `src/pages/teachers/index.astro` |

---

## Purpose

Allow visitors and students to discover available Student-Teachers, browse by course specialty, and find teachers before or after course enrollment.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-S050 | As a Student, I need to browse Student-Teachers before selecting one so that I can find the right match | P1 | 📋 |
| US-S051 | As a Student, I need to filter STs by course so that I can find teachers for my enrolled courses | P1 | 📋 |
| US-P066 | As a Platform, I need to list available STs so that students can discover teaching resources | P1 | 📋 |

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| Nav | "Student-Teachers" link | Global navigation (if shown) |
| CDET | "View All STs" link | From course detail ST section |
| SDSH | "Find a Teacher" link | Student looking for ST |
| HOME | "Become a Teacher" → lands here | Aspirational path |
| (External) | Direct URL | `/student-teachers` |

### Outgoing (users navigate to)

| Target | Trigger | Notes | Status |
|--------|---------|-------|--------|
| STPR | ST card click | View ST profile | 📋 |
| CDET | Course badge click on ST card | See the course they teach | 📋 |
| SBOK | "Book Session" CTA on card | Direct to booking (if enrolled) | 📋 |

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

## Features

### Viewing & Browsing
- [ ] ST card grid (3 columns desktop, 2 tablet, 1 mobile) `[US-S050]`
- [ ] ST card: avatar, name, course badges, students taught, availability `[US-S050]`
- [ ] Short bio (truncated) `[US-S050]`
- [ ] "View Profile" button → STPR `[US-S050]`
- [ ] "Book Session" button → SBOK (if user enrolled) `[US-S050]`
- [ ] Availability indicator (green dot if available) `[US-S050]`

### Search & Filters
- [ ] Search by name or expertise `[US-S051]`
- [ ] Filter by course dropdown `[US-S051]`
- [ ] "Available Now" toggle `[US-S051]`
- [ ] Sort options: Most Students, Highest Rated, Newest `[US-S051]`
- [ ] Pagination `[US-S050]`

### Empty State
- [ ] No STs match filters message `[US-S050]`
- [ ] "Try a different filter or check back soon" `[US-S050]`

### Become a Teacher CTA
- [ ] Banner or section at bottom `[US-P066]`
- [ ] "Want to teach? Complete a course and become a Student-Teacher" `[US-P066]`
- [ ] Link to course browse or info page `[US-P066]`

---

## Sections (from Plan)

### Header
- Page title: "Student-Teachers" or "Learn from Your Peers"
- Subtitle: Brief explanation of ST model

### Search/Filter Bar
- Search input
- Course filter dropdown
- "Available Now" toggle
- Sort dropdown

### ST Grid
Responsive grid layout with ST cards:

**ST Card:**
| Element | Content |
|---------|---------|
| Avatar | Profile image |
| Name | Display name |
| Course Badges | Courses they're certified for |
| Students Taught | Count |
| Availability | Green dot if available |
| Bio | Short bio (truncated) |
| Actions | View Profile, Book Session |

### Empty State
- "No Student-Teachers match your filters"
- "Try a different filter or check back soon"

### Become a Teacher CTA
- Banner section
- Explanation text
- CTA button to courses

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/student-teachers` | GET | ST list with stats | 📋 |
| `/api/courses` | GET | Course filter dropdown options | 📋 |

**Query Parameters:**
- `q` - Search by name or expertise
- `course` - Filter by course slug
- `available` - Boolean, only show available now
- `sort` - students, rating, newest
- `page`, `limit` - Pagination

**Response:**
```typescript
GET /api/student-teachers
{
  student_teachers: [{
    id,
    profile: { id, name, handle, avatar, bio_short },
    certifications: [{
      course_id, course_title, course_slug, certified_date
    }],
    stats: {
      students_taught: number,
      average_rating: number
    },
    is_available: boolean
  }],
  pagination: { page, limit, total, has_more }
}
```

---

## States & Variations

| State | Description |
|-------|-------------|
| Visitor | View-only, "Sign up to book" CTAs |
| Logged In (Not Enrolled) | Can view but "Enroll first" prompts |
| Logged In (Enrolled) | "Book Session" buttons active for matching courses |
| Filtered by Course | Pre-filtered from CDET link |

---

## Error Handling

| Error | Display |
|-------|---------|
| No STs available | "No Student-Teachers available yet. Check back soon!" |
| Load fails | "Unable to load teachers. [Retry]" |

---

## Mobile Considerations

- Single column cards
- Filters in collapsible drawer
- "Available Now" toggle prominent

---

## Implementation Notes

- P1 priority: Core flow works via CDET ST section; directory is enhancement
- Genesis Cohort: May have very few STs initially
- Consider "Featured ST" or "Top Teachers" section
- Availability indicator updates in real-time (or near real-time)
