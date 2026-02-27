# WELC - Welcome/Marketing Page

| Field | Value |
|-------|-------|
| Route | `/welcome` |
| Access | Public |
| Priority | P0 |
| Status | ✅ Implemented |
| Block | 1 |
| Astro Page | `src/pages/welcome.astro` |
| Component | `src/components/home/` (HeroSection, FeaturedCourses, etc.) |
| JSON Spec | `src/data/pages/welcome.json` |

---

## Purpose

Marketing/landing page that communicates PeerLoop's value proposition and guides visitors toward course discovery or signup. Previously at `/`, now at `/welcome` to make room for the dashboard homepage.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-G001 | As a visitor, I want to see a clear value proposition on homepage so that I understand what PeerLoop offers | P0 | ✅ |
| US-G002 | As a visitor, I want to understand how the platform works so that I can decide if it's right for me | P0 | ✅ |
| US-G004 | As a visitor, I want to view featured/promoted courses so that I can discover quality content | P0 | ✅ |

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| (External) | Direct URL, marketing campaigns | Marketing entry point |
| HOME | Welcome/About link in dashboard | From dashboard to marketing page |
| Any page | Footer links | Marketing content |

### Outgoing (users navigate to)

| Target | Trigger | Notes | Status |
|--------|---------|-------|--------|
| CBRO | "Browse Courses" CTA | Primary conversion path | ✅ |
| CDET | Featured course card click | Direct to specific course | ✅ |
| CRLS | "Meet Our Creators" link | Secondary path | ✅ |
| SGUP | "Get Started" / "Sign Up" CTA | Registration conversion | ✅ |
| LGIN | "Log In" nav link | Returning users | ✅ |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| courses | title, thumbnail, price, rating, badge | Featured courses display |
| users (creators) | name, avatar, title | Featured creators section |
| platform_stats | various | Platform statistics display |

---

## Features

### Hero Section
- [x] Headline with value proposition (Learn, Teach, Earn) `[US-G001]`
- [x] Subheadline explaining peer teaching model `[US-G001]`
- [x] Primary CTA: "Get Started" → SGUP `[US-G001]`
- [x] Secondary CTA: "Browse Courses" → CBRO `[US-G001]`
- [ ] Hero image/illustration `[US-G001]` *(Currently: gradient background only)*

### How It Works
- [x] Step 1: Enroll in a course `[US-G002]`
- [x] Step 2: Learn from certified Student-Teachers `[US-G002]`
- [x] Step 3: Get certified and start teaching `[US-G002]`
- [x] Visual 3-step illustration `[US-G002]`

### Featured Courses
- [x] 3-6 course cards with thumbnail, title, creator `[US-G004]`
- [x] Price, rating, badge display `[US-G004]`
- [x] Level indicator `[US-G004]`
- [x] "View All Courses" link → CBRO `[US-G004]`

### Value Proposition
- [x] For Students: Learn from peers who recently mastered the material `[US-G001]`
- [x] For Student-Teachers: Earn while teaching what you know `[US-G001]`
- [x] For Creators: Build a teaching community around your courses `[US-G001]`

### Featured Creators
- [x] Creator avatars and names `[US-G004]`
- [x] Creator titles/descriptions `[US-G004]`

### Social Proof
- [x] Testimonials grid (3 cards) `[US-G001]`

---

## Implementation Notes

- Data fetched via SSR from D1
- Platform stats from `platform_stats` table
- Genesis Cohort launch: May feature only 4 courses (per CD-026)
- SEO: Important for marketing, optimize meta tags
- Previously the homepage at `/`, moved to `/welcome` in Session 145

---

## History

- **2026-01-29**: Moved from `/` to `/welcome` (Session 145)
- **2026-01-08**: Consolidated and verified as HOME page
- **2026-01-07**: Initial verification
