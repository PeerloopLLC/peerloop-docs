# RUN-001 Feature Registry - Index

**Created:** 2025-12-25
**Purpose:** Track every feature at the page-event level with full traceability.

---

## Feature Files

Features are split by block for easier navigation:

| File | Block | Focus | Features | Hours |
|------|-------|-------|----------|-------|
| [features-block-0.md](features/features-block-0.md) | 0 | Foundation (Auth) | 22 | 35 |
| [features-block-1.md](features/features-block-1.md) | 1 | Course Display | 35 | 55.5 |
| [features-block-2.md](features/features-block-2.md) | 2 | Enrollment Flow | 7 | 16 |
| [features-block-3.md](features/features-block-3.md) | 3 | Course Content | 9 | 18.5 |
| [features-block-4.md](features/features-block-4.md) | 4 | Video Sessions | 23 | 47 |
| [features-block-5.md](features/features-block-5.md) | 5 | Community Feed | 21 | 53 |
| [features-block-6.md](features/features-block-6.md) | 6 | ST & Certification | 20 | 41.5 |
| [features-block-7.md](features/features-block-7.md) | 7 | Creator Tools | 29 | 63.5 |
| [features-block-8.md](features/features-block-8.md) | 8 | Admin | 66 | 139.5 |
| [features-block-9.md](features/features-block-9.md) | 9 | Polish | 25 | 52 |
| [features-infrastructure.md](features/features-infrastructure.md) | - | Cross-cutting | 8 | 124 |
| [features-post-mvp.md](features/features-post-mvp.md) | - | P2/P3 Deferred | 22 | 60 |

---

## Summary Statistics

| Category | Features | Hours |
|----------|----------|-------|
| Block 0-9 (MVP) | 257 | 521.5 |
| Infrastructure | 8 | 124 |
| Post-MVP | 22 | 60 |
| **Total** | **287** | **705.5** |

*Note: Infrastructure hours overlap with blocks (already counted in block totals with dependencies).*

**Estimated MVP Total:** ~554 hours (features + infrastructure, no double-counting)

---

## Schema Reference

### Feature ID Format
`F-[PAGE]-[NNN]` where PAGE is the 3-4 letter page code.

### Feature Types
| Type | Description |
|------|-------------|
| **Action** | User-triggered event |
| **Display** | Data shown to user |
| **Cosmetic** | Visual/styling element |

### Status Values
| Status | Meaning |
|--------|---------|
| `MVP` | In scope for MVP |
| `POST-MVP` | Deferred to after MVP |
| `COMPLETE` | Implementation finished |
| `ABANDONED` | Will not implement |
| `BLOCKED` | Cannot proceed |

### Column Definitions
| Column | Description |
|--------|-------------|
| **ID** | Unique feature identifier |
| **Feature** | Brief description |
| **Type** | Action / Display / Cosmetic |
| **User Action** | What user does to trigger |
| **Developer Action** | What code must do |
| **UI Element** | Component affected |
| **Stories** | User stories (US-*) |
| **Goals** | Goals (GO-*) |
| **Depends On** | Other feature IDs required |
| **Status** | Current status |
| **Hours** | Estimated effort |
| **Updated** | Date last modified |

---

## How to Use

### Find a Feature
1. Identify the block (see Block → Page mapping below)
2. Open the block file
3. Find the page section
4. Locate feature by ID or description

### Update a Feature
1. Find the feature in its block file
2. Update status, hours, or other fields
3. Update the "Updated" date

### Defer/Remove a Feature
1. Find feature in block file
2. Change status to POST-MVP or ABANDONED
3. Check "Depends On" across ALL files to find dependent features
4. Update dependent features if needed

---

## Block → Page Mapping

| Block | Pages |
|-------|-------|
| 0 | LGIN, SGUP, PWRS |
| 1 | HOME, CBRO, CDET, CRLS, CPRO |
| 2 | CDET (enrollment), SDSH (basic), CEAR (Stripe) |
| 3 | CCNT, SDSH (progress) |
| 4 | SBOK, SROM, STPR (book), TDSH (join) |
| 5 | FEED, MSGS, IFED, CPRO (follow) |
| 6 | STDR, STPR, TDSH, SDSH (certs), CPRO (creds) |
| 7 | STUD, CMST, CSES, CDSH, CEAR |
| 8 | ADMN, AUSR, ACRS, AENR, ASES, ACRT, APAY, ACAT, MODQ |
| 9 | PROF, SETT, NOTF, CANA |
| Post-MVP | CHAT, HELP, LEAD, SUBCOM, CNEW |

---

## Page → Block Lookup

| Page | Primary Block | Additional Blocks |
|------|---------------|-------------------|
| ADMN | 8 | - |
| ACAT | 8 | - |
| ACRS | 8 | - |
| ACRT | 8 | - |
| AENR | 8 | - |
| APAY | 8 | - |
| ASES | 8 | - |
| AUSR | 8 | - |
| CANA | 9 | - |
| CBRO | 1 | - |
| CCNT | 3 | 4 (book button) |
| CDSH | 7 | - |
| CDET | 1 | 2 (enrollment), 4 (ST avail), 9 (share) |
| CEAR | 7 | 2 (Stripe Connect) |
| CHAT | Post-MVP | - |
| CMST | 7 | - |
| CNEW | Post-MVP | - |
| CPRO | 1 | 5 (follow), 6 (credentials) |
| CRLS | 1 | - |
| CSES | 7 | - |
| FEED | 5 | Post-MVP (P3 features) |
| HELP | Post-MVP | - |
| HOME | 1 | - |
| IFED | 5 | - |
| LEAD | Post-MVP | - |
| LGIN | 0 | - |
| MODQ | 8 | - |
| MSGS | 5 | - |
| NOTF | 9 | - |
| PROF | 9 | - |
| PWRS | 0 | - |
| SBOK | 4 | - |
| SDSH | 2 | 3 (progress), 4 (sessions), 6 (certs) |
| SETT | 9 | 0 (password change) |
| SGUP | 0 | - |
| SROM | 4 | - |
| STDR | 6 | - |
| STPR | 6 | 4 (book button) |
| STUD | 7 | - |
| SUBCOM | Post-MVP | - |
| TDSH | 6 | 4 (join button) |

---

## Document History

| Date | Changes |
|------|---------|
| 2025-12-25 | Split into 12 block files for maintainability |
| 2025-12-25 | Initial creation with ~286 features |
