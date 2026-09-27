---
name: project_admin_conformance_policy
description: "Conv 331 — RG-ADMIN restyle policy: admin = dense operational console with relaxations A–D + a deliberate dark \"Admin\" visual identity"
metadata: 
  node_type: memory
  type: project
  originSessionId: 26134cab-6ac3-4dba-8aa5-43b6a6e22531
---

**[ADMIN-CONF-POLICY] (Conv 331, decided with user):** How to restyle `/admin/*` (RG-ADMIN — 16 routes, 33 components in `src/components/admin/`, shell `src/layouts/AdminLayout.astro` + `src/components/layout/AdminNavbar.tsx`; ~1470 legacy-token hits incl. **122 `dark:`**; multi-conv effort). Admin is a **dense operational console** (tables / forms / queues / bulk-actions for ≤2 high-trust operators), NOT a content surface — so it gets relaxations + a distinct identity while staying coherent with Matt tokens.

**Strict (same as everywhere):** drop ALL `dark:` (app has no dark mode); no off-token strays / hard-hex; status → Matt semantic tokens (success/warning/error/info), `secondary-*`(slate) → `neutral-*`; spacing stays on the 4px scale.

**Relaxations (admin-specific):**
- **A — Density bias:** free use of the compact end of the spacing/type scales (`gap-8`/`p-8`) where content surfaces use generous (`gap-12`/`p-16`); still on-scale.
- **B — Neutral-led, minimal brand:** neutral + semantic-status led; accent only for genuine primary actions (NOT brand-purple — see identity accent below).
- **C — Lightweight controls in dense contexts:** adopt `Button`/`Input`/`Select` for forms + primary actions, but allow inline text-actions / icon-buttons in table rows + toolbars (RG-MOD precedent).
- **D — Flatter containers:** top-level panels get Matt card treatment; inner data tables/rows stay flat (no per-row cards/shadows).

**Type — admin runs one notch tighter than content (the ambient "Admin" signal):** body default **12px** (`text-body-small`, vs content's 14px); dense/meta (table secondary cells, timestamps, IDs, counts, captions) **10px** (`text-display-micro`); headings scaled down one step. Do **NOT** use 10px throughout (legibility). Mint a dense alias only if a real grid proves 12px too loose.

**Admin visual identity (so it "registers Admin" when operators cross from the light user app):**
- **Dark sidebar** — `AdminNavbar` bg → **`neutral-900`** charcoal, light-on-dark nav (the primary signal; reclaims admin's old `dark:` sensibility as a deliberate identity, not a mode).
- **"Admin" wordmark** + shield/gear glyph in the sidebar header.
- **Admin accent** for primary actions = **`info` americana-blue (#0777B6)** or a steel tone — NOT brand-purple — so admin CTAs read as admin.
- **Role chip** ("Admin") by the avatar on every admin page.
- **Shared page-header pattern** (title + `/admin` breadcrumb).

**Sweep plan:** multi-conv; **start shell-first** (`AdminLayout` + `AdminNavbar` → the dark identity) **+ `AdminDashboard`** (establish the patterns), then route-by-route (top offenders: PayoutsAdmin, PromotionSettings, Announcements, Topics…). Build on **RG-MOD** (Conv 313 — `warning`/`suspend` Button variants, status-badge hybrids, dense queue chrome). The detailed per-component conformance section gets written into `plan/typo-fdn/migration-ledger.md` when the sweep starts. Relates to [[project_old_appnavbar_retire_by_default]] (the canonical-vs-legacy nav distinction).
