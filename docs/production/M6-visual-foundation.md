# M6 — Visual / Asset Integration Foundation

**Status:** IMPLEMENTED — awaiting approved final art files

## Objective

Prepare the production Godot project so approved Orlumi: Petal Nook artwork can replace developer placeholders without changing gameplay, economy, save, offline or companion logic.

## Implemented

### Production scene layers

`MainRoom` now follows the TDD presentation hierarchy:

1. `Base`
2. `Furniture`
3. `Companions`
4. `UI`
5. `Overlay`

This makes visual replacement and Photo Mode behaviour predictable.

### VisualAssetService

Added:

`game/autoload/visual_asset_service.gd`

Responsibilities:

- resolve approved production PNGs by fixed path convention
- return `null` safely when art is not ready
- cache loaded textures
- keep art availability independent from game state

No gameplay system may depend on an approved image being present.

### Furniture visual slots

Added reusable component:

- `game/scenes/visuals/furniture_visual.tscn`
- `game/scripts/visuals/furniture_visual.gd`

The component:

- reads the current furniture level from `GameState`
- loads the correct level texture automatically
- hides Lv0 furniture
- uses a developer fallback when texture is absent
- preserves a separate tap hitbox for interactive furniture

Little Pot remains tappable through the same component; other v1 furniture is currently visual-only in the room.

### Lumie visual bridge

Lumie's existing movement / reaction / annoyed state machine is unchanged, but its presentation now resolves:

- `lumie_normal.png`
- `lumie_annoyed.png`
- `lumie_shadow.png`

When these files are absent, Lumie uses a text fallback. The interaction hitbox is separate from the artwork.

### Main room background

`MainRoom` now resolves:

`assets/backgrounds/main_room/bg_room_main.png`

If missing, the current warm cream fallback remains visible.

The background is environment-only. Furniture, Lumie and interaction markers are separate nodes.

### Photo Mode logo

Photo Mode now resolves:

`assets/logos/logo_orlumi_petal_nook.png`

A text fallback is used until the approved logo file exists.

## Locked production asset contract

See:

`assets/README.md`

Core naming examples:

```text
assets/backgrounds/main_room/bg_room_main.png
assets/furniture/little_pot/little_pot_lv1.png
assets/furniture/little_pot/little_pot_lv2.png
...
assets/companions/lumie/lumie_normal.png
assets/companions/lumie/lumie_annoyed.png
assets/companions/lumie/lumie_shadow.png
assets/logos/logo_orlumi_petal_nook.png
```

## Important art rule

Do not commit exploratory generations into production asset paths.

Only approved art is copied to the exact filenames consumed by `VisualAssetService`.

## Pending visual work

M6 does **not** declare any placeholder art final.

Still requiring owner/art approval:

- final `BgRoom`
- Little Pot Lv1–Lv5
- Wooden Rack Lv1–Lv5
- Curtain Lv1–Lv5
- Small Table Lv1–Lv5
- Lumie normal
- Lumie annoyed
- Lumie shadow
- final Petal Nook logo
- production UI skin and icons

## Next production gate

Before starting final visual integration, approved assets should be reviewed against the Orlumi brand rules and then copied into the production paths one group at a time.
