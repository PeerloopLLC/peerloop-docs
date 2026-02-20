# Page: Admin Analytics

**Code:** AANA
**URL:** `/admin/analytics`
**Access:** Admin only
**Priority:** P1
**Status:** In Scope

---

## Purpose

Provide platform administrators with comprehensive analytics for monitoring app effectiveness, profitability, and growth metrics to inform business decisions and marketing strategy.

---

## Key Business Questions Answered

1. **Is the platform profitable?** → Revenue trends, platform take, payout ratios
2. **Is the flywheel working?** → Student → S-T conversion rate
3. **Are courses effective?** → Completion rates, time to complete
4. **Is the platform growing?** → User growth, enrollment trends
5. **Are creators successful?** → Creator revenue, course performance
6. **Where should we invest?** → Category performance, top courses

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| ADMN | "View Analytics" link | From admin dashboard |
| Nav | "Analytics" link | Admin navigation |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| ADMN | Back/breadcrumb | Return to dashboard |
| AUSR | "View Users" | Drill into user data |
| ACRS | "View Courses" | Drill into course data |
| APAY | "View Payouts" | Drill into payout data |

---

## Sections

### Header
- Page title: "Platform Analytics"
- Period selector: 7d / 30d / 90d / 1y / All time
- Export button (future): CSV/PDF export

### Executive Summary Cards (5 KPIs)

| Metric | Description | Target |
|--------|-------------|--------|
| **Total Revenue** | Gross platform revenue | Growth |
| **Platform Take** | 15% platform share | $X/month |
| **Active Users** | Monthly active users | Growth |
| **Completion Rate** | % enrollments completed | ≥75% |
| **Flywheel Rate** | Students becoming S-Ts | 10-20% |

### Revenue & Profitability Section

**Revenue Trend Chart (AreaChart)**
- Gross revenue over time
- Daily/weekly/monthly based on period
- Optional: Stacked by category

**Revenue Distribution (PieChart)**
```
Platform: 15%
Creator Royalties: 15%
S-T Commissions: 70%
```

**Financial Metrics Table**

| Metric | Value | Change |
|--------|-------|--------|
| Gross Revenue | $X | +Y% |
| Platform Revenue | $X | +Y% |
| Avg Order Value | $X | +Y% |
| Total Payouts | $X | +Y% |
| Pending Payouts | $X | - |

### User Growth & Acquisition Section

**User Growth Chart (AreaChart)**
- New signups over time
- Cumulative users line overlay

**User Funnel (FunnelChart)**
```
Signups:        1,000  (100%)
Enrolled:         400  (40%)
Completed:        300  (75% of enrolled)
Became S-T:        45  (15% of completed)
```

**Role Distribution (PieChart)**
- Students only
- Student-Teachers
- Creators
- Multi-role (Creator + S-T)
- Admins/Mods

### Course & Creator Metrics Section

**Courses Over Time (AreaChart)**
- New courses published
- Cumulative active courses

**Top Courses Table**

| Course | Creator | Revenue | Enrollments | Completion | Rating |
|--------|---------|---------|-------------|------------|--------|
| ... | ... | $X | N | X% | 4.8 |

**Top Creators Table**

| Creator | Courses | Revenue | Students | Avg Rating |
|---------|---------|---------|----------|------------|
| ... | N | $X | N | 4.8 |

**Category Performance (BarChart)**
- Revenue by category
- Horizontal bars, sorted by revenue

### Student-Teacher Pipeline Section

**S-T Growth Chart (AreaChart)**
- New certifications over time
- Active vs inactive S-Ts

**S-T Conversion Funnel (FunnelChart)**
```
Completed Course:    300
Recommended by S-T:  120  (40%)
Creator Certified:    60  (50%)
Active Teaching:      45  (75%)
```

**Flywheel Health Metric**
```
New Students (30d):     100
New S-Ts (30d):          12
Flywheel Rate:          12%  ✅ Target: 10-20%
```

**S-T Leaderboard Table**

| S-T | Course | Students | Sessions | Rating | Revenue |
|-----|--------|----------|----------|--------|---------|
| ... | ... | N | N | 4.9 | $X |

### Engagement & Effectiveness Section

**Session Metrics Cards**

| Metric | Value |
|--------|-------|
| Total Sessions | N |
| Completed | N (X%) |
| Cancelled | N (X%) |
| Avg Duration | Xm |
| Total Hours | Xh |

**Sessions Trend (AreaChart)**
- Sessions over time
- Completed vs cancelled

**Completion Rate Trend (AreaChart)**
- Platform-wide completion % over time
- Target line at 75%

**Progress Distribution (PieChart)**
- Not Started
- 1-25%
- 25-50%
- 50-75%
- 75-99%
- Completed

**Time to Completion**
- Average days from enrollment to completion
- Distribution histogram (future)

### Marketing Metrics Section (Future/Phase 2)

*Requires additional tracking integration*

| Metric | Source | Status |
|--------|--------|--------|
| Traffic by Source | PostHog/UTM | Planned |
| Signup Conversion | PostHog | Planned |
| CAC | Ad platforms | Future |
| LTV | Internal calc | Future |
| LTV:CAC | Derived | Future |

---

## API Endpoints

### Summary Endpoint

```typescript
// GET /api/admin/analytics?period=30d
{
  period: '30d',
  kpis: {
    total_revenue: 450000,        // cents
    revenue_change: 12.5,         // %
    platform_take: 67500,         // cents (15%)
    platform_take_change: 12.5,
    active_users: 850,            // MAU
    active_users_change: 8.2,
    completion_rate: 72.5,        // %
    completion_rate_change: 2.1,
    flywheel_rate: 14.2,          // %
    flywheel_rate_change: 1.5
  }
}
```

### Revenue Endpoint

```typescript
// GET /api/admin/analytics/revenue?period=30d
{
  period: '30d',
  trend: [
    { date: '2026-01-01', revenue: 15000 },
    // ...
  ],
  distribution: {
    platform: 67500,
    creator: 67500,
    st: 315000
  },
  metrics: {
    gross_revenue: 450000,
    avg_order_value: 45000,      // cents
    total_payouts: 280000,
    pending_payouts: 85000
  }
}
```

### Users Endpoint

```typescript
// GET /api/admin/analytics/users?period=30d
{
  period: '30d',
  growth: [
    { date: '2026-01-01', signups: 12, cumulative: 850 },
    // ...
  ],
  funnel: [
    { name: 'Signups', value: 1000 },
    { name: 'Enrolled', value: 400 },
    { name: 'Completed', value: 300 },
    { name: 'Became S-T', value: 45 }
  ],
  distribution: [
    { name: 'Students', value: 650 },
    { name: 'Student-Teachers', value: 45 },
    { name: 'Creators', value: 12 },
    { name: 'Multi-role', value: 8 }
  ]
}
```

### Courses Endpoint

```typescript
// GET /api/admin/analytics/courses?period=30d
{
  period: '30d',
  trend: [
    { date: '2026-01-01', new_courses: 2, cumulative: 45 },
    // ...
  ],
  top_courses: [
    {
      id, title, creator_name,
      revenue: 85000,
      enrollments: 42,
      completion_rate: 78.5,
      rating: 4.8
    },
    // ...
  ],
  top_creators: [
    {
      id, name, avatar_url,
      courses: 3,
      revenue: 125000,
      students: 85,
      avg_rating: 4.7
    },
    // ...
  ],
  by_category: [
    { name: 'Programming', value: 180000 },
    { name: 'Design', value: 95000 },
    // ...
  ]
}
```

### Student-Teachers Endpoint

```typescript
// GET /api/admin/analytics/student-teachers?period=30d
{
  period: '30d',
  growth: [
    { date: '2026-01-01', new_sts: 2, cumulative: 45 },
    // ...
  ],
  funnel: [
    { name: 'Completed', value: 300 },
    { name: 'Recommended', value: 120 },
    { name: 'Certified', value: 60 },
    { name: 'Active', value: 45 }
  ],
  flywheel: {
    new_students: 100,
    new_sts: 12,
    rate: 12.0
  },
  top_sts: [
    {
      id, name, avatar_url, course_title,
      students: 18,
      sessions: 45,
      rating: 4.9,
      revenue: 42000
    },
    // ...
  ]
}
```

### Engagement Endpoint

```typescript
// GET /api/admin/analytics/engagement?period=30d
{
  period: '30d',
  sessions: {
    total: 450,
    completed: 380,
    cancelled: 70,
    completion_rate: 84.4,
    avg_duration: 52,
    total_hours: 329
  },
  session_trend: [
    { date: '2026-01-01', completed: 12, cancelled: 2 },
    // ...
  ],
  completion_trend: [
    { date: '2026-01-01', rate: 71.2 },
    // ...
  ],
  progress_distribution: [
    { name: 'Not Started', value: 50 },
    { name: '1-25%', value: 80 },
    { name: '25-50%', value: 120 },
    { name: '50-75%', value: 95 },
    { name: '75-99%', value: 55 },
    { name: 'Completed', value: 300 }
  ],
  avg_completion_days: 42
}
```

---

## Component Structure

```
AdminAnalytics.tsx
├── Header
│   ├── Title
│   ├── DateRangeSelector (reused)
│   └── Export button (future)
├── KPICards (5 cards)
├── RevenueSection
│   ├── RevenueTrendChart (AreaChart)
│   ├── RevenueDistribution (PieChart)
│   └── FinancialMetricsTable
├── UsersSection
│   ├── UserGrowthChart (AreaChart)
│   ├── UserFunnel (FunnelChart)
│   └── RoleDistribution (PieChart)
├── CoursesSection
│   ├── CourseTrendChart (AreaChart)
│   ├── TopCoursesTable
│   ├── TopCreatorsTable
│   └── CategoryPerformance (BarChart)
├── STSection
│   ├── STGrowthChart (AreaChart)
│   ├── STFunnel (FunnelChart)
│   ├── FlywheelHealthCard
│   └── STLeaderboardTable
└── EngagementSection
    ├── SessionMetricsCards
    ├── SessionTrendChart (AreaChart)
    ├── CompletionTrendChart (AreaChart)
    └── ProgressDistribution (PieChart)
```

---

## Key Metrics Definitions

| Metric | Definition | Target |
|--------|------------|--------|
| **Completion Rate** | Enrollments with status='completed' / Total enrollments | ≥75% |
| **Flywheel Rate** | New S-Ts (30d) / New students (30d) | 10-20% |
| **Platform Take** | 15% of gross revenue | - |
| **MAU** | Users with activity in last 30 days | Growth |
| **AOV** | Average order value (gross revenue / enrollments) | - |
| **Session Completion** | Completed sessions / Scheduled sessions | ≥85% |

---

## Comparison: AANA vs CANA vs TANA

| Feature | AANA (Admin) | CANA (Creator) | TANA (S-T) |
|---------|--------------|----------------|------------|
| Scope | Platform-wide | Creator's courses | Personal teaching |
| Revenue view | All revenue + splits | Creator royalties (15%) | S-T commissions (70%) |
| User metrics | All users, funnel | Course students | Assigned students |
| S-T view | All S-Ts, pipeline | S-Ts for their courses | N/A |
| Course view | All courses, categories | Own courses only | N/A |
| Funnel | Full platform funnel | Course funnel | N/A |
| Marketing | Yes (future) | No | No |

---

## Implementation Notes

- Reuses chart components from CANA (AreaChart, BarChart, PieChart, FunnelChart)
- More API endpoints than CANA due to broader scope
- Consider caching for expensive aggregations
- Marketing metrics require PostHog/UTM integration
- Export feature deferred (needs server-side PDF/CSV generation)
- Consider adding goal/target lines to charts
- Admin-only access enforced at API and page level
