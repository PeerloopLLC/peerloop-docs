> **Matt Design System** · [Index](./INDEX.md) · [Pre-plan](../matt-pre-plan.md)

## 8. Layout & Margins — Style Guide (gap analysis → spec)

✅ **Guide authored Conv 288; Q2 closed + core built Conv 289.** Matt's page-template + breakpoint frames + populated mobile pages were extracted (§8.3.1, §8.3.2) and the layout rules written (§8.5). Q2 (utility-column side) was **decided by the client — LEFT** (impromptu meeting, Conv 289). The **jar fix shipped Conv 289**: rather than a new `ContentShell`, the 1248px shell cap + centering was added to `AppLayout` (which already hosted the card/grey shell) — fixing it app-wide; `ListingShell` filters moved left; `/courses` promoted to H1. See §8.5 build-status table. Residuals (vertical-rhythm tokens, full-bleed hero slot) tracked under PLAN **LAYOUT-SG**.

**Why this doc exists.** We have a spacing *scale* (`--space-4 … --space-64`, [§ Batch 3](./07-token-scaffolding.md)) but **no layout/margin *system*** — no canonical content width, no shared page container for non-listing pages, no documented rule for which side the utility column sits on. The result is visible drift (§8.1). This guide will be the single source of truth for *page-level* layout, complementing the *atomic* spacing scale in §6.

---

### 8.1 Motivating case — the "margin jar" (`/courses` → `/course/[slug]`)

Navigating from the course **listing** to a course **detail** page produces a jarring shift. It has **two compounding causes**, both traceable to missing system rules:

1. **Content left-origin jumps right ~196px.** The listing's utility column (filters) is on the **right**, so content starts immediately after the 220px app-nav. The detail's utility column (the `SubNav` section strip, 196px) is on the **left**, so content starts ~196px further right. → No rule pins which side the utility column lives on.

2. **Content width balloons.** The listing caps its column at **640px** (`ListingShell`, CD-039). The detail page has **no cap** — it falls back to fluid width (~1230px at a 1758px viewport). → No canonical content max-width (see §8.4 Q1, open to Matt since Conv 172).

Neither page is "wrong" in isolation; there is simply nothing reconciling them. That is the gap this guide closes.

---

### 8.2 Current code reality (what ships today)

| Surface | Container | Content width | Outer gutter | Utility column | Source |
|---|---|---|---|---|---|
| **AppLayout** (`<main>`) | flex, no inner cap | `flex-1` → **fluid / full-bleed** | `px-16` (16px), `pt-[88px] pb-[96px]` | — | `src/layouts/AppLayout.astro` |
| **Listing pages** (`/courses`, …) | `ListingShell` | **640px** centered column | inherits AppLayout 16px | **right** rail, **320px**, sticky, `#eff6ff` bg | `src/components/layout/ListingShell.astro` (CD-039 / LIST-1COL, Conv 284) |
| **Course detail** (`/course/[slug]`) | raw AppLayout slot | **fluid** (~1230px) | inherits AppLayout 16px | **left** `SubNav`, **196px** | page in `src/pages/course/[slug]` |
| **~80 other non-listing pages** | raw AppLayout slot | **fluid** (no cap) | inherits AppLayout 16px | varies / none | various |

**Key observation:** only *listing* pages have a disciplined container. Everything else inherits AppLayout's uncapped `flex-1`. `ListingShell`'s 640px is a **local CD-039 decision with no Matt basis** — it was invented to stop cards stretching, not extracted from a spec.

---

### 8.3 What Matt actually specified (consolidated)

Pulled together from [§2 Architecture](./02-architecture.md) and [§ Batch 2 Layout dimensions](./07-token-scaffolding.md). These are the *known* values — the foundation the guide builds on:

| Dimension | Desktop ≥1025 | Tablet Portrait ≤1024 | Mobile ≤640 |
|---|---|---|---|
| Sidebar width | 220 / 70 (collapsed) | replaced by Control Bar | replaced by Control Bar |
| Outer page padding | **16px** | 48 T/B · **168 L/R** | ~16–20 L/R *(estimate)* · T/B **OPEN** |
| Sidebar↔Main gutter | **16px** | n/a | n/a |
| `SubNav` (entity section strip) | **196px** (left) | ??? narrower? | slide-in from left |
| Header Bar height | 40 | 24 | 44 |
| **Main content max-width** | **OPEN — not in Figma** | OPEN | OPEN |

**Spacing scale** (atomic, [§ Batch 3](./07-token-scaffolding.md)): `--space-4/8/12/16/20/24/32/40/48/64`. Matt-confirmed: 16, 20, 24, 48. Rest scaffolded from Tailwind. *No Spacing collection exists in Matt's Figma Variables.*

---

### 8.3.1 Matt's page templates — extracted Conv 288 (AUTHORITATIVE)

Matt added three **"Page Template - Layout"** outer frames. These are the authoritative source for the shell + content container + margins, and they **supersede** the older Batch-2 page-padding estimates where they conflict.

**Source nodes** (file `UpDNMiIEO8y3J7ZHkm356b`):
- Desktop: `81:1483` — *Page Template - Layout / Desktop + Tablet Landscape* (1280×800). Screenshot: `../figma-screenshots/page-template-desktop_81-1483.png`.
- Tablet: `517:8866` — *Page Template - Layout / Tablet* (834×1194).
- Mobile: `517:8867` — *Page Template - Layout / Mobile* (393×852).

**Desktop layout model (the headline):**

```
Page frame      bg #f8fafc · border · rounded-24 · p-16 · flex · justify-center
 └─ Main Content   flex · gap-16 · max-w-[1248px] · centered        ← content cap = 1248px
     ├─ Nav Bar       w-220 · py-28 · flex-col justify-between       ← sidebar
     └─ Page Content  WHITE card · flex-1 · rounded-20 · p-24 ·      ← the universal container
                      shadow · overflow-y-auto
         └─ Content   flex-1 · w-full   (fills the card)
```

Matt provides **two** related frame sets:
- **Device templates** (`81:1483` desktop, `517:8866` tablet, `517:8867` mobile) — the shells.
- **"Breakpoints and layouts"** (below) — the same shells pinned to **Tailwind's exact breakpoints** with precise geometry. This set is authoritative for the responsive rules.

**Responsive breakpoint geometry (exact — computed from the frame coordinates):**

| Tailwind BP | Viewport | Shell | Sidebar | Content padding | **Content width** | node |
|---|---|---|---|---|---|---|
| `base` | 393 | single column, no sidebar | — | 16 | **361** | `1149:35443` |
| `sm` | 640 | single column, no sidebar | — | 16 | **608** | `1149:21386` |
| `md` | 768 | single column, no sidebar | — | 32 | **704** | `1149:21417` |
| `lg` | 1024 | **sidebar + white card** | 220 | 24 | **708** | `1149:21325` |
| `xl` | 1280 | sidebar + white card | 220 | 24 | **964** | `1149:21494` |
| `2xl` | 1536 | sidebar + white card | 220 | 24 | **964** | `1149:21555` |

**The rules these encode:**
- **Shell-swap at `lg` (1024px):** `< lg` → single-column, no sidebar, floating nav pills (top header pill + bottom nav pill); `≥ lg` → 220px sidebar + white "Page Content" card.
- **Content container (`lg`+) = the white card** — `rounded-20`, `p-24`, shadow, `overflow-y-auto`, `flex-1`; content **fills** it. Outer frame padding 16px; nav↔card gutter 16px.
- **Content caps at 964px** (card 1012 − 48 padding). The whole shell (220 + 16 + 1012 = **1248px**) caps and **centers** beyond `xl` — at 2xl the side margins grow to 144px each.
- **`< lg` has no card** — content sits directly on the `#f8fafc` grey with padding only (16 at base/sm, 32 at md). Floating nav pills are fixed-width, centered (base/sm: 353 top + 345 bottom; md: 498 bottom, 6 icons).
- Page background `#f8fafc` (grey shell) at every breakpoint; active nav = white pill.

**Consequences for the margin jar:**
- The white **Page Content card** is the missing **universal container**. Our jar exists because we have no such wrapper: listings cap at 640 *inside* the (absent) card — too narrow vs Matt's 964 — and detail fills ~1230 with no 1248 shell cap — too wide. Put both inside the card → both become 964px → jar gone, faithful to spec.
- **The content-width question is fully answered — no invented prose measure needed.** Matt's cap is 964px; "fill the card" is the rule. (A narrower reading measure for long prose would be a *project extension* beyond Matt's spec — see §8.5.1; default is to follow Matt.)
- This white-card-on-grey is the **"grey shell"** NAV-RETROFIT deferred. It can now be built.

**Deltas vs prior Batch-2 notes:** tablet padding **32px** (not 168 — Matt revised); mobile padding **16px** (was "~16–20 estimate"); content cap **964px content / 1248px shell, centered** (was "awaiting Matt"); shell-swap confirmed at **`lg` 1024**.

---

### 8.3.2 Populated mobile pages — extracted Conv 288

Three populated mobile course frames (under Figma heading **Mobile / Menus**) resolve the hero, vertical-rhythm, and mobile-SubNav questions with real content:
- `951:20132` — course hero (fragment). Screenshot: `../figma-screenshots/mobile-course-hero_951-20132.png`.
- `951:20383` — same page, SubNav **right-drawer** open. Screenshot: `../figma-screenshots/mobile-course-subnav-drawer_951-20383.png`.
- `1113:13756` — course **About** page (full). Screenshot: `../figma-screenshots/mobile-course-about_1113-13756.png`.

**Hero / full-bleed rule (Q4 answer).** The course hero is a **full-bleed** banner (`w-full` = 393px, breaking past the page's 16px padding), with its **own internal `p-20`** and a blurred course image background. Sibling content below respects the page padding. → **Rule: the entity hero is full-bleed within the page-content area; body content stays inside the content padding.**

**Vertical rhythm (Q5 answer).** The mobile About page is a vertical flex (not absolute):
- Page-level blocks (hero → SubNav row → content body): **`gap-24`**.
- Between content sections (intro paragraph, "What You'll Learn", "What's Included", "Who is this for?", "Prerequisites"): **`gap-30`** ⚠ off-scale — likely Matt eyeballing; **snap to `--space-32`** unless confirmed.
- Within a list group (between checklist rows): **`gap-16`**; icon↔label inline: `gap-10`.
- Section headings = Header 4 Bold (16px); body copy = Body Default (14px) in `text/tertiary #767676`; course checks `course/primary #327d00`, included checks `text/primary #0777b6`.

**Mobile SubNav pattern.** The entity section nav (Course Feed / About / Sessions / Reviews / Resources / Teachers / Meet the Creator) collapses on mobile to a **`px-16` row** — `[section-icon + current-section label]` on the left, **hamburger `≡`** on the right — which opens a **right-side slide-in drawer** (active item = white pill). → Data point for the utility-column-side question (Q2): Matt's section nav comes from the **right** on mobile.

---

### 8.4 OPEN — what's missing (the Figma checklist) ⭐

**Status (Conv 289): FULLY RESOLVED.** The page-template + breakpoint frames (§8.3.1) answered Q1/Q3/Q6/Q7; the populated mobile pages (§8.3.2) answered Q4 (full-bleed hero) and Q5 (vertical rhythm). **Q2 — the desktop utility-column SIDE — was decided by the client (LEFT) in an impromptu meeting, Conv 289.** This *overrides* the prior mobile lean toward "right" (Matt's section nav is a right drawer, §8.3.2): desktop standardizes on **left**; the mobile drawer side is a separate residual (see §8.5.3).

1. ✅ **RESOLVED (Conv 288) — Main content max-width = 1248px.** Matt's Desktop page template (`81:1483`) caps the nav+panel group at `max-w-[1248px]`, centered; content fills the white card to ~1012px (see §8.3.1). The Conv-172 question is closed. **Residual design call (not a Figma question — ours):** does Matt's "content fills the card" hold for *long-prose* detail bodies, or do we add a narrower reading measure (~720–820px) for readability while grids/dashboards fill? Matt's template shows fill; pick a policy in §8.5.1.

2. ✅ **RESOLVED (Conv 289, client decision) — utility column = LEFT.** The secondary/utility column (filters, section nav, enrollment rail) sits on the **left** across page types. This standardizes the prior inconsistency (entity `SubNav` was already left; listing filter panel was right → **must move right→left**). See §8.5.3 for the locked convention.

3. **Utility-column width(s).** Listing filters = 320; entity `SubNav` = 196. Are these two distinct, intentional widths, or should utility columns share one width token?

4. **Full-bleed vs capped rule.** Which elements go edge-to-edge (heroes clearly do) vs sit inside the capped content measure (bodies)? Need an explicit boundary so heroes stay wide while prose stays readable.

5. **Vertical rhythm.** Standard spacing between page *sections* (e.g. About → What you'll learn → Prerequisites). Currently ad-hoc `gap-16`. Is there a Matt section-gap, or do we scaffold one from the scale?

6. **Mobile / tablet residuals.** Mobile page padding T/B (`Batch 2:284` "needs Dev Mode"); Tablet Portrait `Entity Header` / `Role Tab Bar` / `SubNav` treatments (multiple `???` in Batch 2).

7. **Any post-Matt-phaseout updates.** Per the Conv 239 Matt phase-out, check whether Matt added/changed any page-structure frames since the Conv 172 extraction.

---

### 8.5 The guide (authored Conv 288 · core built Conv 289)

Authoritative layout rules, derived from §8.3.1 / §8.3.2.

**Build status (Conv 289):** The jar fix shipped — but **without a separate `ContentShell` component**. Investigation found `AppLayout.astro` *already* hosts the white card, grey bg, mobile pills, and a left `sub-nav` slot (the NAV-RETROFIT "grey shell"); the only missing piece was the **1248px shell cap + centering**, now added to `AppLayout` directly (user decision, Conv 289 — "cap AppLayout, no new component"). This fixes the jar **app-wide at once** (every page inherits `AppLayout`), so the "~80-page rollout" needs no per-page work.

| §8.5.x | Item | Status (Conv 289) |
|---|---|---|
| 8.5.1 | 1248 shell cap + centering + grey bg + white card | ✅ **Built** — cap added to `AppLayout`; card/grey already existed. No `ContentShell` component (superseded). |
| 8.5.2 | Per-breakpoint padding (16 / md:32 / lg:24) | ✅ Already in `AppLayout` — confirmed, unchanged. |
| 8.5.3 | Utility column = LEFT (Q2) | ✅ **Built** — `ListingShell` filters moved right→left; entity `SubNav` already left. |
| 8.5.4 | Vertical rhythm tokens | ⏭️ Not tokenized this conv (pages already use `gap-24`/`gap-16`); follow-up. |
| 8.5.5 | Full-bleed hero slot | ⏭️ Was tied to `ContentShell`; not built. Revisit as an `AppLayout` slot if a page needs it. |
| 8.5.7 | `/courses` H2→H1 | ✅ **Built** — `SectionTitle` gained `level={1}`; `/courses` header promoted. |

Proposed semantic tokens are *recommendations*; finalize names against `tokens-semantic.css` at build time.

#### 8.5.1 Content container & measure

| Concept | Value | Notes |
|---|---|---|
| Page background | `#f8fafc` | grey shell, all breakpoints — propose `--surface-page` |
| Shell max-width | **1248px**, centered (`mx-auto`) | the sidebar+card group; centers beyond `xl` (2xl → 144px side margins) — propose `--layout-shell-max` |
| Sidebar | 220px, gutter 16px to card | `lg`+ only |
| Content card | white, `rounded-[20px]`, `p-24`, `border-[rgba(0,0,0,0.1)]`, `shadow-[0_0_8.1px_rgba(0,0,0,0.04)]`, `overflow-y-auto`, `flex-1` | `lg`+ only — the **universal container** |
| Effective content width | **≤ 964px** (1248 − 220 − 16 − 48 padding) at `xl`/`2xl`; 708 at `lg` | a *consequence* of the shell cap, not a separate max-width |

**Rule:** content **fills the card** — no separate prose reading-measure (Matt's spec caps at 964; we follow it). If a future readability pass wants a narrower measure for long prose, add it as an explicit, documented project extension — do not bake it in silently.

**`ContentShell` component (the jar fix — the missing sibling of `ListingShell`).** A shared wrapper every non-listing page drops its content into, so margins/measure are identical everywhere:
- `lg`+: renders the white card (values above) inside the centered 1248 shell.
- `< lg`: renders content directly on the grey with breakpoint padding only (no card).
- Slots: default `<slot />` (padded body) + a `fullBleedHero` slot that breaks out of the card padding (§8.5.5).
- Lives inside `AppLayout` (which owns the sidebar + grey bg + 1248 centering). `AppLayout` needs: grey `#f8fafc` bg, the `max-w-[1248px] mx-auto` shell wrapper, and `p-16` — most exists; the 1248 cap + grey bg are the additions.

#### 8.5.2 Gutters & padding (per breakpoint)

| Breakpoint | Outer frame | Content padding | Shell |
|---|---|---|---|
| `base`/`sm` | — | **16px** | single column, no card |
| `md` | — | **32px** | single column, no card |
| `lg`/`xl`/`2xl` | **16px** | **24px** (inside card) | 220 sidebar + card, gutter 16 |

#### 8.5.3 Utility column — ✅ LEFT (Q2 resolved Conv 289, client decision)

**Canonical side: LEFT** (desktop), decided by the client in an impromptu meeting, Conv 289. The utility column — listing filters, entity `SubNav` section strip, enrollment rail — sits to the **left** of the content area across page types.

- **Widths (unchanged):** listing filter panel **320px**; entity `SubNav` **196px** strip. Keep as two distinct widths (Q3-adjacent); revisit a shared token only if a later pass wants it.
- **Build implication:** entity `SubNav` is *already* left — no change. The **listing filter panel currently sits on the right (`ListingShell`) and must move right→left** to match. This is the one concrete migration the decision forces.
- **Sticky behavior:** utility column sticks within the card scroll region (define exact offset at build time against the hero).
- **Mobile reflow (residual, not blocking):** the desktop *side* decision is left, but Matt's mobile section-nav drawer comes from the **right** (§8.3.2). Keep Matt's right drawer for the mobile section nav unless the client extends the "left" call to mobile; filters reflow to the top per current `ListingShell`. Flag for a quick client confirm if it surfaces during build — do not block on it.

#### 8.5.4 Vertical rhythm

| Level | Gap | Token |
|---|---|---|
| Page-level blocks (hero / utility row / body) | **24px** | `--space-24` |
| Between content sections (heading + block) | **32px** (Matt drew 30 — snapped) | `--space-32` |
| Within a list group (rows) | **16px** | `--space-16` |
| Icon ↔ label inline | 10–12px | `--space-12` |

#### 8.5.5 Full-bleed exceptions

The **entity hero is full-bleed** — it spans the full content-area width, breaking the card's 24px (desktop) / 16px (mobile) padding, with its own internal `p-20`. This is the *only* sanctioned break of the content padding so far. Everything else stays inside the padding. A `ContentShell` `fullBleedHero` slot encodes this so pages don't hand-roll negative margins.

#### 8.5.6 Reconciliation with `ListingShell`

`ListingShell` (640 column + 320 panel = 960 ≈ the 964 card width) is **already roughly Matt-compatible** once placed inside the card — its geometry fits. Plan: keep `ListingShell` for the column+panel listing pattern, but have it sit **inside** `ContentShell`'s card rather than raw in `AppLayout`. Decide at build time whether `ListingShell` adopts `ContentShell` as its outer wrapper or stays a parallel sibling that assumes the same shell. Either way the listing's 640 column is retained (it's a deliberate one-card-per-row measure), and the *non-listing* pages get the card via `ContentShell` — which is what removes the jar.

#### 8.5.7 The H1/H2 consistency fix (independent, do anytime)

Promote `/courses` "Browse Courses" from `H2` → `H1` (detail pages already use `H1` in the hero). Closes the semantics inconsistency and the `E2E-MIG` browse-heading flag. Not container-dependent.

---

### Cross-references

- Atomic spacing scale & layout extraction: [07-token-scaffolding.md](./07-token-scaffolding.md) (Batches 2–4)
- Two-panel shell architecture: [02-architecture.md](./02-architecture.md)
- Living open questions: [04-open-questions.md](./04-open-questions.md)
- Listing container in code: `src/components/layout/ListingShell.astro`
- App shell in code: `src/layouts/AppLayout.astro`
- Tracked in PLAN.md: **LAYOUT-SG**
