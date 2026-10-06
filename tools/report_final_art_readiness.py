#!/usr/bin/env python3
"""Report production-art completeness for Orlumi: Petal Nook.

This report is informational during M7.9: missing final PNGs do not fail CI.
Invalid files are already enforced by tools/validate_assets.py.
"""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

BATCHES: dict[str, list[str]] = {
    "Batch 1 — Room identity": [
        "assets/backgrounds/main_room/bg_room_main.png",
        "assets/companions/lumie/lumie_normal.png",
        "assets/companions/lumie/lumie_annoyed.png",
        "assets/companions/lumie/lumie_shadow.png",
        *[f"assets/furniture/little_pot/little_pot_lv{level}.png" for level in range(1, 6)],
    ],
    "Batch 2 — Room progression": [
        *[f"assets/furniture/wooden_rack/wooden_rack_lv{level}.png" for level in range(1, 6)],
        *[f"assets/furniture/curtain/curtain_lv{level}.png" for level in range(1, 6)],
        *[f"assets/furniture/small_table/small_table_lv{level}.png" for level in range(1, 6)],
    ],
    "Batch 3 — UI finishing": [
        "assets/ui/shop_icons/little_pot.png",
        "assets/ui/shop_icons/wooden_rack.png",
        "assets/ui/shop_icons/curtain.png",
        "assets/ui/shop_icons/small_table.png",
        "assets/logos/logo_orlumi_petal_nook.png",
    ],
}

OPTIONAL_LATER = ["assets/backgrounds/main_room/area2_locked.png"]


def main() -> int:
    total_present = 0
    total_required = 0

    print("PETAL_NOOK_FINAL_ART_READINESS")
    for batch_name, paths in BATCHES.items():
        present = [path for path in paths if (ROOT / path).exists()]
        missing = [path for path in paths if not (ROOT / path).exists()]
        total_present += len(present)
        total_required += len(paths)
        print(f"{batch_name}: {len(present)}/{len(paths)} present")
        for path in missing:
            print(f"  PENDING: {path}")

    optional_present = sum((ROOT / path).exists() for path in OPTIONAL_LATER)
    print(f"Optional later-state art: {optional_present}/{len(OPTIONAL_LATER)} present")
    print(f"TOTAL REQUIRED FINAL ART: {total_present}/{total_required}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
