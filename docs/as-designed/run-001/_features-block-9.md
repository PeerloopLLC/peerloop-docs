# Block 9: Polish Features

**Block:** 9
**Focus:** Notifications, analytics, settings, profile
**Pages:** PROF, SETT, NOTF, CANA, CDET (share)

---

## PROF - Profile

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-PROF-001 | View own profile | Display | Page load | GET /api/me/profile | Profile sections | US-S022 | GO-001 | F-AUTH-001 | MVP | 2 | 2025-12-25 |
| F-PROF-002 | Edit profile info | Action | Click Edit | Open edit mode | Edit button | US-S022 | GO-001 | F-PROF-001 | MVP | 3 | 2025-12-25 |
| F-PROF-003 | Save profile changes | Action | Click Save | PATCH /api/me/profile | Save button | US-S022 | GO-001 | F-PROF-002 | MVP | 2 | 2025-12-25 |
| F-PROF-004 | Upload avatar | Action | Click avatar | Upload image, update profile | Avatar upload | US-S023 | GO-001 | F-PROF-001 | MVP | 3 | 2025-12-25 |
| F-PROF-005 | Set visibility | Action | Toggle visibility | PATCH /api/me/profile | Visibility toggles | US-S024 | GO-001 | F-PROF-001 | MVP | 2 | 2025-12-25 |
| F-PROF-006 | View public preview | Action | Click Preview | Show public view | Preview button | US-S024 | GO-001 | F-PROF-001 | MVP | 2 | 2025-12-25 |

---

## SETT - Settings

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-SETT-001 | View settings page | Display | Page load | GET /api/me/settings | Settings form | US-S025 | GO-001 | F-AUTH-001 | MVP | 2 | 2025-12-25 |
| F-SETT-002 | Manage notifications | Action | Toggle settings | PATCH /api/me/settings | Notification toggles | US-S025 | GO-001 | F-SETT-001 | MVP | 2 | 2025-12-25 |
| F-SETT-004 | Manage connected accounts | Display | Page load | Show OAuth connections | Connected accounts | US-P012 | GO-001 | F-SETT-001 | MVP | 2 | 2025-12-25 |
| F-SETT-005 | Disconnect OAuth | Action | Click Disconnect | DELETE /api/auth/connections/:provider | Disconnect button | US-P012 | GO-001 | F-SETT-004 | MVP | 2 | 2025-12-25 |
| F-SETT-006 | Delete account | Action | Click Delete | Confirm + DELETE /api/me | Delete button | US-P013 | GO-001 | F-SETT-001 | MVP | 3 | 2025-12-25 |
| F-SETT-007 | Email preferences | Action | Toggle email types | PATCH /api/me/settings | Email toggles | US-S025 | GO-001 | F-SETT-001 | MVP | 1 | 2025-12-25 |

*Note: Change password (F-SETT-003) is in Block 0.*

---

## NOTF - Notifications

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-NOTF-001 | View notifications | Display | Page load | GET /api/me/notifications | Notification list | US-P014 | GO-001 | F-AUTH-001 | MVP | 3 | 2025-12-25 |
| F-NOTF-002 | Mark as read | Action | Click notification | PATCH /api/notifications/:id | Notification item | US-P015 | GO-001 | F-NOTF-001 | MVP | 1 | 2025-12-25 |
| F-NOTF-003 | Mark all as read | Action | Click Mark All | PATCH /api/me/notifications/read-all | Mark all button | US-P015 | GO-001 | F-NOTF-001 | MVP | 1 | 2025-12-25 |
| F-NOTF-004 | Clear notifications | Action | Click Clear | DELETE /api/me/notifications | Clear button | US-P016 | GO-001 | F-NOTF-001 | MVP | 1 | 2025-12-25 |
| F-NOTF-005 | Click notification | Action | Click item | Navigate to relevant page | Notification item | US-P014 | GO-001 | F-NOTF-001 | MVP | 2 | 2025-12-25 |
| F-NOTF-006 | Unread count badge | Display | Always | Show count in nav | Badge | US-P014 | GO-001 | F-AUTH-001 | MVP | 1 | 2025-12-25 |

---

## CANA - Creator Analytics

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-CANA-001 | View enrollment trends | Display | Page load | GET /api/me/analytics/enrollments | Chart | US-C013 | GO-001 | F-AUTH-001 | MVP | 4 | 2025-12-25 |
| F-CANA-002 | View revenue analytics | Display | Page load | GET /api/me/analytics/revenue | Revenue chart | US-C014 | GO-001 | F-CANA-001 | MVP | 3 | 2025-12-25 |
| F-CANA-003 | View engagement metrics | Display | Page load | GET /api/me/analytics/engagement | Engagement chart | US-C015 | GO-001 | F-CANA-001 | MVP | 3 | 2025-12-25 |
| F-CANA-004 | Filter by date range | Action | Select dates | Re-fetch with params | Date picker | US-C013 | GO-001 | F-CANA-001 | MVP | 2 | 2025-12-25 |
| F-CANA-005 | Filter by course | Action | Select course | Re-fetch with params | Course dropdown | US-C013 | GO-001 | F-CANA-001 | MVP | 1 | 2025-12-25 |
| F-CANA-006 | Export analytics | Action | Click Export | Download CSV/PDF | Export button | US-C013 | GO-001 | F-CANA-001 | MVP | 3 | 2025-12-25 |

---

## CDET - Course Detail (Share)

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-CDET-011 | Share course | Action | Click share | Copy URL / open share modal | Share button | - | GO-001 | F-CDET-001 | MVP | 1 | 2025-12-25 |

---

## Block 9 Summary

| Page | Features | Hours |
|------|----------|-------|
| PROF | 6 | 14 |
| SETT | 6 | 12 |
| NOTF | 6 | 9 |
| CANA | 6 | 16 |
| CDET (share) | 1 | 1 |
| **Total** | **25** | **52** |

---

## Infrastructure Dependencies

Block 9 requires:

| ID | Feature | Hours |
|----|---------|-------|
| F-NOTIF-001 | Notification system | 16 |

**Block 9 Total with Infrastructure: 68 hours**
