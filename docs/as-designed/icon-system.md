# Icon System — Inventory & Namespace Reconciliation

**Last Updated:** 2026-07-07 (Conv 370 — ICN-NS COMPLETE: Option A + all phases + §3.3 decided)
**Status:** 🟢 **ICN-NS COMPLETE** — Option A (MattIcon-canonical) ratified Conv 370. **Phase 1** retired the legacy Astro path registry (`icon-paths.ts` + `Icon.astro`) → system count **4 → 3**, §3.1 + §3.2 gone. **Phase 2** ratified the naming convention (**MattIcon kebab name is canonical**; `icons.tsx` renames to match on conflict) + the full reconciliation map (**§7**). **Phase 3** consolidated all **10** aliases + executed **all 15** name-mismatch renames (incl. the `UsersIcon`→`GroupIcon` follow-up; `RatingIcon`→`ratings` moot); `icons.tsx` is now **98** exports (was 108). **§3.3 decided — accept split:** the `icons.tsx` (Heroicons, React islands) / `MattIcon` (Material, Matt surfaces) two-system split is an **intentional, documented steady state**. Implementation-unification was considered and **declined** — it would restyle React islands app-wide for an aesthetic call better made per-surface, and the RTMIG-4 route sweep that could have carried it closed Conv 340 without touching icon glyphs (so no migration will resolve it on its own). Names are aligned, so the correspondence stays clear. All gates green.
**Related:** memory `reference_icon_system`, [matt-provenance.md](matt-provenance.md) §9, `../Peerloop/src/lib/icon-provenance.ts` (per-icon source), CURRENT-TASKS.md [ICN-NS]

---

## 1. Problem

Peerloop **historically** carried **four** coexisting icon systems with **three** naming conventions. The same glyph was frequently defined in two or three of them under different names, and — worse — some *identical kebab strings* resolved to *different glyphs* depending on which component consumed them. This doc inventories the systems and records the reconciliation.

> **Phase 1 outcome (Conv 370).** System 1 — the Astro path registry (`icon-paths.ts` + `Icon.astro`, System #1 below) — has been **retired**. Its only 4 real call sites (Breadcrumbs `chevron-right`; Footer's 3 brand logos) migrated to `MattIcon` and `brand-icons.tsx`, and both files were deleted. **Three** systems now remain (2 = `icons.tsx`, 3 = `brand-icons.tsx`, 4 = `MattIcon`). The §2/§4 figures below are preserved as the *pre-retirement* inventory that justified the decision; struck through where superseded.

---

## 2. The four systems

| # | System | File | Convention | Count | Call sites | Role |
|---|--------|------|-----------|------:|-----------:|------|
| 1 | ~~Astro path registry (`<Icon name=…>`)~~ **RETIRED Conv 370** | ~~`src/lib/icon-paths.ts` + `ui/Icon.astro`~~ (deleted) | kebab string keys (`chevron-right`) | ~40 | **4** real sites (not 6 — earlier count included 2 doc-comment examples) | retired |
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

> **Decision — Conv 370: accept the split as an intentional steady state.** After Phase 1 this is a *two*-system duplication: `icons.tsx` (Heroicons-style **stroke**, the React-island glyph set) and `MattIcon` (Material **filled**, Matt design surfaces). *Implementation*-unifying them (making shared concepts render one SVG) was considered and **declined**: it would restyle React islands app-wide (stroke→Material) for an aesthetic call better made per-surface, and the legacy→Matt route sweep (RTMIG-4) that could have carried it **closed Conv 340 without ever scoping icon-glyph unification** — so no migration will absorb it. The two-system split is therefore accepted and documented as intentional; Phases 2–3 aligned the *names* so the correspondence stays legible. This is revisitable if the app later commits to an all-Material look, but it is not open work.

### 3.4 What is **not** a fixable collision

- **Convention split is largely inherent.** React *components* are idiomatically `PascalCaseIcon`; string-keyed registries are idiomatically kebab. Forcing one convention across component-and-string-key worlds would fight the grain of each framework.
- **Some suspected intra-`icons.tsx` dupes are distinct glyphs; many others are literal aliases.** `MoreIcon` (horizontal ⋯) ≠ `DotsVerticalIcon` (vertical ⋮) — genuinely distinct, no free dedup. But `icons.tsx` also shipped **10 literal aliases** (`export const A = B`, same render fn) — incl. `XIcon = CloseIcon` (the former unverified §3.4 suspect, **confirmed identical**) and `SearchIcon = DiscoverIcon`. Those were free dedup wins, **all consolidated Conv 370** (Phase 3); full list in **§7.1**.

---

## 4. Usage weight (drives cost)

- **System 2 (`icons.tsx`)** — 175 importers. Renaming here is the expensive part; treat as the stable workhorse.
- **System 1 (`icon-paths.ts`)** — **RETIRED Conv 370.** Had only **4** real `<Icon>` call sites (the audit's "6" mistakenly counted 2 doc-comment examples in `Icon.astro`). Retiring it erased collision categories §3.1 and §3.2 exactly as predicted, at trivial cost.
- **System 4 (MattIcon)** — ~10+ Matt components; the stated design destination.
- **System 3 (brand-icons)** — 7 logos, self-contained.

---

## 5. Reconciliation options — **OPEN DECISION**

The core question: **which system is canonical**, and **what naming convention** do the string-keyed systems share? Candidate end-states:

- **Option A — MattIcon-canonical for design glyphs; `icons.tsx` stays the React workhorse; retire `icon-paths.ts`.** Aligns with the Matt phase-out (memory `project_matt_phaseout_inspired_default`). MattIcon becomes the single kebab registry; `icons.tsx` remains for React ergonomics but is reconciled *against* MattIcon names (a `FooIcon` component should map 1:1 to a MattIcon `foo`). Brand logos consolidate into `brand-icons.tsx` (retire System-1 `brand-*`).
- **Option B — `icons.tsx`-canonical (status quo weighted to usage).** Keep the 175-importer React system as the source of truth; MattIcon becomes a thin styling layer over the same concept set; retire `icon-paths.ts`. Lower churn but fights the design-system direction.
- **Option C — Keep all four, just dedup names.** Only resolve §3.1/§3.2 (rename or retire the colliding kebab keys) and leave the component/registry split as-is. Minimal, but leaves triplication.

**Recommendation:** **Option A**, executed in phases — it matches the design trajectory and the cheapest first phase (retiring `icon-paths.ts`) already removes the sharpest hazards.

> **Decision — Conv 370: Option A ratified.** MattIcon-canonical for design glyphs; `icons.tsx` stays the React workhorse; `brand-icons.tsx` is the canonical brand-logo home; the Astro path registry is retired. **Phase 1 executed the same conv** (see §6).

---

## 6. Recommended phased execution (deferred)

| Phase | Scope | Cost | Removes |
|-------|-------|------|---------|
| ~~**1 — bounded**~~ ✅ **DONE Conv 370** | Retired `icon-paths.ts` + `Icon.astro`; migrated its **4** real sites (Breadcrumbs `chevron-right`→`MattIcon`; Footer's 3 brand logos→`brand-icons.tsx`) | small, one conv | §3.1 + §3.2 entirely ✅ |
| ~~**2 — convention**~~ ✅ **DONE Conv 370** | Ratified Option A; ratified the naming convention (**MattIcon kebab name is canonical**; `icons.tsx` renames to match on conflict); built the reconciliation map (see **§7**) | decision + doc | ambiguity ✅ (renames scheduled to Phase 3) |
| **3 — dedup** ✅ **DONE Conv 370** | consolidated the 10 aliases + **all 15** name-mismatch renames; **§3.3 decided — accept the two-system split as intentional** (implementation-unification declined) | multi-conv | §3.1–§3.3 ✅ |

**ICN-NS is complete (Conv 370).** All three phases done; §3.3 resolved by decision — the `icons.tsx` (Heroicons) / `MattIcon` (Material) split is accepted as an intentional, documented steady state (see §3.3). No open ICN-NS work remains.

**Phase 1 visual notes (Conv 370):** two sites changed appearance by design — the Footer **Twitter** logo went bird → **X** mark (modernization, via `brand-icons.tsx`), and the Breadcrumbs separator **chevron** went thin outline → **Matt's filled Material wedge** (chosen to follow Option A + the established `MattIcon`-in-`.astro` precedent, over a zero-change `icons.tsx`-in-`.astro` one-off). GitHub is pixel-identical; LinkedIn negligible. No glyph was lost and nothing was repurposed ambiguously.

---

## 7. Naming convention & reconciliation map (Phase 2 — Conv 370)

**The convention.** A shared icon concept uses **one base token** across systems: `<Concept>Icon` (PascalCase) in `icons.tsx` ↔ `<concept>` (kebab) in MattIcon (`svg/<concept>.svg`). Mechanical transform: strip the `Icon` suffix, PascalCase→kebab (`ChevronRightIcon` ↔ `chevron-right`). **On a name conflict for the same glyph concept, the MattIcon kebab name is canonical** (ratified Conv 370 — MattIcon is the design source of truth per Option A); `icons.tsx` renames to match. New icons MUST follow this from the start.

> **Scope.** Phase 2 decided + documented; **Phase 3 (Conv 370) then executed the alias consolidation (§7.1) + the clean 1:1 renames (§7.3)** — ~78 files, all 5 gates green. Two rows (`RatingIcon`, `TeamIcon`+`UsersIcon`) and the deeper §3.3 implementation-unification remain deferred, flagged inline.

### 7.1 Intra-`icons.tsx` aliases — confirmed exact duplicates (10)

`icons.tsx` **had** an `// Aliases (for backwards compatibility)` block: these names were **literal aliases** (`export const A = B`), same render function — not merely look-alike. **Consolidated Conv 370 (Phase 3):** the alias block was removed and every importer repointed to the canonical name. Direction followed §5 — where MattIcon has the concept, its name was kept (`SearchIcon` kept over its former *base* `DiscoverIcon`, since `search` is the MattIcon name); where it doesn't, the clearer name was kept (`PlusIcon` over `CreatingIcon`).

| Alias(es) | Base glyph | Note |
|-----------|-----------|------|
| `XIcon` | `CloseIcon` | **§3.4 suspect CONFIRMED identical** (literal alias) — maps to MattIcon `close` |
| `RatingIcon` | `StarFilledIcon` | "rating" is a filled star; distinct from MattIcon's `ratings` glyph — reconcile carefully in Phase 3 |
| `PrivacyIcon`, `ShieldIcon`, `FocusIcon` | `ShieldCheckIcon` | 3 aliases → 1 |
| `RevenueIcon` | `MoneyIcon` | |
| `BrainIcon` | `LightbulbIcon` | |
| `CreateIcon` | `EditIcon` | |
| `PlusIcon` | `CreatingIcon` | |
| `SearchIcon` | `DiscoverIcon` | "search" is literally Discover's magnifying glass (also aligns to MattIcon `search`) |

### 7.2 Aligned — `icons.tsx` ↔ MattIcon name already 1:1 (17)

No action; these are the model. `ArrowLeftIcon`↔`arrow-left`, `ArrowRightIcon`↔`arrow-right`, `CalendarIcon`↔`calendar`, `ChevronRightIcon`↔`chevron-right`, `ClockIcon`↔`clock`, `CloseIcon`↔`close`, `CoursesIcon`↔`courses`, `FeedIcon`↔`feed`, `FolderIcon`↔`folder`, `HomeIcon`↔`home`, `LockIcon`↔`lock`, `MenuIcon`↔`menu`, `NotificationsIcon`↔`notifications`, `PlayCircleIcon`↔`play-circle`, `SearchIcon`↔`search`, `SparklesIcon`↔`sparkles`, `WarningIcon`↔`warning`.

### 7.3 Name-mismatch → canonical target (the Phase-3 rename list)

Same concept, divergent name. Under the convention the **MattIcon name wins**, so `icons.tsx` renames to the PascalCase form shown. **Executed Conv 370 (Phase 3):** 13 of the 15 rows in the first pass (~78-file rename; gates green), then the final 2 resolved in a follow-up. The 3 *awkward* names (`VideocamIcon`, `PersonAddIcon`, `AdminPanelSettingsIcon`) were applied as-is per the ratified "MattIcon wins" decision. **All 15 rows are now resolved** — the two initially-deferred ones closed as:
> - **`UsersIcon`→`GroupIcon` (done, 21 usages).** A glyph check settled the "merge" worry: `UsersIcon` = Heroicons 2-person = MattIcon `group` (2-person), so it's a clean 1:1 rename. `TeamIcon` = Heroicons 3-person *user-group* is a **distinct glyph with no MattIcon twin** — kept as-is (§7.4), **not** merged. So this was never a lossy merge.
> - **`RatingIcon`→`ratings`: moot.** `RatingIcon` was an unused (0-importer) alias of `StarFilledIcon`, already consolidated away in §7.1; no React consumer needs a `ratings` glyph. MattIcon `ratings` stays available for Matt surfaces.

| icons.tsx (current) | MattIcon (canonical) | → icons.tsx target | Confidence |
|---------------------|----------------------|--------------------|------------|
| `VideoIcon` | `videocam` | `VideocamIcon` | clear · *awkward?* |
| `MessagesIcon` | `message` | `MessageIcon` | clear |
| `InfoCircleIcon` | `info` | `InfoIcon` | clear |
| `CertificateIcon` | `certification` | `CertificationIcon` | clear |
| `ChatBubblesIcon` | `chat` | `ChatIcon` | clear |
| ~~`RatingIcon` (=StarFilled)~~ | `ratings` | — | **moot** — unused alias, consolidated to `StarFilledIcon` |
| `UserPlusIcon` | `person-add` | `PersonAddIcon` | clear · *awkward?* |
| `AdminIcon` | `admin-panel-settings` | `AdminPanelSettingsIcon` | clear · *awkward?* |
| `TagIcon` | `label` | `LabelIcon` | arguable |
| `ProfileIcon` | `user-icon` | `UserIcon` | arguable |
| `HelpIcon` | `question` | `QuestionIcon` | arguable |
| `MoneyIcon`/`RevenueIcon` | `earnings` | `EarningsIcon` | arguable |
| `EditIcon`/`CreateIcon` | `write` | `WriteIcon` | arguable |
| `UsersIcon` (2-person) | `group` | `GroupIcon` ✅ | done — clean 1:1 (`TeamIcon`=3-person kept, no twin) |
| `TeachingIcon` | `teachers` | `TeachersIcon` | arguable |

### 7.4 No-twin sets (keep as-is)

- **`icons.tsx`-only (~74):** utility glyphs with no MattIcon counterpart (`Archive`, `Ban`, `Bolt`, `ChartBar`, `Check*`, `ChevronDown`/`Left`/`Up`, `Clipboard`, `Code`, `CreditCard`, `Dashboard`, `Download`, `Email`, `Eye`, `Filter`, `Flag`, `Globe`, `Link`, `Logout`, `More`/`DotsVertical`, `Refresh`, `Send`, `Settings`, `Sort`, `Spinner`, `Star`, **`TeamIcon`** (3-person — deliberately distinct from the 2-person `GroupIcon`), `Trash`, `Trend*`, `Trophy`, `Upload`, …). Stay `PascalCaseIcon`; no MattIcon SVG required unless a design need arises.
- **MattIcon-only (~30):** design glyphs with no React twin (`accessibility-new`, `arrow-up`/`down`, `assignment`, `av-timer`, `bookmark(-filled)`, `level-*`, `milestone`, `module`, `notes`, `present`, `resource`, `review`, `signature`, `stars-2`, `student(-teacher)`, `verified`, `video-comment`, `work-together`, …). Stay kebab SVGs.

---

## 8. Related

- Memory `reference_icon_system` — the runtime behavior of each system.
- [matt-provenance.md](matt-provenance.md) §9 — MattIcon per-icon design provenance (`matt` / `matt-embedded` / ours), `icon-provenance.ts`.
- `docs/decisions/05-ui-ux-components.md` — MattIcon usage in nav chrome (ControlBar, NavDrawer).
