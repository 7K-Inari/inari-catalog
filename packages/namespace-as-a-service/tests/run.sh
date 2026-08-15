#!/usr/bin/env bash
# Render/validation test for namespace-as-a-service (expects kro installed).
set -euo pipefail
cd "$(dirname "$0")/.."

kubectl apply -f rgd.yaml
for i in $(seq 1 30); do
  state=$(kubectl get rgd namespace-as-a-service -o jsonpath='{.status.state}' 2>/dev/null || true)
  [ "$state" = "Active" ] && break
  sleep 2
done
[ "${state:-}" = "Active" ] || { echo "RGD not Active: ${state:-<none>}"; exit 1; }

kubectl get crd tenantnamespaces.kro.run >/dev/null

kubectl apply -f tests/instance-minimal.yaml
kubectl apply -f tests/instance-full.yaml

for i in $(seq 1 60); do
  kubectl get namespace team-minimal >/dev/null 2>&1 && \
  kubectl get namespace team-full >/dev/null 2>&1 && \
  kubectl get resourcequota team-full-quota -n team-full >/dev/null 2>&1 && \
  kubectl get limitrange team-full-defaults -n team-full >/dev/null 2>&1 && \
  kubectl get rolebinding team-full-admins -n team-full >/dev/null 2>&1 && \
  kubectl get rolebinding team-full-viewers -n team-full >/dev/null 2>&1 && break
  sleep 2
done
kubectl get namespace team-minimal
kubectl get namespace team-full
kubectl get resourcequota team-full-quota -n team-full
kubectl get limitrange team-full-defaults -n team-full
kubectl get rolebinding team-full-admins -n team-full
kubectl get rolebinding team-full-viewers -n team-full
# minimal instance has no bindings (includeWhen false)
! kubectl get rolebinding team-minimal-admins -n team-minimal 2>/dev/null

# negative schema check: missing required 'team' must be rejected
if kubectl apply --dry-run=server -f - >/dev/null 2>&1 <<'EOF'
apiVersion: kro.run/v1alpha1
kind: TenantNamespace
metadata:
  name: bad
spec:
  name: bad
EOF
then
  echo "expected schema rejection for missing 'team'"
  exit 1
fi
echo "namespace-as-a-service: OK"
