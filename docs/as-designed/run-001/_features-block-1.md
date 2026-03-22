# Block 1: Course Display Features

**Block:** 1
**Focus:** Course listing, detail, creator profiles (read-only)
**Pages:** HOME, CBRO, CDET, CRLS, CPRO

---

## HOME - Homepage

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-HOME-001 | View hero section | Display | Page load | Render hero with value prop | Hero banner | US-G001, US-G004 | GO-001 | - | MVP | 2 | 2025-12-25 |
| F-HOME-002 | View featured courses | Display | Page load | Fetch featured courses, render cards | Course cards grid | US-G002 | GO-001 | F-CBRO-001 | MVP | 3 | 2025-12-25 |
| F-HOME-003 | View featured creators | Display | Page load | Fetch featured creators, render cards | Creator cards grid | US-G003 | GO-001 | F-CRLS-001 | MVP | 2 | 2025-12-25 |
| F-HOME-004 | View testimonials | Display | Page load | Render testimonials carousel | Testimonial cards | US-G003 | GO-021 | - | MVP | 2 | 2025-12-25 |
| F-HOME-005 | Click course card | Action | Click course | Navigate to CDET | Course card | US-G005 | GO-001 | F-HOME-002 | MVP | 0.5 | 2025-12-25 |
| F-HOME-006 | Click creator card | Action | Click creator | Navigate to CPRO | Creator card | US-G008 | GO-001 | F-HOME-003 | MVP | 0.5 | 2025-12-25 |
| F-HOME-007 | Click CTA button | Action | Click "Get Started" | Navigate to SGUP | CTA button | US-G011 | GO-001 | - | MVP | 0.5 | 2025-12-25 |
| F-HOME-008 | Click Browse Courses | Action | Click nav link | Navigate to CBRO | Nav link | US-G005 | GO-001 | - | MVP | 0.5 | 2025-12-25 |

---

## CBRO - Course Browse

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-CBRO-001 | View course list | Display | Page load | GET /api/courses, render grid | Course cards grid | US-G005, US-S001 | GO-001 | - | MVP | 4 | 2025-12-25 |
| F-CBRO-002 | Filter by category | Action | Select category | Filter courses, update URL params | Category dropdown | US-G006, US-S001 | GO-001 | F-CBRO-001 | MVP | 2 | 2025-12-25 |
| F-CBRO-003 | Filter by price range | Action | Set price slider | Filter courses client-side | Price range slider | US-G006 | GO-001 | F-CBRO-001 | MVP | 2 | 2025-12-25 |
| F-CBRO-004 | Filter by rating | Action | Select min rating | Filter courses | Rating filter | US-G006 | GO-001 | F-CBRO-001 | MVP | 1 | 2025-12-25 |
| F-CBRO-005 | Search courses | Action | Type in search box | Debounced search API call | Search input | US-G007, US-S001 | GO-001 | F-CBRO-001 | MVP | 3 | 2025-12-25 |
| F-CBRO-006 | Sort courses | Action | Select sort option | Re-sort results | Sort dropdown | US-S001 | GO-001 | F-CBRO-001 | MVP | 1 | 2025-12-25 |
| F-CBRO-007 | Click course card | Action | Click course | Navigate to CDET | Course card | US-G005 | GO-001 | F-CBRO-001 | MVP | 0.5 | 2025-12-25 |
| F-CBRO-008 | Pagination | Action | Click page number | Fetch next page | Pagination controls | US-S001 | GO-001 | F-CBRO-001 | MVP | 2 | 2025-12-25 |
| F-CBRO-009 | Empty state | Display | No results | Show "No courses found" message | Empty state component | US-S001 | - | F-CBRO-001 | MVP | 1 | 2025-12-25 |
| F-CBRO-010 | Loading state | Display | Page loading | Show skeleton loaders | Skeleton cards | - | - | - | MVP | 1 | 2025-12-25 |

---

## CDET - Course Detail

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-CDET-001 | View course header | Display | Page load | GET /api/courses/:slug | Course hero section | US-S002 | GO-001 | - | MVP | 2 | 2025-12-25 |
| F-CDET-002 | View pricing | Display | Page load | Display price from course data | Price badge | US-G007, US-S002 | GO-001 | F-CDET-001 | MVP | 1 | 2025-12-25 |
| F-CDET-003 | View curriculum | Display | Page load | Render module/lesson tree | Curriculum accordion | US-S003 | GO-001 | F-CDET-001 | MVP | 3 | 2025-12-25 |
| F-CDET-004 | View instructor info | Display | Page load | Fetch creator data | Instructor card | US-S004 | GO-001 | F-CDET-001 | MVP | 2 | 2025-12-25 |
| F-CDET-005 | View reviews | Display | Page load | GET /api/courses/:id/reviews | Reviews list | US-S005 | GO-001 | F-CDET-001 | MVP | 3 | 2025-12-25 |
| F-CDET-010 | Click instructor profile | Action | Click instructor | Navigate to CPRO | Instructor card | US-G010 | GO-001 | F-CDET-004 | MVP | 0.5 | 2025-12-25 |
| F-CDET-011 | Share course | Action | Click share | Copy URL / open share modal | Share button | - | GO-001 | F-CDET-001 | MVP | 1 | 2025-12-25 |

*Note: Enrollment features (F-CDET-006 through F-CDET-009, F-CDET-012) are in Block 2.*

---

## CRLS - Creator Listing

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-CRLS-001 | View creator list | Display | Page load | GET /api/creators | Creator cards grid | US-G008 | GO-001 | - | MVP | 3 | 2025-12-25 |
| F-CRLS-002 | Filter by expertise | Action | Select category | Filter creators | Category filter | US-G009 | GO-001 | F-CRLS-001 | MVP | 2 | 2025-12-25 |
| F-CRLS-003 | Search creators | Action | Type in search | Search API call | Search input | US-G008 | GO-001 | F-CRLS-001 | MVP | 2 | 2025-12-25 |
| F-CRLS-004 | Click creator card | Action | Click creator | Navigate to CPRO | Creator card | US-G008 | GO-001 | F-CRLS-001 | MVP | 0.5 | 2025-12-25 |
| F-CRLS-005 | View creator stats | Display | Page load | Show course count, student count | Stats badges | US-G009 | GO-001 | F-CRLS-001 | MVP | 1 | 2025-12-25 |

---

## CPRO - Creator Profile

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-CPRO-001 | View creator header | Display | Page load | GET /api/creators/:handle | Profile header | US-G010 | GO-001 | - | MVP | 2 | 2025-12-25 |
| F-CPRO-002 | View creator bio | Display | Page load | Render bio content | Bio section | US-G010 | GO-001 | F-CPRO-001 | MVP | 1 | 2025-12-25 |
| F-CPRO-003 | View creator courses | Display | Page load | GET /api/creators/:id/courses | Course cards | US-G010 | GO-001 | F-CPRO-001 | MVP | 2 | 2025-12-25 |
| F-CPRO-007 | Click course card | Action | Click course | Navigate to CDET | Course card | US-G005 | GO-001 | F-CPRO-003 | MVP | 0.5 | 2025-12-25 |
| F-CPRO-008 | View student count | Display | Page load | Show total students | Stats | US-G010 | GO-001 | F-CPRO-001 | MVP | 0.5 | 2025-12-25 |

*Note: Credentials (F-CPRO-004) is Block 6, Follow (F-CPRO-005, F-CPRO-006) is Block 5.*

---

## Block 1 Summary

| Page | Features | Hours |
|------|----------|-------|
| HOME | 8 | 11 |
| CBRO | 10 | 17.5 |
| CDET | 7 | 12.5 |
| CRLS | 5 | 8.5 |
| CPRO | 5 | 6 |
| **Total** | **35** | **55.5** |
