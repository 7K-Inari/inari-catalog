#!/usr/bin/env bash
# Render/validation test for postgresql-aws (expects kro + Crossplane AWS CRD stubs).
set -euo pipefail
cd "$(dirname "$0")/.."

kubectl apply -f rgd.yaml
for i in $(seq 1 30); do
  state=$(kubectl get rgd postgresql-aws -o jsonpath='{.status.state}' 2>/dev/null || true)
  [ "$state" = "Active" ] && break
  sleep 2
done
[ "${state:-}" = "Active" ] || { echo "RGD not Active: ${state:-<none>}"; exit 1; }

kubectl get crd postgresqlaws.kro.run >/dev/null

kubectl apply -f tests/instance-minimal.yaml
kubectl apply -f tests/instance-full.yaml

for i in $(seq 1 30); do
  kubectl get instance.rds.aws.upbound.io minimal-db >/dev/null 2>&1 && \
  kubectl get instance.rds.aws.upbound.io full-db >/dev/null 2>&1 && break
  sleep 2
done
kubectl get instance.rds.aws.upbound.io minimal-db
kubectl get instance.rds.aws.upbound.io full-db

# Every managed resource must be pinned to the per-account ProviderConfig (§5.7).
for db in minimal-db full-db; do
  kubectl get instance.rds.aws.upbound.io "$db" \
    -o jsonpath='{.spec.providerConfigRef.name}' | grep -qx dev-account
done

kubectl get instance.rds.aws.upbound.io full-db -o jsonpath='{.spec.forProvider.engine}' | grep -q postgres
kubectl get instance.rds.aws.upbound.io full-db -o jsonpath='{.spec.forProvider.multiAZ}' | grep -q true
kubectl get instance.rds.aws.upbound.io full-db -o jsonpath='{.spec.forProvider.storageEncrypted}' | grep -q true
kubectl get instance.rds.aws.upbound.io full-db -o jsonpath='{.spec.forProvider.vpcSecurityGroupIds[0]}' | grep -q sg-0123456789abcdef0
# deletionProtection=true must disable skipFinalSnapshot.
kubectl get instance.rds.aws.upbound.io full-db -o jsonpath='{.spec.forProvider.skipFinalSnapshot}' | grep -q false
kubectl get instance.rds.aws.upbound.io full-db -o jsonpath='{.spec.writeConnectionSecretToRef.name}' | grep -q full-db-conn
echo "postgresql-aws: OK"
