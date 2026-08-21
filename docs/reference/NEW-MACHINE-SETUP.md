# New Dev Machine Setup

Get a fresh machine to a **fully-seeded local Peerloop** with every capability exercisable
(students, teachers, creators, admins, Stripe, booking, feeds). Local only — no Cloudflare auth
required. For deeper operational detail see [DEVELOPMENT-GUIDE.md](DEVELOPMENT-GUIDE.md); for the
seed model see [DB-GUIDE.md](DB-GUIDE.md).

Category: **manual** (editorial — not auto-maintained).

---

## Prerequisites

| Tool | Version | Notes |
|------|---------|-------|
| Node | **22.19.0** | Pinned in `.nvmrc` + `package.json` engines. `nvm use` in `Peerloop/`. |
| npm | ≥ 10 | Ships with Node 22. |
| git | any recent | |

Wrangler, Vitest, Astro, etc. are project **devDependencies** — installed by `npm install`, not
separately. **No `wrangler login`** is needed for local work (`--local` uses miniflare's own
SQLite/R2; Cloudflare auth is only for staging/remote).

---

## Steps

**1. Clone both repos as siblings.** The dual-repo layout is load-bearing (the docs repo adds the
code repo via `--add-dir`):

```bash
mkdir -p ~/projects && cd ~/projects
git clone <peerloop-docs remote> peerloop-docs
git clone <Peerloop remote>      Peerloop
```

**2. Install dependencies (code repo):**

```bash
cd ~/projects/Peerloop
nvm use          # picks up .nvmrc → 22.19.0
npm install
```

**3. Secrets — create `.dev.vars`:**

```bash
cp .dev.vars.example .dev.vars
```

Then fill in the real values (get them from a secure channel — they are **not** in git). Astro/Vite
read them via the `.env → .dev.vars` symlink, which the env-check hook expects.

**4. Seed the database with all capabilities:**

```bash
npm run db:setup:local:feeds
```

This is the **top of the cumulative `db:setup:local:*` chain** (the name is misleading — `:feeds` is
the *superset*, not just feeds). In order it: resets local D1 → applies migrations (schema + core
seed) → dev test data → feed data → R2 assets → **Stripe** test data → **booking** test data →
re-cleans feeds.

> `db:setup:local:dev` (CLAUDE.md's "standard") stops after dev+feeds+R2 — **no Stripe, no booking**.
> Use `:feeds` for the full set. Intermediate levels exist if you want less:
> `:dev` ⊂ `:stripe` ⊂ `:booking` ⊂ `:feeds`.

**5. Run it:**

```bash
npm run dev        # astro dev → http://localhost:4321
```

Use `localhost`, not `127.0.0.1` (`astro dev` binds `[::1]` only).

---

## Logging in

The dev seed creates test users across every role. Sign in without a real password via the dev-login
endpoint `POST /api/auth/dev-login` (`src/pages/api/auth/dev-login.ts`) — seeded accounts are defined
in `migrations-dev/0001_seed_dev.sql`.

---

## Optional extras

- **PLATO test seed** — `npm run db:seed:plato` (only if doing PLATO test work; not part of normal app
  capabilities). See [PLATO-GUIDE.md](PLATO-GUIDE.md).
- **Staging** — `npm run db:setup:staging:feeds` (requires `wrangler login` + remote D1 access). Staging
  is the only deploy target; production is gated.

---

## Troubleshooting

- **Env-check hook fails at session start** — it validates Node/npm/Wrangler/Stripe-CLI/`.dev.vars`.
  Re-check whichever line is red.
- **A route 500s with `The file does not exist at ".../node_modules/.vite/deps_ssr/…"`** — stale Vite
  dep-optimizer cache: `npx astro dev stop` → `rm -rf node_modules/.vite` → restart. (Never port-kill;
  `lsof -ti` returns Chrome.) See `memory/reference_devserver_stale_daemon`.
- **Re-seed from scratch anytime** — just re-run `npm run db:setup:local:feeds` (it resets first).
