# GDevelop Build Log

## Current status

Current implementation stage: **Step 4 — Shop UI skeleton**

## Completed

### Step 1 — MainRoom skeleton

- Project created in GDevelop
- Portrait layout confirmed
- `MainRoom` scene created
- Layers created:
  - `Base`
  - `Furniture`
  - `Companions`
  - `UI`
  - `Overlay`
- Initial scene objects created and placed
- Sprite objects connected to image assets / placeholders

### Step 2 — Variables and UI text

Global variables created for:

- economy
- furniture levels
- unlock flags
- save / offline state
- companion state
- Photo Mode

Scene variables created for UI overlay states.

Initial values currently include:

```text
Petals = 0
Comfort = 2
BaseIncomePerSec = 1
BonusPercent = 0
FinalIncomePerSec = 1
TapValue = 1
LittlePotLevel = 1
WoodenRackLevel = 0
CurtainLevel = 0
SmallTableLevel = 0
OfflineCapMinutes = 60
GameInputLocked = 0 during temporary testing
```

UI text updates correctly by using **set text**, not add text.

Current main UI text:

- `Petals: 0`
- `+1/sec`
- `Comfort: 2`
- `Offline Limit: 60 min`

### Step 3 — Basic petal income

- Passive petal income started
- Little Pot tapping started
- Petal text updates in preview

Passive-income logic:

```text
Petals = Petals + FinalIncomePerSec * TimeDelta()
```

Tap logic:

```text
Petals = Petals + TapValue
```

## Current Step 4 — Shop UI skeleton

### Objects to create / confirm

Main shop:

- `PanelShop`
- `TxtShopTitle`
- `TxtShopPetals`
- `BtnCloseShop`

Little Pot card:

- `CardLittlePot`
- `IconLittlePot`
- `TxtLittlePotName`
- `TxtLittlePotLevel`
- `TxtLittlePotNext`
- `TxtLittlePotPrice`
- `BtnLittlePotUpgrade`

All shop elements belong on the `Overlay` layer.

### Initial Little Pot card content

- Name: `Little Pot`
- Level: `Lv.1`
- Next: `Next: 2/sec`
- Price: `30`
- Button: `Upgrade`

### Shop-open conditions

- Cursor / touch is on `BtnShop`
- Mouse / touch released
- `GameInputLocked = 0`
- `PhotoModeActive = 0`

Actions:

- show shop panel and card objects
- `ShopOpen = 1`
- `GameInputLocked = 1`

### Shop-close conditions

- Cursor / touch is on `BtnCloseShop`
- Mouse / touch released

Actions:

- hide shop panel and card objects
- `ShopOpen = 0`
- `GameInputLocked = 0`

## Known project-saving issue

The original GDevelop project instance stopped saving normally, while **Save As** worked. The Save As copy should be treated as the active project. The older project should remain only as a backup and should not receive further edits.

## Next implementation sequence

1. Complete Step 4 shop open / close behaviour
2. Step 5 — Little Pot real upgrade from Lv1 to Lv2
3. Add the remaining three furniture cards
4. Recalculate full economy after each purchase
5. Trigger Lumie's first appearance after the first real purchase / upgrade
6. Add Lumie movement and reactions
7. Add opening and Lumie intro
8. Add save / load
9. Add offline reward and rewarded-ad cap extension
10. Add settings and double-confirm reset
11. Add Photo Mode and screenshot flow
12. Android export and device testing

## Temporary testing notes

Until the opening flow is implemented, `GameInputLocked` may remain `0` at scene start for testing. It must later return to the formal flow:

- lock input during opening and modal overlays
- unlock after the active blocking overlay closes
