# PRIC - Pricing

| Field | Value |
|-------|-------|
| Route | `/pricing` |
| Status | Implemented |
| Block | 1.8 |
| JSON Spec | `src/data/pages/pricing.json` |
| Astro Page | `src/pages/pricing.astro` |
| Component | `src/components/marketing/PricingPage.tsx` |

## Purpose

Clearly explain Peerloop's pricing structure for students, student-teachers, and creators. Transparency builds trust and reduces purchase friction.

## Features

- [x] Hero section with "Simple, Transparent Pricing" headline
- [x] Quick pricing summary (Courses $99-399, Sessions $20-50/hour)
- [x] For Students section with 3 pricing cards + 14-day guarantee
- [x] For Student-Teachers section with pricing + interactive earnings calculator
- [x] For Creators section with pricing + revenue example calculation
- [x] Revenue split visual (70/15/15 diagram)
- [x] Comparison to traditional tutoring (3 options)
- [x] Guarantees section (3 guarantees with icons)
- [x] Payment methods section (Visa, Mastercard, Amex, Stripe)
- [x] FAQ Preview section (3 expandable questions)
- [x] Final CTA section with Get Started + Browse Courses buttons
- [ ] PayPal payment *(Spec says "coming soon" - not implemented)*

## Sections

### Hero
- Headline: "Simple, Transparent Pricing"
- Subheadline: "No subscriptions. No hidden fees. Just pay for what you use."
- Quick summary: Courses $99-399, Sessions $20-50/hour

### For Students
- 3 pricing cards: Course Access ($99-$399), 1-on-1 Sessions ($20-$50/hr), Subscriptions (None)
- 14-day money-back guarantee banner with shield icon
- "Browse Courses" CTA button

### For Student-Teachers
- 3 pricing cards: To Get Started (Free), Your Earnings (70%), Payouts (Weekly)
- Interactive earnings calculator with sliders:
  - Hours per week (1-40)
  - Rate per hour ($20-$50)
  - Shows weekly, monthly, yearly earnings
- "Become a Teacher" CTA button

### For Course Creators
- 3 pricing cards: To Create (Free), Course Sales (85%), Session Royalties (15%)
- Revenue example: Course with 100 students = $19,540 first year
- "Create a Course" CTA button

### How the Money Flows
- Visual 70/15/15 split diagram
- Student-Teacher: 70%, Course Creator: 15%, Peerloop: 15%
- Explanatory text about model benefits

### Compare to Traditional Tutoring
- 3 comparison cards:
  - Professional Tutor: $50-150/hour
  - Tutoring Center: $30-80/hour
  - Peerloop: $20-50/hour (highlighted with "Best Value" badge)

### Our Guarantees
- 3 guarantee cards with emoji icons:
  - 14-Day Money Back
  - Session Quality Promise
  - Secure Payments

### Payment Methods
- Accepted: Visa, Mastercard, Amex
- Powered by Stripe badge

### FAQ Preview
- 3 expandable accordion questions:
  - Are there any hidden fees?
  - When do Student-Teachers get paid?
  - Can I get a refund?
- "More questions? See all FAQs" link

### Final CTA
- "Ready to Get Started?" headline
- Two buttons: Get Started Free, Browse Courses

## User Stories Covered

- US-S010: Understand pricing before committing
- US-T015: Understand earning potential as a teacher
- US-C020: Understand revenue model as a creator

## Interactive Elements

### Buttons (with onClick handlers)

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| FAQ accordion buttons (x3) | PricingPage | Toggle FAQ answer visibility | Active |
| Earnings calculator sliders (x2) | PricingPage | Update calculated earnings | Active |

### Links - Navigation CTAs

| Element | Target | Status |
|---------|--------|--------|
| "Browse Courses" button (For Students) | `/courses` | Active |
| "Become a Teacher" button | `/become-a-teacher` | Active |
| "Create a Course" button | `/for-creators` | Active |
| "More questions? See all FAQs" link | `/faq` | Active |
| "Get Started Free" button | `/signup` | Active |
| "Browse Courses" button (Final CTA) | `/courses` | Active |

### Target Pages Status

| Target | Page Code | Implemented |
|--------|-----------|-------------|
| `/courses` | CBRO | Yes |
| `/become-a-teacher` | BTAT | PageSpecView |
| `/for-creators` | FCRE | PageSpecView |
| `/faq` | FAQP | Yes |
| `/signup` | SGUP | Yes |

### Analytics Events

| Event | Spec Status | Implemented |
|-------|-------------|-------------|
| page_view | Required | No |
| calculator_used | Required | No |
| cta_click | Required | No |

## Components Analyzed

| Component | File | Status |
|-----------|------|--------|
| PricingPage | `src/components/marketing/PricingPage.tsx` | Clean - No TODOs |

## Notes

- Static page - no API calls or data fetching required
- All content is hardcoded in the component
- Responsive design with mobile-friendly layout
- FAQ accordions use React state for toggle
- Earnings calculator uses React useState for interactive sliders
- Comparison section implemented as additional feature beyond original spec

---

## Verification Notes

**Verified:** 2026-01-08 (Code + Visual + Interactive Elements)
**Consolidated:** 2026-01-08
- JSON spec updated to match verified implementation
- 6 discrepancies documented in JSON `_discrepancies` section

### Discrepancies Found

| Feature | Spec | Reality | Status |
|---------|------|---------|--------|
| PayPal payment | "coming soon" in spec | Not shown | OK (intentionally omitted) |
| Receipts/invoices | Listed in spec | Not mentioned on page | Minor omission |
| Comparison section | In notes as suggestion | Fully implemented | Improvement |
| Analytics events | 3 events listed | None implemented | Missing |

### Components Verified

| Component | File | Status |
|-----------|------|--------|
| PricingPage | `src/components/marketing/PricingPage.tsx` | No TODOs |

### Interactive Elements Summary

| Category | Count | Active | Inactive |
|----------|-------|--------|----------|
| Buttons (onClick) | 5 | 5 | 0 |
| Internal Links | 6 | 6 | 0 |
| External Links | 0 | 0 | 0 |
| Dynamic Links | 0 | 0 | 0 |
| Analytics Events | 0 | 0 | 3 (not implemented) |

**Notes:**
- 2 target pages (BTAT, FCRE) are PageSpecView placeholders
- Analytics events from JSON spec not implemented
- Comparison section was a suggested feature that was implemented

### Screenshots

| File | Date | Description |
|------|------|-------------|
| `PRIC-2026-01-08-19-08-55.png` | 2026-01-08 | Full page screenshot showing all sections |
