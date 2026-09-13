# Changelog

## [2.0.0](https://github.com/7K-Inari/inari-catalog/compare/v1.0.0...v2.0.0) (2026-09-13)


### ⚠ BREAKING CHANGES

* **postgresql-aws:** full RDS package with per-account ProviderConfig

### Features

* M3-W1 Crossplane AWS packages, platform apps, tenant-zone-aws RGD, policy packs ([ef2c72a](https://github.com/7K-Inari/inari-catalog/commit/ef2c72a9817937b735948a010a751acf4bbffa30))
* **postgresql-aws:** full RDS package with per-account ProviderConfig ([3f24ce3](https://github.com/7K-Inari/inari-catalog/commit/3f24ce3949e9867c7c89bb29fcced0fccb8e126f))
* publish remaining catalog packages to GHCR ([aa0f143](https://github.com/7K-Inari/inari-catalog/commit/aa0f1435b5a3d73c69cca5fe9c14deff96c68f36))
* publish remaining catalog packages to GHCR ([4d13d4f](https://github.com/7K-Inari/inari-catalog/commit/4d13d4f571caa730329552e5cfc612d83be84c6d))


### Bug Fixes

* **qa:** broken policy CEL, chained-ignore ServiceAccount, unguarded optional lists, helm test assertions ([9d8b6e9](https://github.com/7K-Inari/inari-catalog/commit/9d8b6e901fc7d0533931bbc432e4f1f7a8dc118b))

## 1.0.0 (unreleased)

### Breaking changes

* package renamed from `postgresql-aws-basic` to `postgresql-aws`; the
  generated CRD kind is now `PostgreSQLAWS` and the OCI artifact moves to
  `ghcr.io/7k-inari/catalog/postgresql-aws`.
* new required field `providerConfigName` pins every managed resource to a
  per-account Crossplane `ProviderConfig` (platform plan §5.7).

### Features

* full RDS posture: multiAZ, storage encryption, deletion protection,
  backup retention, VPC security groups; status endpoint/port/ready;
  readyWhen on the instance Ready condition.

## 1.0.0 (2026-08-15)


### Features

* add incubating s3-backed-app, postgresql-aws-basic, keycloak-client packages ([42abcae](https://github.com/7K-Inari/inari-catalog/commit/42abcae5701884b21fe7e2d77dca3359500f7abc))
* curated golden-path catalog v1 (5 KRO RGD packages) ([e2f571c](https://github.com/7K-Inari/inari-catalog/commit/e2f571cbda09625d00bf55981d8048fe67e86ece))


### Bug Fixes

* make RGDs pass kro validation (v0.6.1 CLI-verified) ([dd3d9d4](https://github.com/7K-Inari/inari-catalog/commit/dd3d9d46a6b3290df694aba5f2d3270513166b54))
