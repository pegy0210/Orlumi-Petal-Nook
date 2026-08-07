# @Orlumi Studio — Orlumi: Petal Nook
# Product Requirements Document (PRD) v1.0

**Status:** ACTIVE BASELINE / Studio development document  
**Product:** Orlumi: Petal Nook  
**Studio hierarchy:** `@Orlumi Studio → @Petal Nook → Game Project`  
**Master brand:** Orlumi  
**Brand line:** *Little lights, little wonders.*  
**Primary platform:** Android  
**Orientation:** Portrait  
**Primary language:** English  
**Supporting localization:** Traditional Chinese  

---

## 1. Product Vision

Orlumi: Petal Nook is a gentle portrait-format idle/decor game set within the wider Orlumi universe. The player begins with a quiet little house and a waiting flower, then gradually brings warmth and life into the nook through small interactions, furniture upgrades, gentle progression and companionship.

The product must feel like **one corner of Orlumi**, not a disconnected casual game. Every system, object, character, sound, interface and monetization decision must support the same sense of little lights, tiny wonders, cherished details, gentle surprise and premium collectibility.

Petal Nook is intentionally low-pressure. It should reward returning, noticing, arranging and softly progressing rather than demanding constant attention.

---

## 2. Product Goals

### 2.1 Core player goals

The player should be able to:

1. Understand the game within the first minute without a heavy tutorial.
2. See the nook gradually change through visible upgrades.
3. Generate and spend Petals in a simple, satisfying loop.
4. Feel that each purchase makes the room warmer or more alive.
5. Encounter Lumie as a gentle surprise after the first real purchase or upgrade.
6. Interact with Lumie without turning Lumie into a stat machine.
7. Leave the game and return later to meaningful but controlled offline progress.
8. Enter Photo Mode and capture a clean image of the nook.
9. Feel that future companions, furniture and areas could naturally belong to the same universe.

### 2.2 Studio goals

The first production version must establish a technical and content foundation that can expand into:

- more furniture
- more room areas
- additional companions
- collectible decor
- seasonal content
- additional Orlumi sub-series connections
- future premium cosmetic or permanent content

The first version must not hard-code the game in a way that prevents these extensions.

---

## 3. Non-Goals for v1

The following are explicitly outside the first-version core scope unless separately approved:

- combat
- competitive multiplayer
- PvP
- social guild systems
- complex story campaign
- long dialogue sequences
- companion stat optimization
- companion economic buffs
- large explorable world map
- heavy quest systems
- energy/stamina gating
- mandatory account creation
- intrusive interstitial-ad loops
- random paid loot boxes

Petal Nook must not become a loud, high-pressure retention game.

---

## 4. Experience Principles

### 4.1 Gentle progression
Progress should feel steady, visible and comforting rather than explosive or noisy.

### 4.2 Small things matter
Upgrades should change details that players can notice and cherish.

### 4.3 Premium cute, not childish
Visuals should remain delicate, refined, dreamy and collectible.

### 4.4 Quiet magic
Magic is expressed through light, atmosphere, behaviour, small surprises and character presence rather than exaggerated fantasy effects.

### 4.5 Lumie is a character, not a resource generator
Lumie's primary value is emotional presence and recognisable Orlumi identity.

### 4.6 Orlumi first
A feature that is commercially useful but aesthetically or emotionally inconsistent with Orlumi should not ship without redesign.

---

## 5. Target Experience

### Primary experience profile

A short-session, portrait mobile game that can be comfortably opened for a few minutes at a time and revisited throughout the day.

The expected emotional rhythm is:

**notice → tap → collect → choose → place/upgrade → observe → discover → leave → return**

The game should remain enjoyable even when the player does not optimize progression.

---

## 6. Core Gameplay Loop

**Collect Petals → purchase/upgrade furniture → increase income and Comfort → make the nook feel more alive → unlock further possibilities.**

Supporting loops:

- tap Little Pot for active Petal gain
- earn Petals passively over time
- receive limited offline earnings
- interact with Lumie
- enter Photo Mode and capture the nook
- return later to continue progression

---

## 7. First Launch and Onboarding

### 7.1 Initial state

At first launch:

- Little Pot is already visible at Lv1.
- Other furniture is absent at Lv0.
- Lumie is not present.
- Player starts with 0 Petals.
- The room should feel quiet but not empty or broken.

### 7.2 Opening sequence

The opening plays only on first launch.

**English**

> Somewhere within Orlumi,  
> there is a little house.  
> Inside, a flower waits in silence.  
> This is where your nook begins.

**Traditional Chinese**

> 在 Orlumi 的某個角落，  
> 有一間小小的屋。  
> 屋裡，一盆花靜靜地等待著。  
> 這裡，就是你的小花窩開始的地方。

Requirements:

- atmosphere-first
- minimal text
- one line / short beat at a time
- tap to continue
- no lore dump
- never repeatedly shown after completion unless the player performs a full progress reset

---

## 8. Resources and Economy

### 8.1 Primary soft currency

**Petals**

Petals are earned through:

- passive income
- Little Pot tapping
- offline reward

Petals are spent on:

- furniture purchase
- furniture upgrade

### 8.2 Starting economy

- `Petals = 0`
- `Comfort = 2`
- `BaseIncomePerSec = 1`
- `BonusPercent = 0`
- `FinalIncomePerSec = 1`
- `TapValue = 1`

### 8.3 Economy recalculation rule

Economy values should be derived from the current state/levels rather than permanently incremented in a fragile way. This is required so save/load, reset, balancing and future level expansion remain predictable.

---

## 9. Furniture System

### 9.1 Universal level rule

- `Lv0` = not owned / not visible
- `Lv1` = first owned visible state
- `Lv2+` = upgrade states

### 9.2 Little Pot exception

Little Pot starts at Lv1 and is already visible.

The first paid Little Pot action is:

`Lv1 → Lv2`

This initial Lv1 state must **not** trigger Lumie's appearance.

### 9.3 Current v1 level cap

Current production cap: **Lv5**

The underlying data structure must remain extendable beyond Lv5.

### 9.4 Little Pot

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

### 9.5 Wooden Rack

Prices by level:

`50 / 100 / 200 / 400 / 800`

Income:

`1 / 2 / 4 / 6 / 9`

Cumulative Comfort:

`4 / 8 / 13 / 18 / 24`

### 9.6 Curtain

Prices:

`120 / 240 / 480 / 960 / 1920`

Income bonus:

`5% / 10% / 15% / 22% / 30%`

Cumulative Comfort:

`6 / 12 / 19 / 26 / 34`

### 9.7 Small Table

Prices:

`300 / 600 / 1200 / 2400 / 4800`

Income bonus:

`5% / 8% / 12% / 16% / 20%`

Cumulative Comfort:

`10 / 20 / 32 / 44 / 59`

### 9.8 Shop card behaviour

Each furniture card must display:

- large furniture image
- furniture name
- current level
- next effect
- upgrade/purchase price
- `Upgrade` action

At max level:

- display `MAX`
- disable purchase action

Layout must use a **portrait 2 × 2 card grid**, not a row list.

---

## 10. Comfort System

Comfort represents the overall development of the nook.

It is primarily raised by furniture ownership/upgrades.

Current Area 2 eligibility rule:

- `Comfort >= 20`
- `SmallTableLevel >= 1`

### v1 constraint

The right side of the room is reserved for Area 2 expansion, but the first production scope does not require a fully developed Area 2 gameplay loop.

The main room composition must visually preserve this future expansion path.

---

## 11. Lumie

### 11.1 Brand role

Lumie is the core Orlumi character anchor and must not appear as a generic bunny mascot.

Mandatory identity rules:

- star-ears are the primary identifying feature
- the star quality comes from the ear structure itself, not star decorations
- glowing droplet tail
- soft luminous eyes
- creamy white, pastel lavender, blush pink and pale gold palette

### 11.2 First appearance

Lumie appears only after the player's **first real purchase or upgrade**.

Trigger if any one becomes true:

- `LittlePotLevel >= 2`
- `WoodenRackLevel >= 1`
- `CurtainLevel >= 1`
- `SmallTableLevel >= 1`

### 11.3 First appearance sequence

Plays once.

**English**

> With the first piece placed,  
> the little house stirs softly.  
> A tiny companion has drawn near.  
> Its name is Lumie.

**Traditional Chinese**

> 當第一件傢俱安放好後，  
> 小屋也輕輕甦醒過來。  
> 一位小小的同伴被吸引而來。  
> 牠的名字，叫 Lumie。

### 11.4 Lumie role in v1

Lumie provides:

- visual companionship
- movement
- tap reactions
- personality
- Photo Mode interaction

Lumie provides **no**:

- income bonus
- Comfort bonus
- resource multiplier
- mandatory progression function

### 11.5 Movement

Lumie may move within the active main-room space using a gentle 3/4 spatial pattern.

Requirements:

- movement should feel calm and living, not frantic
- Lumie may move front/back/left/right according to room perspective
- Lumie must not wander into the reserved Area 2 space in v1
- movement should respect visually valid floor zones

### 11.6 Tap reaction

Potential normal reactions:

- 🌸
- ✨
- 😊
- 💛
- 😴
- ❔

Rules:

- tapping may trigger one reaction
- emoji cannot refresh while already visible
- emoji disappears naturally after a short duration
- then a 1–2 second cooldown applies
- another reaction cannot occur during cooldown

### 11.7 Annoyed state

Annoyed probability begins from the sixth successful tap cycle:

- taps 6–7: 25%
- taps 8–9: 50%
- taps 10+: 100%

When annoyed:

- switch to annoyed appearance
- may show angry reaction or no emoji
- ignore further taps for 30 seconds
- return to normal afterwards
- reset the repeated-tap count

The system should feel playful, not punitive.

---

## 12. Save and Persistence

### 12.1 Save methods

- manual save icon on main screen
- autosave every 60 seconds
- immediate save on important state changes
- save when application backgrounds/exits where technically supported

### 12.2 Immediate-save events

At minimum:

- furniture purchase
- furniture upgrade
- area unlock milestone
- Lumie unlock
- opening completion
- Lumie intro completion
- offline reward claim
- offline-cap upgrade
- manual save

### 12.3 Save integrity requirement

Save/load must restore the same logical game state without double-counting income or bonuses.

Progress data and paid-entitlement data must be logically separable.

---

## 13. Reset

Reset is available inside Settings.

Requirements:

- first confirmation
- second confirmation
- clearly explain that progress will restart

Reset clears:

- Petals
- Comfort
- furniture levels
- progression flags
- Lumie progress/unlock state
- opening completion state
- Lumie intro completion state
- offline cap back to 60 minutes

Reset must preserve:

- remove-ads entitlement
- permanent paid content
- theme packs
- other non-consumable entitlements

After reset, the opening sequence plays again.

---

## 14. Offline Progress

### 14.1 Base cap

`60 minutes`

### 14.2 Rewarded-ad extension

One rewarded ad increases the **future offline accumulation cap** by:

`+15 minutes`

Maximum:

`120 minutes`

This is not an instant reward added after the player returns.

### 14.3 Formula

```text
OfflineSeconds = min(realOfflineSeconds, OfflineCapMinutes * 60)
OfflineRewardPending = FinalIncomePerSec * OfflineSeconds * 0.1
```

### 14.4 Offline return flow

On valid return:

- calculate offline duration
- cap duration
- calculate reward
- show concise reward popup
- one `Claim` action

The offline popup does not contain a rewarded-ad button for adding instant income.

---

## 15. Main Screen UI

### 15.1 Persistent information

Current target information:

- Petals
- Income
- Comfort
- Offline Limit

The top-left environment composition should leave sufficient clean space for this information.

### 15.2 Main controls

Current target controls:

- Save
- Offline Boost
- Shop
- Settings
- Photo Mode

UI must remain light, calm, legible and uncluttered.

---

## 16. Photo Mode

### 16.1 Entry

Accessible from the main screen.

### 16.2 Standard UI hidden

Hide:

- Petals
- Income
- Comfort
- Offline Limit
- Save
- Offline Boost
- Shop
- Settings
- standard Photo Mode entry control
- save toast

### 16.3 Visible in Photo Mode

- room
- owned furniture
- Lumie
- Orlumi: Petal Nook logo
- Capture control
- Exit control

### 16.4 Lumie interaction

Lumie remains tappable.

Normal emoji and annoyed rules remain active.

### 16.5 Capture output

Immediately before capture:

- hide Capture
- hide Exit

Final captured image should contain:

- environment
- furniture
- Lumie if present
- product logo

Final image must not contain gameplay UI or Photo Mode controls.

---

## 17. Visual Direction Requirements

Petal Nook must inherit Orlumi's master art direction.

Required qualities:

- dreamy
- soft
- warm
- peaceful
- gently glowing
- delicate
- collectible
- premium cute
- low-to-medium saturation
- soft lighting
- low contrast
- subtle magical feeling
- clean silhouettes
- restrained detail density

Avoid:

- loud casual-game colour schemes
- neon glow
- generic kawaii mascots
- visual clutter
- cheap-looking bundled assets
- overly childish UI
- harsh outlines
- excessive decorative stars used as a substitute for brand structure

### Spatial direction

- portrait composition
- semi top-down / 3/4 spatial depth
- top-left reserve for information UI
- main active zone centre-left / lower-middle
- right side reserved for Area 2 expansion

### Background composition rule

`BgRoom` must not permanently bake in separate gameplay objects such as:

- Little Pot
- Lumie
- lock icon
- separately interactive furniture

These must remain independent assets/components.

---

## 18. Audio Direction

Audio is required as an experience layer but final implementation is not yet locked.

Working requirements:

- soft, unobtrusive ambience
- delicate interaction feedback
- no aggressive reward jingles
- no loud casino-like sounds
- Lumie reactions should remain gentle

**Studio Decision Gate:** final music/SFX scope and production method to be confirmed before content lock.

---

## 19. Localization

English is the primary production language.

Traditional Chinese is supporting localization.

Requirements:

- UI strings must not be embedded in art where avoidable
- game copy should support externalized localization data
- layouts must tolerate English and Traditional Chinese length differences

---

## 20. Accessibility and Usability Baseline

v1 should support:

- touch targets suitable for phone use
- readable text at portrait phone size
- sufficient UI/background contrast without breaking the soft palette
- no critical information conveyed only through subtle colour variation
- reduced dependence on precise tapping for essential controls

Further accessibility options may be added after technical architecture is confirmed.

---

## 21. Monetization Boundaries

Current approved monetization mechanic in the core design:

- optional rewarded ad to extend future offline cap by 15 minutes, up to 120 minutes

Paid permanent entitlements are architecturally anticipated, including examples such as:

- remove ads
- permanent content unlocks
- theme packs

However, exact paid products and pricing are **not yet approved in this PRD**.

Monetization must not make Lumie feel transactional or reduce the room to a bundle of low-value goods.

**Studio Decision Gate:** final v1 monetization catalogue and regional pricing.

---

## 22. Analytics / Telemetry Baseline

If analytics are implemented, the first version should only require product-level events needed to understand stability and core progression, for example:

- first_launch
- opening_complete
- first_pot_tap
- shop_open
- furniture_purchase
- furniture_upgrade
- lumie_unlocked
- offline_reward_claimed
- offline_cap_extended
- photo_mode_opened
- photo_captured
- reset_completed

No analytics vendor is selected at PRD stage.

**Studio Decision Gate:** analytics provider, privacy wording and consent requirements.

---

## 23. v1 Functional Scope

### Must ship

- portrait Android project
- MainRoom
- first-launch opening
- Little Pot Lv1 start state
- active tapping
- passive income
- Petal economy
- furniture purchase/upgrade system
- Little Pot
- Wooden Rack
- Curtain
- Small Table
- Comfort
- 2 × 2 Shop
- Lumie first appearance
- Lumie movement
- Lumie emoji reactions
- Lumie annoyed state
- save/load
- manual save
- autosave
- reset with double confirmation
- offline reward
- rewarded offline-cap extension
- Settings
- Photo Mode
- English strings
- Traditional Chinese localization support
- Area 2 future-space reservation

### May ship if low risk

- additional Lumie idle animations
- subtle particle ambience
- extra minor room details
- richer save confirmation feedback

### Explicitly defer

- multiple active companions
- companion roster management
- fully playable Area 2
- complex collection catalogue
- cloud save
- account system
- social features
- achievements
- push notifications
- large narrative chapters

---

## 24. Acceptance Criteria for First Playable Build

A build qualifies as **First Playable** when all of the following are true:

1. App launches in portrait orientation on Android target resolution.
2. Opening can be completed without blocking the game.
3. Little Pot is visible at Lv1.
4. Petals start at 0.
5. Passive income increases Petals correctly.
6. Tapping Little Pot increases Petals according to TapValue.
7. Shop can open and close.
8. Player can purchase/upgrade at least Little Pot.
9. Cost is deducted correctly.
10. Economy recalculates correctly after upgrade.
11. First real purchase/upgrade triggers Lumie once.
12. Lumie can appear and move in a valid main-room area.
13. Lumie tap reaction works with cooldown.
14. Annoyed state can trigger and recover.
15. Save → close → reopen restores progress.
16. Offline reward does not exceed the configured cap.
17. Reset restores first-run progress state while preserving entitlement storage architecture.
18. Photo Mode can hide gameplay UI and return to normal mode.

---

## 25. v1 Release Gate

A production candidate should not be considered release-ready until:

- all Must Ship items are implemented
- no progression-blocking bugs remain
- no repeatable currency duplication exploit is known
- save/load survives repeated app restarts
- offline reward has been tested across clock/time edge cases
- Android touch UI is usable on representative phone sizes
- Lumie visual asset meets official Orlumi identity rules
- art direction is internally consistent
- English copy is final
- Traditional Chinese localization is reviewed
- privacy/analytics requirements are resolved if telemetry or ads are enabled
- store-ready Android build can be produced and installed

---

## 26. Technical Decision Gates for TDD

The following are intentionally deferred to the Technical Design Document rather than decided inside the PRD:

1. **Final engine:** retain GDevelop vs migrate to Godot/code-first implementation.
2. **Rendering/reference resolution strategy.**
3. **Save-file format and migration/versioning.**
4. **Data-driven furniture configuration format.**
5. **Lumie movement/state-machine implementation.**
6. **Android screenshot implementation for Photo Mode.**
7. **Rewarded-ad provider and SDK architecture.**
8. **Analytics provider, if any.**
9. **Android export/build/signing pipeline.**
10. **Automated test strategy and CI feasibility.**

Engine selection must prioritize maintainability, direct code collaboration, GitHub version control, Android delivery, testing and future Orlumi expansion—not sunk cost in the prototype.

---

## 27. Product Decision Gates Still Open

These items are not required to block TDD drafting unless they affect architecture:

- final v1 audio production method
- exact launch monetization products beyond rewarded offline-cap extension
- exact Area 2 launch treatment (pure visual reservation vs teaser state)
- whether additional cosmetic furniture variants are included at launch
- whether v1 includes analytics
- final store launch pricing / paid catalogue

No open item may be silently converted into a permanent product rule without Studio approval.

---

## 28. Source-of-Truth Rule

This PRD consolidates previously approved Petal Nook product decisions into a production-oriented baseline.

If a lower-level implementation note conflicts with this PRD:

- product behaviour follows this PRD
- technical implementation details follow the approved TDD
- Orlumi identity follows the master brand rules

Any future change that materially affects player experience, monetization, Lumie identity, platform scope or world consistency requires an explicit versioned PRD update.

---

## 29. Next Studio Stage

**Next document:** `TDD v1.0 — Technical Design Document`

Primary immediate decision:

> Select the implementation architecture that allows @Orlumi Studio to develop Petal Nook quickly, safely and maintainably into an installable Android game while preserving the approved product experience.
