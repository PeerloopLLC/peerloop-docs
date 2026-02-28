# Session Decisions - 2026-02-28 (Session 313)

## 1. Use Platform Detection for CI Instead of CF_PAGES Env Var
**Type:** Implementation
**Topics:** testing, cloudflare, deployment

**Trigger:** CF_PAGES env var was not set during the test phase of CF Pages builds, so the test header still showed "Machine: unknown" after deploying the initial fix.

**Options Considered:**
1. Check `CF_PAGES === '1'` env var — not reliably set during test phase
2. Check `process.platform !== 'darwin'` (Linux vs macOS) ← Chosen
3. Check `CI === 'true'` env var — more standard but not guaranteed on CF Pages
4. Combination of all three — belt and suspenders

**Decision:** Use `process.platform !== 'darwin'` as primary CI detection, with `CF_PAGES` and `CI` env vars as additional signals. All three are checked in `isCI()`.

**Rationale:** Platform check is the most reliable — CF builds always run on Linux, dev machines are always macOS. Env var checks are additive safety but not required.

**Consequences:** Test header now shows `Machine: CI` with platform info on CF builds, and hides the irrelevant Wrangler D1 line. `isCloudflarePages()` kept as deprecated alias for backward compatibility.
