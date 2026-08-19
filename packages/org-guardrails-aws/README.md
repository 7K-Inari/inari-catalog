# org-guardrails-aws

Org-side guardrails applied to every vended AWS account (platform plan §5.12
step 2), packaged as a KRO RGD composed of Crossplane MRs pinned to the
vended account's ProviderConfig:

- **CloudTrail** — multi-region audit trail, global service events, log-file
  validation, into a dedicated S3 bucket.
- **Budget alert** — monthly COST budget with 80% forecasted and 100% actual
  email notifications, filtered on the mandatory `inari.dev/cost-center` tag.
- **Mandatory cost tags** — enforced at request time by `tenant-zone-aws`
  (the tags are stamped on the account and all zone resources).

The in-cluster admission baseline (`baseline-security`, `cost-guardrails`)
ships as separate CEL-VAP policy packs.

## Parameters

| Name | Type | Default | Description |
|---|---|---|---|
| `accountName` | string | — (required) | Zone/account name; names the Trail and Budget. |
| `providerConfigName` | string | — (required) | ProviderConfig for the vended account. |
| `region` | string | `eu-west-1` | Home region. |
| `trailBucketName` | string | — (required) | S3 bucket for CloudTrail logs. |
| `monthlyBudgetUsd` | integer | `200` | Monthly budget ceiling. |
| `budgetAlertEmail` | string | — (required) | Alert recipient. |
| `costCenter` | string | — (required) | Mandatory cost tag. |

## Status

`trailArn`, `ready`.

## Validation

`tests/run.sh` (kind + kro, stub cloudtrail/budgets CRDs) asserts the graph
renders with multi-region trail, both budget notifications, and
ProviderConfig wiring.
