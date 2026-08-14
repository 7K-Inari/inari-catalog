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


def sync(root: Path) -> list[str]:
    config_path = root / "release-please-config.json"
    config = json.loads(config_path.read_text())
    packages_dir = root / "packages"
    components = {}
    if packages_dir.is_dir():
        for child in sorted(packages_dir.iterdir()):
            if child.is_dir() and (child / "package.yaml").is_file():
                components[f"packages/{child.name}"] = dict(PACKAGE_DEFAULTS)
    config["packages"] = components
    config_path.write_text(json.dumps(config, indent=2) + "\n")
    return sorted(components)


def main() -> int:
    components = sync(ROOT)
    print(f"configured {len(components)} package component(s): {', '.join(components) or '(none)'}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
