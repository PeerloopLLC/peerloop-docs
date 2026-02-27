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

**A. Look up the page** using `docs/tech/tech-021-url-routing.md` or `ROUTE-STORIES.md`:
- Find the route for the given page code
- Determine the page name and status

**B. Derive Astro page path** from the route:
- `/` → `../Peerloop/src/pages/index.astro`
- `/courses` → `../Peerloop/src/pages/courses/index.astro`
- `/courses/:slug` → `../Peerloop/src/pages/courses/[slug].astro`
- `/dashboard/learning` → `../Peerloop/src/pages/dashboard/learning/index.astro`

**C. Read the Astro page** to identify imported components.

### 2. Identify Shared Navigation Components

Check if the page uses these shared navigation components:

**Header:** `../Peerloop/src/components/navigation/Header.tsx`
- Read and analyze if imported/used

**Footer:** `../Peerloop/src/components/navigation/Footer.astro`
- Read and analyze if imported/used
- Note variant: 'full' (marketing) or 'compact' (app)

**Sidebar/Dashboard Nav:** Check for dashboard navigation if applicable
- `../Peerloop/src/components/navigation/DashboardNav.tsx` or similar

### 3. Analyze All Link Sources

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

### 4. Cross-Reference with Route Documentation

For each unique destination:

**A. Match route to page code:**
- Look up route in `docs/tech/tech-021-url-routing.md`
- For dynamic routes like `/courses/{slug}`, match pattern `/courses/:slug`
- For external URLs (https://), mark as "External"

**B. Determine status:**
- ✅ **Exists** - Route documented AND Astro file exists
- ⏸️ **On-Hold** - Route documented as deferred
- ⚠️ **Unmapped** - Astro file exists but NOT in route docs
- ❌ **Missing** - Neither in route docs nor Astro file exists
- 🌐 **External** - External URL (different domain)

**C. Verify Astro files exist:**
```bash
# Check if destination pages actually exist
ls ../Peerloop/src/pages/{path}.astro
ls ../Peerloop/src/pages/{path}/index.astro
```

### 5. Generate Output Report

Format the output as follows:

```markdown
## {PAGE_NAME} ({CODE}) - Navigation Audit

**Route:** {route}
**Astro File:** {path}

---

### Header Navigation

| Destination | Code | Page Name | Status |
|-------------|------|-----------|--------|
| {route} | {CODE} | {name} | {status} |

*(Include authenticated user menu if applicable)*

---

### Footer Navigation

**{Section Name}:**

| Destination | Code | Page Name | Status |
|-------------|------|-----------|--------|
| {route} | {CODE} | {name} | {status} |

---

### Main Content Sections

**{Section/Component Name}:**

| Destination | Code | Page Name | Status |
|-------------|------|-----------|--------|
| {route} | {CODE} | {name} | {status} |

---

### External Links

| Destination | Label | Location |
|-------------|-------|----------|
| {url} | {text} | {component} |

---

### Button Actions (onClick)

| Button | Component | Action | Destination |
|--------|-----------|--------|-------------|
| {text} | {component} | {description} | {route or API} |

---

## Issues Found

| Issue | Route | Action Needed |
|-------|-------|---------------|
| ❌ Missing Page | {route} | Create page or remove link |
| ⚠️ Unmapped Route | {route} | Add to route docs |
| ⏸️ On-Hold | {route} | Page linked but placeholder |

---

## Summary

- **Total unique destinations:** {N} routes
- **Fully implemented:** {N} routes
- **On-Hold (linked but placeholder):** {N} routes
- **Missing entirely:** {N} routes
- **External links:** {N} URLs
```

### 6. Handle Special Cases

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

### 7. Save Report (Optional)

If the user wants to save the report, append to the existing page spec in `docs/pagespecs/`.

## Example

```
/L-page-links CBRO

> Looking up CBRO in route docs...
> Found: Course Browse at /courses
> Astro file: ../Peerloop/src/pages/courses/index.astro

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

> Cross-referencing with route docs...

## Course Browse (CBRO) - Navigation Audit

**Route:** /courses
**Astro File:** ../Peerloop/src/pages/courses/index.astro

---

### Header Navigation

| Destination | Code | Page Name | Status |
|-------------|------|-----------|--------|
| `/` | HOME | Homepage | ✅ Exists |
| `/courses` | CBRO | Course Browse | ✅ Exists |
| `/how-it-works` | HOWI | How It Works | ✅ Exists |
| `/pricing` | PRIC | Pricing | ✅ Exists |
| `/for-creators` | FCRE | For Creators | ✅ Exists |
| `/login` | LGIN | Login | ✅ Exists |
| `/signup` | SGUP | Sign Up | ✅ Exists |

---

### Main Content Sections

**CourseGrid (Course Cards):**

| Destination | Code | Page Name | Status |
|-------------|------|-----------|--------|
| `/courses/{slug}` | CDET | Course Detail | ✅ Exists (Dynamic) |
| `/creators/{handle}` | CPRO | Creator Profile | ✅ Exists (Dynamic) |

**Pagination:**

| Destination | Code | Page Name | Status |
|-------------|------|-----------|--------|
| `/courses?page={n}` | CBRO | Course Browse | ✅ Exists (Self) |

---

## Summary

- **Total unique destinations:** 18 routes
- **Fully implemented:** 17 routes
- **On-Hold:** 1 route (/blog)
- **Missing:** 0 routes
- **External:** 3 URLs
```

## Notes

- Always read actual code, don't assume from spec
- Header and Footer are typically shared across many pages - note their destinations once clearly
- For dynamic routes, verify the pattern exists even if specific slugs vary
- Pay attention to conditional rendering (auth state, user roles)
- API endpoints are not pages - list separately
- This audit is about navigation connectivity, not feature completeness

