# CONT - Contact

| Field | Value |
|-------|-------|
| Route | `/contact` |
| Status | ✅ Implemented |
| Block | 1.8 |
| JSON Spec | `src/data/pages/contact.json` |
| Astro Page | `src/pages/contact.astro` |
| Component | `src/components/marketing/ContactPage.tsx` |

## Features

- [x] Hero with headline and subheadline
- [x] Contact form with 5 fields (name, email, category, subject, message)
- [x] Category dropdown (7 options)
- [x] Client-side validation with inline errors
- [x] Form states: idle, submitting (with spinner), success, error
- [x] Success message with "Return to Home" + "Send Another" options
- [x] FAQ redirect card in sidebar
- [x] Alternative contact emails (3)
- [x] Social links (Twitter/X, LinkedIn, Instagram)
- [x] Office address info
- [x] Form submission to POST /api/contact
- [x] Submissions stored in D1 contact_submissions table
- [ ] Email notification via Resend *(Planned: Block 9)*
- [ ] Analytics events *(Not implemented)*
- [ ] Map embed *(Optional, not implemented)*

## Data Storage

| Entity | API | Purpose |
|--------|-----|---------|
| `contact_submissions` | POST /api/contact | Store form submissions |

## Form Fields

| Field | Type | Required | Validation |
|-------|------|----------|------------|
| Name | text | Yes | Min 2 characters |
| Email | email | Yes | Valid email format |
| Category | select | Yes | 7 options |
| Subject | text | Yes | Min 5 characters |
| Message | textarea | Yes | Min 20 characters |

## Category Options

| Value | Label |
|-------|-------|
| general | General Question |
| support | Technical Support |
| billing | Billing & Payments |
| partnership | Partnership Inquiry |
| press | Press & Media |
| creator | Creator Application |
| other | Other |

## User Stories Covered

- US-G020: Contact support with questions
- US-G021: Reach out for partnership opportunities

## Interactive Elements

### Form Submission

| Element | Action | Status |
|---------|--------|--------|
| Contact form | POST /api/contact on submit | ✅ Active |
| Send Message button | Submits form, shows spinner | ✅ Active |

### Buttons (onClick handlers)

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| Send Another Message | SuccessMessage | Resets form to idle | ✅ Active |

### Links

| Element | Target | Type | Status |
|---------|--------|------|--------|
| Visit FAQ | `/faq` | Internal | ✅ Active |
| Return to Home | `/` | Internal | ✅ Active |
| support@peerloop.com | `mailto:` | External | ✅ Active |
| partnerships@peerloop.com | `mailto:` | External | ✅ Active |
| press@peerloop.com | `mailto:` | External | ✅ Active |
| Twitter/X | `twitter.com/peerloop` | External | ✅ Active |
| LinkedIn | `linkedin.com/company/peerloop` | External | ✅ Active |
| Instagram | `instagram.com/peerloop` | External | ✅ Active |

### Target Pages Status

| Target | Page Code | Status |
|--------|-----------|--------|
| `/faq` | FAQP | ✅ Implemented |
| `/` | HOME | ✅ Implemented |

### Analytics Events

| Event | Spec Status | Implemented |
|-------|-------------|-------------|
| page_view | Spec'd | ❌ No |
| form_start | Spec'd | ❌ No |
| form_submit | Spec'd | ❌ No |

## States & Variations

| State | Description | Status |
|-------|-------------|--------|
| Default (idle) | Empty form ready for input | ✅ |
| Submitting | Spinner on button, fields disabled | ✅ |
| Success | Thank you message with CTAs | ✅ |
| Error | Error banner shown, form remains | ✅ |
| Validation Error | Inline field errors shown | ✅ |

## Notes

- Form submission stores to D1 contact_submissions table
- Email notification via Resend planned for Block 9
- Rate limiting not yet implemented
- Has dev mode toggle (PageSpecView + real content)
- Responsive: form full-width on mobile, sidebar stacks below

---

## Verification Notes

**Verified:** 2026-01-08 (Code + Visual + Interactive Elements)

**Consolidated:** 2026-01-08
- JSON spec updated to match verified implementation
- 3 discrepancies documented in JSON `_discrepancies` section

### Components Verified

| Component | File | Status |
|-----------|------|--------|
| ContactPage | `src/components/marketing/ContactPage.tsx` | ✅ Clean |
| SuccessMessage | (inline) | ✅ Clean |
| SocialIcon | (inline) | ✅ Clean |

### Discrepancies Found

| Feature | Spec | Reality | Status |
|---------|------|---------|--------|
| Analytics events | 3 events spec'd | Not implemented | ❌ Missing |
| Email notification | Via Resend | Not yet implemented | ⚠️ Block 9 |
| Map embed | Optional | Not implemented | ⚠️ Optional |

### Interactive Elements Summary

| Category | Count | Active | Inactive |
|----------|-------|--------|----------|
| Form (onSubmit) | 1 | 1 | 0 |
| Buttons (onClick) | 1 | 1 | 0 |
| Internal Links | 2 | 2 | 0 |
| External Links | 6 | 6 | 0 |
| Analytics Events | 0 | 0 | 3 |

**Notes:**
- All interactive elements are functional
- Form validation works client-side
- Form submits successfully to /api/contact
- All email links use mailto: protocol
- Social links open in new tab with proper rel attributes
- Analytics planned for Block 9

### Screenshots

| File | Date | Description |
|------|------|-------------|
| `CONT-2026-01-08-02-20-00.png` | 2026-01-08 | Full page with form |
