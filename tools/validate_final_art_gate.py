#!/usr/bin/env python3
"""Strict final-art batch gate for Orlumi: Petal Nook.

Usage: python3 tools/validate_final_art_gate.py 1|2|3
Batch N requires all production assets from batches 1..N to exist.
Dimension/PNG validity remains enforced by validate_assets.py.
"""

from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]

BATCHES: dict[int, list[str]] = {
    1: [
        "assets/backgrounds/main_room/bg_room_main.png",
        "assets/companions/lumie/lumie_normal.png",
        "assets/companions/lumie/lumie_annoyed.png",
        "assets/companions/lumie/lumie_shadow.png",
        *[f"assets/furniture/little_pot/little_pot_lv{level}.png" for level in range(1, 6)],
    ],
    2: [
        *[f"assets/furniture/wooden_rack/wooden_rack_lv{level}.png" for level in range(1, 6)],
        *[f"assets/furniture/curtain/curtain_lv{level}.png" for level in range(1, 6)],
        *[f"assets/furniture/small_table/small_table_lv{level}.png" for level in range(1, 6)],
    ],
    3: [
        "assets/ui/shop_icons/little_pot.png",
        "assets/ui/shop_icons/wooden_rack.png",
        "assets/ui/shop_icons/curtain.png",
        "assets/ui/shop_icons/small_table.png",
        "assets/logos/logo_orlumi_petal_nook.png",
    ],
}


def main() -> int:
    if len(sys.argv) != 2 or sys.argv[1] not in {"1", "2", "3"}:
        print("Usage: validate_final_art_gate.py 1|2|3", file=sys.stderr)
        return 2

    target = int(sys.argv[1])
    required: list[str] = []
    for batch in range(1, target + 1):
        required.extend(BATCHES[batch])

    missing = [path for path in required if not (ROOT / path).exists()]
    if missing:
        for path in missing:
            print(f"FINAL_ART_GATE_MISSING: {path}", file=sys.stderr)
        print(
            f"PETAL_NOOK_FINAL_ART_GATE: FAIL — batch {target} requires "
            f"{len(required) - len(missing)}/{len(required)} assets present",
            file=sys.stderr,
        )
        return 1

    print(f"PETAL_NOOK_FINAL_ART_GATE: PASS — batch {target} ({len(required)}/{len(required)})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
