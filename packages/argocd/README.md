# argocd (platform app)

ArgoCD as a first-class cluster addon: declarative GitOps continuous
delivery. Installed, adopted, and version/values-managed via the inari-ui
cluster addons surface; AppProjects ship as native manifests in the
baseline/team repos (team-scoped projects come from the `gitops-repo`
scaffold skeleton). SSO is wired to the platform Keycloak out-of-band (OIDC
config delivered via ESO).

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

## Values schema

The upstream argo-cd chart ships no `values.schema.json`, so this package
carries a curated one covering the Inari-managed surface (HA topology,
metrics, ingress, RBAC, extension toggles). inari-server enforces it on
addon adopt/update with 422 field-level errors; `tests/run.sh` asserts
`values-defaults.yaml` stays schema-valid.

