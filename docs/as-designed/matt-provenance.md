# Matt Provenance & Cutover

**Status:** Design settled Conv 195 (discussion). Not yet implemented. Tracked in PLAN.md: **MATT-CUTOVER**.

**Companions:** `matt-design-system.md` (the design system spec), `matt-pre-plan.md` (route map + file structure), `url-routing.md` (routing — updated by the flip).

---

## 1. The problem

Matt is actively designing in Figma, but it is **certain he will not draw all 70+ pages**. The
pages he doesn't draw become **Claude-built Matt-equivalents** — built in his style, but authored
by us. It is equally certain that **some of what we build in the next few days, Matt will later
redraw**. When he does, two sources exist for the same primitive/component/page, and we need to
know which one is authoritative ("whose is in use") without it becoming a mess.

## 2. Two orthogonal axes (do not conflate)

The mess comes from conflating two independent questions. Keep them separate:

| Axis | Question | How it's encoded |
|------|----------|------------------|
| **Domain** | Is this part of the new design system, or the doomed legacy app? | **Structural** — route/layout tree (`/` vs `/old/*` after the flip). Free; no marker. |
| **Authorship** | Within the design system, did **Matt draw** this or did **Claude build** it? | **Explicit marker** — `@matt-source`. This is the collision axis. |

Only **authorship** causes collisions, and it is the one axis structure *cannot* encode — because
authorship is mixed *within* the design-system layer by definition (Matt won't draw everything). A
folder or route prefix is great at the domain axis and useless at the authorship axis. That is the
irreducible reason a marker must exist.

## 3. Decisions (settled Conv 195)

1. **`@matt-source` attribution everywhere.** Every Matt-authoritative artifact (component, token,
   icon) carries an explicit `@matt-source <figma-node>` marker, applied exhaustively across all
   artifact types. **Unmarked (within the design-system layer) = ours** (Claude-built
   Matt-equivalent). The marker is the *sole* authorship signal — provenance does **not** rely on
   folder/path, because the namespace is about to dissolve (decision 2).

2. **Full namespace dissolve in the routing flip.** After today's demo (2026-05-26), flip the
   routing so the Matt design system becomes the primary app and legacy is demoted:
   - `src/pages/matt/*` → `src/pages/*` (Matt becomes `/`)
   - legacy `src/pages/*` → `src/pages/old/*` (legacy becomes `/old/*`)
   - `src/components/matt/*` → `src/components/*` (the `matt/` namespace disappears)

   Astro uses file-based routing, so the flip is a **physical file move**, not a config tweak.

3. **Lifecycle is structural, not marked.** `/old/*` self-documents "throwaway / will be replaced."
   No per-shim marker on legacy CSS workarounds — the route prefix says it all. The demo-usability
   CSS hacks on legacy pages die with their pages on conversion.

4. **Mark before flip (sequencing).** Run the exhaustive `@matt-source` pass *while the `matt/`
   folder still exists*. The folder is a free audit aid: everything under it is in-domain, so the
   marking pass only has to answer the easy question "which of these did Matt draw?" Once the flip
   dissolves the namespace, the markers become the *only* way to recover provenance. Marking after
   the flip means reconstructing provenance with no folder to lean on.

5. **Legacy prefix = `/old`, no fallback redirects (Conv 195).** Legacy lands at `/old/*`
   (supersedes the earlier `/fraser/` naming once documented in `url-routing.md` §8). Because this
   is **not a production app**, the flip needs **no redirect/middleware layer**: the ~72 legacy
   routes Matt hasn't rebuilt simply 404 at root after the flip; their copies live at `/old/*`.
   This is why [ROUTE-FLIP] is a pure file-move + link-rewrite (see §8 checklist).

## 4. The marker

Format: `@matt-source <nodeId>` (optionally `<fileKey>?node-id=<nodeId>` when cross-file). The node
ref is load-bearing — it makes the claim **verifiable** (re-probe the Figma node) and is the anchor
the detection sweep keys off. A bare boolean would not be re-probeable.

Placement by artifact type (exact syntax finalized when the marking pass starts):

- **Components** (`.tsx` / `.astro`): file header block, e.g. `/** @matt-source 597:6504 */`.
- **Tokens** (CSS): comment on the block or token, e.g. `--pastel-green: #E8F4DF; /* @matt-source 477:8502 */`. Extends the existing free-text provenance comments already in `tokens-*.css` ("Matt-verified" / "Speculative").
- **Icons** (bulk-harvested SVGs): a registry/index table mapping icon name → source node is more practical than per-SVG comments. The 10 Material-harvested nav icons (`menu`, `search`, `admin-panel-settings`, `chevron-right`, `group`, `label`, `assignment`, `videocam`, `warning`, `person-add`) are *not* Matt-authored → they stay **unmarked** (= ours). **`[PROV]` sub-task:** these currently sit in `src/components/matt/icons/svg/` mixed with Matt's ~43, with **no record distinguishing them** — the marking pass must capture that distinction (the icon-folder colocation case).

**Unmarked = ours.** Within shared files (e.g. ours + Matt tokens colocated in `tokens-primitives.css`),
the exhaustive marking pass makes omission reliable; the existing "Speculative (Conv 172)" prose
blocks remain as belt-and-suspenders for the colocated ours-items.

## 5. Reconciliation = the flip event, in miniature

When Matt later redraws one of our Claude-built equivalents, we re-translate from his Figma node and
**add** the `@matt-source` marker. The act of adding the marker *is* the reconciliation event, and
the **git diff that adds it is the audit trail** — no separate log of "this became authoritative on
Conv N" is needed. Provenance history falls out of version control.

## 6. Detection (later workstream)

A collision = "Matt drew a Figma node whose name matches an existing **unmarked** design-system
primitive." A sweep:

1. Greps `@matt-source` markers + enumerates unmarked design-system primitives.
2. Probes Matt's Figma Components/pages node names (Figma MCP).
3. Flags any name-match against an unmarked primitive → "Matt now has X; reconcile."

Wires into the existing `[FIGMA-MCP-DOC-HARVEST]` / `[ASSET-SWEEP-GATE]` infra. The sweep only ever
watches the design-system (primary) tree — `/old/*` never collides; it's just retired.

**Phase 6 extrapolation = unmarked, by design.** `[MATT-EXEC-EXT]` (Phase 6) builds primitives Matt
never drew — form-input variants, skeleton loader, modal frame, empty-state slot, status pills. These
are Claude-built extrapolations, so they carry **no** `@matt-source` marker. That's correct, not an
omission: their unmarked state *is* their provenance ("ours, extrapolated"). They are prime collision
candidates if Matt later draws his own versions (§6). Do not retrofit markers onto them.

## 7. Open implementation details

- Exact marker syntax per artifact type (§4) — settle at the start of the marking pass.
- Whether colocated ours-items get an explicit negative marker (`@matt-source none`) or rely on the
  exhaustive-pass + Speculative-prose convention. Leaning on the latter.
- Layout-name collision (see §8 step 3) — pick the rename strategy at execution.

## 8. ROUTE-FLIP execution checklist

The flip (`[ROUTE-FLIP]`) is a pure **file-move + link-rewrite** — no redirect/middleware layer
(decision 5). Blast radius mapped Conv 195 (225 `/matt` URLs across 29 files; 83 `@components/matt/*`
imports; ~13 Matt routes; ~85 legacy pages). Execute in this order:

1. **Move legacy out first** — `src/pages/*` → `src/pages/old/*`, **excluding `src/pages/api/`** (the
   42 API dirs stay at `/api/`) and `404.astro` (stays at root). Doing this first frees `index.astro`
   and other names for the incoming Matt pages.
2. **Move Matt pages in** — `src/pages/matt/*` → `src/pages/*` (the ~13 routes become root).
3. **Resolve the layout collision** — `src/layouts/matt/AppLayout.astro` would overwrite the existing
   legacy `src/layouts/AppLayout.astro`. Rename the legacy one (the repo already has a
   `LegacyAppLayout.astro` convention) or keep Matt's under a distinct name. Decide at execution.
4. **Dissolve the component namespace** — `src/components/matt/*` → `src/components/*` (subdirs
   `brand/ chat/ course/ entity/ icons/ ui/` stay); rewrite the 83 `@components/matt/...` imports → `@components/...`.
5. **Rewrite hardcoded URLs** — the 225 `/matt` references → bare paths; update route-matching
   conditionals (`ControlBar`, `MainNav`: `'/matt/'` → `'/'`) and the `[...tab].astro` redirect
   (`/matt/course` → `/course`).
6. **Remove the 2 demo bridges** — AppNavbar "New Design" link and Sidebar "Classic App" link (Conv
   191 TEMP markers); they become circular after the flip.
7. **Regenerate the route map** — `cd ../Peerloop && node scripts/route-api-map.mjs` (auto-discovers
   the new file layout; no manual edit of `route-map.generated.ts`).
8. **Update docs** — this file, `url-routing.md`, `matt-pre-plan.md` route map.
9. **Run all 5 baseline gates** (tsc / astro check / lint / test / build).
