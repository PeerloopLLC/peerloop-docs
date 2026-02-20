---
description: Analyze all navigation links and button destinations on a page
argument-hint: "<PAGE_CODE> (e.g., HOME, CBRO, CDET)"
---

# Page Links Audit

**Purpose:** Analyze a page's navigation connections - all links, button destinations, and shared navigation components - and map them to page codes.

## Arguments

- `$ARGUMENTS` - The page code (e.g., HOME, CBRO, CDET, SDSH)

If no argument provided, ask the user which page to audit.

## Actions

### 1. Locate Page Files

**A. Read PAGES-MAP.md** to find the page:
```
PAGES-MAP.md   # Root file - lookup by code
```

From PAGES-MAP.md, extract for the given code:
- Route (e.g., `/`, `/courses`, `/dashboard/learning`)
- JSON spec path (e.g., `../Peerloop/src/data/pages/index.json`)
- Page name
- Status (Active or On-Hold ⏸️)

**B. Derive Astro page path** from the route:
- `/` → `../Peerloop/src/pages/index.astro`
- `/courses` → `../Peerloop/src/pages/courses/index.astro`
- `/courses/:slug` → `../Peerloop/src/pages/courses/[slug].astro`
- `/dashboard/learning` → `../Peerloop/src/pages/dashboard/learning/index.astro`

**C. Read the Astro page** to identify imported components.

### 2. Extract Intended Outgoing Links from JSON

**Read the page's JSON spec** (path from PAGES-MAP.md).

**Extract `connections.outgoing` array:**
```json
{
  "connections": {
    "outgoing": [
      {
        "target": "CBRO",           // Page code
        "targetRoute": "/courses",   // Route
        "trigger": "\"Browse Courses\" CTA",
        "notes": "Primary conversion path"
      }
    ]
  }
}
```

**Build the Intended Links list:**
- For each entry in `outgoing`, record:
  - `target` (page code)
  - `targetRoute` (route pattern)
  - `trigger` (what user action leads there)
  - `notes` (context)

This list defines what the spec **intended** as navigation destinations for this page. Links found in the code that match these are marked as "Intended".

### 3. Identify Shared Navigation Components

Check if the page uses these shared navigation components:

**Header:** `../Peerloop/src/components/navigation/Header.tsx`
- Read and analyze if imported/used

**Footer:** `../Peerloop/src/components/navigation/Footer.astro`
- Read and analyze if imported/used
- Note variant: 'full' (marketing) or 'compact' (app)

**Sidebar/Dashboard Nav:** Check for dashboard navigation if applicable
- `../Peerloop/src/components/navigation/DashboardNav.tsx` or similar

### 4. Analyze All Link Sources

For each component (page + imports + shared nav):

**A. Find anchor tags:**
```
Pattern: <a\s+[^>]*href=["']([^"']+)["']
Pattern: href=\{[^}]+\}  (dynamic hrefs)
```

**B. Find React Link components:**
```
Pattern: <Link\s+[^>]*to=["']([^"']+)["']
Pattern: <Link\s+[^>]*href=["']([^"']+)["']
```

**C. Find button navigation:**
```
Pattern: onClick.*navigate|router\.push|window\.location
Pattern: onClick.*href|onClick.*redirect
```

**D. Find form actions:**
```
Pattern: action=["']([^"']+)["']
Pattern: fetch\(["']([^"']+)["'].*POST
```

For each destination found, record:
- Element type (link, button, form)
- Destination URL/route
- Visible text/label (if determinable)
- Source component name
- Section (Header, Footer, Hero, Content, etc.)

### 5. Cross-Reference with PAGES-MAP.md and Intended Links

For each unique destination:

**A. Match route to page code:**
- Look up exact route in PAGES-MAP.md "Lookup by Route" section
- For dynamic routes like `/courses/{slug}`, match pattern `/courses/:slug`
- For external URLs (https://), mark as "External"

**B. Determine status:**
- ✅ **Exists** - Route in PAGES-MAP.md AND Astro file exists
- ⏸️ **On-Hold** - Route in PAGES-MAP.md with ⏸️ marker
- ⚠️ **Unmapped** - Astro file exists but NOT in PAGES-MAP.md
- ❌ **Missing** - Neither in PAGES-MAP.md nor Astro file exists
- 🌐 **External** - External URL (different domain)

**C. Verify Astro files exist:**
```bash
# Check if destination pages actually exist
ls ../Peerloop/src/pages/{path}.astro
ls ../Peerloop/src/pages/{path}/index.astro
```

**D. Check if destination is Intended:**
- Compare each found destination against the `connections.outgoing` list from Step 2
- Match by `target` (page code) OR `targetRoute` (route pattern)
- Mark as **YES** if destination matches an intended outgoing link
- Leave blank if destination exists but was not in the intended list (e.g., shared nav links)

### 6. Generate Output Report

Format the output as follows:

```markdown
## {PAGE_NAME} ({CODE}) - Navigation Audit

**Route:** {route}
**Astro File:** {path}

---

### Intended Outgoing Links (from JSON spec)

| Target | Route | Trigger | Notes |
|--------|-------|---------|-------|
| {CODE} | {route} | {trigger text} | {notes} |

---

### Header Navigation

| Destination | Code | Page Name | Status | Intended? |
|-------------|------|-----------|--------|-----------|
| {route} | {CODE} | {name} | {status} | YES / |

*(Include authenticated user menu if applicable)*

---

### Footer Navigation

**{Section Name}:**

| Destination | Code | Page Name | Status | Intended? |
|-------------|------|-----------|--------|-----------|
| {route} | {CODE} | {name} | {status} | YES / |

---

### Main Content Sections

**{Section/Component Name}:**

| Destination | Code | Page Name | Status | Intended? |
|-------------|------|-----------|--------|-----------|
| {route} | {CODE} | {name} | {status} | YES / |

---

### External Links

| Destination | Label | Location | Intended? |
|-------------|-------|----------|-----------|
| {url} | {text} | {component} | YES / |

---

### Button Actions (onClick)

| Button | Component | Action | Destination | Intended? |
|--------|-----------|--------|-------------|-----------|
| {text} | {component} | {description} | {route or API} | YES / |

---

## Intended Links Coverage

| Intended Target | Route | Found in Code? | Location |
|-----------------|-------|----------------|----------|
| {CODE} | {route} | ✅ Yes / ❌ No | {component or N/A} |

*(This table shows whether each intended outgoing link from the JSON spec was found in the actual implementation)*

---

## Issues Found

| Issue | Route | Action Needed |
|-------|-------|---------------|
| ❌ Missing Page | {route} | Create page or remove link |
| ⚠️ Unmapped Route | {route} | Add to PAGES-MAP.md |
| ⏸️ On-Hold | {route} | Page linked but placeholder |
| ⚠️ Intended but Missing | {route} | Add link to page (spec requires it) |
| ℹ️ Unintended Link | {route} | Link exists but not in spec (review if needed) |

---

## Summary

- **Total unique destinations:** {N} routes
- **Fully implemented:** {N} routes
- **On-Hold (linked but placeholder):** {N} routes
- **Missing entirely:** {N} routes
- **Unmapped in PAGES-MAP:** {N} routes
- **External links:** {N} URLs
- **Intended links found:** {N}/{M} ({%})
- **Unintended links (in code but not spec):** {N}
```

### 7. Handle Special Cases

**A. Dynamic routes:**
- `/courses/{slug}` → Map to CDET (`/courses/:slug`)
- `/creators/{handle}` → Map to CPRO (`/creators/:handle`)
- `/teachers/{handle}` → Map to STPR (`/teachers/[handle]`)
- Show as "Dynamic" in table with pattern

**B. API routes:**
- `/api/*` routes are backend endpoints, not pages
- List separately under "API Endpoints Called"

**C. Conditional links:**
- Note if link only appears for authenticated users
- Note if link only appears for specific roles (creator, admin, etc.)

**D. Hash links:**
- `#section` anchors on same page - note but don't flag as missing

### 8. Save Report (Optional)

If the user wants to save the report:

```
docs/pages/{CODE}/{CODE}-links.md
```

Or append to existing page spec as new section.

## Example

```
/L-page-links CBRO

> Looking up CBRO in PAGES-MAP.md...
> Found: Course Browse at /courses
> JSON spec: ../Peerloop/src/data/pages/courses/index.json
> Astro file: ../Peerloop/src/pages/courses/index.astro

> Reading JSON spec for intended outgoing links...
> Found 3 intended outgoing links:
>   - CDET (/courses/[slug]) - "Course card click"
>   - CPRO (/creators/[handle]) - "Creator name click"
>   - HOME (/) - "Logo click"

> Analyzing page components...
> Found imports: CourseGrid, CourseFilters, Pagination
> Uses Header: Yes
> Uses Footer: Yes (full variant)

> Scanning for navigation elements...
> Header: 12 links found
> Footer: 20 links found
> CourseGrid: 3+ dynamic links (course cards)
> CourseFilters: 0 links
> Pagination: 2 links (prev/next)

> Cross-referencing with PAGES-MAP.md and intended links...

## Course Browse (CBRO) - Navigation Audit

**Route:** /courses
**Astro File:** ../Peerloop/src/pages/courses/index.astro

---

### Intended Outgoing Links (from JSON spec)

| Target | Route | Trigger | Notes |
|--------|-------|---------|-------|
| CDET | /courses/[slug] | Course card click | View course details |
| CPRO | /creators/[handle] | Creator name click | View creator profile |
| HOME | / | Logo click | Return to home |

---

### Header Navigation

| Destination | Code | Page Name | Status | Intended? |
|-------------|------|-----------|--------|-----------|
| `/` | HOME | Homepage | ✅ Exists | YES |
| `/courses` | CBRO | Course Browse | ✅ Exists | |
| `/how-it-works` | HOWI | How It Works | ✅ Exists | |
| `/pricing` | PRIC | Pricing | ✅ Exists | |
| `/for-creators` | FCRE | For Creators | ✅ Exists | |
| `/login` | LGIN | Login | ✅ Exists | |
| `/signup` | SGUP | Sign Up | ✅ Exists | |

---

### Main Content Sections

**CourseGrid (Course Cards):**

| Destination | Code | Page Name | Status | Intended? |
|-------------|------|-----------|--------|-----------|
| `/courses/{slug}` | CDET | Course Detail | ✅ Exists (Dynamic) | YES |
| `/creators/{handle}` | CPRO | Creator Profile | ✅ Exists (Dynamic) | YES |

**Pagination:**

| Destination | Code | Page Name | Status | Intended? |
|-------------|------|-----------|--------|-----------|
| `/courses?page={n}` | CBRO | Course Browse | ✅ Exists (Self) | |

---

### Intended Links Coverage

| Intended Target | Route | Found in Code? | Location |
|-----------------|-------|----------------|----------|
| CDET | /courses/[slug] | ✅ Yes | CourseGrid |
| CPRO | /creators/[handle] | ✅ Yes | CourseGrid |
| HOME | / | ✅ Yes | Header |

---

## Summary

- **Total unique destinations:** 18 routes
- **Fully implemented:** 17 routes
- **On-Hold:** 1 route (/blog)
- **Missing:** 0 routes
- **External:** 3 URLs
- **Intended links found:** 3/3 (100%)
- **Unintended links (in code but not spec):** 15 (shared nav)
```

## Notes

- Always read actual code, don't assume from spec
- Header and Footer are typically shared across many pages - note their destinations once clearly
- For dynamic routes, verify the pattern exists even if specific slugs vary
- Pay attention to conditional rendering (auth state, user roles)
- API endpoints are not pages - list separately
- This audit is about navigation connectivity, not feature completeness

### Understanding "Intended?" Column

The `connections.outgoing` array in the page JSON defines **page-specific** navigation that should exist for this page. This is distinct from shared navigation (Header/Footer) which exists on all pages.

- **YES** = This link matches an entry in the page's `connections.outgoing` array
- **(blank)** = Link exists but is not page-specific (e.g., shared navigation)

**Key insight:**
- Intended links NOT found in code = **Missing functionality** (spec says it should be there)
- Links found but NOT intended = Usually fine (shared nav), but review if in main content

**The "Intended Links Coverage" table** is the most important output - it shows whether the page implements all the navigation paths the spec requires.
