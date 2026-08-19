#!/usr/bin/env bash
# Render test for the keycloak platform app (helm template against defaults).
set -euo pipefail
cd "$(dirname "$0")/.."

version=$(grep -A2 '^channels:' chart.yaml | awk '/stable:/ {gsub(/"/,"",$2); print $2}')
[ -n "$version" ] || { echo "no stable channel version"; exit 1; }

helm repo add inari-test-bitnami https://charts.bitnami.com/bitnami >/dev/null 2>&1 || true
helm template keycloak inari-test-bitnami/keycloak \
  --version "$version" --namespace keycloak -f values-defaults.yaml > /tmp/keycloak-render.yaml

grep -q 'kind: StatefulSet' /tmp/keycloak-render.yaml
grep -q 'app.kubernetes.io/name: keycloak' /tmp/keycloak-render.yaml
grep -q 'KEYCLOAK_PRODUCTION' /tmp/keycloak-render.yaml || grep -q 'start --optimized\|production' /tmp/keycloak-render.yaml
grep -q 'kind: ServiceMonitor' /tmp/keycloak-render.yaml
echo "keycloak (platform-app): OK"
