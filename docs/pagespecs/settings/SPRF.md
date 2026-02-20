# Page: Profile Settings

**Code:** SPRF
**URL:** `/settings/profile`
**Access:** Authenticated
**Priority:** P1
**Status:** Implemented

---

## Purpose

Allow users to edit their profile information including display name, handle, title, bio, contact info, social links, and privacy settings.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| SETT | "Profile" card/link | From main settings page |
| PROF | "Edit Profile" button | From public profile view |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| SETT | Breadcrumb "Settings" | Return to settings hub |
| PROF | "View Profile" link | Preview public profile (future) |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| users | name, handle, email, title, bio, avatar_url | Basic profile info |
| users | website, location | Contact & location |
| users | linkedin_url, twitter_url, youtube_url | Social links |
| users | privacy_public | Privacy control |
| users | is_student_teacher, is_creator | Role-specific display |

---

## Sections

### Header
- Page title: "Profile Settings"
- Description: "Update your profile information visible to other users"

### Basic Information
- **Display Name** input (required, max 100 chars)
- **Handle** input with @ prefix (required, 3-30 chars, unique)
  - Format: letters, numbers, underscores, hyphens
  - On-blur validation: format + uniqueness check via API
  - Error: "This handle is already taken"
- **Title** input (optional, max 100 chars)
  - Placeholder: "e.g., Software Engineer, Music Teacher"
- **Bio** textarea (optional, max 500 chars)
  - Character counter: "X/500"
  - Placeholder: "Tell others about yourself..."

### Contact & Location
- **Website** URL input (optional)
  - Placeholder: "https://yourwebsite.com"
- **Location** text input (optional, max 100 chars)
  - Placeholder: "e.g., New York, NY"

### Social Links
- **LinkedIn** URL input (optional)
  - Placeholder: "https://linkedin.com/in/yourprofile"
- **Twitter/X** URL input (optional)
  - Placeholder: "https://twitter.com/yourhandle"
- **YouTube** URL input (optional)
  - Placeholder: "https://youtube.com/@yourchannel"

### Privacy
- **Public Profile** toggle with description
  - "Allow anyone to view your profile. When disabled, only logged-in users can see your profile."

### Actions
- "Unsaved changes" indicator when form modified
- **Save Changes** button
  - Disabled when no changes or saving
  - Shows spinner during save

---

## User Stories Fulfilled

- US-S008: Student can update profile information
- US-S047: Control profile privacy settings
- US-P005: View and edit own profile

---

## States & Variations

| State | Description |
|-------|-------------|
| Loading | Skeleton animation while fetching profile |
| Error | Red border, error message, Retry button |
| Loaded | Form fields populated with current values |
| Has Changes | "Unsaved changes" indicator, Save button enabled |
| No Changes | Save button disabled with "No Changes" text |
| Saving | Save button shows spinner, disabled |
| Field Error | Amber/yellow alert, field highlighted with red border |
| Save Success | Green success message |

---

## Mobile Considerations

- Full-width inputs on mobile
- Section cards stack vertically
- Save button remains accessible (sticky bottom on mobile)

---

## Error Handling

| Error | Display |
|-------|---------|
| Failed to load profile | "Unable to load profile" with retry |
| Handle format invalid | "Must be 3-30 characters: letters, numbers, underscores, and hyphens" |
| Handle taken | "This handle is already taken" (inline) |
| Invalid URL | "[field] must be a valid URL" |
| Save fails | "Failed to save profile" (form-level error) |

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `page_view` | Page load | profile_settings |
| `profile_save` | Save button clicked | fields_changed |

---

## API Calls

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/me/profile` | Page load | Fetch current profile data |
| `GET /api/users/check-handle?handle=X` | Handle blur | Check handle uniqueness |
| `PATCH /api/me/profile` | Save clicked | Update profile fields |

**Profile Response:**
```typescript
GET /api/me/profile
{
  name: string,
  handle: string,
  email: string,
  title: string | null,
  bio: string | null,
  avatar_url: string | null,
  website: string | null,
  location: string | null,
  linkedin_url: string | null,
  twitter_url: string | null,
  youtube_url: string | null,
  privacy_public: boolean,
  is_student_teacher: boolean,
  is_creator: boolean
}
```

**Handle Check Response:**
```typescript
GET /api/users/check-handle?handle=newhandle
{
  available: boolean
}
```

**Update Request:**
```typescript
PATCH /api/me/profile
{
  name: string,
  handle: string,
  title: string | null,
  bio: string | null,
  website: string | null,
  location: string | null,
  linkedin_url: string | null,
  twitter_url: string | null,
  youtube_url: string | null,
  privacy_public: boolean
}
```

---

## Implementation Notes

- Avatar upload not yet implemented (future feature)
- Handle validation happens on blur, not on every keystroke
- Handle uniqueness check skips API call if unchanged from saved value
- URL fields validated on save (server-side)
- Changes tracked via JSON comparison to detect modifications
