# CANA - Creator Analytics

| Field | Value |
|-------|-------|
| Route | `/dashboard/creator/analytics` |
| Access | Authenticated (Creator role) |
| Priority | P1 |
| Status | 📋 Spec Only |
| Block | 8 |
| JSON Spec | `src/data/pages/dashboard/creator/analytics.json` |
| Astro Page | `src/pages/dashboard/creator/analytics.astro` |

---

## Purpose

Provide Creators with detailed analytics about their courses, student engagement, conversion rates, and revenue performance.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-C033 | As a Creator, I need to view course analytics | P1 | ⏳ |
| US-C047 | As a Creator, I need to track conversion rates | P1 | ⏳ |
| US-C048 | As a Creator, I need to monitor student engagement | P1 | ⏳ |
| US-C049 | As a Creator, I need to analyze revenue trends | P1 | ⏳ |

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| CDSH | "View Analytics" link | From dashboard |
| STUD | "Analytics" tab | From Creator Studio |
| Nav | "Analytics" link | Creator navigation |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| CDET | Course name click | View course |
| CDSH | Back/breadcrumb | Return to dashboard |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| courses | id, title, student_count, rating | Course list |
| enrollments | course_id, status, enrolled_at, completed_at | Enrollment metrics |
| sessions | course_id, status, scheduled_start | Session metrics |
| module_progress | enrollment_id, is_complete, completed_at | Progress metrics |
| certificates | course_id, type, issued_at | Completion metrics |
| transactions | enrollment_id, amount_cents, paid_at | Revenue data |

---

## Features

### Key Metrics
- [ ] Total revenue (period) `[US-C049]`
- [ ] New enrollments (period) `[US-C047]`
- [ ] Completion rate (%) `[US-C048]`
- [ ] Average rating `[US-C033]`
- [ ] Active students `[US-C048]`

### Charts & Trends
- [ ] Enrollment trends chart `[US-C047]`
- [ ] Revenue trends chart `[US-C049]`
- [ ] Comparison to previous period `[US-C033]`

### Course Performance Table
- [ ] Enrollments total/period per course `[US-C047]`
- [ ] Revenue total/period per course `[US-C049]`
- [ ] Completion rate per course `[US-C048]`

### Funnel Analysis
- [ ] Page views → Enrollments → Completions → Became ST `[US-C047]`
- [ ] Conversion rates at each step `[US-C047]`

### Progress Distribution
- [ ] Students by progress stage chart `[US-C048]`

### Session Analytics
- [ ] Sessions per week trend `[US-C033]`
- [ ] Average session duration `[US-C033]`
- [ ] No-show rate `[US-C033]`

### ST Performance
- [ ] Top STs by students taught `[US-C033]`
- [ ] Average ratings per ST `[US-C033]`

---

## Sections (from Plan)

### Header
- Page title: "Analytics"
- Date range selector (7d, 30d, 90d, 1y, custom)
- Course filter: All / specific course

### Key Metrics Row
- Total Revenue, New Enrollments, Completion Rate, Avg Rating, Active Students

### Enrollment Trends Chart
- Line/area chart with revenue overlay
- Period comparison

### Course Performance Table
- Course, Enrollments, Revenue, Completion Rate, Avg Rating, Active

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/creators/me/analytics` | GET | Aggregated analytics | ⏳ |
| `/api/creators/me/analytics/enrollments` | GET | Enrollment trends | ⏳ |
| `/api/creators/me/analytics/courses` | GET | Course performance | ⏳ |
| `/api/creators/me/analytics/funnel` | GET | Conversion metrics | ⏳ |
| `/api/creators/me/analytics/progress` | GET | Student progress distribution | ⏳ |
| `/api/creators/me/analytics/sessions` | GET | Session metrics | ⏳ |
| `/api/creators/me/analytics/export` | GET | CSV/PDF export | ⏳ |

**Query Parameters:**
- `period` - 7d, 30d, 90d, 1y, custom
- `from`, `to` - Date range for custom
- `course_id` - Filter by specific course

---

## States & Variations

| State | Description |
|-------|-------------|
| Default | All courses, last 30 days |
| Filtered | Specific course or date range |
| Comparison | Comparing to previous period |
| Empty | No data yet, "Share your courses" |

---

## Error Handling

| Error | Display |
|-------|---------|
| Load fails | "Unable to load analytics. [Retry]" |
| Partial data | Show available data with notice |

---

## Implementation Notes

- Consider caching/pre-computing metrics for performance
- Charts should be interactive (hover for details)
- Export to CSV/PDF for reporting
- Future: Cohort analysis, predictive metrics
