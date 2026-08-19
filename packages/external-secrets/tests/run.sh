#!/usr/bin/env bash
# Render test for the external-secrets platform app.
set -euo pipefail
cd "$(dirname "$0")/.."

version=$(grep -A2 '^channels:' chart.yaml | awk '/stable:/ {gsub(/"/,"",$2); print $2}')
[ -n "$version" ] || { echo "no stable channel version"; exit 1; }

helm repo add inari-test-eso https://charts.external-secrets.io >/dev/null 2>&1 || true
helm template external-secrets inari-test-eso/external-secrets \
  --version "$version" --namespace external-secrets -f values-defaults.yaml > /tmp/eso-render.yaml

grep -q 'kind: Deployment' /tmp/eso-render.yaml
grep -q 'externalsecrets.external-secrets.io' /tmp/eso-render.yaml
grep -q 'clustersecretstores.external-secrets.io' /tmp/eso-render.yaml
echo "external-secrets (platform-app): OK"
