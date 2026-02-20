# Page: Creator Newsletters

**Code:** CNEW
**URL:** `/studio/newsletters`
**Access:** Authenticated (Creator role)
**Priority:** P3
**Status:** Out of Scope (Post-MVP)

---

## Purpose

Allow Creators to publish newsletters to their subscribers, with optional paid subscription tiers.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| STUD | "Newsletters" nav item | Creator Studio sidebar |
| CDSH | "Manage Newsletters" link | Dashboard quick action |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| STUD | Back/breadcrumb | Return to studio |
| (External) | "Preview" button | Opens newsletter preview |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| newsletters | id, title, content, status, sent_at, creator_id | Newsletter records |
| newsletter_subscribers | user_id, creator_id, tier, subscribed_at | Subscriber list |
| newsletter_tiers | id, name, price, description | Subscription tiers |

---

## Sections

### Header
- Page title: "Newsletters"
- "Create Newsletter" button

### Newsletter List
- Table/cards of past newsletters
- Columns: Title, Status (Draft/Sent), Sent Date, Opens, Clicks
- Actions: Edit, Duplicate, Delete, View Stats

### Create/Edit Newsletter
- Title field
- Rich text editor for content
- Subscriber tier selector (who receives)
- Schedule or send immediately
- Preview button

### Subscriber Management
- Subscriber count by tier
- Export subscribers
- Tier management (create/edit tiers)

---

## User Stories Fulfilled

- US-C026: As a Creator, I need to publish newsletters (potentially with subscription payments) so that I can engage my audience

---

## States & Variations

| State | Description |
|-------|-------------|
| Empty | No newsletters yet - show "Create your first newsletter" CTA |
| List | Viewing all newsletters |
| Editing | Creating/editing a newsletter |
| Sending | Newsletter being sent (progress indicator) |

---

## Mobile Considerations

- Newsletter editing may be limited on mobile (complex rich text)
- Consider mobile-optimized preview

---

## Error Handling

| Error | Display |
|-------|---------|
| Send fails | "Newsletter failed to send. [Retry]" |
| No subscribers | "You have no subscribers yet" |

---

## Server Integration

### Feature Flag
```typescript
// Requires: canAccess('newsletters')
// Depends on: creator_tools
// Role required: creator
```

### API Endpoints Called

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/newsletters` | Page load | List creator's newsletters |
| `POST /api/newsletters` | Create new | Create newsletter draft |
| `PUT /api/newsletters/:id` | Edit/save | Update newsletter |
| `POST /api/newsletters/:id/send` | Send clicked | Send to subscribers |
| `DELETE /api/newsletters/:id` | Delete clicked | Delete newsletter |
| `GET /api/newsletters/subscribers` | Subscriber tab | List subscribers |
| `GET /api/newsletters/tiers` | Tier management | List subscription tiers |

### Newsletter Send Flow (Resend)

```
Send Newsletter:
  1. POST /api/newsletters/:id/send {
       tier_id?: string  // null = all subscribers
     }
  2. Backend:
     - Validate newsletter status is 'draft' or 'scheduled'
     - Get subscriber list (filtered by tier if specified)
     - Queue email jobs (batch for large lists)
     - Update status: 'sending'
  3. Email Worker (Cloudflare Queue):
     - Process batches of 100
     - Call Resend API for each
     - Track delivery status
  4. Update status: 'sent', set sent_at
```

### Resend Integration

```typescript
// Backend sends newsletter:
import { Resend } from 'resend';
import { NewsletterEmail } from '@/emails/newsletter';

const resend = new Resend(process.env.RESEND_API_KEY);

// For each subscriber (batched):
await resend.emails.send({
  from: `${creator.name} via PeerLoop <newsletters@peerloop.com>`,
  to: subscriber.email,
  subject: newsletter.title,
  react: NewsletterEmail({
    content: newsletter.content,
    creatorName: creator.name,
    unsubscribeUrl: `${origin}/unsubscribe?token=${token}`
  })
});
```

### Subscriber Management

```typescript
// GET /api/newsletters/subscribers
{
  total: 150,
  by_tier: [
    { tier_id: null, name: 'Free', count: 120 },
    { tier_id: 'uuid', name: 'Premium', count: 30 }
  ],
  subscribers: [
    { user_id, name, email, tier_id, subscribed_at }
  ]
}

// Subscribers auto-added when:
// 1. User follows creator (free tier)
// 2. User purchases tier subscription (paid tier)
```

### Tracking (via Resend webhooks)

```typescript
// POST /api/webhooks/resend (newsletter-specific events)
email.opened → UPDATE newsletters SET opens_count = opens_count + 1
email.clicked → UPDATE newsletters SET clicks_count = clicks_count + 1
email.bounced → Mark subscriber email as bounced
email.unsubscribed → Remove from newsletter_subscribers
```

### Data Flow Diagram

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│   CNEW      │      │  PeerLoop   │      │   Resend    │
│   (Client)  │      │  (Server)   │      │   (Email)   │
└──────┬──────┘      └──────┬──────┘      └──────┬──────┘
       │                    │                    │
       │ POST /newsletters  │                    │
       │───────────────────>│                    │
       │                    │ Create draft       │
       │ { draft }          │                    │
       │<───────────────────│                    │
       │                    │                    │
       │ PUT /newsletters/  │                    │
       │   :id (edit)       │                    │
       │───────────────────>│                    │
       │                    │                    │
       │ POST /newsletters/ │                    │
       │   :id/send         │                    │
       │───────────────────>│                    │
       │                    │ Queue emails       │
       │ { sending }        │                    │
       │<───────────────────│                    │
       │                    │                    │
       │                    │ Batch send via     │
       │                    │ Resend             │
       │                    │───────────────────>│
       │                    │                    │
       │                    │ Webhooks:          │
       │                    │ opened, clicked    │
       │                    │<───────────────────│
       │                    │ Update metrics     │
```

---

## Notes

- **Feature Flag:** `newsletters` - check with `canAccess('newsletters')`
- **Dependencies:** Requires `creator_tools` feature enabled
- Resend for email delivery (same provider as transactional emails)
- React Email for newsletter templates
- Batch processing for large subscriber lists (100 per batch)
- Consider Substack-like experience
- Paid tiers would need Stripe subscription integration (future)
