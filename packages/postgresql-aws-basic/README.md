# postgresql-aws-basic

Basic AWS RDS PostgreSQL instance via Crossplane (`rds.aws.upbound.io/Instance`).
Connection details (host, port, username, password) are written to the
`<name>-conn` Secret in the target namespace.

**Incubating stub** — intentionally minimal; VPC/subnet-group composition,
backup policy, and IRSA-scoped ProviderConfig wiring land with the M3
Crossplane milestone.

## Prerequisites

- kro
- Crossplane + provider-aws-rds CRDs, with a per-account `ProviderConfig`

## Parameters

| Name | Type | Default | Description |
|---|---|---|---|
| `name` | string | — (required) | RDS instance name. |
| `namespace` | string | `default` | Namespace for the connection Secret. |
| `region` | string | `us-east-1` | AWS region. |
| `engineVersion` | string | `16` | PostgreSQL major version. |
| `instanceClass` | string | `db.t3.micro` | RDS instance class. |
| `allocatedStorage` | integer | `20` | Storage in GiB. |
| `databaseName` | string | `app` | Initial database name. |
| `publiclyAccessible` | boolean | `false` | Public endpoint (normally false). |

## Example

```yaml
apiVersion: kro.run/v1alpha1
kind: PostgresAWS
metadata:
  name: orders-db
spec:
  name: orders-db
  namespace: payments
  instanceClass: db.t3.small
  allocatedStorage: 50
```
