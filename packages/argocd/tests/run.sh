#!/usr/bin/env bash
# Render test for the argocd platform app.
set -euo pipefail
cd "$(dirname "$0")/.."

version=$(grep -A2 '^channels:' chart.yaml | awk '/stable:/ {gsub(/"/,"",$2); print $2}')
[ -n "$version" ] || { echo "no stable channel version"; exit 1; }

helm repo add inari-test-argo https://argoproj.github.io/argo-helm >/dev/null 2>&1 || true
# ServiceMonitor templates are gated on .Capabilities.APIVersions.Has
# "monitoring.coreos.com/v1"; declare it so helm template renders them.
helm template argocd inari-test-argo/argo-cd \
  --version "$version" --namespace argocd \
  --api-versions monitoring.coreos.com/v1 \
  -f values-defaults.yaml > /tmp/argocd-render.yaml

grep -q 'argocd-server' /tmp/argocd-render.yaml
grep -q 'argocd-repo-server' /tmp/argocd-render.yaml
grep -q 'kind: ServiceMonitor' /tmp/argocd-render.yaml
grep -q 'kind: StatefulSet' /tmp/argocd-render.yaml
echo "argocd (platform-app): OK"
