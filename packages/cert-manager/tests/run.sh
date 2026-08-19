#!/usr/bin/env bash
# Render test for the cert-manager platform app.
set -euo pipefail
cd "$(dirname "$0")/.."

version=$(grep -A2 '^channels:' chart.yaml | awk '/stable:/ {gsub(/"/,"",$2); print $2}')
[ -n "$version" ] || { echo "no stable channel version"; exit 1; }

helm repo add inari-test-jetstack https://charts.jetstack.io >/dev/null 2>&1 || true
helm template cert-manager inari-test-jetstack/cert-manager \
  --version "$version" --namespace cert-manager -f values-defaults.yaml > /tmp/cert-manager-render.yaml

grep -q 'kind: Deployment' /tmp/cert-manager-render.yaml
grep -q 'kind: CustomResourceDefinition' /tmp/cert-manager-render.yaml
grep -q 'clusterissuers.cert-manager.io' /tmp/cert-manager-render.yaml
echo "cert-manager (platform-app): OK"
