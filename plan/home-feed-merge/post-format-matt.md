# [POST-MATT] — Post format, Matt design (spec capture)

**Status:** 📐 SPEC CAPTURED (Conv 258) — from Figma probe. Not built. Part of `[HOME-FEED-MERGE]` / the feeds redesign.
**Figma:** fileKey `UpDNMiIEO8y3J7ZHkm356b` · **simple post** node `477:8285` · **complex post** node `477:8203`. (Asset URLs from the probe expire in 7 days — re-probe by node ID.)

## Shared card shell (both posts)
`border (border/default #eaeff5) · rounded-[12px] · p-[20px] · flex-col · gap-[20px]`. Three stacked regions: **header · body · reactions row** (complex adds an embedded entity card between body and reactions).

## Header row (`gap-6`, items-center)
- **Avatar chip** ("User Icon" — maps to existing `Avatar`/`UserIcon`): initials, rounded-[33px], **role-tinted bg + initials**: student/new = bg `#f1f9ff` + initials `#0777b6` (primary blue); creator = bg `#e0e8ff` + initials `#584df4` (creator purple). → avatar tint encodes role (ties to ROLE-SEMANTICS accent tokens). Simple = 39–41px, complex = 40px.
- **Name** — Body Medium Bold (Inter 16/600, tracking -0.352), black.
- **Role icon + label** — `how_to_reg` icon + "Joined PeerLoop" (new member) · `creator` gear icon + "Creator". Label = Body Small (12, text/tertiary `#767676`). Role-driven.
- **Timestamp** — bulleted (`list-disc`) "2h"/"1h", Body Small tertiary.

## Body
- Text = Body Default (Inter 14/400, text/default `#414141`); multi-paragraph + bullet lines supported.
- **"Show More" truncation** (complex post) — underlined link, primary `#0777b6`. → **directly ties to `[SHOWMORE]` #13** (build them together).

## Embedded entity card (complex post only, node `477:8210`)
A **course** card embedded *inside* the post — `border · rounded-[12px] · px-20 py-12`:
- `course` icon + title ("Intro to Claude Code", Body Medium Bold).
- meta row: creator icon + name · `stars_2` + "5.0 (1 review)" · `accessibility_new` + "Beginner".
- **"Learn More" Button** — note a **green variant** (bg `#e8f4df` / text `#327d00`) + right-arrow. (Check whether `Button` has this success/course-green variant or needs one.)
- 🔑 **This IS the "promote-a-course" content type / the feed "card"/"sample-post-with-CTA" variant we designed.** The embedded entity card + "Learn More" = the entity-promo in post form. Cross-links: `[PROMOTE-PIPELINE]` templates + `[HOME-FEED-MERGE]` render variants. A community promo would be the parallel template. **Reuse candidate:** existing `CourseCatalogCard`/`CourseCard` (compact variant) rather than a new inline card.

## Reactions row (`gap-10`)
- **Reaction pills** — emoji + count, `primary/light #f1f9ff` bg + border, rounded-[33px], primary text (👍 2 · 💕 1). Zero-count pill uses `#f6f6f6` bg.
- **Comment pill** — 💬 + "Matt commented" / "Matt and 1 other commented" (purple `#584df4` accent border). → likely a new `ReactionPill` primitive (emoji+count) + a comment-summary pill.

## Tokens seen
`border/default #eaeff5` · `primary #0777b6` · creator `#584df4` · `text/default #414141` · `text/tertiary #767676` · `primary/light #f1f9ff` · avatar bg tints `#f1f9ff`/`#e0e8ff` · course-green button `#e8f4df`/`#327d00`. Type: Body Medium Bold (16/600), Body Default (14/400), Body Small (12/400) — all Inter.

## Build notes / cross-links
- **Reuse, don't inline** (`feedback_reuse_existing_components`): Avatar/UserIcon, Button (+ verify green variant), CourseCatalogCard for the embedded entity. New primitives likely needed: `ReactionPill`, comment-summary pill, the post shell itself.
- Post shell is the container for the **3 feed-item variants** (member-post = this; sample-post = this + entity card + CTA; card-announcement). The complex post shows member-post + embedded-entity already unify into one component with optional regions.
- `[SHOWMORE]` #13 is the body-truncation behavior — fold in.
- Provenance: `@matt-source` (these ARE Matt frames — list both node IDs).
