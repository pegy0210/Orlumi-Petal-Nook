# M7 — Approved Art Integration: BgRoom Gate

**Status:** ACTIVE — WAITING FOR APPROVED CLEAN BGROOM ART FILE  
**Project:** @Orlumi Studio → @Petal Nook  
**Production path:** `assets/backgrounds/main_room/bg_room_main.png`

## Objective

Lock the **clean base environment** before furniture, Lumie, Area 2 treatment and UI art are positioned against it. BgRoom establishes visual perspective, usable floor and UI breathing room, but must not permanently bake future gameplay-state indicators into the background.

## Final production contract

- File: `assets/backgrounds/main_room/bg_room_main.png`
- Format: PNG
- Source dimensions: **1280 × 2200 px**
- Orientation: portrait
- Gameplay reference canvas: 1080 × 1920
- Camera: semi top-down / 3/4 top-down
- Rendering: soft painterly storybook 2D
- Background contains **environment only**; gameplay objects and state indicators remain separate Godot nodes.

## Required composition

1. Window is on the **left**.
2. Window is low enough that the upper-left area remains visually quiet for persistent HUD information.
3. Centre / lower-centre retains generous open readable floor space for Little Pot, furniture and Lumie movement.
4. Right side retains enough physical room for a future Area 2 layer, but should look natural and complete even before Area 2 is revealed.
5. Perspective and floor geometry must support furniture placed as separate sprites without obvious mismatch.
6. The room must read clearly at mobile scale without dense decorative noise.
7. The world must feel suited to a tiny spirit such as Lumie rather than a conventional human household.

## Clean-background rule

The base BgRoom should be deliberately **cleaner than a normal illustrated room**.

Prefer:

- open floor
- soft wall / natural boundary
- plants, flowers, small stones and subtle organic growth concentrated around edges
- warm filtered light
- restrained glowing motes
- a few cherished environmental details only

Avoid filling the scene with human domestic objects. The purpose of the background is to create a stage for collectible furniture and companions, not to pre-decorate the room.

## Forbidden baked elements

The final BgRoom must contain **none** of the following:

- Little Pot
- Lumie or any companion
- lock icon / locked badge
- locked doorway treatment
- Area 2 boundary line or marker
- Curtain gameplay furniture
- Wooden Rack gameplay furniture
- Small Table gameplay furniture
- standard UI / counters / buttons
- logo or text
- sofa, adult bed, kitchen fittings or other dominant human-scale living-room objects

Small environmental details are allowed only if they cannot be confused with purchasable gameplay furniture.

## Area 2 separation rule

Area 2 is **not part of the base background state**.

The right-side reserve exists only as spatial capacity in BgRoom. The player should not see a lock icon or explicit locked-area treatment in the clean background.

When Area 2 is introduced later, the locked/unlocked presentation will be handled by a separate Godot visual component, using a future asset such as:

`assets/backgrounds/main_room/area2_locked.png`

That layer may appear only when the corresponding game state requires it and can later be replaced or removed without altering `bg_room_main.png`.

## Orlumi visual gate

BgRoom must feel like one softly awakened corner of the wider Orlumi universe:

- dreamy and warm
- gentle indirect light
- low-to-medium saturation
- premium cute rather than childish
- calm, uncluttered composition
- quiet magical warmth rather than overt fantasy spectacle
- natural rounded materials and cherished small details
- slightly ambiguous spirit-scale proportions rather than realistic human architecture

Avoid neon, heavy outlines, glossy-plastic rendering, generic kawaii-room styling, clutter, conventional human-home staging and obvious imitation of another IP.

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
- [ ] centre/lower floor remains generously usable
- [ ] right side leaves future Area 2 spatial capacity without showing a lock state
- [ ] no gameplay furniture or Lumie baked in
- [ ] no lock icon / Area 2 marker / UI / text baked in
- [ ] no dominant human-household styling
- [ ] depth and perspective work with separate object sprites
- [ ] colour saturation and lighting match Orlumi direction
- [ ] no obvious crop-risk at 1080 × 1920 viewport
- [ ] Godot import / boot CI remains green after integration
- [ ] visual review completed in MainRoom with gameplay placeholders visible

## Automatic validation

`tools/validate_assets.py` checks final-path asset dimensions and PNG validity. GitHub CI runs this validator on every push / pull request.

Automatic validation does **not** replace art-direction review. Composition, perspective and brand quality remain a human/Studio approval gate.

## Integration sequence after approval

1. Put approved clean image at `assets/backgrounds/main_room/bg_room_main.png`.
2. Run asset-contract CI.
3. Godot `VisualAssetService` detects the final path automatically.
4. MainRoom switches from fallback colour to the approved background.
5. Review HUD safe area and room crop at reference viewport.
6. Calibrate furniture anchors and Lumie movement against the approved room.
7. Lock MainRoom Layout v1.
8. Proceed to Little Pot approved art integration.
9. Add Area 2 locked visual later as a separate state-driven component; do not edit the base background for it.

## Decision

Do not start final furniture-position tuning against a temporary or exploratory background. BgRoom approval is the first M7 visual gate, but **Area 2 lock treatment is explicitly deferred and separate from BgRoom**.
