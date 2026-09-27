---
name: Verify baselines in current conv — Conv 101→102 incident pointer
description: Primary rule lives in CLAUDE.md §Baseline Verification. This file retains BOTH baseline-incident details — Conv 101→102 (verify-this-conv / time-fragile tests) and Conv 104 (astro check must be in the 5-gate baseline).
type: feedback
originSessionId: 12068441-588a-46fa-b887-2651598646bf
---
**Primary rule is in CLAUDE.md** — see §Baseline Verification Rule 2 (verify in THIS conv before claiming; mark un-verified carry-forwards explicitly with `(unchanged from Conv N, not re-verified this conv)`).

**Conv 101→102 incident detail (kept here):**

Conv 101's RESUME-STATE.md confidently claimed *"tests: 6399/6399 passing (366 test files)"* as a baseline for Phase 2a. Conv 102 ran the full suite for the first time and found **5 session-creation tests had been failing silently** — time-fragile `Date.now() + Nh` patterns that break when current UTC is late in the day. The 5 failures had been lurking unnoticed for some unknown number of conversations because no one ever re-verified the baseline. Phase 2a would have inherited this broken baseline invisibly; Phase 3 would have inherited it on top of that; and so on.

**Pattern lessons:**

- Carry-forward baselines are hypotheses, not facts.
- The `feedback_cleanup_step.md` rule applies: verifying baselines is part of block cleanup, not optional.
- Time-fragile test patterns (current-time-dependent) are a recurring source of silent failures — flag them whenever spotted.
- `/r-end`'s update-plan and docs agents must cite a verification command from the current conv's transcript when including baseline numbers, or mark them un-verified.

---

## Conv 104 incident — baselines must include `astro check` (folded in Conv 281 from feedback_baseline_includes_astro_check)

**Primary rule is in CLAUDE.md** — see §Baseline Verification (5-gate definition: tsc / `npm run check` / lint / test / build).

**Conv 104 incident detail:**
- `tsc --noEmit` was green; `npm run check` (astro check) reported **10 type errors** in `.astro` pages (CourseTag triple-definition + 2 one-offs) plus 27 hints.
- Errors had been invisible through Conv 100–103 because `astro check` was never in: the local in-conv baseline habit (tsc/test/build only), `.github/workflows/ci.yml` (lint → typecheck → test → build → e2e), or any `/r-end` / `/r-commit` gate.
- Likely drifted in during the TERMINOLOGY rename (Sessions 346-356) or the CourseTag type-extraction refactor; flagged `[AC]` for fix before `[P6]` PR merge.
- CI was updated Conv 104 to run `npm run check` in the `lint-and-typecheck` job.

**User principle:** *"We don't want to bypass issues as we do upgrades, refactors, etc, or really ever."*
