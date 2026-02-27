# CNEW - Creator Newsletters

| Field | Value |
|-------|-------|
| Route | `/dashboard/creator/newsletters` |
| Access | Authenticated (Creator role) |
| Priority | P3 |
| Status | 📋 Spec Only (Post-MVP) |
| Block | - |
| JSON Spec | `src/data/pages/dashboard/creator/newsletters.json` |
| Astro Page | `src/pages/dashboard/creator/newsletters.astro` |

---

## Purpose

Allow Creators to publish newsletters to their subscribers, with optional paid subscription tiers.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-C026 | As a Creator, I need to publish newsletters so that I can engage my audience | P3 | ⏳ |

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

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| newsletters | id, title, content, status, sent_at, creator_id | Newsletter records |
| newsletter_subscribers | user_id, creator_id, tier, subscribed_at | Subscriber list |
| newsletter_tiers | id, name, price, description | Subscription tiers |

---

## Features

### Newsletter List
- [ ] Table of past newsletters `[US-C026]`
- [ ] Status (Draft/Sent), date, opens, clicks `[US-C026]`
- [ ] Actions: Edit, Duplicate, Delete `[US-C026]`

### Create/Edit Newsletter
- [ ] Title field `[US-C026]`
- [ ] Rich text editor `[US-C026]`
- [ ] Subscriber tier selector `[US-C026]`
- [ ] Schedule or send immediately `[US-C026]`
- [ ] Preview button `[US-C026]`

### Subscriber Management
- [ ] Subscriber count by tier `[US-C026]`
- [ ] Export subscribers `[US-C026]`
- [ ] Tier management `[US-C026]`

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/newsletters` | GET | List creator's newsletters | ⏳ |
| `/api/newsletters` | POST | Create newsletter draft | ⏳ |
| `/api/newsletters/:id` | PUT | Update newsletter | ⏳ |
| `/api/newsletters/:id/send` | POST | Send to subscribers | ⏳ |
| `/api/newsletters/:id` | DELETE | Delete newsletter | ⏳ |
| `/api/newsletters/subscribers` | GET | List subscribers | ⏳ |
| `/api/newsletters/tiers` | GET | List subscription tiers | ⏳ |

---

## States & Variations

| State | Description |
|-------|-------------|
| Empty | No newsletters yet |
| List | Viewing all newsletters |
| Editing | Creating/editing a newsletter |
| Sending | Newsletter being sent |

---

## Error Handling

| Error | Display |
|-------|---------|
| Send fails | "Newsletter failed to send. [Retry]" |
| No subscribers | "You have no subscribers yet" |

---

## Implementation Notes

- **Feature Flag:** `newsletters` - requires `canAccess('newsletters')`
- **Dependencies:** Requires `creator_tools` feature enabled
- Post-MVP priority (P3)
- Uses Resend for email delivery
- React Email for newsletter templates
- Batch processing for large subscriber lists
- Paid tiers would need Stripe subscription integration (future)
