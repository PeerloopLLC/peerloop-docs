---
name: No testing artifacts in production code
description: User prefers not to add dev-only testing infrastructure to the production codebase. Multi-user testing uses two browser vendors (e.g., Chrome + Safari) instead.
type: feedback
---

User does not want to burden the production codebase with testing artifacts. When multi-user simultaneous testing is needed (e.g., student in one tab, teacher in another, BBB sessions), use two different browser vendors (Chrome + Safari) which have fully independent cookies and localStorage. This was decided over a dev-mode impersonation/tab-isolation approach (Session 380, 2026-03-12).
