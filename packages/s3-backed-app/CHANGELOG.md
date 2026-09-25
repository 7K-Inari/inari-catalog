# Changelog

## [5.0.0](https://github.com/7K-Inari/inari-catalog/compare/v4.0.0...v5.0.0) (2026-09-25)


### ⚠ BREAKING CHANGES

* **s3-backed-app:** full version with ProviderConfig, encryption, IRSA

### Features

* add incubating s3-backed-app, postgresql-aws-basic, keycloak-client packages ([42abcae](https://github.com/7K-Inari/inari-catalog/commit/42abcae5701884b21fe7e2d77dca3359500f7abc))
* curated golden-path catalog v1 (5 KRO RGD packages) ([e2f571c](https://github.com/7K-Inari/inari-catalog/commit/e2f571cbda09625d00bf55981d8048fe67e86ece))
* M3-W1 Crossplane AWS packages, platform apps, tenant-zone-aws RGD, policy packs ([ef2c72a](https://github.com/7K-Inari/inari-catalog/commit/ef2c72a9817937b735948a010a751acf4bbffa30))
* publish remaining catalog packages to GHCR ([aa0f143](https://github.com/7K-Inari/inari-catalog/commit/aa0f1435b5a3d73c69cca5fe9c14deff96c68f36))
* publish remaining catalog packages to GHCR ([4d13d4f](https://github.com/7K-Inari/inari-catalog/commit/4d13d4f571caa730329552e5cfc612d83be84c6d))
* **s3-backed-app:** full version with ProviderConfig, encryption, IRSA ([177f9c2](https://github.com/7K-Inari/inari-catalog/commit/177f9c2dbea3dd89f4887374d88ae3b82e6abb8a))


### Bug Fixes

* make RGDs pass kro validation (v0.6.1 CLI-verified) ([dd3d9d4](https://github.com/7K-Inari/inari-catalog/commit/dd3d9d46a6b3290df694aba5f2d3270513166b54))
* **qa:** broken policy CEL, chained-ignore ServiceAccount, unguarded optional lists, helm test assertions ([9d8b6e9](https://github.com/7K-Inari/inari-catalog/commit/9d8b6e901fc7d0533931bbc432e4f1f7a8dc118b))
* **s3-backed-app,tenant-zone-aws:** quote CEL ternary scalars in YAML ([c47711d](https://github.com/7K-Inari/inari-catalog/commit/c47711d9999991f202ca621a49b27b6766591f0e))
* **s3-backed-app:** wire bucketPrefix into bucket name and BUCKET_NAME env ([4406626](https://github.com/7K-Inari/inari-catalog/commit/44066260c8e924b0d9dac7269cf7d6cad665fa39))

## [4.0.0](https://github.com/7K-Inari/inari-catalog/compare/v3.0.0...v4.0.0) (2026-09-13)


### ⚠ BREAKING CHANGES

* **s3-backed-app:** full version with ProviderConfig, encryption, IRSA

### Features

* add incubating s3-backed-app, postgresql-aws-basic, keycloak-client packages ([42abcae](https://github.com/7K-Inari/inari-catalog/commit/42abcae5701884b21fe7e2d77dca3359500f7abc))
* curated golden-path catalog v1 (5 KRO RGD packages) ([e2f571c](https://github.com/7K-Inari/inari-catalog/commit/e2f571cbda09625d00bf55981d8048fe67e86ece))
* M3-W1 Crossplane AWS packages, platform apps, tenant-zone-aws RGD, policy packs ([ef2c72a](https://github.com/7K-Inari/inari-catalog/commit/ef2c72a9817937b735948a010a751acf4bbffa30))
* publish remaining catalog packages to GHCR ([aa0f143](https://github.com/7K-Inari/inari-catalog/commit/aa0f1435b5a3d73c69cca5fe9c14deff96c68f36))
* publish remaining catalog packages to GHCR ([4d13d4f](https://github.com/7K-Inari/inari-catalog/commit/4d13d4f571caa730329552e5cfc612d83be84c6d))
* **s3-backed-app:** full version with ProviderConfig, encryption, IRSA ([177f9c2](https://github.com/7K-Inari/inari-catalog/commit/177f9c2dbea3dd89f4887374d88ae3b82e6abb8a))


### Bug Fixes

* make RGDs pass kro validation (v0.6.1 CLI-verified) ([dd3d9d4](https://github.com/7K-Inari/inari-catalog/commit/dd3d9d46a6b3290df694aba5f2d3270513166b54))
* **qa:** broken policy CEL, chained-ignore ServiceAccount, unguarded optional lists, helm test assertions ([9d8b6e9](https://github.com/7K-Inari/inari-catalog/commit/9d8b6e901fc7d0533931bbc432e4f1f7a8dc118b))
* **s3-backed-app,tenant-zone-aws:** quote CEL ternary scalars in YAML ([c47711d](https://github.com/7K-Inari/inari-catalog/commit/c47711d9999991f202ca621a49b27b6766591f0e))
* **s3-backed-app:** wire bucketPrefix into bucket name and BUCKET_NAME env ([4406626](https://github.com/7K-Inari/inari-catalog/commit/44066260c8e924b0d9dac7269cf7d6cad665fa39))

## [3.0.0](https://github.com/7K-Inari/inari-catalog/compare/v2.0.0...v3.0.0) (2026-09-13)


### ⚠ BREAKING CHANGES

* **s3-backed-app:** full version with ProviderConfig, encryption, IRSA

### Features

* add incubating s3-backed-app, postgresql-aws-basic, keycloak-client packages ([42abcae](https://github.com/7K-Inari/inari-catalog/commit/42abcae5701884b21fe7e2d77dca3359500f7abc))
* curated golden-path catalog v1 (5 KRO RGD packages) ([e2f571c](https://github.com/7K-Inari/inari-catalog/commit/e2f571cbda09625d00bf55981d8048fe67e86ece))
* M3-W1 Crossplane AWS packages, platform apps, tenant-zone-aws RGD, policy packs ([ef2c72a](https://github.com/7K-Inari/inari-catalog/commit/ef2c72a9817937b735948a010a751acf4bbffa30))
* publish remaining catalog packages to GHCR ([aa0f143](https://github.com/7K-Inari/inari-catalog/commit/aa0f1435b5a3d73c69cca5fe9c14deff96c68f36))
* publish remaining catalog packages to GHCR ([4d13d4f](https://github.com/7K-Inari/inari-catalog/commit/4d13d4f571caa730329552e5cfc612d83be84c6d))
* **s3-backed-app:** full version with ProviderConfig, encryption, IRSA ([177f9c2](https://github.com/7K-Inari/inari-catalog/commit/177f9c2dbea3dd89f4887374d88ae3b82e6abb8a))


### Bug Fixes

* make RGDs pass kro validation (v0.6.1 CLI-verified) ([dd3d9d4](https://github.com/7K-Inari/inari-catalog/commit/dd3d9d46a6b3290df694aba5f2d3270513166b54))
* **qa:** broken policy CEL, chained-ignore ServiceAccount, unguarded optional lists, helm test assertions ([9d8b6e9](https://github.com/7K-Inari/inari-catalog/commit/9d8b6e901fc7d0533931bbc432e4f1f7a8dc118b))
* **s3-backed-app,tenant-zone-aws:** quote CEL ternary scalars in YAML ([c47711d](https://github.com/7K-Inari/inari-catalog/commit/c47711d9999991f202ca621a49b27b6766591f0e))
* **s3-backed-app:** wire bucketPrefix into bucket name and BUCKET_NAME env ([4406626](https://github.com/7K-Inari/inari-catalog/commit/44066260c8e924b0d9dac7269cf7d6cad665fa39))

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
