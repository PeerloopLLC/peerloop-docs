# Page: Creator Listing

**Code:** CRLS
**URL:** `/creators`
**Access:** Public
**Priority:** P0
**Status:** In Scope

---

## Purpose

Allow visitors to discover and browse course creators, building trust and enabling creator-first discovery.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| HOME | "Meet Our Creators" link | From homepage |
| Nav | "Creators" nav link | Global navigation |
| CPRO | Back/breadcrumb | Return from creator profile |
| (External) | Direct URL | `/creators` |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| CPRO | Creator card click | View creator profile |
| CDET | Course link on creator card | Direct to course (if shown) |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| users (creators) | id, name, handle, avatar, title, bio_short | Creator cards |
| user_expertise | tag | Expertise tags on cards |
| user_stats | students_taught, courses_created, average_rating | Stats display |
| courses | count per creator | Course count badge |

---

## Sections

### Header
- Page title: "Our Creators" or "Meet the Experts"
- Subtitle: Brief explanation of creator role

### Search
- Search by name or expertise
- Placeholder: "Search by name or expertise..."

### Filter Options
- **Expertise Area:** Tag-based filtering
- **Sort:** Most Students, Highest Rated, Newest, A-Z

### Creator Grid
- Responsive grid: 3 columns desktop, 2 tablet, 1 mobile
- Creator card:
  - Avatar (large, circular)
  - Name
  - Title
  - Short bio (truncated)
  - Expertise tags (top 3)
  - Stats row: X students, Y courses, Z rating
  - "View Profile" link → CPRO

### Pagination
- Show 12-24 creators per page
- Page numbers or load more

### Empty State
- No creators match search/filter
- "Try a different search term"

---

## User Stories Fulfilled

- US-S004: Discover creators before choosing courses
- US-G008: Browse creators as a visitor

---

## States & Variations

| State | Description |
|-------|-------------|
| Default | All creators, sorted by popularity |
| Filtered | Active expertise filter |
| Search Results | Searching by name/expertise |
| Empty | No results, show empty state |

---

## Mobile Considerations

- Single column cards
- Search sticky at top
- Filters in collapsible section

---

## Error Handling

| Error | Display |
|-------|---------|
| Load fails | "Unable to load creators. Please try again." |
| No results | Empty state with suggestion |

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `page_view` | Page load | filters, search_query |
| `search` | Search submitted | query |
| `creator_click` | Creator card clicked | creator_id, position |

---

## API Calls

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/creators` | Page load | Creator list with stats |
| `GET /api/creators?q=...&expertise=...` | Filter/search | Filtered results |

**Query Parameters:**
- `q` - Search by name or expertise
- `expertise` - Filter by expertise tag
- `sort` - students, rating, newest, name
- `page`, `limit` - Pagination

---

## Notes

- Genesis Cohort: Only 3 creators initially (per CD-008)
- May want to highlight "Featured Creator" or sort by activity
