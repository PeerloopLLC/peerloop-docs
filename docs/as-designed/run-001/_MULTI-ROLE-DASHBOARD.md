# Multi-Role Dashboard Design

**Created:** 2025-12-25
**Purpose:** Define how `/dashboard` adapts when users hold multiple roles.

---

## Problem Statement

Users can hold multiple roles simultaneously:
- Student (S) - base role for all authenticated users
- Teacher (T) - certified to teach specific courses
- Creator (C) - creates and manages courses
- Moderator (M) - moderates course communities

A user who is S+T+C needs a dashboard that serves all three contexts without overwhelming them.

---

## Approach: Horizontal Sections

**Decision:** Start with horizontal sections on the dashboard screen, one per role. These can evolve into:
- Accordion sections (collapsed by default)
- Tabs (role as tab, content as panel)
- Sidebar navigation within dashboard

### Section Layout

```
┌─────────────────────────────────────────────────────┐
│ Dashboard                                    [user] │
├─────────────────────────────────────────────────────┤
│                                                     │
│ ┌─────────────────────────────────────────────────┐ │
│ │ 📚 My Learning (Student Section)                │ │
│ │ - Enrolled courses with progress                │ │
│ │ - Upcoming sessions                             │ │
│ │ - Recent activity                               │ │
│ └─────────────────────────────────────────────────┘ │
│                                                     │
│ ┌─────────────────────────────────────────────────┐ │
│ │ 🎓 My Teaching (Teacher Section)        │ │  ← Only if user is Teacher
│ │ - Upcoming teaching sessions                    │ │
│ │ - Student requests                              │ │
│ │ - Earnings summary                              │ │
│ └─────────────────────────────────────────────────┘ │
│                                                     │
│ ┌─────────────────────────────────────────────────┐ │
│ │ 🎨 My Courses (Creator Section)                 │ │  ← Only if user is Creator
│ │ - Course performance                            │ │
│ │ - Recent enrollments                            │ │
│ │ - [Go to Studio] button                         │ │
│ └─────────────────────────────────────────────────┘ │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## Section Definitions

### 📚 My Learning (Student Section)

**Visible to:** All authenticated users (everyone is a student)

| Widget | Content | Data Source |
|--------|---------|-------------|
| Enrolled Courses | Course cards with progress % | `enrollments` + `progress` |
| Upcoming Sessions | Next 3 booked sessions | `sessions` where student_id = user |
| Continue Learning | Last accessed course | `progress.last_accessed_at` |
| Certificates | Recent achievements | `certificates` |

**Actions:**
- "Browse Courses" → CBRO
- "View All Courses" → filtered SDSH
- Click course → CCNT

---

### 🎓 My Teaching (Teacher Section)

**Visible to:** Users with Teacher role for at least one course

| Widget | Content | Data Source |
|--------|---------|-------------|
| Today's Sessions | Sessions scheduled today | `sessions` where st_id = user |
| Pending Requests | Booking requests awaiting response | `session_requests` |
| This Week's Earnings | Sum of session earnings | `sessions` + `payment_splits` |
| Student Queue | Students waiting to book | `enrollments` in Teacher's courses |

**Actions:**
- "Set Availability" → SETT or calendar modal
- "View All Sessions" → CSES (shared with Creator)
- Click session → SROM

---

### 🎨 My Courses (Creator Section)

**Visible to:** Users with Creator role

| Widget | Content | Data Source |
|--------|---------|-------------|
| Course Performance | Enrollment + revenue per course | `courses` + `enrollments` |
| Recent Enrollments | Last 5 enrollments | `enrollments` |
| Pending Payouts | Amount awaiting payout | `payment_splits` |
| Quick Actions | Create course, view studio | Links |

**Actions:**
- "Go to Studio" → STUD
- "Create Course" → course creation flow
- "View Analytics" → CANA

---

### 🛡️ Moderation (Moderator Section)

**Visible to:** Users with Moderator role

| Widget | Content | Data Source |
|--------|---------|-------------|
| Pending Items | Count of items needing review | `moderation_queue` |
| Recent Actions | Last 5 moderation actions | `moderation_log` |

**Actions:**
- "Open Queue" → MODQ

---

## Section Ordering

Sections appear in this order (top to bottom):
1. **My Learning** - Always first (everyone is a student)
2. **My Teaching** - If Teacher role
3. **My Courses** - If Creator role
4. **Moderation** - If Moderator role

---

## Mobile Considerations

On mobile, sections become:
1. **Stacked cards** - Each section is a collapsible card
2. **Bottom navigation** could include role switcher
3. **Swipe between sections** as alternative to scrolling

---

## Future Evolution

### Option A: Accordion Sections
- Sections collapsed by default
- User expands section they want to focus on
- Last expanded section remembered

### Option B: Tab-Based
- Horizontal tabs at top: "Learning" | "Teaching" | "Courses"
- Only relevant tabs shown
- Content panel shows selected tab

### Option C: Sidebar Navigation
- Left sidebar with role sections
- Main area shows selected section content
- More traditional dashboard layout

**Recommendation:** Start with horizontal sections (simplest). Gather user feedback. Migrate to tabs if users prefer focus over overview.

---

## Implementation Notes

### Single URL, Multiple Sections
```
GET /dashboard
→ Check user roles
→ Render sections for each role
→ Pass role-specific data to each section component
```

### Component Structure
```
<Dashboard>
  <StudentSection />           // Always rendered
  {isTeacher && <TeacherSection />}
  {isCreator && <CreatorSection />}
  {isModerator && <ModeratorSection />}
</Dashboard>
```

### Data Loading
- Load all sections in parallel (Promise.all)
- Each section is independently cacheable
- Show skeleton loading per section

---

## Relationship to Existing Pages

| Current Page | New Role | Notes |
|--------------|----------|-------|
| SDSH | StudentSection | Core student content |
| TDSH | TeacherSection | Teaching-focused content |
| CDSH | CreatorSection | Course management content |

**These pages may become:**
- Expanded versions of dashboard sections
- Or deprecated in favor of unified dashboard

**Recommendation:** Keep separate pages for deep-dive but dashboard sections for overview.

---

## Document History

| Date | Changes |
|------|---------|
| 2025-12-25 | Initial design based on horizontal sections approach |
