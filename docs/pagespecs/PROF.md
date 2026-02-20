# Page: Profile

**Code:** PROF
**URL:** `/profile` or `/@:handle`
**Access:** Authenticated (own) / Public (others, if privacy_public)
**Priority:** P0
**Status:** In Scope

---

## Purpose

Display and edit user profile information, manage privacy settings, view achievements, and control public-facing profile elements.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| Nav | "Profile" link | Global navigation |
| SDSH | "Update Profile" | From dashboard |
| FEED | Author avatar click | Viewing others' profiles |
| MSGS | Participant avatar click | From messages |
| (External) | Direct URL | `/@sarah` |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| SETT | "Settings" / "Edit Settings" | Account settings |
| MSGS | "Message" (on others' profiles) | Start conversation |
| CPRO | (If user is Creator) | May redirect or show creator sections |
| STPR | (If user is ST) | May redirect or show ST sections |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| users | All profile fields | Profile display/edit |
| user_qualifications | sentence, display_order | Credentials (if ST/Creator) |
| user_expertise | tag | Expertise tags |
| user_interests | tag | Interest tags (students) |
| user_stats | all | Stats display |
| follows | count | Follower/following counts |
| certificates | type, course_id, issued_at | Achievements |
| enrollments | count, status | Learning stats |
| user_goodwill | total_earned, balance, spent | Goodwill points (Block 2+) |

---

## Sections

### Profile Header
- **Avatar:** Large, editable (own profile)
- **Name:** Display name
- **Handle:** @handle
- **Title:** Professional title (optional)
- **Bio:** Short bio
- **Role badges:** Student, ST, Creator indicators
- **Edit button** (own profile only)
- **Follow/Message buttons** (others' profiles)

### Stats Bar
- Followers / Following counts
- Courses enrolled/completed (students)
- Students taught (STs)
- Courses created (creators)

### Interests (Students)
- Tag pills of interests
- Editable on own profile

### Expertise (STs/Creators)
- Tag pills of expertise areas
- Editable on own profile

### Qualifications (STs/Creators)
- List of credentials
- Editable on own profile

### Learning Progress (Students)
- Courses in progress
- Completion stats
- Certificates earned
- "View All Certificates"

### Teaching Activity (STs)
- Courses certified to teach
- Students taught
- Teaching stats

### Goodwill Points (Block 2+ - Own Profile Only)
- **Public View (others):**
  - Total earned points: "847 earned"
  - Breakdown by category
- **Private View (own):**
  - Total Earned
  - Spent (given to others)
  - Available Balance
  - "View History" → transaction log

### Available to Help Toggle (STs - Block 2+)
- Toggle switch: "Available to Help"
- When on, shows in ST directory for Summon

### Privacy Settings
- "Public Profile" toggle (own only)
- Controls visibility to non-authenticated users

### Followers/Following (Collapsible)
- Lists of followers and following
- Avatar + name + follow/unfollow button

---

## User Stories Fulfilled

- US-P005: View and edit own profile
- US-S008: Student can update profile
- US-S047: Control profile privacy
- US-S048: Follow other users
- US-S049: Be followed by others
- US-S067: View own goodwill points
- US-S068: See goodwill breakdown
- US-T020: ST toggle availability

---

## States & Variations

| State | Description |
|-------|-------------|
| Own Profile (View) | Full profile with edit options |
| Own Profile (Edit) | Edit mode with form fields |
| Other's Profile (Public) | View-only, follow/message options |
| Other's Profile (Private) | "This profile is private" |
| Student Profile | Learning-focused sections |
| ST Profile | Teaching sections visible |
| Creator Profile | Redirects to or embeds CPRO |
| Multi-Role | Shows all relevant sections |

---

## Mobile Considerations

- Header stacks vertically
- Sections become accordion/tabs
- Edit mode is separate screen or modal
- Stats in horizontal scroll

---

## Error Handling

| Error | Display |
|-------|---------|
| Profile not found | 404: "User not found" |
| Profile private | "This profile is private" |
| Update fails | "Unable to save. Please try again." |
| Avatar upload fails | "Unable to upload image. Try again." |

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `page_view` | Page load | is_own, user_id |
| `profile_edit` | Edit mode entered | - |
| `profile_updated` | Changes saved | fields_changed |
| `follow_click` | Follow button clicked | target_user_id |
| `message_click` | Message button clicked | target_user_id |
| `privacy_toggled` | Privacy changed | new_value |

---

## API Calls

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/users/me` | Page load (own) | Own profile data |
| `GET /api/users/:handle` | Page load (other) | Other user's profile |
| `PUT /api/users/me` | Save changes | Update profile fields |
| `POST /api/users/me/avatar` | Avatar upload | Upload new avatar |
| `GET /api/users/:handle/stats` | Page load | User statistics |
| `GET /api/users/:handle/certificates` | Page load | Earned certificates |
| `GET /api/users/:handle/followers` | Expand section | Follower list |
| `GET /api/users/:handle/following` | Expand section | Following list |
| `POST /api/follows` | Follow clicked | Follow user |
| `DELETE /api/follows/:id` | Unfollow clicked | Unfollow user |
| `GET /api/users/me/follows/:user_id` | Page load (auth) | Check if following |
| `GET /api/users/me/goodwill` | Page load (own, Block 2+) | Goodwill points |
| `PUT /api/users/me/availability` | Toggle (ST) | Update availability |

**Profile Response:**
```typescript
GET /api/users/:handle
{
  id, name, handle, avatar, title, bio,
  privacy_public: boolean,
  roles: string[],  // ['student', 'st', 'creator']
  qualifications: [{ sentence, display_order }],
  expertise: string[],
  interests: string[]
}
```

**Stats Response:**
```typescript
GET /api/users/:handle/stats
{
  followers_count, following_count,
  courses_enrolled, courses_completed,  // students
  students_taught, sessions_conducted,  // STs
  courses_created, total_students       // creators
}
```

**Profile Update:**
```typescript
PUT /api/users/me
{
  name?, title?, bio?,
  privacy_public?,
  interests?: string[],
  expertise?: string[],
  qualifications?: [{ sentence }]
}
```

**Goodwill Response (Block 2+):**
```typescript
GET /api/users/me/goodwill
{
  total_earned, spent, balance,
  breakdown: [{ category, amount }]
}
```

---

## Notes

- Consider unified profile page that adapts to role
- STPR and CPRO may be variants of PROF rather than separate pages
- Avatar upload: Consider size/format restrictions
- Handle uniqueness check on registration/edit
