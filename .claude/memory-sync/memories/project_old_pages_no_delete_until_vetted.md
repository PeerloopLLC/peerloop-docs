---
name: project_old_pages_no_delete_until_vetted
description: "/old/* legacy pages are NEVER deleted until ALL pages converted AND client-vetted; \"retire\" = repoint hrefs only, leave /old live as reference/fallback"
metadata: 
  node_type: memory
  type: project
  originSessionId: 11104546-6032-4a4a-a1ed-d74060187c89
---

During the `/old`→root migration, **never delete an `/old/*` legacy page** until
**every** page has been converted to a Matt root page AND the client has vetted the
new pages. The `/old` tree is the trusted reference/fallback for the whole migration.

"Retire `/old/<x>`" in PLAN.md / DISC-DROP Stage 4 / the per-page loop means ONLY:
**repoint internal hrefs** (`/discover/communities` → `/communities`) so the app
navigates to the new root page. The `/old` page stays fully reachable at its `/old`
URL — it just stops being linked-to. Do NOT `rm` it.

**Why:** Pre-launch, the legacy app is the trusted baseline; the client compares new
vs old and signs off page-by-page. Deleting an `/old` page before the global
"all-converted + client-vetted" gate destroys the comparison reference and risks
silent functionality loss with no fallback. User directive, Conv 221, emphatic:
*"I do not ever want them deleted until all of the pages are converted and vetted by
the client."*

**How to apply:**
- Per-page conversion = build the Matt root page + repoint hrefs. STOP there. Never
  delete the `/old` page as part of the per-page loop.
- The bulk `/old` deletion is a SINGLE end-of-migration step, gated on all-converted
  + client-vetted — not part of [RTMIG-4]/[DISC-DROP] per-page work.
- Distinct from deleting fake-demo *stub* pages at root (Conv 203 — `/saved`, `/todo`,
  `/messages`, etc.): those were resolving placeholders, NOT `/old` legacy pages, and
  deleting them was correct. See [[project_route_404_honesty_standin]].

Related: [[project_route_404_honesty_standin]], [[project_preflip_worktree_reference]].
