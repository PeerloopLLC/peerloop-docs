# PROF - Profile

| Field | Value |
|-------|-------|
| Route | `/profile` or `/@:handle` |
| Access | Authenticated (own) / Public (others, if privacy_public) |
| Priority | P0 |
| Status | 📋 Spec Only |
| Block | 9 |
| JSON Spec | `src/data/pages/profile.json` |
| Astro Page | `src/pages/profile.astro` |

---

## Purpose

Display and edit user profile information, manage privacy settings, view achievements, and control public-facing profile elements.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-P005 | As a Platform, I need profile pages so that users can present themselves | P0 | 📋 |
| US-S008 | As a Student, I need to update my profile so that others know about me | P0 | 📋 |
| US-S047 | As a Student, I need to control profile privacy so that I manage visibility | P0 | 📋 |
| US-S048 | As a Student, I need to follow other users so that I see their activity | P0 | 📋 |
| US-S049 | As a Student, I need to be followed by others so that I build connections | P0 | 📋 |
| US-S067 | As a Student, I need to view my goodwill points so that I track engagement | P2 | 📋 |
| US-S068 | As a Student, I need to see goodwill breakdown so that I understand where I earned | P2 | 📋 |
| US-T020 | As a S-T, I need to toggle availability so that students can summon me | P2 | 📋 |

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

| Target | Trigger | Notes | Status |
|--------|---------|-------|--------|
| SETT | "Settings" / "Edit Settings" | Account settings | 📋 |
| MSGS | "Message" (on others' profiles) | Start conversation | 📋 |
| CPRO | (If user is Creator) | May redirect or show creator sections | 📋 |
| STPR | (If user is ST) | May redirect or show ST sections | 📋 |

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

## Features

### Profile Header
- [ ] Large avatar (editable on own profile) `[US-S008]`
- [ ] Display name `[US-S008]`
- [ ] @handle `[US-S008]`
- [ ] Professional title (optional) `[US-S008]`
- [ ] Short bio `[US-S008]`
- [ ] Role badges (Student, ST, Creator) `[US-P005]`
- [ ] Edit button (own profile only) `[US-S008]`
- [ ] Follow/Message buttons (others' profiles) `[US-S048]`

### Stats Bar
- [ ] Followers / Following counts `[US-S048]`
- [ ] Courses enrolled/completed (students) `[US-P005]`
- [ ] Students taught (STs) `[US-P005]`
- [ ] Courses created (creators) `[US-P005]`

### Interests (Students)
- [ ] Tag pills of interests `[US-S008]`
- [ ] Editable on own profile `[US-S008]`

### Expertise (STs/Creators)
- [ ] Tag pills of expertise areas `[US-P005]`
- [ ] Editable on own profile `[US-S008]`

### Qualifications (STs/Creators)
- [ ] List of credentials `[US-P005]`
- [ ] Editable on own profile `[US-S008]`

### Learning Progress (Students)
- [ ] Courses in progress `[US-P005]`
- [ ] Completion stats `[US-P005]`
- [ ] Certificates earned `[US-P005]`
- [ ] "View All Certificates" link `[US-P005]`

### Teaching Activity (STs)
- [ ] Courses certified to teach `[US-P005]`
- [ ] Students taught `[US-P005]`
- [ ] Teaching stats `[US-P005]`

### Goodwill Points (Block 2+ - Own Profile Only)
- [ ] Total earned points `[US-S067]`
- [ ] Breakdown by category `[US-S068]`
- [ ] Spent (given to others) `[US-S068]`
- [ ] Available balance `[US-S067]`
- [ ] "View History" → transaction log `[US-S068]`

### Available to Help Toggle (STs - Block 2+)
- [ ] Toggle switch: "Available to Help" `[US-T020]`
- [ ] Shows in ST directory for Summon when enabled `[US-T020]`

### Privacy Settings
- [ ] "Public Profile" toggle (own only) `[US-S047]`
- [ ] Controls visibility to non-authenticated users `[US-S047]`

### Followers/Following
- [ ] Collapsible lists `[US-S049]`
- [ ] Avatar + name + follow/unfollow button `[US-S048]`

---

## Sections (from Plan)

### Profile Header
- Avatar (large, editable)
- Name, handle, title, bio
- Role badges
- Edit / Follow / Message buttons

### Stats Bar
- Followers / Following
- Learning / Teaching stats

### Interests / Expertise / Qualifications
- Tag pills
- Editable on own profile

### Learning Progress / Teaching Activity
- Role-appropriate sections

### Goodwill Points (Own Profile)
- Balance and breakdown
- View history

### Followers/Following
- Expandable lists

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/users/me` | GET | Own profile data | 📋 |
| `/api/users/:handle` | GET | Other user's profile | 📋 |
| `/api/users/me` | PUT | Update profile fields | 📋 |
| `/api/users/me/avatar` | POST | Upload new avatar | 📋 |
| `/api/users/:handle/stats` | GET | User statistics | 📋 |
| `/api/users/:handle/certificates` | GET | Earned certificates | 📋 |
| `/api/users/:handle/followers` | GET | Follower list | 📋 |
| `/api/users/:handle/following` | GET | Following list | 📋 |
| `/api/follows` | POST | Follow user | 📋 |
| `/api/follows/:id` | DELETE | Unfollow user | 📋 |
| `/api/users/me/goodwill` | GET | Goodwill points (Block 2+) | 📋 |
| `/api/users/me/availability` | PUT | Update availability (ST) | 📋 |

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

## Error Handling

| Error | Display |
|-------|---------|
| Profile not found | 404: "User not found" |
| Profile private | "This profile is private" |
| Update fails | "Unable to save. Please try again." |
| Avatar upload fails | "Unable to upload image. Try again." |

---

## Mobile Considerations

- Header stacks vertically
- Sections become accordion/tabs
- Edit mode is separate screen or modal
- Stats in horizontal scroll

---

## Implementation Notes

- Consider unified profile page that adapts to role
- STPR and CPRO may be variants of PROF rather than separate pages
- Avatar upload: Size/format restrictions (max 2MB, jpg/png)
- Handle uniqueness check on registration/edit
- Avatar uploads stored in R2
