# Current Tasks — between convs

> Last refreshed 2026-06-30 (Conv 351). Per-conv history lives in `docs/sessions/` + git; this file is forward-looking task state only.
>
> **Persistent home for Peerloop task state.** Tracked in git so both machines see the
> same state via `/r-commit` push/pull. Edit by hand to reorder; the refresh (`/r-update-tasks`,
> plus `/r-commit` + `/r-end`) preserves your edits and overlays statuses from TodoWrite for
> code-matched rows.
>
> **Format:** Tasks are keyed by `[CODE]` (the sole stable identifier — no numeric IDs). Every task is
> an H3 (`### [CODE] · status · [model]`; the status segment appears in Ordered only) with a lead line
> then sub-bullets (Ordered uses Status / Next / Why / Refs; backlog is a lead line + adaptive
> sub-bullets). **Lanes** fold related micro-tasks into one H3's sub-bullets. **Parked** items sit under
> the blockquoted `> ## ⏸️ PARKED` divider near the end of the backlog. Only the three real `## ` H2
> anchors (🔥 Ordered / 📋 Unordered backlog / ✅ Completed this conv) are load-bearing.

---

## 🔥 Ordered (next-conv execution sequence)

### [CURTASKS] · 🔄 Active (Phases 1–3 done; Phases 4–5 next) · [Opus]

Adopt the spt `CURRENT-TASKS.md` task-persistence model — replace the `RESUME-STATE.md`-Remaining + machine-local `.scratch/conv-tasks.md` split with this one git-tracked, hand-editable, persistent file.

- **Status:** Phases 1–3 ✅ done. Phase 1 (design + seed) Conv 350. **Atomic read/write cutover (Phases 2–3) Conv 351** — `/r-update-tasks` engine built + dry-run-verified (zero row loss); `/r-start` read path → active-only; `/r-end` Step 5 → refresh + narrative-only RESUME-STATE; `/r-commit` Step 0 → boundary refresh. The cutover goes **live at Conv 351's `/r-end`**.
- **Next:** Phase 4 (scripts/config/ancillary — `resume-state-check.sh` narrowing, `config.json` timecard entries, `w-review-resume-state` retarget) + Phase 5 (docs/memory — `CLAUDE.md`, `skills-system.md`, 3 core + ~10 incidental memory files; fully retire `.scratch/conv-tasks.md` references).
- **Why:** machine-local `conv-tasks.md` is stale-on-return after multi-conv stints on the other machine; one git-tracked file ends the friction + the no-shrink guard.
- **Refs:** `PLAN.md § CURTASKS` · spt `~/projects/spt-docs/CURRENT-TASKS.md` + its r-update-tasks/r-start/r-end/r-commit skills.

### [MEM-CAP-ARCH] · ★ Next (actively at cap) · [Opus]

Architectural fix for `MEMORY.md` outgrowing the 25 KB SessionStart auto-load cap.

- **Status:** ~87% of the 25 KB cap (22202/25600 bytes, re-confirmed Conv 350 r-start). Rising each conv.
- **Next:** design a durable index architecture (NOT another `/r-prune-memory` run — that lever is maxed). The first 200 lines / 25 KB load at every SessionStart, so overflow silently truncates the newest entries.
- **Why:** degrades *every* session start; the one backlog item actively getting worse.
- **Refs:** `code.claude.com/docs/en/memory.md` (cap) · `/r-start` Step 5.7 cap-check.

---

## 📋 Unordered backlog

### [LAYOUT-SG] · standalone

`/course/[slug]` hero design call: inset (contained in the content column) vs full-bleed (edge-to-edge). Decide, then apply.

### [VITE-DEDUP] · standalone

Durable `resolve.dedupe ['react','react-dom']` / ssr fix for the Vite SSR multiple-React cold-start crash. Retires the manual `rm -rf node_modules/.vite` workaround.

### [ICN-NS] · standalone

Icon-namespace cleanup across the two icon systems (Astro path registry `icon-paths.ts` + React `icons.tsx`/`brand-icons.tsx`) and the Matt `MattIcon` registry — reconcile naming so the three don't collide/duplicate.

### [TZ-AUDIT] · standalone · [Opus]

Full timezone-correctness audit. Recurring `new Date()` issues have survived multiple sweeps; user has low confidence TZ handling is right — dedicated deep pass.

### [DOCGEN-SPEC] · standalone

Document the generated-docs regen binding + the `/r-end` Step 5c regen gate in `doc-sync-strategy.md` (the auto-regen contract is encoded in skill scripts but not written down).

### [BRAND-CASE] · standalone

App-wide "PeerLoop" → "Peerloop" casing cleanup: 45 camelCase instances in `src/` UI copy vs the canonical 168. Verify each isn't intentional stylization before bulk-replace; skip the wordmark SVG filename.

### [HOME-FIXES] · standalone (deferred per-route bucket)

Deferred bucket of per-route fixes captured while sweeping the Home (`/`) route — small issues set aside to batch later.

### [COURSES-FIXES] · standalone (deferred per-route bucket)

Same as [HOME-FIXES] but for the Courses route(s).

### [PLAN-XTRACT] · standalone

Extract bloated inline PLAN.md blocks out to `plan/<slug>/README.md`. PLAN.md is ~62K tokens — over the Read-tool limit (forced a Python-splice workaround Conv 350). Low priority.

> ## ⏸️ PARKED (blocked behind a clear gate — out of active rotation)
>
> Each revisits when its gate clears.

### [RG-PUBLIC] · ⏸️ Parked — gate: marketing redesign

Public/marketing route group sweep (the only un-swept RG-* group; RTMIG-4 closed Conv 340 with it deferred). The 14 marketing pages live only in `/old/*`; root paths 404 by design. Revisit if/when the marketing redesign is scheduled. **Refs:** `plan/route-migration/README.md § RG-PUBLIC disposition`.

### [V217-WATCH] · ⏸️ Parked — gate: new CC release

Watch the upstream Claude Code `[TERM-GARBLE]` bug (blank/partial tool output + confabulated failure under Opus 4.8 + parallel batches; unfixed as of CC 2.1.159). Re-check on new CC releases. **Refs:** memory `reference_term_garble_upstream_bug`.

### [PREFLIP-WT] · ⏸️ Parked — gate: user say-so

Tear down the preflip reference worktree (`~/projects/Peerloop-preflip` on :4331, `peerloop-ref` alias). Consequential + machine-local; the PLATO port-audit reason for keeping it has cleared. **Refs:** memory `project_preflip_worktree_reference`.

### [BROWSER-SMOKE-2B] · ⏸️ Parked — gate: post-launch · [Opus]

Evaluate an LLM-driven headless PLATO browser-mode smoke-walk executor. Do NOT resurrect Playwright E2E. **Refs:** `docs/decisions/06-testing-ci.md`.

---

## ✅ Completed this conv

- **[CT-UPDSKILL]** — built `/r-update-tasks` (preserve-then-overlay refresh engine), dry-run-verified against the live file (single clean insertion, zero row loss).
- **[CT-READ]** — flipped `/r-start` read path to active-only hydration + `CURRENT-TASKS.md` (retired conv-tasks.md regen + no-shrink guard).
- **[CT-REND]** — flipped `/r-end` Step 5 write path: refresh `CURRENT-TASKS.md` + narrative-only `RESUME-STATE.md` (Branch kept) + clear TodoWrite.
- **[CT-RCOMMIT]** — added `/r-commit` Step 0 boundary refresh.
