# FAQP - FAQ

| Field | Value |
|-------|-------|
| Route | `/faq` |
| Status | ✅ Implemented |
| Block | 1.8 |
| JSON Spec | `src/data/pages/faq.json` |
| Astro Page | `src/pages/faq.astro` |
| Component | `src/components/marketing/FaqPage.tsx` |

## Features

- [x] Hero with headline and subheadline
- [x] Search bar with clear button
- [x] Category filter tabs (7: All, General, Students, Teachers, Creators, Payments, Technical)
- [x] FAQ accordion (expandable Q&A items)
- [x] Grouped by category view (when "All" selected)
- [x] Single category flat view (when category selected)
- [x] No results state with clear filters button
- [x] Contact CTA section
- [x] Dynamic data from D1 faq_entries table
- [ ] Analytics events *(Not implemented)*

## Data Sources

| Entity | API | Purpose |
|--------|-----|---------|
| `faq_entries` | GET /api/faq | 25 FAQ entries across 6 categories |

## FAQ Categories

| Category | Questions | Icon |
|----------|-----------|------|
| General | 3 | ℹ️ |
| For Students | 5 | 📚 |
| For Teachers | 5 | 🎓 |
| For Creators | 4 | ✏️ |
| Payments | 4 | 💳 |
| Technical | 4 | ⚙️ |
| **Total** | **25** | |

## User Stories Covered

- US-G010: Find answers to common questions
- US-S015: Understand refund policy
- US-T010: Understand payment process

## Interactive Elements

### Buttons (onClick handlers)

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| Clear search (✕) | FaqPage | Clears search query | ✅ Active |
| Category tab (All) | CategoryTab | Sets filter to 'all' | ✅ Active |
| Category tabs (6) | CategoryTab | Sets filter to category | ✅ Active |
| Clear filters | FaqPage | Resets search + category | ✅ Active |
| Accordion toggle | FaqAccordion | Expands/collapses answer | ✅ Active |

### Links

| Element | Target | Type | Status |
|---------|--------|------|--------|
| "Contact Us" button | `/contact` | Internal | ✅ Active |

### Target Pages Status

| Target | Page Code | Status |
|--------|-----------|--------|
| `/contact` | CONT | ✅ Implemented |

### Analytics Events

| Event | Spec Status | Implemented |
|-------|-------------|-------------|
| page_view | Spec'd | ❌ No |
| faq_search | Spec'd | ❌ No |
| faq_expand | Spec'd | ❌ No |
| contact_click | Spec'd | ❌ No |

## States & Variations

| State | Description | Status |
|-------|-------------|--------|
| Default | All categories visible, grouped by category | ✅ |
| Filtered | Single category selected, flat list | ✅ |
| Search Results | Matching questions filtered | ✅ |
| No Results | Empty state with clear filters | ✅ |

## Notes

- Category tabs sticky at top on scroll
- Category tabs scroll horizontally on mobile
- Search filters both questions and answers
- FAQ data loaded from D1 via /api/faq
- Has dev mode toggle (PageSpecView + real content)

---

## Verification Notes

**Verified:** 2026-01-08 (Code + Visual + Interactive Elements)

**Consolidated:** 2026-01-08
- JSON spec updated to match verified implementation
- 2 discrepancies documented in JSON `_discrepancies` section

### Components Verified

| Component | File | Status |
|-----------|------|--------|
| FaqPage | `src/components/marketing/FaqPage.tsx` | ✅ Clean |
| CategoryTab | (inline) | ✅ Clean |
| FaqAccordion | (inline) | ✅ Clean |

### Discrepancies Found

| Feature | Spec | Reality | Status |
|---------|------|---------|--------|
| Analytics events | 4 events spec'd | Not implemented | ❌ Missing |
| Category "For Student-Teachers" | Spec name | Shows as "For Teachers" | ⚠️ Minor |

### Interactive Elements Summary

| Category | Count | Active | Inactive |
|----------|-------|--------|----------|
| Buttons (onClick) | 9+ | 9+ | 0 |
| Internal Links | 1 | 1 | 0 |
| External Links | 0 | 0 | 0 |
| Dynamic Links | 0 | 0 | 0 |
| Analytics Events | 0 | 0 | 4 |

**Notes:**
- All interactive elements are functional
- Search works on both questions and answers
- Category filtering works correctly
- No broken links or missing targets
- Analytics planned for Block 9

### Screenshots

| File | Date | Description |
|------|------|-------------|
| `FAQP-2026-01-08-02-15-00.png` | 2026-01-08 | Full page with all categories |
