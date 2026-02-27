# PRIV - Privacy Policy

| Field | Value |
|-------|-------|
| Route | `/privacy` |
| Status | ✅ Implemented |
| Block | - |
| JSON Spec | `src/data/pages/privacy.json` |
| Astro Page | `src/pages/privacy.astro` |
| Component | `src/components/marketing/PrivacyPolicyPage.tsx` |

## Features

- [x] Privacy content (12 comprehensive sections)
- [x] Table of contents (sticky sidebar on desktop, collapsible dropdown on mobile)
- [x] Last updated date
- [x] Effective date
- [x] Smooth scroll navigation to sections
- [x] Related documents links (Terms, Contact)
- [x] Contact information with email link
- [ ] Analytics events (page_view, section_view) *(Not implemented)*

## Sections Implemented

1. Introduction
2. Information We Collect (with subsections)
3. How We Use Your Information
4. How We Share Your Information (with subsections)
5. Data Retention
6. Your Privacy Rights
7. Cookies and Tracking
8. Security
9. Children's Privacy
10. International Data Transfers
11. Changes to This Policy
12. Contact Us

## User Stories Covered

- US-G030: Understand how my data is used
- US-G031: Request deletion of my data

## Notes

- Legal page required before launch
- GDPR/CCPA compliance considerations
- Must be reviewed by legal counsel before production

---

## Interactive Elements

### Buttons (with onClick handlers)

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| TOC Toggle (mobile) | PrivacyPolicyPage | Opens/closes mobile TOC dropdown | ✅ Active |
| TOC Section Links (mobile) | PrivacyPolicyPage | Smooth scrolls to section | ✅ Active |
| TOC Section Links (desktop) | PrivacyPolicyPage | Smooth scrolls to section | ✅ Active |

### Links - Internal

| Element | Target | Status |
|---------|--------|--------|
| Terms of Service | `/terms` | ✅ Active |
| Contact Us | `/contact` | ✅ Active |

### Links - External

| Element | Target | Status |
|---------|--------|--------|
| Privacy email (Your Rights section) | `mailto:privacy@peerloop.com` | ✅ Active |
| Privacy email (Contact section) | `mailto:privacy@peerloop.com` | ✅ Active |

### Target Pages Status

| Target | Page Code | Implemented |
|--------|-----------|-------------|
| /terms | TERM | 📋 PageSpecView |
| /contact | CONT | ✅ Yes |

### Analytics Events

| Event | Trigger | Status |
|-------|---------|--------|
| page_view | Page load | ❌ Not implemented |
| section_view | Section scrolled into view | ❌ Not implemented |

---

## Verification Notes

**Verified:** 2026-01-08 (Code + Visual + Interactive Elements)
**Consolidated:** 2026-01-08
- JSON spec updated to match verified implementation
- 2 discrepancies documented in JSON `_discrepancies` section

### Discrepancies Found

| Feature | Spec | Reality | Status |
|---------|------|---------|--------|
| Analytics events | 2 events specified | Not implemented | ❌ |
| Sections collapsible | Per mobileConsiderations | Not collapsible (scroll-based) | ⚠️ Different approach |

### Components Verified

| Component | File | Status |
|-----------|------|--------|
| PrivacyPolicyPage | `src/components/marketing/PrivacyPolicyPage.tsx` | ✅ No TODOs |

### Interactive Elements Summary

| Category | Count | Active | Inactive |
|----------|-------|--------|----------|
| Buttons (onClick) | 3 types | 3 | 0 |
| Internal Links | 2 | 2 | 0 |
| External Links | 2 | 2 | 0 |
| Dynamic Links | 0 | 0 | 0 |
| Analytics Events | 2 | 0 | 2 |

**Notes:**
- All interactive elements are functional
- TOC navigation works correctly on both mobile and desktop
- /terms target page is PageSpecView placeholder (TERM not yet implemented)
- Analytics events from JSON spec not implemented

### Screenshots

| File | Date | Description |
|------|------|-------------|
| `PRIV-2026-01-08-19-25-17.png` | 2026-01-08 | Full page view showing all sections and TOC |
