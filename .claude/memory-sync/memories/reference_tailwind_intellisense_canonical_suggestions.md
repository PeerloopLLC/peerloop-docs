---
name: reference_tailwind_intellisense_canonical_suggestions
description: "Tailwind IntelliSense `suggestCanonicalClasses` flags arbitrary [Npx]→scale — REJECT in Peerloop (spacing override + @matt-source px contract); silenced machine-local via Peerloop/.vscode/settings.json"
metadata: 
  node_type: memory
  type: reference
  originSessionId: aee40aa1-2d27-45af-b502-77b65cd4e656
---

**VS Code Tailwind CSS IntelliSense (`bradlc.vscode-tailwindcss` ≥0.14.x) has a lint rule `tailwindCSS.lint.suggestCanonicalClasses` (default `warning`)** that flags arbitrary utilities which have a scale equivalent, offering a "Replace with" quick-fix — e.g. `w-[112px]`→`w-28`, `h-[24px]`→`h-6` (px÷4). **NEVER accept these in Peerloop.** Two reasons:

1. **Provenance:** `@matt-source` / `@matt-inspired` pages use arbitrary `[Npx]` as the pixel-exact design contract (1:1 Figma ports — e.g. `src/components/brand/Logo.tsx`, node `1:270`, dims 112×65 / 137×24 / 109×24). The `[Npx]` values ARE the design; converting them breaks 1:1 fidelity.
2. **The px÷4 math is stock-Tailwind and unreliable here.** `tokens-tailwind-bridge.css` (Conv 174 "decision B") overrides `--spacing-{4,8,12,16,20,24,32,40,48,64}` to **literal px** (via `--space-N`), so the numeric scale is NOT a uniform 4px/unit. The suggestion is right *by luck* only when the divided number lands OUTSIDE that set (`w-[112px]`→`w-28`→112px ✓ because 28∉set), and silently **4×-mis-sizes** when it lands INSIDE (`w-[96px]`→`w-24`=**24px**, `h-[256px]`→`h-64`=**64px**). That's the [DEMO-HOME] bug class (Conv 174/191). See [[project_spacing_snap_over_matt_exception]].

**Fix (Conv 371):** `~/projects/Peerloop/.vscode/settings.json` → `"tailwindCSS.lint.suggestCanonicalClasses": "ignore"`. **Machine-local** — `.vscode/` is gitignored in the code repo (`.gitignore:42`), so this does NOT sync via git → **replicate on MacMiniM4** (recreate the same one-line file). The file carries an inline comment with this rationale. `npm run check:tailwind`, eslint, tsc, astro do NOT flag this (it's editor-only); the other installed extensions (`stivo.tailwind-fold`, `dbaeumer.vscode-eslint`) are not the source.
