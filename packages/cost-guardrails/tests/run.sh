#!/usr/bin/env bash
# Admission tests for the cost-guardrails policy pack (requires k8s >= 1.30).
set -euo pipefail
cd "$(dirname "$0")/.."

kubectl apply -f policies.yaml
kubectl get validatingadmissionpolicy cost-max-replicas >/dev/null
kubectl get validatingadmissionpolicy cost-require-cost-center-label >/dev/null
sleep 5

if kubectl apply -f tests/fixtures/violating-replicas.yaml >/dev/null 2>&1; then
  echo "expected denial but violating-replicas.yaml was admitted"
  kubectl delete -f tests/fixtures/violating-replicas.yaml --wait=false >/dev/null 2>&1 || true
  exit 1
fi

kubectl apply -f tests/fixtures/compliant.yaml
kubectl delete -f tests/fixtures/compliant.yaml
echo "cost-guardrails (policy-pack): OK"
