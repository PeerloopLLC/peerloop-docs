# Page: Security Settings

**Code:** SSEC
**URL:** `/settings/security`
**Access:** Authenticated
**Priority:** P1
**Status:** Implemented

---

## Purpose

Manage account security including password changes, session management, logout functionality, and account deletion with proper confirmation safeguards.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| SETT | "Security" card/link | From settings hub |
| Nav | Direct link | If deep-linked |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| SETT | Breadcrumb "Settings" | Return to settings hub |
| PWRS | "Change Password" button | Password reset flow |
| HOME | Logout or account deletion | Post-action redirect |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| users | id, email | Verify ownership for deletion |
| (future: sessions) | device, last_active | Active sessions list |

---

## Sections

### Header
- Page title: "Security Settings"
- Description: "Manage your password, sessions, and account security"
- Breadcrumb: Settings → Security

### Password Section
- **Title:** "Password"
- **Description:** "Use the password reset flow to set a new password"
- **Action:** "Change Password" button → PWRS flow
- Card with icon, text, and CTA button

### Active Sessions Section (Coming Soon)
- **Title:** "Active Sessions"
- **Status:** Coming Soon placeholder
- **Future Features:**
  - List of logged-in devices
  - Device name, browser, location
  - Last active timestamp
  - "Log out" button per session
  - "Log out all devices" bulk action
- **Note:** Requires sessions table in schema

### Account Actions Section
- **Title:** "Account Actions"
- **Sign Out:**
  - Description: "Sign out of your account on this device"
  - "Sign Out" button
  - Calls `/api/auth/logout`, redirects to HOME

### Danger Zone Section
- **Title:** "Danger Zone"
- **Styling:** Red-tinted border and header
- **Delete Account:**
  - Description: "Permanently delete your account and all associated data"
  - "Delete Account" button (red)
  - Opens confirmation modal

### Delete Confirmation Modal
- **Title:** "Delete Account" (red)
- **Warning Box:**
  - "This action is permanent and cannot be undone."
  - Bullet list of consequences:
    - All your data will be permanently deleted
    - Your enrollments will be cancelled
    - Your certificates will be revoked
    - Any pending payouts will be forfeited
- **Email Confirmation:**
  - Label: "Type [user@email.com] to confirm:"
  - Text input for email
  - Validation: must match exactly (case-insensitive)
- **Actions:**
  - "Cancel" button (secondary)
  - "Delete My Account" button (red, disabled until email matches)
- **Processing State:**
  - "Deleting..." text on button
  - Both buttons disabled during deletion

### Info Section
- Background: Secondary/gray
- **Title:** "About Account Security"
- **Tips:**
  - Use a strong, unique password that you don't use elsewhere
  - Sign out when using shared or public computers
  - Account deletion is permanent and cannot be undone

---

## User Stories Fulfilled

- US-S049: Change password via reset flow
- US-S050: View active sessions (future)
- US-S051: Log out of current device
- US-S052: Delete account with confirmation

---

## States & Variations

| State | Description |
|-------|-------------|
| Default | All sections displayed, actions available |
| Logging Out | Sign Out button shows "Signing out...", disabled |
| Delete Modal Open | Modal overlay with confirmation form |
| Delete Processing | Modal buttons disabled, "Deleting..." text |
| Error | Red alert banner with error message |

---

## Mobile Considerations

- Buttons full-width on small screens
- Modal responsive to viewport (max-width constraint)
- Touch-friendly button targets (min 44px)
- Danger zone clearly visible with red styling

---

## Error Handling

| Error | Display |
|-------|---------|
| Logout fails | Red alert: "Failed to logout" with retry |
| Delete fails | Error in modal, modal stays open |
| Email mismatch | Button stays disabled, no error shown |
| Network error | Generic error message with retry option |

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `page_view` | Page load | security_settings |
| `logout` | Logout clicked | source: security_settings |
| `account_delete_initiated` | Delete modal opened | - |
| `account_deleted` | Account successfully deleted | - |

---

## API Calls

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/me/profile` | Page load | Get user email for delete confirmation |
| `POST /api/auth/logout` | Sign Out clicked | End user session |
| `DELETE /api/me/account` | Delete confirmed | Permanently delete account |

**Logout Response:**
```typescript
POST /api/auth/logout
{
  message: "Logged out successfully"
}
```

**Delete Account Response:**
```typescript
DELETE /api/me/account
{
  message: "Account deleted successfully",
  deleted: true
}
```

**Delete Account - Cascading Operations:**
The delete endpoint performs cascading deletes in order:
1. notifications
2. feed_activities
3. session_bookings (as student and as S-T)
4. homework_submissions
5. certificates
6. enrollments
7. student_teachers
8. contact_submissions
9. courses (if creator)
10. users (final)

---

## Notes

- Password change uses existing PWRS flow (no inline password change)
- Active sessions feature deferred - requires sessions table in schema
- Account deletion requires exact email match (case-insensitive)
- Deletion is hard-delete; consider soft-delete for production compliance
- All auth cookies cleared after logout or deletion
- Redirect includes query param for deleted accounts: `/?deleted=1`
