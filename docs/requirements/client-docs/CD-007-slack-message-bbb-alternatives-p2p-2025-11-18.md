# CD-007: Slack Message - BBB Alternatives & P2P Video Research

**Source:** Slack message from client
**Date:** 2025-11-18
**Added:** 2025-11-30

---

## Original Message

> Doing some preliminary research on BBB alternatives, it seems to make a difference in cost and efficiency if video conferencing is one on one.
>
> For a 1:1 (one-to-one) use case, your requirements change significantly from a standard conferencing setup. The most important technical factor for you is Peer-to-Peer (P2P) architecture.
> In a P2P call, video data travels directly between the two users' devices, bypassing the expensive video servers (SFUs) entirely. This results in lower latency, higher security, and significantly lower costs.
> Here is the best choice for your specific needs, broken down by how much code you want to write:
>
> **The Best "Low Code" Choice: Digital Samba**
> If you want the easiest integration (an iframe you drop into your site) without the strict time limits of competitors, this is your winner.
> Why it wins for 1:1: Unlike Whereby, which recently imposed a strict 30-minute time limit on all free calls[1, 2], Digital Samba offers unlimited duration for calls on their free plan (up to the monthly cap).
> The Free Tier: You get 10,000 participant minutes per month for free. For 1:1 calls, this equals roughly 83 hours of conversation per month (10,000 mins ÷ 2 people), which is huge for a free tier.[3, 4]
> Features: It comes with the "Zoom-like" UI pre-built (screen sharing, chat, settings), so you don't have to build anything.
>
> **The Best "Developer" Choice: Daily.co**
> If you want to build the UI into your app (using an SDK) rather than using an iframe, Daily.co is the strongest technical choice for 1:1.
> Why it wins for 1:1: Daily supports automatic P2P switching.[5, 6] When a call has only two people, it routes the video Peer-to-Peer (high quality, low latency, low server cost). If a third person joins, it seamlessly switches to the server (SFU) mode. Many competitors route everything through their servers, which is inefficient for 1:1.
> Pricing: Like Digital Samba, they offer 10,000 free minutes per month.
> Integration: They offer a "Prebuilt" overlay that is very easy to add, but you still have full control via their API if you need it later.
>
> **The "Cheapest at Scale" Choice: VideoSDK.live**
> If you plan to scale beyond the free tiers and price is your absolute priority.
> Why it wins: Their video pricing is $0.003 per minute, which is lower than the industry standard of $0.004 (Daily/Dyte).
> Audio-Only Savings: If your users often turn off their video, VideoSDK.live charges significantly less for audio-only minutes ($0.0006/min).
>
> **Summary Recommendation**
> Choose Digital Samba if you want to finish the integration today and don't want to write UI code.
> Choose Daily.co if you want a professional SDK that handles 1:1 traffic intelligently (P2P) and gives you 10,000 free minutes.

---

## Summary for SPECS.md

Client research on video conferencing alternatives to BBB, specifically optimized for 1:1 peer tutoring sessions.

**Key elements for SPECS.md:**

- **P2P Architecture Insight:** For 1:1 sessions, Peer-to-Peer architecture is critical
  - Video data travels directly between devices
  - Bypasses expensive SFU (Selective Forwarding Unit) servers
  - Benefits: Lower latency, higher security, significantly lower costs

- **Three Options Evaluated:**

  | Service | Best For | Free Tier | Key Feature |
  |---------|----------|-----------|-------------|
  | Digital Samba | Low code (iframe) | 10,000 mins/mo (~83 hrs 1:1) | Pre-built Zoom-like UI |
  | Daily.co | Developer SDK | 10,000 mins/mo | Auto P2P switching for 1:1 |
  | VideoSDK.live | Scale/cost priority | N/A | $0.003/min (below industry $0.004) |

- **Daily.co Highlighted Feature:** Automatic P2P switching
  - 2 people → P2P mode (efficient)
  - 3+ people → SFU mode (seamless switch)
  - Many competitors always use SFU (inefficient for 1:1)

- **Whereby Warning:** Recently imposed 30-minute limit on free calls (avoid)

- **Client Recommendations:**
  - Digital Samba: Quick integration, no UI code
  - Daily.co: Professional SDK with intelligent P2P handling

**Technical Implications:**
- 1:1 tutoring sessions benefit from P2P-optimized solutions
- May reconsider BBB if primarily 1:1 sessions (P2P alternatives more cost-effective)
- Daily.co offers best developer experience with automatic optimization
- Digital Samba offers fastest time-to-market

**Relationship to Other Docs:**
- **Potentially supersedes CD-006's BBB preference** for 1:1 use case
- Aligns with CD-006's cost-consciousness (avoiding per-user fees)
- **Chronology:** Nov 18 - after CD-006 (Nov 16), before CD-002 (Nov 29)
- CD-002 still mentions BBB - may be for group sessions vs 1:1

**Open Questions:**
- Does client prefer Daily.co or Digital Samba?
- BBB for groups, P2P solution for 1:1? Or single solution for all?
- Does CD-002's BBB mention (Nov 29) override this research, or coexist?
