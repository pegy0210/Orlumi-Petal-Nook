#!/usr/bin/env python3
"""Validate the Android packaging contract for Orlumi: Petal Nook."""

from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PROJECT = ROOT / "project.godot"
EXPORT = ROOT / "export_presets.cfg"


def fail(message: str) -> None:
    print(f"ANDROID_PACKAGING_ERROR: {message}", file=sys.stderr)


def main() -> int:
    failures: list[str] = []

    if not PROJECT.exists():
        failures.append("project.godot is missing")
    if not EXPORT.exists():
        failures.append("export_presets.cfg is missing")

    project_text = PROJECT.read_text(encoding="utf-8") if PROJECT.exists() else ""
    export_text = EXPORT.read_text(encoding="utf-8") if EXPORT.exists() else ""

    project_checks = {
        'config/name="Orlumi: Petal Nook"': "application name",
        'run/main_scene="res://game/scenes/boot/boot.tscn"': "main scene",
        'window/size/viewport_width=1080': "1080 viewport width",
        'window/size/viewport_height=1920': "1920 viewport height",
        'config/features=PackedStringArray("4.3")': "Godot 4.3 feature contract",
    }
    for needle, label in project_checks.items():
        if needle not in project_text:
            failures.append(f"project.godot missing {label}: {needle}")

    export_checks = {
        'name="Android"': "Android preset",
        'platform="Android"': "Android platform",
        'export_path="build/android/Orlumi-Petal-Nook.apk"': "APK export path",
        'package/unique_name="com.orlumi.petalnook"': "package id",
        'package/name="Orlumi: Petal Nook"': "package display name",
        'architectures/arm64-v8a=true': "arm64 ABI",
        'architectures/x86=false': "x86 disabled",
        'architectures/x86_64=false': "x86_64 disabled",
        'gradle_build/min_sdk="23"': "minimum SDK 23",
        'gradle_build/target_sdk="35"': "target SDK 35",
        'version/code=1': "version code",
        'version/name="0.8.0"': "version name",
    }
    for needle, label in export_checks.items():
        if needle not in export_text:
            failures.append(f"export_presets.cfg missing {label}: {needle}")

    if failures:
        for message in failures:
            fail(message)
        return 1

    print("PETAL_NOOK_ANDROID_PACKAGING: PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
