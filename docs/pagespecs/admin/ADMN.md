# Page: Admin Dashboard

**Code:** ADMN
**URL:** `/admin`
**Access:** Authenticated (Admin role)
**Priority:** P0
**Status:** In Scope

---

## Purpose

Platform administration hub for managing users, processing payouts, reviewing content, monitoring platform health, and handling system-wide operations.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| LGIN | Successful login (Admin) | Default for admins |
| Nav | "Admin" link | Admin navigation |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| PROF | User row click | View user profile |
| CDET | Course row click | View course |
| MODQ | "Moderation Queue" | Content moderation |
| (Stripe) | "Stripe Dashboard" | External: payment details |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| users | All fields | User management |
| courses | All fields | Course oversight |
| enrollments | All fields | Enrollment management |
| transactions | All fields | Payment tracking |
| payment_splits | All fields | Revenue split tracking |
| payouts | All fields | Payout management |
| certificates | All fields | Certificate vetting |
| sessions | All fields | Session monitoring |
| content_flags | All fields | Moderation queue |
| moderator_invites | All fields | Moderator invitation management |

---

## Sections

### Admin Navigation
- Sidebar with sections:
  - Dashboard Overview
  - Users
  - Courses
  - Payouts
  - Enrollments
  - Certificates
  - Moderators
  - Analytics
  - Settings
  - Moderation → MODQ

### Dashboard Overview
- **Key Metrics:**
  - Total users (with growth)
  - Active courses
  - Total revenue
  - Pending payouts
  - Sessions this week
- **Quick Actions:**
  - Process pending payouts
  - Review flagged content
  - Approve certificates
- **Recent Activity:**
  - Latest enrollments
  - Recent payouts
  - New users
- **Alerts:**
  - Pending approvals count
  - Flagged content count
  - System alerts

### Users Section
- **User List:**
  - Table: Name, Email, Role(s), Status, Joined, Actions
  - Search by name/email
  - Filter by role, status
  - Pagination
- **User Actions:**
  - View profile
  - Edit roles
  - Suspend/unsuspend
  - Delete (with confirmation)
- **User Detail View:**
  - Full profile
  - Enrollments
  - Transactions
  - Sessions
  - Audit log

### Courses Section
- **Course List:**
  - Table: Title, Creator, Students, Revenue, Status
  - Filter by status, category
  - Search
- **Course Actions:**
  - View course
  - Feature/unfeature
  - Suspend/unsuspend
  - Override settings

### Payouts Section (from CD-020)
- **Pending Payouts:**
  - List by recipient
  - Amount pending
  - "Process" button per payout
  - "Process All" batch action
- **Payout History:**
  - Past payouts with dates, amounts, status
  - Filter by recipient, date range
- **Payout Actions:**
  - Approve individual payout
  - Batch approve
  - Mark as paid
  - View Stripe transfer

### Enrollments Section
- **Enrollment List:**
  - Table: Student, Course, ST, Status, Date
  - Filter by course, status
- **Enrollment Actions:**
  - Manually enroll user
  - Cancel enrollment
  - Issue refund
  - Reassign ST

### Certificates Section
- **Pending Certificates:**
  - Awaiting admin vetting
  - Review and approve/reject
- **Issued Certificates:**
  - History of all certificates
  - Revoke if needed

### Moderators Section
- **Current Moderators:**
  - List of users with `is_moderator = true`
  - Each shows: name, email, assigned date
  - "Remove Moderator" action
- **Pending Invites:**
  - Invites sent but not yet accepted
  - Each shows: email, sent date, expires date, status
  - "Resend" / "Cancel" actions
- **Invite New Moderator:**
  - "Invite Moderator" button
  - Email input + optional message
  - Sends invite email via Resend
  - Creates record in `moderator_invites`
- **Invite History:**
  - All past invites (accepted, declined, expired)
  - Filter by status
- **Two-Step Flow:**
  1. Admin sends invite to email
  2. Invitee receives email with unique link
  3. Invitee clicks link → MINV page to accept/decline
  4. If accepted: user's `is_moderator` flag set to true
- **Source:** Brian Review 2025-12-26

### Analytics Section
- **Platform Metrics:**
  - User growth over time
  - Revenue trends
  - Course performance
  - Conversion rates
  - Session completion rates
- **Export:** Download reports as CSV

### Settings Section
- **Platform Settings:**
  - Default commission rates
  - Feature flags
  - Maintenance mode
- **Email Templates:** (future)
- **Integration Settings:**
  - Stripe configuration
  - Stream configuration
  - Video provider settings

---

## User Stories Fulfilled

- US-A001: Access admin dashboard
- US-A002: Manage users
- US-A003: View platform analytics
- US-A004: Process payouts (CD-020)
- US-A005: Manage enrollments
- US-A006: Vet certificates
- US-A007: Review flagged content → MODQ

---

## States & Variations

| State | Description |
|-------|-------------|
| Overview | Main dashboard with metrics |
| Section View | Specific admin section |
| Processing | Batch operations in progress |
| Alert | Pending items require attention |

---

## Mobile Considerations

- Admin primarily desktop-focused
- Mobile: simplified overview + critical actions
- Tables become card lists
- Batch operations may be limited

---

## Error Handling

| Error | Display |
|-------|---------|
| Action fails | "Unable to complete action. Try again." |
| Payout fails | "Payout failed. Check Stripe." |
| Load fails | "Unable to load data. [Retry]" |

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `page_view` | Page load | section |
| `user_updated` | User modified | user_id, action |
| `payout_processed` | Payout approved | payout_id, amount |
| `enrollment_modified` | Enrollment changed | enrollment_id, action |
| `certificate_vetted` | Certificate approved/rejected | cert_id, action |

---

## API Calls

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/admin/dashboard` | Page load | Aggregated metrics and alerts |
| `GET /api/admin/users` | Users section | Paginated user list |
| `GET /api/admin/courses` | Courses section | Paginated course list |
| `GET /api/admin/enrollments` | Enrollments section | Paginated enrollment list |
| `GET /api/admin/payouts/pending` | Payouts section | Pending payouts |
| `POST /api/admin/payouts/:id/approve` | Approve payout | Process single payout |
| `POST /api/admin/payouts/batch-approve` | Batch approve | Process multiple payouts |
| `GET /api/admin/certificates/pending` | Certificates section | Pending certificates |
| `GET /api/admin/analytics` | Analytics section | Platform metrics |
| `GET /api/admin/flags/count` | Alerts | Flagged content count |
| `GET /api/admin/moderator-invites` | Moderators section | List invites |
| `POST /api/admin/moderator-invites` | Send invite | Create and send invite |
| `DELETE /api/admin/moderator-invites/:id` | Cancel invite | Revoke pending invite |
| `POST /api/admin/moderator-invites/:id/resend` | Resend invite | Resend invite email |
| `DELETE /api/admin/users/:id/moderator` | Remove moderator | Remove moderator role |

**Dashboard Response:**
```typescript
GET /api/admin/dashboard
{
  metrics: {
    total_users: number,
    users_growth: number,        // percent change
    active_courses: number,
    total_revenue: number,       // cents
    pending_payouts: number,     // cents
    sessions_this_week: number
  },
  alerts: {
    pending_payouts: number,
    pending_certificates: number,
    flagged_content: number,
    system_alerts: string[]
  },
  recent: {
    enrollments: [...],          // last 5
    payouts: [...],              // last 5
    users: [...]                 // last 5
  }
}
```

**Payout Approval:**
```typescript
POST /api/admin/payouts/:id/approve
// Triggers Stripe Transfer
// Returns { success, transfer_id, amount }

POST /api/admin/payouts/batch-approve
{
  payout_ids: string[]
}
// Returns { success, processed: number, failed: number }
```

---

## Notes

- CD-020: Semi-automated payouts (admin approves, Stripe transfers)
- Security: Admin actions should be logged
- Consider role-based admin access (super admin, support, etc.)
- Prototype gap noted in CD-027: Admin not implemented
- Critical security: Protect admin routes carefully
