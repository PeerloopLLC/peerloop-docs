# State — Conv 417 (2026-07-26 ~06:50)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Started from a one-line UI complaint — "Ask … a Question" on the course Peer Teachers / Meet the Creator tabs navigated away from the course page — and ended up fixing a site-wide auth bug. Built a shared **`MessageUserButton`** island that opens the existing `NewConversationModal` in place (signed-out viewers keep the `/messages?to=` login bounce), added a **discard guard** and an opt-in **"Open in Messages"** escape hatch to that modal, and fixed a silently-swallowed failed POST. Then swept all 23 message affordances, and while measuring for the follow-up plan discovered **`[MSGBOOT]`** — a pre-existing current-user bootstrap race with two live symptoms — and fixed it (M1). Committed as code `1f7bfd79` + docs `7ec640f`, both pushed at close. 5 gates green throughout; suite ended at **6568**.

## Key Context

- **Next conv starts at M2 `[CANMSG]`, not M1.** M1 landed this conv. The 6-step MESSAGES mini-plan (M1–M6) is sequenced at the top of `CURRENT-TASKS.md § 🎯 Now` with its dependencies written into the preamble: hard M1→M2, soft M3→M4/M5, and M4/M5 independently shippable (so the programme can legitimately stop after M4).
- **M2 has a real undecided fork**, both options in the task body: drop the client `canMessage` gate entirely (open messaging, Conv 110, makes it near-vacuous and the API is authoritative) versus batch it via the existing server-side `getMessageableFlags`. It is tagged `[Opus]` for that reason. ⚠️ **Re-measure before deciding** — the Conv-417 numbers predate M1, which now makes the per-row fan-out fire on *every* load rather than warm loads only.
- **`[MSG-ICON]` (M3) is the structural blocker for adoption.** Only 3 of the 22 per-user message affordances are `Button` components; the other 19 are bespoke icon-only `<a>` tags with per-site classNames. `MessageUserButton` renders a `Button`, so M4/M5 are **not** an href swap — the icon variant has to exist first.
- **The `authStatus` three-state already existed** (`AuthStatus`, `useAuthStatus()` in `src/lib/current-user.ts`), and `StudentDashboard` / `ProgressionNudge` / `useCreatorGate` already gate on it. M1 was two consumers joining that pattern — not the SSR-seeding rework the task had proposed. Worth remembering before designing state mechanisms here.
- **Cold-vs-warm is a distinct test axis.** Both `[MSGBOOT]` symptoms were invisible to a warm browser; they only appeared using `browser.newContext()` per probe. Any verification touching a client cache needs first-visit as an explicit case.
- **`/messages?to=` is thread-aware** (`MessagesCenter:104-110`) — it selects an existing conversation and only falls back to the composer when there is none. That is why the "Open in Messages" exit needed no new plumbing, and it is the fact that makes broad adoption safe rather than a trade-off.
- **`MSG-TEACHER` (DEFERRED #16) was archived to `plan/COMPLETED.md`** by the r-end plan agent as satisfied by Convs 416–417. Flagged to the user and accepted; reversible with a two-file edit if it was scoped more broadly than the course page.
- **Dev server left running on `:4321`** (pid 97315, ephemeral). It was found bound-but-dead at conv start — the `[DEVSRV-STALE]` pattern, now un-parked with its root cause recorded.
- For the task backlog, see `CURRENT-TASKS.md` — do not re-list here.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.
