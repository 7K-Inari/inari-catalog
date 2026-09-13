# Changelog

## [1.2.0](https://github.com/7K-Inari/inari-catalog/compare/v1.1.0...v1.2.0) (2026-09-13)


### Features

* M3-W1 Crossplane AWS packages, platform apps, tenant-zone-aws RGD, policy packs ([ef2c72a](https://github.com/7K-Inari/inari-catalog/commit/ef2c72a9817937b735948a010a751acf4bbffa30))
* **policy-packs:** baseline-security, cost-guardrails, org-guardrails-aws ([bc41e49](https://github.com/7K-Inari/inari-catalog/commit/bc41e496eeec0a5946ca862746a3d789f22fbc11))
* publish remaining catalog packages to GHCR ([aa0f143](https://github.com/7K-Inari/inari-catalog/commit/aa0f1435b5a3d73c69cca5fe9c14deff96c68f36))
* publish remaining catalog packages to GHCR ([4d13d4f](https://github.com/7K-Inari/inari-catalog/commit/4d13d4f571caa730329552e5cfc612d83be84c6d))


### Bug Fixes

* **qa:** broken policy CEL, chained-ignore ServiceAccount, unguarded optional lists, helm test assertions ([9d8b6e9](https://github.com/7K-Inari/inari-catalog/commit/9d8b6e901fc7d0533931bbc432e4f1f7a8dc118b))

## [1.1.0](https://github.com/7K-Inari/inari-catalog/compare/v1.0.0...v1.1.0) (2026-09-13)


### Features

* M3-W1 Crossplane AWS packages, platform apps, tenant-zone-aws RGD, policy packs ([ef2c72a](https://github.com/7K-Inari/inari-catalog/commit/ef2c72a9817937b735948a010a751acf4bbffa30))
* **policy-packs:** baseline-security, cost-guardrails, org-guardrails-aws ([bc41e49](https://github.com/7K-Inari/inari-catalog/commit/bc41e496eeec0a5946ca862746a3d789f22fbc11))
* publish remaining catalog packages to GHCR ([aa0f143](https://github.com/7K-Inari/inari-catalog/commit/aa0f1435b5a3d73c69cca5fe9c14deff96c68f36))
* publish remaining catalog packages to GHCR ([4d13d4f](https://github.com/7K-Inari/inari-catalog/commit/4d13d4f571caa730329552e5cfc612d83be84c6d))


### Bug Fixes

* **qa:** broken policy CEL, chained-ignore ServiceAccount, unguarded optional lists, helm test assertions ([9d8b6e9](https://github.com/7K-Inari/inari-catalog/commit/9d8b6e901fc7d0533931bbc432e4f1f7a8dc118b))

## 1.0.0 (unreleased)

### Features

* baseline-security policy pack (plan §5.11): five CEL
  ValidatingAdmissionPolicies (pinned images, required resources, no
  privileged/hostPath/hostNetwork, mandatory tenant label, read-only rootfs
  as warn) with admission tests on kind >= 1.30.
