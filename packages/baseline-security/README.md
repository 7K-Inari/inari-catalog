# baseline-security (policy pack)

Baseline in-cluster admission guardrails (platform plan §5.11), implemented
as CEL **ValidatingAdmissionPolicies** (`engine: cel-vap`, Kubernetes ≥1.30)
so tenant clusters need no extra policy engine. Distributed to ClusterSets
via fleet rollout; versioned and OCI-signed like every catalog package.

| Policy | Action | Scope |
|---|---|---|
| `baseline-disallow-latest-image` | Deny | Pods (non-system namespaces) |
| `baseline-require-resources` | Deny | Pods — cpu/memory requests + memory limit |
| `baseline-disallow-privileged` | Deny | Pods — privileged, hostNetwork, hostPath |
| `baseline-require-tenant-label` | Deny | Deployments/StatefulSets — `inari.dev/tenant` |
| `baseline-readonly-rootfs` | Warn/Audit | Pods — read-only root filesystem |

Notes:
- System namespaces (`kube-system`, `kube-node-lease`, `kube-public`) are
  excluded via the bindings' namespaceSelector.
- Checks cover `spec.containers`; initContainer coverage is a follow-up.
- Exemptions are time-boxed and approval-gated in the Policy Service (§5.11),
  not by editing these policies.

## Tests

`tests/run.sh` (runs on kind ≥1.30 in CI) applies the pack and asserts real
admission denials for violating fixtures and admission for the compliant one.
