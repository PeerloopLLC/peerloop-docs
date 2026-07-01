# Vernacular — acronym & shorthand glossary

> A living lookup of the acronyms / shorthand we use, so they're easy to find. **Terse by design.**
> 3 columns: **Acronym · Literal meaning · Context / comments.** Alphabetical (Ctrl-F friendly).
> CC appends new acronyms here as they come up in conversation. Not a source of truth — see the linked docs/CLAUDE.md for detail.

| Acronym | Literal meaning | Context / comments |
|---------|-----------------|--------------------|
| **2 Sigma Problem** | Bloom's "2 sigma" finding | The core problem Peerloop targets: 1:1 tutoring beats group teaching by ~2σ. Peerloop makes peer tutoring affordable to close the gap. |
| **BBB** | BigBlueButton | Video-conferencing provider, abstracted behind the VideoProvider interface (alongside PlugNmeet). |
| **CC** | Claude Code | This CLI assistant. In Peerloop, CC is the **sole author** of project files (user hands-off). |
| **CD** | Client Directive (note) | Raw client change input under `docs/requirements/rfc/CD-XXX/`; processed into an RFC via `/w-add-client-note`. |
| **CoW** | Copy-on-Write | Cheap clone that only diverges on write — the model behind git **worktrees** (e.g. `Peerloop-preflip` reference worktree, agent-isolation worktrees) and APFS file clones. |
| **conv** | Conversation | Unit of tracked work (replaced "Session"). Counter in `CONV-COUNTER`; lifecycle `/r-start` → `/r-commit` → `/r-end`. |
| **conv-tasks.md** | (scratch file — RETIRED) | Former `.scratch/` TodoWrite companion; **retired Conv 351** when task state moved to the git-tracked `CURRENT-TASKS.md`. Still appears in older session docs. |
| **conv-turns.md** | (scratch file) | `.scratch/` companion: turn-by-turn Q/A re-orientation log (question in full + terse reply). Seeded each conv by `/r-start`. |
| **CURRENT-TASKS.md** | (root file) | The persistent, git-tracked task store (🔥 Ordered / 📋 Unordered backlog + ⏸️ Parked / ✅ Completed-this-conv). Hand-editable; refreshed at `/r-commit` + `/r-end`. Replaced `conv-tasks.md` (Conv 351). |
| **D1** | Cloudflare D1 | SQLite-based edge database; Peerloop's primary DB. |
| **DNS** | Domain Name System | Relevant to the `peerloop.com` cutover between Cloudflare Pages and Workers (an MVP-GOLIVE step). |
| **DO** | Durable Objects | Cloudflare primitive — **not used** in Peerloop. |
| **DOM** | Document Object Model | "DOM-truth": for precise layout/visibility, trust `getComputedStyle` / `getBoundingClientRect` / `elementFromPoint` over screenshots. |
| **DR** | Disaster Recovery | Data-recovery floors (D1 Time Travel, R2 Bucket Locks, KV no-PITR). An MVP-GOLIVE concern. |
| **E2E** | End-to-End (tests) | Playwright suite, separate from the unit suite. Migration tracked by [E2E-MIG] / [E2E-GATE]. |
| **JWT** | JSON Web Token | Peerloop's custom auth / session mechanism. |
| **KV** | Key-Value (Cloudflare KV) | SESSION cache only; no point-in-time recovery, deletion permanent. |
| **MCP** | Model Context Protocol | External tool servers (Figma, Claude-in-Chrome). |
| **MOOC** | Massive Open Online Course | Completion-rate benchmark (15–20%) vs Peerloop's ≥75% target. |
| **MVP** | Minimum Viable Product | — |
| **MVP-GOLIVE** | (PLAN block) | Gates the production launch; prod is undeployed + gated behind it. Staging is the only feature deploy target. |
| **PITR** | Point-In-Time Recovery | DB/storage DR capability. KV has none. |
| **PLATO** | (project harness) | Peerloop's browser-run / browser-testing harness (see `memory/plato-context.md`). |
| **PR** | Pull Request | Via the `gh` CLI; `/code-review` and ultrareview operate on the branch or a PR. |
| **prov** | Provenance | The 3-marker page convention: `@stand-in` / `@matt-source` / `@matt-inspired`. |
| **QLINT** | Question Lint | Retired Stop-hook that flagged malformed user-facing questions. Superseded Conv 273 by routing all decisions through `AskUserQuestion`. |
| **R2** | Cloudflare R2 | S3-compatible object storage; no versioning (uses Bucket Locks + backup copy). |
| **RFC** | Request For Change | Client-driven change requests under `docs/requirements/rfc/` (built from CD-XXX notes). |
| **RG-\*** | Route Group | A route-sweep task within RTMIG-4 (RG-COURSES, RG-ADMIN, RG-AUTH…). 14 groups total. |
| **RTMIG** | Route Migration | RTMIG-4 = the current full route **visual-presentation sweep** (~50 routes, 14 RG-* groups, per-route PAUSE protocol). |
| **r-start / r-commit / r-end** | (lifecycle skills) | begin/resume · save-and-continue · close-with-agents-and-push. |
| **SNAV-TOP / SUBNAV-TO-TOP** | (task code) | Move the page-section SubNav from the desktop vertical-left rail to a horizontal strip at the top of the content panel at all sizes. Conv 354: global `SUBNAV_LAYOUT` toggle (`src/lib/subnav-layout.ts`). Phase 1 = flat pages flipped (rail restorable by flipping the constant); Phase 2 = redesign the zoned course-enrollment journey as a horizontal stepper. |
| **SOP** | Standard Operating Procedure | **Our route-sweep SOP** (RTMIG-4): the canonical 8-step process per route — assess Tier-1 + Tier-2 → surface → **PAUSE** → do ripe porting/extraction → browser-verify (member+visitor) → user out-of-scope review → mark ☑ Swept. Per-route "SOP pointers" are added as routes are swept. |
| **SoT** | Source of Truth | — |
| **SSG / SSR** | Static Site Generation / Server-Side Rendering | Astro render modes (React islands). |
| **Tier-1 / Tier-2** | (route-sweep layers) | Tier-1 = page-level presentation treatment; Tier-2 = primitive-extraction candidates (surfaced via `/w-prim-candidates` → ledger). Both are ported during a route's sweep. |
| **TZ** | Timezone | Recurring `new Date()` correctness concern; tracked by [TZ-AUDIT]. |
| **VT** | View Transition | Astro client-side navigation transitions. |
| **WIP** | Work In Progress | — |
| **WORM** | Write Once, Read Many | R2 Bucket Locks immutability — a DR safeguard for backups. |
| **w-\* / q-\*** | (skill namespaces) | `w-` = work/utility skills (codecheck, sync-docs…); `q-` = quick/legacy skills. |
