# Page: Certificate Verify

**Code:** CVER
**URL:** `/verify/:id`
**Access:** Public
**Priority:** P1
**Status:** Implemented

---

## Purpose

Public verification page for Peerloop certificates. Allows anyone to verify a certificate's authenticity by ID or QR code scan.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| External | QR code scan | From certificate |
| External | Direct link | Shared URL |
| ACRT | "Verify" action | Admin check |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| CDET | Course name link | View course |
| CPRO | Creator name link | View creator |
| PROF | Holder name link | View profile |

---

## Sections

### Verification Banner

**Valid Certificate:**
- Green checkmark icon
- "Certificate Verified"
- Peerloop seal

**Revoked Certificate:**
- Red X icon
- "Certificate Revoked"
- Warning styling

**Not Found:**
- Gray icon
- "Certificate Not Found"
- "Please check the ID"

### Certificate Details

**Certificate Holder:**
- Avatar
- Full name
- Profile link (optional)

**Course Information:**
- Course thumbnail
- Course title (link to CDET)
- Creator name (link to CPRO)

**Certificate Data:**
- Certificate number
- Issue date
- Course completion date

### Revocation Notice (if applicable)
- Revocation date
- Reason (if provided)
- "This certificate is no longer valid"

### Share Section
- Copy link button
- Social share buttons (optional)

### About Peerloop
- Brief platform description
- "Learn more" → HOME
- "Browse courses" → CBRO

---

## URL Format

```
/verify/CERT-XXXX-XXXX-XXXX
```

Certificate ID is public, non-guessable (UUID or custom format).

---

## API Calls

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/certificates/verify/:id` | Page load | Certificate data |

**Response (Valid):**
```typescript
{
  valid: true,
  certificate: {
    id: string,
    number: string,
    issued_at: string,
    holder: { name, avatar_url, handle },
    course: { title, slug, thumbnail_url },
    creator: { name, handle }
  }
}
```

**Response (Revoked):**
```typescript
{
  valid: false,
  revoked: true,
  revoked_at: string,
  reason: string | null,
  certificate: { ... }
}
```

**Response (Not Found):**
```typescript
{
  valid: false,
  notFound: true
}
```

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| certificates | id, number, issued_at, status, revoked_at, reason | Certificate |
| users | name, avatar_url, handle | Holder |
| courses | title, slug, thumbnail_url | Course |
| users (creator) | name, handle | Creator |

---

## States & Variations

| State | Description |
|-------|-------------|
| Valid | Green, verified display |
| Revoked | Red, warning display |
| Not Found | Gray, error display |
| Loading | Skeleton/spinner |

---

## SEO & OpenGraph

**Meta Tags:**
- Title: "Certificate Verification | Peerloop"
- Description: Dynamic based on status

**OpenGraph:**
- Image: Certificate preview or Peerloop logo
- Type: website

---

## Security Considerations

- Rate limiting to prevent scraping
- No PII exposed beyond name/avatar
- Certificate IDs not sequential
- Consider CAPTCHA for abuse prevention

---

## Notes

- Mobile-first (QR scan primary use case)
- Fast, minimal page load
- No authentication required
- Consider embeddable badge/widget
- QR code on certificates links here
