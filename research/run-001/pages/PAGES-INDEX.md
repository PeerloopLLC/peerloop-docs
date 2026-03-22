# RUN-001 Pages Index

> **⚠️ DELETED:** The entire PageSpec system (JSON specs, markdown specs, Astro stubs, audit scripts) was deleted in Sessions 307+311. Pages are now implemented as real Astro components. See git history.
> - **Route→story mapping:** See [ROUTE-STORIES.md](../../../docs/as-designed/route-stories.md) for the canonical 402-story route assignment.
> - **Route definitions:** See `docs/as-designed/url-routing.md`.
> - This index remains as a historical reference. Links below point to archived locations.

**Run:** RUN-001 (Stream + VideoProvider)
**Created:** 2025-12-25
**Updated:** 2026-01-22
**Total Pages:** 46 (11 public, 25 authenticated, 3 role-specific, 7 admin screens)

---

## Page Schema Definition

Each page file (`CODE.md`) follows this standard schema:

```markdown
# Page: [Page Name]

**Code:** [3-4 letter code]
**URL:** [URL pattern]
**Access:** [Public | Authenticated | Role-specific (which roles)]
**Priority:** [P0 | P1 | P2 | P3]
**Status:** [In Scope | Out of Scope | Partial]

---

## Purpose
[One sentence describing why this page exists and what user need it serves]

---

## Connections

### Incoming (users arrive from)
| Source | Trigger | Notes |
|--------|---------|-------|
| CODE | [Button/Link/Redirect description] | [Optional notes] |

### Outgoing (users navigate to)
| Target | Trigger | Notes |
|--------|---------|-------|
| CODE | [Button/Link/Redirect description] | [Optional notes] |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| [table_name] | [field1, field2, ...] | [Why needed] |

---

## Sections

### [Section Name]
- [Element 1]
- [Element 2]
- ...

[Repeat for each section]

---

## User Stories Fulfilled
- US-XXXX: [Story title]
- ...

---

## States & Variations
[Different states the page can be in, e.g., empty state, loading, error]

---

## Mobile Considerations
[Any mobile-specific layout or behavior notes]

---

## Error Handling
[What errors can occur and how they're displayed]

---

## Analytics Events
[Key events to track on this page]

---

## Notes
[Any additional context, open questions, or implementation notes]
```

### Schema Extension Rules

1. **Custom sections allowed** - Add sections specific to a page as needed
2. **Evaluate for promotion** - If a custom section appears useful across multiple pages, add it to this schema
3. **Backfill on promotion** - When a section is added to the schema, update all existing page files

---

## Page Code Registry

**Status Legend:** ✅ = Implemented | 📋 = Spec Only (PageSpecView) | 🆕 = Needs Spec

| Code | Page Name | URL | Impl | Block | File |
|------|-----------|-----|:----:|:-----:|------|
| **Public Pages - Core** ||||||
| HOME | Homepage | `/` | ✅ | 1 | [HOME.md](../../../docs/pagespecs/HOME.md) |
| CBRO | Course Browse | `/courses` | ✅ | 1 | [CBRO.md](../../../docs/pagespecs/courses/CBRO.md) |
| CDET | Course Detail | `/courses/:slug` | ✅ | 1 | [CDET.md](../../../docs/pagespecs/courses/CDET.md) |
| CRLS | Creator Listing | `/creators` | ✅ | 1 | [CRLS.md](../../../docs/pagespecs/creators/CRLS.md) |
| CPRO | Creator Profile | `/creators/:handle` | ✅ | 1 | [CPRO.md](../../../docs/pagespecs/creators/CPRO.md) |
| STDR | Teacher Directory | `/teachers` | 📋 | 7 | [STDR.md](../../../docs/pagespecs/teachers/STDR.md) |
| STPR | Teacher Profile | `/teachers/:handle` | 📋 | 7 | [STPR.md](../../../docs/pagespecs/teachers/STPR.md) |
| **Public Pages - Auth** ||||||
| LGIN | Login | `/login` | ✅ | 0 | [LGIN.md](../../../docs/pagespecs/LGIN.md) |
| SGUP | Sign Up | `/signup` | ✅ | 0 | [SGUP.md](../../../docs/pagespecs/SGUP.md) |
| PWRS | Password Reset | `/reset-password` | ✅ | 0 | [PWRS.md](../../../docs/pagespecs/PWRS.md) |
| MINV | Moderator Invite | `/invite/mod/:token` | 📋 | 8 | [MINV.md](../../../docs/pagespecs/invite/mod/MINV.md) |
| **Public Pages - Marketing** ||||||
| ABOU | About | `/about` | 📋 | - | 🆕 page-ABOU-about.md |
| HOWI | How It Works | `/how-it-works` | 📋 | - | 🆕 page-HOWI-how-it-works.md |
| PRIC | Pricing | `/pricing` | 📋 | - | 🆕 page-PRIC-pricing.md |
| FCRE | For Creators | `/for-creators` | 📋 | - | 🆕 page-FCRE-for-creators.md |
| BTAT | Become a Teacher | `/become-a-teacher` | 📋 | - | 🆕 page-BTAT-become-teacher.md |
| FAQP | FAQ | `/faq` | 📋 | - | 🆕 page-FAQP-faq.md |
| CONT | Contact | `/contact` | 📋 | - | 🆕 page-CONT-contact.md |
| STOR | Success Stories | `/stories` | ✅ | 1.8 | 🆕 page-STOR-stories.md |
| TSTM | Testimonials | `/testimonials` | ✅ | 1.8 | 🆕 page-TSTM-testimonials.md |
| BLOG | Blog | `/blog` | 📋 | - | 🆕 page-BLOG-blog.md |
| CARE | Careers | `/careers` | 📋 | - | 🆕 page-CARE-careers.md |
| **Public Pages - Legal** ||||||
| PRIV | Privacy Policy | `/privacy` | 📋 | - | 🆕 page-PRIV-privacy.md |
| TERM | Terms of Service | `/terms` | 📋 | - | 🆕 page-TERM-terms.md |
| **Authenticated Pages** ||||||
| SDSH | Student Dashboard | `/dashboard/learning` | ✅ | 2 | [SDSH.md](../../../docs/pagespecs/dashboard/learning/SDSH.md) |
| TDSH | Teacher Dashboard | `/dashboard/teaching` | 📋 | 7 | [TDSH.md](../../../docs/pagespecs/dashboard/teaching/TDSH.md) |
| CDSH | Creator Dashboard | `/dashboard/creator` | 📋 | 8 | [CDSH.md](../../../docs/pagespecs/dashboard/creator/CDSH.md) |
| FEED | Community Feed | `/community` | 📋 | 5 | [FEED.md](../../../docs/pagespecs/community/FEED.md) |
| MSGS | Messages | `/messages` | 📋 | 5 | [MSGS.md](../../../docs/pagespecs/MSGS.md) |
| PROF | Profile | `/profile` | 📋 | 9 | [PROF.md](../../../docs/pagespecs/PROF.md) |
| SETT | Settings | `/settings` | ✅ | 9 | [SETT.md](../../../docs/pagespecs/SETT.md) |
| SPAY | Payment Settings | `/settings/payments` | ✅ | 2 | [SPAY.md](../../../docs/pagespecs/settings/SPAY.md) |
| SNOT | Notification Settings | `/settings/notifications` | ✅ | 9 | [SNOT.md](../../../docs/pagespecs/settings/SNOT.md) |
| SPRF | Profile Settings | `/settings/profile` | ✅ | 9 | [SPRF.md](../../../docs/pagespecs/settings/SPRF.md) |
| SSEC | Security Settings | `/settings/security` | ✅ | 9 | [SSEC.md](../../../docs/pagespecs/settings/SSEC.md) |
| NOTF | Notifications | `/notifications` | ✅ | 9 | [NOTF.md](../../../docs/pagespecs/NOTF.md) |
| SBOK | Session Booking | `/courses/:slug/book` | 📋 | 4 | [SBOK.md](../../../docs/pagespecs/session/SBOK.md) |
| SROM | Session Room | `/session/:id` | 📋 | 4 | [SROM.md](../../../docs/pagespecs/session/SROM.md) |
| CCNT | Course Content | `/courses/:slug/learn` | ✅ | 3 | [CCNT.md](../../../docs/pagespecs/courses/CCNT.md) |
| CSUC | Enrollment Success | `/courses/:slug/success` | ✅ | 2 | 🆕 CSUC.md |
| CDIS | Course Discuss | `/courses/:slug/discuss` | 📋 | 5 | 🆕 CDIS.md |
| HELP | Summon Help | `/help` | 📋 | 5 | [HELP.md](../../../docs/pagespecs/HELP.md) |
| IFED | Instructor Feed | `/community/:instructor` | 📋 | 5 | [IFED.md](../../../docs/pagespecs/community/IFED.md) |
| LEAD | Leaderboard | `/leaderboard` | 📋 | - | [LEAD.md](../../../docs/pagespecs/LEAD.md) |
| SUBCOM | Sub-Community | `/groups/:id` | 📋 | - | [SUBCOM.md](../../../docs/pagespecs/groups/SUBCOM.md) |
| **Creator Pages** ||||||
| CMST | My Students | `/dashboard/teaching/students` | 📋 | 7 | [CMST.md](../../../docs/pagespecs/dashboard/teaching/CMST.md) |
| CSES | Session History | `/dashboard/teaching/sessions` | 📋 | 7 | [CSES.md](../../../docs/pagespecs/dashboard/teaching/CSES.md) |
| CANA | Creator Analytics | `/dashboard/creator/analytics` | 📋 | 8 | [CANA.md](../../../docs/pagespecs/dashboard/creator/CANA.md) |
| CEAR | Earnings Detail | `/settings/payments` | ✅ | 2 | [CEAR.md](../../../docs/pagespecs/dashboard/teaching/CEAR.md) |
| CNEW | Creator Newsletters | `/dashboard/creator/newsletters` | 📋 | - | [CNEW.md](../../../docs/pagespecs/dashboard/creator/CNEW.md) |
| **Role-Specific Pages** ||||||
| STUD | Creator Studio | `/dashboard/creator/studio` | 📋 | 8 | [STUD.md](../../../docs/pagespecs/dashboard/creator/STUD.md) |
| ADMN | Admin Dashboard | `/admin` | 📋 | 8 | [ADMN.md](../../../docs/pagespecs/admin/ADMN.md) |
| MODQ | Moderator Queue | `/mod` | 📋 | 8 | [MODQ.md](../../../docs/pagespecs/mod/MODQ.md) |
| **Admin SPA Screens** (routes within `/admin`) ||||||
| AUSR | Admin Users | `/admin/users` | ✅ | 8 | [AUSR.md](../../../docs/pagespecs/admin/AUSR.md) |
| ACRS | Admin Courses | `/admin/courses` | 📋 | 8 | 🆕 ACRS.md |
| AENR | Admin Enrollments | `/admin/enrollments` | 📋 | 8 | [AENR.md](../../../docs/pagespecs/admin/AENR.md) |
| ASES | Admin Sessions | `/admin/sessions` | 📋 | 8 | [ASES.md](../../../docs/pagespecs/admin/ASES.md) |
| ACRT | Admin Certificates | `/admin/certificates` | 📋 | 8 | [ACRT.md](../../../docs/pagespecs/admin/ACRT.md) |
| APAY | Admin Payouts | `/admin/payouts` | 📋 | 8 | [APAY.md](../../../docs/pagespecs/admin/APAY.md) |
| ACAT | Admin Categories | `/admin/categories` | 📋 | 8 | 🆕 ACAT.md |

### Implementation Summary

| Status | Count | Description |
|--------|-------|-------------|
| ✅ Implemented | 20 | Real components, fetches data from D1 |
| 📋 Spec Only | 21 | Uses PageSpecView placeholder |
| 🆕 Needs Spec | 15 | Route exists, spec file needed |
| **Total** | **56** | |

**Implemented Pages (20):**
- Block 0: LGIN, SGUP, PWRS
- Block 1: HOME, CBRO, CDET, CRLS, CPRO
- Block 1.8: STOR, TSTM
- Block 2: SDSH, CSUC, SPAY
- Block 3: CCNT
- Block 8: AUSR
- Block 9: SETT, SNOT, SPRF, SSEC, NOTF

**Needs Spec Files (15):**
ABOU, HOWI, PRIC, FCRE, BTAT, FAQP, CONT, STOR, TSTM, BLOG, CARE, PRIV, TERM, CSUC, CDIS

---

## Pages by Priority

### P0 - MVP Core (31 pages/screens)
| Code | Page Name |
|------|-----------|
| HOME | Homepage |
| CBRO | Course Browse |
| CDET | Course Detail |
| CRLS | Creator Listing |
| CPRO | Creator Profile |
| STPR | Teacher Profile |
| LGIN | Login |
| SGUP | Sign Up |
| PWRS | Password Reset |
| SDSH | Student Dashboard |
| TDSH | Teacher Dashboard |
| CDSH | Creator Dashboard |
| FEED | Community Feed |
| MSGS | Messages |
| PROF | Profile |
| SETT | Settings |
| NOTF | Notifications |
| SBOK | Session Booking |
| SROM | Session Room |
| CCNT | Course Content |
| STUD | Creator Studio |
| CMST | My Students (Creator) |
| CSES | Session History (Creator) |
| CEAR | Earnings Detail (Creator) |
| ADMN | Admin Dashboard |
| AUSR | Admin Users |
| ACRS | Admin Courses |
| AENR | Admin Enrollments |
| ASES | Admin Sessions |
| ACRT | Admin Certificates |
| APAY | Admin Payouts |

### P1 - Important (6 pages/screens)
| Code | Page Name |
|------|-----------|
| STDR | Teacher Directory |
| IFED | Instructor Feed |
| MODQ | Moderator Queue |
| CANA | Creator Analytics |
| ACAT | Admin Categories |
| MINV | Moderator Invite |

### P2 - Block 2+ (2 pages)
| Code | Page Name |
|------|-----------|
| CHAT | Course Chat (Goodwill) |
| HELP | Summon Help (Goodwill) |

### P3 - Future Consideration (3 pages)
| Code | Page Name |
|------|-----------|
| CNEW | Creator Newsletters |
| LEAD | Leaderboard |
| SUBCOM | Sub-Community |

---

## Connection Summary

*Quick reference for navigation paths. See individual page files for full details.*

### Primary User Journeys

**Visitor → Student Journey:**
```
HOME → CBRO → CDET → SGUP → LGIN → SBOK → SDSH
```

**Student → Learning Journey:**
```
SDSH → CCNT → SBOK → SROM → CCNT → (complete) → SDSH
```

**Student → Teacher Journey:**
```
SDSH → (certified) → TDSH → SROM → TDSH
```

**Creator Journey:**
```
LGIN → CDSH → STUD → (create course) → CDSH
```

**Creator Management Journey:**
```
CDSH → CMST (students) → CSES (sessions) → CANA (analytics) → CEAR (earnings)
```

**Admin Journey:**
```
LGIN → ADMN → AUSR/ACRS/AENR/ASES/ACRT/APAY/ACAT (SPA routes)
```

---

## Document History

| Date | Changes |
|------|---------|
| 2026-01-22 | **Migration complete:** All PageSpecs moved to `docs/pagespecs/` with mirrored folder structure |
| 2026-01-22 | Added SSEC (Security Settings), SNOT, SPRF, SPAY PageSpec documents |
| 2025-12-25 | Added 3 P3 pages: CNEW (Creator Newsletters), LEAD (Leaderboard), SUBCOM (Sub-Community) |
| 2025-12-25 | Added 11 pages: Creator (CMST, CSES, CANA, CEAR) + Admin screens (AUSR, ACRS, AENR, ASES, ACRT, APAY, ACAT) |
| 2025-12-25 | Initial creation with 27 pages, schema definition |
