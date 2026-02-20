# Infrastructure Features

**Purpose:** Cross-cutting systems that multiple pages depend on.

---

## Core Infrastructure

| ID | Feature | Description | Stories | Goals | Block | Status | Hours | Updated |
|----|---------|-------------|---------|-------|-------|--------|-------|---------|
| F-AUTH-001 | Authentication system | Login, session management, OAuth | US-P007-P013 | GO-001 | 0 | MVP | 16 | 2025-12-25 |
| F-PAY-001 | Payment processing | Stripe integration, checkout | US-P026-P033 | GO-001 | 2 | MVP | 20 | 2025-12-25 |
| F-STRM-001 | Stream.io integration | Feed infrastructure, real-time | US-S016-S019 | GO-001 | 5 | MVP | 16 | 2025-12-25 |
| F-VID-001 | VideoProvider interface | BBB/PlugNmeet adapter | US-V001-V007 | GO-022 | 4 | MVP | 24 | 2025-12-25 |
| F-ENR-001 | Enrollment system | Enrollment management | US-S006 | GO-001 | 2 | MVP | 12 | 2025-12-25 |
| F-CERT-001 | Certification system | Certificate issuance | US-T017-T019 | GO-020 | 6 | MVP | 12 | 2025-12-25 |
| F-NOTIF-001 | Notification system | Email + in-app notifications | US-P014-P019 | GO-001 | 9 | MVP | 16 | 2025-12-25 |
| F-STOR-001 | File storage | R2 integration | US-P038-P045 | GO-001 | 3 | MVP | 8 | 2025-12-25 |

---

## Infrastructure by Block

| Block | Infrastructure | Hours |
|-------|----------------|-------|
| 0 | F-AUTH-001 | 16 |
| 2 | F-PAY-001, F-ENR-001 | 32 |
| 3 | F-STOR-001 | 8 |
| 4 | F-VID-001 | 24 |
| 5 | F-STRM-001 | 16 |
| 6 | F-CERT-001 | 12 |
| 9 | F-NOTIF-001 | 16 |
| **Total** | | **124** |

---

## Dependency Map

```
F-AUTH-001 (Block 0)
    ├── F-PAY-001 (Block 2)
    │   └── F-ENR-001 (Block 2)
    ├── F-STOR-001 (Block 3)
    ├── F-VID-001 (Block 4)
    ├── F-STRM-001 (Block 5)
    ├── F-CERT-001 (Block 6)
    └── F-NOTIF-001 (Block 9)
```

---

## Detail: F-AUTH-001 - Authentication System

**Hours:** 16
**Block:** 0

| Sub-Feature | Hours |
|-------------|-------|
| Email/password registration | 4 |
| Email/password login | 4 |
| Google OAuth | 4 |
| GitHub OAuth | 3 |
| Session management | 1 |

---

## Detail: F-PAY-001 - Payment Processing

**Hours:** 20
**Block:** 2

| Sub-Feature | Hours |
|-------------|-------|
| Stripe integration setup | 4 |
| Payment intent creation | 4 |
| Checkout flow | 6 |
| Webhook handling | 4 |
| Error handling | 2 |

---

## Detail: F-VID-001 - VideoProvider Interface

**Hours:** 24
**Block:** 4

| Sub-Feature | Hours |
|-------------|-------|
| Interface definition | 2 |
| BBB adapter | 10 |
| Room management | 4 |
| Recording management | 4 |
| Webhook integration | 4 |

---

## Detail: F-STRM-001 - Stream.io Integration

**Hours:** 16
**Block:** 5

| Sub-Feature | Hours |
|-------------|-------|
| Stream.io setup | 2 |
| User token generation | 2 |
| Feed types configuration | 4 |
| Activity posting | 4 |
| Real-time updates | 4 |

---

## Summary

| Category | Features | Hours |
|----------|----------|-------|
| Infrastructure | 8 | 124 |
