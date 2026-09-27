---
name: feedback_staging_is_deploy_target_prod_gated
description: Staging is the only deploy target for feature work; prod deploy is gated behind the MVP-GOLIVE launch event — never run deploy:prod / deploy:cron:prod for features
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 16fc6f4a-5312-4217-b9e6-a719a8c52ec0
---

For all feature/development work the **deploy target is staging** (`deploy:staging`, `deploy:cron:staging`). **Production has never been deployed:** `main` is undeployed, no prod secrets set, prod D1 (`peerloop-db`) unmigrated, no prod domain/OAuth. A real prod go-live is the **MVP-GOLIVE launch event** (`plan/mvp-golive/`, status ⏸️ DEFERRED until launch decision) with a gated execution order (Domain → Cloudflare → Resend → OAuth → Stream → Stripe → BBB). Related: [[project_staging_integration_plan]], [[reference_staging_url]].

**Why:** "deploy" in this project has meant *staging* the entire dev phase, but the npm scripts expose real `:prod` targets gated only by an interactive `confirm-prod.js` stdin prompt. RESUME-STATE/PLAN sometimes write "prod deploy" loosely for a feature; taking that literally pushes unready infra to prod from an unmerged dev branch, and satisfying `confirm-prod.js` programmatically removes the one human checkpoint that would catch it.

**How to apply:** Treat any "prod deploy" line in a *feature* task as **mis-scoped → fold into MVP-GOLIVE**, do NOT execute it. NEVER run `deploy:prod` / `deploy:cron:prod` for feature work; never auto-answer `confirm-prod.js`. Conv 262: DISCOVERY-RAILS #30's "prod deploy" was taken literally → `peerloop-cron` deployed to prod from `jfg-dev-13-matt`, then **deleted the same conv** to restore the not-deployed state. The prod cron deploy already lives — gated — in MVP-GOLIVE.CRON-CLEANUP (it now also runs `refreshDiscoveryRails`).
