# State — Conv 409 (2026-07-24 ~07:45)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Built MERGE-BRIAN §1 `/course/[slug]` **Tier A + Tier B** (6 of 9 ADAPT mechanisms), committed and live-verified. Tier A (cosmetic): M1 hero compression (360→166px), M5 compact actionable journey band, M4 Peer-Teachers relabel + count-gated search island. Tier B (shared-primitive, all opt-in): M6 scroll-preserve, M7 dense tabs, M12 compact feed composer + skeletons. Remaining §1 = Tier C (M2/M3/M10 + `[RECEIPT]`), schema-bearing, its own conv.

## Key Context

- **Next: §1 Tier C** — M2 `[SESS-TAB]` (curriculum-first Sessions-tab rebuild + a booked-not-completed fixture verify), M3 `[SESS-FILES]` (`display_order` column + reseed), M10 `[COMM-BAND]` (`logo_url` column + reseed + public read route), plus `[RECEIPT]` (M5's Payment target dep — no receipt page exists; Payment still points at `/success`). All need `0001` schema edits + reseed. Full per-mechanism build notes: `plan/merge-brian/README.md §1 Build log`.
- **Committed this conv:** code `a7de0522` (12 files, +425/−169), docs `31f8d38`; the `/r-end` bookkeeping commit follows and both push at close.
- **🔴 Spacing-token trap** (new memory): only use spacing values from the defined set `{4,8,12,16,20,24,32,40,48,64}`. An undefined token like `py-28` does NOT error — it silently resolves to stock Tailwind's 4px-per-unit (`py-28`=112px), invisible to tsc/lint/build. **DOM-measure (`getComputedStyle`) after any spacing edit.** See `memory/project_spacing_snap_over_matt_exception.md`.
- **Provenance:** a cosmetic change to a `@matt-source` component keeps the stamp + documents the departure as a Strict-B drift; a full `@matt-inspired` flip needs the prov-registry update tracked under `[PROV-SWEEP-DEBT2]` (a raw flip adds prov:sweep errors).
- **Side-by-side gotcha:** dev servers `:4321` (ours) + `:4341` (Brian's pivot at `8a1e677f`) are long-running and **share the localhost auth cookie** (same host) — re-assert identity per side before reading state; `:4341`'s login modal never renders (use the dev-login DevTools/fetch snippet).
- For the task backlog, see `CURRENT-TASKS.md` — do not re-list here.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.
