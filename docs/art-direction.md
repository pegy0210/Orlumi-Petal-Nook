# Art Direction

## Brand line

**Little lights, little wonders.**

Orlumi: Petal Nook must feel like one softly glowing corner of the wider Orlumi universe.

## Visual essence

- dreamy
- soft
- gently glowing
- delicate
- collectible
- premium cute
- quietly magical
- warm and refined

Avoid:

- clutter
- loud casual-game colours
- cheap bundled-goods aesthetics
- generic kawaii
- overly childish proportions
- strong black outlines
- harsh contrast
- photorealism
- obvious imitation of another franchise

## Camera and composition

- Portrait mobile composition
- Semi top-down / 3/4 top-down room view
- Clear front-to-back depth
- Left upper area must remain visually quiet enough for UI information
- Main interactive furniture area sits around the centre-left / centre-lower zone
- Right side remains spatially available for future Area 2, but the base BgRoom must not display a lock marker or locked-area treatment

## Scale and world-language rule

Lumie is **not a human character living in a human-sized home**. The environment should therefore avoid reading like an ordinary adult living room, bedroom, attic studio, or apartment.

Petal Nook should feel like a small spirit-scale nook whose exact physical scale is gently ambiguous. The space exists around Lumie and tiny wonders rather than around human domestic routines.

Prefer:

- open floor and breathing room
- softly rounded architectural forms
- window, plaster, wood, stones, moss, flowers and tiny natural details
- subtle magical light and drifting glow
- small environmental details that could plausibly belong to a tiny spirit world
- proportions that feel charmingly dreamlike rather than architecturally literal

Avoid using human-life props as the main visual language, including:

- sofas or armchairs
- adult beds
- large dining furniture
- dominant bookshelves or office storage
- realistic household doors used as the focal point
- kitchen fittings
- conventional apartment décor
- dense human-scale wall decoration

A window or simple architectural opening may exist, but it should support atmosphere rather than make the scene read as a conventional human residence.

## Rendering style

- soft painterly 2D
- clean readable silhouettes
- gentle diffused light
- subtle bloom and soft glow
- muted pastel palette
- polished but not glossy-plastic
- small details should feel cherished, not crowded
- slightly storybook / dreamlike material treatment rather than realistic interior rendering

## Core palette

### Master six colours

| Name | Hex | Main use |
|---|---|---|
| Mist Cream | `#F3EDE3` | walls, pale panels, soft background light |
| Warm Oat | `#E4D7C3` | floors, neutral cards, warm surfaces |
| Soft Walnut | `#A9876A` | wooden furniture and framing |
| Moss Sage | `#9FAF8C` | plants, natural accents |
| Petal Blush | `#D8B7B0` | flowers, gentle accent details |
| Glow Ivory | `#FFF7EA` | luminous highlights and soft magic |

### Supporting colours

- Dusty Stone — `#C8BBAE`
- Muted Olive — `#7F8D6A`
- Dusty Gold — `#D8C08F`
- Soft Moon Green — `#C7D8C8`

## Lumie palette

Lumie should stay within:

- creamy white
- pastel lavender
- blush pink
- pale gold

Suggested working colours:

- creamy white / glow: `#FFF7EA`
- pale lavender tint: `#DCD3EA`
- blush tint: `#E7C6CB`
- pale gold: `#E2C58E`
- soft shadow: `#B7B1AA`

## Lumie visual anchors

Lumie must never become a generic bunny mascot.

Required features:

- star-shaped ears created through the ear silhouette itself
- glowing droplet tail
- soft luminous eyes
- compact size suitable for several companions sharing one room
- gentle presence with a slightly mysterious quality

Do not substitute decorative stars for the star-ear structure.

## Environment guidance

The room should not feel like a conventional modern home. It should feel softly awakened and slightly removed from ordinary reality without becoming a high-fantasy castle.

The current approved direction is closer to a **quiet magical garden nook / spirit room** than a furnished human home. BgRoom should stay relatively clean because furniture, Lumie and future Area 2 treatment are separate game layers.

Useful qualities:

- rounded plaster and natural wood
- soft stone edging
- tiny plant life
- warm indirect sunlight
- subtle glowing dust
- restrained magical details
- quiet empty areas that give the room air
- gentle floral growth around edges rather than dense centre decoration

## Area 2 visual rule

Area 2 is a **separate later-stage visual layer**.

The base BgRoom must not contain:

- a lock icon
- a locked doorway treatment
- a dashed boundary
- an Area 2 badge
- any other baked-in indication that the region is locked

When Area 2 is introduced, its locked/unlocked treatment will be added as a separate Godot asset/component above the clean background.

## Furniture guidance

- clear silhouette at mobile scale
- same semi-top-down perspective as the room
- gently rounded forms
- handcrafted, delicate and premium-cute
- decorative growth between upgrade stages should be meaningful but controlled

Recommended first-version visual stages:

- Stage A: Lv1–2
- Stage B: Lv3–4
- Stage C: Lv5

## Shop UI guidance

- 2 × 2 card grid
- large centred furniture artwork
- rounded cards
- soft cream / oat base
- understated gold or sage accents
- no dense spreadsheet feeling
- no heavy shadows

## Master AI style prompt

```text
Orlumi universe game asset, premium cute and quietly magical, portrait cozy idle decor game, semi top-down 3/4 view, soft painterly storybook 2D illustration, dreamy gentle glow, delicate collectible design, refined warm pastel palette using mist cream, warm oat, soft walnut, moss sage, petal blush and glow ivory, clean readable silhouette, softly diffused lighting, subtle sense of wonder, calm and uncluttered, a tiny spirit-scale garden nook rather than a conventional human home, open floor, softly rounded natural architecture, gentle flowers and stones around the edges, same visual language as other Orlumi assets
```

## Negative prompt

```text
photorealistic, realistic human apartment, living room, bedroom, attic studio, sofa, adult bed, kitchen, large bookshelf, office furniture, conventional household door as focal point, harsh contrast, thick black outline, neon colours, saturated candy palette, cluttered composition, generic kawaii mascot, cheap mobile game art, plastic 3D render, noisy texture, baked-in lock icon, locked-area marker, text, watermark, cropped object, extra objects
```
