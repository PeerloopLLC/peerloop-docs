# Block 3: Course Content Features

**Block:** 3
**Focus:** Course content storage, progress tracking
**Pages:** CCNT, SDSH (progress parts)

---

## CCNT - Course Content

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-CCNT-001 | View course content | Display | Page load | GET /api/courses/:id/content | Content viewer | US-S026 | GO-001 | F-ENR-001 | MVP | 4 | 2025-12-25 |
| F-CCNT-002 | Navigate lessons | Action | Click lesson | Load lesson content | Lesson nav | US-S026 | GO-001 | F-CCNT-001 | MVP | 2 | 2025-12-25 |
| F-CCNT-003 | Mark lesson complete | Action | Click Complete | PATCH /api/progress/:lessonId | Complete button | US-S027 | GO-001 | F-CCNT-001 | MVP | 2 | 2025-12-25 |
| F-CCNT-004 | View progress | Display | Page load | Show completion % | Progress bar | US-S027 | GO-001 | F-CCNT-001 | MVP | 1 | 2025-12-25 |
| F-CCNT-005 | Download resources | Action | Click Download | Fetch from R2 | Download button | US-S026 | GO-001 | F-CCNT-001 | MVP | 2 | 2025-12-25 |
| F-CCNT-007 | Video playback | Action | Play video | Stream from R2/CDN | Video player | US-S026 | GO-001 | F-CCNT-001 | MVP | 4 | 2025-12-25 |

*Note: Session booking from content (F-CCNT-006) is in Block 4.*

---

## SDSH - Student Dashboard (Progress Features)

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-SDSH-002 | View course progress | Display | Page load | Show progress % per course | Progress bars | US-S012 | GO-001 | F-SDSH-001 | MVP | 2 | 2025-12-25 |
| F-SDSH-004 | Click course card | Action | Click course | Navigate to CCNT | Course card | US-S026 | GO-001 | F-SDSH-001 | MVP | 0.5 | 2025-12-25 |
| F-SDSH-008 | Continue learning CTA | Action | Click Continue | Navigate to last accessed CCNT | Continue button | US-S026 | GO-001 | F-SDSH-002 | MVP | 1 | 2025-12-25 |

---

## Block 3 Summary

| Page | Features | Hours |
|------|----------|-------|
| CCNT | 6 | 15 |
| SDSH (progress) | 3 | 3.5 |
| **Total** | **9** | **18.5** |

---

## Infrastructure Dependencies

Block 3 requires:

| ID | Feature | Hours |
|----|---------|-------|
| F-STOR-001 | File storage (R2) | 8 |

**Block 3 Total with Infrastructure: 26.5 hours**
