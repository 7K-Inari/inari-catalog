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

TYPE_FILES = {
    "kro-rgd": ("rgd.yaml",),
    "platform-app": ("chart.yaml", "values-defaults.yaml"),
    "policy-pack": ("policies.yaml",),
}
VALID_TYPES = tuple(TYPE_FILES)


def package_type(pkg: Path) -> str:
    for line in (pkg / "package.yaml").read_text().splitlines():
        m = re.match(r"^type:\s*(\S+)", line)
        if m:
            return m.group(1)
    return "kro-rgd"


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
            ptype = package_type(pkg)
            if ptype not in VALID_TYPES:
                errors.append(f"{pkg}: unknown type '{ptype}' (expected one of {', '.join(VALID_TYPES)})")
                continue
            for required in TYPE_FILES[ptype]:
                if not (pkg / required).is_file():
                    errors.append(f"{pkg}: missing {required} (type: {ptype})")
            if ptype == "kro-rgd" and (pkg / "rgd.yaml").is_file():
                check_rgd(pkg / "rgd.yaml", errors)
            hints = ("ui-hints.yaml", "README.md") if ptype == "kro-rgd" else ("README.md",)
            for hint in hints:
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
