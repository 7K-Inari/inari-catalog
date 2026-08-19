# cert-manager (platform app)

cert-manager on the platform cluster (§5.6): certificate issuance for the
control plane and platform apps. ClusterIssuers are platform-scoped resources
reconciled by `inari-operator`.

## Chart

- repo: https://charts.jetstack.io
- chart: `cert-manager`
- channels: `stable` / `incubating` (see `chart.yaml`)

Defaults: CRDs enabled, HA controller/webhook/cainjector, Prometheus
ServiceMonitor.

```sh
helm template cert-manager cert-manager \
  --repo https://charts.jetstack.io \
  --version "$(yq '.channels.stable' chart.yaml)" \
  --namespace cert-manager -f values-defaults.yaml
```
