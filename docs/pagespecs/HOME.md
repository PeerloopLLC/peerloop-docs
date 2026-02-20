# Page: Homepage

**Code:** HOME
**URL:** `/`
**Access:** Public
**Priority:** P0
**Status:** In Scope

---

## Purpose

Landing page that communicates PeerLoop's value proposition and guides visitors toward course discovery or signup.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| (External) | Direct URL, search engines, marketing | Primary entry point |
| LGIN | Logo click | Return to home |
| SGUP | Logo click | Return to home |
| Any page | Logo/nav home link | Global navigation |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| CBRO | "Browse Courses" CTA | Primary conversion path |
| CDET | Featured course card click | Direct to specific course |
| CRLS | "Meet Our Creators" link | Secondary path |
| SGUP | "Get Started" / "Sign Up" CTA | Registration conversion |
| LGIN | "Log In" nav link | Returning users |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| courses | title, thumbnail, price, rating, badge | Featured courses display |
| users (creators) | name, avatar, title | Featured creators (optional) |

---

## Sections

### Header/Navigation
- Logo (links to HOME)
- Nav links: Browse Courses, For Creators, About
- CTA: Sign Up, Log In

### Hero
- Headline: Value proposition (Learn, Teach, Earn)
- Subheadline: Brief explanation of peer teaching model
- Primary CTA: "Get Started" → SGUP
- Secondary CTA: "Browse Courses" → CBRO
- Hero image/illustration

### How It Works
- Step 1: Enroll in a course
- Step 2: Learn from certified Student-Teachers
- Step 3: Get certified and start teaching
- Visual: 3-step illustration

### Featured Courses
- 3-6 course cards with:
  - Thumbnail, title, creator name
  - Price, rating, badge (if any)
  - Level indicator
- "View All Courses" link → CBRO

### Value Proposition
- For Students: Learn from peers who recently mastered the material
- For Student-Teachers: Earn while teaching what you know
- For Creators: Build a teaching community around your courses

### Social Proof (Optional for MVP)
- Testimonials or stats
- Creator logos/avatars

### Footer
- Navigation links
- Legal links (Privacy, Terms)
- Copyright

---

## User Stories Fulfilled

- US-G001: See clear value proposition on homepage
- US-G002: Understand how the platform works
- US-G004: View featured/promoted courses

---

## States & Variations

| State | Description |
|-------|-------------|
| Default | Standard homepage for visitors |
| Logged In | Header shows user avatar, dashboard link instead of Login/Signup |

---

## Mobile Considerations

- Hero section stacks vertically
- Course cards become horizontal scroll or single column
- Hamburger menu for navigation
- CTAs remain prominent and thumb-accessible

---

## Error Handling

| Error | Display |
|-------|---------|
| Featured courses fail to load | Show static placeholder or hide section |
| Images fail to load | Show placeholder images |

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `page_view` | Page load | source, referrer |
| `cta_click` | Any CTA clicked | cta_name, destination |
| `course_card_click` | Featured course clicked | course_id, position |

---

## API Calls

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/courses/featured` | Page load | Featured courses for carousel |
| `GET /api/creators/featured` | Page load (optional) | Featured creators section |

---

## Notes

- Genesis Cohort launch: May feature only 4 courses (per CD-026)
- Consider A/B testing hero messaging
- SEO: Primary landing page, optimize meta tags
