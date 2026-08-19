#!/usr/bin/env bash
# Render test for the monitoring-stack platform app.
set -euo pipefail
cd "$(dirname "$0")/.."

version=$(grep -A2 '^channels:' chart.yaml | awk '/stable:/ {gsub(/"/,"",$2); print $2}')
[ -n "$version" ] || { echo "no stable channel version"; exit 1; }

helm repo add inari-test-prom https://prometheus-community.github.io/helm-charts >/dev/null 2>&1 || true
helm template monitoring inari-test-prom/kube-prometheus-stack \
  --version "$version" --namespace monitoring -f values-defaults.yaml > /tmp/monitoring-render.yaml

grep -q 'kind: StatefulSet' /tmp/monitoring-render.yaml
grep -q 'kind: Deployment' /tmp/monitoring-render.yaml
grep -q 'grafana' /tmp/monitoring-render.yaml
grep -q 'prometheus' /tmp/monitoring-render.yaml
echo "monitoring-stack (platform-app): OK"
