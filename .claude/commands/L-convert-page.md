# Convert Page to AppLayout

**Purpose:** Convert a legacy page from `../Peerloop/_src/pages` (using `LandingLayout`) to a new page using `AppLayout` at a specified route.

## Arguments

- `$ARGUMENTS` - Two arguments: `<pageCode> <route>`
  - `pageCode`: The page code from PAGES-MAP.md (e.g., CRLS, STDR, LEAD)
  - `route`: The new route path (e.g., /discover/creators, /discover/teachers)

Example: `/L-convert-page CRLS /discover/creators`

If arguments are missing or invalid, ask the user for clarification.

## Process Overview

1. Look up the page code in route docs to find the original page
2. Read the original Astro page from `../Peerloop/_src/pages`
3. Extract the `<Fragment slot="content">` section
4. Create a new AppLayout page at the specified route
5. Report what was created

## Actions

### 1. Look Up Page Code

Look up the page code in `docs/tech/tech-021-url-routing.md` or `ROUTE-STORIES.md` to find:
- Page title
- Original route
- Original Astro file path (replace `src/` with `_src/`)

If page code not found, report error and stop.

### 2. Read Original Page

Read the original Astro page from `../Peerloop/_src/pages` (not `src/pages`).

The path is derived from `metadata.astroFile`:
- Replace `src/pages/` with `../Peerloop/_src/pages/`
- Example: `src/pages/creators/index.astro` → `../Peerloop/_src/pages/creators/index.astro`

If file not found, report error and stop.

### 3. Extract Content Fragment

From the original page, extract:

**A. The `<Fragment slot="content">` section:**
```astro
<Fragment slot="content">
  <ComponentName client:load prop1={value1} prop2={value2} />
</Fragment>
```

Extract the inner content (without the Fragment tags).

**B. Required imports for the content:**
- The React component import (e.g., `import CreatorBrowse from '@components/creators/profiles/CreatorBrowse'`)
- Any type imports needed for props

**C. Props/data passed to the component:**
- Look at the frontmatter for data fetching (D1 queries, etc.)
- These will need to be replicated or simplified

### 4. Create New Page

Create the new Astro page at `../Peerloop/src/pages/{route}/index.astro`.

**Template:**
```astro
---
/**
 * {CODE} - {route}
 * {title} - converted from legacy LandingLayout page
 */
import AppLayout from "@layouts/AppLayout.astro";
import {ComponentName} from '{component-path}';

// Data fetching code (copied/adapted from original)
{frontmatter-data-code}
---

<AppLayout title="{title} | PeerLoop">
  <div class="max-w-6xl">
    <header class="mb-8">
      <h1 class="text-2xl font-bold text-secondary-900 dark:text-secondary-100">{title}</h1>
      <p class="text-secondary-600 dark:text-secondary-400 mt-1">
        {description from original page or JSON spec purpose}
      </p>
    </header>

    <!-- Content from Fragment slot -->
    {content-from-fragment}
  </div>
</AppLayout>
```

**Width guidance:**
- `max-w-6xl` for grid/browse pages (creators, teachers, students, courses)
- `max-w-4xl` for detail/profile pages
- `max-w-3xl` for forms/settings pages

### 5. Handle Data Fetching

**Option A: Keep SSR data fetching**
If the original page has D1 queries in the frontmatter, copy them to the new page.

**Option B: Convert to client-side**
If the component can fetch its own data, simplify to just mounting the component.

**Option C: Create skeleton**
If data fetching is complex, create a skeleton page that mounts the component without props, and note that data fetching needs to be implemented.

### 6. Create Directories

Ensure the directory structure exists for the new route:
```bash
mkdir -p ../Peerloop/src/pages/{route-directories}
```

### 7. Summary

Present final summary:

```
Page Conversion Complete: {CODE} → {route}
─────────────────────────────────────────

Source: ../Peerloop/_src/pages/{original-path}
Target: ../Peerloop/src/pages/{new-path}

Component: {ComponentName}
Layout: AppLayout (was LandingLayout)

Changes:
- Removed PageSpecView and sidepanel (dev mode elements)
- Wrapped in AppLayout with header
- Container: max-w-{size}

Data Fetching: {SSR copied | Client-side | Skeleton (needs implementation)}

Files Created:
- ../Peerloop/src/pages/{new-path}

Next Steps:
- Verify the page renders correctly at {route}
- Update DiscoverSlidePanel if this page is linked there
- Add to PAGES-MAP.md (or new routing doc) if tracking
```

## Notes

- The original page in `../Peerloop/_src/pages` is NOT modified
- The new page uses `AppLayout` which provides the persistent AppNavbar sidebar
- PageSpecView and dev-mode sidepanel are NOT included in the converted page
- Dark mode classes should be included (the AppLayout pages support dark mode)
- If the React component has its own container (`container-main`), consider whether to keep it or rely on the page's container

## Example

**Input:** `/L-convert-page CRLS /discover/creators`

**Source:** `../Peerloop/_src/pages/creators/index.astro`
```astro
<LandingLayout ...>
  <PageSpecView ... />
  <Fragment slot="sidepanel">...</Fragment>
  <Fragment slot="content">
    <CreatorBrowse client:load initialCreators={creators} />
  </Fragment>
</LandingLayout>
```

**Output:** `../Peerloop/src/pages/discover/creators/index.astro`
```astro
<AppLayout title="Creator Listing | PeerLoop">
  <div class="max-w-6xl">
    <header class="mb-8">
      <h1>Our Creators</h1>
      <p>Discover course creators and authors</p>
    </header>
    <CreatorBrowse client:load initialCreators={creators} />
  </div>
</AppLayout>
```
