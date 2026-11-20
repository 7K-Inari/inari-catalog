#!/usr/bin/env bash
# Render + values-schema test for the external-dns platform app.
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

helm repo add inari-test-external-dns https://kubernetes-sigs.github.io/external-dns/ >/dev/null 2>&1 || true
helm template external-dns inari-test-external-dns/external-dns \
  --version "$version" --namespace external-dns -f values-defaults.yaml > /tmp/external-dns-render.yaml

grep -q 'kind: Deployment' /tmp/external-dns-render.yaml
grep -q 'kind: ClusterRole' /tmp/external-dns-render.yaml
grep -q 'kind: ServiceMonitor' /tmp/external-dns-render.yaml
grep -q 'registry=txt' /tmp/external-dns-render.yaml
grep -q 'policy=upsert-only' /tmp/external-dns-render.yaml
echo "external-dns (platform-app): OK"
