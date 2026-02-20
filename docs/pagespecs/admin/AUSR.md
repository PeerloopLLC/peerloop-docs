# Screen: Admin Users

**Code:** AUSR
**URL:** `/admin/users` (route within Admin SPA)
**Access:** Authenticated (Admin role)
**Priority:** P0
**Status:** In Scope

---

## Purpose

CRUD interface for managing all platform users - view, search, edit roles, suspend, and delete user accounts.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| ADMN | "Users" nav item | Admin sidebar |
| AENR | User name click | From enrollment |
| ACRT | User name click | From certificate |
| APAY | Recipient name click | From payout |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| PROF | "View Public Profile" | Opens in new tab |
| AENR | "View Enrollments" | Filtered to user |
| ASES | "View Sessions" | Filtered to user |
| ACRT | "View Certificates" | Filtered to user |
| APAY | "View Payouts" | Filtered to user (if ST/Creator) |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| users | All fields | User records |
| enrollments | count per user | Enrollment stats |
| sessions | count per user | Session stats |
| student_teachers | user_id, course_id | ST status |
| certificates | user_id | Certificate count |

---

## Sections

### Header
- Screen title: "User Management"
- "Add User" button (manual creation)
- Export button

### Search & Filters
- **Search:** Name, email, handle
- **Role filter:** All / Student / ST / Creator / Admin / Moderator
- **Status filter:** All / Active / Suspended / Unverified
- **Date filter:** Joined date range

### Users Table

| Column | Content |
|--------|---------|
| User | Avatar + name + email |
| Handle | @handle |
| Roles | Role badges (Student, ST, Creator, Admin, Mod) |
| Joined | Registration date |
| Status | Active / Suspended / Unverified |
| Stats | Enrollments, Sessions, Courses created |
| Actions | Edit, Suspend, Delete |

### User Detail Panel / Modal

**View Mode:**
- Full user profile data
- Role badges
- Account status
- Activity summary:
  - Enrollments (count, link to AENR)
  - Sessions (count, link to ASES)
  - Certificates (count, link to ACRT)
  - Payouts (if applicable, link to APAY)
- Audit log (recent account actions)

**Edit Mode:**
- Name, handle (editable)
- Email (editable, triggers reverification)
- Role toggles:
  - is_creator
  - is_student_teacher
  - is_admin
  - is_moderator
- Account status (active/suspended)
- Notes (admin-only)

### Actions

| Action | Description |
|--------|-------------|
| Edit | Open edit mode |
| Suspend | Suspend account (with reason) |
| Unsuspend | Restore suspended account |
| Delete | Permanent deletion (with confirmation) |
| Reset Password | Send password reset email |
| Verify Email | Manually verify email |
| Impersonate | Log in as user (super admin only, audit logged) |

### Add User Modal
- Manual user creation
- Name, email, password (or invite link)
- Role selection
- Send welcome email toggle

---

## API Calls

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/admin/users` | Page load | Paginated, filterable user list |
| `GET /api/admin/users/:id` | Detail open | Full user data with stats |
| `POST /api/admin/users` | Add user | Manual user creation |
| `PATCH /api/admin/users/:id` | Save edit | Update user fields |
| `DELETE /api/admin/users/:id` | Delete | Soft delete user |
| `POST /api/admin/users/:id/suspend` | Suspend | Suspend account |
| `POST /api/admin/users/:id/unsuspend` | Unsuspend | Restore account |
| `POST /api/admin/users/:id/reset-password` | Reset password | Send reset email |
| `POST /api/admin/users/:id/verify-email` | Verify email | Manual verification |
| `GET /api/admin/users/export` | Export | CSV export |

**Query Parameters:**
- `q` - Search name/email/handle
- `role` - student, st, creator, admin, moderator
- `status` - active, suspended, unverified
- `from`, `to` - Joined date range
- `page`, `limit` - Pagination

**User Response:**
```typescript
GET /api/admin/users/:id
{
  user: { ...all fields... },
  stats: {
    enrollments: number,
    sessions: number,
    courses_created: number,
    certificates: number
  },
  audit_log: [{ action, timestamp, by }]
}
```

---

## States & Variations

| State | Description |
|-------|-------------|
| List | Default user list |
| Filtered | Search/filter applied |
| Detail | User panel open |
| Editing | Edit mode active |
| Confirming | Delete/suspend confirmation |

---

## Error Handling

| Error | Display |
|-------|---------|
| Load fails | "Unable to load users. [Retry]" |
| Update fails | "Unable to save changes. [Retry]" |
| Delete blocked | "Cannot delete user with active enrollments" |

---

## Audit Logging

All admin actions logged:
- Who performed action
- What action
- When
- Target user
- Previous/new values

---

## Notes

- Single admin user assumption: No role hierarchy needed
- Consider GDPR: Data export, right to delete
- Impersonation should be heavily audited
