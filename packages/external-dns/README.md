# external-dns (platform app)

ExternalDNS as a first-class cluster addon (parent plan §4.1): synchronizes
exposed Services and Ingresses with DNS providers. Installed, adopted, and
version/values-managed via the inari-ui cluster addons surface; DNS records
themselves ship as native `DNSEndpoint` manifests in the tenant state repo
(rendered by inari-server's source-agnostic renderer).

## Chart

- repo: https://kubernetes-sigs.github.io/external-dns/
- chart: `external-dns`
- channels: `stable` / `incubating` (see `chart.yaml`)

```sh
helm template external-dns external-dns \
  --repo https://kubernetes-sigs.github.io/external-dns/ \
  --version "$(yq '.channels.stable' chart.yaml)" \
  --namespace external-dns -f values-defaults.yaml
```

## Values schema

`values.schema.json` is vendored from the upstream chart (same chart
version as the `stable` channel). inari-server enforces it on addon
adopt/update with 422 field-level errors; `tests/run.sh` asserts
`values-defaults.yaml` stays schema-valid.
