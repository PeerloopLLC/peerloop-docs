# Peerloop Auto Memory

## Quick References

- **Stream.io details:** `docs/tech/tech-002-stream.md` (env setup, feed groups, key files, follow relationships)
- **Migration system:** `docs/tech/tech-024-migrations.md` (split seed strategy, commands)
- **OAuth setup:** `docs/tech/tech-025-google-oauth.md` (Google + GitHub setup instructions, blocked on client)
- **Auth stack:** `docs/tech/tech-010-auth-libraries.md` (jose, bcryptjs, arctic)

## Stream.io Quick Facts

- DEV app ID: `1457190` (local + CF Preview)
- PROD app ID: `1456912` (CF Production)
- Feed groups: `townhall`, `course`, `community`, `timeline`, `notification`
- `instructor` feed was **removed** (Session 190). Use `community` instead.
- Node SDK incompatible with CF Workers — uses REST API via `src/lib/stream.ts`

## Cloudflare Secrets Status (Session 193)

| Secret | Local | CF Preview | CF Production |
|--------|:-----:|:----------:|:-------------:|
| JWT_SECRET | ✅ | ✅ | ✅ |
| RESEND_API_KEY | ✅ | ✅ | ✅ |
| STREAM_API_KEY | ✅ | ✅ | ✅ |
| STREAM_API_SECRET | ✅ | ✅ | ✅ |
| STREAM_APP_ID | ✅ | ✅ | ✅ |
| STRIPE_PUBLISHABLE_KEY | ✅ | ❌ | ❌ |
| STRIPE_SECRET_KEY | ✅ | ❌ | ❌ |
| STRIPE_WEBHOOK_SECRET | ✅ | ❌ | ❌ |
| GOOGLE_CLIENT_ID | commented | ❌ | ❌ |
| GOOGLE_CLIENT_SECRET | commented | ❌ | ❌ |
| GITHUB_CLIENT_ID | commented | ❌ | ❌ |
| GITHUB_CLIENT_SECRET | commented | ❌ | ❌ |

**Action needed:** Add 3 Stripe secrets to CF. OAuth secrets blocked on client app registration.

## Migration Commands

- `db:setup:local` — Full dev setup (with test data)
- `db:setup:local:clean` — Production-like (no test data)
- `db:migrate:prod` — Production (requires confirmation)
- `db:seed:prod` — 🚫 BLOCKED
- `db:reset:prod` — 🚫 BLOCKED
