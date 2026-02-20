# Post-MVP Features

**Purpose:** Features deferred beyond MVP (P2/P3 priority).

---

## P2 Features (Block 2+)

### CHAT - Course Chat

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-CHAT-001 | View course chat | Display | Page load | GET Stream course feed | Chat messages | US-S029 | GO-001 | F-ENR-001, F-STRM-001 | POST-MVP | 4 | 2025-12-25 |
| F-CHAT-002 | Send message | Action | Click Send | POST to Stream | Send button | US-S029 | GO-001 | F-CHAT-001 | POST-MVP | 2 | 2025-12-25 |
| F-CHAT-003 | Ask question | Action | Click Ask | Tag as question | Ask button | US-S030 | GO-001 | F-CHAT-001 | POST-MVP | 2 | 2025-12-25 |

### HELP - Summon Help

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-HELP-001 | Open help modal | Action | Click Help | Open modal | Help button | US-S031 | GO-019 | F-ENR-001 | POST-MVP | 2 | 2025-12-25 |
| F-HELP-002 | Describe problem | Action | Type description | Store in form state | Text area | US-S031 | GO-019 | F-HELP-001 | POST-MVP | 1 | 2025-12-25 |
| F-HELP-003 | Spend goodwill points | Action | Click Submit | POST /api/help-requests, deduct points | Submit button | US-S031 | GO-019 | F-HELP-002 | POST-MVP | 3 | 2025-12-25 |
| F-HELP-004 | View matched STs | Display | After submit | Show available STs | ST list | US-P054 | GO-019 | F-HELP-003 | POST-MVP | 3 | 2025-12-25 |

---

## P3 Features (Future)

### FEED - Community Feed (P3 Features)

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-FEED-008 | Promote post | Action | Click Promote | Spend goodwill points | Promote button | US-S071 | GO-019 | F-FEED-001 | POST-MVP | 4 | 2025-12-25 |
| F-FEED-009 | AI Chat companion | Action | Click AI Chat | Open AI chat panel | AI button | US-S079 | GO-027 | F-FEED-001 | POST-MVP | 8 | 2025-12-25 |

### LEAD - Leaderboard

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-LEAD-001 | View leaderboard | Display | Page load | GET /api/leaderboard | Rankings table | US-P053 | GO-019 | F-AUTH-001 | POST-MVP | 4 | 2025-12-25 |
| F-LEAD-002 | Filter by period | Action | Select period | Re-fetch rankings | Period dropdown | US-P053 | GO-019 | F-LEAD-001 | POST-MVP | 2 | 2025-12-25 |
| F-LEAD-003 | View rewards tiers | Display | Page load | Show tier progress | Tiers section | US-P082 | GO-019 | F-LEAD-001 | POST-MVP | 2 | 2025-12-25 |

### SUBCOM - Sub-Community

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-SUBC-001 | View sub-community | Display | Page load | GET /api/communities/:slug | Community page | US-S081 | GO-001 | F-AUTH-001 | POST-MVP | 4 | 2025-12-25 |
| F-SUBC-002 | Create sub-community | Action | Click Create | POST /api/communities | Create button | US-S081 | GO-001 | F-AUTH-001 | POST-MVP | 4 | 2025-12-25 |
| F-SUBC-003 | Invite members | Action | Click Invite | POST /api/communities/:id/invites | Invite button | US-P097 | GO-001 | F-SUBC-001 | POST-MVP | 3 | 2025-12-25 |
| F-SUBC-004 | Post to community | Action | Click Post | POST to community feed | Post button | US-S081 | GO-001 | F-SUBC-001 | POST-MVP | 2 | 2025-12-25 |

### CNEW - Creator Newsletters

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-CNEW-001 | View newsletters | Display | Page load | GET /api/me/newsletters | Newsletter list | US-C026 | GO-001 | F-AUTH-001 | POST-MVP | 3 | 2025-12-25 |
| F-CNEW-002 | Create newsletter | Action | Click Create | Open editor | Create button | US-C026 | GO-001 | F-CNEW-001 | POST-MVP | 4 | 2025-12-25 |
| F-CNEW-003 | Send newsletter | Action | Click Send | POST /api/newsletters/:id/send | Send button | US-C026 | GO-001 | F-CNEW-002 | POST-MVP | 3 | 2025-12-25 |

---

## Summary

| Priority | Pages | Features | Hours |
|----------|-------|----------|-------|
| P2 | CHAT, HELP | 7 | 17 |
| P3 | FEED (P3), LEAD, SUBCOM, CNEW | 15 | 43 |
| **Total** | | **22** | **60** |

---

## Notes

- These features can be pulled into MVP if time/budget allows
- Dependencies on MVP features are noted in "Depends On" column
- Hours are estimates; actual effort may vary
