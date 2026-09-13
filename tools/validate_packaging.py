#!/usr/bin/env python3
"""Validate non-secret Android packaging configuration for Petal Nook.

This does not build an APK. It only catches accidental drift in the committed
Godot project/export metadata before a real Android SDK/export-template build.
"""

from __future__ import annotations

import configparser
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def fail(message: str) -> int:
    print(f"PACKAGING_CONTRACT_ERROR: {message}", file=sys.stderr)
    return 1


def main() -> int:
    project_path = ROOT / "project.godot"
    preset_path = ROOT / "export_presets.cfg"
    if not project_path.exists():
        return fail("project.godot missing")
    if not preset_path.exists():
        return fail("export_presets.cfg missing")

    project_text = project_path.read_text(encoding="utf-8")
    required_project_lines = [
        'config/name="Orlumi: Petal Nook"',
        'run/main_scene="res://game/scenes/boot/boot.tscn"',
        'window/size/viewport_width=1080',
        'window/size/viewport_height=1920',
    ]
    for line in required_project_lines:
        if line not in project_text:
            return fail(f"project contract missing: {line}")

    preset_text = preset_path.read_text(encoding="utf-8")
    required_preset_lines = [
        'name="Android"',
        'platform="Android"',
        'export_path="build/android/Orlumi-Petal-Nook.apk"',
        'package/unique_name="com.orlumi.petalnook"',
        'package/name="Orlumi: Petal Nook"',
        'architectures/arm64-v8a=true',
    ]
    for line in required_preset_lines:
        if line not in preset_text:
            return fail(f"Android preset contract missing: {line}")

    print("PETAL_NOOK_PACKAGING_CONTRACT: PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
