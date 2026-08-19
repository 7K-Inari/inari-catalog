# monitoring-stack (platform app)

kube-prometheus-stack on the platform cluster (§5.6): Prometheus, Grafana,
and Alertmanager for the control plane and platform apps. ServiceMonitors
shipped by the other platform apps (`keycloak`, `cert-manager`,
`external-secrets`, `argocd`) are picked up via
`serviceMonitorSelectorNilUsesHelmValues: false`.

## Chart

- repo: https://prometheus-community.github.io/helm-charts
- chart: `kube-prometheus-stack`
- channels: `stable` / `incubating` (see `chart.yaml`)

Grafana admin credentials come from ESO, never from values files.

```sh
helm template monitoring kube-prometheus-stack \
  --repo https://prometheus-community.github.io/helm-charts \
  --version "$(yq '.channels.stable' chart.yaml)" \
  --namespace monitoring -f values-defaults.yaml
```
