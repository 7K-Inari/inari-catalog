# postgresql-aws

AWS RDS PostgreSQL via Crossplane `provider-aws`, packaged as a KRO
ResourceGraphDefinition. Every managed resource is pinned to a per-account
Crossplane `ProviderConfig` via `providerConfigRef` — one ProviderConfig per
onboarded AWS account, so tenant A's databases can only act in tenant A's
account (platform plan §5.7).

## Prerequisites

1. Crossplane + `provider-aws-rds` installed on the target cluster.
2. A `ProviderConfig` per AWS account (created by AWS account onboarding):

```yaml
apiVersion: aws.upbound.io/v1beta1
kind: ProviderConfig
metadata:
  name: dev-account
spec:
  credentials:
    source: IRSA   # platform cluster; see "Run contexts" below
```

No long-lived AWS keys are stored anywhere — authentication is always
short-lived web-identity sessions.

## Run contexts (§5.7)

Both run contexts are keyless; they differ only in **whose OIDC issuer the AWS
role trusts**.

### Platform cluster (Inari-operated)

Used for platform-scoped cloud resources and the Tenant Zone Factory. The
provider pod's ServiceAccount is annotated with the platform bootstrap role
ARN; the platform cluster's EKS OIDC issuer vends a web-identity token, and
the provider assumes the role via `sts:AssumeRoleWithWebIdentity`
(`ProviderConfig.spec.credentials.source: IRSA`). To act **inside a tenant
account**, the per-account ProviderConfig role-chains into that account's
onboarding role, which trusts the platform cluster's OIDC issuer conditioned
on `sub` (the provider ServiceAccount) and `aud = sts.amazonaws.com`.

### Tenant cluster (developer-installed)

Manages the tenant's own AWS resources in their own account. If the tenant
cluster is EKS in that account this is plain IRSA against the *tenant
cluster's* OIDC issuer; on non-EKS clusters the same web-identity flow works
if the cluster's OIDC issuer is publicly reachable (e.g. S3-hosted discovery
document).

### Onboarding role trust policy (created by "Connect AWS account")

```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": {"Federated": "arn:aws:iam::<account>:oidc-provider/<cluster-oidc-issuer>"},
    "Action": "sts:AssumeRoleWithWebIdentity",
    "Condition": {
      "StringEquals": {
        "<cluster-oidc-issuer>:aud": "sts.amazonaws.com",
        "<cluster-oidc-issuer>:sub": "system:serviceaccount:crossplane-system:provider-aws-*"
      }
    }
  }]
}
```

The role is least-privilege (scoped to the services Inari manages); tenants
revoke access by deleting the role.

## Usage

```yaml
apiVersion: kro.run/v1alpha1
kind: PostgreSQLAWS
metadata:
  name: orders-db
spec:
  name: orders-db
  providerConfigName: dev-account   # required
  region: eu-west-1
  instanceClass: db.t3.small
  multiAZ: true
  deletionProtection: true
```

Status exposes `endpoint`, `port`, and `ready`; the connection secret
`<name>-conn` (username/password/host/port) is written to `spec.namespace`.

## Validation

- **CI (mocked):** `tests/run.sh` runs on kind + kro with a stub
  `instances.rds.aws.upbound.io` CRD (`tests/deps/`) and asserts the rendered
  MRs, including `providerConfigRef` wiring.
- **Dev account (dry-run):** with a real ProviderConfig in place,
  `kubectl apply --dry-run=server -f tests/instance-full.yaml` validates the
  generated CRD schema; applying for real provisions against the dev account.
