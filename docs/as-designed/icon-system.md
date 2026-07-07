# Icon System — Inventory & Namespace Reconciliation

**Last Updated:** 2026-07-06 (Conv 369 — [ICN-NS] audit; reconciliation deferred)
**Status:** 🔍 **AUDIT** — inventory + proposal complete; the canonical-system + naming-convention decision is **OPEN** (see §5). No renames executed.
**Related:** memory `reference_icon_system`, [matt-provenance.md](matt-provenance.md) §9, `../Peerloop/src/lib/icon-provenance.ts` (per-icon source), CURRENT-TASKS.md [ICN-NS]

---

## 1. Problem

Peerloop carries **four** coexisting icon systems with **three** naming conventions. The same glyph is frequently defined in two or three of them under different names, and — worse — some *identical kebab strings* resolve to *different glyphs* depending on which component consumes them. This doc inventories the systems and proposes a reconciliation. It does **not** execute renames: the canonical-system choice (§5) is a genuine architectural decision tied to the Matt design phase-out, so it needs an explicit call before hundreds of call sites are touched.

---

## 2. The four systems

| # | System | File | Convention | Count | Call sites | Role |
|---|--------|------|-----------|------:|-----------:|------|
| 1 | Astro path registry (`<Icon name=…>`) | `src/lib/icon-paths.ts` (+ `ui/Icon.astro`) | kebab string keys (`chevron-right`) | ~40 | **6** `<Icon>` sites | near-legacy |
| 2 | React icon components | `src/components/ui/icons.tsx` | `PascalCaseIcon` (`ChevronRightIcon`) | 108 | **175 importers** | dominant workhorse |
| 3 | React brand logos | `src/components/ui/brand-icons.tsx` | `PascalCaseLogo` (`GitHubLogo`) | 7 | brand chrome | — |
| 4 | Matt design icons (`<MattIcon name=…>`) | `src/components/icons/MattIcon.tsx` + `svg/*.svg` | kebab filenames (`chevron-right`) | 59 | ~10+ Matt components | design-system canonical direction |

- **System 4 source of truth** is the `svg/*.svg` directory — drop a file in and `import.meta.glob` auto-registers it under `<filename minus .svg>`; per-icon design provenance (`matt` / `matt-embedded` / ours) lives in `icon-provenance.ts` (see matt-provenance.md §9). Unknown names render a dashed placeholder.
- Full name lists are intentionally **not** duplicated here (they'd drift); enumerate from source:
  - System 1: object keys in `icon-paths.ts`
  - System 2/3: `grep -oE "export const [A-Za-z]+" ui/icons.tsx` / `ui/brand-icons.tsx`
  - System 4: `ls src/components/icons/svg/*.svg`

---

## 3. Collisions & duplication

### 3.1 Exact-name collisions — System 1 ↔ System 4 (same kebab string, different glyph)

Both `icon-paths.ts` and MattIcon use kebab keys, and these **10 names exist in both**, drawing *different* pictures (Heroicon-style outline vs Matt SVG):

`chevron-right` · `clock` · `feed` · `home` · `lock` · `menu` · `notifications` · `search` · `sparkles` · `warning`

No runtime clash (each is resolved by its own component — `<Icon>` vs `<MattIcon>`), but the shared string is a **readability/mental-model hazard**: `name="chevron-right"` means two different glyphs depending on the tag.

### 3.2 Brand-logo duplication — System 1 ↔ System 3

Three brands are defined in **both** registries:

| Brand | System 1 (`icon-paths.ts`) | System 3 (`brand-icons.tsx`) |
|-------|----------------------------|------------------------------|
| GitHub | `brand-github` | `GitHubLogo` |
| Twitter/X | `brand-twitter-bird` | `TwitterXLogo` |
| LinkedIn | `brand-linkedin-square` | `LinkedInLogo` |

System 3 additionally has `GoogleLogo` / `InstagramLogo` / `StripeLogo` / `YouTubeLogo` (no System-1 twin).

### 3.3 Concept triplication — Systems 1 + 2 + 4

Many glyph *concepts* are defined in all three general-icon systems (System 1 kebab, System 2 `PascalCaseIcon`, System 4 kebab SVG): `home`, `search`, `feed`, `lock`, `notifications`, `warning`, `sparkles`, `clock`, `menu`, plus near-twins `video`/`videocam`, `certificate`/`certification`, `courses`/`course`. Redundant maintenance surface; a restyle has to be applied up to three times.

### 3.4 What is **not** a fixable collision

- **Convention split is largely inherent.** React *components* are idiomatically `PascalCaseIcon`; string-keyed registries are idiomatically kebab. Forcing one convention across component-and-string-key worlds would fight the grain of each framework.
- **Suspected intra-`icons.tsx` dupes are real distinct glyphs.** `MoreIcon` (horizontal ⋯) ≠ `DotsVerticalIcon` (vertical ⋮). There is **no** free mechanical dedup sweep. (`CloseIcon` vs `XIcon` is the one unverified same-glyph suspect — 13 vs 2 importers.)

---

## 4. Usage weight (drives cost)

- **System 2 (`icons.tsx`)** — 175 importers. Renaming here is the expensive part; treat as the stable workhorse.
- **System 1 (`icon-paths.ts`)** — only **6** `<Icon>` call sites. Cheapest to retire; doing so alone erases collision categories §3.1 and §3.2.
- **System 4 (MattIcon)** — ~10+ Matt components; the stated design destination.
- **System 3 (brand-icons)** — 7 logos, self-contained.

---

## 5. Reconciliation options — **OPEN DECISION**

The core question: **which system is canonical**, and **what naming convention** do the string-keyed systems share? Candidate end-states:

- **Option A — MattIcon-canonical for design glyphs; `icons.tsx` stays the React workhorse; retire `icon-paths.ts`.** Aligns with the Matt phase-out (memory `project_matt_phaseout_inspired_default`). MattIcon becomes the single kebab registry; `icons.tsx` remains for React ergonomics but is reconciled *against* MattIcon names (a `FooIcon` component should map 1:1 to a MattIcon `foo`). Brand logos consolidate into `brand-icons.tsx` (retire System-1 `brand-*`).
- **Option B — `icons.tsx`-canonical (status quo weighted to usage).** Keep the 175-importer React system as the source of truth; MattIcon becomes a thin styling layer over the same concept set; retire `icon-paths.ts`. Lower churn but fights the design-system direction.
- **Option C — Keep all four, just dedup names.** Only resolve §3.1/§3.2 (rename or retire the colliding kebab keys) and leave the component/registry split as-is. Minimal, but leaves triplication.

**Recommendation:** **Option A**, executed in phases — it matches the design trajectory and the cheapest first phase (retiring `icon-paths.ts`) already removes the sharpest hazards.

---

## 6. Recommended phased execution (deferred)

| Phase | Scope | Cost | Removes |
|-------|-------|------|---------|
| **1 — bounded** | Retire `icon-paths.ts` (migrate its **6** `<Icon>` call sites to MattIcon/`icons.tsx`) + dedup the 3 duplicated brand logos into `brand-icons.tsx` | small, completable in one conv | §3.1 + §3.2 entirely |
| **2 — convention** | Ratify Option A; make `icons.tsx` names map 1:1 to MattIcon; document the convention | decision + doc | ambiguity |
| **3 — dedup** | Collapse concept triplication (§3.3); verify `CloseIcon`/`XIcon` | multi-conv (175 importers) | §3.3 |

Phase 1 is safe and standalone; Phases 2–3 depend on the §5 decision.

---

## 7. Related

- Memory `reference_icon_system` — the runtime behavior of each system.
- [matt-provenance.md](matt-provenance.md) §9 — MattIcon per-icon design provenance (`matt` / `matt-embedded` / ours), `icon-provenance.ts`.
- `docs/decisions/05-ui-ux-components.md` — MattIcon usage in nav chrome (ControlBar, NavDrawer).
