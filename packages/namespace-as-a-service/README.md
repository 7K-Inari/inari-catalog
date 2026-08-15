# namespace-as-a-service

Self-service tenant namespace: a `Namespace` with a `ResourceQuota`, a
`LimitRange` (sane container defaults), and optional RBAC `RoleBinding`s for an
admin and a viewer group.

KRO generates a `TenantNamespace` CRD from this ResourceGraphDefinition; the
Inari console renders the deploy form from that CRD's schema plus
[`ui-hints.yaml`](./ui-hints.yaml).

## Prerequisites

- kro installed on the target cluster (no other dependencies).

## Parameters

| Name | Type | Default | Description |
|---|---|---|---|
| `name` | string | — (required) | Namespace to create (DNS-1123). |
| `team` | string | — (required) | Owning team/tenant; applied as `inari.dev/tenant` label. |
| `labels` | map | `{}` | Extra namespace labels. |
| `cpuLimit` | string | `"4"` | ResourceQuota CPU limit ceiling. |
| `memoryLimit` | string | `"8Gi"` | ResourceQuota memory limit ceiling. |
| `maxPods` | integer | `50` | ResourceQuota pod ceiling. |
| `adminGroup` | string | `""` | Keycloak group granted `edit` in the namespace. |
| `viewerGroup` | string | `""` | Keycloak group granted `view` in the namespace. |

## Example

```yaml
apiVersion: kro.run/v1alpha1
kind: TenantNamespace
metadata:
  name: payments-team
spec:
  name: payments
  team: acme-payments
  cpuLimit: "8"
  memoryLimit: 16Gi
  maxPods: 100
  adminGroup: tenant-acme/payments-admins
  viewerGroup: tenant-acme/payments-viewers
```

See `tests/` for minimal/full instances validated in CI.
