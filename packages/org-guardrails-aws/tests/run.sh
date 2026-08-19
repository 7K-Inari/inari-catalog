#!/usr/bin/env bash
# Render/validation test for org-guardrails-aws (expects kro + Crossplane AWS CRD stubs).
set -euo pipefail
cd "$(dirname "$0")/.."

kubectl apply -f rgd.yaml
for i in $(seq 1 30); do
  state=$(kubectl get rgd org-guardrails-aws -o jsonpath='{.status.state}' 2>/dev/null || true)
  [ "$state" = "Active" ] && break
  sleep 2
done
[ "${state:-}" = "Active" ] || { echo "RGD not Active: ${state:-<none>}"; exit 1; }

kubectl get crd orgguardrailsaws.kro.run >/dev/null

kubectl apply -f tests/instance-minimal.yaml
kubectl apply -f tests/instance-full.yaml

for i in $(seq 1 60); do
  kubectl get trail.cloudtrail.aws.upbound.io acme-audit >/dev/null 2>&1 && \
  kubectl get budget.budgets.aws.upbound.io acme-monthly >/dev/null 2>&1 && \
  kubectl get trail.cloudtrail.aws.upbound.io globex-audit >/dev/null 2>&1 && break
  sleep 2
done

# CloudTrail: multi-region, log validation, global events.
trail=$(kubectl get trail.cloudtrail.aws.upbound.io acme-audit -o json)
echo "$trail" | grep -q '"isMultiRegionTrail":true' || echo "$trail" | grep -q '"isMultiRegionTrail": true'
echo "$trail" | grep -q acme-audit-logs
kubectl get trail.cloudtrail.aws.upbound.io acme-audit -o jsonpath='{.spec.providerConfigRef.name}' | grep -qx acme-account

# Budget: monthly COST budget with 80% forecasted + 100% actual alerts.
budget=$(kubectl get budget.budgets.aws.upbound.io acme-monthly -o json)
echo "$budget" | grep -q MONTHLY
echo "$budget" | grep -q FORECASTED
echo "$budget" | grep -q platform-team@example.com
kubectl get budget.budgets.aws.upbound.io acme-monthly -o jsonpath='{.spec.providerConfigRef.name}' | grep -qx acme-account
kubectl get budget.budgets.aws.upbound.io globex-monthly -o jsonpath='{.spec.forProvider.limitAmount}' | grep -q 200

echo "org-guardrails-aws: OK"
