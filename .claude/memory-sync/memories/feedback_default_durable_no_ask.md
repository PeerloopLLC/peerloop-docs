---
name: Default to durable without asking — multi-conv scope counter-case + Conv 131 incident
description: Primary rule lives in CLAUDE.md (§Solution Quality + §Critical Rule). This file retains the multi-conv-scope counter-case and the Conv 131 TDS-AUTH precedent.
type: feedback
originSessionId: b81cfd2e-9614-44bb-b04d-776097b6e4fb
---
**Primary rule is in CLAUDE.md** — see §Solution Quality (default to durable, proceed without approval) and §Critical Rule's Threshold subsection (size of the change ≠ novelty; a substantial rewrite that follows an established pattern still doesn't need check-in).

**Counter-case retained here (not in CLAUDE.md):**

- **Multi-conv scope** — when the "durable" path would span multiple convs (i.e., this conv won't finish what's started), pause and present the scope tradeoff before committing. The user may prefer a smaller-but-completable durable cut, or may want to scope a separate conv for the larger version.
- (Other counter-cases — novel architectural decisions and irreversible-destructive actions — are covered by CLAUDE.md §Critical Rule and the global §Executing actions with care directives respectively.)

**Conv 131 TDS-AUTH (canonical incident):** Presented auth-libraries.md rewrite as substantial, asked user to choose. User corrected: *"Remember the durable preference when choices are shown. In this case durable = substantial rewrite."* This is the precedent that prompted the "size ≠ novelty" clarification now in CLAUDE.md.
