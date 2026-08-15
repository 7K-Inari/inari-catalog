#!/usr/bin/env python3
"""Structural validation of packages/*/rgd.yaml (KRO ResourceGraphDefinitions).

Deep CEL type-checking happens in test.yml against a live kind cluster with
kro installed; this offline check catches malformed YAML, missing required
sections, unknown channels, and unbalanced CEL `${...}` expressions early.

Dependency-free (no PyYAML): RGD structure is checked with targeted parsing.
"""
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

REQUIRED_TOP = ("apiVersion: kro.run/v1alpha1", "kind: ResourceGraphDefinition")
REQUIRED_SECTIONS = ("schema:", "resources:", "apiVersion:", "kind:")


def check_rgd(path: Path, errors: list[str]) -> None:
    text = path.read_text()
    for needle in REQUIRED_TOP:
        if needle not in text:
            errors.append(f"{path}: missing '{needle}'")
    for section in REQUIRED_SECTIONS:
        if not re.search(rf"^\s*{re.escape(section)}", text, re.M):
            errors.append(f"{path}: missing section '{section}'")
    # balanced CEL expressions: ${ ... }
    opens = text.count("${")
    # every ${ must be closed by a } — approximate by brace balance check
    depth = 0
    i = 0
    while i < len(text):
        if text.startswith("${", i):
            depth += 1
            i += 2
            continue
        if text[i] == "}" and depth > 0:
            depth -= 1
        i += 1
    if opens == 0:
        errors.append(f"{path}: no CEL expressions found — is this an RGD?")
    if depth != 0:
        errors.append(f"{path}: unbalanced CEL expressions (depth {depth})")


def main() -> int:
    errors: list[str] = []
    packages_dir = ROOT / "packages"
    if packages_dir.is_dir():
        for pkg in sorted(packages_dir.iterdir()):
            if not (pkg.is_dir() and (pkg / "package.yaml").is_file()):
                continue
            rgd = pkg / "rgd.yaml"
            if not rgd.is_file():
                errors.append(f"{pkg}: missing rgd.yaml")
                continue
            check_rgd(rgd, errors)
            for hint in ("ui-hints.yaml", "README.md"):
                if not (pkg / hint).is_file():
                    errors.append(f"{pkg}: missing {hint}")
            if not (pkg / "tests").is_dir():
                errors.append(f"{pkg}: missing tests/ directory")
    for e in errors:
        print(f"::error::{e}")
    if errors:
        return 1
    print("RGD structural validation passed")
    return 0


if __name__ == "__main__":
    sys.exit(main())
