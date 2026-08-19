#!/usr/bin/env bash
# Admission tests for the baseline-security policy pack (requires k8s >= 1.30
# for ValidatingAdmissionPolicy GA).
set -euo pipefail
cd "$(dirname "$0")/.."

kubectl apply -f policies.yaml
for p in baseline-disallow-latest-image baseline-require-resources baseline-disallow-privileged baseline-require-tenant-label baseline-readonly-rootfs; do
  kubectl get validatingadmissionpolicy "$p" >/dev/null
  kubectl get validatingadmissionpolicybinding "$p" >/dev/null
done
sleep 5  # let bindings become active

expect_denied() {
  if kubectl apply -f "tests/fixtures/$1" >/dev/null 2>&1; then
    echo "expected denial but $1 was admitted"; kubectl delete -f "tests/fixtures/$1" --wait=false >/dev/null 2>&1 || true; exit 1
  fi
}

expect_denied violating-latest.yaml
expect_denied violating-privileged.yaml
expect_denied violating-no-resources.yaml
expect_denied violating-no-tenant-label.yaml

kubectl apply -f tests/fixtures/compliant.yaml
kubectl delete -f tests/fixtures/compliant.yaml
echo "baseline-security (policy-pack): OK"
