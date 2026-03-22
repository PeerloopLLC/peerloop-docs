# CD-006: Slack Message - Calendar, BBB, Discord Discussion

**Source:** Slack message from client
**Date:** 2025-11-17
**Added:** 2025-11-30

---

## Original Message

> I want to let y'all know my current thinking so you can ponder before tomorrow. I think we need a full blown calendar feature so we don't have to try and keep up behind the scenes with scheduling. Full profile, calendar, and big blue button integration. Big blue button has service providers so we can easily integrate without hosting. BBB charges by the session instead of by the user. This is a huge cost savings versus zoom. We can use Discord for real time communications.
>
> If each user had to pay a monthly fee for Zoom that adds overhead for the user plus a setup hassle we don't need for the user.
>
> As it is users will need to setup discord (or slack, telegram) for real time communication.

---

## Summary for SPECS.md

Client communication clarifying infrastructure priorities and technology decisions for scheduling, video, and real-time communication.

**Key elements for SPECS.md:**

- **Calendar Feature:** "Full blown calendar feature" required

  - Rationale: Avoid manual behind-the-scenes scheduling management
  - Core MVP component alongside profiles

- **Video Conferencing:** BigBlueButton (BBB) confirmed

  - Use hosted service providers (not self-hosted)
  - Pricing model: Per-session vs per-user (cost savings vs Zoom)
  - Avoids user-paid monthly fees (reduces friction)

- **Real-Time Communication:** Discord accepted as interim solution

  - Alternatives mentioned: Slack, Telegram
  - Users will need to set up external accounts
  - Implies real-time chat is not MVP for in-platform build

- **Cost Considerations:**
  - BBB per-session pricing preferred over Zoom per-user pricing
  - Avoiding user-paid monthly fees reduces friction and overhead
  - Hosted BBB services preferred over self-hosting

**Technical Implications:**

- Calendar system must be robust ("full blown")
- BBB integration via hosted provider API
- External chat platform (Discord/Slack/Telegram) for real-time communication initially
- No immediate need to build in-platform chat for MVP

**Relationship to Other Docs:**

- Reinforces CD-002's BigBlueButton mention
- Reinforces CD-005's Discord as interim solution
- Confirms calendar as MVP priority (also in CD-005)
- **Chronology:** Nov 16 - between CD-005 (Nov 13) and CD-002 (Nov 29)

**Open Questions:**

- Which BBB hosted provider to use?
- Discord vs Slack vs Telegram - client preference for real-time?
