# SUBCOM - Sub-Community

| Field | Value |
|-------|-------|
| Route | `/community/:slug` |
| Access | Authenticated (Members only, or Public if open) |
| Priority | P3 |
| Status | 📋 Spec Only (Post-MVP) |
| Block | - |
| JSON Spec | `src/data/pages/groups/[id].json` |
| Astro Page | `src/pages/groups/[id].astro` |

---

## Purpose

User-created sub-communities for study groups, interest clusters, or private collaboration spaces within the platform.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-S081 | As a Student, I need to create sub-communities and invite users so that I can form study groups | P3 | 📋 |
| US-P097 | As a Platform, I need to support user-created sub-communities so that users can organize privately | P3 | 📋 |

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

| Target | Trigger | Notes | Status |
|--------|---------|-------|--------|
| STPR | Click member name | View member profile | 📋 |
| FEED | Back/breadcrumb | Return to main feed | 📋 |
| MSGS | "Message" button | DM a member | 📋 |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| sub_communities | id, name, slug, description, visibility, creator_id | Community info |
| sub_community_members | user_id, community_id, role, joined_at | Membership |
| sub_community_posts | id, content, author_id, created_at | Community feed |
| sub_community_invites | email, token, status | Pending invites |

---

## Features

### Header
- [ ] Community name + description `[US-S081]`
- [ ] Member count `[US-S081]`
- [ ] Join/Leave button `[US-S081]`
- [ ] Settings gear (for owner/admins) `[US-S081]`

### Community Feed
- [ ] Posts from members only `[US-S081]`
- [ ] Same feed UI as main FEED `[US-S081]`
- [ ] "New Post" composer `[US-S081]`

### Members List
- [ ] Member list with avatars `[US-S081]`
- [ ] Owner/Admin badges `[US-S081]`
- [ ] "Invite Members" button `[US-S081]`

### Settings Panel (Owner/Admin)
- [ ] Edit name/description `[US-S081]`
- [ ] Visibility toggle (Public/Invite-only) `[US-S081]`
- [ ] Manage members (remove, promote) `[US-S081]`
- [ ] Invite settings `[US-S081]`
- [ ] Delete community `[US-S081]`

### Invite Flow
- [ ] Search users by name/email `[US-S081]`
- [ ] Send invite notification `[US-S081]`
- [ ] Pending invites list `[US-S081]`
- [ ] Invite link generation `[US-S081]`

---

## Sections (from Plan)

### Header
- Community name + description
- Member count
- Join/Leave/Request button
- Settings gear (admins)

### Community Feed
- Member-only posts
- Same UI as FEED
- Post composer

### Members Sidebar (Desktop) / Tab (Mobile)
- Member avatars
- Role badges
- Invite button

### Settings Panel
- Name/description editing
- Visibility toggle
- Member management
- Delete option

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/communities/:slug` | GET | Get community details | 📋 |
| `/api/communities/:slug/feed` | GET | Get community posts | 📋 |
| `/api/communities/:slug/posts` | POST | Add to community feed | 📋 |
| `/api/communities/:slug/join` | POST | Join community | 📋 |
| `/api/communities/:slug/leave` | DELETE | Leave community | 📋 |
| `/api/communities/:slug/invite` | POST | Send invite | 📋 |
| `/api/communities/:slug` | PUT | Update community | 📋 |
| `/api/communities/invite/:token/accept` | POST | Accept invite | 📋 |

**Join/Leave Flow:**
```typescript
// POST /api/communities/:slug/join
// For public: instant join
// For private: creates pending request

// DELETE /api/communities/:slug/leave
// Removes from members and Stream feed followers
```

**Invite System:**
```typescript
POST /api/communities/:slug/invite
{
  user_id?: string,      // Existing user
  email?: string         // External invite
}

// Creates invite record
// Sends notification or email
// Returns invite link
```

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

## Error Handling

| Error | Display |
|-------|---------|
| Load fails | "Unable to load community. [Retry]" |
| Not found | "This community doesn't exist or is private" |
| Already member | "You're already a member" |
| Invite expired | "This invite has expired" |

---

## Mobile Considerations

- Members list as bottom sheet or separate tab
- Settings accessed via menu
- Invite flow as modal

---

## Implementation Notes

- **Feature Flag:** `sub_communities` - check with `canAccess('sub_communities')`
- **Dependencies:** Requires `community_feed` feature enabled
- Uses Stream.io `subcommunity` feed group (separate from main feeds)
- Limits: max 5 communities per user, max 100 members
- Moderation: Platform moderators access via MODQ
- Sub-community posts do NOT appear in main feed (isolated)
- CD-032 source: Fraser Meeting Notes mention study groups
