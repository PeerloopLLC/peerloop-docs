# HOWI - How It Works

| Field | Value |
|-------|-------|
| Route | `/how-it-works` |
| Status | ✅ Implemented |
| Block | 1.8 |
| JSON Spec | `src/data/pages/how-it-works.json` |
| Astro Page | `src/pages/how-it-works.astro` |
| Component | `src/components/marketing/HowItWorksPage.tsx` |

## Purpose

Explain the Peerloop learning model in detail - the learn-teach-earn flywheel, how sessions work, and what makes peer learning effective. Convert curious visitors into enrolled students.

## Features

- [x] Hero section with "Learn. Teach. Earn." headline
- [x] Animated flywheel illustration with Learn/Teach/Earn/Grow labels
- [x] Step-by-step journey (6 steps with icons in alternating timeline)
- [x] For Students section with benefits + 75% completion stat
- [x] For Student-Teachers section with benefits + $900/month earning calculator
- [x] For Course Creators section with benefits + 70/15/15 revenue split visual
- [x] Why Peer Learning Works section (4 reasons: Fresh Perspective, Relatable Experience, Affordable Access, Infinite Scale)
- [x] FAQ Preview section (3 expandable questions)
- [x] Final CTA section with Get Started + Browse Courses buttons
- [ ] Video Explainer section *(Spec says optional - not implemented)*

## Sections

### Hero
- Headline: "Learn. Teach. Earn."
- Subheadline: "A revolutionary approach to education that benefits everyone in the learning chain."
- Animated flywheel with concentric spinning circles
- Labels: Learn, Teach, Earn, Grow positioned around flywheel

### Your Journey (Steps)
6-step alternating timeline with icons:
1. Choose Your Course (search icon)
2. Learn with a Peer Tutor (video icon)
3. Practice & Progress (code icon)
4. Earn Your Certificate (award icon)
5. Become a Teacher (graduation icon)
6. Earn While You Teach (dollar icon)

### For Students
- 4 benefit bullet points
- 75%+ completion rate stat card
- "Start Learning" CTA button

### For Student-Teachers
- 4 benefit bullet points
- Earning potential calculator ($900/month example)
- "Become a Teacher" CTA button

### For Course Creators
- 4 benefit bullet points
- Revenue split visual (70% S-T / 15% Creator / 15% Platform)
- "Create a Course" CTA button

### Why Peer Learning Works
4 cards with emoji icons:
- Fresh Perspective
- Relatable Experience
- Affordable Access
- Infinite Scale

### FAQ Preview
3 expandable accordion questions:
- How much does it cost?
- How do I become a Student-Teacher?
- What if I'm not satisfied?
- "See all FAQs" link

### Final CTA
- "Ready to Start Your Journey?" headline
- Two buttons: Get Started Free, Browse Courses

## User Stories Covered

- US-G002: Understand how the platform works
- US-S001: Understand how to find and enroll in courses
- US-T001: Understand the path to becoming a Student-Teacher

## Interactive Elements

### Buttons (with onClick handlers)

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| FAQ accordion buttons (x3) | HowItWorksPage | Toggle FAQ answer visibility | ✅ Active |

### Links - Navigation CTAs

| Element | Target | Status |
|---------|--------|--------|
| "Start Learning" button | `/courses` | ✅ Active |
| "Become a Teacher" button | `/become-a-teacher` | ✅ Active |
| "Create a Course" button | `/for-creators` | ✅ Active |
| "See all FAQs" link | `/faq` | ✅ Active |
| "Get Started Free" button | `/signup` | ✅ Active |
| "Browse Courses" button | `/courses` | ✅ Active |

### Target Pages Status

| Target | Page Code | Implemented |
|--------|-----------|-------------|
| `/courses` | CBRO | ✅ Yes |
| `/become-a-teacher` | BTAT | 📋 PageSpecView |
| `/for-creators` | FCRE | 📋 PageSpecView |
| `/faq` | FAQP | ✅ Yes |
| `/signup` | SGUP | ✅ Yes |

### Analytics Events

| Event | Spec Status | Implemented |
|-------|-------------|-------------|
| page_view | Required | ❌ No |
| section_view | Required | ❌ No |
| video_play | Required | ❌ No (no video) |
| cta_click | Required | ❌ No |

## Components Analyzed

| Component | File | Status |
|-----------|------|--------|
| HowItWorksPage | `src/components/marketing/HowItWorksPage.tsx` | ✅ Clean - No TODOs |

## Notes

- Static page - no API calls or data fetching required
- All content is hardcoded in the component
- Responsive design with mobile-friendly layout
- FAQ accordions use React state for toggle
- Flywheel animation uses CSS `animate-spin` with different durations

---

## Verification Notes

**Verified:** 2026-01-08 (Code + Visual + Interactive Elements)
**Consolidated:** 2026-01-08
- JSON spec updated to match verified implementation
- 5 discrepancies documented in JSON `_discrepancies` section

### Discrepancies Found

| Feature | Spec | Reality | Status |
|---------|------|---------|--------|
| Video Explainer | Optional section | Not implemented | ⚠️ OK (optional) |
| Analytics events | 4 events listed | None implemented | ❌ Missing |

### Components Verified

| Component | File | Status |
|-----------|------|--------|
| HowItWorksPage | `src/components/marketing/HowItWorksPage.tsx` | ✅ No TODOs |

### Interactive Elements Summary

| Category | Count | Active | Inactive |
|----------|-------|--------|----------|
| Buttons (onClick) | 3 | 3 | 0 |
| Internal Links | 6 | 6 | 0 |
| External Links | 0 | 0 | 0 |
| Dynamic Links | 0 | 0 | 0 |
| Analytics Events | 0 | 0 | 4 (not implemented) |

**Notes:**
- 2 target pages (BTAT, FCRE) are PageSpecView placeholders
- Analytics events from JSON spec not implemented
- Video explainer section intentionally omitted (marked optional in spec)

### Screenshots

| File | Date | Description |
|------|------|-------------|
| `HOWI-2026-01-08-18-56-18.png` | 2026-01-08 | Full page screenshot showing all sections |
