# TERM - Terms of Service

| Field | Value |
|-------|-------|
| Route | `/terms` |
| Status | ✅ Implemented |
| Block | - |
| JSON Spec | `src/data/pages/terms.json` |
| Astro Page | `src/pages/terms.astro` |
| Component | `src/components/marketing/TermsOfServicePage.tsx` |

## Features

- [x] Terms content (12 comprehensive sections)
- [x] Table of contents (sticky sidebar on desktop, collapsible dropdown on mobile)
- [x] Last updated date
- [x] Effective date
- [x] Smooth scroll navigation to sections
- [x] Related documents links (Privacy, Contact)
- [x] Contact information with email links
- [x] S-T independent contractor status (Section 5.1)
- [ ] Analytics events (page_view) *(Not implemented)*

## Sections Implemented

1. Acceptance of Terms
2. Account Terms (with 3 subsections)
3. User Conduct (with 3 subsections)
4. Student Terms (with 3 subsections)
5. Student-Teacher Terms (with 4 subsections)
6. Creator Terms (with 4 subsections)
7. Intellectual Property (with 3 subsections)
8. Payments & Fees
9. Disclaimers & Limitations (with 2 subsections)
10. Dispute Resolution (with 3 subsections)
11. General Provisions
12. Contact Information

## User Stories Covered

- US-G032: Understand terms before signing up
- US-G033: Know my rights and obligations

## Notes

- Legal page required before launch
- Must cover S-T independent contractor status
- Must be reviewed by legal counsel before production

---

## Interactive Elements

### Buttons (with onClick handlers)

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| TOC Toggle (mobile) | TermsOfServicePage | Opens/closes mobile TOC dropdown | ✅ Active |
| TOC Section Links (mobile) | TermsOfServicePage | Smooth scrolls to section | ✅ Active |
| TOC Section Links (desktop) | TermsOfServicePage | Smooth scrolls to section | ✅ Active |

### Links - Internal

| Element | Target | Status |
|---------|--------|--------|
| Privacy Policy | `/privacy` | ✅ Active |
| Contact Us | `/contact` | ✅ Active |

### Links - External

| Element | Target | Status |
|---------|--------|--------|
| Security email | `mailto:security@peerloop.com` | ✅ Active |
| Copyright email | `mailto:copyright@peerloop.com` | ✅ Active |
| Legal email | `mailto:legal@peerloop.com` | ✅ Active |

### Target Pages Status

| Target | Page Code | Implemented |
|--------|-----------|-------------|
| /privacy | PRIV | ✅ Yes |
| /contact | CONT | ✅ Yes |

### Analytics Events

| Event | Trigger | Status |
|-------|---------|--------|
| page_view | Page load | ❌ Not implemented |

---

## Verification Notes

**Verified:** 2026-01-08 (Code + Visual + Interactive Elements)
**Consolidated:** 2026-01-08
- JSON spec updated to match verified implementation
- 2 discrepancies documented in JSON `_discrepancies` section

### Discrepancies Found

| Feature | Spec | Reality | Status |
|---------|------|---------|--------|
| Analytics events | 1 event specified | Not implemented | ❌ |
| Sections collapsible | Per mobileConsiderations | Not collapsible (scroll-based) | ⚠️ Different approach |

### Components Verified

| Component | File | Status |
|-----------|------|--------|
| TermsOfServicePage | `src/components/marketing/TermsOfServicePage.tsx` | ✅ No TODOs |

### Interactive Elements Summary

| Category | Count | Active | Inactive |
|----------|-------|--------|----------|
| Buttons (onClick) | 3 types | 3 | 0 |
| Internal Links | 2 | 2 | 0 |
| External Links | 3 | 3 | 0 |
| Dynamic Links | 0 | 0 | 0 |
| Analytics Events | 1 | 0 | 1 |

**Notes:**
- All interactive elements are functional
- TOC navigation works correctly on both mobile and desktop
- All target pages (/privacy, /contact) are fully implemented
- Analytics event from JSON spec not implemented

### Screenshots

| File | Date | Description |
|------|------|-------------|
| `TERM-2026-01-08-19-36-21.png` | 2026-01-08 | Full page view showing sections 6-12 and TOC |
