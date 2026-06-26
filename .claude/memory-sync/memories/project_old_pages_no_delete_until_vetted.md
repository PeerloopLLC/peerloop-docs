---
name: project_old_pages_no_delete_until_vetted
description: "RTMIG-4 /old policy — REVISED Conv 250: ports MOVE /old/* → root as @stand-in (not copy); /old is NOT retained live; behavioral reference = preflip worktree + git history; rollback = git revert. Supersedes the Conv-221 keep-/old-live-until-vetted rule. Deletion scope CORRECTED Conv 338 (not '44 deletable' — 74 /old pages need per-page vetting; SoT = route-migration README ledger)."
metadata: 
  node_type: memory
  type: project
  originSessionId: 11104546-6032-4a4a-a1ed-d74060187c89
---

**REVISED Conv 250 (supersedes the original Conv-221 keep-/old-live rule below).**

During the `/old`→root migration ([RTMIG-4]), porting a route now **MOVES** the legacy
file `/old/X` → `/X`, marks it `@stand-in`, and commits that move as the page's
legacy baseline. The `/old` copy is **not** kept. When the route is later retrofitted
`@stand-in → @matt-inspired`, it is edited **in place** at `/X`.

**Why the reversal (Conv 250).** The original rule kept `/old` live for two purposes:
(1) a behavioral/functional reference while porting, and (2) a live, client-reachable
production rollback. Both eroded:
- **Matt phase-out (Conv 239)** ended faithful-port-to-Matt-frame; pages are now our
  own `@matt-inspired` redesigns decided function-first.
- The **preflip worktree** ([[project_preflip_worktree_reference]], `peerloop-ref` →
  `~/projects/Peerloop-preflip` on :4331) is a *better* behavioral reference than
  `/old` — the actual running pre-flip app — and **git history** holds the exact file
  at any commit.
- `/old/*` is in practice **unreachable** anyway (nothing links to it; e.g. the whole
  admin console already deep-links to `/admin/*`, not `/old/admin/*`), so it served
  neither purpose live.
- Examining legacy code in the **live repo** (the moved `@stand-in`, or `/old` pre-move)
  beats the worktree for *implementation*: same tree, zero setup, imports resolve to
  *current* shared components/APIs. The worktree's stale-import snapshot is for
  *runtime observation*, not code archaeology. So the legacy code must stay in the live
  repo at port time — which the MOVE guarantees (it rides to the target as the stand-in).

**How to apply:**
- Port = `git mv /old/X → /X` + add `@stand-in` marker + commit (the baseline). Later:
  retrofit in place, diff the port against the move-commit baseline field-by-field
  (the "no dropped behavior" gate, see [[feedback_port_functionality_and_styling]]),
  flip marker to `@matt-inspired`, verify.
- **Keep the preflip worktree alive** as the behavioral backstop — `[PREFLIP-WT]`
  re-scoped from "tear down when RTMIG-4 done" to "keep until client-vetting complete."
- Rollback if a port regresses = `git revert` (not a live `/old` page).
- **`/old` deletion scope — CORRECTED Conv 338 (the carried "44 deletable copies" figure
  was wrong).** Verified: **74** `/old/*` page files exist; only **12** have an exact root
  twin; the other 62 are a mix of restructured-path ports (`/old/dashboard` →
  `/creating`+`/teaching`; `/old/feed`+`/old/feeds` → `/`), deliberate old-vs-new
  comparison-keeps, and **parked RG-PUBLIC marketing pages that are the ONLY copy (must NOT
  delete)** — exact-path matching can't classify them, each needs per-page vetting. The
  carried "dead components" list was also wrong (`FeedAllTab`/`FeedRoleTab` are LIVE via
  `ExploreFeeds` ← `/old/discover/feeds.astro`; component cleanup is coupled to page cleanup).
  Authoritative corrected scope + recovery convention (git history + commit `608346a2`, **no
  archive folder**) + the deletion ledger now live in `plan/route-migration/README.md`
  § OLD-PORTED-CLEANUP. Conv 338 deleted only the 2 proven 0-importer orphans (`HomeFeed`,
  `UserCardCompact`); the rest is deferred per-page work.
- Still distinct from deleting fake-demo *stub* pages (Conv 203) — see
  [[project_route_404_honesty_standin]].

---

**ORIGINAL rule (Conv 221, now superseded — kept for provenance):** never delete an
`/old/*` page until **every** page was converted AND client-vetted; "retire" meant
repoint hrefs only, leave `/old` live as reference/fallback; bulk deletion was a single
end-of-migration step. User directive, emphatic: *"I do not ever want them deleted until
all of the pages are converted and vetted by the client."* Reversed Conv 250 on the
reasoning above (the keep-alive value collapsed once Matt left and the preflip worktree
+ git history covered the reference role).

Related: [[project_route_404_honesty_standin]], [[project_preflip_worktree_reference]], [[project_matt_phaseout_inspired_default]], [[feedback_port_functionality_and_styling]].
