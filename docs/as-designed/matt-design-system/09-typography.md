> **Matt Design System** · [Index](./INDEX.md) · [Colour §5](./05-color-and-tokens.md) · [Layout §8](./08-layout-and-margins.md)

## 9. Typography System — Two Leading Regimes & Role Discipline

### 9.0 Typography Foundation — Role Discipline (Conv 298 [TYPO-FDN])

> This is the **operative typography layer for new work.** The raw Variable
> definitions live in [`tokens-typography.css`](../../../../Peerloop/src/styles/tokens-typography.css)
> (18 Figma-canonical entries, [TSV] Conv 181) and are bridged to Tailwind
> utilities in `tokens-tailwind-bridge.css`. This section is the **rule for which
> token to use where** — the missing discipline above the token set, sibling to the
> colour foundation (§5.0 [PALETTE-FDN]) and the layout foundation (§8 [LAYOUT-SG]).

**Why this layer exists.** Matt's type scale is correct and complete, but it has **no
documented usage discipline**, so consumers improvised. A Conv-298 DOM-truth audit of
the Home SmartFeed found font-size / line-height / padding drifting card-to-card. Root
cause: the scale has **two deliberate leading regimes**, and consumers picked tokens by
*size* without regard to *regime*. Usage counts at the time:

| Token | Size / LH | Uses | Of which on `<p>` |
|---|---|---|---|
| `text-body-default` (caption, lh 1.0) | 14px / 14px | **166** | **99** |
| `text-body-small` (caption, lh 1.0) | 12px / 12px | 298 | — |
| `text-body-medium` (paragraph, lh 1.5) | 16px / 24px | **3** | — |
| `text-body-medium-bold` (paragraph) | 16px / 24px | 67 | — |

The paragraph token was used **3 times**; the *caption* token was used for **99 paragraphs**,
inheriting caption leading (line-height = font-size, no leading). The app's de-facto body
size is **14px**, but Matt's scale only offered 14px as a *caption* — a real gap (see
§9.2).

### 9.1 The two leading regimes (Matt's design, documented)

Matt's Figma type system has **two leading regimes on purpose** — do not flatten them:

| Regime | Sizes | Line-height | Letter-spacing | Use for |
|---|---|---|---|---|
| **Dense / display** | Body 12–14px · all Headers 14–32px | **1.0** (100%) | 0 | captions, labels, metadata, chips, nav, dense single-line UI, headings |
| **Prose** | Body 16–20px | **1.5** (150%) | −0.022em | multi-line paragraph copy |

`lh: 1.0` on a 14px caption is **correct** — it is single-line text where leading is
irrelevant. The same token on a multi-line paragraph reads cramped. **The token is not
the bug; the role mismatch is.**

### 9.2 The 14px-paragraph gap → `text-body-default-prose` (CC-minted, Conv 298)

Matt's scale offers 14px **only** as a dense caption (lh 1.0). But the app's body text is
14px, and paragraphs need prose leading at that size. Rather than upsize the whole app to
Matt's 16px paragraph token (a client-visible change) or break the caption regime (which
~67 legit label/chip/nav uses depend on), TYPO-FDN **mints a 14px paragraph token** — a
CC-ownership scale *extension* (permitted post-Conv-289), filling a gap Matt's frames never
covered:

```
text-body-default-prose   14px / lh 1.5 (21px) / weight 400 / ls 0
```

`ls` stays 0 (Matt's optical tracking is size-driven and unneeded at 14px). Defined in
`tokens-typography.css` and bridged like the canonical tokens; clearly marked `CC-MINTED
(NOT @matt-source)`.

### 9.2a The 12/14px bold gap → `text-body-small-bold` / `text-body-default-bold` (CC-minted, Conv 300)

Matt's `-bold` (600) weight exists at 16px (`text-body-medium-bold`) and for all headings
(`text-h1-bold`…`text-h5-bold`), but **not** at 12/14px — yet count/emphasis labels (e.g.
`AnalyticCount`'s "👍 2") need 600 at those sizes, and code had already reached for a
(then-phantom) `text-body-default-bold`. TYPO-FDN mints the two missing dense-regime bold
tokens, same `-bold = 600` pattern, dense lh 1.0:

```
text-body-small-bold      12px / lh 1.0 / weight 600 / ls 0
text-body-default-bold    14px / lh 1.0 / weight 600 / ls 0
```

CC-ownership scale extension (Conv 300, `[TYPO-CTA-TOKEN]`); marked `CC-MINTED (NOT @matt-source)`
in `tokens-typography.css`.

### 9.2b The 16/500 label gap → `text-body-medium-medium` (CC-minted, Conv 302)

Matt's 16px body comes only as `400` (`text-body-medium`) or `600` (`text-body-medium-bold`) —
there is **no 16/500**. Form-control **labels** (toggles, fields) across the settings islands
are de-facto 16px medium (legacy `font-medium`, no size class). `text-h4` is 16/500 but lives in
the **header** regime (lh 1.0, ls 0) and is semantically a heading — wrong for a label. TYPO-FDN
mints the missing body-regime 16/500, sitting between `text-body-medium` (400) and
`text-body-medium-bold` (600):

```
text-body-medium-medium    16px / lh 1.5 / weight 500 / ls -0.022em
```

CC-ownership scale extension (Conv 302, RG-PROFILE; chosen over bump-to-600 / drop-to-14/500);
marked `CC-minted (NOT @matt-source)` in `tokens-typography.css`.

### 9.2c The display / glyph regime — non-prose sizing (CC-minted, Conv 327)

§9.1's two regimes (dense / prose) both assume the styled text has a **typographic role** —
paragraph, caption, label, heading. A recurring class of UI does not: the `text-*` value
sizes a **non-prose glyph** — a single initial, numeral, icon, or micro-badge — whose size
is driven by its **container or display role**, not a text role, and for which no §9.3
token fits (it is off-scale, or the role token's leading / tracking would corrupt a lone
glyph). These were previously tolerated as scattered per-component "display-exceptions"
(raw `text-xs…3xl`, `text-6xl`, `text-[10px]`) cross-referenced by drift-prone phrases
("404-numeral precedent", "sub-12 glyph"). This **third regime** replaces that ad-hoc
practice with governed tokens — consistency by construction, not by citation.

**The test — all three must hold:** (1) the content is a single glyph/numeral, not a run of
text; (2) its size is container/display-driven, not a text role; (3) no §9.3 role token
fits. A `text-*` that passes is **conformant by this regime**, not a violation.
`font-bold`/`font-semibold` on such a glyph folds into the token's weight — *not* a
raw-weight violation, because there is no role token to attach a `-bold` variant to.

**Family A — avatar initials (minted + applied, Conv 327).** A monogram initial must fill
avatar circles of 24–96px. Five tokens, weight 600 (Matt Semi-Bold; normalized from the
prior raw `font-bold` = 700), dense lh 1.0, ls 0:

```
text-display-avatar-xs   12px / 600 / lh 1.0   (was text-xs,  h-6)
text-display-avatar-sm   14px / 600 / lh 1.0   (was text-sm,  h-8)
text-display-avatar-md   18px / 600 / lh 1.0   (was text-lg,  h-12)
text-display-avatar-lg   24px / 600 / lh 1.0   (was text-2xl, h-16)
text-display-avatar-xl   30px / 600 / lh 1.0   (was text-3xl, h-24)
```

Applied inside `UserAvatar`'s `sizeClasses` map — one file, conforming all 15 consumers at
once. Other container-scaled-initial sites (`MySessionsTab` `text-[7px]`, `EnrollmentCard`
`font-bold` initial) are **pending adopters** of this family. Defined in
`tokens-typography.css`, bridged in `tokens-tailwind-bridge.css`, marked
`CC-MINTED (NOT @matt-source)`.

**Pending regime members** (documented home; not yet minted):

| Sub-class | Will mint | Current raw | Sites |
|---|---|---|---|
| B · hero display numeral | `text-display-numeral` (~60 / 600) | `text-6xl` | `/404` |
| C · sub-12 micro-badge | `text-display-micro` (+ `-bold`?) | `text-[10px]` | `ConversationList`, `MemberCard` |

**D · icon / emoji glyph** (★, 🧠) is **out of this regime** — it is icon sizing, owned by
the icon-system `size-*` scale (§5 / icon docs), not a type token.

### 9.3 Role discipline — which token for which text role

| Text role | Token | Size / LH |
|---|---|---|
| **Paragraph / multi-line prose (app default)** | `text-body-default-prose` | 14px / 1.5 |
| Paragraph, larger reading contexts | `text-body-medium` | 16px / 1.5 |
| Lead / intro paragraph | `text-body-large` | 20px / 1.5 |
| Bold emphasis in prose | `text-body-medium-bold` | 16px / 1.5 |
| **Caption / label / metadata / chip / dense single-line** | `text-body-default` (14) · `text-body-small` (12) | / 1.0 |
| Label, medium weight | `text-body-default-medium` · `text-body-small-medium` | / 1.0 |
| Form-control label, 16px medium | `text-body-medium-medium` | 16px / 1.5 |
| Bold label / count / emphasis (12–14px) | `text-body-default-bold` (14) · `text-body-small-bold` (12) | / 1.0 |
| **Headings** | `text-h1`…`text-h5` (500) · `text-h1-bold`…`text-h5-bold` (600) | / 1.0 |

**Decision rule:** *Is the text a multi-line paragraph?* → a **prose** token (lh 1.5).
*Is it a single-line label / caption / heading?* → a **dense** token (lh 1.0). Never select
a token by size alone.

### 9.4 Sweep policy — "tokenize or flag" (the type/spacing SOP)

Mirrors §5.0's colour "map or flag". When sweeping a `@matt-source` / `@matt-inspired`
surface for TYPO-FDN (or in a route sweep):

1. **Tokenize** raw type that bypasses the system — `text-[Npx]`, Tailwind defaults
   (`text-sm`/`text-base`/`text-lg`), `text-slate-*`/`text-gray-*` (also a §5 colour gap),
   ad-hoc `leading-*` — onto the role token from §9.3.
2. **Flag** a genuinely novel need (a size/weight/leading the scale lacks) rather than
   inventing inline — extend the scale deliberately (like §9.2), don't improvise per-site.
3. **Spacing — scale classes only.** Margin / padding / gap use the Matt px-scale
   classes (`p-16`, `gap-12`, `mt-4`), **never arbitrary `[Npx]`** (`p-[16px]`,
   `mt-[12px]`). Off-scale values (no token: 2/6/10/76px) snap to the nearest scale step,
   or are FLAGGED as sanctioned optical exceptions where snapping would misalign (e.g. a
   2px icon-baseline nudge). Widths / heights / radii may stay arbitrary where no scale
   token exists.
4. **Non-prose glyph — neither tokenize-to-role nor flag-and-mint-a-role.** If the `text-*`
   sizes a single glyph / numeral / icon by its container (an avatar initial, a hero
   numeral, a micro-badge), it has **no typographic role** — use the **display / glyph
   regime** (§9.2c), never a §9.3 role token. A glyph token that passes §9.2c's test is
   conformant; do not flag it.

### 9.4a Canonical card spacing + the Unified Feed-Card Spec (Conv 298)

Feed / listing **cards** standardize on **`p-16` padding + `rounded-12` radius**. The Home
feed renders ~7 card components of different origins; they MUST present **identically per
slot** (the "cards of several origins" problem the user flagged Conv 298):

| Slot | Token |
|---|---|
| Container | `p-16` · `rounded-12` |
| Eyebrow / label | `text-body-small-medium` (12 / 1.0) |
| Title | `text-body-medium-bold` (16 / 1.5) |
| Body / paragraph | `text-body-default-prose` (14 / 1.5) |
| Meta / timestamp | `text-body-small` (12 / 1.0) |
| CTA link | `text-body-small-medium` |
| Rhythm | `mt-4` (label→title→body) · `mt-8` (body→CTA) · internal `gap-12` |

Reference implementation: `AnnouncementCard`. Per-component conformance is tracked in
[`plan/typo-fdn/migration-ledger.md`](../../../plan/typo-fdn/migration-ledger.md) — a
component-level checklist (shared components tracked once; route completion derived) so no
component is silently deferred (the gap that let PALETTE-FDN's `[FAC-RECOLOR]` rot).

### 9.5 Status

- ✅ Two-regime model + role discipline documented (this section).
- ✅ `text-body-default-prose` minted + bridged + validated (AnnouncementCard pilot:
  body `<p>` 14/14 → 14/21; caption regime intact).
- ⬜ Canonical card padding/radius standard (§9.4 step 3).
- ⬜ Migration: ~99 `<p>` paragraph misuses + raw-class feed cards
  (`FeedActivityCard`, `FeedPost`) → role tokens. Rides the RG-* route sweeps, like
  PALETTE-FDN's tail. SoT: `PLAN.md` ACTIVE § TYPO-FDN.
