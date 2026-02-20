# Page: Notification Settings

**Code:** SNOT
**URL:** `/settings/notifications`
**Access:** Authenticated
**Priority:** P1
**Status:** Implemented

---

## Purpose

Allow users to manage their email notification preferences for sessions, messages, course updates, payments, certificates, and marketing communications.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| SETT | "Notifications" card/link | From main settings page |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| SETT | Breadcrumb "Settings" | Return to settings hub |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| users | email_session_reminder, email_session_booked, email_new_message, email_course_update, email_certificate, email_payment, email_marketing | Store notification preferences |
| users | is_student_teacher, is_creator | Show role-specific settings |

---

## Sections

### Header
- Page title: "Notification Settings"
- Description: "Choose which email notifications you'd like to receive"

### Sessions & Booking
- **Session reminders** toggle: "Get notified before your upcoming learning sessions"
- **New booking notifications** toggle: "Get notified when someone books a session with you"

### Messages & Updates
- **New messages** toggle: "Get notified when you receive a new message"
- **Course updates** toggle: "Get notified about updates to courses you're enrolled in"

### Achievements
- **Certificate notifications** toggle: "Get notified when you earn a new certificate"

### Payments
- **Payment notifications** toggle: "Get notified about payments, earnings, and payouts"

### Marketing
- **Newsletter & promotions** toggle: "Receive updates about new features, tips, and special offers"
- Default: off (opt-in)

### Info Section
- Background: Secondary/gray
- Auto-save behavior explanation
- Security email disclaimer (always sent)
- Unsubscribe instructions

---

## User Stories Fulfilled

- US-S044: Receive session reminders
- US-S045: Control message notifications
- US-S046: Get course update notifications
- US-S047: Certificate earned notifications
- US-S048: Opt in/out of marketing emails
- US-ST032: Booking notifications for Student-Teachers
- US-ST033: Payment notifications for earnings

---

## States & Variations

| State | Description |
|-------|-------------|
| Loading | Skeleton animation while fetching preferences |
| Error | Red border, error message, Retry button |
| Loaded | All toggles displayed with current values |
| Saving | Individual toggle disabled while saving |
| Save Success | Brief green success message (2 seconds) |

---

## Mobile Considerations

- Toggles remain usable on small screens (44px min touch target)
- Section cards stack vertically
- Touch-friendly toggle targets

---

## Error Handling

| Error | Display |
|-------|---------|
| Failed to load settings | "Unable to load notification settings" with retry |
| Failed to save preference | "Failed to save" with automatic rollback to previous value |

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `page_view` | Page load | notification_settings |
| `notification_toggle` | Toggle changed | field_name, new_value |

---

## API Calls

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/me/settings` | Page load | Fetch current notification preferences |
| `PATCH /api/me/settings` | Toggle changed | Update individual preference |

**Settings Response:**
```typescript
GET /api/me/settings
{
  email_session_reminder: boolean,
  email_session_booked: boolean,
  email_new_message: boolean,
  email_course_update: boolean,
  email_certificate: boolean,
  email_payment: boolean,
  email_marketing: boolean,
  is_student_teacher: boolean,
  is_creator: boolean
}
```

**Update Request:**
```typescript
PATCH /api/me/settings
{
  [field_name]: boolean  // Only the changed field
}
```

---

## Implementation Notes

- Uses optimistic updates: UI changes immediately, rolls back on error
- Each toggle saves independently (no "Save All" button)
- Preferences stored as INTEGER 0/1 in SQLite, converted to boolean in API
- Security-related emails (password reset, account alerts) always sent regardless of preferences
