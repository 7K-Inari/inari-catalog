# s3-backed-app

Application (`Deployment` + `Service`) with an AWS S3 bucket provisioned by
Crossplane (`s3.aws.upbound.io/Bucket`). The bucket's connection details are
written to the `<name>-bucket` Secret in the app namespace.

**Incubating** — IAM wiring (least-privilege access policy/role) lands with the
M3 Crossplane work; today the app receives bucket name/region via env vars and
is expected to use pod identity (IRSA) supplied cluster-side.

## Prerequisites

- kro
- Crossplane + provider-aws-s3 CRDs, with a per-account `ProviderConfig`

## Parameters

| Name | Type | Default | Description |
|---|---|---|---|
| `name` | string | — (required) | Name for app and bucket resources. |
| `namespace` | string | `default` | App namespace. |
| `image` | string | — (required) | Container image. |
| `replicas` | integer | `1` | Replica count. |
| `port` | integer | `8080` | Container port. |
| `bucketPrefix` | string | `""` | Optional bucket-name prefix. |
| `region` | string | `us-east-1` | AWS region for the bucket. |
| `bucketVersioning` | boolean | `false` | Enable S3 versioning. |

## Example

```yaml
apiVersion: kro.run/v1alpha1
kind: S3BackedApp
metadata:
  name: uploads
spec:
  name: uploads
  image: ghcr.io/acme/uploader:0.3.1
  region: eu-west-1
  bucketVersioning: true
```
