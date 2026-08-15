# web-service

Golden-path web service: `Deployment` + `Service` + `Ingress` with automatic
DNS via ExternalDNS annotations and a TLS certificate via cert-manager.

KRO generates a `WebService` CRD from this ResourceGraphDefinition.

## Prerequisites

- kro on the target cluster
- an ingress controller (e.g. ingress-nginx) matching `ingressClassName`
- ExternalDNS (reads the Ingress hostname annotation)
- cert-manager with the referenced `ClusterIssuer`

## Parameters

| Name | Type | Default | Description |
|---|---|---|---|
| `name` | string | — (required) | Name for all composed resources. |
| `namespace` | string | `default` | Target namespace. |
| `image` | string | — (required) | Container image. |
| `replicas` | integer | `2` | Replica count. |
| `port` | integer | `8080` | Container port. |
| `host` | string | — (required) | Public hostname (DNS + TLS). |
| `ingressClassName` | string | `nginx` | Ingress class. |
| `clusterIssuer` | string | `letsencrypt-prod` | cert-manager ClusterIssuer. |
| `externalDnsHostname` | string | `""` | Override for the published DNS record. |
| `cpuRequest` / `memoryRequest` | string | `100m` / `128Mi` | Container requests. |
| `cpuLimit` / `memoryLimit` | string | `500m` / `512Mi` | Container limits. |

## Example

```yaml
apiVersion: kro.run/v1alpha1
kind: WebService
metadata:
  name: checkout
spec:
  name: checkout
  namespace: payments
  image: ghcr.io/acme/checkout:1.4.0
  host: checkout.acme.example.com
```
