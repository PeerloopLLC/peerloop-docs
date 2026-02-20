# Page: Course Discuss

**Code:** CDIS
**URL:** `/courses/:slug/discuss`
**Access:** Authenticated (Enrolled)
**Priority:** P1
**Status:** Implemented

---

## Purpose

Forum-style discussion board for course enrollees to ask questions, share insights, and help each other asynchronously.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| CCNT | "Discussion" tab/link | From learning |
| CDET | "Join Discussion" | Enrolled users |
| NOTF | Discussion notification | Reply/mention |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| CCNT | "Back to Course" | Return to learning |
| CHAT | "Live Chat" tab | Real-time chat |
| PROF | User name click | View profile |
| STPR | S-T badge click | View S-T profile |

---

## Sections

### Header
- Course title
- "Back to Course" link
- Toggle: Discussion / Chat (if CHAT implemented)

### New Post Section
- "Ask a question" or "Share something"
- Expandable form:
  - Title (required)
  - Content (rich text)
  - Module reference (dropdown, optional)
  - Tags (optional)
  - Submit button

### Discussion Feed

**Filters:**
- All / Questions / Tips / General
- Sort: Recent / Popular / Unanswered

**Thread Card:**
- Author avatar + name + role badge
- Title
- Content preview
- Module tag (if applicable)
- Reply count
- Like count
- Timestamp
- "View Thread" → expand

### Thread Detail (Expanded/Modal)

**Original Post:**
- Full content
- Author info
- Timestamp
- Like button
- Report button
- Edit/Delete (if author)

**Replies:**
- Nested replies (1 level)
- Author avatar + name
- Content
- Timestamp
- Like button
- Reply button
- S-T/Creator "Endorsed" badge (optional)

**Reply Form:**
- Rich text editor
- Submit button

### Sidebar (Desktop)

**Module Navigation:**
- Quick jump to module discussions
- "All Modules" option

**Popular Tags:**
- Clickable tag filters

**Unanswered Questions:**
- Count badge
- Link to filtered view

---

## API Calls

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/courses/:slug/discussions` | Page load | Discussion threads |
| `POST /api/courses/:slug/discussions` | New post | Create thread |
| `GET /api/discussions/:id` | Thread click | Thread with replies |
| `POST /api/discussions/:id/replies` | Reply submit | Add reply |
| `POST /api/discussions/:id/like` | Like click | Toggle like |
| `POST /api/discussions/:id/report` | Report click | Flag content |
| `DELETE /api/discussions/:id` | Delete click | Remove (author only) |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| discussions | id, course_id, user_id, title, content, module_id, created_at | Threads |
| discussion_replies | id, discussion_id, user_id, content, parent_id | Replies |
| discussion_likes | user_id, discussion_id or reply_id | Likes |
| users | name, avatar_url, roles | Author info |
| course_curriculum | id, title | Module reference |

---

## States & Variations

| State | Description |
|-------|-------------|
| Feed | Discussion list |
| Thread | Single thread expanded |
| Posting | New post form open |
| Filtered | Filter/search applied |
| Empty | No discussions yet |

---

## Error Handling

| Error | Display |
|-------|---------|
| Not enrolled | "Enroll to join discussions" → CDET |
| Post fails | "Unable to post. Try again." |
| Load fails | "Unable to load discussions. [Retry]" |

---

## Notes

- Different from CHAT (async vs real-time)
- Consider Stream.io for feed infrastructure
- S-T/Creator answers can be marked as "endorsed"
- Module tagging helps organize by topic
- Search within discussions (future)
- Email notifications for replies (NOTF integration)
