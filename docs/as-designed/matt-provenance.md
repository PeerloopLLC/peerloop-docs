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

## 6. Detection

A collision = "Matt drew a Figma node whose name matches an existing **unmarked** design-system
primitive." A sweep:

1. Greps `@matt-source` markers + enumerates unmarked design-system primitives.
2. Probes Matt's Figma Components/pages node names (Figma MCP).
3. Flags any name-match against an unmarked primitive → "Matt now has X; reconcile."

Wires into the existing `[FIGMA-MCP-DOC-HARVEST]` / `[ASSET-SWEEP-GATE]` infra. The sweep only ever
watches the design-system (primary) tree — `/old/*` never collides; it's just retired.

### 6a. Implementation — local half built (Conv 199, `[PROV-SWEEP]`)

The sweep splits along a hard line: **what's deterministic locally** vs **what needs Figma**.

- **Local half — BUILT.** `scripts/prov-sweep.ts` (run via `npm run prov:sweep`, tsx). It derives
  the marked set by grepping `@matt-source`, reads the icon registry (`icon-provenance.ts`) and the
  component/token candidate registry (`scripts/prov-candidates.ts`), validates the provenance
  bookkeeping for drift, and **emits the collision-candidate manifest** — the exact list of semantic
  names step 2 must probe Matt's Figma for. Exit 0 = consistent, exit 1 = drift/error (gate-ready).
  - **Drift checks:** SVG↔registry bijection; each component candidate still exists + still unmarked
    (a candidate that *gained* a marker = `RECONCILED` → drop it from the registry); a stray
    `Provenance: UNMARKED` note on a non-registered file = `UNTRACKED` → classify it; token candidate
    still present in its CSS. Both drift branches calibrated (proven to fire) Conv 199.
  - **Marker accept-rule:** a real marker is `@matt-source` + a node-shaped ref (`\d+:\d+`), NOT just
    any token. This keeps PROSE mentions of the convention (e.g. `icon-provenance.ts`'s own header,
    the §9 `Provenance:` notes) out of the count — tightening the accept-condition, not enumerating
    reject-conditions, is the robust fix for the §9 grep-pollution class.

- **The candidate registry can't be auto-derived (post-flip).** The route flip dissolved the
  `matt/` namespace, so `src/components/*` now co-mingles design-system primitives with legacy app
  components, and only *pages* got the `/old/*` domain split — not components. So "unmarked
  design-system primitive" is an **explicit enumeration** (`scripts/prov-candidates.ts`: the 9
  unmarked components + speculative tokens + Phase-6 extrapolations as they land), not a directory
  walk. Icon candidates stay in `icon-provenance.ts` (`source: 'ours'`); the sweep imports both.

- **Figma half — deferred (agent step, not scriptable here).** Step 2 is an MCP/agent probe, and the
  harvest infra it wires into (`[FIGMA-MCP-DOC-HARVEST]` / `[ASSET-SWEEP-GATE]`) doesn't exist yet.
  `prov:sweep` produces that step's *input*; running the probe + matching is a separate workstream.
  `RoleTabBar` is the standout live candidate — `[RTB]` already tracks Matt designing a Role Tab Bar.

**Phase 6 extrapolation = unmarked, by design.** `[MATT-EXEC-EXT]` (Phase 6) builds primitives Matt
never drew — form-input variants, skeleton loader, modal frame, empty-state slot, status pills. These
are Claude-built extrapolations, so they carry **no** `@matt-source` marker. That's correct, not an
omission: their unmarked state *is* their provenance ("ours, extrapolated"). They are prime collision
candidates if Matt later draws his own versions (§6). Do not retrofit markers onto them.

## 7. Open implementation details

- ~~Exact marker syntax per artifact type (§4)~~ — **SETTLED [PROV] Conv 197.** Components:
  `* @matt-source <node>` as the last line of the file-header comment block. Tokens: same line on
  the relevant `:root` sub-block comment. Icons: a registry (`icon-provenance.ts` + `_INDEX.md`),
  not per-SVG comments. See §9.
- ~~Whether colocated ours-items get an explicit negative marker (`@matt-source none`)~~ —
  **SETTLED [PROV] Conv 197:** no negative marker. Unmarked = ours, made reliable by the exhaustive
  pass + retained "Speculative" prose. Files that are ours but reference a Matt node for visual
  context get a plain-English `Provenance: UNMARKED = ours` note (NOT the `@matt-source` token,
  which would pollute the §6 grep — see the SubNav incident in §9).
- Layout-name collision (see §8 step 3) — pick the rename strategy at execution ([ROUTE-FLIP], unchanged).

## 8. ROUTE-FLIP execution checklist

> **✅ EXECUTED Conv 197** (after the 2026-05-26 demo). Actuals vs the Conv-195 estimate:
> 43 legacy top-level entries → `src/pages/old/`; 9 Matt page routes → root; 83 `@components/matt/*`
> imports rewritten (17 files); 139 `/matt` URL/comment refs resolved; layout collision settled by
> moving legacy `AppLayout.astro` → `layouts/old/` (61 refs) and promoting Matt's to `layouts/AppLayout.astro`
> (9 refs). **Key enabler:** every page imports via `@`-aliases (zero relative `../` page imports), so the
> file moves needed no per-page import surgery — only the layout/component *targets* and `/matt` literals.
> All 5 gates green (tsc / astro check 0/0/0 / lint / build 6.3s / 6453 tests). Route map regenerated.

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

## 9. PROV execution record (Conv 197)

The exhaustive `@matt-source` pass ran Conv 197, before the flip (per decision 4). Results:

**Components (`src/components/matt/`, 44 files):**
- **35 marked** Matt-authoritative — each `@matt-source <node>` added to the file-header comment,
  formalizing the free-text Figma citation 38 of them already carried.
- **9 unmarked = ours:** `ControlBar.tsx`, `HeaderBar.astro`, `icons/MattIcon.tsx`, `RoleTabBar.tsx`,
  `SubNav.astro`, `ui/Card.astro`, `ui/SectionTitle.astro`, `ui/IconLabelChip.tsx`, `ui/_SocialPostDemo.tsx`.
  Three of these (SubNav container, IconLabelChip, _SocialPostDemo) reference a Matt node for visual
  context but are Claude-built — they carry a plain-English `Provenance: UNMARKED = ours` note.
  - 🔎 **Grep-pollution gotcha:** a `Provenance` note must NOT contain the literal `@matt-source`
    token (it would be counted as a marker by §6). SubNav initially did; reworded to "Figma node …".
    The §6 sweep should additionally anchor on `@matt-source` at the start of a comment line.

**Tokens (`src/styles/`):**
- `tokens-primitives.css` — color block marked `@matt-source 477:8502` (13 Matt-verified). Speculative
  `--alert-light` / `--carmine-red` stay unmarked.
- `tokens-typography.css` — Body blocks `@matt-source 40:485`, Headers block `@matt-source 40:493`.
- `tokens-semantic.css` — color-semantics + entity blocks `@matt-source 40:484`; button-variant block
  `@matt-source 40:482`. Speculative `--Alert-*` stay unmarked. (Nodes recovered by live Figma re-probe
  per the Conv 197 decision — Variable Collections aren't node-anchored, so we cite a *consuming* node
  where `get_variable_defs` returns the semantics, the same convention used for primitives/typography.)
- Scaffolded scales (spacing/radius/shadow/etc.) stay unmarked: the scale is ours (Token Scaffolding
  Policy, Conv 172) even where a few values coincide with Matt's measurements, and no node is recorded.
- `tokens-tailwind-bridge.css` — unmarked: it is a re-export adapter (ours); provenance lives in the
  primitives/typography it bridges.

**Icons (`src/components/matt/icons/svg/`, 53 SVGs):** provenance externalized to a registry —
`icon-provenance.ts` (canonical, machine-readable for §6) + `_INDEX.md` (human view). 39 `matt-catalogue`
(own symbol node), 2 `matt-embedded`, 12 `ours` (unmarked).

**Model refinement — the `matt-embedded` class.** Icons forced a third authorship value the
two-class model (§2) didn't name. A Material-sourced glyph's provenance is decided by **curation, not
drawing**: `stars_2` / `accessibility_new` are Material icons, but Matt placed them in his Social Post
frame → Matt-authoritative (cite his frame node). The 10 Conv-193 NAV-ICON-SWAP Material icons +
`chevrons-left` + `folder` were picked by *us* → ours. Same Material origin, opposite provenance. This
is consistent with §3 decision 1 (the marker, not the pixels' origin, is the authorship signal); the
registry's `source` field (`matt-catalogue` / `matt-embedded` / `ours`) records the distinction.

## 10. PROV-MATCH execution record (Conv 199 — first live Figma matching)

`[PROV-MATCH]` (the §6 step 2-3 Figma probe) was run manually Conv 199 against Matt's Components page
(`UpDNMiIEO8y3J7ZHkm356b` → `1:269`), matching the `prov:sweep` manifest's names against Matt's actual
node names. **Result: no confirmed collisions.** Every unmarked primitive stays ours.

- **Clean (no name-match):** `RoleTabBar` (Matt has NOT drawn a Role Tab Bar, despite `[RTB]`
  anticipating it), `ControlBar`, `HeaderBar`, `Card`, `IconLabelChip`, and all 12 `ours` icons.
- **Two exact name-matches, both NON-collisions** (the human-review step earned its keep):
  - `SectionTitle` matched Matt's "Section Title" component (`722:14801`, variants `WIP`/`Dev Ready`/
    `Archived`) — but that's his **design-file readiness-banner** system, not a product primitive.
  - `SubNav` matched two canvas **sections** named "Sub Nav" (`502:12864`, `622:18616`) — but those are
    Figma section containers, not a drawn SubNav-container component. Matt's drawn parts are "Sub Nav
    Item" (already marked `@494:11653`) + a new "Sub Nav Item With Sub nav" (`622:18618`).
- **Tokens:** no `Alert`/`Carmine` in Matt's variable namespace (probed `40:482`); no alert/form
  component exists in his file. Speculative tokens stay ours. (Caveat: MCP can't enumerate *all*
  local-file Variables — this is a representative-node negative + structural absence.)

**Refinement for automation (`[PROV-MATCH]` future):** every false positive was a **node-type
mismatch** — name collided with a Figma *section* or a *design-process status component*, not a
product *symbol/component*. The eventual automated matcher must filter on node type (`<section>` and
readiness-banner components out of the candidate pool), not name alone. Name-match is necessary, not
sufficient.

**Side findings (reverse direction — Matt has, we lack):** Matt's Icons section now has `checklist`
(`924:16952`); anchors reference `play_circle` (`319:10972`). Neither is in our 53-icon registry —
harvest gaps for `[HOWTOREG-ICN]` / `[PLAY-CIRCLE-ICN]`, not collisions.

## 11. Page-level provenance — the 3-marker convention (Conv 207)

Component-level provenance (§3–§4) is binary: `@matt-source` vs unmarked. **Pages need a
third class.** Pages are orchestrators — many will never have a Matt Figma source frame at all
(login, signup, onboarding, error pages, etc.), so the "unmarked = ours, Claude-extrapolated" rule
that works for components leaves no way to distinguish *legacy-rehost* pages awaiting retrofit from
*deliberately-built-in-Matt-style* pages. The 3-marker convention closes that gap.

### The three markers

Every non-legacy page (`.astro` or page-level `.tsx`) carries **exactly one** of these as a
top-of-file doc-comment:

| Marker | Meaning | Promotion path |
|--------|---------|----------------|
| `@stand-in` | Legacy-rehost page awaiting retrofit. Not Matt-designed, not built in Matt-style. Transient. | Retrofit → `@matt-inspired` (or `@matt-source` if a Figma frame lands). |
| `@matt-source <nodeId>` | 1:1 port from a specific Matt Figma frame. May list multiple nodeIds when composing several frames (e.g. `course/[slug]/[...tab].astro` lists 8). | Terminal — verifiable, sweep-anchor. |
| `@matt-inspired` | Built with Matt tokens/primitives/design language but no source Figma frame exists. | Promote to `@matt-source` if/when a Figma frame lands and is re-validated. |

**Unmarked = legacy.** A page in the design-system tree without one of these three markers belongs
to the doomed legacy app (`/old/*` after ROUTE-FLIP). `dev/*` pages opt out of the convention.

### Why three, not two

Component-level provenance only needs two classes because Phase-6 extrapolated components carry
*conceptual* status ("ours, extrapolated") — the unmarked component is *still* part of the design
system. Pages don't have that escape valve: an unmarked page is just unconverted legacy. So:

- Legacy-rehost pre-retrofit → `@stand-in` (transient, greppable, prompts the retrofit)
- Matt-designed → `@matt-source` (existing class, unchanged)
- Built-in-Matt-style without a Figma source → `@matt-inspired` (the new third class)

The third class makes "built from Matt's design language" greppable. When Matt later draws an
`@matt-inspired` page, the retrofit just upgrades the marker — no archaeology needed.

### Detection (extends §6)

`scripts/prov-sweep.ts` (originally a component sweep) extends to page-level. Both `@matt-inspired`
and `@matt-source` count as "marked"; `@stand-in` counts as an explicit "needs work" signal.
Unmarked pages in the design-system tree are an audit failure: every non-legacy page should declare
its class. Tracked: **`[PROV-SWEEP-MI]`** (teach the sweep about `@matt-inspired`).

### Examples (Convs 207–208)

- `src/pages/index.astro` — `@matt-inspired` (no source frame; built with Matt tokens + primitives)
- `src/pages/courses.astro` — `@matt-inspired`
- `src/pages/login.astro` / `signup.astro` / `onboarding.astro` — `@matt-inspired` (Conv 207
  retrofits via the 11 new form primitives)
- `src/pages/404.astro` — `@matt-inspired` (Conv 208 [STANDIN-404] promoted from `@stand-in`)
- `src/pages/course/[slug]/[...tab].astro` — `@matt-source` with 8 nodeIds (Conv 207)
- `src/pages/profile.astro` — `@stand-in` (Conv 207 backlog: `[STANDIN-MATT]` retrofit pending)

### Relationship to the Phase-6 extrapolation registry

Component-level extrapolations stay in `scripts/prov-candidates.ts` and carry **no** page marker
themselves — the page marker is a **page-level** declaration. A page composed entirely of
Phase-6-extrapolated components is still legitimately `@matt-inspired` (built with Matt's design
language). Marker scope is page-file granular.

### Origin

Established Conv 207 across the login/signup/onboarding retrofit pass. User-confirmed: *"those pages
that have none of those are legacy."* Codified Conv 208 [PROV-CODIFY]. Decision: `docs/DECISIONS.md`
§"3-Marker Page-Provenance Convention".
