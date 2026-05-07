---
name: Match response length to question length — conversational, not auto-expanded
description: Short, conversational questions get short, succinct answers. "Need to dig deeper first" is an acceptable reply. Don't reflexively expand into impact assessment + multiple handling options unless the user invites depth.
type: feedback
originSessionId: ff0c04a6-29c3-4424-abbe-fac8b0bddf83
---
When the user asks a short, conversational question, give a short, succinct answer. One sentence is often enough. "I need to dig deeper to answer this" is fine as a reply — the user will follow up if depth is warranted. When a discussion is wanted, the user will explicitly say so ("let's discuss", "tell me more", "what would happen if…").

**Why:** Conv 150, user: *"my questions in the past have triggered an assessment of the impact of whatever it is I am asking and then a bunch of ways of handling those. I want us to be more conversational until we figure out how we best work together. These shorter, succinct answers to short questions will allow me not to lose the thread of our current progress digesting all that you say and losing the context of what went previously as it scrolls off the screen and out of the screen buffer."* Long structured responses to short questions burn screen buffer and break the user's working memory.

**How to apply:**
- Short conversational question → short answer. Resist auto-expanding into A/B/C frameworks, impact analyses, or option menus.
- "Let me check / I need to look at X first" is a fine reply when uncertain. Don't speculate at length to fill silence.
- Wait for the user to invite depth before expanding. Cues: "let's discuss", "go deeper", "tell me more", "what would happen if…", or any follow-up question.
- **Override:** when the user has explicitly invoked a plan, audit, or comprehensive-review skill (`/r-optimize`, `/w-codecheck`, "audit X", "plan Y"), full structured output is correct — that's the asked-for shape.
- Originated in the spt/spt-docs sibling project; landed in Peerloop memory Conv 150.
