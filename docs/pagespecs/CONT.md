# Page: Contact

**Code:** CONT
**URL:** `/contact`
**Access:** Public
**Priority:** P2
**Status:** Implemented (Marketing)

---

## Purpose

Provide contact options for general inquiries, support, partnerships, and press.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| Nav | Footer "Contact" link | All pages |
| FAQP | "Contact Us" link | Need more help |
| ABOU | "Contact Us" link | From about |
| FCRE | "Contact Us" link | Creator questions |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| FAQP | "Check FAQ first" | Common questions |
| HELP | "Help Center" (if logged in) | Support |

---

## Sections

### Hero
- Headline: "Get in Touch"
- Subheadline: We'd love to hear from you

### Contact Options

**General Inquiries**
- Email: hello@peerloop.com
- Response time: 24-48 hours

**Support**
- Email: support@peerloop.com
- Check FAQ first link
- Help Center (logged in users)

**Partnerships**
- Email: partnerships@peerloop.com
- For potential partners, integrations

**Press**
- Email: press@peerloop.com
- For media inquiries

### Contact Form
- Name (required)
- Email (required)
- Subject dropdown:
  - General Question
  - Technical Support
  - Billing Issue
  - Partnership Inquiry
  - Press/Media
  - Other
- Message (required)
- Submit button

### Social Links
- Twitter/X
- LinkedIn
- Instagram
- YouTube

### Location (Optional)
- Company address (if applicable)
- Map embed (optional)

---

## Form Handling

**Submission Flow:**
1. Validate fields
2. Show loading state
3. Submit to API
4. Show success message
5. (Email sent to appropriate inbox)

**Success State:**
- "Thanks for reaching out!"
- "We'll get back to you within 24-48 hours"
- Option to send another message

**Error State:**
- "Unable to send message"
- "Please try again or email us directly"

---

## API Calls

| Endpoint | When | Purpose |
|----------|------|---------|
| `POST /api/contact` | Form submit | Send contact message |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| contact_messages | (if stored) | Contact submissions |

---

## Notes

- Consider using third-party form service (Formspree, etc.)
- CAPTCHA/honeypot for spam prevention
- Email routing based on subject
- Auto-reply confirmation email
