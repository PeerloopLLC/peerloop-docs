# CDET - Course Detail

| Field | Value |
|-------|-------|
| Route | `/courses/:slug` |
| Access | Public (some content gated for enrolled users) |
| Priority | P0 |
| Status | ✅ Implemented |
| Block | 1 |
| Astro Page | `src/pages/courses/[slug].astro` |
| Component | `src/components/courses/CourseDetail.tsx` |
| JSON Spec | `src/data/pages/courses/[slug].json` |

---

## Purpose

Display comprehensive course information to help visitors make enrollment decisions, and provide enrolled students with course access.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-G006 | As a visitor, I want to view full course details before signup so that I can make informed decisions | P0 | ✅ |
| US-G007 | As a visitor, I want to see course price and what's included so that I understand the value | P0 | ✅ |
| US-S005 | As a student, I want to review curriculum before enrolling so that I know what to expect | P0 | ✅ |
| US-S059 | As a student, I want to see learning objectives so that I understand outcomes | P0 | ✅ |
| US-S060 | As a student, I want to see what's included so that I know the course components | P0 | ✅ |
| US-S061 | As a student, I want to see available Student-Teachers so that I can choose who to learn from | P0 | ✅ |
| US-S083 | As a student, I want course price to equal ST session price (unified pricing) | P0 | ✅ |
| US-S084 | As a student, I want to access ST calendar during enrollment | P1 | ⏳ |

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| CBRO | Course card click | Primary discovery path |
| HOME | Featured course click | From homepage |
| CPRO | Course card in creator's courses | From creator profile |
| SDSH | "Continue Learning" or course card | Enrolled student returning |
| IFED | Course mention/link | From instructor feed |
| (External) | Direct URL, search, marketing | Shareable course link |

### Outgoing (users navigate to)

| Target | Trigger | Notes | Status |
|--------|---------|-------|--------|
| SBOK | "Book a Session" / ST card click | Select ST and schedule | ⏳ |
| SGUP | "Enroll" (logged out) | Redirect to signup, return after | ✅ |
| CCNT | "Start Learning" (enrolled) | Access course content | ✅ |
| CPRO | Creator name/avatar click | View creator profile | ✅ |
| STPR | ST name click in ST list | View ST profile | ⏳ |
| CBRO | Breadcrumb "Courses" | Back to browse | ✅ |
| (Payment) | "Enroll Now" button | Payment flow (Stripe) | ✅ |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| courses | All fields | Main course display |
| course_objectives | objective, display_order | "What You'll Learn" section |
| course_includes | item, display_order | "What's Included" section |
| course_curriculum | title, description, duration, session_number | Curriculum display |
| course_prerequisites | type, content | Prerequisites section |
| course_target_audience | description | "Who This Is For" section |
| course_testimonials | quote, student_name, student_role | Social proof |
| student_teachers | user_id, students_taught, certified_date | ST listing |
| users (creator) | name, avatar, title, bio | Creator card |
| users (STs) | name, avatar | ST cards |
| enrollments | status | Check if current user enrolled |
| peerloop_features | all | PeerLoop-specific features display |

---

## Features

### Hero Section
- [x] Course thumbnail (large) with badge overlay `[US-G006]`
- [x] Title and tagline `[US-G006]`
- [x] Creator info (avatar, name, link to CPRO) `[US-G006]`
- [x] Rating stars + review count `[US-G006]`
- [x] Level badge, Duration, Format `[US-G006]`
- [x] Price (prominent) `[US-G007]`
- [x] Primary CTA: "Enroll Now" or "Start Learning" (if enrolled) `[US-G007]`
- [ ] Secondary CTA: "Book Free Intro" (if available) `[US-S084]`

### What You'll Learn
- [x] Checkmark list of learning objectives `[US-S059]`

### What's Included
- [x] Icon list of included items `[US-S060]`

### Who This Is For
- [x] Target audience descriptions `[US-G006]`

### Prerequisites
- [x] Grouped by type: Required, Nice to Have, Not Required `[US-S005]`

### Curriculum
- [x] Expandable/collapsible module list (accordion) `[US-S005]`
- [x] Module title and duration `[US-S005]`
- [x] Description (collapsed by default) `[US-S005]`
- [x] Session number grouping `[US-S005]`

### Meet Your Student-Teachers
- [x] Grid of ST cards with avatar, name, stats `[US-S061]`
- [x] "Book with [Name]" CTA → SBOK `[US-S061]`
- [x] Only shows if course has certified STs `[US-S061]`

### About the Creator
- [x] Creator card with avatar, name, title, bio `[US-G006]`
- [ ] Qualifications (top 3) `[US-G006]`
- [ ] Stats: courses created, students taught, rating `[US-G006]`
- [x] "View Full Profile" → CPRO `[US-G006]`

### Reviews/Testimonials
- [x] Featured testimonials `[US-G006]`
- [x] Average rating display `[US-G006]`

### Related Courses
- [x] 3-4 related course cards `[US-G006]`

### Enrollment
- [x] Enroll button (Stripe integration) `[US-G007]`

---

## Sections

### Breadcrumb
- Home > Courses > [Category] > [Course Title]

### Hero Section
- **Left/Top:**
  - Course thumbnail (large)
  - Badge overlay if applicable (Popular, New, etc.)
- **Right/Bottom:**
  - Title
  - Tagline
  - Creator info (avatar, name, link to CPRO)
  - Rating stars + review count
  - Level badge, Duration, Format
  - Price (prominent)
  - **Primary CTA:** "Enroll Now" or "Start Learning" (if enrolled)
  - **Secondary CTA:** "Book Free Intro" (if available, per CD-029)

### What You'll Learn
- Checkmark list of learning objectives
- Source: course_objectives

### What's Included
- Icon list of included items
- Source: course_includes

### Who This Is For
- Target audience descriptions
- Source: course_target_audience

### Prerequisites
- Grouped by type: Required, Nice to Have, Not Required
- Source: course_prerequisites

### Curriculum
- Expandable/collapsible module list
- For each module:
  - Title, duration
  - Description (collapsed by default)
  - Session number grouping if applicable

### Meet Your Student-Teachers
- Grid of ST cards:
  - Avatar, name
  - Students taught count
  - Certified date
  - "Book with [Name]" CTA → SBOK (pre-selected)
- Only shows if course has certified STs

### About the Creator
- Creator card (larger):
  - Avatar, name, title
  - Short bio
  - Qualifications (top 3)
  - Stats: courses created, students taught, rating
  - "View Full Profile" → CPRO

### Reviews/Testimonials
- Featured testimonials
- Average rating display
- Source: course_testimonials

### PeerLoop Features
- Highlight peer teaching model:
  - 1-on-1 teaching sessions
  - Earn while you learn
  - Become a certified teacher
- Source: peerloop_features

### Related Courses
- 3-4 related course cards
- Based on category or tags

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/courses/:slug` | GET | Course data + enrollment status | ✅ |
| `/api/checkout/session` | POST | Create Stripe checkout | ✅ |
| `/api/sessions` | POST | Create intro session (CD-029) | ⏳ |

### Enrollment Checkout Flow (Stripe)

```
"Enroll Now" Clicked:
  1. POST /api/checkout/session {
       course_id: string,
       return_url: "/courses/:slug?enrolled=true"
     }
  2. Backend:
     - Creates Stripe Checkout Session
     - line_items: [{ price: course.stripe_price_id, quantity: 1 }]
     - payment_intent_data: { transfer_group: "course-{course_id}" }
  3. Response: { checkout_url: "https://checkout.stripe.com/..." }
  4. Client redirects to Stripe Checkout

On Stripe:
  - User enters payment info
  - Completes checkout

After Payment:
  - Webhook: checkout.session.completed
  - Backend creates enrollment
  - Backend creates payment_splits (15/15/70)
  - Backend grants instructor feed access
  - Backend sends welcome email (Resend)
  - Redirect back to /courses/:slug?enrolled=true
```

### Webhook: checkout.session.completed

```typescript
// Server processes webhook:
1. Extract metadata: { course_id, user_id }
2. Create enrollment record
3. Create payment_splits:
   - Platform: 15%
   - Creator: 15%
   - ST Pool: 70% (held until sessions taught)
4. INSERT INTO instructor_followers (grant feed access)
5. Send welcome email via Resend
```

---

## States & Variations

| State | Description | Status |
|-------|-------------|--------|
| Visitor | Full info, "Enroll" CTA leads to signup | ✅ |
| Logged In (Not Enrolled) | "Enroll" CTA leads to payment | ✅ |
| Enrolled | "Start Learning" CTA, "Book Session" CTA prominent | ✅ |
| Completed | "Review Course" option, teaching path highlighted | ⏳ |

---

## Error Handling

| Error | Display |
|-------|---------|
| Course not found | 404 page with search suggestion |
| Course inactive | "This course is no longer available" |
| STs unavailable | Hide ST section, show "Check back soon" |
| Payment fails | Stripe handles errors, return to course page |

---

## Mobile Considerations

- Hero becomes stacked (image, then content)
- Sticky "Enroll" button at bottom
- Curriculum sections accordion-style
- ST cards horizontal scroll

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `page_view` | Page load | course_id, source |
| `enroll_click` | Enroll CTA clicked | course_id, user_logged_in |
| `st_selected` | ST card clicked | course_id, st_id |
| `creator_click` | Creator profile clicked | creator_id |
| `curriculum_expanded` | Module expanded | course_id, module_id |

---

## Implementation Notes

- SSR for SEO, CSR overlay for personalization ("You're enrolled")
- EnrollButton component handles auth state and Stripe checkout
- CD-033: Price shown = price for ST sessions (unified pricing)
- CD-029: "Book Free Intro" for trust-building (no payment)
- SEO: Course pages are key for organic discovery
- Schema.org Course markup for rich snippets
- Stripe Checkout handles PCI compliance
- Webhook is source of truth for enrollment creation

---

## Interactive Elements

### Buttons (with onClick handlers)

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| Enroll Now | EnrollButton | Initiates Stripe checkout | ✅ Active |
| Curriculum session toggle | CourseDetail | Expands/collapses session modules | ✅ Active |
| Book with [ST Name] | CourseDetail | Links to /courses/{slug}/book?st={id} | ✅ Active |

### Links - Breadcrumb

| Element | Target | Status |
|---------|--------|--------|
| Home | / | ✅ Active |
| Courses | /courses | ✅ Active |
| Category | /courses?category={id} | ✅ Active |

### Links - Hero Section

| Element | Target | Status |
|---------|--------|--------|
| Creator card | /creators/{handle} | ✅ Active |

### Links - Sidebar

| Element | Target | Status |
|---------|--------|--------|
| Creator avatar/name | /creators/{handle} | ✅ Active |
| "View full profile →" | /creators/{handle} | ✅ Active |

### Links - Student-Teachers Section

| Element | Target | Status |
|---------|--------|--------|
| "Book with [Name]" button | /courses/{slug}/book?st={id} | ✅ Active |

### Links - Related Courses

| Element | Target | Status |
|---------|--------|--------|
| Course cards | /courses/{slug} | ✅ Active |

### Links - Navigation (Header/Footer)

Same as other public pages (HOME, CBRO).

### API Calls (triggered by interactions)

| Trigger | Endpoint | Method | Status |
|---------|----------|--------|--------|
| Page load (SSR) | `/api/courses/{slug}` | GET | ✅ Active |
| Page load (SSR) | `/api/categories` | GET | ✅ Active |
| Page load (SSR) | `/api/courses?limit=4` | GET | ✅ Active (related) |
| Enroll click | `/api/checkout/session` | POST | ✅ Active |

### Target Pages Status

| Target | Page Code | Implemented |
|--------|-----------|-------------|
| / | HOME | ✅ Yes |
| /courses | CBRO | ✅ Yes |
| /creators/{handle} | CPRO | ✅ Yes |
| /courses/{slug}/book | SBOK | 📋 PageSpecView |
| /courses/{slug} | CDET | ✅ Yes (current) |

---

## Verification Notes

**Verified:** 2026-01-07 (Code + Visual + Interactive Elements)

**Consolidated:** 2026-01-08
- JSON spec updated to match verified implementation
- 4 discrepancies documented in JSON `_discrepancies` section

### Discrepancies Found

| Feature | Spec | Reality | Status |
|---------|------|---------|--------|
| "Book Free Intro" secondary CTA | Planned | Not implemented | ⏳ Deferred |
| Who This Is For | Listed as unchecked | ✅ Implemented in sidebar | ✅ Fixed |
| ST grid | Listed as unchecked | ✅ Implemented | ✅ Fixed |
| "Book with [Name]" CTA | Listed as unchecked | ✅ Implemented | ✅ Fixed |
| Creator qualifications | Planned | Not shown | ⏳ Deferred |
| Creator stats | Planned | Not shown | ⏳ Deferred |
| Analytics events | 5 events specified | None implemented | ❌ Not implemented |

### Components Verified

| Component | File | Status |
|-----------|------|--------|
| CourseDetail | `src/components/courses/CourseDetail.tsx` | ✅ No TODOs |
| EnrollButton | `src/components/courses/EnrollButton.tsx` | ✅ Clean |
| CourseCard | `src/components/courses/CourseCard.tsx` | ✅ Clean |
| [slug].astro | `src/pages/courses/[slug].astro` | ✅ Clean |

### Interactive Elements Summary

| Category | Count | Active | Inactive |
|----------|-------|--------|----------|
| Buttons (onClick) | 5+ | 5+ | 0 |
| Breadcrumb Links | 3 | 3 | 0 |
| Creator Links | 3 | 3 | 0 |
| ST Book Links | 2+ | 2+ | 0 |
| Related Course Links | 2+ | 2+ | 0 |
| API Endpoints | 4 | 4 | 0 |
| Analytics Events | 5 | 0 | 5 |

**Notes:**
- All major sections implemented and working
- ST section shows when course has student-teachers
- Curriculum accordion works with session grouping
- Enroll button integrates with Stripe checkout
- Creator qualifications/stats not shown (deferred)

### Screenshots

| File | Date | Description |
|------|------|-------------|
| `CDET-2026-01-07-05-58-56.png` | 2026-01-07 | Full course detail page |
