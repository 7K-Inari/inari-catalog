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

for i in $(seq 1 60); do
  kubectl get bucket.s3.aws.upbound.io minimal-s3 >/dev/null 2>&1 && \
  kubectl get bucket.s3.aws.upbound.io acme-full-s3 >/dev/null 2>&1 && break
  sleep 2
done
kubectl get bucket.s3.aws.upbound.io minimal-s3
kubectl get bucket.s3.aws.upbound.io acme-full-s3

# Stub CRDs have no provider behind them: simulate the controllers by writing
# status, so expressions referencing bucket.status/irsaRole.status resolve and
# the rest of the graph (ServiceAccounts, Deployment, Service) can render.
bucket_status='{"status":{"atProvider":{"arn":"arn:aws:s3:::BUCKET"},"conditions":[{"type":"Ready","status":"True","reason":"Available","lastTransitionTime":"2026-01-01T00:00:00Z"}]}}'
kubectl patch bucket.s3.aws.upbound.io minimal-s3 --subresource=status --type=merge -p "${bucket_status/BUCKET/minimal-s3}"
kubectl patch bucket.s3.aws.upbound.io acme-full-s3 --subresource=status --type=merge -p "${bucket_status/BUCKET/acme-full-s3}"

for i in $(seq 1 60); do
  kubectl get role.iam.aws.upbound.io full-s3-s3 >/dev/null 2>&1 && break
  sleep 2
done
kubectl get role.iam.aws.upbound.io full-s3-s3
kubectl patch role.iam.aws.upbound.io full-s3-s3 --subresource=status --type=merge -p \
  '{"status":{"atProvider":{"arn":"arn:aws:iam::123456789012:role/full-s3-s3"},"conditions":[{"type":"Ready","status":"True","reason":"Available","lastTransitionTime":"2026-01-01T00:00:00Z"}]}}'

for i in $(seq 1 60); do
  kubectl get deployment minimal-s3 >/dev/null 2>&1 && \
  kubectl get deployment full-s3 >/dev/null 2>&1 && \
  kubectl get service minimal-s3 >/dev/null 2>&1 && \
  kubectl get service full-s3 >/dev/null 2>&1 && \
  kubectl get bucketpublicaccessblock.s3.aws.upbound.io minimal-s3 >/dev/null 2>&1 && break
  sleep 2
done
kubectl get bucket.s3.aws.upbound.io minimal-s3
kubectl get bucket.s3.aws.upbound.io acme-full-s3
kubectl get deployment minimal-s3
kubectl get service minimal-s3
kubectl get deployment full-s3
kubectl get bucket.s3.aws.upbound.io acme-full-s3 -o jsonpath='{.spec.forProvider.region}' | grep -q eu-west-1
kubectl get deployment full-s3 -o jsonpath='{.spec.template.spec.containers[0].env[?(@.name=="BUCKET_NAME")].value}' | grep -q acme-full-s3

# Every AWS managed resource must be pinned to the per-account ProviderConfig (§5.7).
for gk in bucket.s3.aws.upbound.io bucketversioning.s3.aws.upbound.io bucketserversideencryptionconfiguration.s3.aws.upbound.io bucketpublicaccessblock.s3.aws.upbound.io; do
  kubectl get "$gk" minimal-s3 -o jsonpath='{.spec.providerConfigRef.name}' | grep -qx dev-account
  kubectl get "$gk" acme-full-s3 -o jsonpath='{.spec.providerConfigRef.name}' | grep -qx dev-account
done

# Public access fully blocked; versioning enabled on the full instance.
pab=$(kubectl get bucketpublicaccessblock.s3.aws.upbound.io acme-full-s3 -o json)
echo "$pab" | grep -q '"blockPublicPolicy":true' || echo "$pab" | grep -q '"blockPublicPolicy": true'
kubectl get bucketversioning.s3.aws.upbound.io acme-full-s3 -o jsonpath='{.spec.forProvider.versioningConfiguration.status}' | grep -q Enabled
kubectl get bucketversioning.s3.aws.upbound.io minimal-s3 -o jsonpath='{.spec.forProvider.versioningConfiguration.status}' | grep -q Suspended

# IRSA: role/policy/attachment rendered only for the full instance (createIrsaRole).
kubectl get role.iam.aws.upbound.io full-s3-s3
kubectl get policy.iam.aws.upbound.io full-s3-s3
kubectl get rolepolicyattachment.iam.aws.upbound.io full-s3-s3
kubectl get role.iam.aws.upbound.io full-s3-s3 -o jsonpath='{.spec.providerConfigRef.name}' | grep -qx dev-account
kubectl get role.iam.aws.upbound.io full-s3-s3 -o jsonpath='{.spec.forProvider.assumeRolePolicy}' | grep -q AssumeRoleWithWebIdentity
! kubectl get role.iam.aws.upbound.io minimal-s3-s3 >/dev/null 2>&1

# Workload runs under its ServiceAccount.
kubectl get serviceaccount minimal-s3
kubectl get serviceaccount full-s3
kubectl get serviceaccount full-s3 -o jsonpath='{.metadata.annotations.eks\.amazonaws\.com/role-arn}' | grep -q 'arn:aws:iam::123456789012:role/full-s3-s3'
kubectl get deployment full-s3 -o jsonpath='{.spec.template.spec.serviceAccountName}' | grep -q full-s3
echo "s3-backed-app: OK"
