# Block 4: Video Sessions Features

**Block:** 4
**Focus:** VideoProvider integration, session booking, session room
**Pages:** SBOK, SROM, CDET (ST availability), CCNT (book from content), SDSH (sessions), TDSH (join)

---

## SBOK - Session Booking

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-SBOK-001 | View ST availability | Display | Page load | GET /api/student-teachers/:id/availability | Calendar view | US-S083 | GO-001 | F-AUTH-001 | MVP | 4 | 2025-12-25 |
| F-SBOK-002 | Select time slot | Action | Click slot | Highlight selected | Calendar slot | US-S084 | GO-001 | F-SBOK-001 | MVP | 2 | 2025-12-25 |
| F-SBOK-003 | Confirm booking | Action | Click Book | POST /api/sessions | Book button | US-S084 | GO-001 | F-SBOK-002 | MVP | 3 | 2025-12-25 |
| F-SBOK-004 | Schedule Later option | Action | Click Schedule Later | Create pending enrollment | Schedule Later button | US-S085 | GO-001 | F-SBOK-001 | MVP | 2 | 2025-12-25 |
| F-SBOK-005 | Booking confirmation | Display | After booking | Show confirmation, send email | Confirmation modal | US-S086 | GO-001 | F-SBOK-003 | MVP | 2 | 2025-12-25 |
| F-SBOK-006 | View ST info | Display | Page load | Show ST profile summary | ST card | US-S083 | GO-001 | F-SBOK-001 | MVP | 1 | 2025-12-25 |
| F-SBOK-007 | Cancel booking | Action | Click Cancel | DELETE /api/sessions/:id | Cancel button | US-S084 | GO-001 | F-SBOK-003 | MVP | 2 | 2025-12-25 |

---

## SROM - Session Room

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-SROM-001 | Join session | Action | Page load | VideoProvider.getJoinUrl(), redirect/embed | Video container | US-V001 | GO-022 | F-VID-001, F-AUTH-001 | MVP | 6 | 2025-12-25 |
| F-SROM-002 | Share screen | Action | Click Share Screen | VideoProvider screen share API | Share button | US-V002 | GO-022 | F-SROM-001 | MVP | 2 | 2025-12-25 |
| F-SROM-003 | Use whiteboard | Action | Click Whiteboard | VideoProvider whiteboard feature | Whiteboard button | US-V003 | GO-022 | F-SROM-001 | MVP | 2 | 2025-12-25 |
| F-SROM-004 | Chat during session | Action | Send message | VideoProvider chat | Chat panel | US-V004 | GO-022 | F-SROM-001 | MVP | 1 | 2025-12-25 |
| F-SROM-005 | Start recording | Action | Click Record | VideoProvider.startRecording() | Record button | US-V005 | GO-022 | F-SROM-001 | MVP | 3 | 2025-12-25 |
| F-SROM-006 | Stop recording | Action | Click Stop | VideoProvider.stopRecording() | Stop button | US-V005 | GO-022 | F-SROM-005 | MVP | 1 | 2025-12-25 |
| F-SROM-007 | End session | Action | Click End | VideoProvider.endMeeting(), navigate out | End button | US-V006 | GO-022 | F-SROM-001 | MVP | 2 | 2025-12-25 |
| F-SROM-008 | Post-session rating | Action | Submit rating | POST /api/sessions/:id/rating | Rating modal | US-V007 | GO-001 | F-SROM-007 | MVP | 3 | 2025-12-25 |
| F-SROM-009 | Waiting room | Display | Before host joins | Show waiting message | Waiting screen | US-V001 | GO-022 | F-SROM-001 | MVP | 2 | 2025-12-25 |

---

## Related Features from Other Pages

### CDET - Course Detail (ST Availability)

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-CDET-009 | View ST availability | Display | Page load | Fetch STs for course | ST cards | US-S007 | GO-001 | F-CDET-001 | MVP | 2 | 2025-12-25 |

### CCNT - Course Content (Book from Content)

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-CCNT-006 | Book session from content | Action | Click Book Session | Navigate to SBOK | Book button | US-S083 | GO-001 | F-CCNT-001 | MVP | 1 | 2025-12-25 |

### SDSH - Student Dashboard (Sessions)

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-SDSH-003 | View upcoming sessions | Display | Page load | GET /api/me/sessions?upcoming=true | Session cards | US-S013 | GO-001 | F-AUTH-001 | MVP | 2 | 2025-12-25 |
| F-SDSH-005 | Click session card | Action | Click session | Navigate to SROM (if now) or SBOK | Session card | US-S013 | GO-001 | F-SDSH-003 | MVP | 1 | 2025-12-25 |

### TDSH - ST Dashboard (Join)

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-TDSH-007 | Join session | Action | Click Join | Navigate to SROM | Join button | US-V001 | GO-022 | F-TDSH-002 | MVP | 1 | 2025-12-25 |

### STPR - ST Profile (Book)

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-STPR-005 | Click Book Session (visitor) | Action | Click Book | Redirect to SGUP | Book button | US-S083 | GO-001 | F-STPR-001 | MVP | 1 | 2025-12-25 |
| F-STPR-006 | Click Book Session (logged in) | Action | Click Book | Navigate to SBOK | Book button | US-S083 | GO-001 | F-STPR-001, F-AUTH-001 | MVP | 1 | 2025-12-25 |

---

## Block 4 Summary

| Page | Features | Hours |
|------|----------|-------|
| SBOK | 7 | 16 |
| SROM | 9 | 22 |
| CDET (ST avail) | 1 | 2 |
| CCNT (book) | 1 | 1 |
| SDSH (sessions) | 2 | 3 |
| TDSH (join) | 1 | 1 |
| STPR (book) | 2 | 2 |
| **Total** | **23** | **47** |

---

## Infrastructure Dependencies

Block 4 requires:

| ID | Feature | Hours |
|----|---------|-------|
| F-VID-001 | VideoProvider interface (BBB/PlugNmeet) | 24 |

**Block 4 Total with Infrastructure: 71 hours**
