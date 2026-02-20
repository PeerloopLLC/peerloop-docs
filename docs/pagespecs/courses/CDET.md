# Page: Course Detail

**Code:** CDET
**URL:** `/courses/:slug`
**Access:** Public (some content gated for enrolled users)
**Priority:** P0
**Status:** In Scope

---

## Purpose

Display comprehensive course information to help visitors make enrollment decisions, and provide enrolled students with course access.

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

| Target | Trigger | Notes |
|--------|---------|-------|
| SBOK | "Book a Session" / ST card click | Select ST and schedule |
| SGUP | "Enroll" (logged out) | Redirect to signup, return after |
| CCNT | "Start Learning" (enrolled) | Access course content |
| CPRO | Creator name/avatar click | View creator profile |
| STPR | ST name click in ST list | View ST profile |
| CBRO | Breadcrumb "Courses" | Back to browse |
| (Payment) | "Enroll Now" button | Payment flow (inline or Stripe) |

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
- Video/reading counts if available

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

### Related Courses (Optional for MVP)
- 3-4 related course cards
- Based on category or tags

---

## User Stories Fulfilled

- US-G006: View full course details before signup
- US-G007: See course price and what's included
- US-S005: Review curriculum before enrolling
- US-S059: See learning objectives
- US-S060: See what's included
- US-S061: See available Student-Teachers
- US-S083: See course price equals ST session price (per CD-033)
- US-S084: Access ST calendar during enrollment

---

## States & Variations

| State | Description |
|-------|-------------|
| Visitor | Full info, "Enroll" CTA leads to signup |
| Logged In (Not Enrolled) | "Enroll" CTA leads to payment |
| Enrolled | "Start Learning" CTA, "Book Session" CTA prominent |
| Completed | "Review Course" option, teaching path highlighted |

---

## Mobile Considerations

- Hero becomes stacked (image, then content)
- Sticky "Enroll" button at bottom
- Curriculum sections accordion-style
- ST cards horizontal scroll

---

## Error Handling

| Error | Display |
|-------|---------|
| Course not found | 404 page with search suggestion |
| Course inactive | "This course is no longer available" |
| STs unavailable | Hide ST section, show "Check back soon" |

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

## Server Integration

### API Endpoints Called

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/courses/:slug` | Page load | Course data + enrollment status |
| `POST /api/checkout/session` | "Enroll Now" clicked | Create Stripe checkout |
| `POST /api/sessions` | "Book Free Intro" clicked | Create intro session (CD-029) |

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

### Stripe Checkout Session

```typescript
// POST /api/checkout/session
stripe.checkout.sessions.create({
  mode: 'payment',
  line_items: [{
    price: course.stripe_price_id,
    quantity: 1
  }],
  payment_intent_data: {
    transfer_group: `enrollment-${course.id}-${user.id}`
  },
  success_url: `${origin}/courses/${slug}?enrolled=true`,
  cancel_url: `${origin}/courses/${slug}`,
  metadata: {
    course_id: course.id,
    user_id: user.id
  }
})
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

### Free Intro Session (CD-029)

```
"Book Free Intro" Clicked:
  1. Must be logged in (redirect to SGUP if not)
  2. POST /api/sessions {
       course_id: string,
       type: 'intro',
       st_id: optional  // if ST pre-selected
     }
  3. Backend:
     - Creates session with is_intro = true
     - No payment required
     - Notifies ST (Resend email)
  4. Redirect to SBOK or confirmation
```

### Data Flow Diagram

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│   CDET      │      │  PeerLoop   │      │   Stripe    │
│   (Client)  │      │  (Server)   │      │ (Checkout)  │
└──────┬──────┘      └──────┬──────┘      └──────┬──────┘
       │                    │                    │
       │ "Enroll Now"       │                    │
       │ POST /checkout/    │                    │
       │   session          │                    │
       │───────────────────>│                    │
       │                    │ Create Checkout    │
       │                    │───────────────────>│
       │                    │ checkout_url       │
       │                    │<───────────────────│
       │ { checkout_url }   │                    │
       │<───────────────────│                    │
       │                    │                    │
       │ redirect ────────────────────────────────>
       │                    │                    │
       │ (user pays on Stripe)                   │
       │                    │                    │
       │                    │ Webhook:           │
       │                    │ checkout.session.  │
       │                    │ completed          │
       │                    │<───────────────────│
       │                    │                    │
       │                    │ Create enrollment  │
       │                    │ Create splits      │
       │                    │ Grant feed access  │
       │                    │ Send email (Resend)│
       │                    │                    │
       │ <──────────────────────── return URL    │
       │ (enrolled=true)    │                    │
```

---

## Notes

- CD-033: Price shown = price for ST sessions (unified pricing)
- CD-029: "Book Free Intro" for trust-building (no payment)
- SEO: Course pages are key for organic discovery
- Schema.org Course markup for rich snippets
- Stripe Checkout handles PCI compliance
- Webhook is source of truth for enrollment creation
