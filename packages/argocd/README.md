# argocd (platform app)

ArgoCD on the platform cluster (§5.6): hosts tenant-local GitOps root apps
(rendered tenant-zone baselines) and shared ArgoCD Projects as
platform-scoped resources reconciled by `inari-operator`. SSO is wired to the
platform Keycloak out-of-band (OIDC config delivered via ESO).

## Chart

- repo: https://argoproj.github.io/argo-helm
- chart: `argo-cd`
- channels: `stable` / `incubating` (see `chart.yaml`)

Defaults: HA server/repo-server/application-set, redis-ha, metrics +
ServiceMonitors, default RBAC readonly, dex/notifications off (SSO via
Keycloak; notifications via the control plane).

```sh
helm template argocd argo-cd \
  --repo https://argoproj.github.io/argo-helm \
  --version "$(yq '.channels.stable' chart.yaml)" \
  --namespace argocd -f values-defaults.yaml
```
