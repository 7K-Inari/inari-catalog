#!/usr/bin/env bash
# Render/validation test for s3-backed-app (expects kro + Crossplane AWS CRD stubs).
set -euo pipefail
cd "$(dirname "$0")/.."

kubectl apply -f rgd.yaml
for i in $(seq 1 30); do
  state=$(kubectl get rgd s3-backed-app -o jsonpath='{.status.state}' 2>/dev/null || true)
  [ "$state" = "Active" ] && break
  sleep 2
done
[ "${state:-}" = "Active" ] || { echo "RGD not Active: ${state:-<none>}"; exit 1; }

kubectl get crd s3backedapps.kro.run >/dev/null

kubectl apply -f tests/instance-minimal.yaml
kubectl apply -f tests/instance-full.yaml

for i in $(seq 1 30); do
  kubectl get bucket.s3.aws.upbound.io minimal-s3 >/dev/null 2>&1 && \
  kubectl get bucket.s3.aws.upbound.io acme-full-s3 >/dev/null 2>&1 && break
  sleep 2
done
kubectl get bucket.s3.aws.upbound.io minimal-s3
kubectl get bucket.s3.aws.upbound.io acme-full-s3
kubectl get deployment minimal-s3
kubectl get service minimal-s3
kubectl get deployment full-s3
kubectl get bucket.s3.aws.upbound.io acme-full-s3 -o jsonpath='{.spec.forProvider.region}' | grep -q eu-west-1
kubectl get deployment full-s3 -o jsonpath='{.spec.template.spec.containers[0].env[?(@.name=="BUCKET_NAME")].value}' | grep -q acme-full-s3
echo "s3-backed-app: OK"
