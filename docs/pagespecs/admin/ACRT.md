# Screen: Admin Certificates

**Code:** ACRT
**URL:** `/admin/certificates` (route within Admin SPA)
**Access:** Authenticated (Admin role)
**Priority:** P0
**Status:** In Scope

---

## Purpose

Manage certificates - review pending certifications, issue/revoke certificates, and maintain the credentialing system.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| ADMN | "Certificates" nav item | Admin sidebar |
| AUSR | "View Certificates" on user | Filtered to user |
| ACRS | "View Certificates" on course | Filtered to course |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| AUSR | User name click | View user |
| ACRS | Course name click | View course |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| certificates | All fields | Certificate records |
| users (recipients) | id, name, email | Recipient info |
| users (issuers) | id, name | Who issued |
| users (recommenders) | id, name | Who recommended (for ST recs) |
| courses | id, title | Course info |

---

## Sections

### Header
- Screen title: "Certificate Management"
- "Issue Certificate" button
- Pending count badge

### Tabs
- **Pending** - Awaiting admin action
- **Issued** - All issued certificates
- **Revoked** - Revoked certificates

### Filters
- **Search:** Recipient name
- **Course filter:** All / specific course
- **Type filter:** All / Completion / Mastery / Teaching
- **Date filter:** Issue date range

### Pending Certificates Tab

For each pending certificate:
- Recipient name + avatar
- Course name
- Type (Completion / Mastery / Teaching)
- Recommended by (for ST recommendations)
- Date recommended
- Supporting info:
  - Progress completed
  - Sessions attended
  - Average rating received (for teaching)
- Actions: Approve, Reject

### Certificates Table (Issued/Revoked)

| Column | Content |
|--------|---------|
| Recipient | Name + email |
| Course | Course title |
| Type | Completion / Mastery / Teaching |
| Issued | Date |
| Issued By | Creator or Admin |
| Recommended By | ST (if applicable) |
| Status | Active / Revoked |
| Actions | View, Revoke |

### Certificate Detail Panel

**View Mode:**
- Recipient info (link to AUSR)
- Course info (link to ACRS)
- Certificate type
- Issue date
- Issued by
- Recommended by (if applicable)
- Certificate URL/PDF
- Verification info

**Actions:**
- View/Download PDF
- Revoke (with reason)
- Re-issue (if revoked)

### Issue Certificate Modal
- Select recipient (search users)
- Select course
- Certificate type:
  - Completion
  - Mastery
  - Teaching
- Issue date
- Notes
- Notify recipient toggle

---

## API Calls

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/admin/certificates` | Page load | Paginated, filterable list |
| `GET /api/admin/certificates/pending` | Pending tab | Awaiting approval |
| `GET /api/admin/certificates/:id` | Detail open | Full certificate data |
| `POST /api/admin/certificates` | Issue | Create new certificate |
| `POST /api/admin/certificates/:id/approve` | Approve | Issue pending cert |
| `POST /api/admin/certificates/:id/reject` | Reject | Decline pending cert |
| `POST /api/admin/certificates/:id/revoke` | Revoke | Revoke issued cert |
| `POST /api/admin/certificates/:id/reinstate` | Reinstate | Restore revoked cert |
| `GET /api/admin/certificates/:id/pdf` | Download | Get certificate PDF |

**Query Parameters:**
- `q` - Search recipient name
- `course_id` - Filter by course
- `type` - completion, mastery, teaching
- `status` - pending, issued, revoked
- `from`, `to` - Issue date range
- `page`, `limit` - Pagination

**Issue Certificate:**
```typescript
POST /api/admin/certificates
{
  user_id: string,
  course_id: string,
  type: 'completion' | 'mastery' | 'teaching',
  notes?: string,
  notify: boolean
}
```

**Pending Certificate Response:**
```typescript
GET /api/admin/certificates/pending
{
  certificates: [{
    id, type,
    recipient: { id, name, avatar },
    course: { id, title },
    recommended_by: { id, name } | null,
    recommended_at: string,
    supporting: {
      progress_percent: number,
      sessions_attended: number,
      avg_rating?: number
    }
  }]
}
```

---

## Certificate Types

| Type | Meaning | Issued By |
|------|---------|-----------|
| Completion | Finished course | Creator (on ST recommendation) |
| Mastery | Demonstrated mastery | Creator (with assessment) |
| Teaching | Certified to teach | Creator (after vetting) |

---

## States & Variations

| State | Description |
|-------|-------------|
| Pending Tab | Showing pending approvals |
| Issued Tab | Showing all issued |
| Revoked Tab | Showing revoked |
| Detail | Certificate panel open |
| Issuing | Manual issue form |

---

## Error Handling

| Error | Display |
|-------|---------|
| Load fails | "Unable to load certificates. [Retry]" |
| Approve fails | "Unable to issue certificate. [Retry]" |
| Already issued | "User already has this certificate" |

---

## Notes

- CD-011: Dual certificate system (completion vs mastery)
- Teaching certificates make users STs for that course
- Revocation should be rare and documented
- Consider verification page for external validation
