---
name: Favour durable decisions over faster options
description: Core operating principle — prefer encompassing, lasting solutions over convenient fixes; present both and lean durable when deciding
type: feedback
originSessionId: b22c0500-f9e7-4cd7-bfac-60bb1b739c21
---
**The operating principle (Conv 100, user's words):**

> "Favour durable decisions over faster options. I am less concerned about disruptions and more concerned about a stable outcome that survives. For the software we write, consider this question when supplying choices or deciding which way you are leaning: are we making a convenient 'fix' to expedite moving on with perhaps another aspect of the codebase, or should we opt for a more encompassing solution that will last? Ideally, the software should be characterized by a small number of overview directives that we adhere to for the most part and break when the reasons are sound."

**Why:** The user is building for production. Accumulated quick fixes create long-term debt and repeatedly revisit work. A stable outcome that survives is worth the disruption of doing it right the first time. This is a *guiding principle*, not a rule — it can be broken when the reasons are sound, but the default lean is toward durability.

**How to apply:**

1. When presenting options, always include **the most durable/rigorous option** alongside any quick fix. Show both the cost and the long-term payoff.
2. When the user asks "which is the durable option?" or "which do you lean toward?", **answer decisively** — recommend the durable choice and explain why. Don't hedge.
3. When you're about to propose a cast, a TODO comment, a band-aid, or a "defer this for later" — stop and ask whether the durable version is feasible within scope. If yes, propose it. If no, say so and explain the tradeoff.
4. **Signals that you're drifting toward the wrong answer:** "the simplest approach is...", "for now let's just...", "we can always fix this later", "as any", "TODO:", "leave as-is and file a follow-up".
5. **Signals that you're on the right track:** consolidating duplicated code while fixing it, reading upstream changelogs before bumping, refactoring adjacent smells, choosing one canonical call site, removing rather than adding conditional branches.
6. **Small number of overview directives:** lean on a few strong principles (durability, no silent failures, no dead code, no duplicated call sites) rather than a long ruleset. Break them only with explicit reasoning.

**Examples where this principle applied (Conv 100):**
- Stripe apiVersion pin: user chose to bump the pin + consolidate all 3 call sites to use `getStripe()`, instead of casting the old pin with `as any`. Reason: casts are invisible drift; pinning to an old version is debt, not stability.

**Examples where this went wrong (Conv 025):**
- Linking to `/messages?to=handle` instead of building an inline message form with pre-populated content
- Silently swallowing fetch errors in CourseTabs instead of surfacing them
- Not considering role-based auth implications of the complete endpoint until the user flagged it
