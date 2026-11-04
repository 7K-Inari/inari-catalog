#!/usr/bin/env bash
# Render + values-schema test for the argocd platform app.
set -euo pipefail
cd "$(dirname "$0")/.."

version=$(grep -A2 '^channels:' chart.yaml | awk '/stable:/ {gsub(/"/,"",$2); print $2}')
[ -n "$version" ] || { echo "no stable channel version"; exit 1; }

# Day-one schema validation (dependent feature decision 4): the upstream
# argo-cd chart ships no values.schema.json, so this package carries a
# curated one — the same document inari-server enforces with 422 field-level
# errors on adopt/update. The packaged defaults must satisfy it.
python3 -m pip install --quiet jsonschema pyyaml
python3 - <<'PY'
import json, yaml, jsonschema
schema = json.load(open("values.schema.json"))
values = yaml.safe_load(open("values-defaults.yaml"))
jsonschema.validate(values, schema)
print("values-defaults.yaml: schema-valid")
PY

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
