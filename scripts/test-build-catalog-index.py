#!/usr/bin/env python3
"""Tests for scripts/build-catalog-index.py."""
import importlib.util
import tempfile
import unittest
from pathlib import Path

SPEC = importlib.util.spec_from_file_location(
    "build_catalog_index",
    Path(__file__).with_name("build-catalog-index.py"),
)
mod = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(mod)


def write_pkg(root: Path, name: str, **meta) -> None:
    pkg = root / "packages" / name
    pkg.mkdir(parents=True)
    (pkg / "package.yaml").write_text(
        "".join(f"{k}: {v}\n" for k, v in meta.items())
    )


class BuildCatalogIndexTest(unittest.TestCase):
    def test_empty_packages_dir(self):
        with tempfile.TemporaryDirectory() as tmp:
            self.assertEqual(mod.build(Path(tmp)), [])

    def test_entries_have_all_fields(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            write_pkg(
                root,
                "web-service",
                version="1.2.3",
                channel="stable",
                description="Web service",
                category="application",
            )
            packages = mod.build(root)
        (entry,) = packages
        self.assertEqual(
            entry,
            {
                "name": "web-service",
                "version": "1.2.3",
                "channel": "stable",
                "type": "kro-rgd",
                "description": "Web service",
                "category": "application",
                "ociRef": "ghcr.io/7k-inari/catalog/web-service:1.2.3",
                "channelRef": "ghcr.io/7k-inari/catalog/web-service:stable",
            },
        )

    def test_defaults_applied(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            write_pkg(root, "bare", version="0.1.0")
            (entry,) = mod.build(root)
        self.assertEqual(entry["channel"], "incubating")
        self.assertEqual(entry["category"], "uncategorized")
        self.assertEqual(entry["type"], "kro-rgd")

    def test_explicit_type(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            write_pkg(root, "keycloak", version="0.1.0", type="platform-app")
            (entry,) = mod.build(root)
        self.assertEqual(entry["type"], "platform-app")

    def test_dirs_without_package_yaml_skipped(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            (root / "packages" / "not-a-package").mkdir(parents=True)
            self.assertEqual(mod.build(root), [])

    def test_sorted_by_name(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            write_pkg(root, "zeta", version="0.1.0")
            write_pkg(root, "alpha", version="0.1.0")
            packages = mod.build(root)
        self.assertEqual([p["name"] for p in packages], ["alpha", "zeta"])

    def test_render_shape(self):
        text = mod.render(
            [{"name": "a", "version": "0.1.0", "channel": "stable", "type": "kro-rgd",
              "description": "d", "category": "c",
              "ociRef": "o", "channelRef": "ch"}]
        )
        self.assertIn("kind: CatalogIndex", text)
        self.assertIn("  - name: a", text)
        self.assertIn('    type: "kro-rgd"', text)
        self.assertIn('    ociRef: "o"', text)

    def test_folded_description(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            pkg = root / "packages" / "folded"
            pkg.mkdir(parents=True)
            (pkg / "package.yaml").write_text(
                "version: 1.0.0\ndescription: >-\n  Multi-line description:\n  with a colon.\n"
            )
            (entry,) = mod.build(root)
        self.assertEqual(entry["description"], "Multi-line description: with a colon.")

    def test_real_repo_matches_committed_index(self):
        generated = mod.render(mod.build(mod.ROOT))
        committed = (mod.ROOT / "catalog.yaml").read_text()
        self.assertEqual(generated, committed)


if __name__ == "__main__":
    unittest.main()
