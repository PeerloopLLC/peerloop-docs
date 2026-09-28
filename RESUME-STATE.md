# State — Conv 460 (2026-09-27 ~20:30)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-17`, docs: `main`

## Summary

CC-infra conv (no code). Ruled the one open hopper item carried from Conv 459 (`(r-end)`-tagged) via `/r-hopper` — user chose **do-it-now** over CC's promote-to-a-row recommendation. Ported **fps r-end's Step 1b currency-sweep** into peerloop r-end as a new **Step 4e** (pre-commit self-falsification check), then exercised it live on this very close (worked as designed — clean).

## Key Context

- **New r-end Step 4e — currency sweep.** Sits between Step 4d (PRE-COMMIT CHECKPOINT) and Step 5 (SAVE STATE), so it runs while the conv's work is still in the working tree. Mechanically derives the changed-path list — docs via `git diff "$H"` (working-tree-vs-heartbeat, `$H` = the `Conv NNN start` commit) + `ls-files --others`; code repo (no heartbeat of its own) via `git log --since=<heartbeat ts>` + `diff --name-only HEAD` + untracked — then re-reads each changed file **plus always-swept surfaces** (`docs/INDEX.md`, `PLAN.md`, `CLAUDE.md`↔`CLAUDE-OFFLOAD.md`) asking only *"did this conv's own work make anything here untrue?"*. Fix in place, naming the conv. **Exclusions:** `docs/sessions/*` (history), `RESUME-STATE.md` (rewritten Step 5), generated docs (regen Step 5c), `.scratch/*`.
- **What was adapted from fps:** dual-repo heartbeat asymmetry (only peerloop-docs carries the heartbeat; code repo anchored by its timestamp). **What was dropped:** fps's `DEC-`/`DECISIONS.md` tombstone machinery (peerloop routes decisions to `docs/decisions/` chunks via the learn-decide agent, not a tombstone sweep). Kept all of fps's discipline warnings: derive mechanically not from memory, no `..HEAD`, untracked command not optional, silent-empty-is-worse, refinement≠falsehood.
- **First live run was clean** — 7 surfaces re-read (4 changed + 3 always-swept), 0 corrected. The only durable claim at risk ("peerloop r-end lacks fps Step 1b") lived only in the previous RESUME-STATE + a `.scratch` note, both excluded/rewritten.
- **Decision routed** to `DOC-DECISIONS.md` § 3 (cc-workflow topic) by the learn-decide agent.
- Board unchanged otherwise: `## 🎯 Now` top is `[GSN-SPIN]`; standing NEXT-CONV priority remains the **163 codecheck warnings** — `[RHOOKS]` (88 react-hooks, already `[Opus]`-tagged, behavior-sensitive) + `[A11Y]` (75 jsx-a11y). See `CURRENT-TASKS.md`.

## 🗃️ Hopper handoff

_No items placed this close._ (The Conv-459 item was ruled do-it-now and cleared; nothing new surfaced during this close.)

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.
