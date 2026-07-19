# State — Conv 397 (2026-07-19 ~14:50)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Conv 397 was a **tool-evaluation conv** (`Block: MVP-GOLIVE` + misc) — the **code repo was never touched** (HEAD still `2d148da7` from Conv 394, working tree clean throughout). It assessed the `react-doctor` npm package end-to-end in four phases and landed a clear verdict: **occasional external audit, explicitly pre-go-live; NOT added to the toolbelt.** The durable output was not the tool but the two coverage gaps it exposed in tooling **we already owned** — no accessibility linting anywhere, and 15 unenabled React Compiler rules sitting in `node_modules`. Those became `[A11Y]`, `[RHOOKS]`, `[RDFIX]`.

## Key Context

- **Task backlog lives in `CURRENT-TASKS.md`** — do not re-list here. New this conv: **[A11Y]**, **[RHOOKS]** (`[Opus]`-tagged), **[RDFIX]**, all in Unordered backlog. `[RDOC]` closed. All three `## 🔥 Ordered` entries stayed **gated** the whole conv (`[MERGE-BRIAN-JULY7]` on hold pending the user's client conversation, `[ORPHAN-BACKLOG]` Cat-B parked behind `[RG-PUBLIC]`, `[PLATO-SEQ]` 4c post-launch), so this conv ran entirely from the backlog. **That gating is unchanged going into Conv 398.**

- **The React Doctor verdict is settled — don't re-open it.** The disqualifier is **structural, not quality**: it analyzed **0 of our 90 `.astro` files** (reported `framework: "unknown"`), so a gate built on it could stay green while a route regressed. `0.x` at ~4 versions/day is secondary. Full reasoning in `docs/decisions/06-testing-ci.md` § RDOC; reproducible pre-launch procedure in `plan/mvp-golive/README.md` § **MVP-GOLIVE.CODE-AUDIT**; baseline report preserved at `.scratch/rdoc-report-conv397.json` so a future run is a *diff*, not a fresh derivation.

- **The load-bearing finding, worth remembering before anyone re-evaluates a linter here:** react-doctor *depends on* `eslint-plugin-react-hooks@7.1.1` but reports **zero** `react-hooks/*` rules. The two tools are **complementary, not overlapping** — falsified in both directions (its 154 a11y findings invisible to the plugin; the plugin's 91 `set-state-in-effect` findings invisible to it). Had Phase 3 been skipped, we'd have adopted it believing it covered the hooks rules. **A bundled dependency does not mean its rules run — check the fired-rule set.**

- **⚠️ `[RHOOKS]` is NOT a free flip, and this is the thing most likely to bite.** 105 of the 108 control findings are `error` severity and `npm run lint` is one of the five baseline gates — enabling `recommended-latest` as-is turns the gate **RED immediately** and blocks all baseline verification. Land at `warn` first. Exact precedent: `[LE-TRIAGE]` (Convs 147–149, COMPLETE) did this for `exhaustive-deps`, and its rationale is still a comment in `eslint.config.js`.

- **Branch naming is now load-bearing for billing.** Conv 396's `codeBranchAllowPattern: "^jfg-dev"` is a **whitelist** — a descriptively-named branch (`rdoc-eval`) would silently zero the work's billable minutes with no error. Any future branch must be `jfg-dev-NN`. This drove the Conv-397 decision to run in place with no branch; if `[A11Y]`/`[RHOOKS]` warrant one, cut `jfg-dev-15`.

- **🔻 `[RSYNC-GATE]`'s premise was corrected this conv.** The `/r-start` Step 5.7 `rsync -a --delete` ran with **no classifier block**, after firing at Convs 395 and 396. The "will RECUR every conv / structural property" claim is **falsified** — it is **intermittent**, which is worse: a block firing 2-in-3 invites assuming a silent pass means the sync happened. Row corrected in place rather than opening a duplicate task. Fix case unchanged.

- **Evaluation method worth reusing** (both now in `docs/sessions/2026-07/20260719_1443 Learnings.md`): (1) **measure coverage first** — read the tool's own `analyzedFiles` before interpreting any finding count; engine docs claimed `.astro` `<script>`-block support that this consumer never exercised. (2) **run a control** against tooling already installed but unenabled, to isolate net-new signal per unit of new dependency.

- **Docs repo commits this conv:** `4583948` (start heartbeat), `08634f9` (the RDOC landing), + the end-of-conv commit. **Code repo: no Conv 397 commits** — by design.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.
