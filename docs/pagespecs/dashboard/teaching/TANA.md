# Page: ST Analytics

**Code:** TANA
**URL:** `/dashboard/teaching/analytics`
**Access:** Authenticated (Student-Teacher role)
**Priority:** P1
**Status:** In Scope

---

## Purpose

Provide Student-Teachers with performance analytics: earnings trends, session patterns, student completion metrics, and performance comparisons over time.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| TDSH | "View Analytics" link | From ST dashboard stats section |
| CEAR | "View Trends" link | From earnings detail |
| Nav | "Analytics" link | ST navigation |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| CEAR | "View Full Earnings" | To earnings detail |
| CSES | "View Sessions" | To session history |
| CMST | "View Students" | To student list |
| TDSH | Back/breadcrumb | Return to dashboard |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| payment_splits | amount_cents, created_at (where recipient_type = 'st') | Earnings time series |
| video_sessions | scheduled_at, status, actual_duration_minutes, rating | Session trends and metrics |
| enrollments | status, progress_percent, enrolled_at, completed_at | Student completion metrics |
| student_teachers | rating, rating_count, certified_at | ST profile metrics |
| courses | id, title | Course filter |

---

## Sections

### Header
- Page title: "Analytics"
- Period selector: 7 days / 30 days / 90 days / 1 year / All time
- Course filter dropdown (if ST teaches multiple courses)

### Key Metrics Cards (4-card row)
- **Earnings** - Period earnings with % change vs previous period
- **Sessions** - Sessions completed with % change
- **Students** - Active students count
- **Rating** - Average rating with trend indicator

### Earnings Trend Chart
- Line/area chart: Earnings over time
- Daily/weekly/monthly granularity based on period
- Tooltip with exact amounts
- Uses AreaChart component from CANA

### Sessions Trend Chart
- Line chart: Sessions over time
- Shows completed sessions count
- Cancellation rate as secondary metric
- Uses AreaChart component

### Student Progress Distribution
- Pie/donut chart: Students by progress stage
- Segments:
  - Not Started (0%)
  - Getting Started (1-25%)
  - Making Progress (25-50%)
  - Halfway There (50-75%)
  - Almost Done (75-99%)
  - Completed (100%)
- Uses PieChart component from CANA

### Session Patterns
- Bar chart: Sessions by day of week
- Helps S-T identify popular teaching times
- Uses BarChart component from CANA

### Performance Summary (4-metric grid)
- **Avg Completion Time** - Days from first session to completion
- **Sessions per Student** - Average sessions before completion
- **Completion Rate** - % of students who complete
- **Session Completion Rate** - % of scheduled sessions completed (not cancelled)

---

## User Stories Fulfilled

- US-ST-040: View teaching performance trends
- US-ST-041: Track earnings over time
- US-ST-042: Understand student progress patterns
- US-ST-043: Identify best teaching times

---

## States & Variations

| State | Description |
|-------|-------------|
| Default | Last 30 days, all courses |
| Filtered | By period or specific course |
| New ST | Limited data message with encouragement |
| Loading | Skeleton charts during fetch |
| Error | Failed to load with retry option |

---

## Mobile Considerations

- Metric cards in 2x2 grid
- Charts stack vertically (full width)
- Period selector as dropdown (not tabs)
- Touch-friendly chart interactions
- Simplified tooltips

---

## Error Handling

| Error | Display |
|-------|---------|
| Load fails | "Unable to load analytics. [Retry]" |
| No data for period | "No activity in this period. Try a longer range." |

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `page_view` | Page load | period, course_filter |
| `period_changed` | Period selector change | new_period |
| `course_filtered` | Course filter change | course_id |

---

## Server Integration

### API Endpoints Called

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/me/st-analytics` | Page load | Summary metrics |
| `GET /api/me/st-analytics/earnings` | Page load | Earnings time series |
| `GET /api/me/st-analytics/sessions` | Page load | Session stats + patterns |
| `GET /api/me/st-analytics/students` | Page load | Progress distribution |

### Summary Endpoint Response

```typescript
// GET /api/me/st-analytics?period=30d&courseId=optional
{
  period: '30d',
  metrics: {
    total_earnings: 125000,       // cents
    earnings_change: 15.2,        // % vs previous period
    sessions_completed: 24,
    sessions_change: 8.5,         // % vs previous period
    active_students: 12,
    average_rating: 4.8,
    total_ratings: 18
  }
}
```

### Earnings Time Series Response

```typescript
// GET /api/me/st-analytics/earnings?period=30d
{
  period: '30d',
  data: [
    { date: '2026-01-01', earnings: 5000 },
    { date: '2026-01-02', earnings: 7500 },
    // ...
  ]
}
```

### Sessions Endpoint Response

```typescript
// GET /api/me/st-analytics/sessions?period=30d
{
  period: '30d',
  metrics: {
    total_sessions: 28,
    completed_sessions: 24,
    cancelled_sessions: 4,
    completion_rate: 85.7,
    avg_duration_minutes: 52,
    total_duration_hours: 20.8
  },
  sessions_by_day: [
    { name: 'Sun', value: 2 },
    { name: 'Mon', value: 5 },
    { name: 'Tue', value: 6 },
    { name: 'Wed', value: 4 },
    { name: 'Thu', value: 5 },
    { name: 'Fri', value: 3 },
    { name: 'Sat', value: 3 }
  ]
}
```

### Students Progress Response

```typescript
// GET /api/me/st-analytics/students?courseId=optional
{
  distribution: [
    { name: 'Not Started', value: 2, color: '#e5e7eb' },
    { name: '1-25%', value: 3, color: '#fef3c7' },
    { name: '25-50%', value: 4, color: '#fde68a' },
    { name: '50-75%', value: 2, color: '#fcd34d' },
    { name: '75-99%', value: 1, color: '#a3e635' },
    { name: 'Completed', value: 5, color: '#22c55e' }
  ],
  total: 17,
  performance: {
    avg_completion_days: 45,
    avg_sessions_per_student: 8,
    completion_rate: 29.4
  }
}
```

---

## Component Structure

```
STAnalytics.tsx
├── Header (title + filters)
│   ├── DateRangeSelector (reused from CANA)
│   └── Course filter dropdown
├── MetricsRow (4 cards)
│   └── MetricCard x4 (earnings, sessions, students, rating)
├── Charts Grid
│   ├── EarningsTrendChart (AreaChart)
│   └── StudentProgressChart (PieChart)
├── SessionAnalytics (reused from CANA)
│   ├── Session metrics grid
│   └── Sessions by day (BarChart)
└── PerformanceSummary
    └── 4-metric grid (completion times, rates)
```

---

## Implementation Notes

- **Simpler than CANA** - S-Ts have fewer dimensions (no course-level breakdown, no S-T leaderboard)
- **Reuses chart components** - AreaChart, BarChart, PieChart, DateRangeSelector from CANA
- **Reuses analytics components** - MetricsRow pattern, SessionAnalytics component
- **Future enhancements:**
  - Goal-setting feature ("Earn $X this month")
  - Rating history trend (needs rating_history table)
  - Comparison to platform average
  - Student retention analysis

---

## Difference from CANA (Creator Analytics)

| Feature | CANA (Creator) | TANA (S-T) |
|---------|----------------|------------|
| Revenue source | Course sales (15%) | Teaching sessions (70%) |
| Course view | Multiple courses breakdown | Single role, maybe multiple |
| S-T leaderboard | Yes (views their S-Ts) | No |
| Funnel analysis | Yes (views → enrollments → completions) | No |
| Session analytics | Aggregate for all S-Ts | Personal sessions only |
| Student progress | All course students | Only assigned students |

---

## Notes

- S-T gets 70% commission (vs Creator's 15% royalty)
- Rating trend feature deferred (needs schema change)
- Consider adding comparison to other S-Ts teaching same course (anonymized)
