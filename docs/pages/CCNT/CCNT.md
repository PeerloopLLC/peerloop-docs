# CCNT - Course Content

| Field | Value |
|-------|-------|
| Route | `/courses/:slug/learn` |
| Access | Authenticated (enrolled students only) |
| Priority | P0 |
| Status | ✅ Implemented |
| Block | 3 |
| Astro Page | `src/pages/courses/[slug]/learn.astro` |
| Component | `src/components/learning/CourseLearning.tsx` |
| JSON Spec | `src/data/pages/courses/[slug]/learn.json` |

---

## Purpose

Deliver course content to enrolled students, track module progress, enable self-paced learning, and provide access to resources and help features.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-S052 | As a student, I want to access enrolled course content so that I can learn | P0 | ✅ |
| US-S053 | As a student, I want to view course materials (videos, docs) so that I can study | P0 | ✅ |
| US-S054 | As a student, I want to track module progress so that I know where I am | P0 | ✅ |
| US-S055 | As a student, I want to mark modules complete so that I can track my progress | P0 | ✅ |
| US-S056 | As a student, I want to navigate between modules so that I can move through content | P0 | ✅ |
| US-S062 | As a student, I want to access "Summon Help" feature so that I can get assistance | P1 | ⏳ |
| US-S063 | As a student, I want to see helpers available so that I know if help is ready | P1 | ⏳ |
| US-S087 | As a student, I want to view homework assignments so that I know what's due | P0 | ✅ |
| US-S088 | As a student, I want to submit homework with text and/or files so that I can complete assignments | P0 | ✅ |
| US-S089 | As a student, I want to see feedback on submitted homework so that I can improve | P0 | ✅ |
| US-S090 | As a student, I want to resubmit homework if requested so that I can correct mistakes | P0 | ✅ |
| US-S091 | As a student, I want to access session recordings so that I can review | P1 | ⏳ |
| US-S092 | As a student, I want to download materials shared by ST so that I have offline access | P0 | ✅ |
| US-S093 | As a student, I want to access course-level resources so that I have all materials | P0 | ✅ |

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| SDSH | "Continue Learning" | From dashboard |
| CDET | "Start Learning" (enrolled) | From course detail |
| SROM | "Back to Course" | After session |
| NOTF | Course update notification | Content updates |

### Outgoing (users navigate to)

| Target | Trigger | Notes | Status |
|--------|---------|-------|--------|
| SBOK | "Schedule Session" | Book tutoring session | ⏳ |
| SROM | "Join Session" (if imminent) | Active session | ⏳ |
| SDSH | "Dashboard" / back | Return to dashboard | ✅ |
| CDET | "Course Info" | View course details | ✅ |
| CHAT | "Course Chat" (Block 2+) | Course community chat | ⏳ |
| HELP | "Summon Help" button (Block 2+) | Request help from ST | ⏳ |
| STPR | ST name in "Your Teacher" | View assigned ST | ⏳ |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| courses | id, title, slug | Course context |
| course_curriculum | id, title, description, duration, video_url, document_url, module_order, session_number | Content display |
| module_progress | enrollment_id, module_id, is_complete | Progress tracking |
| enrollments | id, student_teacher_id | Enrollment status |
| sessions | scheduled_start | Upcoming session reminder |
| users (ST) | name, avatar | Assigned teacher |
| user_availability | is_available | Helpers online (Block 2+) |
| homework_assignments | id, title, instructions, due_within_days, is_required | Homework display |
| homework_submissions | id, status, submitted_at, feedback | Student submissions |
| session_resources | id, name, type, r2_key | Course resources |

---

## Features

### Module Navigation
- [x] Module sidebar with all modules `[US-S056]`
- [x] Completion checkboxes `[US-S054]`
- [x] Current module highlighted `[US-S056]`
- [x] Progress indicators `[US-S054]`
- [ ] Session grouping (if applicable) `[US-S056]`

### Content Viewer
- [x] Module title and duration `[US-S052]`
- [x] Video embeds (YouTube, Vimeo) `[US-S053]`
- [x] Document links (external) `[US-S053]`
- [x] Module description and content `[US-S052]`
- [ ] Learning objectives `[US-S052]`

### Progress Tracking
- [x] Mark complete checkbox `[US-S055]`
- [x] Progress bar in header `[US-S054]`
- [x] Previous/Next module navigation `[US-S056]`

### Homework Tab
- [x] Assignment list with status `[US-S087]`
- [x] Assignment details (expanded) `[US-S087]`
- [x] Text submission area `[US-S088]`
- [x] File attachment option `[US-S088]`
- [x] Submit button `[US-S088]`
- [x] View past submissions `[US-S089]`
- [x] See feedback from ST/Creator `[US-S089]`
- [x] Resubmit if requested `[US-S090]`

### Resources Tab
- [x] Resource list (slides, docs, files) `[US-S093]`
- [x] Grouped by type `[US-S093]`
- [x] Download buttons `[US-S092]`
- [ ] Session recordings `[US-S091]`

### Summon Help (Block 2+)
- [ ] Floating "Summon Help" button `[US-S062]`
- [ ] Online helpers count `[US-S063]`
- [ ] Opens HELP modal `[US-S062]`

---

## Sections

### Header Bar
- Course title
- Progress bar (% complete)
- "Dashboard" link → SDSH
- "Schedule Session" → SBOK

### Sidebar / Navigation Panel
- **Tab Navigation:**
  - "Modules" tab (default)
  - "Homework" tab
  - "Resources" tab
- **Module List (Modules tab):**
  - All modules in order
  - Completion checkboxes
  - Current module highlighted
  - Session grouping (if applicable)
  - Progress indicators
- **Your Teacher:**
  - Assigned ST avatar + name
  - "Message" button → MSGS
  - Next session reminder (if scheduled)
- **Quick Actions:**
  - "Schedule Session" → SBOK
  - "Course Info" → CDET

### Content Area
- **Module Header:**
  - Module title
  - Duration
  - Session number (if grouped)
- **Learning Objectives:**
  - What you'll learn in this module
- **Video Player (if video_url):**
  - Embedded video (YouTube/Vimeo)
  - Playback controls
  - Speed adjustment
- **Document Link (if document_url):**
  - Link to external doc (Google Docs, Notion)
  - Opens in new tab
- **Module Content:**
  - Description text
  - Topics covered
  - Hands-on exercise description
- **Mark Complete:**
  - Checkbox: "I've completed this module"
  - Progress updates on check
- **Navigation:**
  - "Previous Module" / "Next Module" buttons

### Homework Tab
- **Assignment List:**
  - All homework assignments for course
  - Each shows: Title, Required/Optional badge, Due date, Status, Points
  - Click to expand assignment details
- **Assignment Detail (Expanded):**
  - Full instructions
  - Module reference (if module-specific)
  - File attachment option
  - Text submission area
  - "Submit" button
- **Submitted Work:**
  - View past submissions
  - See feedback from ST/Creator
  - Resubmit if requested

### Resources Tab
- **Resource List:**
  - Course-level resources (slides, docs, files)
  - Grouped by type: Videos, Documents, Other
  - Each shows: Icon, Name, File size, Upload date
  - "Download" button for each
- **Session Recordings:**
  - Past session recordings (if available)
  - Each shows session date, duration
  - "Watch Recording" → opens player or downloads

### Summon Help Button (Block 2+)
- Floating button: "Summon Help"
- Shows online helpers count: "3 available"
- Opens HELP modal when clicked

### Progress Summary (Bottom/Footer)
- Overall progress: X of Y modules complete
- "Continue to Next Module" or "You've completed all modules!"
- Certificate prompt when done

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/courses/:course_id` | GET | Course info | ✅ |
| `/api/courses/:course_id/curriculum` | GET | All modules | ✅ |
| `/api/enrollments?course_id=:course_id` | GET | Enrollment + ST info | ✅ |
| `/api/enrollments/:enrollment_id/progress` | GET | Module progress | ✅ |
| `/api/enrollments/:enrollment_id/progress` | POST | Update module progress | ✅ |
| `/api/sessions?course_id=:course_id&upcoming=true&limit=1` | GET | Next session reminder | ⏳ |
| `/api/helpers/available?course_id=:course_id` | GET | Available helper count | ⏳ |
| `/api/courses/:course_id/homework` | GET | List homework assignments | ✅ |
| `/api/homework/:id` | GET | Assignment details | ✅ |
| `/api/homework/:id/submissions/me` | GET | My submission status | ✅ |
| `/api/homework/:id/submit` | POST | Submit homework | ✅ |
| `/api/submissions/:id` | PUT | Update submission | ✅ |
| `/api/courses/:course_id/resources` | GET | Course resources list | ✅ |
| `/api/resources/:id` | GET | Get download URL | ✅ |

**Curriculum Response:**
```typescript
GET /api/courses/:course_id/curriculum
{
  modules: [{
    id, title, description, duration,
    video_url, document_url,
    module_order, session_number
  }]
}
```

**Progress Update:**
```typescript
POST /api/enrollments/:enrollment_id/progress
{
  module_id: string,
  is_complete: boolean
}
// Returns updated progress summary
```

**Progress Response:**
```typescript
GET /api/enrollments/:enrollment_id/progress
{
  modules: [{ module_id, is_complete }],
  summary: { completed: number, total: number, percent: number }
}
```

---

## States & Variations

| State | Description | Status |
|-------|-------------|--------|
| In Progress | Modules partially complete, current highlighted | ✅ |
| Not Started | First visit, start at module 1 | ✅ |
| Complete | All modules done, certificate prompt | ✅ |
| Module View | Viewing specific module content | ✅ |
| Video Playing | Video player active | ✅ |
| Session Imminent | "Join Session" banner if within 15 min | ⏳ |

---

## Error Handling

| Error | Display |
|-------|---------|
| Not enrolled | "You must be enrolled. [Enroll now]" → CDET |
| Content load fails | "Unable to load content. [Retry]" |
| Video fails | "Video unavailable. Try external link." |
| Progress save fails | "Unable to save progress. Trying again..." |

---

## Mobile Considerations

- Sidebar becomes bottom sheet or hamburger menu
- Video player full-width
- Mark complete is prominent
- Module navigation via swipe or buttons
- Floating Summon Help accessible

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `page_view` | Page load | course_id, module_id |
| `module_viewed` | Module accessed | module_id, time_spent |
| `module_completed` | Marked complete | module_id |
| `video_played` | Video started | module_id, video_url |
| `video_completed` | Video watched >90% | module_id |
| `summon_help_clicked` | Summon clicked | module_id, helpers_count |
| `session_scheduled` | Schedule clicked | course_id |

---

## Implementation Notes

- Requires enrollment
- Video embeds support YouTube and Vimeo
- Resources downloadable from R2 storage
- Homework submissions with feedback workflow
- CD-019: External LMS content (videos/docs hosted externally)
- Progress is self-reported (checkbox model)
- Consider video progress tracking (pause/resume points)
- Certificate prompt when all modules complete
- Block 2+: Summon Help is goodwill-based feature

---

## Verification Notes

**Verified:** 2026-01-07 (Visual + Code + Enrollment Flow)

**Consolidated:** 2026-01-08
- JSON spec updated to match verified implementation
- 6 discrepancies documented in JSON `_discrepancies` section

### Bug Fixed During Verification

**Issue:** Page returned 503 "Service unavailable" on MBA-2017
**Cause:** `learn.astro` checked for native D1 binding instead of using `getDB()` with REST fallback
**Fix:** Updated to use `getDB(Astro.locals)` - commit pending

### Features Verified (Visual)

| Feature | Status | Notes |
|---------|--------|-------|
| Breadcrumb navigation | ✅ | My Learning > Course > Learn |
| Progress bar | ✅ | Shows 0% with module count |
| Module sidebar | ✅ | 8 modules listed |
| Current module highlight | ✅ | Module 1 selected |
| Tabs (Modules/Homework/Resources) | ✅ | All visible |
| Module title & duration | ✅ | "20 min" shown |
| Module description | ✅ | Visible |
| Mark Complete button | ✅ | Primary action |
| Next navigation | ✅ | "Next >" link |
| Creator info | ✅ | Shows Guy Rymberg |
| View Course Details link | ✅ | Links to CDET |

### Test Context

- User: Jennifer Kim (student)
- Course: Vibe Coding 101
- Enrollment: Created via Stripe checkout + webhook
- All 8 modules loaded from curriculum

### Screenshots

| File | Date | Description |
|------|------|-------------|
| `CCNT-2026-01-07-modules.png` | 2026-01-07 | Module 1 view with sidebar |
