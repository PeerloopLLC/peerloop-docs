# Block 2: Enrollment Features

**Block:** 2
**Focus:** Stripe payments, enrollment creation, basic dashboard
**Pages:** CDET (enrollment parts), SDSH (basic), CEAR (Stripe Connect)

---

## CDET - Course Detail (Enrollment Features)

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-CDET-006 | Click Enroll (visitor) | Action | Click Enroll | Navigate to SGUP with redirect | Enroll button | US-G014, US-S006 | GO-001 | F-CDET-001 | MVP | 1 | 2025-12-25 |
| F-CDET-007 | Click Enroll (logged in) | Action | Click Enroll | Open payment modal/flow | Enroll button | US-S006 | GO-001, GO-018 | F-CDET-001, F-AUTH-001 | MVP | 2 | 2025-12-25 |
| F-CDET-008 | Complete payment | Action | Submit payment | POST /api/enrollments, Stripe charge | Payment modal | US-S006 | GO-001 | F-CDET-007, F-PAY-001 | MVP | 4 | 2025-12-25 |
| F-CDET-012 | View "already enrolled" state | Display | Page load (enrolled) | Show "Go to Course" instead of Enroll | Button state | US-S026 | GO-001 | F-CDET-001, F-ENR-001 | MVP | 1 | 2025-12-25 |

---

## SDSH - Student Dashboard (Basic)

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-SDSH-001 | View enrolled courses | Display | Page load | GET /api/me/enrollments | Course cards | US-S011 | GO-001 | F-AUTH-001 | MVP | 3 | 2025-12-25 |
| F-SDSH-007 | Empty state (no courses) | Display | No enrollments | Show "Browse Courses" CTA | Empty state | US-S011 | GO-001 | F-SDSH-001 | MVP | 1 | 2025-12-25 |

*Note: Progress features (F-SDSH-002, F-SDSH-004, F-SDSH-008) are in Block 3. Session features (F-SDSH-003, F-SDSH-005) are in Block 4. Certificate features (F-SDSH-006) are in Block 6.*

---

## CEAR - Earnings Detail (Stripe Connect)

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-CEAR-006 | Connect Stripe | Action | Click Connect | Stripe Connect OAuth | Connect button | US-C018 | GO-001 | F-CEAR-001 | MVP | 4 | 2025-12-25 |

*Note: Other CEAR features are in Block 7.*

---

## Block 2 Summary

| Page | Features | Hours |
|------|----------|-------|
| CDET (enrollment) | 4 | 8 |
| SDSH (basic) | 2 | 4 |
| CEAR (Stripe) | 1 | 4 |
| **Total** | **7** | **16** |

---

## Infrastructure Dependencies

Block 2 requires these infrastructure features:

| ID | Feature | Hours |
|----|---------|-------|
| F-PAY-001 | Payment processing (Stripe) | 20 |
| F-ENR-001 | Enrollment system | 12 |

**Block 2 Total with Infrastructure: 48 hours**
