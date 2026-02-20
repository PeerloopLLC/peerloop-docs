# ABOU - About

| Field | Value |
|-------|-------|
| Route | `/about` |
| Status | ✅ Implemented |
| Block | 1.8 |
| JSON Spec | `src/data/pages/about.json` |
| Astro Page | `src/pages/about.astro` |
| Component | `src/components/marketing/AboutPage.tsx` |

## Features

- [x] Hero section with mission statement
- [x] The 2 Sigma Problem explanation with visual (50%→98%)
- [x] Learn-Teach-Earn Flywheel with 4 steps + circular visual
- [x] Impact Stats (4 metrics from D1 platform_stats)
- [x] Our Values (4 cards: Accessibility, Empowerment, Community, Excellence)
- [x] Team section (dynamic from D1 team_members table)
- [x] Team member cards with photo, name, role, bio, LinkedIn
- [x] "We're hiring" link to careers
- [x] CTA section with signup + courses buttons
- [ ] Hero background image/illustration *(Currently: gradient only)*
- [ ] Analytics events *(Not implemented)*

## Data Sources

| Entity | API | Purpose |
|--------|-----|---------|
| `team_members` | GET /api/team | Team section display |
| `platform_stats` | GET /api/stats | Impact metrics |

## User Stories Covered

- US-G003: Understand the platform's mission and values
- US-G005: Learn about the team behind the platform

## Interactive Elements

### Links

| Element | Target | Type | Status |
|---------|--------|------|--------|
| "View Open Positions" | `/careers` | Internal | ✅ Active |
| "Get Started Free" | `/signup` | Internal | ✅ Active |
| "Explore Courses" | `/courses` | Internal | ✅ Active |
| Team member LinkedIn | `linkedin.com/in/*` | External | ✅ Active |

### Target Pages Status

| Target | Page Code | Status |
|--------|-----------|--------|
| `/careers` | CARE | 📋 PageSpecView |
| `/signup` | SGUP | ✅ Implemented |
| `/courses` | CBRO | ✅ Implemented |

### Analytics Events

| Event | Spec Status | Implemented |
|-------|-------------|-------------|
| page_view | Spec'd | ❌ No |
| cta_click | Spec'd | ❌ No |
| team_member_click | Spec'd | ❌ No |

## Notes

- Team data fetched from D1 via /api/team (5 members seeded)
- Stats fetched from D1 via /api/stats with fallback values
- Responsive: team grid 1→2→3 columns, values 1→2→4 columns
- Has dev mode toggle (PageSpecView + real content)

---

## Verification Notes

**Verified:** 2026-01-08 (Code + Visual + Interactive Elements)

**Consolidated:** 2026-01-08
- JSON spec updated to match verified implementation
- 3 discrepancies documented in JSON `_discrepancies` section

### Components Verified

| Component | File | Status |
|-----------|------|--------|
| AboutPage | `src/components/marketing/AboutPage.tsx` | ⚠️ Has "coming soon" fallback |
| StatCard | (inline) | ✅ Clean |
| TeamMemberCard | (inline) | ✅ Clean |

### Discrepancies Found

| Feature | Spec | Reality | Status |
|---------|------|---------|--------|
| Hero background | Image/illustration | Gradient only | ⚠️ Minor |
| CTA "Join our team" | Listed in spec | Not in CTA (only Team section) | ⚠️ Minor |
| Analytics events | 3 events spec'd | Not implemented | ❌ Missing |

### Interactive Elements Summary

| Category | Count | Active | Inactive |
|----------|-------|--------|----------|
| Buttons (onClick) | 0 | 0 | 0 |
| Internal Links | 3 | 3 | 0 |
| External Links | 5 | 5 | 0 |
| Dynamic Links | 0 | 0 | 0 |
| Analytics Events | 0 | 0 | 3 |

**Notes:**
- All internal links point to valid pages (SGUP, CBRO implemented; CARE is PageSpecView)
- LinkedIn links are external, open in new tab with proper rel attributes
- No onClick handlers - all interactions are link-based
- Analytics not yet implemented (planned for Block 9)

### Screenshots

| File | Date | Description |
|------|------|-------------|
| `ABOU-2026-01-08-02-10-00.png` | 2026-01-08 | Full page with real team data |
