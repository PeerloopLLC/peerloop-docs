# ACAT - Admin Categories

| Field | Value |
|-------|-------|
| Route | `/admin/categories` |
| Access | Authenticated (Admin role) |
| Priority | P1 |
| Status | ✅ Implemented |
| Block | 8 |
| Astro Page | `src/pages/admin/categories.astro` |
| Component | `src/components/admin/CategoriesAdmin.tsx` |
| JSON Spec | `src/data/pages/admin/categories.json` |
| Implemented | 2026-01-06 |

---

## Purpose

CRUD interface for managing course categories - the taxonomy used to organize and filter courses.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-A059 | As an Admin, I need to manage course categories (create, edit, delete) so that I can organize course taxonomy | P1 | ✅ |
| US-A060 | As an Admin, I need to reorder categories so that I can control how categories appear to users | P1 | ✅ |

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| ADMN | "Categories" nav item | Admin sidebar (under Settings) |

### Outgoing (users navigate to)

| Target | Trigger | Notes | Status |
|--------|---------|-------|--------|
| ACRS | "View Courses" | Courses in category | ⏳ Pending |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| categories | All fields | Category records |
| courses | category_id, count | Usage stats |

---

## Features

### Category Management
- [x] Category listing (with course counts) `[US-A059]`
- [x] Create category (modal with slug auto-generation) `[US-A059]`
- [x] Edit category (modal) `[US-A059]`
- [x] Delete category (FK protection - can't delete if courses assigned) `[US-A059]`
- [x] Category stats (total, with courses, empty, total courses) `[US-A059]`

### Organization
- [x] Reorder categories (move up/down actions) `[US-A060]`

### Pending Features
- [ ] Drag to reorder *(planned as drag/drop, implemented as up/down buttons)*
- [ ] Description field *(planned, not implemented)*
- [ ] Icon field *(planned, not implemented)*
- [ ] Parent category for sub-categories *(planned for future)*
- [ ] Merge categories *(planned, not implemented)*
- [ ] View Courses link to ACRS *(planned, not implemented)*

---

## Sections (from Plan)

### Header
- [x] Screen title: "Category Management"
- [x] "Add Category" button

### Categories Table

| Column | Content | Status |
|--------|---------|--------|
| Order | Drag handle + display order | ✅ (up/down buttons instead of drag) |
| Name | Category name | ✅ |
| Slug | URL slug | ✅ |
| Courses | Count of courses in category | ✅ |
| Actions | Edit, Delete | ✅ |

### Category Form (Add/Edit)

| Field | Status |
|-------|--------|
| Name - Category display name | ✅ |
| Slug - URL-friendly slug (auto-generated, editable) | ✅ |
| Display Order - Sort order | ✅ (via up/down) |
| Description - Optional description | ⏳ Planned |
| Icon - Optional icon (for UI) | ⏳ Planned |
| Parent - For sub-categories | ⏳ Future |

### Actions

| Action | Description | Status |
|--------|-------------|--------|
| Add | Create new category | ✅ |
| Edit | Modify category | ✅ |
| Reorder | Change display order | ✅ (buttons, not drag) |
| Delete | Remove category (only if empty) | ✅ |
| Merge | Merge into another category | ⏳ Planned |

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/admin/categories` | GET | Ordered category list | ✅ |
| `/api/admin/categories` | POST | Create new category | ✅ |
| `/api/admin/categories/:id` | PATCH | Update category | ✅ |
| `/api/admin/categories/:id` | DELETE | Remove (if no courses) | ✅ |
| `/api/admin/categories/reorder` | POST | Update display order | ✅ |
| `/api/admin/categories/:id/merge` | POST | Merge into another | ⏳ Planned |

**Category Response:**
```typescript
GET /api/admin/categories
{
  categories: [{
    id, name, slug, display_order,
    description, icon,
    course_count: number
  }]
}
```

**Reorder:**
```typescript
POST /api/admin/categories/reorder
{
  order: [
    { id: 'cat_1', display_order: 0 },
    { id: 'cat_2', display_order: 1 }
  ]
}
```

**Merge (planned):**
```typescript
POST /api/admin/categories/:id/merge
{
  into_category_id: string
}
// Moves all courses, then deletes source
```

---

## Sample Categories (from CD-021)

| Name | Slug |
|------|------|
| AI & Product Management | ai-product-management |
| Machine Learning | machine-learning |
| Computer Vision | computer-vision |
| NLP | nlp |
| Data Science | data-science |
| Business Analytics | business-analytics |
| Backend Development | backend-development |
| Cloud Computing | cloud-computing |
| Full-Stack Development | full-stack-development |
| DevOps | devops |
| System Design | system-design |
| AI & Robotics | ai-robotics |
| AI in Healthcare | ai-healthcare |
| AI Coding | ai-coding |
| AI & Prompt Engineering | ai-prompt-engineering |

---

## States & Variations

| State | Description | Status |
|-------|-------------|--------|
| List | Viewing all categories | ✅ |
| Adding | Create form open | ✅ |
| Editing | Edit form open | ✅ |
| Reordering | Drag mode active | ⏳ (uses buttons instead) |

---

## Error Handling

| Error | Display |
|-------|---------|
| Load fails | "Unable to load categories. [Retry]" |
| Duplicate slug | "Slug already exists. Choose another." |
| Delete blocked | "Cannot delete category with X courses" |

---

## Implementation Notes

- Simple CRUD admin page
- Validates slug format (lowercase, alphanumeric, hyphens)
- Display order used for browse page category filter ordering
- Categories are platform-wide, not per-creator
- Genesis Cohort: May only need 4-5 categories initially

---

## Plan vs Implementation

| Planned Feature | Implementation Status |
|-----------------|----------------------|
| Drag to reorder | Changed to up/down buttons |
| Description field | Not implemented |
| Icon field | Not implemented |
| Parent (sub-categories) | Not implemented (future) |
| Merge categories | Not implemented |
| View Courses link | Not implemented |

---

## Interactive Elements

### Buttons (with onClick handlers)

| Element | Component | Action | Status |
|---------|-----------|--------|--------|
| Add Category | CategoriesAdmin | Opens create modal | ✅ Active |
| Error retry | CategoriesAdmin | Retries `fetchCategories()` | ✅ Active |
| Table row click | AdminDataTable | Opens edit modal for category | ✅ Active |
| Edit (row action) | AdminActionMenu | Opens edit modal | ✅ Active |
| Move Up (row action) | AdminActionMenu | POST reorder API (swap with above) | ✅ Active |
| Move Down (row action) | AdminActionMenu | POST reorder API (swap with below) | ✅ Active |
| Delete (row action) | AdminActionMenu | DELETE with confirm (protected if has courses) | ✅ Active |
| Modal backdrop | CategoryModal | Closes modal | ✅ Active |
| Cancel button | CategoryModal | Closes modal | ✅ Active |
| Create/Update button | CategoryModal | Submits form (POST or PATCH) | ✅ Active |

### Form Controls (CategoryModal)

| Element | Type | Validation | Status |
|---------|------|------------|--------|
| Name input | text | Required | ✅ Active |
| Slug input | text | Required, lowercase alphanumeric + hyphens | ✅ Active |
| Display Order input | number | Optional (auto-assigned if empty) | ✅ Active |

### Links - Admin Sidebar (via AdminLayout)

| Element | Target | Status |
|---------|--------|--------|
| Dashboard | /admin | 📋 PageSpecView |
| Users | /admin/users | ✅ Implemented |
| Courses | /admin/courses | ✅ Implemented |
| Categories | /admin/categories | ✅ Implemented (fixed 2026-01-07) |
| Enrollments | /admin/enrollments | 📋 PageSpecView |
| Sessions | /admin/sessions | 📋 PageSpecView |
| Payouts | /admin/payouts | 📋 PageSpecView |
| Moderation Queue | /admin/moderation | 📋 PageSpecView |
| Moderators | /admin/moderators | 📋 PageSpecView |
| Back to App | / | ✅ Active |

**Fixed (2026-01-07):** Categories link added to AdminLayout.astro sidebar in Management section.

### API Calls (triggered by interactions)

| Trigger | Endpoint | Method | Status |
|---------|----------|--------|--------|
| Page load | `/api/admin/categories` | GET | ✅ Active |
| Create submit | `/api/admin/categories` | POST | ✅ Active |
| Edit submit | `/api/admin/categories/{id}` | PATCH | ✅ Active |
| Delete click | `/api/admin/categories/{id}` | DELETE | ✅ Active |
| Move Up/Down | `/api/admin/categories/reorder` | POST | ✅ Active |

### Target Pages Status

| Target | Page Code | Implemented |
|--------|-----------|-------------|
| /admin | ADMN | 📋 PageSpecView |
| /admin/users | AUSR | ✅ Yes |
| /admin/courses | ACRS | ✅ Yes |
| /admin/categories | ACAT | ✅ Yes (current) |
| /admin/enrollments | AENR | 📋 PageSpecView |
| /admin/sessions | ASES | 📋 PageSpecView |
| /admin/payouts | APAY | 📋 PageSpecView |
| /admin/moderation | MODQ | 📋 PageSpecView |
| /admin/moderators | MINV | 📋 PageSpecView |
| / | HOME | ✅ Yes |

---

## Verification Notes

**Verified:** 2026-01-07 (Code + Visual + Interactive Elements)

**Consolidated:** 2026-01-08
- JSON spec updated to match verified implementation
- 6 discrepancies documented in JSON `_discrepancies` section

### Discrepancies Found

| Feature | Spec | Reality | Status |
|---------|------|---------|--------|
| ~~Sidebar navigation~~ | ~~Should have "Categories" link~~ | ~~Missing from AdminLayout sidebar~~ | ✅ Fixed |
| Drag to reorder | Drag-and-drop | Up/Down buttons | ⚠️ Different (acceptable) |
| Description field | Planned | Not implemented | ⏳ Deferred |
| Icon field | Planned | Not implemented | ⏳ Deferred |
| Parent categories | Planned | Not implemented | ⏳ Future |
| Merge categories | Planned | Not implemented | ⏳ Deferred |
| View Courses link | Planned | Not implemented | ⏳ Deferred |
| Analytics events | Not specified | None implemented | ℹ️ Not planned |

### Components Verified

| Component | File | Status |
|-----------|------|--------|
| CategoriesAdmin | `src/components/admin/CategoriesAdmin.tsx` | ✅ No TODOs |
| CategoryModal | `src/components/admin/CategoriesAdmin.tsx` | ✅ No TODOs |
| categories.astro | `src/pages/admin/categories.astro` | ✅ Clean |

### Interactive Elements Summary

| Category | Count | Active | Inactive |
|----------|-------|--------|----------|
| Buttons (onClick) | 10 | 10 | 0 |
| Form Controls | 3 | 3 | 0 |
| Admin Sidebar Links | 9 | 9 | 0 |
| API Endpoints | 5 | 5 | 0 |
| Analytics Events | 0 | 0 | 0 |

**Notes:**
- All CRUD operations fully functional
- Move Up/Down provides acceptable alternative to drag-and-drop
- Delete protected: categories with courses cannot be deleted
- Slug auto-generation works on create (not on edit)
- Modal has client-side validation for name, slug format

### Screenshots

| File | Date | Description |
|------|------|-------------|
| `ACAT-2026-01-07-05-34-53.png` | 2026-01-07 | Category list view with stats |
| `ACAT-2026-01-07-05-35-17.png` | 2026-01-07 | Edit Category modal |
| `ACAT-2026-01-07-05-35-55.png` | 2026-01-07 | Row actions dropdown menu |
