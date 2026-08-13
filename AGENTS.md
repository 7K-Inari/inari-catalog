# inari-catalog — Agent Guide

Curated package catalog for Inari: KRO ResourceGraphDefinitions (golden-path templates), platform-app Helm charts, UI-schema hints, policy packs; CI publishes signed OCI artifacts to `stable`/`incubating` channels (plan §5.5, §6 #8).

Stack: YAML, CEL, Helm, KRO RGDs, OPA/Rego tests, OCI artifacts (cosign-signed)

## Key architecture constraints
- Curated packages are **KRO ResourceGraphDefinitions**: single YAML, CEL type-checked/terminating, generates CRD + controller dynamically (§4.3, §5.5).
- Published as versioned OCI artifacts with channels (`stable`, `incubating`); content ships on its own release cadence, faster than binaries (§6).
- Every package: docs + tests (render/validation tests in CI); artifacts cosign-signed (§5.10).
- Policy packs (Kyverno or CEL ValidatingAdmissionPolicies) live here too (e.g. `baseline-security`, `cost-guardrails`) (§5.11).

## Conventions
- Conventional Commits; SemVer releases; container images/artifacts cosign-signed (once CI exists).
- Write tests for new behavior; keep changes minimal and focused.
- Canonical architecture & development plan: https://github.com/7K-Inari/inari-docs/blob/main/docs/architecture/inari-platform-plan.md (section references below point into it).

## Platform design principles (apply everywhere)
1. Tenant-aware to the core — every object carries a tenant ID; every API decision is tenant-scoped.
2. Zero tenant credentials on the hub — no tenant kubeconfigs or cloud keys in the control plane.
3. Pull, never push — agents dial out; the control plane never initiates connections into tenant networks.
4. Desired state, eventually reconciled — GitOps/CR-based mutations, not imperative RPCs.
5. The catalog is a projection of reality — capabilities are discovered, not declared.
6. Small kernel, everything else extension.
7. Modular monolith first — strict internal module boundaries.
