# Orlumi: Petal Nook — Production Asset Guide

Approved production art is stored under `assets/` and resolved automatically by `VisualAssetService`.

Exploratory or review images must **not** be dropped into the production paths below until approved.

## Production structure

```text
assets/
  backgrounds/
    main_room/
      bg_room_main.png
      area2_locked.png        # future separate overlay; not part of base BgRoom
  furniture/
    little_pot/
      little_pot_lv1.png
      little_pot_lv2.png
      little_pot_lv3.png
      little_pot_lv4.png
      little_pot_lv5.png
    wooden_rack/
      wooden_rack_lv1.png ... wooden_rack_lv5.png
    curtain/
      curtain_lv1.png ... curtain_lv5.png
    small_table/
      small_table_lv1.png ... small_table_lv5.png
  companions/
    lumie/
      lumie_normal.png
      lumie_annoyed.png
      lumie_shadow.png
  ui/
    shop_icons/
      little_pot.png
      wooden_rack.png
      curtain.png
      small_table.png
  logos/
    logo_orlumi_petal_nook.png
```

## Automatic fallback behaviour

If an approved PNG does not yet exist, the Godot project keeps running with a developer fallback. Adding the correctly named file is enough for the relevant visual slot to use it on the next project run.

Gameplay state, economy, save data and unlock logic must never depend on whether final art is present.

## Reference sizes

- Main room background: `1280 × 2200`
- Little Pot: `280 × 280`
- Wooden Rack: `320 × 420`
- Curtain: `360 × 260`
- Small Table: `300 × 300`
- Lumie normal / annoyed: `220 × 220`
- Lumie shadow: `180 × 80`
- Shop icon: `220 × 220`
- Photo Mode logo: `520 × 180`

Transparent PNG is preferred for furniture, companions, shadow and UI assets.

## Approval workflow

During review, files may use local suffixes such as:

- `_concept`
- `_review`
- `_approved`

Only the final approved version is copied into the exact production path/name above. Production filenames do not use review suffixes.

## Main room background rules

`assets/backgrounds/main_room/bg_room_main.png` is the first M7 approved-art gate and must be an exact **1280 × 2200 PNG** containing **environment only**.

It must not contain:

- Little Pot
- Wooden Rack
- Curtain
- Small Table
- Lumie or another companion
- lock icon / locked badge
- locked doorway treatment
- Area 2 boundary or marker
- gameplay UI
- Photo Mode controls
- logo or text
- dominant human-scale living-room / bedroom / kitchen objects

Composition requirements:

- portrait semi top-down / 3/4 perspective
- window on the left and low enough to preserve the top-left information zone
- clean top-left UI area
- generous open centre/lower floor for separate game objects
- right side retains spatial capacity for future Area 2 but looks natural before Area 2 is shown
- soft garden/spirit-nook feeling rather than a conventional human residence
- restrained flowers, stones and plant growth concentrated around edges rather than filling the play area

Full acceptance criteria: `docs/production/M7-bgroom-gate.md`.

## Area 2 asset rule

`area2_locked.png` is a **future state-driven overlay**, not part of `bg_room_main.png`.

The clean base background must work without any visible lock state. When the Area 2 feature is implemented, the overlay can be shown or hidden independently by Godot based on game state.

## Lumie non-negotiable identity rules

Approved Lumie art must retain:

- star-ears formed by the ear shape itself, not decorative stars
- glowing droplet tail
- soft luminous eyes
- creamy white, pastel lavender, blush pink and pale gold palette

Do not replace these identity features with generic bunny styling.

## Automatic validation

`tools/validate_assets.py` checks final-path production assets that are present. Missing future assets are treated as pending; an invalid final-path asset fails GitHub CI.
