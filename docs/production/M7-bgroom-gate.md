# M7 — Approved Art Integration: BgRoom Gate

**Status:** ACTIVE — WAITING FOR APPROVED BGROOM ART FILE  
**Project:** @Orlumi Studio → @Petal Nook  
**Production path:** `assets/backgrounds/main_room/bg_room_main.png`

## Objective

Lock the main room background before furniture, Lumie and UI art are positioned against it. BgRoom establishes the visual perspective, usable floor, UI breathing room and future Area 2 reservation.

## Final production contract

- File: `assets/backgrounds/main_room/bg_room_main.png`
- Format: PNG
- Source dimensions: **1280 × 2200 px**
- Orientation: portrait
- Gameplay reference canvas: 1080 × 1920
- Camera: semi top-down / 3/4 top-down
- Rendering: soft painterly 2D
- Background contains environment only; gameplay objects remain separate Godot nodes.

## Required composition

1. Window is on the **left**.
2. Window is low enough that the upper-left area remains visually quiet for persistent HUD information.
3. Centre / lower-centre retains open readable floor space for Little Pot, furniture and Lumie movement.
4. Right side remains visually open enough for future Area 2 expansion.
5. Perspective and floor geometry must support furniture placed as separate sprites without obvious mismatch.
6. The room must read clearly at mobile scale without dense decorative noise.

## Forbidden baked elements

The final BgRoom must contain **none** of the following:

- Little Pot
- Lumie or any companion
- lock icon / locked badge
- Curtain gameplay furniture
- Wooden Rack gameplay furniture
- Small Table gameplay furniture
- standard UI / counters / buttons
- logo or text

Small environmental details are allowed only if they cannot be confused with purchasable gameplay furniture.

## Orlumi visual gate

BgRoom must feel like one softly awakened corner of the wider Orlumi universe:

- dreamy and warm
- gentle indirect light
- low-to-medium saturation
- premium cute rather than childish
- calm, uncluttered composition
- quiet magical warmth rather than overt fantasy spectacle
- natural rounded materials and cherished small details

Avoid neon, heavy outlines, glossy-plastic rendering, generic kawaii-room styling, clutter and obvious imitation of another IP.

## Palette anchor

Environment should primarily harmonise with:

- Mist Cream `#F3EDE3`
- Warm Oat `#E4D7C3`
- Soft Walnut `#A9876A`
- Moss Sage `#9FAF8C`
- Petal Blush `#D8B7B0`
- Glow Ivory `#FFF7EA`

Supporting colours may be used in restrained amounts.

## Approval checklist

BgRoom is considered **approved** only when all of these pass:

- [ ] exact 1280 × 2200 PNG production file
- [ ] left window placement approved
- [ ] upper-left HUD zone remains quiet
- [ ] centre/lower floor remains usable
- [ ] right-side Area 2 reserve remains readable
- [ ] no gameplay furniture or Lumie baked in
- [ ] no lock icon / UI / text baked in
- [ ] depth and perspective work with separate object sprites
- [ ] colour saturation and lighting match Orlumi direction
- [ ] no obvious crop-risk at 1080 × 1920 viewport
- [ ] Godot import / boot CI remains green after integration
- [ ] visual review completed in MainRoom with gameplay placeholders visible

## Automatic validation

`tools/validate_assets.py` checks final-path asset dimensions and PNG validity. GitHub CI runs this validator on every push / pull request.

Automatic validation does **not** replace art-direction review. Composition, perspective and brand quality remain a human/Studio approval gate.

## Integration sequence after approval

1. Put approved image at `assets/backgrounds/main_room/bg_room_main.png`.
2. Run asset-contract CI.
3. Godot `VisualAssetService` detects the final path automatically.
4. MainRoom switches from fallback colour to the approved background.
5. Review HUD safe area and room crop at reference viewport.
6. Lock furniture anchor coordinates against the approved room.
7. Proceed to Little Pot approved art integration.

## Decision

Do not start final furniture-position tuning against a temporary or exploratory background. BgRoom approval is the first M7 visual gate.
