---
name: project_route_404_honesty_standin
description: Route-migration rule — unconverted pages must 404 (no resolving placeholder stubs); @stand-in marker for transient legacy rehosts
metadata: 
  node_type: memory
  type: project
  originSessionId: 9a2d9695-6218-488e-801e-56d3efb759d1
---

During the `/old`→root migration there is **no redirect layer**: links to
not-yet-converted pages must **404 honestly**. Do NOT create or keep placeholder
pages that *resolve* to fake/demo content — a 404 is the RTMIG verification signal
that a route still needs work. Stub + convert each page only when its migration
turn comes (the per-page loop in [RTMIG-4]).

**Why:** A resolving placeholder hides the gap (looks done, isn't) and breaks the
"unbuilt routes 404 by design" honesty the whole migration relies on. Conv 203
incident: the rebuilt Home inherited a live link to `/messages`, which still
resolved to a Conv-193 demo-thread stub → user: delete it so the link 404s.

**How to apply:**
- New Matt pages may link to routes that don't exist yet — that's fine, those
  links 404 until conversion. Don't "fix" them by building resolving stubs.
- Delete fake-demo stub pages so their links 404 (Conv 203 removed `/saved`,
  `/todo`, `/teachers` index, `/earnings`, `/notifications`, `/messages`).
- Functional real-data pages (e.g. `/courses`, `/course/[slug]/*`,
  `/teachers/[handle]`) and converted auth-flow pages stay.

**`@stand-in` marker (Conv 203):** a TRANSIENT header marker on pages that rehost
legacy functionality in the Matt shell but aren't yet a proper Matt design —
NOT `@matt-source` (Matt) and NOT an ours/extrapolation primitive. A 3rd class
that exists ONLY until the page is retrofitted to Matt-style ([STANDIN-MATT] task),
then removed. Deliberately NOT formalized in matt-provenance.md / prov-sweep
because it's transient (and its text avoids "UNMARKED" so it won't trip the
prov-sweep note check). Enumerate with `grep -rl '@stand-in' src/pages`.

Established Conv 203 (2026-05-27). Related: [[project_preflip_worktree_reference]].
