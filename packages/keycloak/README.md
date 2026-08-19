# keycloak (platform app)

Keycloak on the platform cluster: Inari SSO, one Keycloak Organization per
tenant, and the OIDC issuer backing control-plane and agent identity
(platform plan §5.4, §5.6).

Installed by the platform engineer via the catalog; reconciled as a
`PlatformApp` targeting the platform cluster. Tenants never install this —
they consume realms/clients via the `keycloak-client` curated package.

## Chart

- repo: https://charts.bitnami.com/bitnami
- chart: `keycloak`
- channels: `stable` / `incubating` (see `chart.yaml`)

`values-defaults.yaml` carries sane platform defaults: production mode, edge
proxy, 2 replicas, embedded PostgreSQL with persistence, ServiceMonitor for
the monitoring stack.

## Install (GitOps payload)

```sh
helm template keycloak keycloak \
  --repo https://charts.bitnami.com/bitnami \
  --version "$(yq '.channels.stable' chart.yaml)" \
  --namespace keycloak --create-namespace \
  -f values-defaults.yaml
```

Admin credentials come from ESO (`ExternalSecret` in the keycloak namespace),
never from values files.
