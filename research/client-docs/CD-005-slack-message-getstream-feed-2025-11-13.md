# CD-005: Slack Message - GetStream Feed Discussion

**Source:** Slack message from client
**Date:** 2025-11-13
**Added:** 2025-11-30

---

## Original Message

> getstream.io Yes It helps build social media features into a site. I want to build an algorithmic feed into the site similar to x.com or skool.com or Substack.com. I see a need for users to gather in a common area and see relevant posts based on their interests. Specifically I want to use the feed option
>
> I am currently thinking of the minimum viable product. We need profiles, payments, and calendar options. We could use discord as a meeting place but that would need to be replaced by a x.com style feed into the near future.
>
> I really don't like the idea of discord but it would be ok for technical users who we will target initially. It would be much better to have the feed within the site

---

## Summary for SPECS.md

Client communication clarifying technology preferences and MVP priorities for the social feed component.

**Key elements for SPECS.md:**

- **Technology Decision:** GetStream.io confirmed as preferred solution for algorithmic feed
  - Specifically wants the "feed option" from GetStream
  - Target UX: X.com, Skool.com, Substack.com style feeds

- **MVP Requirements (confirmed priorities):**
  1. Profiles
  2. Payments
  3. Calendar options
  4. Algorithmic feed (interest-based content)

- **Discord Evaluation:**
  - Acceptable as temporary solution for initial technical users
  - Client explicitly states "I really don't like the idea of discord"
  - Must be replaced by in-site X.com-style feed "in the near future"
  - Discord is a compromise, not a preference

- **Feed Purpose:**
  - Common gathering area for users
  - Interest-based content relevance
  - Social media-style engagement pattern

**Technical Implications:**
- GetStream.io integration for activity feeds
- Interest/preference system for algorithmic content delivery
- Profile system must support feed interactions
- Calendar integration for scheduling
- Payment processing for transactions

**Relationship to Other Docs:**
- Reinforces CD-002's "Algorithmic X.com-Style Feed" requirement
- Provides specific technology choice (GetStream.io) vs CD-002's mention of Bluesky protocol
- **Note:** This message (Nov 13) predates CD-002 (Nov 29), so CD-002's Bluesky mention may supersede this GetStream preference - requires clarification

**Open Questions:**
- GetStream.io vs Bluesky protocol - which is current preference?
- Timeline for Discord replacement if used as interim solution
