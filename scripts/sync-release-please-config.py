#!/usr/bin/env python3
"""Regenerate release-please-config.json package entries from packages/.

Each top-level directory under packages/ becomes a release-please component
(path `packages/<name>`), producing per-package tags `<name>-vX.Y.Z`.
Version source of truth per package: packages/<name>/package.yaml.
"""
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CONFIG = ROOT / "release-please-config.json"

PACKAGE_DEFAULTS = {
    "release-type": "simple",
    "changelog-path": "CHANGELOG.md",
    "bump-minor-pre-major": True,
    "bump-patch-for-minor-pre-major": True,
    "extra-files": ["package.yaml"],
}


def main() -> int:
    config = json.loads(CONFIG.read_text())
    packages_dir = ROOT / "packages"
    components = {}
    if packages_dir.is_dir():
        for child in sorted(packages_dir.iterdir()):
            if child.is_dir() and (child / "package.yaml").is_file():
                components[f"packages/{child.name}"] = dict(PACKAGE_DEFAULTS)
    config["packages"] = components
    CONFIG.write_text(json.dumps(config, indent=2) + "\n")
    print(f"configured {len(components)} package component(s): {', '.join(components) or '(none)'}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
