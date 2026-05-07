---
name: Never write secrets or tokens into chat — user-paste OR Claude diagnostics
description: Two ways secrets reach chat — user paste, and Claude running unredacted diagnostics (stripe config --list, od -c, env, cat .dev.vars). Both burn the secret. Block both.
type: feedback
originSessionId: c98bf91a-357a-4d96-9e58-484fbe76d41e
---

Anything that lands in the chat transcript — whether the user typed it or Claude's tool output printed it — is effectively burned: chat history, telemetry, and any cache/log layer above the model can retain the value. This applies to all credential types: API keys, bearer tokens, HMAC/JWT signing secrets, DB passwords, OAuth client secrets, webhook signing secrets, recovery codes, SSH keys.

Two distinct attack surfaces, with separate trigger heuristics. Both are covered here.

---

## 1. User-paste path (original rule, Conv 113)

**Why:** On 2026-04-14 (Conv 113 era) the user pasted a fresh Cloudflare API Token verbatim into chat. The token was rotated immediately, but the incident demonstrated this can recur silently. That was the second near-miss; making it an explicit rule prevents a third.

**How to apply:**
- If the user is about to share a secret to set up an env var, **stop them** and propose the shell command instead. Example: instead of "paste your CF API token here", say "Run `npx wrangler secret put CLOUDFLARE_API_TOKEN` and paste the value at the prompt — that way it never appears in chat."
- For one-shot config (e.g., `.dev.vars`), suggest `printf "VAR=...\n" >> .dev.vars` or "open `.dev.vars` in your editor and add the line `VAR=...`" — but do not include the actual value in the command.
- If the user pastes a secret anyway, treat it as compromised: tell them to rotate immediately, do NOT echo it back, do NOT use it in subsequent commands beyond what's needed to confirm rotation succeeded.

---

## 2. Claude-initiated diagnostic path (Conv 144 extension)

**Why:** Conv 144 produced two leaks from Claude's own tool output — not user paste:
- `whsec_dc1e8988…` — partial (first 16 chars) of old Stripe webhook signing secret, from an `od -c` dump on a secret-bearing file. The key was already rotated before the leak landed, but the fact that Claude ran `od -c` without a redactor made it a near-miss for a live secret.
- `sk_test_…PP6iSq` — full Test-mode Stripe API key, from `stripe config --list` run with no output filter. Test-mode blast radius only, but still required [VL] rotation to cover the CLI-cache leak vector.

Both came from diagnostic commands that dump whole-file or whole-config contents when the investigation only actually needed a presence/absence check or a suffix identifier.

**How to apply — before running a diagnostic that *could* expose secrets:**

Ask: "If this command's output includes a secret, does the question I'm trying to answer actually require the secret value, or just a presence/absence/identifier check?" Almost always the latter.

**Unsafe patterns (do not run these against secret-bearing files or processes):**
- `cat .dev.vars` / `cat ~/.config/stripe/config.toml` / `cat *.env` — dumps full contents
- `stripe config --list` — prints all CLI-cached keys across modes
- `od -c` / `xxd` / `hexdump` on any secret-bearing file — byte-level dump, still shows secrets
- `env` — dumps entire shell environment including any exported tokens
- `head` / `tail` on `.dev.vars*`, `.env*`, or any config that may contain secrets
- `grep <pattern>` (without `-c`) against secret-bearing files — returns matching lines including adjacent secret material

**Safer alternatives for the common questions:**

| Question | Safe pattern |
|---|---|
| Does file X contain string Y? | `grep -c "Y" X` (returns integer, no content) |
| How long is file X? | `wc -l X` |
| Does file X exist? | `[ -f X ] && echo exists` |
| Which key-suffix is cached? | `grep -E "^[[:space:]]*key_name" X \| sed -E 's/(sk_\|pk_\|whsec_)[a-z]*_[A-Za-z0-9_]+/\1<suffix-only>/'` |
| What env vars are set (names only)? | `env \| awk -F= '{print $1}'` |
| What wrangler secrets are set? | `wrangler secret list` (safe — names only, no values) |

**Redactor one-liners to pipe through** when broader output *is* genuinely needed:
- Stripe: `sed -E 's/(sk\|pk)_(live\|test)_[A-Za-z0-9_]+/\1_\2_<redacted>/g; s/(whsec_)[A-Za-z0-9_]+/\1<redacted>/g'`
- JWT-shaped: `sed -E 's/ey[A-Za-z0-9_.\/-]{20,}/<jwt-redacted>/g'`
- Cloudflare / generic 40-char hex: `sed -E 's/[a-f0-9]{40,}/<hex-redacted>/g'`
- JSON configs: `jq 'del(.api_key, .test_mode_api_key, .live_mode_api_key, .webhook_secret)'`

If a diagnostic's output *must* contain a secret to be useful (very rare — usually the question reformulates to a presence check), run it in the user's shell via a direct `!` prefix or ask them to run it locally and report only the specific datum needed. Do not run it via Bash tool.

**If a Claude-initiated leak happens anyway:**
1. Flag immediately with the 🔴🔴🔴 visual alert (per CLAUDE.md §Issue Surfacing)
2. Create a `[V*]` rotation task via TaskCreate
3. Treat as compromised — rotate the secret, do NOT re-echo it in subsequent commands
4. In the end-of-conv transcript extract, the leaked value should be redacted to suffix-only form (`sk_test_...SUFFIX`) before the extract is committed
