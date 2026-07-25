---
name: project_wrangler_exact_pin_miniflare_dedupe
description: "[MF-SKEW] wrangler is exact-pinned 4.112.0 (NO caret) so its miniflare dedupes with the astro-dev server's — a caret re-splits the copies and revives the _cf_ALARM crash"
metadata: 
  node_type: memory
  type: project
  originSessionId: 316fb654-322f-4f4b-a12d-c5687ce7f506
  modified: 2026-07-25T19:27:53.155Z
---

`package.json` pins **`"wrangler": "4.112.0"`** with **no caret — this is deliberate, load-bearing, do NOT "modernize" it to `^4.112.0`.** ([MF-SKEW], Conv 416.)

**Why:** wrangler bundles miniflare at an *exact* version; the `astro dev` server gets its own miniflare via `@astrojs/cloudflare` → `@cloudflare/vite-plugin` (1.45.1 → miniflare `4.20260714.0`). Both share `.wrangler/state/v3`. If the two miniflares differ, whichever wrote last leaves a schema the other can't read → `table _cf_ALARM has 3 columns but 2 values supplied (SQLITE_ERROR)` on any `wrangler … --local` op while a dev server is up. wrangler **4.112.0** pins miniflare `4.20260714.0` — *byte-identical* to vite-plugin's pin — so npm **dedupes to ONE shared miniflare copy**, structurally eliminating the skew. A caret would let a fresh `npm install` float wrangler to 4.114 (miniflare 20260722 ≠ 714) → **two copies again → skew returns.**

**Companion facts:**
- `@cloudflare/workers-types` is **v5** (`^5.20260714.1`), not v4 — wrangler 4.112's optional peer wants `^5`, and because we declare workers-types *directly*, npm ERESOLVE-fails on a v4. v5 measured **tsc-clean (0 errors)**, so the earlier "major-bump → codebase-wide tsc fallout" fear was unfounded. (Keeping v4 would need a committed `.npmrc legacy-peer-deps=true` — a broad, brittle peer-check weakening; rejected.)
- The **global** nvm wrangler was also bumped to 4.112.0 (was 4.58.0, shadowed local on PATH for manual `wrangler …` calls; npm-run scripts already use `node_modules/.bin`).
- **If `@astrojs/cloudflare` is ever upgraded**, re-check the vite-plugin's bundled miniflare version and re-align wrangler's exact pin to match (keep them in lockstep). See [[feedback_db_setup_shorthand]], [[project_schema_edit_remote_d1_propagation]].
- The old "stop `astro dev` before any `wrangler --local` op" interim rule is **retired** — the dedupe makes seeding-while-dev-up safe (`db:seed:r2:local` verified 7/7 with a live server).
