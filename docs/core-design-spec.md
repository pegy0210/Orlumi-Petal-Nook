# Core Design Specification

## Product identity

- **Title:** Orlumi: Petal Nook
- **Traditional Chinese title:** Orlumi：小花窩
- **Platform:** Android first
- **Orientation:** Portrait
- **Game type:** Cozy clicker / idle decor game
- **Primary language:** English
- **Supporting localization:** Traditional Chinese

## Brand-universe alignment

Orlumi: Petal Nook is one corner of the wider Orlumi universe. It should feel connected to the same ideas of little lights, tiny wonders, gentle surprises and cherished details.

The game must not feel like a generic low-cost kawaii room game. It should remain soft, dreamy, refined, collectible and quietly magical.

## Opening text

### English

Somewhere within Orlumi,  
there is a little house.  
Inside, a flower waits in silence.  
This is where your nook begins.

### Traditional Chinese

在 Orlumi 的某個角落，  
有一間小小的屋。  
屋裡，一盆花靜靜地等待著。  
這裡，就是你的小花窩開始的地方。

## Lumie first appearance text

### English

With the first piece placed,  
the little house stirs softly.  
A tiny companion has drawn near.  
Its name is Lumie.

### Traditional Chinese

當第一件傢俱安放好後，  
小屋也輕輕甦醒過來。  
一位小小的同伴被吸引而來。  
牠的名字，叫 Lumie。

## Main gameplay loop

Collect petals → upgrade furniture → increase income → raise comfort → gradually unlock more of the nook.

## Furniture level rules

- `Lv0` = not present
- `Lv1` = first visible level
- `Lv2+` = upgraded states

### Little Pot exception

- Little Pot is already present when the game starts.
- `LittlePotLevel = 1` at the beginning.
- The first paid action upgrades Little Pot from Lv1 to Lv2.
- Lumie does not appear simply because Little Pot already exists.

### Starting furniture state

- Little Pot: Lv1
- Wooden Rack: Lv0
- Curtain: Lv0
- Small Table: Lv0

## Starting economy

- `Petals = 0`
- `Comfort = 2`
- `BaseIncomePerSec = 1`
- `BonusPercent = 0`
- `FinalIncomePerSec = 1`
- `TapValue = 1`

## Furniture data

### Little Pot

| Level | Income | Tap bonus | Comfort |
|---|---:|---:|---:|
| 1 | 1/sec | 0 | 2 |
| 2 | 2/sec | 0 | 4 |
| 3 | 3/sec | +1 | 7 |
| 4 | 5/sec | +1 | 10 |
| 5 | 7/sec | +1 | 14 |

Upgrade prices:

- Lv1 → Lv2: 30
- Lv2 → Lv3: 60
- Lv3 → Lv4: 120
- Lv4 → Lv5: 240

### Wooden Rack

- Prices: 50 / 100 / 200 / 400 / 800
- Income: 1 / 2 / 4 / 6 / 9
- Comfort: 4 / 8 / 13 / 18 / 24

### Curtain

- Prices: 120 / 240 / 480 / 960 / 1920
- Bonus: +5 / +10 / +15 / +22 / +30%
- Comfort: 6 / 12 / 19 / 26 / 34

### Small Table

- Prices: 300 / 600 / 1200 / 2400 / 4800
- Bonus: +5 / +8 / +12 / +16 / +20%
- Comfort: 10 / 20 / 32 / 44 / 59

## Lumie unlock

Lumie appears only after the player's first real upgrade or purchase.

Trigger when any one condition becomes true:

- `LittlePotLevel >= 2`
- `WoodenRackLevel >= 1`
- `CurtainLevel >= 1`
- `SmallTableLevel >= 1`

## Lumie role in v1

- Companion only
- No income bonus
- No comfort bonus
- No resource bonus
- No gameplay function beyond presence and interaction

## Lumie identity rules

- Star-shaped ears are the primary identifier.
- The star quality comes from the ear shape itself, not decorative stars.
- Lumie has a glowing droplet tail.
- Lumie has soft luminous eyes.
- Palette remains within creamy white, pastel lavender, blush pink and pale gold.

## Lumie interaction

- Tapping Lumie can trigger one random emoji.
- An emoji cannot refresh while visible.
- It disappears naturally after a short duration.
- A 1–2 second cooldown follows before another reaction can occur.

Suggested normal emoji pool:

- 🌸
- ✨
- 😊
- 💛
- 😴
- ❔

### Annoyed mechanic

From the sixth successful tap cycle onward, Lumie can enter annoyed state by probability:

- taps 6–7: 25%
- taps 8–9: 50%
- taps 10+: 100%

When annoyed:

- Lumie switches to an annoyed appearance.
- It may show an angry emoji or no reaction.
- It stops responding for 30 seconds.
- It then returns to normal and resets the tap count.

The same interaction remains active in Photo Mode.

## Offline reward system

- Base offline cap: 60 minutes
- Each rewarded ad increases the future offline cap by 15 minutes
- Maximum cap: 120 minutes

This does not add 15 minutes of reward after the player returns. It expands the future amount of offline time that can be accumulated.

Formula:

```text
OfflineSeconds = min(realOfflineSeconds, OfflineCapMinutes * 60)
OfflineRewardPending = FinalIncomePerSec * OfflineSeconds * 0.1
```

## Save system

- Manual save icon on the main screen
- Autosave every 60 seconds
- Immediate save after upgrades, unlocks and major events
- Save when app moves to background or closes

## Reset rules

- Double confirmation required
- Progress is reset
- Paid entitlements are preserved

Progress reset includes:

- petals
- comfort
- furniture levels
- story flags
- Lumie progress
- offline cap back to 60 minutes

Paid entitlements preserved include:

- remove ads
- permanent unlocks
- theme packs
- other non-consumable purchases

## Shop layout

- Portrait overlay
- 2 × 2 card grid
- Large furniture artwork
- No row-list layout

Each card contains:

- large furniture image
- furniture name
- current level
- next effect
- price
- `Upgrade` button

At maximum level, display `MAX` and disable the button.

## Photo Mode

Photo Mode hides all regular UI and shows:

- room
- furniture
- Lumie
- Orlumi: Petal Nook logo
- capture button
- exit button

Before capture, hide both capture and exit buttons. The final screenshot must not contain standard UI or camera controls.

Lumie remains interactive in Photo Mode.

## MainRoom structure

### Scene

- `MainRoom`

### Layers

- `Base`
- `Furniture`
- `Companions`
- `UI`
- `Overlay`

### Current first-version room direction

- Semi top-down / 3/4 top-down perspective
- Main activity concentrated in the centre-left
- Left upper area reserved for UI information
- Right side reserved for future Area 2 expansion
- Lumie does not enter Area 2 in v1
