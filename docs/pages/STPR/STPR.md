# STPR - ST Profile

| Field | Value |
|-------|-------|
| Route | `/@:handle` (shared with general profile, ST-specific view) |
| Access | Public (if privacy_public = true) |
| Priority | P0 |
| Status | 📋 Spec Only |
| Block | 7 |
| JSON Spec | `src/data/pages/teachers/[handle].json` |
| Astro Page | `src/pages/teachers/[handle].astro` |

---

## Purpose

Display Student-Teacher's credentials, teaching availability, courses they're certified to teach, and enable session booking.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-G009 | As a Visitor, I need to view ST profiles so that I can learn about teachers | P0 | 📋 |
| US-T003 | As a S-T, I need a public profile showing credentials so that students can find me | P0 | 📋 |
| US-T004 | As a S-T, I need to display my availability so that students can book sessions | P0 | 📋 |
| US-T020 | As a S-T, I need to toggle public visibility so that I can control my privacy | P0 | 📋 |
| US-T021 | As a S-T, I need to show courses I'm certified to teach so that students know my expertise | P0 | 📋 |
| US-T022 | As a S-T, I need to show students taught count so that students can see my experience | P0 | 📋 |

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

| Target | Trigger | Notes | Status |
|--------|---------|-------|--------|
| SBOK | "Book Session" CTA | Pre-select this ST | 📋 |
| CDET | Course card click | View course they teach | 📋 |
| MSGS | "Message" button | DM the ST (if allowed) | 📋 |

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

## Features

### Profile Header
- [ ] Avatar with ST badge overlay `[US-T003]`
- [ ] Name and handle (@handle) `[US-T003]`
- [ ] Title/bio `[US-T003]`
- [ ] Teaching badge visual indicator `[US-T003]`
- [ ] Stats row: X students taught, Y sessions, Z rating `[US-T022]`

### Availability Section
- [ ] "Available to Help" indicator (green/gray) `[US-T004]`
- [ ] Weekly availability grid `[US-T004]`
- [ ] Days with available slots highlighted `[US-T004]`
- [ ] Click to expand time slots `[US-T004]`
- [ ] Timezone display `[US-T004]`
- [ ] "Book a Session" CTA → SBOK `[US-T004]`

### Courses I Teach
- [ ] Cards for each certified course `[US-T021]`
- [ ] Course thumbnail + title `[US-T021]`
- [ ] Certified date `[US-T021]`
- [ ] Students taught for this course `[US-T021]`
- [ ] "Book for this course" CTA `[US-T021]`

### Certifications
- [ ] List of earned certificates `[US-T003]`
- [ ] Completion certificates `[US-T003]`
- [ ] Mastery certificates (if earned) `[US-T003]`
- [ ] Teaching certification (per course) `[US-T003]`
- [ ] Issue dates `[US-T003]`

### Reviews/Testimonials
- [ ] Recent reviews from students taught `[US-T003]`
- [ ] Average rating display `[US-T003]`

### Bio/About
- [ ] Extended bio text `[US-T003]`
- [ ] Teaching philosophy (if set) `[US-T003]`

---

## Sections (from Plan)

### Profile Header
| Element | Content |
|---------|---------|
| Avatar | Profile image with ST badge |
| Name | Display name |
| Handle | @handle |
| Title/Bio | Short description |
| Stats | Students taught, sessions, rating |

### Availability Section
- "Available to Help" indicator
- Weekly calendar grid
- Timezone
- "Book a Session" CTA

### Courses I Teach
Course cards with:
- Thumbnail + title
- Certified date
- Students taught count
- "Book for this course" button

### Certifications
- Completion certificates
- Mastery certificates
- Teaching certifications
- Issue dates

### Reviews
- Recent student reviews
- Average rating

### Bio/About
- Extended bio
- Teaching philosophy

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/users/:handle` | GET | Profile data | 📋 |
| `/api/users/:handle/st-info` | GET | ST-specific data | 📋 |
| `/api/users/:handle/availability` | GET | Availability calendar | 📋 |
| `/api/users/:handle/reviews` | GET | Teaching reviews | 📋 |
| `/api/users/me/enrollments` | GET | Check if can book (auth) | 📋 |

**ST Info Response:**
```typescript
GET /api/users/:handle/st-info
{
  certifications: [{
    course: { id, title, slug, thumbnail },
    certified_date: string,
    students_taught: number
  }],
  stats: {
    total_students_taught: number,
    total_sessions: number,
    average_rating: number
  },
  certificates: [{
    type: 'completion' | 'mastery' | 'teaching',
    course_title: string,
    issued_at: string
  }]
}
```

**Availability Response:**
```typescript
GET /api/users/:handle/availability
{
  is_available_now: boolean,
  slots: [{
    day_of_week: number,  // 0-6
    start_time: string,   // "09:00"
    end_time: string      // "17:00"
  }],
  timezone: string  // "America/New_York"
}
```

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

## Error Handling

| Error | Display |
|-------|---------|
| Profile not found | 404 page |
| Profile private | "This profile is private" |
| No availability | "No available slots. Check back later." |

---

## Mobile Considerations

- Header stacks vertically
- Availability becomes scrollable horizontal calendar
- Course cards single column
- Sticky "Book Session" button

---

## Implementation Notes

- ST profile is an extension of regular user profile (PROF)
- Badge/indicator distinguishes ST from regular student
- CD-018: Student profile system ($14K-19K estimate includes this)
- Consider merging with PROF using role-aware sections
- Privacy controls respect privacy_public flag
- Availability syncs with SETT page
