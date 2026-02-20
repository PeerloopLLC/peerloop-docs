# CRLS - Creator Listing

| Field | Value |
|-------|-------|
| Route | `/creators` |
| Access | Public |
| Priority | P0 |
| Status | ✅ Implemented |
| Block | 1 |
| Astro Page | `src/pages/creators/index.astro` |
| Component | `src/components/creators/CreatorBrowse.tsx` |
| JSON Spec | `src/data/pages/creators/index.json` |

---

## Purpose

Allow visitors to discover and browse course creators, building trust and enabling creator-first discovery.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-S004 | As a student, I want to discover creators before choosing courses so that I can find trusted experts | P0 | ✅ |
| US-G008 | As a visitor, I want to browse creators without an account so that I can explore the platform | P0 | ✅ |

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

| Target | Trigger | Notes | Status |
|--------|---------|-------|--------|
| CPRO | Creator card click | View creator profile | ✅ |
| CDET | Course link on creator card | Direct to course (if shown) | ✅ |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| users (creators) | id, name, handle, avatar, title, bio_short | Creator cards |
| user_expertise | tag | Expertise tags on cards |
| user_stats | students_taught, courses_created, average_rating | Stats display |
| courses | count per creator | Course count badge |

---

## Features

### Search & Discovery
- [x] Search by name or expertise `[US-S004]`
- [x] Expertise filter (tag-based) `[US-S004]`
- [x] Sort options (Most Students, Highest Rated, Newest, A-Z) `[US-G008]`

### Display
- [x] Creator cards grid (responsive: 3 → 2 → 1 columns) `[US-G008]`
- [x] Avatar (large, circular) `[US-G008]`
- [x] Name and title `[US-G008]`
- [x] Short bio (truncated) `[US-G008]`
- [x] Expertise tags (top 3) `[US-S004]`
- [x] Stats row: students, courses, rating `[US-G008]`
- [x] "View Profile" link → CPRO `[US-G008]`

### States
- [x] Empty state (no results) `[US-G008]`
- [x] Pagination `[US-G008]`

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

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/creators` | GET | Creator list with stats | ✅ |

**Query Parameters:**
- `q` - Search by name or expertise
- `expertise` - Filter by expertise tag
- `sort` - students, rating, newest, name
- `page`, `limit` - Pagination

---

## States & Variations

| State | Description | Status |
|-------|-------------|--------|
| Default | All creators, sorted by popularity | ✅ |
| Filtered | Active expertise filter | ✅ |
| Search Results | Searching by name/expertise | ✅ |
| Empty | No results, show empty state | ✅ |

---

## Error Handling

| Error | Display |
|-------|---------|
| Load fails | "Unable to load creators. Please try again." |
| No results | Empty state with suggestion |

---

## Mobile Considerations

- Single column cards
- Search sticky at top
- Filters in collapsible section

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `page_view` | Page load | filters, search_query |
| `search` | Search submitted | query |
| `creator_click` | Creator card clicked | creator_id, position |

---

## Implementation Notes

- Responsive grid layout
- Filters by expertise tags from `user_expertise` table
- Genesis Cohort: Only 3 creators initially (per CD-008)
- May want to highlight "Featured Creator" or sort by activity

---

## Interactive Elements

### Search & Sort Controls

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| Search input | CreatorBrowse | Filters by name/title/expertise | ✅ Active |
| Sort dropdown | CreatorBrowse | Changes sort (students, rating, courses, A-Z) | ✅ Active |

### Expertise Filter Pills

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| "All" button | CreatorBrowse | Clears expertise filter | ✅ Active |
| Tag buttons (dynamic) | CreatorBrowse | Filters to selected expertise | ✅ Active |

### Active Filters

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| "Clear filters" link | CreatorBrowse | Resets all filters | ✅ Active |

### Empty State

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| "Clear filters" button | CreatorBrowse | Resets all filters | ✅ Active |

### Links - Creator Cards

| Element | Target | Status |
|---------|--------|--------|
| Creator card (entire card) | /creators/{handle} | ✅ Active |

### Links - CTA Banner

| Element | Target | Status |
|---------|--------|--------|
| "Learn More" button | /for-creators | ✅ Active |

### Links - Navigation (Header/Footer)

Same as other public pages (HOME, CBRO).

### API Calls (triggered by interactions)

| Trigger | Endpoint | Method | Status |
|---------|----------|--------|--------|
| Page load (SSR) | `/api/creators?limit=50` | GET | ✅ Active |

*Note: Filtering/sorting is client-side after initial data load.*

### Target Pages Status

| Target | Page Code | Implemented |
|--------|-----------|-------------|
| /creators/{handle} | CPRO | ✅ Yes |
| /for-creators | FCRE | 📋 PageSpecView |
| / | HOME | ✅ Yes |

---

## Verification Notes

**Verified:** 2026-01-07 (Code + Visual + Interactive Elements)

**Consolidated:** 2026-01-08
- JSON spec updated to match verified implementation
- 2 discrepancies documented in JSON `_discrepancies` section

### Discrepancies Found

| Feature | Spec | Reality | Status |
|---------|------|---------|--------|
| Pagination | Planned | Not visible (only 2 creators) | ⚠️ Not needed yet |
| Analytics events | 3 events specified | None implemented | ❌ Not implemented |

### Components Verified

| Component | File | Status |
|-----------|------|--------|
| CreatorBrowse | `src/components/creators/CreatorBrowse.tsx` | ✅ No TODOs |
| CreatorCard | `src/components/creators/CreatorCard.tsx` | ✅ Clean |
| index.astro | `src/pages/creators/index.astro` | ✅ Clean |

### Interactive Elements Summary

| Category | Count | Active | Inactive |
|----------|-------|--------|----------|
| Search/Sort Controls | 2 | 2 | 0 |
| Filter Pills | 10+ | 10+ | 0 |
| Clear Filters | 2 | 2 | 0 |
| Creator Card Links | 2+ | 2+ | 0 |
| CTA Links | 1 | 1 | 0 |
| API Endpoints | 1 | 1 | 0 |
| Analytics Events | 3 | 0 | 3 |

**Notes:**
- All filtering works client-side (no server round-trips)
- Expertise tags dynamically extracted from creator data
- "Become a Creator" CTA banner at bottom
- Pagination not visible (Genesis Cohort has <12 creators)
- Creator cards show top 3 tags with "+N" overflow indicator

### Screenshots

| File | Date | Description |
|------|------|-------------|
| `CRLS-2026-01-07-06-07-17.png` | 2026-01-07 | Creator listing with filter pills |
