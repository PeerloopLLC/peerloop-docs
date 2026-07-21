# State — Conv 404 (2026-07-21 ~15:45)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Conv 404 ran two threads. (1) **Falsified Conv 403's `[TASK-TOOLS-DOWN]` root cause.** That conv blamed a `CLAUDE_CODE_CHILD_SESSION` leak from VS Code's frozen env; probing the *real* process environments with `ps -wwwE` showed the vars are absent from the `claude` process, its parent `zsh -l`, and VS Code — they exist only inside Bash-**tool** subprocesses, where Claude Code injects them to mark its own child shells. The Conv-403 probe (`echo $VAR` from the Bash tool) prints `1` in every healthy session and can never diagnose anything. Real cause: `TodoWrite` has been **disabled by default since CC v2.1.142**, superseded by the `Task*` tools. Both Conv-403 remediations were undone and every live record corrected. (2) **`[A11Y]` first triage pass, 100 → 72 warnings** — built two behavioral primitives (`ui/ModalBackdrop.tsx`, `ui/ClickableRow.tsx`) and migrated 8 sites; all 5 gates green.

## Key Context

- **Task backlog lives in `CURRENT-TASKS.md`** (32 rows) — do not re-list here. New this conv: `[TASK-TOOLS-VERIFY]`, `[PROV-SWEEP-DEBT2]`, `[COMPDOC]`. Rewritten: `[A11Y]`. Top Ordered `[MERGE-BRIAN-JULY7]` still ON HOLD (gate: user's client conversation).

- **⚠️ FIRST THING NEXT CONV — check whether `TodoWrite` is back.** `CLAUDE_CODE_ENABLE_TASKS=0` was added to `~/.claude/settings.json` `env` this conv but is **UNVERIFIED**; env only applies at launch. If it returns, `[TASK-TOOLS-DOWN]` closes for good. **If it does NOT**, the corrected diagnosis is still incomplete — the unexplained part is that `Task*` **and `Grep`/`Glob`** were all absent, which no setting, CLI flag, or output style accounts for. Investigate the *pruned tool set*, NOT child-session status. Full detail in `[TASK-TOOLS-VERIFY]`.

- **Cross-machine gap:** that var went into the **global** `~/.claude/settings.json`, a home dotfile that is **not git-tracked** — MacMiniM4 will not inherit it. Undecided whether to duplicate it into the git-tracked project `.claude/settings.json` (the `CLAUDE_AFK_TIMEOUT_MS` both-scopes precedent). Same applies to the `~/.zshrc` revert — MacMiniM4 still has the Conv-403 `env -u` guards (harmless no-ops, but stale).

- **Do NOT re-diagnose the Conv-403 theory.** It is falsified and fully unwound: `~/.zshrc` `peerloop()`/`spt()` reverted to plain `claude …` (backup `~/.zshrc.bak-conv404`), memory rewritten, `DOC-DECISIONS.md` §3 + `TIMELINE.md` Conv-403 row marked SUPERSEDED. Archival `docs/sessions/2026-07/20260721_1223 *` still contain the false version by policy.

- **`[A11Y]` continuation is mechanical.** 49 `label-has-associated-control` remain, all the same `htmlFor`/`id` pattern. Next hottest: `ResourcesEditor` 12, `AddCommunityResourceModal` 8, `AvailabilityCalendar` 6, `UsersAdmin` 5. The `[A11Y]` row lists the 6 interactive sites deliberately NOT migrated, each with its reason — **do not force `ClickableRow` onto them**, the a11y contracts genuinely differ (a backdrop must never be focusable).

- **New: behavioral-primitive tier.** `ui/ModalBackdrop.tsx` + `ui/ClickableRow.tsx` are deliberately **unstamped and unregistered** — behavior, not design; no Figma counterpart, so a `data-prov` value or `figmaMatchNames` entry would be a false claim. `prov:sweep` accepts this; `matt-provenance.md §12e` now records it. Known consequence: `ClickableRow` will always read as an "uncovered interactive" in `prov-page-report` (its selector includes `[role="button"]`) — by design, not a bug.

- **Baseline VERIFIED this conv, all 5 gates:** tsc 0 · astro check 0 errors / 0 warnings / 3 hints (1297 files) · lint 0 errors / 167 warnings · **6540/6540 tests** (405 files) · build clean. Separately, `npm run prov:sweep` reports **10 pre-existing issues** (was 0 at Conv 244) — verified untouched by this conv, tracked as `[PROV-SWEEP-DEBT2]`.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.
