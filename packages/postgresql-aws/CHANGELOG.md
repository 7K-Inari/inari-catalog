# Changelog

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
