# Page: Creator Studio

**Code:** STUD
**URL:** `/studio` or `/studio/:course_id`
**Access:** Authenticated (Creator role)
**Priority:** P0
**Status:** In Scope

---

## Purpose

Course creation and management interface for Creators to build, edit, publish, and manage their courses and curriculum.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| CDSH | "Creator Studio" / "Manage Courses" | From dashboard |
| CDSH | "Create New Course" | Direct to new course |
| Nav | "Studio" link (Creators) | Global navigation |
| CDET | "Edit Course" (own course) | Edit specific course |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| CDSH | "Dashboard" / back | Return to dashboard |
| CDET | "Preview Course" | View public course page |
| CPRO | "View Profile" | See creator profile |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| courses | All fields | Course creation/editing |
| course_curriculum | All fields | Module management |
| course_objectives | objective, display_order | Learning objectives |
| course_includes | item, display_order | Included items |
| course_prerequisites | type, content, display_order | Prerequisites |
| course_target_audience | description, display_order | Target audience |
| course_tags | tag | Course tags |
| categories | id, name | Category selection |
| peerloop_features | All fields | Feature toggles |
| homework_assignments | All fields | Homework management |
| session_resources | All fields | Course resources |

---

## Sections

### Studio Header
- "Creator Studio" title
- "New Course" button
- "Dashboard" link → CDSH

### Course List (Main View: `/studio`)
- Grid/list of creator's courses
- Each shows:
  - Thumbnail
  - Title
  - Status badge (Draft, Published, Retired)
  - Student count
  - "Edit" button → `/studio/:course_id`
  - Quick actions: Publish/Unpublish, View, Delete
- "Create New Course" CTA

### Course Editor (Edit View: `/studio/:course_id`)

#### Left Sidebar - Navigation
- Course Settings
- Basic Info
- Curriculum
- Homework
- Resources
- Objectives & Includes
- Prerequisites
- Pricing
- Student-Teachers
- Publishing

#### Section: Basic Info
- **Title:** Text input
- **Slug:** Auto-generated, editable
- **Tagline:** Short description (150 chars)
- **Description:** Rich text editor
- **Thumbnail:** Image upload
- **Category:** Dropdown
- **Level:** Beginner/Intermediate/Advanced
- **Tags:** Tag input (multiple)

#### Section: Curriculum
- **Module List:**
  - Drag-to-reorder
  - Add/remove modules
- **Per Module:**
  - Title
  - Description
  - Duration
  - Session number (for grouping)
  - Video URL (external link)
  - Document URL (external link)
  - Learning objectives (this module)
  - Topics covered
  - Hands-on exercise
- "Add Module" button
- Bulk import (future)

#### Section: Homework
- **Assignment List:**
  - All homework assignments for course
  - Each shows: title, required/optional, linked module (if any)
  - Drag-to-reorder
- **Per Assignment (Edit):**
  - Title
  - Description
  - Instructions (rich text)
  - Module link (optional - assign to specific module)
  - Due within X days (optional)
  - Required for completion toggle
  - Max points (optional, for graded assignments)
  - Active toggle
- **Actions:**
  - "Add Assignment" button
  - Delete assignment
  - Preview assignment
- **Source:** Brian Review 2025-12-26

#### Section: Resources
- **Resource List:**
  - Course-level resources (slides, docs, files)
  - Each shows: name, type, size, upload date
  - Delete option
- **Upload:**
  - "Upload Resource" button
  - Drag-and-drop area
  - File types: PDF, DOC, PPT, images, videos
  - Max file size (e.g., 100MB)
- **Resource Types:**
  - Slides/presentations
  - Documents
  - Videos (uploaded, not YouTube links)
  - Other files
- **Note:** Session recordings appear automatically after sessions
- **Source:** Brian Review 2025-12-26

#### Section: Objectives & Includes
- **Learning Objectives:**
  - List of objectives
  - Add/remove/reorder
- **What's Included:**
  - List of included items
  - Add/remove/reorder

#### Section: Prerequisites
- **Required:**
  - List of required prerequisites
- **Nice to Have:**
  - Optional recommendations
- **Not Required:**
  - Things students don't need

#### Section: Target Audience
- List of audience descriptions
- Who is this course for?

#### Section: Pricing
- **Price:** Currency input (cents → dollars display)
- **Currency:** Dropdown (default USD)
- **Lifetime Access:** Toggle
- **Certificate:** Toggle + certificate name

#### Section: PeerLoop Features
- **1-on-1 Teaching:** Toggle
- **Certified Teachers:** Toggle
- **Earn While Teaching:** Toggle
- **Teacher Commission:** Percentage input

#### Section: Student-Teachers
- List of certified STs for this course
- Pending applications
- Approve/revoke certification
- Link to TDSH for each ST

#### Section: Publishing
- **Status:** Draft / Published / Retired
- **Publish** button (if draft)
- **Unpublish** button (if published)
- **Preview** → CDET
- Publishing checklist:
  - [ ] Title set
  - [ ] Description added
  - [ ] At least 1 module
  - [ ] Thumbnail uploaded
  - [ ] Price set

---

## User Stories Fulfilled

- US-C001: Create new course
- US-C002: Edit course details
- US-C003: Manage course content/curriculum
- US-C010: Set course pricing
- US-C034: Publish/unpublish courses

---

## States & Variations

| State | Description |
|-------|-------------|
| Course List | Viewing all courses |
| New Course | Creating new course (empty form) |
| Editing Draft | Editing unpublished course |
| Editing Published | Editing live course (with warnings) |
| Publishing | Publishing flow with checklist |
| No Courses | Empty state, "Create your first course" |

---

## Mobile Considerations

- Course list is primary on mobile
- Editor sections become full-screen views
- Simplified drag-and-drop for curriculum
- Critical actions (save, publish) always visible

---

## Error Handling

| Error | Display |
|-------|---------|
| Save fails | "Unable to save. Please try again." |
| Publish fails | "Unable to publish. Check required fields." |
| Image upload fails | "Unable to upload image. Try again." |
| Slug conflict | "This URL is already taken. Choose another." |

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `page_view` | Page load | view (list/edit), course_id |
| `course_created` | New course started | - |
| `course_updated` | Changes saved | course_id, fields_changed |
| `course_published` | Published | course_id |
| `course_unpublished` | Unpublished | course_id |
| `module_added` | Module created | course_id |
| `module_reordered` | Modules reordered | course_id |

---

## API Calls

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/creators/me/courses` | List view | Creator's courses |
| `GET /api/courses/:id` | Edit view | Course details |
| `POST /api/courses` | Create new | Create course |
| `PUT /api/courses/:id` | Save changes | Update course |
| `DELETE /api/courses/:id` | Delete | Remove course |
| `GET /api/courses/:id/curriculum` | Edit view | Module list |
| `POST /api/courses/:id/curriculum` | Add module | Create module |
| `PUT /api/courses/:id/curriculum/:module_id` | Edit module | Update module |
| `PUT /api/courses/:id/curriculum/reorder` | Drag-drop | Reorder modules |
| `DELETE /api/courses/:id/curriculum/:module_id` | Delete module | Remove module |
| `PUT /api/courses/:id/publish` | Publish | Set status published |
| `PUT /api/courses/:id/unpublish` | Unpublish | Set status draft |
| `POST /api/courses/:id/thumbnail` | Upload | Upload thumbnail |
| `GET /api/categories` | Edit view | Category dropdown |
| `GET /api/courses/:id/homework` | Homework section | List assignments |
| `POST /api/courses/:id/homework` | Add assignment | Create homework |
| `PUT /api/homework/:id` | Edit assignment | Update homework |
| `DELETE /api/homework/:id` | Delete assignment | Remove homework |
| `GET /api/courses/:id/resources` | Resources section | List resources |
| `POST /api/courses/:id/resources` | Upload resource | Upload file to R2 |
| `DELETE /api/resources/:id` | Delete resource | Remove resource |

**Courses List Response:**
```typescript
GET /api/creators/me/courses
{
  courses: [{
    id, title, slug, thumbnail_url,
    status: 'draft' | 'published' | 'retired',
    student_count: number,
    created_at, updated_at
  }]
}
```

**Course Detail Response:**
```typescript
GET /api/courses/:id
{
  id, title, slug, tagline, description,
  thumbnail_url, category_id, level,
  price_cents, currency, lifetime_access,
  peerloop_features: {
    one_on_one: boolean,
    certified_teachers: boolean,
    earn_while_teaching: boolean,
    teacher_commission: number
  },
  objectives: [{ id, objective, display_order }],
  includes: [{ id, item, display_order }],
  prerequisites: [{ id, type, content, display_order }],
  target_audience: [{ id, description, display_order }],
  tags: string[],
  status, created_at, updated_at
}
```

**Create/Update Course:**
```typescript
POST /api/courses
PUT /api/courses/:id
{
  title, slug?, tagline?, description?,
  category_id?, level?, price_cents?, currency?,
  peerloop_features?: { ... },
  objectives?: [...],
  includes?: [...],
  prerequisites?: [...],
  target_audience?: [...],
  tags?: [...]
}
```

**Curriculum Response:**
```typescript
GET /api/courses/:id/curriculum
{
  modules: [{
    id, title, description, duration,
    session_number, module_order,
    video_url, document_url,
    objectives, topics, exercise
  }]
}
```

---

## Notes

- CD-019: Content is external (YouTube/Vimeo, Google Docs)
- Consider auto-save for forms
- Version history for course changes (future)
- Duplicate course feature (future)
- Analytics dashboard integration
