# Page: Student-Teacher Profile

**Code:** STPR
**URL:** `/@:handle` (shared with general profile, ST-specific view)
**Access:** Public (if privacy_public = true)
**Priority:** P0
**Status:** In Scope

---

## Purpose

Display Student-Teacher's credentials, teaching availability, courses they're certified to teach, and enable session booking.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| STDR | ST card click | From ST directory |
| CDET | ST name in course's ST list | From course detail |
| SBOK | ST info link | While booking |
| SDSH | "Your Teacher" link | Student viewing assigned ST |
| TDSH | Own profile link | ST viewing their public profile |
| (External) | Direct URL | `/@sarah` |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| SBOK | "Book Session" CTA | Pre-select this ST |
| CDET | Course card click | View course they teach |
| MSGS | "Message" button | DM the ST ✅ |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| users | id, name, handle, avatar, title, bio, privacy_public | Profile info |
| student_teachers | course_id, students_taught, certified_date | ST credentials |
| certificates | type, issued_at | Completion/mastery certs |
| courses | id, title, slug, thumbnail | Courses they teach |
| availability | day_of_week, start_time, end_time, timezone | Availability calendar |
| user_stats | average_rating, total_reviews | Teaching stats |
| sessions | count | Sessions conducted |

---

## Sections

### Profile Header
- Avatar (with ST badge overlay)
- Name
- Handle: @handle
- Title/bio
- **Teaching Badge:** Visual indicator of ST status
- Stats row: X students taught, Y sessions, Z rating

### Availability Section
- **"Available to Help" indicator** (green/gray)
- Weekly availability grid:
  - Days with available slots highlighted
  - Click to expand time slots
- Timezone display
- "Book a Session" CTA → SBOK

### Courses I Teach
- Cards for each course they're certified to teach
- For each:
  - Course thumbnail + title
  - Certified date
  - Students taught for this course
  - "Book for this course" CTA

### Certifications
- List of earned certificates:
  - Completion certificates
  - Mastery certificates (if earned)
  - Teaching certification (per course)
- Issue dates

### Reviews/Testimonials (if available)
- Recent reviews from students they've taught
- Average rating

### Bio/About
- Extended bio text
- Teaching philosophy (if set)

---

## User Stories Fulfilled

- US-G009: View ST profile as visitor
- US-T003: ST has public profile showing credentials
- US-T004: ST displays availability
- US-T020: ST can toggle public visibility
- US-T021: ST shows courses certified to teach
- US-T022: ST shows students taught count

---

## States & Variations

| State | Description |
|-------|-------------|
| Visitor | View only, booking prompts signup |
| Logged In (Not Enrolled) | "Enroll first" for booking |
| Logged In (Enrolled in matching course) | "Book Session" active |
| Own Profile (ST viewing self) | "Edit Profile" link, no booking CTA |
| Private Profile | "This profile is private" (if privacy_public = false) |

---

## Mobile Considerations

- Header stacks vertically
- Availability becomes scrollable horizontal calendar
- Course cards single column
- Sticky "Book Session" button

---

## Error Handling

| Error | Display |
|-------|---------|
| Profile not found | 404 page |
| Profile private | "This profile is private" |
| No availability | "No available slots. Check back later." |

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `page_view` | Page load | st_id, source |
| `book_click` | Book session clicked | st_id, course_id |
| `course_click` | Course card clicked | course_id |
| `availability_viewed` | Availability section viewed/expanded | st_id |

---

## API Calls

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/users/:handle` | Page load | Profile data |
| `GET /api/users/:handle/st-info` | Page load (if ST) | ST-specific data |
| `GET /api/users/:handle/availability` | Page load | Availability calendar |
| `GET /api/users/:handle/reviews` | Page load | Teaching reviews |
| `GET /api/users/me/enrollments` | Page load (auth) | Check if can book |

**ST Info Response:**
- Certifications: Array of { course, certified_date, students_taught }
- Stats: total_students_taught, total_sessions, average_rating
- Certificates: Array of earned completion/mastery certs

**Availability Response:**
- is_available_now: boolean
- slots: Array of { day_of_week, start_time, end_time }
- timezone: string

---

## Notes

- ST profile is an extension of regular user profile (PROF)
- Badge/indicator distinguishes ST from regular student
- CD-018: Student profile system ($14K-19K estimate includes this)
- Consider merging with PROF using role-aware sections
