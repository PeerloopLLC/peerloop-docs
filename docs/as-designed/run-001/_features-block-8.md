# Block 8: Admin Features

**Block:** 8
**Focus:** Admin dashboard, CRUD screens
**Pages:** ADMN, AUSR, ACRS, AENR, ASES, ACRT, APAY, ACAT, MODQ

---

## ADMN - Admin Dashboard

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-ADMN-001 | View platform overview | Display | Page load | GET /api/admin/stats | Stats cards | US-A001 | GO-001 | F-AUTH-001 | MVP | 3 | 2025-12-25 |
| F-ADMN-002 | View key metrics | Display | Page load | Show user/course/revenue counts | Metrics section | US-A002 | GO-001 | F-ADMN-001 | MVP | 2 | 2025-12-25 |
| F-ADMN-003 | Access admin tools | Display | Page load | Show admin nav | Admin sidebar | US-A003 | GO-001 | F-ADMN-001 | MVP | 2 | 2025-12-25 |
| F-ADMN-004 | View recent activity | Display | Page load | Show recent actions | Activity feed | US-A001 | GO-001 | F-ADMN-001 | MVP | 2 | 2025-12-25 |
| F-ADMN-005 | Quick actions | Action | Click action | Navigate to relevant admin page | Action buttons | US-A003 | GO-001 | F-ADMN-001 | MVP | 1 | 2025-12-25 |

---

## AUSR - Admin Users

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-AUSR-001 | View users list | Display | Page load | GET /api/admin/users | Users table | US-A004 | GO-001 | F-AUTH-001 | MVP | 4 | 2025-12-25 |
| F-AUSR-002 | Search users | Action | Type in search | Filter users | Search input | US-A004 | GO-001 | F-AUSR-001 | MVP | 2 | 2025-12-25 |
| F-AUSR-003 | Filter by role | Action | Select role | Filter users | Role dropdown | US-A004 | GO-001 | F-AUSR-001 | MVP | 1 | 2025-12-25 |
| F-AUSR-004 | View user detail | Action | Click user | Open user detail panel | User row | US-A004 | GO-001 | F-AUSR-001 | MVP | 2 | 2025-12-25 |
| F-AUSR-005 | Edit user | Action | Click Edit | Open edit modal | Edit button | US-A005 | GO-001 | F-AUSR-004 | MVP | 3 | 2025-12-25 |
| F-AUSR-006 | Save user changes | Action | Click Save | PATCH /api/admin/users/:id | Save button | US-A005 | GO-001 | F-AUSR-005 | MVP | 2 | 2025-12-25 |
| F-AUSR-007 | Change user role | Action | Select role | PATCH /api/admin/users/:id/role | Role select | US-A006 | GO-001 | F-AUSR-005 | MVP | 2 | 2025-12-25 |
| F-AUSR-008 | Suspend user | Action | Click Suspend | PATCH /api/admin/users/:id/suspend | Suspend button | US-A007 | GO-001 | F-AUSR-004 | MVP | 2 | 2025-12-25 |
| F-AUSR-009 | Ban user | Action | Click Ban | PATCH /api/admin/users/:id/ban | Ban button | US-A007 | GO-001 | F-AUSR-004 | MVP | 2 | 2025-12-25 |
| F-AUSR-010 | Pagination | Action | Click page | Fetch next page | Pagination | US-A004 | GO-001 | F-AUSR-001 | MVP | 1 | 2025-12-25 |

---

## ACRS - Admin Courses

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-ACRS-001 | View courses list | Display | Page load | GET /api/admin/courses | Courses table | US-A008 | GO-001 | F-AUTH-001 | MVP | 4 | 2025-12-25 |
| F-ACRS-002 | Search courses | Action | Type in search | Filter courses | Search input | US-A008 | GO-001 | F-ACRS-001 | MVP | 2 | 2025-12-25 |
| F-ACRS-003 | Filter by status | Action | Select status | Filter courses | Status dropdown | US-A008 | GO-001 | F-ACRS-001 | MVP | 1 | 2025-12-25 |
| F-ACRS-004 | View course detail | Action | Click course | Open course detail panel | Course row | US-A008 | GO-001 | F-ACRS-001 | MVP | 2 | 2025-12-25 |
| F-ACRS-005 | Approve course | Action | Click Approve | PATCH /api/admin/courses/:id/approve | Approve button | US-A009 | GO-001 | F-ACRS-004 | MVP | 2 | 2025-12-25 |
| F-ACRS-006 | Reject course | Action | Click Reject | PATCH /api/admin/courses/:id/reject | Reject button | US-A009 | GO-001 | F-ACRS-004 | MVP | 2 | 2025-12-25 |
| F-ACRS-007 | Feature course | Action | Click Feature | PATCH /api/admin/courses/:id/feature | Feature toggle | US-A010 | GO-001 | F-ACRS-004 | MVP | 1 | 2025-12-25 |
| F-ACRS-008 | Edit course | Action | Click Edit | Open edit modal | Edit button | US-A008 | GO-001 | F-ACRS-004 | MVP | 3 | 2025-12-25 |
| F-ACRS-009 | Delete course | Action | Click Delete | DELETE /api/admin/courses/:id | Delete button | US-A008 | GO-001 | F-ACRS-004 | MVP | 2 | 2025-12-25 |

---

## AENR - Admin Enrollments

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-AENR-001 | View enrollments list | Display | Page load | GET /api/admin/enrollments | Enrollments table | US-A011 | GO-001 | F-AUTH-001 | MVP | 4 | 2025-12-25 |
| F-AENR-002 | Search enrollments | Action | Type in search | Filter by student/course | Search input | US-A011 | GO-001 | F-AENR-001 | MVP | 2 | 2025-12-25 |
| F-AENR-003 | Filter by status | Action | Select status | Filter enrollments | Status dropdown | US-A011 | GO-001 | F-AENR-001 | MVP | 1 | 2025-12-25 |
| F-AENR-004 | View enrollment detail | Action | Click enrollment | Open detail panel | Enrollment row | US-A011 | GO-001 | F-AENR-001 | MVP | 2 | 2025-12-25 |
| F-AENR-005 | Process refund | Action | Click Refund | POST /api/admin/enrollments/:id/refund | Refund button | US-A012 | GO-001 | F-AENR-004 | MVP | 4 | 2025-12-25 |
| F-AENR-006 | Override status | Action | Select status | PATCH /api/admin/enrollments/:id | Status dropdown | US-A013 | GO-001 | F-AENR-004 | MVP | 2 | 2025-12-25 |
| F-AENR-007 | View payment details | Display | Expand row | Show payment info | Payment section | US-A011 | GO-001 | F-AENR-004 | MVP | 1 | 2025-12-25 |

---

## ASES - Admin Sessions

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-ASES-001 | View sessions list | Display | Page load | GET /api/admin/sessions | Sessions table | US-A014 | GO-001 | F-AUTH-001 | MVP | 4 | 2025-12-25 |
| F-ASES-002 | Filter by date | Action | Select dates | Filter sessions | Date picker | US-A014 | GO-001 | F-ASES-001 | MVP | 2 | 2025-12-25 |
| F-ASES-003 | Filter by status | Action | Select status | Filter sessions | Status dropdown | US-A014 | GO-001 | F-ASES-001 | MVP | 1 | 2025-12-25 |
| F-ASES-004 | View session detail | Action | Click session | Open detail panel | Session row | US-A014 | GO-001 | F-ASES-001 | MVP | 2 | 2025-12-25 |
| F-ASES-005 | Access recording | Action | Click Recording | Open recording in new tab | Recording link | US-A015 | GO-022 | F-ASES-004 | MVP | 1 | 2025-12-25 |
| F-ASES-006 | Handle dispute | Action | Click Dispute | Open dispute modal | Dispute button | US-A016 | GO-001 | F-ASES-004 | MVP | 4 | 2025-12-25 |
| F-ASES-007 | Resolve dispute | Action | Submit resolution | PATCH /api/admin/disputes/:id | Resolve button | US-A016 | GO-001 | F-ASES-006 | MVP | 2 | 2025-12-25 |

---

## ACRT - Admin Certificates

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-ACRT-001 | View certificates list | Display | Page load | GET /api/admin/certificates | Certificates table | US-A017 | GO-020 | F-AUTH-001 | MVP | 4 | 2025-12-25 |
| F-ACRT-002 | Filter by type | Action | Select type | Filter certificates | Type dropdown | US-A017 | GO-020 | F-ACRT-001 | MVP | 1 | 2025-12-25 |
| F-ACRT-003 | Filter by status | Action | Select status | Filter certificates | Status dropdown | US-A017 | GO-020 | F-ACRT-001 | MVP | 1 | 2025-12-25 |
| F-ACRT-004 | View pending | Display | Click Pending tab | Show pending approvals | Pending tab | US-A017 | GO-020 | F-ACRT-001 | MVP | 2 | 2025-12-25 |
| F-ACRT-005 | Approve certificate | Action | Click Approve | POST /api/admin/certificates/:id/approve | Approve button | US-A018 | GO-020 | F-ACRT-004 | MVP | 2 | 2025-12-25 |
| F-ACRT-006 | Reject certificate | Action | Click Reject | POST /api/admin/certificates/:id/reject | Reject button | US-A018 | GO-020 | F-ACRT-004 | MVP | 2 | 2025-12-25 |
| F-ACRT-007 | Issue manually | Action | Click Issue | Open issue modal, POST | Issue button | US-A018 | GO-020 | F-ACRT-001 | MVP | 3 | 2025-12-25 |
| F-ACRT-008 | Revoke certificate | Action | Click Revoke | PATCH /api/admin/certificates/:id/revoke | Revoke button | US-A019 | GO-020 | F-ACRT-001 | MVP | 2 | 2025-12-25 |

---

## APAY - Admin Payouts

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-APAY-001 | View pending payouts | Display | Page load | GET /api/admin/payouts/pending | Pending list | US-A020 | GO-001 | F-AUTH-001 | MVP | 4 | 2025-12-25 |
| F-APAY-002 | View payout detail | Action | Click payout | Open detail panel | Payout row | US-A020 | GO-001 | F-APAY-001 | MVP | 2 | 2025-12-25 |
| F-APAY-003 | Process single payout | Action | Click Process | POST /api/admin/payouts/:id/process | Process button | US-A021 | GO-001 | F-APAY-002 | MVP | 3 | 2025-12-25 |
| F-APAY-004 | Batch process | Action | Click Process All | POST /api/admin/payouts/batch | Process All button | US-A021 | GO-001 | F-APAY-001 | MVP | 3 | 2025-12-25 |
| F-APAY-005 | View payout history | Display | Click History tab | GET /api/admin/payouts | History table | US-A022 | GO-001 | F-APAY-001 | MVP | 2 | 2025-12-25 |
| F-APAY-006 | Filter by status | Action | Select status | Filter payouts | Status dropdown | US-A022 | GO-001 | F-APAY-005 | MVP | 1 | 2025-12-25 |
| F-APAY-007 | View in Stripe | Action | Click Stripe link | Open Stripe dashboard | External link | US-A021 | GO-001 | F-APAY-002 | MVP | 0.5 | 2025-12-25 |

---

## ACAT - Admin Categories

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-ACAT-001 | View categories list | Display | Page load | GET /api/admin/categories | Categories table | US-A023 | GO-001 | F-AUTH-001 | MVP | 2 | 2025-12-25 |
| F-ACAT-002 | Add category | Action | Click Add | Open add modal, POST | Add button | US-A023 | GO-001 | F-ACAT-001 | MVP | 2 | 2025-12-25 |
| F-ACAT-003 | Edit category | Action | Click Edit | Open edit modal, PATCH | Edit button | US-A023 | GO-001 | F-ACAT-001 | MVP | 2 | 2025-12-25 |
| F-ACAT-004 | Delete category | Action | Click Delete | DELETE /api/admin/categories/:id | Delete button | US-A023 | GO-001 | F-ACAT-001 | MVP | 2 | 2025-12-25 |
| F-ACAT-005 | Reorder categories | Action | Drag and drop | POST /api/admin/categories/reorder | Drag handle | US-A024 | GO-001 | F-ACAT-001 | MVP | 3 | 2025-12-25 |

---

## MODQ - Moderator Queue

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-MODQ-001 | View flagged content | Display | Page load | GET /api/moderation/queue | Flagged items list | US-M001 | GO-001 | F-AUTH-001 | MVP | 4 | 2025-12-25 |
| F-MODQ-002 | Filter by type | Action | Select type | Filter items | Type dropdown | US-M001 | GO-001 | F-MODQ-001 | MVP | 1 | 2025-12-25 |
| F-MODQ-003 | View item detail | Action | Click item | Open detail panel | Item row | US-M001 | GO-001 | F-MODQ-001 | MVP | 2 | 2025-12-25 |
| F-MODQ-004 | Approve content | Action | Click Approve | PATCH /api/moderation/:id/approve | Approve button | US-M002 | GO-001 | F-MODQ-003 | MVP | 1 | 2025-12-25 |
| F-MODQ-005 | Remove content | Action | Click Remove | PATCH /api/moderation/:id/remove | Remove button | US-M002 | GO-001 | F-MODQ-003 | MVP | 1 | 2025-12-25 |
| F-MODQ-006 | Warn user | Action | Click Warn | POST /api/moderation/:id/warn | Warn button | US-M002 | GO-001 | F-MODQ-003 | MVP | 2 | 2025-12-25 |
| F-MODQ-007 | Add decision notes | Action | Type notes | Save with action | Notes field | US-M003 | GO-001 | F-MODQ-003 | MVP | 1 | 2025-12-25 |
| F-MODQ-008 | View decision history | Display | Click History | Show past decisions | History tab | US-M003 | GO-001 | F-MODQ-001 | MVP | 2 | 2025-12-25 |

---

## Block 8 Summary

| Page | Features | Hours |
|------|----------|-------|
| ADMN | 5 | 10 |
| AUSR | 10 | 21 |
| ACRS | 9 | 19 |
| AENR | 7 | 16 |
| ASES | 7 | 16 |
| ACRT | 8 | 17 |
| APAY | 7 | 15.5 |
| ACAT | 5 | 11 |
| MODQ | 8 | 14 |
| **Total** | **66** | **139.5** |
