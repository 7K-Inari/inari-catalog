# cost-guardrails (policy pack, stub)

Cost guardrails as CEL ValidatingAdmissionPolicies (`engine: cel-vap`,
Kubernetes ≥1.30). **Stub** — the request-time/render-time cost policies
live in the Policy Service (§5.11); this pack only carries the in-cluster
admission floor:

| Policy | Action | Scope |
|---|---|---|
| `cost-max-replicas` | Deny | Deployments/StatefulSets — replicas ≤ 10 |
| `cost-require-cost-center-label` | Warn/Audit | Deployments/StatefulSets — `inari.dev/cost-center` |

Follow-ups: parameterized ceilings (paramKind), per-namespace overrides,
budget-linked policies.

## Tests

`tests/run.sh` applies the pack on kind ≥1.30 and asserts a denial above the
replica ceiling and admission of a compliant workload.
