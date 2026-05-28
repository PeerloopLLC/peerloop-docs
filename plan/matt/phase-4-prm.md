# Phase 4 — Primitives [MATT-EXEC-PRM] / [MATT-EXEC-PRM-2]

**Status:** ✅ COMPLETE — scope A Conv 175, scope B Conv 176, DSSR cold-start fix Conv 177
**Family:** matt
**Spec:** `docs/as-designed/matt-pre-plan.md` §9 Phase 4
**Primitives code:** `src/components/matt/ui/*` (now under `src/components/ui/*` post-Conv 197 flip)

---

## Summary

Phase 4 scope A (Conv 175): 3 of 8 primitives + retrofit. Built `Button.tsx` (6 variants primary/outlined/course/student/creator/default × 3 sizes sm/md/lg; renders `<a>` if href else `<button>`; `matt-design-system.md` §6 Button table exactly), `Card.astro` (white-fill container with padding scale sm=12/md=16/lg=24/none + optional borderless), `SectionTitle.astro` (semantic level h2/h3/h4 × visual size large/medium/small). Retrofitted CourseHeader CTA to `<Button variant="course">`; retrofitted course-page body 5 sections → 4 sections each wrapped in `<Card padding="lg">` with `<SectionTitle>` headings (What's included moved to hero overlay per visual diff). Visual fidelity iteration with Matt's `Course.svg` — 6 fixes landed (Course Feed tab, 2-col objectives, What's Included as hero overlay, Meet the Creator as SubNav tab not body card, hero 2-column restructure, hero overlay glyphs). Remaining 5 primitives spawned as `[MATT-EXEC-PRM-2]`.

Phase 4 scope B (Conv 176): 5 primitives + 1 internal demo wrapper landed on `jfg-dev-13-matt`:

- `Module.tsx` (lesson row icon+eyebrow/title/duration, default/active states, direct entity-utility variants)
- `Note.tsx` (sticky-note pastel-yellow annotation `#FFF1B8` until `[NOTE-YELLOW]` token lands)
- `ToDoItem.tsx` (**fully controlled — no `useState`**, parent owns checked+onChange; green-filled checkbox glyph; direct entity-utility for active row)
- `SocialPost.tsx` (composite feed item: author header + body + optional embed slot + footer like/comment/commenters)
- `RoleTabBar.tsx` (Peerloop multi-role tab switcher; anchor + button modes; role-specific primary/background tokens; safety-returns null when ≤1 role)
- `_SocialPostDemo.tsx` (internal underscore-prefixed React wrapper hosting Course-minicard embed JSX)

`/matt/index.astro` extended with Phase 4 Primitives showcase section. Final verification: HTTP 200, body 33,648 chars, 4× `bg-student-background` / 3× `bg-course-background` / 2× `bg-creator-background` in HTML, all 5 primitives + 1 social-post-embed render, tsc clean, astro check clean (0/0/2 pre-existing hints). Remaining entity headers (`TeacherHeader`, `StudentHeader`, `CreatorHeader`) deferred to Phase 5 alongside the routes that consume them.

## Conv 176 — strategic decisions captured

- **Refactor `ToDoItem` from hybrid controlled+uncontrolled to fully controlled (no `useState`)** — Triggered by `[DSSR-SCOPE]` React-hooks-null SSR crash cascading from ToDoItem's `useState` through Sidebar.tsx, zero-ing the entire page body. Discipline rule established: matt/* primitives must be stateless / fully controlled until `[DSSR-SCOPE]` upstream-fixed. **Retired Conv 177 once the real root cause was found.**
- **Direct entity-specific Tailwind utilities, not `.entity-*` cascade, inside matt/* primitives** — Matt's documented multi-mode cascade (`:root` default → `.entity-student` override → `bg-entity-background` consumer) does not propagate empirically through Tailwind 4's `@theme`-generated intermediates; renders as `:root` default (grey) regardless of overriding class. Switched Module + ToDoItem to direct `bg-{course,student,creator}-background` utilities matching `Button.tsx`'s six-variant pattern. Reserve cascade for non-primitive components consuming `var(--Entity-Background)` directly. Tracked as `[CASCADE-BROKEN]` for root-cause investigation (later closed Conv 182 — Matt's button CSS uses variant-scoped variables, NOT entity-cascade; later resurfaced as real Tailwind 4 `@theme inline` bug Conv 188 `[ENTITY-CASCADE-BUG]`).
- **Extract `_Demo.tsx` for rich JSX showcase content; don't inline in `.astro`** — Astro `.astro` expression-block parser rejects `<div className=…>` AND `<div class=…>` AND inline `<svg viewBox=…>` (only accepts component references). Web research confirmed by-design Astro behavior (roadmap discussion #716 tracks broader JSX support; no upgrade fixes this). Pattern: extract embed JSX into underscore-prefixed React file, reference from `.astro` as `<SomeDemo />`.
- **Upgrade Astro stack next conv + retry the canonical [DSSR-SCOPE] dedupe/noExternal workaround** — `[NPM-UP]` task created as 🔝 LEAD NEXT-CONV ITEM. (See Conv 177 below.)

## Conv 176 — patterns established

- **`qlmanage` SVG→PNG visual inspection** — `qlmanage -t -s 1200 -o /tmp file.svg` rasterizes SVG to a Read-tool-viewable PNG (~1 sec per SVG). Bypasses both the SVG-text-too-dense-for-Read issue and the no-Chrome-MCP-driving issue. Should be added to `[MPV]` workflow / `matt-pre-plan.md`.
- **`_Demo.tsx` extraction for rich JSX showcase content** — underscore-prefixed React component files alongside primitives; `.astro` showcase pages mount them as single component references. Avoids Astro expression-block JSX restrictions.
- **Stateless matt/* primitives discipline** — RETIRED Conv 177; see below.
- **Direct entity utility per variant** — match `Button.tsx` pattern (`bg-{course,student,creator}-background` keyed by `entity` prop) instead of relying on `.entity-*` cascade.

## Conv 177 — [NPM-UP] + [DSSR-SCOPE] resolved

**[NPM-UP] COMPLETE.** Astro stack upgraded: astro `6.1.5 → 6.3.7`, `@astrojs/cloudflare 13.1.8 → 13.5.4`, `@astrojs/react 5.0.3 → 5.0.5`, wrangler `4.81.1 → 4.94.0` (initial install hit ERESOLVE — `@astrojs/cloudflare@13.5.4` requires `wrangler@^4.83.0`; added wrangler@4.94.0 to upgrade set per Solution Quality default-durable).

Canonical Vite dedupe workaround attempted in `astro.config.mjs` but FAILED — Sidebar.tsx still crashed on cold-start with same symptom.

**[DSSR-SCOPE] RESOLVED.** Root cause was NOT React/Cloudflare-adapter dual-copy as Conv 122/176 hypothesized; it was Vite's default lazy dep discovery causing a cold-start race (documented industry-wide: Remix #10156, TanStack/router #4264, Storybook #32049, vitejs/vite #17979). First SSR request triggers Vite to find a new import → re-optimize `node_modules/.vite/deps_ssr/` → reload bundled React → in-flight render crashes with null hooks dispatcher → response body cut off mid-attribute. Subsequent requests work; production builds unaffected entirely.

**Fix:** `astro.config.mjs` `vite.optimizeDeps.entries: ['src/**/*.tsx', 'src/**/*.ts', 'src/**/*.astro']` + `include: ['astro/virtual-modules/transitions.js']` (entries alone was insufficient because Astro virtual modules aren't reachable via src/ scanning).

Verified: cold-start `/matt/` now succeeds first request (240839 bytes, all primitives rendered, `</html>` closed, 0 ERROR lines, 0 mid-session re-optimize); production build clean in 7.27s; preview `/matt/` 30564 bytes, all 13 primitives present.

Sidebar.tsx `useState` works fine. DEV-STAGING-SSR row removed from ON-HOLD. Conv 176 stateless-primitives discipline retired from `DEVELOPMENT-GUIDE.md`.

ToDoItem.tsx rewritten as controlled-or-uncontrolled hybrid (proper React idiom). Sidebar.tsx `flex-shrink-0 → shrink-0` (Tailwind v3→v4 rename, caught by `/w-codecheck`). DEVELOPMENT-GUIDE.md stateless-primitives section replaced with "Vite SSR Cold-Start Dep Discovery" section. api-test-helper.ts logger no-op stub added (Astro 6.3 APIContext addition). HeaderBar.astro Props cast fix + CourseHeader.astro dead Button import removed (astro check hints). `/w-codecheck` all 8 PASS.

## Conv 177 — strategic decisions captured

- **Pair wrangler upgrade with the Astro stack upgrade** — `@astrojs/cloudflare@13.5.4` requires `wrangler@^4.83.0` (project had 4.81.1). Chose adding `wrangler@4.94.0` to the upgrade set (option B) over `--legacy-peer-deps` (papers over real version skew). Per CLAUDE.md §Solution Quality: default to durable.
- **Retire the stateless-primitives discipline** — Conv 176's discipline ("matt/* primitives must be stateless / no useState") was responding to a misdiagnosed problem. Real bug is fixable with a 2-line config change. `DEVELOPMENT-GUIDE.md` section replaced with "Vite SSR Cold-Start Dep Discovery" documenting the real bug class + fix recipe + symptom signature for future recurrence detection.
- **ToDoItem uses controlled-or-uncontrolled hybrid pattern** — three valid API shapes considered (fully controlled / uncontrolled only / hybrid); chose hybrid matching React standard idiom. Existing showcase callsites with `checked={false}`/`checked={true}` keep working (controlled, no onChange = no toggle); future production callers can use either mode.
- **Don't downgrade React to 18.2** — technet-experts article suggested React 19→18.2 downgrade as a "stable" fix; rejected because Vite cold-start pattern affects React 18 projects too (Storybook #32049, Remix #10156 reporters on R18). The crash isn't a React-version problem.

## Conv 177 — patterns established

- **Diagnostic checklist for SSR hook crashes:** (1) Does the same request reliably reproduce after fresh server start? → cold-start race (this class). (2) Does the crash persist across multiple requests? → duplicate React copies (#11825 class). (3) Does production build reproduce? → fundamental config issue. Two crash classes share the same error message — distinguish by request-order behavior.
- **Astro virtual module pre-bundling:** any Astro virtual module that appears in `✨ new dependencies optimized: <X>` dev log should be added to `optimizeDeps.include`. New Astro features that introduce new virtual modules may need re-adding.
- **Cheap order-dependence probes falsify "structural" diagnoses:** when a hypothesis requires increasingly elaborate explanations to fit the data, test for order-dependence/cache state before adding complexity. A second probe of an earlier-failing condition (e.g., `/matttest` probe Conv 177) can break a "structural" illusion cheaply.

## Conv 181 — [NOTE-YELLOW] resolved by hardcoding inline (NOT new token)

`get_design_context(652:8646)` probe revealed Matt's yellow (`#FFF6B8` background + `#F1E9B0` border) is hardcoded hex in Figma, NOT a Variable — no `--note-yellow` to surface. Note.tsx aligned to exact Figma spec: yellow hex corrected (`#FFF1B8 → #FFF6B8`), 1px border `#F1E9B0` added, radius 12→8, padding 16→10, gap 8→10, shadow `shadow-sm` → exact custom value, `leading-relaxed` removed (drift vs `text-body-default` canonized lh:1). All values inline as Tailwind arbitrary values per new **tokenize-only-matt-variables principle** (`memory/feedback_tokenize_only_matt_variables.md`): token-ify what Matt has tokenized; hardcode what Matt has hardcoded; honest-orphan rule.
