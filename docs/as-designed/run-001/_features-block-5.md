# Block 5: Community Feed Features

**Block:** 5
**Focus:** Stream.io integration, feed, messages
**Pages:** FEED, MSGS, IFED, CPRO (follow)

---

## FEED - Community Feed

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-FEED-001 | View feed | Display | Page load | GET Stream feed, render posts | Post list | US-S016 | GO-001 | F-AUTH-001, F-STRM-001 | MVP | 6 | 2025-12-25 |
| F-FEED-002 | Create post | Action | Click Post | Open composer modal | New post button | US-S017 | GO-001 | F-FEED-001 | MVP | 4 | 2025-12-25 |
| F-FEED-003 | Submit post | Action | Click Submit | POST to Stream, update feed | Submit button | US-S017 | GO-001 | F-FEED-002 | MVP | 3 | 2025-12-25 |
| F-FEED-004 | React to post | Action | Click reaction | POST reaction to Stream | Reaction buttons | US-S018 | GO-001 | F-FEED-001 | MVP | 2 | 2025-12-25 |
| F-FEED-005 | Comment on post | Action | Click Comment | Open comment input | Comment button | US-S019 | GO-001 | F-FEED-001 | MVP | 3 | 2025-12-25 |
| F-FEED-006 | Submit comment | Action | Click Submit | POST comment to Stream | Submit button | US-S019 | GO-001 | F-FEED-005 | MVP | 2 | 2025-12-25 |
| F-FEED-007 | Infinite scroll | Action | Scroll to bottom | Fetch next page | - | US-S016 | GO-001 | F-FEED-001 | MVP | 2 | 2025-12-25 |
| F-FEED-010 | Filter by course community | Action | Select course | Filter feed by course | Course filter | US-S016 | GO-001 | F-FEED-001 | MVP | 2 | 2025-12-25 |

*Note: F-FEED-008 (Promote post) and F-FEED-009 (AI Chat) are POST-MVP.*

---

## MSGS - Messages

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-MSGS-001 | View conversations list | Display | Page load | GET /api/me/conversations | Conversation list | US-S020 | GO-001 | F-AUTH-001 | MVP | 3 | 2025-12-25 |
| F-MSGS-002 | Select conversation | Action | Click conversation | Load messages for conversation | Conversation item | US-S021 | GO-001 | F-MSGS-001 | MVP | 2 | 2025-12-25 |
| F-MSGS-003 | View messages | Display | Select conversation | GET /api/conversations/:id/messages | Message list | US-S021 | GO-001 | F-MSGS-002 | MVP | 2 | 2025-12-25 |
| F-MSGS-004 | Send message | Action | Click Send | POST /api/conversations/:id/messages | Send button | US-S020 | GO-001 | F-MSGS-003 | MVP | 3 | 2025-12-25 |
| F-MSGS-005 | Start new conversation | Action | Click New | Search users, create conversation | New message button | US-S020 | GO-001 | F-MSGS-001 | MVP | 3 | 2025-12-25 |
| F-MSGS-006 | Real-time updates | Display | Message received | WebSocket/Stream update | - | US-S020 | GO-001 | F-MSGS-003 | MVP | 4 | 2025-12-25 |
| F-MSGS-007 | Unread indicator | Display | Unread messages | Show badge count | Unread badge | US-S021 | GO-001 | F-MSGS-001 | MVP | 1 | 2025-12-25 |

---

## IFED - Instructor Feed

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-IFED-001 | View instructor feed | Display | Page load | GET Stream instructor feed | Post list | US-S032 | GO-001 | F-ENR-001, F-STRM-001 | MVP | 3 | 2025-12-25 |
| F-IFED-002 | React to post | Action | Click reaction | POST reaction | Reaction buttons | US-S033 | GO-001 | F-IFED-001 | MVP | 1 | 2025-12-25 |
| F-IFED-003 | Comment on post | Action | Click Comment | POST comment | Comment button | US-S033 | GO-001 | F-IFED-001 | MVP | 2 | 2025-12-25 |
| F-IFED-004 | View exclusive content | Display | Page load | Show purchaser-only content | Content section | US-S032 | GO-001 | F-IFED-001 | MVP | 2 | 2025-12-25 |

---

## CPRO - Creator Profile (Follow Features)

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-CPRO-005 | Follow creator (visitor) | Action | Click Follow | Redirect to SGUP | Follow button | US-S028 | GO-001 | F-CPRO-001 | MVP | 1 | 2025-12-25 |
| F-CPRO-006 | Follow creator (logged in) | Action | Click Follow | POST /api/creators/:id/follow | Follow button | US-S028 | GO-001 | F-CPRO-001, F-AUTH-001 | MVP | 2 | 2025-12-25 |

---

## Block 5 Summary

| Page | Features | Hours |
|------|----------|-------|
| FEED | 8 | 24 |
| MSGS | 7 | 18 |
| IFED | 4 | 8 |
| CPRO (follow) | 2 | 3 |
| **Total** | **21** | **53** |

---

## Infrastructure Dependencies

Block 5 requires:

| ID | Feature | Hours |
|----|---------|-------|
| F-STRM-001 | Stream.io integration | 16 |

**Block 5 Total with Infrastructure: 69 hours**
