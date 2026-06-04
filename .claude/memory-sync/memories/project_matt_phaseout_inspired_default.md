---
name: project_matt_phaseout_inspired_default
description: "Matt is being phased out; pages now default to @matt-inspired decided page-by-page (function first, then drape Matt style); never lose /old functionality"
metadata: 
  node_type: memory
  type: project
  originSessionId: f09632c8-2bdc-4d57-966c-ed211ff784ad
---

**Strategic pivot (Conv 239):** The client is **phasing out Matt's involvement** (he has too much to do under the time constraints). Consequence for our work:

- Matt's designs are now **"nice-to-have."** We **prefer his style when a frame exists** for a specific page, but the default posture flips: **most pages become `@matt-inspired`, decided page-by-page.**
- **Function-first ordering:** for each page we decide **what the page is functionally FIRST**, then **drape Matt's style onto it** — not the other way around. A Matt frame no longer dictates scope; it's an aesthetic layer applied to a functional decision we own.
- **Non-negotiable floor:** **never lose `/old/*` functionality.** When a Matt frame is a redesign that omits working behavior (e.g. `/session/[id]`: Matt's `622:17884` "Session Prepare" shows checklist/notes/chat but omits the join/rate/cancel state machine), **merge** — keep 100% of legacy function, adopt Matt's style + net-new surfaces, and **use static data for anything we have no schema for** (CREATOR_STATIC precedent). Then revisit.

**Why:** Matt's frames stop arriving; treating them as hard specs would block the migration. The migration must finish on Peerloop's own functional terms, with Matt's design language as a preferred-but-optional skin.

**How to apply:** Don't stop a page port waiting for a Matt frame, and don't drop legacy behavior to match a Matt redesign. Decide the page's function, port it faithfully ([[feedback_port_functionality_and_styling]]), then apply Matt tokens/primitives. Mark `@matt-inspired` (no 1:1 source) unless a faithful `@matt-source` frame was actually mirrored. Net-new Matt surfaces with no backend → static/scaffold, flag for a later schema decision. Supersedes the old "WE produce specs from Figma probes" dependence in [[project_matt_collaboration_style]] for execution sequencing. First case: [SESS-GRAD] /session/[id] merge, Conv 239.
