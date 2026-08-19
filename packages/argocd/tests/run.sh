#!/usr/bin/env bash
# Render test for the argocd platform app.
set -euo pipefail
cd "$(dirname "$0")/.."

version=$(grep -A2 '^channels:' chart.yaml | awk '/stable:/ {gsub(/"/,"",$2); print $2}')
[ -n "$version" ] || { echo "no stable channel version"; exit 1; }

helm repo add inari-test-argo https://argoproj.github.io/argo-helm >/dev/null 2>&1 || true
helm template argocd inari-test-argo/argo-cd \
  --version "$version" --namespace argocd -f values-defaults.yaml > /tmp/argocd-render.yaml

grep -q 'argocd-server' /tmp/argocd-render.yaml
grep -q 'argocd-repo-server' /tmp/argocd-render.yaml
grep -q 'kind: ServiceMonitor' /tmp/argocd-render.yaml
grep -q 'kind: StatefulSet' /tmp/argocd-render.yaml
echo "argocd (platform-app): OK"
