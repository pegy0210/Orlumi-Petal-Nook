#!/usr/bin/env python3
"""Lightweight asset-contract validator for Orlumi: Petal Nook.

No third-party packages are required. The validator is intentionally strict only
for assets that have already been placed in their final production paths.
Missing future assets are reported as pending, not failures.
"""

from __future__ import annotations

import struct
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

PNG_CONTRACTS: dict[str, tuple[int, int]] = {
    "assets/backgrounds/main_room/bg_room_main.png": (1280, 2200),
    "assets/backgrounds/main_room/area2_locked.png": (1280, 2200),
    "assets/companions/lumie/lumie_normal.png": (220, 220),
    "assets/companions/lumie/lumie_annoyed.png": (220, 220),
    "assets/companions/lumie/lumie_shadow.png": (180, 80),
    "assets/ui/shop_icons/little_pot.png": (220, 220),
    "assets/ui/shop_icons/wooden_rack.png": (220, 220),
    "assets/ui/shop_icons/curtain.png": (220, 220),
    "assets/ui/shop_icons/small_table.png": (220, 220),
    "assets/logos/logo_orlumi_petal_nook.png": (520, 180),
}

for level in range(1, 6):
    PNG_CONTRACTS[f"assets/furniture/little_pot/little_pot_lv{level}.png"] = (280, 280)
    PNG_CONTRACTS[f"assets/furniture/wooden_rack/wooden_rack_lv{level}.png"] = (320, 420)
    PNG_CONTRACTS[f"assets/furniture/curtain/curtain_lv{level}.png"] = (360, 260)
    PNG_CONTRACTS[f"assets/furniture/small_table/small_table_lv{level}.png"] = (300, 300)


def read_png_size(path: Path) -> tuple[int, int]:
    with path.open("rb") as handle:
        signature = handle.read(8)
        if signature != b"\x89PNG\r\n\x1a\n":
            raise ValueError("not a PNG file")
        length = struct.unpack(">I", handle.read(4))[0]
        chunk_type = handle.read(4)
        if chunk_type != b"IHDR" or length < 8:
            raise ValueError("invalid PNG IHDR")
        width, height = struct.unpack(">II", handle.read(8))
        return width, height


def main() -> int:
    failures: list[str] = []
    present = 0

    for relative_path, expected_size in PNG_CONTRACTS.items():
        path = ROOT / relative_path
        if not path.exists():
            print(f"PENDING: {relative_path}")
            continue

        present += 1
        try:
            actual_size = read_png_size(path)
        except Exception as exc:  # noqa: BLE001 - concise CI reporting
            failures.append(f"{relative_path}: {exc}")
            continue

        if actual_size != expected_size:
            failures.append(
                f"{relative_path}: expected {expected_size[0]}x{expected_size[1]}, "
                f"got {actual_size[0]}x{actual_size[1]}"
            )
        else:
            print(f"PASS: {relative_path} {actual_size[0]}x{actual_size[1]}")

    if failures:
        for failure in failures:
            print(f"ASSET_CONTRACT_ERROR: {failure}", file=sys.stderr)
        return 1

    print(f"PETAL_NOOK_ASSET_CONTRACT: PASS ({present} final assets currently present)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
