# Block 6: ST & Certification Features

**Block:** 6
**Focus:** Certificate issuance, ST role, ST dashboard, ST directory/profile
**Pages:** STDR, STPR, TDSH, SDSH (certificates), CPRO (credentials)

---

## STDR - ST Directory

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-STDR-001 | View ST list | Display | Page load | GET /api/student-teachers | ST cards grid | US-S007 | GO-001 | - | MVP | 3 | 2025-12-25 |
| F-STDR-002 | Filter by course | Action | Select course | Filter STs | Course filter | US-S008 | GO-001 | F-STDR-001 | MVP | 2 | 2025-12-25 |
| F-STDR-003 | Filter by rating | Action | Select min rating | Filter STs | Rating filter | US-S008 | GO-001 | F-STDR-001 | MVP | 1 | 2025-12-25 |
| F-STDR-004 | Filter by availability | Action | Select time slot | Filter STs | Availability filter | US-S008 | GO-001 | F-STDR-001 | MVP | 2 | 2025-12-25 |
| F-STDR-005 | Click ST card | Action | Click ST | Navigate to STPR | ST card | US-S007 | GO-001 | F-STDR-001 | MVP | 0.5 | 2025-12-25 |
| F-STDR-006 | Search STs | Action | Type in search | Search API | Search input | US-S007 | GO-001 | F-STDR-001 | MVP | 2 | 2025-12-25 |

---

## STPR - ST Profile

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-STPR-001 | View ST header | Display | Page load | GET /api/student-teachers/:handle | Profile header | US-S009 | GO-001 | - | MVP | 2 | 2025-12-25 |
| F-STPR-002 | View credentials | Display | Page load | Show teaching certs | Credentials section | US-S009 | GO-020 | F-STPR-001 | MVP | 2 | 2025-12-25 |
| F-STPR-003 | View reviews | Display | Page load | GET /api/student-teachers/:id/reviews | Reviews list | US-S009 | GO-001 | F-STPR-001 | MVP | 3 | 2025-12-25 |
| F-STPR-004 | View availability | Display | Page load | Show calendar availability | Availability calendar | US-S010 | GO-001 | F-STPR-001 | MVP | 3 | 2025-12-25 |
| F-STPR-007 | View courses taught | Display | Page load | List courses ST is certified for | Course badges | US-S009 | GO-001 | F-STPR-001 | MVP | 1 | 2025-12-25 |

*Note: Book Session features (F-STPR-005, F-STPR-006) are in Block 4.*

---

## TDSH - ST Dashboard

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-TDSH-001 | View teaching schedule | Display | Page load | GET /api/me/teaching-sessions | Calendar/list | US-T001 | GO-001 | F-AUTH-001, F-CERT-001 | MVP | 3 | 2025-12-25 |
| F-TDSH-002 | View upcoming sessions | Display | Page load | Filter today's sessions | Session cards | US-T002 | GO-001 | F-TDSH-001 | MVP | 2 | 2025-12-25 |
| F-TDSH-003 | View booking requests | Display | Page load | GET /api/me/booking-requests | Request cards | US-T003 | GO-001 | F-TDSH-001 | MVP | 2 | 2025-12-25 |
| F-TDSH-004 | Accept booking request | Action | Click Accept | PATCH /api/booking-requests/:id | Accept button | US-T003 | GO-001 | F-TDSH-003 | MVP | 2 | 2025-12-25 |
| F-TDSH-005 | Decline booking request | Action | Click Decline | PATCH /api/booking-requests/:id | Decline button | US-T003 | GO-001 | F-TDSH-003 | MVP | 1 | 2025-12-25 |
| F-TDSH-006 | View earnings summary | Display | Page load | GET /api/me/earnings/summary | Earnings card | US-T004 | GO-001 | F-TDSH-001 | MVP | 2 | 2025-12-25 |
| F-TDSH-008 | Set availability | Action | Click Set Availability | Open availability modal/page | Availability button | US-T001 | GO-001 | F-TDSH-001 | MVP | 4 | 2025-12-25 |

*Note: Join session (F-TDSH-007) is in Block 4.*

---

## SDSH - Student Dashboard (Certificates)

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-SDSH-006 | View certificates | Display | Page load | GET /api/me/certificates | Certificate badges | US-S014 | GO-020 | F-AUTH-001 | MVP | 2 | 2025-12-25 |

---

## CPRO - Creator Profile (Credentials)

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-CPRO-004 | View credentials | Display | Page load | Show certifications, badges | Credentials section | US-G010 | GO-020 | F-CPRO-001 | MVP | 2 | 2025-12-25 |

---

## Block 6 Summary

| Page | Features | Hours |
|------|----------|-------|
| STDR | 6 | 10.5 |
| STPR | 5 | 11 |
| TDSH | 7 | 16 |
| SDSH (certs) | 1 | 2 |
| CPRO (creds) | 1 | 2 |
| **Total** | **20** | **41.5** |

---

## Infrastructure Dependencies

Block 6 requires:

| ID | Feature | Hours |
|----|---------|-------|
| F-CERT-001 | Certification system | 12 |

**Block 6 Total with Infrastructure: 53.5 hours**
