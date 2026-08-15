#!/usr/bin/env bash
# Render/validation test for postgresql-aws-basic (expects kro + Crossplane AWS CRD stubs).
set -euo pipefail
cd "$(dirname "$0")/.."

kubectl apply -f rgd.yaml
for i in $(seq 1 30); do
  state=$(kubectl get rgd postgresql-aws-basic -o jsonpath='{.status.state}' 2>/dev/null || true)
  [ "$state" = "Active" ] && break
  sleep 2
done
[ "${state:-}" = "Active" ] || { echo "RGD not Active: ${state:-<none>}"; exit 1; }

kubectl get crd postgresaws.kro.run >/dev/null

kubectl apply -f tests/instance-minimal.yaml
kubectl apply -f tests/instance-full.yaml

for i in $(seq 1 30); do
  kubectl get instance.rds.aws.upbound.io minimal-db >/dev/null 2>&1 && \
  kubectl get instance.rds.aws.upbound.io full-db >/dev/null 2>&1 && break
  sleep 2
done
kubectl get instance.rds.aws.upbound.io minimal-db
kubectl get instance.rds.aws.upbound.io full-db
kubectl get instance.rds.aws.upbound.io full-db -o jsonpath='{.spec.forProvider.engine}' | grep -q postgres
echo "postgresql-aws-basic: OK"
