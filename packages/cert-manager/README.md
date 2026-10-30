# cert-manager (platform app)

cert-manager as a first-class cluster addon: certificate issuance for tenant
clusters and platform apps. Installed, adopted, and version/values-managed
via the inari-ui cluster addons surface; ClusterIssuers ship as native
manifests in the tenant state repo (rendered by inari-server's
source-agnostic renderer).

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

## Values schema

`values.schema.json` is vendored from the upstream chart (same chart version
as the `stable` channel). inari-server enforces it on addon adopt/update
with 422 field-level errors; `tests/run.sh` asserts `values-defaults.yaml`
stays schema-valid.

