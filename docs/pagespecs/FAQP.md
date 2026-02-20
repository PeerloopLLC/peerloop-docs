# Page: FAQ

**Code:** FAQP
**URL:** `/faq`
**Access:** Public
**Priority:** P2
**Status:** Implemented (Marketing)

---

## Purpose

Answer common questions about Peerloop for students, Student-Teachers, and creators.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| HOME | Footer "FAQ" link | Common path |
| HOWI | "FAQ" link | From how it works |
| PRIC | "FAQ" link | Pricing questions |
| BTAT | "FAQ" link | S-T questions |
| FCRE | "FAQ" link | Creator questions |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| CONT | "Contact Us" | Can't find answer |
| CBRO | "Browse Courses" | CTA |
| HELP | "Get Help" | In-app support |

---

## Sections

### Hero
- Headline: "Frequently Asked Questions"
- Search bar (optional)
- Category quick links

### General Questions
- What is Peerloop?
- How is it different from other platforms?
- Is Peerloop right for me?

### For Students
- How do I enroll in a course?
- What's included in the course fee?
- How do sessions work?
- Can I switch Student-Teachers?
- What's the refund policy?
- How do I get my certificate?

### For Student-Teachers
- How do I become an S-T?
- How long does certification take?
- How much can I earn?
- How do payouts work?
- Can I teach multiple courses?
- What if I get a bad review?

### For Creators
- How do I create a course?
- What's the approval process?
- How do royalties work?
- Who handles the tutoring?
- Can I update my course?

### Payments & Billing
- What payment methods are accepted?
- How do refunds work?
- When do S-Ts get paid?
- Are there any hidden fees?

### Technical Questions
- What devices are supported?
- Do I need special software for sessions?
- What are the internet requirements?

### Still Have Questions?
- "Contact Us" → CONT
- Response time expectation

---

## Implementation Notes

### Accordion Pattern
- Each question expandable
- Multiple open allowed
- Smooth animation

### Search (Optional)
- Filter questions by keyword
- Highlight matching text

### Category Tabs
- Quick jump to section
- Mobile: dropdown or tabs

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| (static) | - | FAQ content in JSON |

---

## Notes

- FAQ content managed in JSON/CMS
- Consider schema markup for SEO (FAQ schema)
- Link to relevant pages from answers
- Update based on support ticket patterns
