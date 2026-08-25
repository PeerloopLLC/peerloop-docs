# State — Conv 442 (2026-08-24 ~16:02)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Worked the **FIXES-AUG-21** client batch: (1) fleshed out Jack Elam's every-role fixture — Prompt Forge community got 4 feed posts + 5 real members (6 total), and his course got a 2nd teacher (Marcus, cert + completed enrollment); (2) found + fixed a **pre-existing seed-feeds bug** — `seed-feeds.mjs` keyed Stream community/course activities by SLUG while the app reads `client.feed(group, entity.id)`, so every seeded feed was invisible; new `streamFeedIdFor()` maps slug→entity id (all seeded feeds now render); (3) replaced random picsum user avatars with **sex-appropriate face photos** (11 local assets from randomuser.me) + neutral Admin. Then did a **full staging deploy** (app v`31733295` + cron v`a25fea00` + full reseed) — verified live. All committed; end-of-conv bookkeeping commit lands in this /r-end.

## Key Context

- **Staging is CURRENT** as of Conv 442: full destructive reseed (reset 71 tables → migrate → dev/stripe/booking/feeds) + app + cron deployed; faces render (assets shipped by the deploy). `platform_stats.environment=staging`.
- **Local-asset avatars** (`public/images/avatars/*.jpg`) render on staging only because they were deployed — a DB reseed alone would 404 them until a deploy.
- **`[STREAM-ENV]` confirmed real (probed):** seed feeds accumulate duplicate Stream activities each `--clean` reseed (16 in the local PF feed) — local+staging share one Stream DEV app, `--clean` clears D1 not Stream, fresh `time` per run. Fix needs Stream-API work (not done — see task).
- **NEXT CONV = `[CAS]`:** community avatars get a generated style (light-purple bg, white initials of non-stop title words + white star icon). Open Qs noted in the task body.
- Jack's login: `jack-elam@example.com` / `Peerloop2` (shared DEV_PASSWORD); on staging use the normal login form (dev-login is DEV-only).
- For the task backlog, see `CURRENT-TASKS.md`.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.
