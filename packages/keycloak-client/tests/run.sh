#!/usr/bin/env bash
# Render/validation test for keycloak-client (expects kro + provider-keycloak CRD stub).
set -euo pipefail
cd "$(dirname "$0")/.."

kubectl apply -f rgd.yaml
for i in $(seq 1 30); do
  state=$(kubectl get rgd keycloak-client -o jsonpath='{.status.state}' 2>/dev/null || true)
  [ "$state" = "Active" ] && break
  sleep 2
done
[ "${state:-}" = "Active" ] || { echo "RGD not Active: ${state:-<none>}"; exit 1; }

kubectl get crd keycloakclients.kro.run >/dev/null

kubectl apply -f tests/instance-minimal.yaml
kubectl apply -f tests/instance-full.yaml

for i in $(seq 1 30); do
  kubectl get client.client.keycloak.crossplane.io minimal-client >/dev/null 2>&1 && \
  kubectl get client.client.keycloak.crossplane.io full-client >/dev/null 2>&1 && break
  sleep 2
done
kubectl get client.client.keycloak.crossplane.io minimal-client
kubectl get client.client.keycloak.crossplane.io full-client
kubectl get client.client.keycloak.crossplane.io full-client -o jsonpath='{.spec.forProvider.realmId}' | grep -q acme
echo "keycloak-client: OK"
