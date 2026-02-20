# Page: Moderator Invite

**Code:** MINV
**URL:** `/invite/moderator/:token`
**Access:** Public (valid token required)
**Priority:** P1
**Status:** In Scope

---

## Purpose

Landing page for moderator invite acceptance. Allows invitees to accept or decline a moderator invitation sent by an admin.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| (Email) | Invite email link | Primary entry point |
| LGIN | Redirect after login | If user logged in to accept |
| SGUP | Redirect after signup | New user accepting invite |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| SGUP | "Accept" (not logged in, no account) | Create account first |
| LGIN | "Accept" (not logged in, has account) | Login first |
| SDSH | Accept successful | Redirect to dashboard |
| HOME | Decline | Return to homepage |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| moderator_invites | id, email, status, invited_by, expires_at | Invite validation |
| users (inviter) | name | Display who sent invite |

---

## Sections

### Token Validation (Page Load)
- Validate token from URL
- Check token not expired
- Check status is 'pending'
- If invalid/expired: show error state

### Invite Details
- **Header:** "You've Been Invited!"
- **Message:** "[Admin Name] has invited you to become a moderator on PeerLoop"
- **Role Description:**
  - What moderators do
  - Responsibilities overview
  - Community guidelines link
- **Invitation Email:** (masked, e.g., j***@example.com)
- **Expires:** Date/time remaining

### Action Buttons
- **Accept Invitation:**
  - If logged in: immediately accept
  - If not logged in: prompt to login or signup
  - Checkbox: "I agree to the moderator guidelines"
- **Decline Invitation:**
  - "No thanks" link
  - Confirmation modal
  - Updates status to 'declined'

### Authentication Flow (if not logged in)
- **Existing Account:**
  - "Already have an account? [Login]"
  - Redirects to LGIN with return URL
  - After login, returns here and accepts
- **New Account:**
  - "New to PeerLoop? [Sign Up]"
  - Redirects to SGUP with return URL
  - Pre-fills email from invite
  - After signup, returns here and accepts

### Success State
- "Welcome, Moderator!"
- Brief onboarding info
- "Go to Dashboard" button → SDSH
- Access to moderation queue info

### Error States
- **Invalid Token:**
  - "This invite link is invalid"
  - "Contact admin for a new invite"
- **Expired Token:**
  - "This invite has expired"
  - "Contact admin for a new invite"
- **Already Used:**
  - "This invite has already been used"
  - If accepted: "You're already a moderator"

---

## User Stories Fulfilled

- US-A034: Invite users to become moderators via email
- US-P104: Accept a moderator invitation
- US-P105: Decline a moderator invitation
- US-P106: Create account while accepting moderator invite

---

## States & Variations

| State | Description |
|-------|-------------|
| Valid Invite | Token valid, pending acceptance |
| Logged In | User authenticated, can accept directly |
| Not Logged In | Must login/signup first |
| Accepted | Success confirmation |
| Declined | Declined confirmation |
| Invalid Token | Token not found or malformed |
| Expired | Token past expiration date |
| Already Used | Invite already accepted/declined |

---

## Mobile Considerations

- Simple, single-column layout
- Large, prominent action buttons
- Easy to complete from email on mobile

---

## Error Handling

| Error | Display |
|-------|---------|
| Invalid token | "Invalid invite link. Request a new invitation." |
| Expired token | "This invitation has expired." |
| Already used | "This invitation has already been used." |
| Accept fails | "Unable to process. Please try again." |
| Network error | "Connection error. Check your internet." |

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `page_view` | Page load | token_valid, invite_status |
| `invite_accepted` | Accept clicked | invite_id |
| `invite_declined` | Decline clicked | invite_id |
| `login_redirect` | Login needed | invite_id |
| `signup_redirect` | Signup needed | invite_id |

---

## API Calls

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/moderator-invites/:token` | Page load | Validate token, get invite details |
| `POST /api/moderator-invites/:token/accept` | Accept clicked | Accept invitation |
| `POST /api/moderator-invites/:token/decline` | Decline clicked | Decline invitation |

**Token Validation Response:**
```typescript
GET /api/moderator-invites/:token
{
  valid: true,
  status: 'pending',
  email_masked: 'j***@example.com',
  invited_by: 'Admin Name',
  expires_at: '2025-01-02T00:00:00Z',
  days_remaining: 7
}
```

**Accept Flow:**
```typescript
POST /api/moderator-invites/:token/accept
// Requires authentication

// If authenticated:
// 1. Verify token matches authenticated user's email
// 2. Set user.is_moderator = true
// 3. Update invite.status = 'accepted'
// 4. Return { success: true, redirect: '/dashboard' }

// If not authenticated:
// Return { requires_auth: true, return_url: '/invite/moderator/:token' }
```

**Decline Flow:**
```typescript
POST /api/moderator-invites/:token/decline
// No auth required

// 1. Update invite.status = 'declined'
// 2. Return { success: true }
```

---

## Notes

- Token is single-use, tied to specific email
- Invite expires after configured period (e.g., 7 days)
- Email in invite must match authenticated user's email
- New users can signup with invite email pre-filled
- Consider allowing accept without login (magic link pattern) in future
- Source: Brian Review 2025-12-26
