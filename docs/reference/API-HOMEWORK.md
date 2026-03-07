# API Reference: Homework

Homework assignments, submissions, and grading endpoints. Part of [API Reference](API-REFERENCE.md).

---

## Homework Endpoints

### GET /api/courses/[id]/homework

List homework assignments for a course. Requires authentication and enrollment.

**Path Parameter:** `id` - Course ID

**Response (200):**
```json
{
  "course_id": "crs-ai-tools-overview",
  "course_title": "AI Tools Overview",
  "enrollment_id": "enr-001",
  "assignments": [
    {
      "id": "hw-001",
      "title": "AI Tool Comparison",
      "description": "Compare three AI tools...",
      "instructions": "Select 3 AI tools from...",
      "module_id": "mod-001",
      "due_within_days": 7,
      "is_required": true,
      "max_points": 100,
      "created_at": "2026-01-01T00:00:00Z",
      "submission": {
        "id": "sub-001",
        "status": "submitted",
        "points": null,
        "submitted_at": "2026-01-05T14:30:00Z"
      }
    }
  ],
  "total": 3
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 401 | Authentication required |
| 403 | You must be enrolled in this course |
| 404 | Course not found |

---

### GET /api/homework/[id]

Get assignment details. Requires authentication and enrollment.

**Path Parameter:** `id` - Assignment ID

**Response (200):**
```json
{
  "id": "hw-001",
  "course_id": "crs-ai-tools-overview",
  "title": "AI Tool Comparison",
  "description": "Compare three AI tools...",
  "instructions": "Select 3 AI tools from the list...",
  "due_within_days": 7,
  "is_required": true,
  "max_points": 100,
  "created_at": "2026-01-01T00:00:00Z",
  "module": {
    "id": "mod-001",
    "title": "Introduction to AI Tools",
    "order": 1
  },
  "enrollment_id": "enr-001"
}
```

---

### GET /api/homework/[id]/submissions/me

Get current user's submission for an assignment.

**Path Parameter:** `id` - Assignment ID

**Response (200) - No Submission:**
```json
{
  "assignment_id": "hw-001",
  "submission": null,
  "max_points": 100
}
```

**Response (200) - With Submission:**
```json
{
  "assignment_id": "hw-001",
  "max_points": 100,
  "submission": {
    "id": "sub-001",
    "content": "My comparison of ChatGPT, Claude, and Gemini...",
    "file_url": "https://drive.google.com/...",
    "status": "reviewed",
    "submitted_at": "2026-01-05T14:30:00Z",
    "points": 85,
    "feedback": "Good analysis! Consider adding...",
    "reviewed_at": "2026-01-06T10:00:00Z",
    "reviewer": {
      "name": "Guy Rymberg",
      "handle": "guy-rymberg"
    }
  }
}
```

---

### POST /api/homework/[id]/submit

Submit homework for an assignment. Creates new or updates existing submission.

**Path Parameter:** `id` - Assignment ID

**Request:**
```json
{
  "content": "My analysis of the AI tools...",
  "file_url": "https://drive.google.com/file/d/..."
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `content` | string | No* | Text submission |
| `file_url` | string | No* | URL to file (Google Drive, Dropbox, etc.) |

*At least one of `content` or `file_url` is required.

**Response (201) - New Submission:**
```json
{
  "id": "sub-001",
  "status": "submitted",
  "submitted_at": "2026-01-05T14:30:00Z",
  "message": "Homework submitted successfully"
}
```

**Response (200) - Updated Submission:**
```json
{
  "id": "sub-001",
  "status": "submitted",
  "submitted_at": "2026-01-05T15:00:00Z",
  "message": "Submission updated successfully"
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 400 | At least one of content or file_url is required |
| 400 | Cannot modify a reviewed submission |
| 400 | This assignment is no longer accepting submissions |
| 401 | Authentication required |
| 403 | You must be enrolled in this course |
| 404 | Assignment not found |

---

## Submission Endpoints

### PUT /api/submissions/[id]

Update a submission before it's been reviewed.

**Path Parameter:** `id` - Submission ID

**Request:**
```json
{
  "content": "Updated analysis...",
  "file_url": "https://drive.google.com/..."
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 400 | Cannot modify a reviewed submission |
| 403 | You can only update your own submissions |
| 404 | Submission not found |

---

### GET /api/homework/[id]/submissions

List all submissions for an assignment. **Teacher/Creator only.**

**Path Parameter:** `id` - Assignment ID

**Query Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `status` | string | Filter by status ("submitted", "reviewed", "resubmit_requested") |

**Response (200):**
```json
{
  "assignment_id": "hw-001",
  "assignment_title": "AI Tool Comparison",
  "submissions": [
    {
      "id": "sub-001",
      "student": {
        "id": "usr-sarah-miller",
        "name": "Sarah Miller",
        "handle": "sarah-miller",
        "avatar_url": null
      },
      "content": "My analysis...",
      "file_url": null,
      "status": "submitted",
      "submitted_at": "2026-01-05T14:30:00Z",
      "points": null,
      "feedback": null,
      "reviewed_at": null
    }
  ],
  "total": 5
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 403 | Only course creators or teachers can view submissions |

---

### PATCH /api/homework/[id]/submissions/[subId]

Grade or request resubmission. **Teacher/Creator only.**

**Path Parameters:**
- `id` - Assignment ID
- `subId` - Submission ID

**Request:**
```json
{
  "status": "reviewed",
  "feedback": "Good analysis! Consider adding more detail...",
  "points": 85
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `status` | string | Yes | "reviewed" or "resubmit_requested" |
| `feedback` | string | No | Written feedback for student |
| `points` | number | No | Awarded points (must not exceed max_points) |

**Response (200):**
```json
{
  "id": "sub-001",
  "status": "reviewed",
  "feedback": "Good analysis!...",
  "points": 85,
  "reviewed_at": "2026-01-06T10:00:00Z",
  "message": "Submission reviewed successfully"
}
```

**Errors:**

| Status | Error |
|--------|-------|
| 400 | Status must be "reviewed" or "resubmit_requested" |
| 400 | Points cannot exceed max points |
| 403 | Only course creators or teachers can grade submissions |
| 404 | Submission not found |
