# MINV - Moderator Invite

| Field | Value |
|-------|-------|
| Route | `/invite/moderator/:token` |
| Access | Public (valid token required) |
| Priority | P1 |
| Status | 📋 Spec Only |
| Block | 8 |
| JSON Spec | `src/data/pages/invite/mod/[token].json` |
| Astro Page | `src/pages/invite/mod/[token].astro` |

---

## Purpose

Landing page for moderator invite acceptance. Allows invitees to accept or decline a moderator invitation sent by an admin.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-A034 | As an Admin, I need to invite users to become moderators so that I can grow the mod team | P1 | 📋 |
| US-P104 | As a User, I need to accept a moderator invitation so that I can help moderate | P1 | 📋 |
| US-P105 | As a User, I need to decline a moderator invitation so that I can opt out | P1 | 📋 |
| US-P106 | As a User, I need to create account while accepting invite so that new users can become mods | P1 | 📋 |

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| (Email) | Invite email link | Primary entry point |
| LGIN | Redirect after login | If user logged in to accept |
| SGUP | Redirect after signup | New user accepting invite |

### Outgoing (users navigate to)

| Target | Trigger | Notes | Status |
|--------|---------|-------|--------|
| SGUP | "Accept" (not logged in, no account) | Create account first | 📋 |
| LGIN | "Accept" (not logged in, has account) | Login first | 📋 |
| SDSH | Accept successful | Redirect to dashboard | 📋 |
| HOME | Decline | Return to homepage | 📋 |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| moderator_invites | id, email, status, invited_by, expires_at | Invite validation |
| users (inviter) | name | Display who sent invite |

---

## Features

### Token Validation
- [ ] Validate token from URL `[US-P104]`
- [ ] Check token not expired `[US-P104]`
- [ ] Check status is 'pending' `[US-P104]`
- [ ] Show error if invalid/expired `[US-P104]`

### Invite Details
- [ ] "You've Been Invited!" header `[US-P104]`
- [ ] "[Admin Name] invited you to be a moderator" message `[US-P104]`
- [ ] Role description and responsibilities `[US-P104]`
- [ ] Masked invitation email `[US-P104]`
- [ ] Expiration date/time `[US-P104]`

### Action Buttons
- [ ] Accept Invitation button `[US-P104]`
- [ ] "I agree to moderator guidelines" checkbox `[US-P104]`
- [ ] Decline link with confirmation `[US-P105]`

### Authentication Flow
- [ ] "Already have an account? Login" option `[US-P104]`
- [ ] "New to PeerLoop? Sign Up" option `[US-P106]`
- [ ] Pre-fill email from invite on signup `[US-P106]`
- [ ] Return to this page after auth `[US-P104]`

### Success State
- [ ] "Welcome, Moderator!" message `[US-P104]`
- [ ] Brief onboarding info `[US-P104]`
- [ ] "Go to Dashboard" button `[US-P104]`

### Error States
- [ ] Invalid Token: "Contact admin for new invite" `[US-P104]`
- [ ] Expired Token: "This invite has expired" `[US-P104]`
- [ ] Already Used: "This invite was already used" `[US-P104]`

---

## Sections (from Plan)

### Token Validation
- On page load, validate token

### Invite Details
- Header with invitation message
- Role description
- Expiration info

### Action Buttons
- Accept / Decline
- Terms agreement

### Authentication Flow
- Login or Signup options

### Success / Error States
- Post-action feedback

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/moderator-invites/:token` | GET | Validate token, get invite details | 📋 |
| `/api/moderator-invites/:token/accept` | POST | Accept invitation | 📋 |
| `/api/moderator-invites/:token/decline` | POST | Decline invitation | 📋 |

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

## Error Handling

| Error | Display |
|-------|---------|
| Invalid token | "Invalid invite link. Request a new invitation." |
| Expired token | "This invitation has expired." |
| Already used | "This invitation has already been used." |
| Accept fails | "Unable to process. Please try again." |
| Network error | "Connection error. Check your internet." |

---

## Mobile Considerations

- Simple, single-column layout
- Large, prominent action buttons
- Easy to complete from email on mobile

---

## Implementation Notes

- Token is single-use, tied to specific email
- Invite expires after configured period (e.g., 7 days)
- Email in invite must match authenticated user's email
- New users can signup with invite email pre-filled
- Consider magic link pattern (accept without login) in future
- Source: Brian Review 2025-12-26
