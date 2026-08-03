# Asset Folder Guide

Store approved game assets under the following structure when they are ready:

```text
assets/
  backgrounds/
  furniture/
  companions/
  shop-icons/
  ui/
  panels/
  logos/
```

## Naming rules

### Backgrounds

- `bg_room_main.png`
- `area2_locked.png`
- `area2_unlocked_decor.png`

### Furniture

- `little_pot_stage_a.png`
- `little_pot_stage_b.png`
- `little_pot_stage_c.png`
- `wooden_rack_stage_a.png`
- `wooden_rack_stage_b.png`
- `wooden_rack_stage_c.png`
- `curtain_stage_a.png`
- `curtain_stage_b.png`
- `curtain_stage_c.png`
- `small_table_stage_a.png`
- `small_table_stage_b.png`
- `small_table_stage_c.png`

### Companions

- `lumie_normal.png`
- `lumie_annoyed.png`
- `lumie_shadow.png`

### Shop icons

- `icon_little_pot.png`
- `icon_wooden_rack.png`
- `icon_curtain.png`
- `icon_small_table.png`

### UI

- `btn_save.png`
- `btn_offline_boost.png`
- `btn_shop.png`
- `btn_settings.png`
- `btn_photo_mode.png`
- `btn_capture.png`
- `btn_exit_photo.png`
- `btn_upgrade.png`
- `btn_claim.png`
- `btn_close.png`

### Panels

- `panel_shop.png`
- `panel_offline_popup.png`
- `panel_settings.png`
- `panel_reset_confirm.png`
- `card_furniture.png`

### Logos

- `logo_orlumi_petal_nook.png`

## Approval status convention

Do not upload exploratory generations directly as final assets.

Use the following suffixes locally while reviewing:

- `_concept`
- `_review`
- `_approved`

Only remove the suffix and place the asset in its final folder after approval.

## BgRoom rule

The final `bg_room_main` must not contain:

- Little Pot
- lock icon
- Lumie
- standard UI

Those elements are separate GDevelop objects.
