# CD-023: Goodwill Points System Specification (Dec 12, 2025)

**Date Uploaded:** 2025-12-23
**Original Date:** 2025-12-12
**Source File:** `Brians GOODWILL_POINTS_SPEC Dec 12, 2025.md`
**Author:** Brian LeBlanc
**Status:** DRAFT
**Summary for SPECS.md:**

Comprehensive specification for a community currency system called "Goodwill Points" that rewards users for helping others. Replaces traditional 5-star reviews with a more meaningful contribution metric. Includes anti-gaming safeguards, "Summon Help" feature, and future monetization tiers.

---

## Core Concept

Goodwill Points are a community currency rewarding helpful behavior:

| Term | Visibility | Description |
|------|------------|-------------|
| **Total Earned** | Public | Lifetime points earned (shows credibility) |
| **Balance** | Private | Points available to award others |
| **Spent** | Private | Points given to helpers |

**Formula:** `Balance = Total Earned - Spent`

---

## How Points Are Earned

| Action | Points | Awarded By | Limits |
|--------|--------|------------|--------|
| Answer a Summon help request | 10-25 | System (auto) | Must be certified in course |
| Answer question in course chat | 5 | Requester | Max 3/day to same person |
| Help S-T through first teaching session | 50 | System (auto) | One-time per new S-T |
| Refer new student who enrolls | 100 | PeerLoop | One-time per referral |
| Volunteer for remedial session | 30 | Student | Max 2/week from same student |
| "Available to Help" status active | 5/day | System (auto) | Only while actively available |

---

## Anti-Gaming Safeguards

| Rule | Purpose |
|------|---------|
| Must be certified in course to earn points | Ties to paying courses |
| Daily cap on points given TO any single user | Prevents friend-farming |
| Daily cap on points given BY any single user | Prevents point inflation |
| Minimum 5 min in help session before points | Prevents quick clicks |
| 24-48 hour cooldown between awarding same person | Prevents gaming |

---

## The "Summon Help" Feature

**Who can use:** Only enrolled students
**Who responds:** Certified S-Ts with "Available to Help" on

**Flow:**
1. Student clicks "Summon Help" button on course content
2. Available helpers (certified S-Ts) get notification
3. First responder joins chat/video
4. After 5+ min session, student awards points (10-25 slider)
5. Points added to helper's Total Earned

**UI Mockup from spec:**
```
┌─────────────────────────────────────────────────────────────┐
│  📚 AI Prompting Mastery - Module 3                         │
│  [Video Player]                                             │
│  Stuck? Get help from a certified peer:                     │
│  [🆘 Summon Help]                                           │
│  Available helpers: 3 online                                │
└─────────────────────────────────────────────────────────────┘
```

---

## Course Chat with Help Queue

**Features:**
- Mark message as question
- "This Helped" button awards 5 points

**UI Mockup from spec:**
```
┌─────────────────────────────────────────────────────────────┐
│  💬 AI Prompting Mastery - Community Chat                   │
│  Sarah: Can someone explain chain prompting?                │
│         [❓ Mark as Question]                               │
│  Marcus: Sure! Chain prompting is when you...               │
│          [✅ This Helped] ← awards 5 points                 │
└─────────────────────────────────────────────────────────────┘
```

---

## Profile Display

### Public View
- Total Goodwill Points earned
- Breakdown: students helped via Summon, questions answered, referrals
- "View Full Activity" link

### Private View
- Total Earned
- Spent (given to helpers)
- Available to Award (balance)

---

## Future Monetization (Phase 2+)

| Points Threshold | Reward |
|------------------|--------|
| 500 points | Badge: "Community Helper" |
| 1,000 points | 10% discount on next course |
| 2,500 points | Free 1-on-1 session with any Creator |
| 5,000 points | Revenue share bonus (extra 5% on teaching) |

---

## Database Schema (from spec)

### User Object Addition
```javascript
goodwillPoints: {
  totalEarned: 847,        // Public
  balance: 727,            // Private
  spent: 120,              // Private
  lastAwardedTo: {         // Anti-gaming
    userId: "user_123",
    timestamp: "2025-12-12T10:00:00Z"
  }
}
```

### New Collection: goodwillTransactions
```javascript
{
  id: "txn_001",
  fromUserId: "sarah_123",
  toUserId: "marcus_456",
  points: 15,
  reason: "summon_help",   // enum
  courseId: 15,
  timestamp: "2025-12-12T10:30:00Z"
}
```

### Transaction Reasons (enum)
- `summon_help` - Responded to a Summon request
- `question_answer` - Answered a question in chat
- `first_session_mentor` - Helped new S-T through first session
- `referral` - Referred a student who enrolled
- `remedial_volunteer` - Volunteered for remedial session
- `availability_bonus` - Daily bonus for being available

---

## Block Roadmap

| Block | Goodwill Feature |
|-------|------------------|
| Block 1 | ❌ Not included (MVP) |
| Block 2 | ✅ Basic points + Summon button |
| Block 3 | ✅ Chat room questions + rewards |
| Block 4 | ✅ Referral tracking + monetization |

**Note:** This is NOT an MVP feature - slated for Block 2+.

---

## Brian's Original Vision

> "Goodwill points can take the place of a 5 star review. How many points has a user earned... These points can be figuratively spent, awarding points to other people who help – with limitations. The total points earned would indicate how active the user has been in the community."

> "The motivation is to build up total earned Goodwill points to demonstrate his usefulness in building the community. As the value increases, his trustworthiness and credibility increases."

---

## Technical Implications

### DB-SCHEMA.md Additions
- Add goodwill fields to users table
- New table: goodwill_transactions
- New table: help_summons
- New enum: transaction_reason

### PAGES.md Additions
- Summon Help interface on Course Content page
- Course Chat Room page
- Goodwill section on Profile/Dashboard

### COMPONENTS.md Additions
- SummonHelpButton
- GoodwillPointsDisplay (public)
- GoodwillBalanceCard (private)
- MarkAsQuestionButton
- ThisHelpedButton
- PointsSlider (10-25)
- AvailableToHelpToggle
- GoodwillBadge

### API.md Additions
- Summon CRUD endpoints
- Goodwill points award/query endpoints
- Availability status endpoints

---

## Goals Implications
- Supports GO-001 (flywheel) - incentivizes community help
- Supports GO-004 (engagement) - gamification drives participation
- New goal implied: Community engagement and retention

## User Stories Implied
- Students summoning help
- S-Ts responding to summons
- Awarding/receiving points
- Anti-gaming enforcement
- Availability status management

---

*Document created: December 12, 2025*
