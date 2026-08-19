# s3-backed-app

Application (`Deployment` + `Service`) with an AWS S3 bucket provisioned by
Crossplane (`s3.aws.upbound.io/Bucket`). Every AWS managed resource is pinned
to a per-account `ProviderConfig` via `providerConfigRef` (platform plan
§5.7). The bucket is encrypted (SSE-S3/AES256) and has a full public access
block; the bucket's connection details are written to the `<name>-bucket`
Secret in the app namespace.

## IRSA (pod identity)

The workload runs under a dedicated `ServiceAccount`. Two modes:

- `createIrsaRole: true` — the graph creates an IAM role (web-identity trust
  conditioned on the ServiceAccount `sub`/`aud`), a bucket-scoped least
  privilege policy, and attaches them; the ServiceAccount is annotated with
  the created role ARN. Requires `oidcProviderArn` and `oidcIssuer` of the
  target cluster (plain EKS IRSA for tenant clusters; see the
  `postgresql-aws` README for both keyless run contexts).
- `createIrsaRole: false` (default) — supply an existing `irsaRoleArn` and it
  is annotated on the ServiceAccount.

## Prerequisites

- kro
- Crossplane + provider-aws-s3 and provider-aws-iam CRDs, with a per-account
  `ProviderConfig`

## Parameters

| Name | Type | Default | Description |
|---|---|---|---|
| `name` | string | — (required) | Name for app and bucket resources. |
| `namespace` | string | `default` | App namespace. |
| `image` | string | — (required) | Container image. |
| `providerConfigName` | string | — (required) | Per-account Crossplane `ProviderConfig`. |
| `replicas` | integer | `1` | Replica count. |
| `port` | integer | `8080` | Container port. |
| `bucketPrefix` | string | `""` | Optional bucket-name prefix. |
| `region` | string | `us-east-1` | AWS region for the bucket. |
| `bucketVersioning` | boolean | `false` | Enable S3 versioning. |
| `createIrsaRole` | boolean | `false` | Create IAM role/policy for the workload in-graph. |
| `irsaRoleArn` | string | `""` | Existing role ARN when not creating one. |
| `oidcProviderArn` | string | `""` | Cluster IAM OIDC provider ARN (with `createIrsaRole`). |
| `oidcIssuer` | string | `""` | Cluster OIDC issuer hostpath (with `createIrsaRole`). |

## Status

`bucketName`, `bucketArn`, `ready` (bucket Ready condition).

## Example

```yaml
apiVersion: kro.run/v1alpha1
kind: S3BackedApp
metadata:
  name: uploads
spec:
  name: uploads
  image: ghcr.io/acme/uploader:0.3.1
  providerConfigName: dev-account
  region: eu-west-1
  bucketVersioning: true
  createIrsaRole: true
  oidcProviderArn: arn:aws:iam::123456789012:oidc-provider/oidc.eks.eu-west-1.amazonaws.com/id/EXAMPLE
  oidcIssuer: oidc.eks.eu-west-1.amazonaws.com/id/EXAMPLE
```

## Validation

- **CI (mocked):** `tests/run.sh` runs on kind + kro with stub s3/iam CRDs
  (`tests/deps/`), asserts all MRs render with the right `providerConfigRef`,
  and that IRSA resources only render when `createIrsaRole` is set.
- **Dev account (dry-run):** `kubectl apply --dry-run=server -f
  tests/instance-full.yaml` against a cluster with a real ProviderConfig.
