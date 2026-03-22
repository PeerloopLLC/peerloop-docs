# Block 7: Creator Tools Features

**Block:** 7
**Focus:** Creator studio, course creation, student management
**Pages:** STUD, CMST, CSES, CDSH, CEAR (main features)

---

## STUD - Creator Studio

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-STUD-001 | View studio dashboard | Display | Page load | GET /api/me/studio | Studio overview | US-C004 | GO-001 | F-AUTH-001 | MVP | 2 | 2025-12-25 |
| F-STUD-002 | View my courses | Display | Page load | GET /api/me/courses | Course list | US-C004 | GO-001 | F-STUD-001 | MVP | 2 | 2025-12-25 |
| F-STUD-003 | Create new course | Action | Click Create | Navigate to course wizard | Create button | US-C005 | GO-001 | F-STUD-001 | MVP | 8 | 2025-12-25 |
| F-STUD-004 | Edit course | Action | Click Edit | Navigate to course editor | Edit button | US-C006 | GO-001 | F-STUD-002 | MVP | 6 | 2025-12-25 |
| F-STUD-005 | Publish/unpublish course | Action | Click Publish | PATCH /api/courses/:id | Publish toggle | US-C005 | GO-001 | F-STUD-002 | MVP | 2 | 2025-12-25 |
| F-STUD-006 | View course analytics | Action | Click Analytics | Navigate to CANA | Analytics link | US-C013 | GO-001 | F-STUD-002 | MVP | 0.5 | 2025-12-25 |
| F-STUD-007 | Studio navigation | Display | Page load | Show studio sidebar | Sidebar nav | US-C004 | GO-001 | F-STUD-001 | MVP | 2 | 2025-12-25 |

---

## CMST - My Students

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-CMST-001 | View student list | Display | Page load | GET /api/me/students | Student table | US-C007 | GO-001 | F-AUTH-001 | MVP | 3 | 2025-12-25 |
| F-CMST-002 | Filter by course | Action | Select course | Filter students | Course dropdown | US-C007 | GO-001 | F-CMST-001 | MVP | 1 | 2025-12-25 |
| F-CMST-003 | View student progress | Display | Page load | Show progress per student | Progress column | US-C008 | GO-001 | F-CMST-001 | MVP | 2 | 2025-12-25 |
| F-CMST-004 | Message student | Action | Click Message | Open MSGS with student | Message button | US-C009 | GO-001 | F-CMST-001 | MVP | 1 | 2025-12-25 |
| F-CMST-005 | Export students | Action | Click Export | Download CSV | Export button | US-C007 | GO-001 | F-CMST-001 | MVP | 2 | 2025-12-25 |
| F-CMST-006 | View student detail | Action | Click student | Open student detail panel | Student row | US-C008 | GO-001 | F-CMST-001 | MVP | 2 | 2025-12-25 |

---

## CSES - Session History

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-CSES-001 | View sessions list | Display | Page load | GET /api/me/sessions | Session table | US-C010 | GO-001 | F-AUTH-001 | MVP | 3 | 2025-12-25 |
| F-CSES-002 | Filter by date range | Action | Select dates | Filter sessions | Date picker | US-C010 | GO-001 | F-CSES-001 | MVP | 2 | 2025-12-25 |
| F-CSES-003 | View recording | Action | Click Recording | Open recording player | Recording link | US-C011 | GO-001 | F-CSES-001 | MVP | 2 | 2025-12-25 |
| F-CSES-004 | View session feedback | Display | Page load | Show ratings | Rating column | US-C012 | GO-001 | F-CSES-001 | MVP | 1 | 2025-12-25 |
| F-CSES-005 | Download recording | Action | Click Download | Fetch from R2 | Download button | US-C011 | GO-001 | F-CSES-003 | MVP | 2 | 2025-12-25 |

---

## CDSH - Creator Dashboard

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-CDSH-001 | View course performance | Display | Page load | GET /api/me/courses/stats | Stats cards | US-C001 | GO-001 | F-AUTH-001 | MVP | 3 | 2025-12-25 |
| F-CDSH-002 | View enrollment stats | Display | Page load | Show recent enrollments | Enrollments widget | US-C002 | GO-001 | F-CDSH-001 | MVP | 2 | 2025-12-25 |
| F-CDSH-003 | View revenue summary | Display | Page load | GET /api/me/earnings | Revenue card | US-C003 | GO-001 | F-CDSH-001 | MVP | 2 | 2025-12-25 |
| F-CDSH-004 | Click Go to Studio | Action | Click Studio | Navigate to STUD | Studio button | US-C004 | GO-001 | - | MVP | 0.5 | 2025-12-25 |
| F-CDSH-005 | View recent activity | Display | Page load | Show recent actions | Activity feed | US-C001 | GO-001 | F-CDSH-001 | MVP | 2 | 2025-12-25 |
| F-CDSH-006 | Quick action: Create course | Action | Click Create | Navigate to course creation | Create button | US-C005 | GO-001 | - | MVP | 0.5 | 2025-12-25 |

---

## CEAR - Earnings Detail (Main Features)

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-CEAR-001 | View earnings breakdown | Display | Page load | GET /api/me/earnings | Earnings table | US-C016 | GO-001 | F-AUTH-001 | MVP | 3 | 2025-12-25 |
| F-CEAR-002 | View payout history | Display | Page load | GET /api/me/payouts | Payout list | US-C017 | GO-001 | F-CEAR-001 | MVP | 2 | 2025-12-25 |
| F-CEAR-003 | Request payout | Action | Click Request | POST /api/me/payouts | Request button | US-C018 | GO-001 | F-CEAR-001 | MVP | 3 | 2025-12-25 |
| F-CEAR-004 | Filter by period | Action | Select period | Filter earnings | Period dropdown | US-C016 | GO-001 | F-CEAR-001 | MVP | 1 | 2025-12-25 |
| F-CEAR-005 | View pending balance | Display | Page load | Show pending amount | Balance card | US-C016 | GO-001 | F-CEAR-001 | MVP | 1 | 2025-12-25 |

*Note: Stripe Connect (F-CEAR-006) is in Block 2.*

---

## Block 7 Summary

| Page | Features | Hours |
|------|----------|-------|
| STUD | 7 | 22.5 |
| CMST | 6 | 11 |
| CSES | 5 | 10 |
| CDSH | 6 | 10 |
| CEAR | 5 | 10 |
| **Total** | **29** | **63.5** |
