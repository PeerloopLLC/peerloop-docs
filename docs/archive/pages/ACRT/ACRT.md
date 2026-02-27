# ACRT - Admin Certificates

| Field | Value |
|-------|-------|
| Route | `/admin/certificates` |
| Access | Authenticated (Admin role) |
| Priority | P0 |
| Status | 📋 Spec Only |
| Block | 8 |
| JSON Spec | `src/data/pages/admin/certificates.json` |
| Astro Page | `src/pages/admin/certificates.astro` |

---

## Purpose

Manage certificates - review pending certifications, issue/revoke certificates, and maintain the credentialing system.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-A006 | As an Admin, I need to vet certificates so that only qualified STs are certified | P1 | ⏳ |
| US-A015 | As an Admin, I need to issue certificates manually so that I can handle special cases | P1 | ⏳ |
| US-A016 | As an Admin, I need to revoke certificates so that I can handle misconduct | P1 | ⏳ |

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

## Features

### Viewing & Browsing
- [ ] Certificate listing with tabs (Pending/Issued/Revoked) `[US-A006]`
- [ ] Search by recipient name `[US-A006]`
- [ ] Filter by course `[US-A006]`
- [ ] Filter by type (Completion/Mastery/Teaching) `[US-A006]`
- [ ] Filter by date range `[US-A006]`
- [ ] Certificate detail panel `[US-A006]`
- [ ] Pending count badge `[US-A006]`

### Certificate Actions
- [ ] Approve pending certificate `[US-A006]`
- [ ] Reject pending certificate `[US-A006]`
- [ ] Issue certificate manually `[US-A015]`
- [ ] Revoke certificate (with reason) `[US-A016]`
- [ ] Reinstate revoked certificate `[US-A016]`
- [ ] View/Download PDF `[US-A006]`

---

## Sections (from Plan)

### Header
- Screen title: "Certificate Management"
- "Issue Certificate" button
- Pending count badge

### Tabs
- Pending - Awaiting admin action
- Issued - All issued certificates
- Revoked - Revoked certificates

### Pending Certificates Tab
For each pending certificate:
- Recipient name + avatar
- Course name
- Type (Completion / Mastery / Teaching)
- Recommended by (for ST recommendations)
- Date recommended
- Supporting info (progress, sessions, rating)
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
- Issued by / Recommended by
- Certificate URL/PDF
- Verification info

**Actions:**
- View/Download PDF
- Revoke (with reason)
- Re-issue (if revoked)

### Issue Certificate Modal
- Select recipient (search users)
- Select course
- Certificate type (Completion/Mastery/Teaching)
- Issue date
- Notes
- Notify recipient toggle

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/admin/certificates` | GET | Paginated, filterable list | ⏳ |
| `/api/admin/certificates/pending` | GET | Awaiting approval | ⏳ |
| `/api/admin/certificates/:id` | GET | Full certificate data | ⏳ |
| `/api/admin/certificates` | POST | Create new certificate | ⏳ |
| `/api/admin/certificates/:id/approve` | POST | Issue pending cert | ⏳ |
| `/api/admin/certificates/:id/reject` | POST | Decline pending cert | ⏳ |
| `/api/admin/certificates/:id/revoke` | POST | Revoke issued cert | ⏳ |
| `/api/admin/certificates/:id/reinstate` | POST | Restore revoked cert | ⏳ |
| `/api/admin/certificates/:id/pdf` | GET | Get certificate PDF | ⏳ |

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

## Implementation Notes

- CD-011: Dual certificate system (completion vs mastery)
- Teaching certificates make users STs for that course
- Revocation should be rare and documented
- Consider verification page for external validation
- Uses shared admin components
