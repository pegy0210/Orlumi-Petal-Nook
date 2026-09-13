#!/usr/bin/env python3
"""Static UI contract checks for Orlumi: Petal Nook.

These checks protect the locked portrait HUD/shop structure and ensure the
shared Petal Nook theme remains attached to MainRoom while visual polish evolves.
"""
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
MAIN_ROOM = ROOT / "game/scenes/main_room/main_room.tscn"
SHOP = ROOT / "game/scenes/ui/shop_panel.tscn"
THEME = ROOT / "game/data/petal_nook_theme.tres"

failures: list[str] = []


def require(text: str, needle: str, message: str) -> None:
    if needle not in text:
        failures.append(message)


main_room = MAIN_ROOM.read_text(encoding="utf-8")
shop = SHOP.read_text(encoding="utf-8")
theme = THEME.read_text(encoding="utf-8")

require(main_room, 'path="res://game/data/petal_nook_theme.tres"', "MainRoom must reference Petal Nook theme")
require(main_room, 'theme = ExtResource("9_theme")', "MainRoom root must apply Petal Nook theme")

for node_name in ("Petals", "Income", "Comfort", "OfflineCap"):
    require(main_room, f'[node name="{node_name}" type="Label" parent="UI/ResourceUI"]', f"Top-left HUD missing {node_name}")
for node_name in ("SaveButton", "OfflineBoostButton", "ShopButton", "SettingsButton", "PhotoButton"):
    require(main_room, f'[node name="{node_name}" type="Button" parent="UI"]', f"Top-right HUD missing {node_name}")

require(shop, '[node name="Grid" type="GridContainer" parent="Content"]', "Shop must use GridContainer")
require(shop, "columns = 2", "Shop must remain a 2-column grid")
for card in ("LittlePotCard", "WoodenRackCard", "CurtainCard", "SmallTableCard"):
    require(shop, f'[node name="{card}" type="Panel" parent="Content/Grid"]', f"Shop missing {card}")

require(theme, 'Button/styles/normal = SubResource("StyleBox_button_normal")', "Theme missing normal button style")
require(theme, 'Panel/styles/panel = SubResource("StyleBox_panel")', "Theme missing panel style")
require(theme, "corner_radius_top_left = 24", "Panel theme must keep soft rounded corners")

if failures:
    for failure in failures:
        print(f"UI_CONTRACT_ERROR: {failure}", file=sys.stderr)
    raise SystemExit(1)

print("PETAL_NOOK_UI_CONTRACT: PASS")
