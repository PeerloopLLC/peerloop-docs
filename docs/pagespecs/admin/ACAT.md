# Screen: Admin Categories

**Code:** ACAT
**URL:** `/admin/categories` (route within Admin SPA)
**Access:** Authenticated (Admin role)
**Priority:** P1
**Status:** Implemented

---

## Purpose

Manage course categories - create, edit, reorder, and archive categories to organize the course catalog.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| ADMN | "Categories" nav item | Admin sidebar |
| ADMN | "Manage Categories" quick action | Dashboard |
| ACRS | "Manage Categories" link | From course management |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| ACRS | "View Courses" | Filtered to category |
| CBRO | "View Public" | Opens browse filtered |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| categories | All fields | Category records |
| courses | count per category | Course counts |

---

## Sections

### Header
- Screen title: "Category Management"
- "Add Category" button
- Reorder toggle

### Categories List

**Grid or List view toggle**

| Field | Content |
|-------|---------|
| Icon | Category icon/emoji |
| Name | Category name |
| Slug | URL slug |
| Description | Short description |
| Courses | Count of courses |
| Order | Display order |
| Status | Active / Archived |
| Actions | Edit, Archive, Delete |

### Category Detail / Edit Modal

**Fields:**
- Name (required)
- Slug (auto-generated, editable)
- Description (optional, for SEO)
- Icon/Emoji picker
- Color (for UI theming)
- Parent category (for hierarchy, optional)
- Display order
- Status (Active/Archived)

### Reorder Mode
- Drag-and-drop reordering
- Save order button
- Cancel button

### Actions

| Action | Description |
|--------|-------------|
| Add | Create new category |
| Edit | Open edit modal |
| Archive | Hide from public (courses remain) |
| Restore | Restore archived category |
| Delete | Remove (only if no courses) |
| Reorder | Change display order |
| View Courses | Navigate to ACRS filtered |

---

## API Calls

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/admin/categories` | Page load | All categories with counts |
| `POST /api/admin/categories` | Add | Create category |
| `PATCH /api/admin/categories/:id` | Edit | Update category |
| `DELETE /api/admin/categories/:id` | Delete | Remove (if empty) |
| `POST /api/admin/categories/:id/archive` | Archive | Soft delete |
| `POST /api/admin/categories/:id/restore` | Restore | Unarchive |
| `PATCH /api/admin/categories/reorder` | Reorder | Update display_order |

**Category Response:**
```typescript
{
  id: string,
  name: string,
  slug: string,
  description: string | null,
  icon: string | null,
  color: string | null,
  parent_id: string | null,
  display_order: number,
  is_active: boolean,
  course_count: number,
  created_at: string,
  updated_at: string
}
```

---

## States & Variations

| State | Description |
|-------|-------------|
| List | Default category list |
| Reordering | Drag-and-drop mode |
| Editing | Edit modal open |
| Adding | Add modal open |
| Confirming | Delete confirmation |

---

## Error Handling

| Error | Display |
|-------|---------|
| Load fails | "Unable to load categories. [Retry]" |
| Slug conflict | "A category with this URL already exists" |
| Delete blocked | "Cannot delete category with courses" |
| Save fails | "Unable to save. [Retry]" |

---

## Validation Rules

| Field | Rules |
|-------|-------|
| Name | Required, 2-50 characters |
| Slug | Required, unique, lowercase, alphanumeric + hyphens |
| Description | Optional, max 200 characters |
| Icon | Optional, single emoji or icon class |

---

## Notes

- Categories affect course browsing and filtering
- Archived categories hide from public but courses retain assignment
- Consider parent/child hierarchy for sub-categories
- Slug used in URLs: `/courses?category={slug}`
- Display order affects homepage and browse page ordering
- Seed categories: AI/ML, Product Management, Design, etc.
