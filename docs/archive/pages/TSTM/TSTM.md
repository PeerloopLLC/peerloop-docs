# TSTM - Testimonials

| Field | Value |
|-------|-------|
| Route | `/testimonials` |
| Access | Public |
| Priority | P1 |
| Status | ✅ Implemented |
| Block | 1.8 |
| Astro Page | `src/pages/testimonials.astro` |
| Component | `src/components/testimonials/TestimonialsBrowse.tsx` |
| JSON Spec | `src/data/pages/testimonials.json` |

---

## Purpose

Display student testimonials with filtering by category and course to build trust and social proof.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-G009 | As a visitor, I want to read testimonials so that I can trust the platform | P1 | ✅ |

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| HOME | Footer "Testimonials" link | Footer navigation |
| Nav Footer | "Testimonials" link | All pages |
| (External) | Direct URL | `/testimonials` |

### Outgoing (users navigate to)

| Target | Trigger | Notes | Status |
|--------|---------|-------|--------|
| CBRO | "Browse Courses" CTA | View courses | ✅ |
| SGUP | "Get Started" CTA | Sign up | ✅ |
| CDET | Course link on card | View course detail | ✅ |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| course_testimonials | id, quote, student_name, student_role, is_featured, created_at, course_id | Testimonial display |
| courses | id, title, slug, category_id | Course reference |
| categories | id, name | Category filtering |

---

## Features

### Hero Section
- [x] Title: "What Our Students Say"
- [x] Subtitle describing testimonials

### Stats Bar
- [x] Total testimonials count (dynamic)
- [x] Courses reviewed count (dynamic)
- [x] Average rating (hardcoded 4.8)

### Featured Reviews
- [x] Featured testimonials section (top 3)
- [x] Only shows when no filters active
- [x] Larger card styling

### Filters
- [x] Category filter (radio buttons)
- [x] Course filter (radio buttons, filtered by category)
- [x] Active filter pills with × to remove
- [x] "Clear all filters" link
- [x] Mobile filter drawer

### Testimonials Grid
- [x] Responsive grid (3 → 2 → 1 columns)
- [x] Testimonial cards with quote, name, role
- [x] Course link on each card
- [x] Category label
- [x] Date display
- [x] Featured badge

### Pagination
- [x] Previous/Next buttons
- [x] Page number buttons
- [x] 12 items per page

### Empty State
- [x] "No testimonials found" message
- [x] "Clear all filters" button

### CTA Section
- [x] "Ready to Start Your Journey?" heading
- [x] "Browse Courses" button → /courses
- [x] "Get Started" button → /signup

---

## Sections

### Header
- Title: "What Our Students Say"
- Subtitle: "Real feedback from real learners on their Peerloop journey."

### Stats Bar
- 3-column layout
- Dynamic counts from data

### Featured Reviews
- Shows top 3 featured testimonials
- Hidden when filters are active

### Filter Sidebar (Desktop)
- Category radio buttons
- Course radio buttons (filtered by selected category)
- "Clear all filters" when active

### Filter Drawer (Mobile)
- Triggered by "Filters" button
- Bottom sheet with category and course filters
- "Clear All" and "Apply Filters" buttons

### Testimonials Grid
- Results count
- Responsive grid
- Testimonial cards

### CTA Banner
- Gradient background
- Two CTA buttons

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/testimonials` | GET | List testimonials | ✅ |
| `/api/categories` | GET | Category list for filter | ✅ |
| `/api/courses` | GET | Course list for filter | ✅ |

**Query Parameters (testimonials):**
- `featured` - Filter featured only
- `limit` - Max results (default 50)
- `course_id` - Filter by course
- `category_id` - Filter by category

---

## States & Variations

| State | Description | Status |
|-------|-------------|--------|
| Default | All testimonials, featured first | ✅ |
| Filtered by category | Shows only selected category | ✅ |
| Filtered by course | Shows only selected course | ✅ |
| Empty | No testimonials match filter | ✅ |
| Paginated | Multiple pages of results | ✅ |

---

## Error Handling

| Error | Display |
|-------|---------|
| No testimonials | Empty state with "Clear all filters" button |
| API error | Shows empty state |

---

## Mobile Considerations

- Filter drawer instead of sidebar
- Single column grid
- Full-width filter button

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `page_view` | Page load | - |
| `filter_change` | Filter changed | filter_type, value |
| `testimonial_view` | Card in viewport | testimonial_id |
| `cta_click` | CTA button clicked | button_type |
| `course_click` | Course link clicked | course_id |

---

## Implementation Notes

- Data from `course_testimonials` D1 table
- Filterable by course and category
- Course filter auto-filters based on category selection
- Client-side filtering after SSR data load
- Pagination with 12 items per page
- Featured testimonials shown first (when no filters)

---

## Interactive Elements

### Buttons (with onClick handlers)

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| Category radio buttons | TestimonialsBrowse | Sets category filter | ✅ Active |
| Course radio buttons | TestimonialsBrowse | Sets course filter | ✅ Active |
| Category pill × button | TestimonialsBrowse | Clears category filter | ✅ Active |
| Course pill × button | TestimonialsBrowse | Clears course filter | ✅ Active |
| "Clear all filters" link | TestimonialsBrowse | Clears all filters | ✅ Active |
| "Clear all filters" button (empty state) | TestimonialsBrowse | Clears all filters | ✅ Active |
| Mobile "Filters" button | TestimonialsBrowse | Opens filter drawer | ✅ Active |
| Mobile drawer close button | TestimonialsBrowse | Closes drawer | ✅ Active |
| Mobile "Clear All" button | TestimonialsBrowse | Clears filters, closes drawer | ✅ Active |
| Mobile "Apply Filters" button | TestimonialsBrowse | Closes drawer | ✅ Active |
| "Previous" pagination | TestimonialsBrowse | Goes to previous page | ✅ Active |
| Page number buttons | TestimonialsBrowse | Goes to specific page | ✅ Active |
| "Next" pagination | TestimonialsBrowse | Goes to next page | ✅ Active |

### Links - Testimonial Cards

| Element | Target | Status |
|---------|--------|--------|
| Course title link | /courses/{slug} | ✅ Active |

### Links - CTA Section

| Element | Target | Status |
|---------|--------|--------|
| "Browse Courses" | /courses | ✅ Active |
| "Get Started" | /signup | ✅ Active |

### Links - Header (via LandingLayout)

| Element | Target | Status |
|---------|--------|--------|
| Peerloop logo | / | ✅ Active |
| Courses | /courses | ✅ Active |
| How It Works | /how-it-works | ✅ Active |
| Pricing | /pricing | ✅ Active |
| For Creators | /for-creators | ✅ Active |

### Links - Footer

Standard footer links (same as HOME).

### API Calls (triggered by interactions)

| Trigger | Endpoint | Method | Status |
|---------|----------|--------|--------|
| Page load (SSR) | `/api/testimonials?featured=false&limit=50` | GET | ✅ Active |
| Page load (SSR) | `/api/categories` | GET | ✅ Active |
| Page load (SSR) | `/api/courses?limit=50` | GET | ✅ Active |

*Note: Filtering and pagination are client-side after initial data load.*

### Target Pages Status

| Target | Page Code | Implemented |
|--------|-----------|-------------|
| / | HOME | ✅ Yes |
| /courses | CBRO | ✅ Yes |
| /courses/{slug} | CDET | ✅ Yes |
| /signup | SGUP | ✅ Yes |
| /how-it-works | HIWO | 📋 PageSpecView |
| /pricing | PRIC | 📋 PageSpecView |
| /for-creators | FCRE | 📋 PageSpecView |

---

## Verification Notes

**Verified:** 2026-01-07 (Code + Visual + Interactive Elements)

**Consolidated:** 2026-01-08
- JSON spec updated to match verified implementation
- 2 discrepancies documented in JSON `_discrepancies` section

### Discrepancies Found

| Feature | Spec | Reality | Status |
|---------|------|---------|--------|
| Component path | `TestimonialsPage.tsx` | `TestimonialsBrowse.tsx` | ✅ Fixed in spec |
| Average rating | Dynamic | Hardcoded 4.8 | ⚠️ Hardcoded |
| Analytics events | 5 events specified | None implemented | ❌ Not implemented |

### Components Verified

| Component | File | Status |
|-----------|------|--------|
| TestimonialsBrowse | `src/components/testimonials/TestimonialsBrowse.tsx` | ✅ No TODOs |
| TestimonialCard | `src/components/testimonials/TestimonialCard.tsx` | ✅ No TODOs |
| testimonials.astro | `src/pages/testimonials.astro` | ✅ Clean |

### Interactive Elements Summary

| Category | Count | Active | Inactive |
|----------|-------|--------|----------|
| Filter Controls | 4 | 4 | 0 |
| Filter Pill Buttons | 2 | 2 | 0 |
| Mobile Drawer Buttons | 4 | 4 | 0 |
| Pagination Buttons | 3+ | 3+ | 0 |
| Card Links | N | N | 0 |
| CTA Links | 2 | 2 | 0 |
| Header Links | 5 | 5 | 0 |
| API Endpoints | 3 | 3 | 0 |
| Analytics Events | 5 | 0 | 5 |

**Notes:**
- Page fully functional with filtering and pagination
- Has 5 testimonials, 4 courses in database
- Course filter cascades from category selection
- Featured testimonials shown at top (when no filters)
- Mobile filter drawer works well
- Avg rating is hardcoded (4.8)

### Screenshots

| File | Date | Description |
|------|------|-------------|
| `TSTM-2026-01-07-06-44-23.png` | 2026-01-07 | Testimonials page with filters and featured reviews |
