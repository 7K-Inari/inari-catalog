# Changelog

## [1.3.0](https://github.com/7K-Inari/inari-catalog/compare/v1.2.0...v1.3.0) (2026-09-25)


### Features

* M3-W1 Crossplane AWS packages, platform apps, tenant-zone-aws RGD, policy packs ([ef2c72a](https://github.com/7K-Inari/inari-catalog/commit/ef2c72a9817937b735948a010a751acf4bbffa30))
* publish remaining catalog packages to GHCR ([aa0f143](https://github.com/7K-Inari/inari-catalog/commit/aa0f1435b5a3d73c69cca5fe9c14deff96c68f36))
* publish remaining catalog packages to GHCR ([4d13d4f](https://github.com/7K-Inari/inari-catalog/commit/4d13d4f571caa730329552e5cfc612d83be84c6d))
* **tenant-zone-aws:** Tenant Zone Factory RGD (plan §5.12) ([98c9a21](https://github.com/7K-Inari/inari-catalog/commit/98c9a2117f14c8b38072ab5c65ed6f940df9d702))


### Bug Fixes

* **qa:** broken policy CEL, chained-ignore ServiceAccount, unguarded optional lists, helm test assertions ([9d8b6e9](https://github.com/7K-Inari/inari-catalog/commit/9d8b6e901fc7d0533931bbc432e4f1f7a8dc118b))
* **s3-backed-app,tenant-zone-aws:** quote CEL ternary scalars in YAML ([c47711d](https://github.com/7K-Inari/inari-catalog/commit/c47711d9999991f202ca621a49b27b6766591f0e))

## [1.2.0](https://github.com/7K-Inari/inari-catalog/compare/v1.1.0...v1.2.0) (2026-09-13)


### Features

* M3-W1 Crossplane AWS packages, platform apps, tenant-zone-aws RGD, policy packs ([ef2c72a](https://github.com/7K-Inari/inari-catalog/commit/ef2c72a9817937b735948a010a751acf4bbffa30))
* publish remaining catalog packages to GHCR ([aa0f143](https://github.com/7K-Inari/inari-catalog/commit/aa0f1435b5a3d73c69cca5fe9c14deff96c68f36))
* publish remaining catalog packages to GHCR ([4d13d4f](https://github.com/7K-Inari/inari-catalog/commit/4d13d4f571caa730329552e5cfc612d83be84c6d))
* **tenant-zone-aws:** Tenant Zone Factory RGD (plan §5.12) ([98c9a21](https://github.com/7K-Inari/inari-catalog/commit/98c9a2117f14c8b38072ab5c65ed6f940df9d702))


### Bug Fixes

* **qa:** broken policy CEL, chained-ignore ServiceAccount, unguarded optional lists, helm test assertions ([9d8b6e9](https://github.com/7K-Inari/inari-catalog/commit/9d8b6e901fc7d0533931bbc432e4f1f7a8dc118b))
* **s3-backed-app,tenant-zone-aws:** quote CEL ternary scalars in YAML ([c47711d](https://github.com/7K-Inari/inari-catalog/commit/c47711d9999991f202ca621a49b27b6766591f0e))

## [1.1.0](https://github.com/7K-Inari/inari-catalog/compare/v1.0.0...v1.1.0) (2026-09-13)


### Features

* M3-W1 Crossplane AWS packages, platform apps, tenant-zone-aws RGD, policy packs ([ef2c72a](https://github.com/7K-Inari/inari-catalog/commit/ef2c72a9817937b735948a010a751acf4bbffa30))
* publish remaining catalog packages to GHCR ([aa0f143](https://github.com/7K-Inari/inari-catalog/commit/aa0f1435b5a3d73c69cca5fe9c14deff96c68f36))
* publish remaining catalog packages to GHCR ([4d13d4f](https://github.com/7K-Inari/inari-catalog/commit/4d13d4f571caa730329552e5cfc612d83be84c6d))
* **tenant-zone-aws:** Tenant Zone Factory RGD (plan §5.12) ([98c9a21](https://github.com/7K-Inari/inari-catalog/commit/98c9a2117f14c8b38072ab5c65ed6f940df9d702))


### Bug Fixes

* **qa:** broken policy CEL, chained-ignore ServiceAccount, unguarded optional lists, helm test assertions ([9d8b6e9](https://github.com/7K-Inari/inari-catalog/commit/9d8b6e901fc7d0533931bbc432e4f1f7a8dc118b))
* **s3-backed-app,tenant-zone-aws:** quote CEL ternary scalars in YAML ([c47711d](https://github.com/7K-Inari/inari-catalog/commit/c47711d9999991f202ca621a49b27b6766591f0e))

## 1.0.0 (unreleased)

### Features

* tenant-zone-aws RGD (plan §5.12): Organizations account vend with
  mandatory cost tags, OIDC web-identity trust bootstrap, and EKS starter
  tier (one region, 2× t3.large managed node group) with phase status
  (VendingAccount → BootstrappingTrust → ProvisioningCluster → Active).
