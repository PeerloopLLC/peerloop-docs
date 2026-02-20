# Page: Course Browse

**Code:** CBRO
**URL:** `/courses`
**Access:** Public
**Priority:** P0
**Status:** In Scope

---

## Purpose

Allow visitors and users to discover courses through browsing, filtering, and searching.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| HOME | "Browse Courses" CTA | Primary path |
| HOME | "View All Courses" link | From featured section |
| CDET | Back/breadcrumb | Return from course detail |
| CPRO | "View Courses" on creator profile | Filtered by creator |
| Nav | "Courses" nav link | Global navigation |
| (External) | Direct URL, search | `/courses` or `/courses?q=...` |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| CDET | Course card click | View course details |
| CPRO | Creator name/avatar click | View creator profile |
| SGUP | "Sign up to enroll" prompt | If trying to enroll while logged out |
| LGIN | "Log in" link | Returning users |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| courses | id, title, slug, thumbnail, price, rating, rating_count, level, duration, badge, student_count | Course cards |
| categories | id, name, slug | Filter options |
| course_tags | tag | Filter/search |
| users (creators) | id, name, avatar | Creator info on cards |

---

## Sections

### Header
- Page title: "Browse Courses" or "Courses"
- Search bar with placeholder text

### Filters Sidebar/Bar
- **Category:** Dropdown or checkbox list (15 categories from CD-021)
- **Level:** Beginner, Intermediate, Advanced
- **Price Range:** Slider or preset ranges (Free, $1-100, $100-500, $500+)
- **Duration:** Short (<4 weeks), Medium (4-8 weeks), Long (8+ weeks)
- Clear filters button
- Active filter pills

### Sort Options
- Relevance (default for search)
- Newest
- Most Popular (student_count)
- Highest Rated
- Price: Low to High
- Price: High to Low

### Course Grid
- Responsive grid: 3 columns desktop, 2 tablet, 1 mobile
- Course card components (see COMPONENTS.md):
  - Thumbnail with badge overlay (if applicable)
  - Title
  - Creator name + avatar
  - Rating stars + count
  - Level badge
  - Price
  - Duration

### Pagination/Load More
- Pagination or infinite scroll
- Results count: "Showing 1-12 of 48 courses"

### Empty State
- No courses match filters
- Suggestion to clear filters or browse all

---

## User Stories Fulfilled

- US-G005: Browse available courses without login
- US-S001: Find courses by category
- US-S003: Filter courses by criteria
- US-S057: Filter by difficulty level
- US-S058: Filter by category

---

## States & Variations

| State | Description |
|-------|-------------|
| Default | All courses, no filters |
| Filtered | Active filters applied, filter pills shown |
| Search Results | Query in search bar, results sorted by relevance |
| Empty Results | No courses match, show empty state |
| Loading | Skeleton cards while fetching |
| Creator Filtered | Arrived from CPRO, pre-filtered by creator |

---

## Mobile Considerations

- Filters collapse into modal/drawer (tap "Filters" button)
- Single column course cards
- Sticky search bar at top
- Sort dropdown accessible

---

## Error Handling

| Error | Display |
|-------|---------|
| Search/filter fails | "Unable to load courses. Please try again." + retry button |
| No results | Empty state with clear filters suggestion |

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `page_view` | Page load | filters_applied, search_query |
| `search` | Search submitted | query, results_count |
| `filter_applied` | Filter changed | filter_type, filter_value |
| `course_card_click` | Course clicked | course_id, position, filters_active |
| `sort_changed` | Sort option changed | sort_option |

---

## API Calls

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/courses` | Page load | Course list with pagination |
| `GET /api/courses?q=...&level=...&category=...` | Filter/search | Filtered results |
| `GET /api/categories` | Page load | Filter options |

**Query Parameters:**
- `q` - Search query
- `level` - beginner, intermediate, advanced
- `category` - Category slug
- `price_min`, `price_max` - Price range
- `sort` - newest, popular, rating, price_asc, price_desc
- `page`, `limit` - Pagination

---

## Notes

- Genesis Cohort: Only 4 courses initially, consider hiding some filters
- URL should reflect filters for shareability: `/courses?level=beginner&category=ai`
- Consider saved filters for logged-in users (future)
