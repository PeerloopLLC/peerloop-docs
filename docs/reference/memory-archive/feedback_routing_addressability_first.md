---
name: feedback-routing-addressability-first
description: "When resolving route-shape questions, the load-bearing decision is ADDRESSABILITY (does each screen need a jump-to / deep-link / redirect URL) — NOT page-count (one state-driven page vs separate files), which is a deferrable build-time detail"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: bdeef095-847f-4500-af55-60e3a0847dfd
---

When facing route-shape / "how should these screens map to routes" questions, decide **addressability** first — does each screen need a stable URL you can jump to, deep-link, or redirect to? Do NOT force a single-page-vs-multiple-pages implementation decision up front.

**Why:** Conv 187 [MATT-EXEC-FLAGS] — I presented the Matt flow route-shapes (Enroll funnel, Session lifecycle, Home variants) as "single state-driven page vs separate sub-routes" AskUserQuestion options. The user rejected it: "These can be implemented as pages and as a single page. What is more important is whether they need to have a route that can be jumped to if needed." Implementation (file count) is a build detail; addressability is the architecturally load-bearing fact.

**How to apply:** For each screen/flow, ask only: does anything need to *navigate directly* to it? Sources of a hard "yes": an external system that redirects to a URL (e.g. Stripe `success_url` → Enroll Success MUST be addressable), a notification/email deep-link (e.g. "pick your teacher" → Choose Teacher), an entity you reach by id (e.g. `/session/[id]` from a schedule click / calendar invite). A "no": transient confirmations and celebratory moments (Session Scheduled, Course Completed) — these become overlays/states. **Addressability ≠ separate files:** an addressable route can still be ONE state-driven page (e.g. `/session/[id]` renders Prepare/During/After from session status). So "needs a URL" and "how many files" are orthogonal — decide the first now, defer the second to build time. Resolved map lives in `.scratch/matt-frames-ready-for-dev.md` § Route Addressability. Related: [[project_matt_phaseout_inspired_default]], [[feedback_external_source_of_truth_first]].
