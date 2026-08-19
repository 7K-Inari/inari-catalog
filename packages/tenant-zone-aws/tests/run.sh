#!/usr/bin/env bash
# Render/validation test for tenant-zone-aws (expects kro + Crossplane AWS CRD stubs).
set -euo pipefail
cd "$(dirname "$0")/.."

kubectl apply -f rgd.yaml
for i in $(seq 1 30); do
  state=$(kubectl get rgd tenant-zone-aws -o jsonpath='{.status.state}' 2>/dev/null || true)
  [ "$state" = "Active" ] && break
  sleep 2
done
[ "${state:-}" = "Active" ] || { echo "RGD not Active: ${state:-<none>}"; exit 1; }

kubectl get crd tenantzoneaws.kro.run >/dev/null

kubectl apply -f tests/instance-minimal.yaml
kubectl apply -f tests/instance-full.yaml

for i in $(seq 1 60); do
  kubectl get account.organizations.aws.upbound.io acme >/dev/null 2>&1 && \
  kubectl get account.organizations.aws.upbound.io globex >/dev/null 2>&1 && \
  kubectl get cluster.eks.aws.upbound.io acme >/dev/null 2>&1 && \
  kubectl get nodegroup.eks.aws.upbound.io acme-starter >/dev/null 2>&1 && break
  sleep 2
done

# Step 1: account vend in the management account, in the requested OU.
kubectl get account.organizations.aws.upbound.io acme
kubectl get account.organizations.aws.upbound.io acme -o jsonpath='{.spec.forProvider.parentId}' | grep -q ou-ab12-34567890
kubectl get account.organizations.aws.upbound.io acme -o jsonpath='{.spec.providerConfigRef.name}' | grep -qx management-account

# Step 2: OIDC trust bootstrap in the vended account (web-identity, aud=sts).
kubectl get openidconnectprovider.iam.aws.upbound.io acme
kubectl get role.iam.aws.upbound.io acme-inari-bootstrap
kubectl get role.iam.aws.upbound.io acme-inari-bootstrap -o jsonpath='{.spec.forProvider.assumeRolePolicy}' | grep -q AssumeRoleWithWebIdentity
kubectl get role.iam.aws.upbound.io acme-inari-bootstrap -o jsonpath='{.spec.providerConfigRef.name}' | grep -qx acme-account

# Step 3: EKS starter tier (2x t3.large default) in the vended account.
kubectl get cluster.eks.aws.upbound.io acme -o jsonpath='{.spec.providerConfigRef.name}' | grep -qx acme-account
kubectl get nodegroup.eks.aws.upbound.io acme-starter -o jsonpath='{.spec.forProvider.instanceTypes[0]}' | grep -q t3.large
kubectl get nodegroup.eks.aws.upbound.io acme-starter -o jsonpath='{.spec.forProvider.scalingConfig[0].desiredSize}' | grep -q 2
kubectl get nodegroup.eks.aws.upbound.io acme-starter -o jsonpath='{.spec.forProvider.clusterNameRef.name}' | grep -q acme
kubectl get role.iam.aws.upbound.io acme-eks-cluster
kubectl get role.iam.aws.upbound.io acme-eks-node

# Mandatory cost tags on the vended account.
tags=$(kubectl get account.organizations.aws.upbound.io acme -o jsonpath='{.spec.forProvider.tags}')
echo "$tags" | grep -q 'inari.dev/cost-center'
echo "$tags" | grep -q cc-1001

echo "tenant-zone-aws: OK"
