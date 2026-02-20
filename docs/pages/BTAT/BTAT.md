# BTAT - Become a Teacher

| Field | Value |
|-------|-------|
| Route | `/become-a-teacher` |
| Status | ✅ Implemented |
| Block | 1.8 |
| JSON Spec | `src/data/pages/become-a-teacher.json` |
| Astro Page | `src/pages/become-a-teacher.astro` |
| Component | `src/components/marketing/BecomeATeacherPage.tsx` |

## Purpose

Recruit Student-Teachers by explaining the certification process, earning potential, and benefits. Key page for sustaining the learn-teach-earn flywheel.

## Features

- [x] Hero section with platform stats
- [x] Why Teach - 6 benefits with icons
- [x] Requirements - What you need / don't need (side-by-side)
- [x] Path to Teaching - 5 step certification process with timelines
- [x] Earnings calculator with 2 sliders (hours, rate)
- [x] Real earnings examples (3 scenarios)
- [x] Teacher testimonials - 3 cards with stats
- [x] Day in the Life schedule example
- [x] FAQ accordion (5 questions)
- [x] Two-Path CTA (enrolled vs not enrolled)
- [ ] Analytics events *(page_view, calculator_used, cta_click, apply_started not implemented)*

## Sections

### Hero
- Headline: "Teach What You Know, Earn What You're Worth"
- Subheadline: "Join 300+ Student-Teachers earning $500-2,000+ monthly"
- Stats: $1,250 avg earnings, $890,000+ paid, 312 active teachers
- CTA: "See If You Qualify" → #requirements

### Why Teach on Peerloop?
6 benefit cards with icons:
1. Earn 70% of Every Session
2. Your Schedule, Your Rules
3. Learn by Teaching
4. Build Your Reputation
5. Work From Anywhere
6. Join a Community

### What You Need (Requirements)
Two columns:
- **What You Need:** 4 items with checkmarks
- **What You Don't Need:** 4 items with X marks

### The Path to Teaching
5-step timeline with timelines:
1. Complete a Course (4-12 weeks)
2. Get Recommended (Instant)
3. Certification Interview (1 week)
4. Teaching Training (2 hours)
5. Start Teaching! (Same day)

### What Can You Earn?
- **Calculator:** Hours per week (1-40) + Hourly rate ($20-$75)
- **Results:** Weekly, Monthly, Yearly projections (70% take-home)
- **Real Examples:** Part-time ($420/mo), Side hustle ($980/mo), Serious income ($2,240/mo)

### Hear From Our Teachers
3 testimonial cards:
- Alex Rivera - Python for Beginners
- Priya Sharma - UX Design Fundamentals
- Marcus Thompson - Data Analytics with SQL

Each card shows: avatar, name, course, quote, stats (students, rating, earnings)

### A Day in the Life
Schedule example from 9:00 AM to Evening with 6 activities

### Common Questions (FAQ)
5 accordion questions:
1. What if I don't feel qualified to teach?
2. How many hours do I need to commit?
3. What if a student is difficult?
4. Do I need my own curriculum or materials?
5. How do I get paid?

Link to full FAQ page.

### Two-Path CTA
- **Left card (white):** "Ready to Start Teaching?" → /login
- **Right card (accent):** "Start Your Journey" → /courses

## User Stories Covered

- US-T001: Understand requirements to become a Student-Teacher
- US-T002: Understand earning potential
- US-T003: Learn about the certification process

## Interactive Elements

### Buttons (with onClick handlers)

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| FAQ accordion buttons (5) | BecomeATeacherPage | Toggle FAQ answer visibility | ✅ Active |

### Links

| Element | Target | Status |
|---------|--------|--------|
| "See If You Qualify" (Hero) | #requirements | ✅ Active |
| "More questions? See all FAQs" | /faq | ✅ Active |
| "Check My Eligibility" (CTA) | /login | ✅ Active |
| "Browse Courses" (CTA) | /courses | ✅ Active |

### Target Pages Status

| Target | Page Code | Implemented |
|--------|-----------|-------------|
| /faq | FAQP | ✅ Yes |
| /login | LGIN | ✅ Yes |
| /courses | CBRO | ✅ Yes |

### Form Elements

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| Hours per week slider | BecomeATeacherPage | Updates earnings calculator | ✅ Active |
| Hourly rate slider | BecomeATeacherPage | Updates earnings calculator | ✅ Active |

## Notes

- Static page - no data fetching required
- Testimonials use static data (not from API)
- SEO: Target 'earn money tutoring', 'become a tutor', 'teaching side hustle'
- Critical page for sustaining the flywheel
- Uses accent color scheme (teal/green) vs primary (blue) for differentiation

---

## Verification Notes

**Verified:** 2026-01-08 (Code + Visual + Interactive Elements)

**Consolidated:** 2026-01-08
- JSON spec updated to match verified implementation
- 7 discrepancies documented in JSON `_discrepancies` section

### Components Verified

| Component | File | Status |
|-----------|------|--------|
| BecomeATeacherPage | `src/components/marketing/BecomeATeacherPage.tsx` | ✅ No TODOs |

### Interactive Elements Summary

| Category | Count | Active | Inactive |
|----------|-------|--------|----------|
| Buttons (onClick) | 5 | 5 | 0 |
| Internal Links | 4 | 4 | 0 |
| External Links | 0 | 0 | 0 |
| Form Inputs (sliders) | 2 | 2 | 0 |
| Analytics Events | 0 | 0 | 4 |

**Notes:**
- All internal links point to implemented pages
- Analytics events (page_view, calculator_used, cta_click, apply_started) specified in JSON spec are not yet implemented
- Earnings calculator is fully functional with real-time updates
- Uses accent color scheme for visual differentiation from other marketing pages

### Screenshots

| File | Date | Description |
|------|------|-------------|
| `BTAT-2026-01-08-20-12-06.png` | 2026-01-08 | Full page screenshot |
