# keycloak-client

Keycloak OIDC client in a tenant realm, managed via Crossplane
provider-keycloak (`client.keycloak.crossplane.io/Client`). The client secret
(when not public) is written to the `<name>-client` Secret.

**Incubating** — tenant realms themselves are platform-scoped resources
reconciled by `inari-operator`; this package assumes the realm already exists.

## Prerequisites

- kro
- Crossplane + provider-keycloak CRDs and `ProviderConfig`
- an existing Keycloak realm

## Parameters

| Name | Type | Default | Description |
|---|---|---|---|
| `name` | string | — (required) | Resource name. |
| `namespace` | string | `default` | Namespace for the client Secret. |
| `realm` | string | — (required) | Owning Keycloak realm. |
| `clientId` | string | `""` | Explicit client ID (defaults to `name`). |
| `redirectUris` | list[string] | — (required) | Valid redirect URIs. |
| `publicClient` | boolean | `false` | Public client (no secret). |
| `serviceAccountsEnabled` | boolean | `false` | Enable service-account grant. |

## Example

```yaml
apiVersion: kro.run/v1alpha1
kind: KeycloakClient
metadata:
  name: checkout-sso
spec:
  name: checkout-sso
  realm: acme
  redirectUris:
    - https://checkout.acme.example.com/callback
```
