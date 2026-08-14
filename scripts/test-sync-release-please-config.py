#!/usr/bin/env python3
"""Tests for sync-release-please-config.py (stdlib unittest, no deps)."""
import importlib.util
import json
import tempfile
import unittest
from pathlib import Path

SPEC = importlib.util.spec_from_file_location(
    "sync", Path(__file__).parent / "sync-release-please-config.py"
)
sync_mod = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(sync_mod)

BASE_CONFIG = {
    "$schema": "https://example.com/schema.json",
    "skip-github-release": True,
    "packages": {"packages/stale": {"release-type": "simple"}},
}


class SyncTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.root = Path(self.tmp.name)
        (self.root / "release-please-config.json").write_text(json.dumps(BASE_CONFIG))

    def tearDown(self):
        self.tmp.cleanup()

    def add_package(self, name, with_manifest=True):
        pkg = self.root / "packages" / name
        pkg.mkdir(parents=True)
        if with_manifest:
            (pkg / "package.yaml").write_text("version: 0.1.0\nchannel: incubating\n")

    def config(self):
        return json.loads((self.root / "release-please-config.json").read_text())

    def test_components_for_packages_with_package_yaml(self):
        self.add_package("foo")
        self.add_package("bar")
        self.add_package("incomplete", with_manifest=False)
        components = sync_mod.sync(self.root)
        self.assertEqual(components, ["packages/bar", "packages/foo"])

    def test_component_settings(self):
        self.add_package("foo")
        sync_mod.sync(self.root)
        comp = self.config()["packages"]["packages/foo"]
        self.assertEqual(comp["release-type"], "simple")
        self.assertEqual(comp["extra-files"], ["package.yaml"])
        self.assertTrue(comp["bump-minor-pre-major"])

    def test_stale_components_removed(self):
        sync_mod.sync(self.root)
        self.assertEqual(self.config()["packages"], {})

    def test_no_packages_dir_yields_empty(self):
        sync_mod.sync(self.root)
        self.assertEqual(self.config()["packages"], {})

    def test_other_top_level_keys_preserved(self):
        sync_mod.sync(self.root)
        cfg = self.config()
        self.assertEqual(cfg["$schema"], BASE_CONFIG["$schema"])
        self.assertTrue(cfg["skip-github-release"])


if __name__ == "__main__":
    unittest.main()
