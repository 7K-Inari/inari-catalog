# external-secrets (platform app)

External Secrets Operator on the platform cluster (§5.6). SecretStores are
namespaced per tenant (§5.10) and reconciled by `inari-operator`; this app
only provides the controller.

## Chart

- repo: https://charts.external-secrets.io
- chart: `external-secrets`
- channels: `stable` / `incubating` (see `chart.yaml`)

```sh
helm template external-secrets external-secrets \
  --repo https://charts.external-secrets.io \
  --version "$(yq '.channels.stable' chart.yaml)" \
  --namespace external-secrets -f values-defaults.yaml
```
