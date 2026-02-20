# Screen: Admin Moderation

**Code:** AMOD
**URL:** `/admin/moderation` (route within Admin SPA)
**Access:** Authenticated (Admin role)
**Priority:** P1
**Status:** Implemented

---

## Purpose

Review and manage flagged content, user reports, and community moderation actions across the platform. Full admin moderation powers including bans.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| ADMN | "Moderation" nav item | Admin sidebar |
| MODQ | "Escalate to Admin" | From moderator queue |
| AUSR | "View Reports" action | Reports about user |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| AUSR | User name click | View reported/reporter |
| CDET | Content link click | View reported content |
| FEED | Post link click | View reported post |
| MODQ | "View Mod Queue" | Moderator queue |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| moderation_reports | All fields | Report records |
| users | id, name, email, avatar_url | Reporter/reported |
| feed_posts | id, content, created_at | Reported posts |
| course_reviews | id, content | Reported reviews |
| moderation_actions | All fields | Action history |

---

## Sections

### Header
- Screen title: "Content Moderation"
- Pending count badge
- Refresh button
- "Action History" tab toggle

### Search & Filters
- **Status filter:** All / Pending / Resolved / Dismissed
- **Type filter:** All / Post / Comment / Review / Profile / Course
- **Reason filter:** Spam / Harassment / Inappropriate / Other
- **Search:** User name/email
- **Date filter:** Report date range

### Reports Table

| Column | Content |
|--------|---------|
| Reporter | Avatar + name |
| Reported | User/content + type badge |
| Reason | Category + excerpt |
| Status | Pending / Resolved / Dismissed |
| Date | Report timestamp |
| Actions | View, Quick actions |

### Report Detail Panel

**Report Info:**
- Reporter details (with link to AUSR)
- Report reason and full notes
- Report timestamp

**Reported Content:**
- Full content preview
- Content type badge
- Link to original content

**Reported User:**
- User details (with link to AUSR)
- Moderation history:
  - Prior reports against
  - Prior warnings received
  - Suspension history
- Risk assessment indicator

**Action Section:**
- Resolution notes (required for action)
- Action buttons

### Actions

| Action | Description |
|--------|-------------|
| Dismiss | No action warranted |
| Warn | Issue warning to user |
| Hide | Hide content from public |
| Delete | Remove content permanently |
| Suspend | Suspend user (with reason, duration) |
| Ban | Permanently ban user |

### Action History Tab

| Column | Content |
|--------|---------|
| Date | Action timestamp |
| Admin | Who took action |
| Type | Action type |
| Target | User/content affected |
| Notes | Resolution notes |

---

## API Calls

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/admin/moderation` | Page load | Paginated reports |
| `GET /api/admin/moderation/:id` | Detail open | Full report with history |
| `POST /api/admin/moderation/:id/dismiss` | Dismiss | Close without action |
| `POST /api/admin/moderation/:id/warn` | Warn | Issue warning |
| `POST /api/admin/moderation/:id/hide` | Hide | Hide content |
| `POST /api/admin/moderation/:id/delete` | Delete | Delete content |
| `POST /api/admin/moderation/:id/suspend` | Suspend | Suspend user |
| `POST /api/admin/moderation/:id/ban` | Ban | Permanent ban |
| `GET /api/admin/moderation/history` | History tab | Action audit trail |

**Query Parameters:**
- `status` - pending, resolved, dismissed
- `type` - post, comment, review, profile, course
- `reason` - spam, harassment, inappropriate, other
- `q` - Search user name/email
- `from`, `to` - Report date range
- `page`, `limit` - Pagination

---

## States & Variations

| State | Description |
|-------|-------------|
| Queue | Pending reports list |
| Filtered | Filters applied |
| Detail | Report panel open |
| History | Action history view |
| Confirming | Ban/delete confirmation |

---

## Error Handling

| Error | Display |
|-------|---------|
| Load fails | "Unable to load reports. [Retry]" |
| Action fails | "Unable to complete action. [Retry]" |
| Content missing | "Original content no longer available" |

---

## Moderation Guidelines

**Warn for:**
- First offense minor issues
- Borderline content

**Hide for:**
- Inappropriate but not severe
- Pending review

**Suspend for:**
- Repeat offenders
- Serious violations
- Duration: 1 day, 7 days, 30 days

**Ban for:**
- Severe violations (harassment, hate speech)
- Multiple suspensions
- Legal concerns

---

## Audit Trail

All moderation actions logged with:
- Admin who took action
- Action type
- Target user/content
- Resolution notes
- Timestamp
- Previous state

---

## Notes

- Admins have full moderation powers; moderators (MODQ) have limited powers
- Reports can be escalated from MODQ to AMOD
- Consider notification to reported user of action taken
- GDPR: Document basis for data processing decisions
- Consider appeals workflow for bans
