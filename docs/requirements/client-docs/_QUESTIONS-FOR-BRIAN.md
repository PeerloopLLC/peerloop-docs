# Questions for Brian

**Purpose:** Consolidated list of all open questions requiring Brian's input, organized by source document.

**Last Updated:** 2025-12-24

---

## From CD-005: Slack - GetStream Feed Discussion

1. **GetStream.io vs Bluesky protocol** - CD-002 (Nov 29) mentions Bluesky protocol for community, but CD-005 (Nov 13) mentions GetStream.io. CD-008 clarified "feeds only" from Stream. Is Bluesky still in consideration, or is GetStream.io the confirmed choice?

---

## From CD-007 & CD-028: Video Platform Decision

> **UPDATE (2025-12-24):** Questions #2-4 are now **non-blocking** due to architectural decision. See `API.md` → "Video Platform Interface Contract". The video platform is abstracted behind an interface - any compliant provider (BBB, PlugNmeet, Daily.co) can be selected during implementation without affecting core architecture.

2. ~~**Video platform final decision**~~ → **DEFERRED TO IMPLEMENTATION** - Interface contract defined in API.md. Provider selection can happen later based on cost/hosting preferences.

3. ~~**PlugNmeet evaluation status**~~ → **DEFERRED TO IMPLEMENTATION** - PlugNmeet can be evaluated against the VideoProvider interface during implementation. DIR-001 may be updated to "MUST-USE VideoProvider-compliant platform".

4. **Single platform or hybrid?** - Interface allows for multiple providers if needed. Decision can be made during implementation based on cost analysis.

---

## From CD-010: Miro Board - Main Activities by Role

5. **Newsletter with subscription payments** - Is a paid newsletter feature planned? Document mentions "Newsletter possibility with subscription payments" as a question.

---

## From CD-011: Miro Board - Drivers & Action Items

6. **AI Assistant technology** - Document lists AI Assistant for Students as "TBD". What is the scope and technology choice for AI assistance? MVP or post-MVP?

7. **Newsletters technology** - Document lists Newsletters as "TBD". What is the scope for newsletters? Is this related to the paid newsletter question in CD-010?

8. **Bluesky vs GetStream.io** - CD-011 explicitly mentions Bluesky for community tool, but CD-005/CD-008/CD-013 confirm GetStream.io for feeds. Which is correct? Are both used for different purposes?

9. **Certificate of Mastery vs Completion** - Document mentions two certificate types. What's the difference? How does a student earn Mastery vs Completion? Is Mastery MVP or post-MVP?

---

## From CD-018: Student Profile System

10. **Profile visibility default** - Should new profiles default to Public or Private? Document notes "default TBD".

---

## From CD-027: Prototype Walkthrough

### Community & Feed Structure
11. **Community Structure** - Is instructor community the same as `instructor_followers` from CD-024, or a separate entity?

12. **Channels within Communities** - Are "Everyone" and "creator-2" (seen in post badges) channels/sub-groups, or test artifacts?

13. **Auto-join Rules** - Which communities do new users automatically join? Just Town Hall, or also some instructors?

14. **Course vs Instructor Feed Access** - User pays for course → gets course feed access. User pays for ANY course from instructor → gets instructor feed access. Is this correct?

### Sessions & Availability
15. **Availability States** - Just Available/Unavailable, or more states (Busy, Away, etc.)?

16. **Session Booking Integration** - Is booking calendar-first (schedule then get BBB/PlugNmeet link), or video-platform-first?

17. **Group Sessions** - Are group sessions (4+ students) part of MVP? Prototype shows "Group Session · 4 students" in Teaching Dashboard.

### Role-Specific Features
18. **Creator Dashboard** - Does Creator need a separate "Creator Studio" or third tab beyond Learning/Teaching? Currently Creator shows identical view to Student-Teacher.

19. **Admin Features** - What admin capabilities are needed for MVP vs post-MVP? Current prototype has no admin implementation.

### Course Content
20. **Homework System** - Is homework submission/grading part of MVP? Prototype shows detailed homework tracking with due dates and scores.

21. **Session Resources** - Are per-session resources (Recording, Slides, Code Files) stored in platform or external links (like course content)?

### UX Decisions
22. **User Menu in Header** - Confirm need for header user dropdown with avatar, settings, logout? Currently missing from prototype.

---

## From CD-032: Fraser Meeting Notes (Dec 24 Observations)

### Student-Teacher Pricing Visibility
23. ~~**S-T Pricing Before Purchase**~~ → **RESOLVED (CD-033)** - The course price **IS** the S-T price. Creators price courses as if they're NOT the primary teacher. There is no separate Teacher premium pricing. This eliminates the "hidden pricing" concern entirely.

> **Key clarifications from CD-033:**
> - Unified pricing model: single price point per course
> - Creator charges same as S-Ts (no premium)
> - 85/15 revenue split (platform/creator+S-T)
> - Enrollment flow shows S-T availability calendar before purchase
> - "Schedule Later" option available after purchase
> - Students can refund at any time

### Course Completion Criteria
24. **How do students "pass" a course?** - What are the criteria for completing/passing a course?
    - Is it self-reported progress (checkboxes)?
    - Is it S-T recommendation + Creator approval (as documented)?
    - Is there a minimum number of sessions?
    - What happens if a student can't pass in allotted sessions?

### Moderator Mechanics
25. **Moderator Invite System** - How does a Teacher invite a Moderator?
    - Is there an invite link/code?
    - Can a Moderator be assigned to specific feeds (Teacher feed, course feed, or both)?
    - What is the onboarding flow for Moderators?

### Timeline Concern
26. ~~**6 Months vs 4 Months**~~ → **RESOLVED** - Brian confirms **4 months is the goal**. Strategy: Practice feature removal if scope doesn't fit. Timeline is fixed; features are flexible.

---

## Summary

| Source | Questions | Status |
|--------|-----------|--------|
| CD-005 | 1 | ✅ Resolved |
| CD-007 & CD-028 | 3 | **#2-4 Deferred** (interface abstraction) |
| CD-010 | 1 | ✅ Resolved |
| CD-011 | 4 | ✅ Resolved (#8 superseded by #1) |
| CD-018 | 1 | ✅ Resolved |
| CD-027 | 12 | ✅ Resolved (#12 unclear - skip) |
| CD-032 | 4 | ✅ Resolved |
| **Total** | **26** | **22 Resolved, 3 Deferred, 1 Unclear** |

---

## How to Use This Document

1. Review questions before meeting with Brian
2. Check off or annotate answers as received
3. After answers received, update relevant docs (SPECS.md, architecture docs)
4. Move answered questions to "Resolved" section below

---

## Resolved Questions

*(Move questions here after Brian answers them, with the answer noted)*

| Question | Answer | Date | Updated In |
|----------|--------|------|------------|
| #23: S-T Pricing Visibility | Course price IS S-T price. Unified pricing, no Teacher premium. 85/15 split. | 2025-12-24 | CD-033, API.md |
| #26: Timeline (6 vs 4 months) | 4 months confirmed. Feature removal strategy if scope doesn't fit. | 2025-12-24 | PLAN.md |
| #1: GetStream vs Bluesky | **Stream for feeds** - GetStream.io confirmed | 2025-12-26 | - |
| #5: Paid newsletter subscriptions | **No, Post-MVP** | 2025-12-26 | FEATURE-FLAGS.md |
| #6: AI Assistant | **Post-MVP** | 2025-12-26 | FEATURE-FLAGS.md |
| #7: Newsletters technology | **Use Resend**, scope TBD (use good defaults) | 2025-12-26 | REMOTE-API.md |
| #9: Mastery vs Completion certs | **Completion=MVP, Mastery=post-MVP** | 2025-12-26 | FEATURE-FLAGS.md |
| #10: Profile visibility default | **Private** | 2025-12-26 | DB-SCHEMA.md |
| #11: Instructor community | **Yes**, same as `instructor_followers` | 2025-12-26 | - |
| #13: Auto-join communities | **Just Town Hall** for now, may expand later | 2025-12-26 | - |
| #14: Feed access rules | **Confirmed** - course purchase → course feed; any instructor course → instructor feed | 2025-12-26 | - |
| #15: Availability states | **Just Available/Unavailable** | 2025-12-26 | DB-SCHEMA.md |
| #16: Booking flow | **Calendar-first** (schedule then get video link) | 2025-12-26 | - |
| #17: Group sessions | **No, post-MVP** | 2025-12-26 | FEATURE-FLAGS.md |
| #18: Creator Studio tab | **No** - Creator uses same dashboard as ST | 2025-12-26 | - |
| #19: Admin features MVP | **CRUD to start**, add as needed | 2025-12-26 | - |
| #20: Homework submission/grading | **Yes, MVP** | 2025-12-26 | FEATURE-FLAGS.md |
| #21: Session resources storage | **Stored on platform** (R2) | 2025-12-26 | DB-SCHEMA.md |
| #22: Header user dropdown | **Yes** - avatar/settings/logout | 2025-12-26 | COMPONENTS.md |
| #24: Course completion criteria | **ST recommendation + Creator approval** | 2025-12-26 | - |
| #25: Moderator invite flow | **Two-step**: email to invite to platform, then email to assign moderator role | 2025-12-26 | - |
