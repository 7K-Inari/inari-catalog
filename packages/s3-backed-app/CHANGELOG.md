# Changelog

## 2.0.0 (unreleased)

### Breaking changes

* new required field `providerConfigName` pins every managed resource to a
  per-account Crossplane `ProviderConfig` (platform plan §5.7).

### Features

* bucket encryption (SSE-S3), full public access block, versioning subresource.
* optional in-graph IRSA role + bucket-scoped policy (`createIrsaRole`), or
  bring-your-own role via `irsaRoleArn`.
* workload runs under a dedicated annotated ServiceAccount; status exposes
  bucketName/bucketArn/ready; readyWhen on the bucket Ready condition.

## 1.0.0 (2026-08-15)


### Features

* add incubating s3-backed-app, postgresql-aws-basic, keycloak-client packages ([42abcae](https://github.com/7K-Inari/inari-catalog/commit/42abcae5701884b21fe7e2d77dca3359500f7abc))
* curated golden-path catalog v1 (5 KRO RGD packages) ([e2f571c](https://github.com/7K-Inari/inari-catalog/commit/e2f571cbda09625d00bf55981d8048fe67e86ece))


### Bug Fixes

* make RGDs pass kro validation (v0.6.1 CLI-verified) ([dd3d9d4](https://github.com/7K-Inari/inari-catalog/commit/dd3d9d46a6b3290df694aba5f2d3270513166b54))
* **s3-backed-app:** wire bucketPrefix into bucket name and BUCKET_NAME env ([4406626](https://github.com/7K-Inari/inari-catalog/commit/44066260c8e924b0d9dac7269cf7d6cad665fa39))
