# Page: Creator Profile

**Code:** CPRO
**URL:** `/creators/:handle` or `/@:handle`
**Access:** Public
**Priority:** P0
**Status:** In Scope

---

## Purpose

Display comprehensive creator information including qualifications, expertise, courses, and teaching philosophy to build trust and drive course enrollment.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| CRLS | Creator card click | From creator listing |
| CDET | Creator name/avatar click | From course detail |
| CBRO | Creator name on course card | From browse results |
| SDSH | Creator link on enrolled course | Student viewing creator |
| IFED | Creator header/link | From instructor feed |
| (External) | Direct URL, shared link | `/@brian` or `/creators/brian` |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| CDET | Course card click | View specific course |
| CBRO | "View All Courses" | Filtered by this creator |
| IFED | "View Feed" (if enrolled in any course) | Access-controlled |
| MSGS | "Message" button | DM the creator ✅ |
| SGUP | Follow button (logged out) | Redirect to signup |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| users | id, name, handle, avatar, title, bio, website, teaching_philosophy | Profile display |
| user_qualifications | sentence, display_order | Credentials section |
| user_expertise | tag | Expertise tags |
| user_stats | students_taught, courses_created, average_rating, total_reviews | Stats bar |
| courses | id, title, slug, thumbnail, price, rating, level | Courses list |
| follows | count where followed_id = creator | Follower count |
| instructor_followers | exists check | Access to IFED |

---

## Sections

### Profile Header
- **Avatar:** Large circular image
- **Name:** Display name
- **Handle:** @handle
- **Title:** Professional title
- **Follow button:** Follows creator (logged in) or prompts signup
- **Follower count:** "X followers"
- **Website link:** External link icon

### Stats Bar
- Students taught
- Courses created
- Average rating (stars + number)
- Total reviews

### Bio Section
- Full biography text
- Expandable if long

### Teaching Philosophy (if present)
- Quote-styled or highlighted section
- Source: users.teaching_philosophy

### Qualifications
- Credential list with icons
- Source: user_qualifications

### Expertise
- Tag pills
- Source: user_expertise

### Courses by [Creator Name]
- Grid of course cards (same as CBRO)
- Show all courses by this creator
- "View All" if more than 6 → CBRO?creator=handle

### Call to Action
- "Explore [Name]'s Courses" button
- Or featured course highlight

---

## User Stories Fulfilled

- US-G008: View creator profile as visitor
- US-G010: See creator qualifications
- US-C008: Creator has public profile
- US-C009: Creator profile shows expertise
- US-C036: Display expertise tags

---

## States & Variations

| State | Description |
|-------|-------------|
| Visitor | Public view, follow prompts signup |
| Logged In (Not Following) | Follow button active |
| Logged In (Following) | "Following" state, unfollow option |
| Enrolled in Creator's Course | "View Feed" link visible (→ IFED) |
| Own Profile (Creator viewing self) | "Edit Profile" link → PROF |

---

## Mobile Considerations

- Header stacks vertically
- Stats become 2x2 grid
- Course cards single column
- Sticky "Follow" button at bottom

---

## Error Handling

| Error | Display |
|-------|---------|
| Creator not found | 404 with "Creator not found" |
| Profile private | "This profile is private" (shouldn't happen for creators) |

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `page_view` | Page load | creator_id, source |
| `follow_click` | Follow clicked | creator_id |
| `course_click` | Course card clicked | course_id |
| `website_click` | External link clicked | creator_id |

---

## API Calls

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/creators/:handle` | Page load | Creator profile data |
| `GET /api/creators/:handle/courses` | Page load | Creator's courses |
| `POST /api/follows` | "Follow" clicked | Follow creator |
| `DELETE /api/follows/:id` | "Unfollow" clicked | Unfollow creator |
| `GET /api/users/me/follows/:creator_id` | Page load (auth) | Check if following |

**Response includes:**
- Profile: name, handle, avatar, title, bio, teaching_philosophy, website
- Qualifications: user_qualifications array
- Expertise: user_expertise tags
- Stats: students_taught, courses_created, average_rating, follower_count
- Courses: Array of course cards

---

## Notes

- CD-017: Creator profiles are a key trust signal ($8K-11K estimate)
- Consider verification badge for vetted creators (future)
- SEO: Creator pages should be indexable
