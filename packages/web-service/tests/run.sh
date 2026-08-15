#!/usr/bin/env bash
# Render/validation test for web-service (expects kro + cert-manager CRDs installed).
set -euo pipefail
cd "$(dirname "$0")/.."

kubectl apply -f rgd.yaml
for i in $(seq 1 30); do
  state=$(kubectl get rgd web-service -o jsonpath='{.status.state}' 2>/dev/null || true)
  [ "$state" = "Active" ] && break
  sleep 2
done
[ "${state:-}" = "Active" ] || { echo "RGD not Active: ${state:-<none>}"; exit 1; }

kubectl get crd webservices.kro.run >/dev/null

kubectl apply -f tests/instance-minimal.yaml
kubectl apply -f tests/instance-full.yaml

for i in $(seq 1 60); do
  kubectl get deployment minimal-web >/dev/null 2>&1 && \
  kubectl get deployment full-web >/dev/null 2>&1 && \
  kubectl get service minimal-web >/dev/null 2>&1 && \
  kubectl get service full-web >/dev/null 2>&1 && \
  kubectl get ingress minimal-web >/dev/null 2>&1 && \
  kubectl get ingress full-web >/dev/null 2>&1 && \
  kubectl get certificate.cert-manager.io minimal-web-tls >/dev/null 2>&1 && \
  kubectl get certificate.cert-manager.io full-web-tls >/dev/null 2>&1 && break
  sleep 2
done
kubectl get deployment minimal-web
kubectl get service minimal-web
kubectl get ingress minimal-web
kubectl get certificate.cert-manager.io minimal-web-tls
kubectl get deployment full-web
kubectl get service full-web
kubectl get ingress full-web
kubectl get certificate.cert-manager.io full-web-tls

# DNS/TLS wiring assertions
kubectl get ingress full-web -o jsonpath='{.spec.tls[0].secretName}' | grep -q full-web-tls
kubectl get ingress full-web -o jsonpath='{.metadata.annotations.external-dns\.alpha\.kubernetes\.io/hostname}' | grep -q app-public.example.test
echo "web-service: OK"
