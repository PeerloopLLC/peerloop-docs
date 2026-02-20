# STUD - Creator Studio

| Field | Value |
|-------|-------|
| Route | `/dashboard/creator/studio` |
| Access | Authenticated (Creator role) |
| Priority | P0 |
| Status | 📋 Spec Only |
| Block | 8 |
| JSON Spec | `src/data/pages/dashboard/creator/studio.json` |
| Astro Page | `src/pages/dashboard/creator/studio.astro` |

---

## Purpose

Course creation and management interface for Creators to build, edit, publish, and manage their courses and curriculum.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-C001 | As a Creator, I need to create new courses | P0 | ⏳ |
| US-C002 | As a Creator, I need to edit course details | P0 | ⏳ |
| US-C003 | As a Creator, I need to manage course curriculum | P0 | ⏳ |
| US-C010 | As a Creator, I need to set course pricing | P0 | ⏳ |
| US-C034 | As a Creator, I need to publish/unpublish courses | P0 | ⏳ |

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

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| courses | All fields | Course creation/editing |
| course_curriculum | All fields | Module management |
| course_objectives | objective, display_order | Learning objectives |
| course_includes | item, display_order | Included items |
| course_prerequisites | type, content, display_order | Prerequisites |
| categories | id, name | Category selection |
| homework_assignments | All fields | Homework management |
| session_resources | All fields | Course resources |

---

## Features

### Course List View
- [ ] Grid of creator's courses `[US-C002]`
- [ ] Status badges (Draft/Published/Retired) `[US-C034]`
- [ ] Student count per course `[US-C002]`
- [ ] Quick actions: Publish/Unpublish, View, Delete `[US-C034]`
- [ ] "Create New Course" CTA `[US-C001]`

### Course Editor
- [ ] Basic info (title, slug, tagline, description, thumbnail) `[US-C002]`
- [ ] Category and level selection `[US-C002]`
- [ ] Tags input `[US-C002]`

### Curriculum Management
- [ ] Module list with drag-to-reorder `[US-C003]`
- [ ] Add/remove modules `[US-C003]`
- [ ] Per module: title, description, duration, video URL, document URL `[US-C003]`
- [ ] Module objectives and topics `[US-C003]`

### Homework Section
- [ ] Assignment list with reorder `[US-C003]`
- [ ] Add/edit assignments `[US-C003]`
- [ ] Required for completion toggle `[US-C003]`
- [ ] Points/grading options `[US-C003]`

### Resources Section
- [ ] Upload course resources (PDF, DOC, PPT) `[US-C003]`
- [ ] Resource list with delete option `[US-C003]`

### Pricing Section
- [ ] Price input `[US-C010]`
- [ ] Currency selection `[US-C010]`
- [ ] Certificate toggle `[US-C010]`

### Publishing
- [ ] Publishing checklist `[US-C034]`
- [ ] Publish/Unpublish buttons `[US-C034]`
- [ ] Preview link `[US-C034]`

---

## Sections (from Plan)

### Course Editor Sidebar
- Course Settings, Basic Info, Curriculum, Homework
- Resources, Objectives & Includes, Prerequisites
- Pricing, Student-Teachers, Publishing

### Publishing Checklist
- [ ] Title set
- [ ] Description added
- [ ] At least 1 module
- [ ] Thumbnail uploaded
- [ ] Price set

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/creators/me/courses` | GET | Creator's courses | ⏳ |
| `/api/courses` | POST | Create course | ⏳ |
| `/api/courses/:id` | GET | Course details | ⏳ |
| `/api/courses/:id` | PUT | Update course | ⏳ |
| `/api/courses/:id` | DELETE | Delete course | ⏳ |
| `/api/courses/:id/curriculum` | GET | Module list | ⏳ |
| `/api/courses/:id/curriculum` | POST | Create module | ⏳ |
| `/api/courses/:id/curriculum/reorder` | PUT | Reorder modules | ⏳ |
| `/api/courses/:id/publish` | PUT | Publish course | ⏳ |
| `/api/courses/:id/unpublish` | PUT | Unpublish course | ⏳ |
| `/api/courses/:id/thumbnail` | POST | Upload thumbnail | ⏳ |
| `/api/courses/:id/homework` | GET/POST | Homework management | ⏳ |
| `/api/courses/:id/resources` | GET/POST | Resource management | ⏳ |

---

## States & Variations

| State | Description |
|-------|-------------|
| Course List | Viewing all courses |
| New Course | Creating new course (empty form) |
| Editing Draft | Editing unpublished course |
| Editing Published | Editing live course (with warnings) |
| No Courses | Empty state, "Create your first course" |

---

## Error Handling

| Error | Display |
|-------|---------|
| Save fails | "Unable to save. Please try again." |
| Publish fails | "Unable to publish. Check required fields." |
| Image upload fails | "Unable to upload image. Try again." |
| Slug conflict | "This URL is already taken. Choose another." |

---

## Implementation Notes

- CD-019: Content is external (YouTube/Vimeo, Google Docs)
- Consider auto-save for forms
- File uploads to R2
- Version history for course changes (future)
