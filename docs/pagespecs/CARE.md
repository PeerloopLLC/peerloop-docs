# Page: Careers

**Code:** CARE
**URL:** `/careers`
**Access:** Public
**Priority:** P3
**Status:** Spec Only (Future)

---

## Purpose

Attract talent by showcasing open positions and company culture.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| ABOU | "Join Our Team" link | From about |
| Nav | Footer "Careers" link | All pages |
| External | Job boards/LinkedIn | Recruiting |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| External | Application link | Job application |
| ABOU | "About Us" link | Company info |

---

## Sections

### Hero
- Headline: "Join the Mission"
- Subheadline: Help solve the 2 Sigma Problem
- Team photo or illustration

### Why Work at Peerloop
- Mission-driven work
- Remote-first culture
- Growth opportunity
- Benefits highlights

### Open Positions

**Position Card:**
- Job title
- Department
- Location (Remote, Hybrid, etc.)
- Type (Full-time, Part-time, Contract)
- Brief description
- "Apply" button

**Filter Options:**
- Department
- Location
- Type

### No Open Positions State
- "No open positions right now"
- "Join talent network" email signup

### Company Culture
- Values
- Team photos
- Day-in-the-life content

### Benefits
- Health/dental
- Remote work
- Learning budget
- Equity (if applicable)
- PTO policy

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| (static) | - | Job content |
| job_listings | (if dynamic) | Job posts |

---

## Implementation Options

1. **Static:** Jobs hardcoded in JSON
2. **Lever/Greenhouse:** Embed job board widget
3. **Custom:** D1 table with admin editing

---

## Notes

- Link to job board or application system
- Consider Lever, Greenhouse, Ashby integration
- Email capture for talent network
- May be placeholder until hiring begins
