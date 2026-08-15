# inari-catalog

Curated package catalog for Inari: KRO ResourceGraphDefinitions (golden-path templates), platform-app Helm charts, UI-schema hints, policy packs; CI publishes signed OCI artifacts to `stable`/`incubating` channels (plan §5.5, §6 #8).

Stack: YAML, CEL, Helm, KRO RGDs, OPA/Rego tests, OCI artifacts (cosign-signed)

Part of the **Inari** multi-tenant Internal Developer Platform (GitHub org `7K-Inari`).
Canonical architecture & development plan: [inari-docs/docs/architecture/inari-platform-plan.md](https://github.com/7K-Inari/inari-docs/blob/main/docs/architecture/inari-platform-plan.md)

## Packages

Golden-path packages live under `packages/<name>/` — each is a KRO
ResourceGraphDefinition (`rgd.yaml`) plus `package.yaml` (version/channel),
`ui-hints.yaml`, a README, and render/validation tests under `tests/`.

| Package | Channel | Description |
|---|---|---|
| [namespace-as-a-service](packages/namespace-as-a-service) | stable | Tenant namespace with quotas and team RBAC |
| [web-service](packages/web-service) | stable | Web service with DNS (ExternalDNS) + TLS (cert-manager) |
| [s3-backed-app](packages/s3-backed-app) | incubating | App backed by an S3 bucket via Crossplane |
| [postgresql-aws-basic](packages/postgresql-aws-basic) | incubating | Basic RDS PostgreSQL via Crossplane (M3 stub) |
| [keycloak-client](packages/keycloak-client) | incubating | Keycloak OIDC client via provider-keycloak |

[`catalog.yaml`](catalog.yaml) is the machine-readable index consumed by the
inari-server Catalog Service; regenerate with
`python3 scripts/build-catalog-index.py`. See
[docs/release-process.md](docs/release-process.md) for versioning, channels,
and the signed OCI publish flow.
