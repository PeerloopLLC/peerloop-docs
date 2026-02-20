---
description: Verify a page implementation against its spec
argument-hint: "<PAGE_CODE> (e.g., HOME, CBRO, CDET)"
---

# Verify Page Implementation

**Purpose:** Compare a page's actual implementation against its spec, identify discrepancies, and update documentation.

## Arguments

- `$ARGUMENTS` - The page code (e.g., HOME, CBRO, CDET, SDSH)

If no argument provided, ask the user which page to verify.

## Actions

### 1. Locate Page Files

Read the page spec file to find related files:

```
docs/pages/{CODE}/{CODE}.md   # Page spec (source of truth)
```

From the spec's metadata table, extract:
- `Astro Page` path
- `Component` path(s)
- `JSON Spec` path

### 2. Code Analysis

**Read all relevant files:**
- The Astro page file
- All component files in the component directory
- The JSON spec file

**Search for incomplete work markers:**
```
Pattern: TODO|FIXME|NYI|Not Yet|Future|Placeholder|Stub|coming soon
```
Search case-insensitive in all component files.

**Document findings:**
- List each component and its status (clean or has markers)
- Note any conditional rendering that hides features
- Note any commented-out code

### 3. Interactive Elements Analysis

**Identify all interactive elements in the code:**

**A. Buttons (with onClick handlers):**
- Search for `onClick` in all component files
- Document each button's action (what happens when clicked)
- Note if the handler is implemented or a placeholder

**B. Links (navigation):**
- Search for `<a href=` and `<Link` in all component files
- Document each link's target URL
- Categorize as:
  - Internal links (same site)
  - External links (different domain)
  - Dynamic links (with variables like `/courses/{slug}`)

**C. Form submissions:**
- Search for `<form` and `onSubmit` handlers
- Document the form action and method

**D. Analytics events:**
- Search for analytics patterns: `posthog|analytics|track|gtag|plausible`
- Check if events listed in spec are actually implemented

**E. Verify target pages exist:**
- For each internal link, check if the target page exists
- Note if target is implemented or PageSpecView placeholder

**Create Interactive Elements section in the spec:**

```markdown
## Interactive Elements

### Buttons (with onClick handlers)

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| [Button text] | [Component name] | [What it does] | ✅ Active / ❌ Inactive |

### Links - [Section Name]

| Element | Target | Status |
|---------|--------|--------|
| [Link text/description] | [URL] | ✅ Active |

### Target Pages Status

| Target | Page Code | Implemented |
|--------|-----------|-------------|
| /path | CODE | ✅ Yes / 📋 PageSpecView / ❌ Missing |
```

### 4. Check for Screenshots

**First, check the incoming folder:**
```
../Peerloop/incoming/
```

Look for any image files (*.png, *.jpg, *.jpeg, *.webp).

**If images found:**
1. Read each image using the Read tool (it supports images)
2. Inform user: "Found N screenshot(s) in incoming folder. Analyzing..."
3. Continue to Step 5

**If no images found:**
Ask the user to provide screenshots:

```
No screenshots found in ../Peerloop/incoming/

Please:
1. Take screenshot(s) of the {CODE} page
2. Save them to: ../Peerloop/incoming/
3. Tell me when ready (any filename is fine)

Tip: Capture the full page if possible (use browser's full-page screenshot).
```

Wait for user confirmation, then re-check the incoming folder.

### 5. Visual Analysis

Once screenshot is provided:

1. **Identify all visible sections** - List what you can see
2. **Compare to spec** - Check each feature in the spec's Features section
3. **Note discrepancies:**
   - Features marked [x] but not visible
   - Features visible but not in spec
   - Features implemented differently than spec describes

### 6. Create Discrepancy Report

Format findings as:

```
## Verification Results for {CODE}

### Features Status

| Feature | Spec Status | Actual | Notes |
|---------|-------------|--------|-------|
| [Feature name] | [x] | ✅/❌/⚠️ | [Description] |

### Components Analyzed

| Component | File | Status |
|-----------|------|--------|
| [Name] | [path] | ✅ Clean / ⚠️ Has TODOs |

### Discrepancies Found

| Feature | Spec Says | Reality | Action |
|---------|-----------|---------|--------|
| [Feature] | [Expected] | [Actual] | Uncheck/Update/Note |
```

### 7. Update Page Spec

Make the following updates to `docs/pages/{CODE}/{CODE}.md`:

**A. Update Features section:**
- Uncheck `[ ]` features that aren't implemented
- Add note in italics: `*(Currently: [what exists])*`
- Add new features that exist but weren't in spec

**B. Update Sections descriptions** if reality differs from spec

**C. Add/Update Interactive Elements section** (see Step 3 format)

**D. Add/Update Verification Notes section at end:**

```markdown
---

## Verification Notes

**Verified:** {YYYY-MM-DD} (Code + Visual + Interactive Elements)

### Discrepancies Found

| Feature | Spec | Reality | Status |
|---------|------|---------|--------|
| [Feature] | [Expected] | [Actual] | ❌/⚠️ |

### Components Verified

| Component | File | Status |
|-----------|------|--------|
| [Name] | [path] | ✅ No TODOs |

### Interactive Elements Summary

| Category | Count | Active | Inactive |
|----------|-------|--------|----------|
| Buttons (onClick) | N | N | N |
| Internal Links | N | N | N |
| External Links | N | N | N |
| Dynamic Links | N | N | N |
| Analytics Events | N | N | N |

**Notes:**
- [Key observations about interactive elements]
- [Missing pages, broken links, unimplemented handlers]

### Screenshots

| File | Date | Description |
|------|------|-------------|
| `{CODE}-{YYYY-MM-DD-HH-MM-SS}.png` | {YYYY-MM-DD} | {description} |
```

### 8. Move Screenshots from Incoming

For each image in `../Peerloop/incoming/`:

1. Generate timestamp: `{YYYY-MM-DD-HH-MM-SS}`
2. Determine new filename: `{CODE}-{timestamp}.{ext}`
3. Move the file:
   ```bash
   mv ../Peerloop/incoming/{original} docs/pages/{CODE}/{CODE}-{timestamp}.{ext}
   ```
4. If multiple screenshots, number them: `{CODE}-{timestamp}-1.png`, `{CODE}-{timestamp}-2.png`

**After moving, verify incoming folder is empty (except .gitkeep).**

Log each move:
```
Moved: screenshot.png → docs/pages/{CODE}/{CODE}-2026-01-06-21-30-00.png
```

### 9. Summary

Present final summary:

```
Verification Complete: {CODE}
─────────────────────────────

Features Verified: X/Y
- ✅ Implemented: N
- ❌ Not Implemented: N
- ⚠️ Different: N

Interactive Elements: X total
- ✅ Active: N
- ❌ Inactive: N
- 📋 Target PageSpecView: N
- ❌ Target Missing: N

Spec Updated: docs/pages/{CODE}/{CODE}.md
Screenshot: docs/pages/{CODE}/{filename}.png

Discrepancies requiring attention:
1. [List items needing work]

Interactive element issues:
1. [List broken links, missing pages, unimplemented handlers]
```

## Example

```
/q-verify-page HOME

> Reading docs/pages/HOME/HOME.md...
> Found Astro page: ../Peerloop/src/pages/index.astro
> Found components: ../Peerloop/src/components/home/
> Found JSON spec: ../Peerloop/src/data/pages/index.json

> Analyzing 7 components...
> No TODO/NYI markers found.

> Analyzing interactive elements...
> Found 3 buttons with onClick handlers
> Found 45+ internal links
> Found 3 external links (social)
> Found 6+ dynamic links (course/creator cards)
> Checking analytics implementation...
> Analytics events: 0/3 implemented

> Verifying target pages...
> - /signup (SGUP): ✅ Implemented
> - /courses (CBRO): ✅ Implemented
> - /how-it-works (HOWI): 📋 PageSpecView
> - /cookies: ❌ Missing

> Checking ../Peerloop/incoming/...
> Found 1 screenshot: homepage.png

> Analyzing screenshot...
> Found sections: Hero, How It Works, Featured Courses, Featured Creators,
> Value Proposition, Testimonials, CTA, Footer

> Discrepancies found:
> - Hero image/illustration: Spec says required, only gradient background exists
> - Testimonials: Spec says carousel, implemented as grid
> - Analytics events: Not implemented

> Updating docs/pages/HOME/HOME.md...
> - Unchecked: Hero image/illustration
> - Unchecked: Testimonials carousel
> - Added: Interactive Elements section
> - Added Verification Notes section

> Moving screenshot...
> Moved: homepage.png → docs/pages/HOME/HOME-2026-01-06-21-30-00.png

Verification Complete: HOME
─────────────────────────────
Features Verified: 18/20
- ✅ Implemented: 16
- ❌ Not Implemented: 2
- ⚠️ Different: 2

Interactive Elements: 57 total
- ✅ Active: 54
- ❌ Inactive: 3 (analytics events)
- 📋 Target PageSpecView: 15
- ❌ Target Missing: 1 (/cookies)

Spec Updated: docs/pages/HOME/HOME.md
Screenshot: docs/pages/HOME/HOME-2026-01-06-21-30-00.png

Interactive element issues:
1. /cookies page linked in footer but does not exist
2. Analytics events (page_view, cta_click, course_card_click) not implemented
```

## Notes

- Always read the actual code, don't assume from spec
- Look for hidden features (conditional rendering, feature flags)
- Check for responsive/mobile differences if possible
- Be thorough but concise in discrepancy notes
- The spec should reflect REALITY after verification, not aspirations
