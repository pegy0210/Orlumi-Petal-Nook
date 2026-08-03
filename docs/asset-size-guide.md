# Asset Size Guide

## Reference canvas

- Game resolution reference: **1080 × 1920**
- Orientation: **portrait**
- Background working size may exceed the final canvas slightly to allow positioning adjustments.

## Background and areas

| Asset | Recommended source size | Notes |
|---|---:|---|
| `BgRoom` | 1280 × 2200 | Full portrait background; no Little Pot or lock symbol baked into the image |
| `Area2Locked` | 360 × 540 | Separate subtle locked-area overlay |
| `Area2UnlockedDecor` | 420 × 620 | Separate future Area 2 visual extension |

### BgRoom composition requirements

- Window on the left side, placed low enough to preserve the upper-left UI zone
- Upper-left wall area remains visually quiet
- No flower pot baked into the background
- No lock icon baked into the background
- Main central/lower floor remains usable for furniture and companion movement
- Right side remains open for future Area 2

## Furniture scene assets

| Asset | Recommended source size | Suggested on-screen width |
|---|---:|---:|
| `ObjLittlePot` | 280 × 280 | 170–210 px |
| `ObjWoodenRack` | 320 × 420 | 190–230 px |
| `ObjCurtain` | 360 × 260 | 220–280 px |
| `ObjSmallTable` | 300 × 300 | 170–210 px |

## Lumie assets

| Asset | Recommended source size | Suggested on-screen width |
|---|---:|---:|
| `ObjLumieNormal` | 220 × 220 | 110–145 px |
| `ObjLumieAnnoyed` | 220 × 220 | 110–145 px |
| `LumieShadow` | 180 × 80 | scale with Lumie |
| `ObjLumieEmoji` bubble, optional | 120 × 120 | above Lumie |

Normal and annoyed sprites must share:

- identical canvas dimensions
- identical foot / ground baseline
- identical body placement
- consistent apparent scale

## Shop furniture icons

Each shop icon:

- **220 × 220**
- transparent background
- centred composition
- larger and cleaner than the room version
- same furniture identity and visual stage as the room asset

Required:

- `IconLittlePot`
- `IconWoodenRack`
- `IconCurtain`
- `IconSmallTable`

## Main UI icons

| Asset | Recommended size |
|---|---:|
| `BtnSaveIcon` | 96 × 96 |
| `BtnOfflineBoost` | 96 × 96 |
| `BtnShop` | 96 × 96 |
| `BtnSettings` | 96 × 96 |
| `BtnPhotoMode` | 96 × 96 |
| `BtnCapturePhoto` | 120 × 120 |
| `BtnExitPhotoMode` | 88 × 88 |
| `BtnClose` | 88 × 88 |
| `BtnUpgrade` | 220 × 88 |
| `BtnClaim` | 260 × 96 |

## Panels and shop cards

| Asset | Recommended size |
|---|---:|
| `PanelStoryOverlay` | 1080 × 1920, or generated in-engine |
| `PanelOfflinePopup` | 760 × 520 |
| `PanelShop` | 920 × 1180 |
| `PanelSettings` | 820 × 900 |
| `PanelResetConfirm` | 760 × 420 |
| `CardFurniture` | 380 × 420 |

## Logo

| Asset | Recommended source size | Suggested on-screen width |
|---|---:|---:|
| `LogoPhotoMode` | 520 × 180 | 260–340 px |

## Upgrade-stage production rule

To reduce first-version workload, furniture may use three visual stages instead of a unique image for every level:

- Stage A: Lv1–2
- Stage B: Lv3–4
- Stage C: Lv5

`Lv0` means the scene furniture is hidden.

## File format

- Background: PNG or WebP without transparency requirement
- Furniture, companions, icons and UI: transparent PNG or transparent WebP
- Keep source masters before compression
- Do not bake UI text into panels or buttons unless specifically approved
