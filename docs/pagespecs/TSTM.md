# Page: Testimonials

**Code:** TSTM
**URL:** `/testimonials`
**Access:** Public
**Priority:** P2
**Status:** Implemented (Marketing)

---

## Purpose

Display a collection of testimonials and reviews from users to build trust and social proof.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| HOME | "Testimonials" link | Social proof |
| Nav | Footer link | All pages |
| CDET | "Student reviews" link | Course-level |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| STOR | "Full Stories" link | Detailed stories |
| CBRO | "Browse Courses" CTA | Start learning |
| CDET | Course link | Featured courses |

---

## Sections

### Hero
- Headline: "What Our Community Says"
- Aggregate rating display

### Filter/Tabs (Optional)
- All / Students / S-Ts / Creators
- Sort: Most recent / Highest rated

### Testimonial Grid

**Each Card:**
- Avatar
- Name
- Role badge (Student, S-T, Creator)
- Star rating (if applicable)
- Quote text
- Course mentioned (link to CDET)
- Date

### Video Testimonials Section (Optional)
- Embedded video testimonials
- Higher impact than text

### Aggregate Stats
- Overall satisfaction rating
- Number of reviews
- Course completion rate

### Call to Action
- "Join Them" → SGUP
- "Browse Courses" → CBRO

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| course_reviews | rating, content, user_id | Reviews |
| users | name, avatar_url | Reviewer info |
| courses | title, slug | Course reference |

---

## Notes

- Mix of curated and actual reviews
- Consider pulling real reviews from course_reviews
- Video testimonials are high-impact
- Regular refresh to show recent activity
- Filter by course if coming from CDET
