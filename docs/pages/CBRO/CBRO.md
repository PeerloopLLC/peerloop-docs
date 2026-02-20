# CBRO - Course Browse

| Field | Value |
|-------|-------|
| Route | `/courses` |
| Access | Public |
| Priority | P0 |
| Status | ✅ Implemented |
| Block | 1 |
| Astro Page | `src/pages/courses/index.astro` |
| Component | `src/components/courses/CourseBrowse.tsx` |
| JSON Spec | `src/data/pages/courses/index.json` |

---

## Purpose

Allow visitors and users to discover courses through browsing, filtering, and searching.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-G005 | As a visitor, I want to browse available courses without login so that I can explore content | P0 | ✅ |
| US-S001 | As a student, I want to find courses by category so that I can discover relevant content | P0 | ✅ |
| US-S003 | As a student, I want to filter courses by criteria so that I can narrow my search | P0 | ✅ |
| US-S057 | As a student, I want to filter by difficulty level so that I can find appropriate courses | P0 | ✅ |
| US-S058 | As a student, I want to filter by category so that I can find courses in my interest area | P0 | ✅ |

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

| Target | Trigger | Notes | Status |
|--------|---------|-------|--------|
| CDET | Course card click | View course details | ✅ |
| CPRO | Creator name/avatar click | View creator profile | ✅ |
| SGUP | "Sign up to enroll" prompt | If trying to enroll while logged out | ✅ |
| LGIN | "Log in" link | Returning users | ✅ |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| courses | id, title, slug, thumbnail, price, rating, rating_count, level, duration, badge, student_count | Course cards |
| categories | id, name, slug | Filter options |
| course_tags | tag | Filter/search |
| users (creators) | id, name, avatar | Creator info on cards |

---

## Features

### Search & Discovery
- [x] Course listing grid `[US-G005]`
- [x] Search with debounce `[US-S001]`
- [x] Sort dropdown (relevance, newest, popular, rating, price) `[US-S003]`

### Filtering
- [x] Category filter (radio buttons list) `[US-S058]`
- [x] Level filter (Beginner, Intermediate, Advanced) `[US-S057]`
- [ ] Price range filter (slider or preset ranges) `[US-S003]` *(not implemented)*
- [x] Duration filter (Short, Medium, Long) `[US-S003]`
- [x] Clear filters button `[US-S003]`
- [x] Active filter pills `[US-S003]`

### Display
- [x] Responsive grid: 3 columns desktop, 2 tablet, 1 mobile `[US-G005]`
- [x] Course cards with thumbnail, title, creator, rating, level, price `[US-G005]`
- [x] Badge overlay on cards (if applicable) `[US-G005]`
- [x] Pagination `[US-G005]`
- [x] Results count display `[US-G005]`

### States
- [x] Loading state (skeleton cards) `[US-G005]`
- [x] Empty state (no results with suggestions) `[US-G005]`
- [x] Mobile filter drawer `[US-S003]`

---

## Sections

### Header
- Page title: "Browse Courses" or "Courses"
- Search bar with placeholder text

### Filters Sidebar/Bar
- **Category:** Dropdown or checkbox list
- **Level:** Beginner, Intermediate, Advanced
- **Price Range:** Slider or preset ranges *(planned)*
- **Duration:** Short (<4 weeks), Medium (4-8 weeks), Long (8+ weeks) *(planned)*
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
- Course card components:
  - Thumbnail with badge overlay (if applicable)
  - Title
  - Creator name + avatar
  - Rating stars + count
  - Level badge
  - Price
  - Duration

### Pagination/Load More
- Pagination controls
- Results count: "Showing 1-12 of 48 courses"

### Empty State
- No courses match filters
- Suggestion to clear filters or browse all

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/courses` | GET | Course list with pagination | ✅ |
| `/api/categories` | GET | Filter options | ✅ |

**Query Parameters:**
- `q` - Search query
- `level` - beginner, intermediate, advanced
- `category` - Category slug
- `price_min`, `price_max` - Price range
- `sort` - newest, popular, rating, price_asc, price_desc
- `page`, `limit` - Pagination

---

## States & Variations

| State | Description | Status |
|-------|-------------|--------|
| Default | All courses, no filters | ✅ |
| Filtered | Active filters applied, filter pills shown | ✅ |
| Search Results | Query in search bar, results sorted by relevance | ✅ |
| Empty Results | No courses match, show empty state | ✅ |
| Loading | Skeleton cards while fetching | ✅ |
| Creator Filtered | Arrived from CPRO, pre-filtered by creator | ✅ |

---

## Error Handling

| Error | Display |
|-------|---------|
| Search/filter fails | "Unable to load courses. Please try again." + retry button |
| No results | Empty state with clear filters suggestion |

---

## Mobile Considerations

- Filters collapse into modal/drawer (tap "Filters" button)
- Single column course cards
- Sticky search bar at top
- Sort dropdown accessible

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

## Implementation Notes

- Client-side filtering with URL state sync
- Responsive grid: 3 → 2 → 1 columns
- URL should reflect filters for shareability: `/courses?level=beginner&category=ai`
- Genesis Cohort: Only 4 courses initially, consider hiding some filters
- Consider saved filters for logged-in users (future)

---

## Interactive Elements

### Search & Sort Controls

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| Search input | CourseBrowse | Debounced search (300ms), updates filter | ✅ Active |
| Sort dropdown | CourseBrowse | Changes sort order (popular, rating, newest, price) | ✅ Active |
| Mobile filters button | CourseBrowse | Opens filter drawer (mobile only) | ✅ Active |

### Filter Controls (Sidebar)

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| Category radio buttons (15) | FilterContent | Sets selectedCategory, resets page | ✅ Active |
| Level radio buttons (3) | FilterContent | Sets selectedLevel, resets page | ✅ Active |
| Duration radio buttons (3) | FilterContent | Sets selectedDuration, resets page | ✅ Active |
| "Clear all filters" link | FilterContent | Resets all filters and search | ✅ Active |

### Active Filter Pills

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| Category pill × button | CourseBrowse | Clears category filter | ✅ Active |
| Level pill × button | CourseBrowse | Clears level filter | ✅ Active |
| Duration pill × button | CourseBrowse | Clears duration filter | ✅ Active |
| Search query pill × button | CourseBrowse | Clears search query | ✅ Active |

### Pagination

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| Previous button | CourseBrowse | Decrements page | ✅ Active |
| Next button | CourseBrowse | Increments page | ✅ Active |
| Page number buttons | CourseBrowse | Sets specific page | ✅ Active |

### Mobile Filter Drawer

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| Backdrop click | CourseBrowse | Closes drawer | ✅ Active |
| Close (×) button | CourseBrowse | Closes drawer | ✅ Active |
| "Clear All" button | CourseBrowse | Clears filters, closes drawer | ✅ Active |
| "Apply Filters" button | CourseBrowse | Closes drawer (filters already applied) | ✅ Active |

### Empty State

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| "Clear all filters" button | CourseBrowse | Resets all filters | ✅ Active |

### Links - Course Cards

| Element | Target | Status |
|---------|--------|--------|
| Course card (entire card) | /courses/{slug} | ✅ Active |

### Links - Navigation (Header)

| Element | Target | Status |
|---------|--------|--------|
| Logo "Peerloop" | / | ✅ Active |
| "Courses" | /courses | ✅ Active (current) |
| "How It Works" | /how-it-works | ✅ Active |
| "Pricing" | /pricing | ✅ Active |
| "For Creators" | /for-creators | ✅ Active |
| User menu | (dropdown) | ✅ Active |

### Links - Footer

| Section | Links | Status |
|---------|-------|--------|
| Platform | Browse Courses, Find Creators, Find Teachers, How It Works, Pricing | ✅ Active |
| Get Involved | Become a Teacher, For Creators, Success Stories, Testimonials | ✅ Active |
| Company | About Us, Blog, Careers, Contact | ✅ Active |
| Support | FAQ, Help Center, Privacy Policy, Terms of Service | ✅ Active |
| Social | Twitter, LinkedIn, GitHub | ✅ Active |
| Bottom | Privacy, Terms, Cookies | ✅ Active |

### API Calls (triggered by interactions)

| Trigger | Endpoint | Method | Status |
|---------|----------|--------|--------|
| Page load (SSR) | `/api/courses?limit=50` | GET | ✅ Active |
| Page load (SSR) | `/api/categories` | GET | ✅ Active |

*Note: Filtering/sorting is client-side after initial data load.*

### Target Pages Status

| Target | Page Code | Implemented |
|--------|-----------|-------------|
| /courses/{slug} | CDET | ✅ Yes |
| /how-it-works | HOWI | 📋 PageSpecView |
| /pricing | PRIC | 📋 PageSpecView |
| /for-creators | FCRE | 📋 PageSpecView |
| / | HOME | ✅ Yes |

---

## Verification Notes

**Verified:** 2026-01-07 (Code + Visual + Interactive Elements)

**Consolidated:** 2026-01-08
- JSON spec updated to match verified implementation
- 3 discrepancies documented in JSON `_discrepancies` section

### Discrepancies Found

| Feature | Spec | Reality | Status |
|---------|------|---------|--------|
| Price range filter | Planned | Not implemented | ⏳ Deferred |
| URL state sync | "URL should reflect filters" | Not implemented | ⚠️ Missing |
| Analytics events | 5 events specified | None implemented | ❌ Not implemented |

### Components Verified

| Component | File | Status |
|-----------|------|--------|
| CourseBrowse | `src/components/courses/CourseBrowse.tsx` | ✅ No TODOs |
| CourseCard | `src/components/courses/CourseCard.tsx` | ✅ No TODOs |
| courses/index.astro | `src/pages/courses/index.astro` | ✅ Clean |

### Interactive Elements Summary

| Category | Count | Active | Inactive |
|----------|-------|--------|----------|
| Search/Sort Controls | 3 | 3 | 0 |
| Filter Controls | 22 | 22 | 0 |
| Filter Pills | 4 | 4 | 0 |
| Pagination Controls | 3+ | 3+ | 0 |
| Mobile Drawer Controls | 4 | 4 | 0 |
| Course Card Links | 4+ | 4+ | 0 |
| Header/Footer Links | 20+ | 20+ | 0 |
| API Endpoints | 2 | 2 | 0 |
| Analytics Events | 5 | 0 | 5 |

**Notes:**
- All filtering works client-side (no server round-trips)
- Duration filter IS implemented (spec was outdated)
- Price range filter NOT implemented
- URL does not reflect current filters (not shareable)
- No analytics events implemented

### Screenshots

| File | Date | Description |
|------|------|-------------|
| `CBRO-2026-01-07-05-51-53.png` | 2026-01-07 | Course browse with filter sidebar |
