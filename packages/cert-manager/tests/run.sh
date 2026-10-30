#!/usr/bin/env bash
# Render + values-schema test for the cert-manager platform app.
set -euo pipefail
cd "$(dirname "$0")/.."

version=$(grep -A2 '^channels:' chart.yaml | awk '/stable:/ {gsub(/"/,"",$2); print $2}')
[ -n "$version" ] || { echo "no stable channel version"; exit 1; }

# Day-one schema validation (dependent feature decision 4): the vendored
# values.schema.json is what inari-server enforces with 422 field-level
# errors on adopt/update — the packaged defaults must satisfy it.
python3 -m pip install --quiet jsonschema pyyaml
python3 - <<'PY'
import json, yaml, jsonschema
schema = json.load(open("values.schema.json"))
values = yaml.safe_load(open("values-defaults.yaml"))
jsonschema.validate(values, schema)
print("values-defaults.yaml: schema-valid")
PY

helm repo add inari-test-jetstack https://charts.jetstack.io >/dev/null 2>&1 || true
helm template cert-manager inari-test-jetstack/cert-manager \
  --version "$version" --namespace cert-manager -f values-defaults.yaml > /tmp/cert-manager-render.yaml

grep -q 'kind: Deployment' /tmp/cert-manager-render.yaml
grep -q 'kind: CustomResourceDefinition' /tmp/cert-manager-render.yaml
grep -q 'clusterissuers.cert-manager.io' /tmp/cert-manager-render.yaml
echo "cert-manager (platform-app): OK"
