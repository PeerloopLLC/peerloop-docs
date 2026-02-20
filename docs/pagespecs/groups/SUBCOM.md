# Page: Sub-Community

**Code:** SUBCOM
**URL:** `/community/:slug`
**Access:** Authenticated (Members only, or Public if open)
**Priority:** P3
**Status:** Out of Scope (Post-MVP)

---

## Purpose

User-created sub-communities for study groups, interest clusters, or private collaboration spaces within the platform.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| FEED | Sub-community card/link | From main feed |
| SDSH | "My Communities" section | Dashboard widget |
| NOTF | Community notification | Invited to join |
| (Direct) | Shared invite link | External share |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| STPR | Click member name | View member profile |
| FEED | Back/breadcrumb | Return to main feed |
| MSGS | "Message" button | DM a member |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| sub_communities | id, name, slug, description, visibility, creator_id | Community info |
| sub_community_members | user_id, community_id, role, joined_at | Membership |
| sub_community_posts | id, content, author_id, created_at | Community feed |
| sub_community_invites | email, token, status | Pending invites |

---

## Sections

### Header
- Community name + description
- Member count
- Join/Leave button (or "Pending" if invite-only)
- Settings gear (for owner/admins)

### Community Feed
- Posts from members only
- Same feed UI as main FEED (cards, reactions, comments)
- "New Post" composer

### Members Sidebar (Desktop) / Tab (Mobile)
- Member list with avatars
- Owner/Admin badges
- "Invite Members" button (if permitted)

### Settings Panel (Owner/Admin only)
- Edit name/description
- Visibility toggle (Public/Invite-only)
- Manage members (remove, promote to admin)
- Invite settings (who can invite)
- Delete community

### Invite Flow
- Search users by name/email
- Send invite (creates notification)
- Pending invites list
- Invite link generation

---

## User Stories Fulfilled

- US-S081: As a Student, I need to create a sub-community and invite specific users so that I can form study groups or interest clusters
- US-P097: As a System, I need to support user-created sub-communities with invite functionality so that users can organize privately

---

## States & Variations

| State | Description |
|-------|-------------|
| Member View | Full access to feed and members |
| Non-Member (Public) | Can see feed, join button visible |
| Non-Member (Private) | "Request to Join" or "Invite Only" message |
| Owner View | Full access + settings panel |
| Empty | No posts yet - prompt to start conversation |

---

## Mobile Considerations

- Members list as bottom sheet or separate tab
- Settings accessed via menu
- Invite flow as modal

---

## Error Handling

| Error | Display |
|-------|---------|
| Load fails | "Unable to load community. [Retry]" |
| Not found | "This community doesn't exist or is private" |
| Already member | "You're already a member" |
| Invite expired | "This invite has expired" |

---

## Analytics Events

| Event | Trigger |
|-------|---------|
| sub_community_viewed | Page load |
| sub_community_joined | User joins |
| sub_community_post_created | New post |
| sub_community_member_invited | Invite sent |

---

## Server Integration

### Feature Flag
```typescript
// Requires: canAccess('sub_communities')
// Depends on: community_feed
```

### API Endpoints Called

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/communities/:slug` | Page load | Get community details |
| `GET /api/communities/:slug/feed` | Page load | Get community posts |
| `POST /api/communities/:slug/posts` | Create post | Add to community feed |
| `POST /api/communities/:slug/join` | Join clicked | Join community |
| `DELETE /api/communities/:slug/leave` | Leave clicked | Leave community |
| `POST /api/communities/:slug/invite` | Invite member | Send invite |
| `PUT /api/communities/:slug` | Edit settings | Update community |

### Community Feed (Stream.io)

```typescript
// Sub-communities use Stream.io with separate feed group:
// Feed: subcommunity:{community_id}

// On page load:
1. GET /api/communities/:slug → { community, membership }
2. POST /api/stream/token { feeds: ['subcommunity:{id}'] }
3. Connect to Stream, subscribe to feed

// Post to community:
POST /api/communities/:slug/posts {
  content: string
}
// Backend: Store in DB + publish to Stream feed
```

### Join/Leave Flow

```typescript
// POST /api/communities/:slug/join
// For public communities: instant join
// For private communities: creates pending request

// Backend:
1. Check visibility (public vs private)
2. If public: INSERT INTO sub_community_members
3. If private: INSERT INTO sub_community_requests (pending)
4. Notify community owner

// DELETE /api/communities/:slug/leave
1. DELETE FROM sub_community_members
2. Remove from Stream feed followers
```

### Invite System

```typescript
// POST /api/communities/:slug/invite
{
  user_id?: string,      // Existing user
  email?: string         // External invite
}

// Backend:
1. Create invite record in sub_community_invites
2. If user_id: Create notification
3. If email: Send email invite via Resend
4. Generate invite link with token

// Accept invite:
POST /api/communities/invite/:token/accept
1. Validate token not expired
2. Add user to members
3. Mark invite as used
```

### Moderation

```typescript
// Community owner/admins can:
POST /api/communities/:slug/members/:id/remove  // Remove member
POST /api/communities/:slug/members/:id/promote // Make admin
POST /api/communities/:slug/posts/:id/delete    // Delete post

// Platform moderators:
// Access via MODQ with community_id filter
// Can delete posts, suspend communities
```

### Data Flow Diagram

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│   SUBCOM    │      │  PeerLoop   │      │  Stream.io  │
│   (Client)  │      │  (Server)   │      │   (Feeds)   │
└──────┬──────┘      └──────┬──────┘      └──────┬──────┘
       │                    │                    │
       │ GET /communities/  │                    │
       │   :slug            │                    │
       │───────────────────>│                    │
       │                    │ Check membership   │
       │ { community, role }│                    │
       │<───────────────────│                    │
       │                    │                    │
       │ POST /stream/token │                    │
       │ { feeds: [subcom:X]}                    │
       │───────────────────>│                    │
       │                    │ Generate token     │
       │ { token }          │                    │
       │<───────────────────│                    │
       │                    │                    │
       │ Connect to subcommunity:X feed          │
       │─────────────────────────────────────────>
       │ { posts }                               │
       │<─────────────────────────────────────────
       │                    │                    │
       │ POST /communities/ │                    │
       │   :slug/posts      │                    │
       │───────────────────>│                    │
       │                    │ Store + publish    │
       │                    │───────────────────>│
       │ { post }           │                    │
       │<───────────────────│                    │
```

### Limits & Constraints

```typescript
// Anti-abuse limits:
MAX_COMMUNITIES_PER_USER: 5       // Can create max 5
MAX_MEMBERS_PER_COMMUNITY: 100    // Free tier
MAX_INVITES_PER_DAY: 20           // Rate limit

// Stored in features config or hardcoded initially
```

---

## Notes

- **Feature Flag:** `sub_communities` - check with `canAccess('sub_communities')`
- **Dependencies:** Requires `community_feed` feature enabled
- Uses Stream.io `subcommunity` feed group (separate from main feeds)
- Consider limits: max communities per user (5), max members (100)
- Moderation: Platform moderators access via MODQ
- Sub-community posts do NOT appear in main feed (isolated)
- CD-032 source: Fraser Meeting Notes mention study groups
