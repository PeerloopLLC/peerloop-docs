# Page: For Creators

**Code:** FCRE
**URL:** `/for-creators`
**Access:** Public
**Priority:** P2
**Status:** Implemented (Marketing)

---

## Purpose

Recruit course creators by explaining the benefits, revenue model, and how the Peerloop platform works for them.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| HOME | "For Creators" link | Navigation |
| Nav | Main navigation | All pages |
| PRIC | "For Creators" link | From pricing |
| ABOU | "Create courses" link | From about |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| SGUP | "Apply to Create" CTA | Creator signup |
| CONT | "Contact Us" | Questions |
| CRLS | "See Creators" | Browse creators |
| HOWI | "How It Works" | Learning side |

---

## Sections

### Hero
- Headline: "Create once, earn forever"
- Subheadline: Build a scalable teaching business
- "Apply to Create" CTA

### The Creator Opportunity
- Passive income from royalties (15%)
- Student-Teachers handle tutoring
- Focus on content, not 1-on-1 time
- Scalable beyond your time

### How It Works

1. **Create Your Course**
   - Upload content (videos, docs)
   - Structure modules
   - Set pricing

2. **Certify Student-Teachers**
   - Review completions
   - Recommend for certification
   - Build your teaching team

3. **Earn Royalties**
   - 15% of every session
   - Passive, recurring income
   - As long as course is active

### Revenue Calculator
- Input: course price, session price, students/month
- Output: projected monthly/annual earnings
- Interactive widget

### Platform Features
- Course builder / Creator Studio
- Analytics dashboard
- S-T management
- Payment handling (Stripe)

### Success Stories
- Creator testimonials
- Earnings examples
- Course examples

### Requirements
- Expertise in your field
- Existing content or willingness to create
- Commitment to quality

### Call to Action
- "Apply to Create" → SGUP (creator flow)
- "Have Questions?" → CONT

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| (static) | - | Marketing content |
| users | count where is_creator | Creator count stat |
| courses | count | Course count stat |

---

## Notes

- Target: existing course creators, coaches, consultants
- Emphasize passive income / scalability
- Calculator is engaging - consider implementation
- Creator application may require approval workflow
