# @Orlumi Studio — Orlumi: Petal Nook
# Technical Design Document (TDD) v1.0

**Status:** ACTIVE TECHNICAL BASELINE  
**Product:** Orlumi: Petal Nook  
**Studio hierarchy:** `@Orlumi Studio → @Petal Nook → Game Project`  
**Product baseline:** `docs/product/PRD-v1.0.md`  
**Target platform:** Android first  
**Orientation:** Portrait  

---

## 1. Technical Objective

Build Petal Nook as a maintainable, data-driven 2D mobile game that can be developed primarily through source-controlled code, reviewed in GitHub, assisted by Codex/AI development workflows, tested incrementally, and exported as an installable Android application.

The technical architecture must preserve the Orlumi product rules while remaining expandable for future furniture, companions, room areas, cosmetics and seasonal content.

The implementation must avoid hard-coding v1 content in ways that make future Orlumi expansion expensive.

---

## 2. Engine Decision

### 2.1 Production engine

**Godot 4.x stable + GDScript**

Godot becomes the production implementation path for Petal Nook.

### 2.2 Existing GDevelop prototype

The current GDevelop work is retained as:

- interaction reference
- UI-flow reference
- economy prototype reference
- proof of early gameplay logic

It is **not** the production source of truth after Godot implementation starts.

No approved gameplay rule is discarded merely because the implementation engine changes.

### 2.3 Why Godot

The project benefits from:

- text-based source control
- clean GitHub diffs
- direct code generation and review
- deterministic reusable game logic
- scene composition suitable for 2D room/decor games
- Android export support
- easier automated testing than event-sheet-only development
- reusable data resources for future Orlumi content
- lower dependency on manual editor event wiring

---

## 3. Technical Principles

### 3.1 Data-driven content
Furniture values, levels, costs and effects must live in data/config resources rather than scattered gameplay code.

### 3.2 Single source of game state
Runtime progress is owned by one central game-state service. UI reads from state; UI does not independently maintain economy values.

### 3.3 Recalculate, do not accumulate fragile bonuses
Derived values such as income and Comfort are recalculated from current furniture levels and permanent modifiers.

### 3.4 UI is presentation
Buttons request actions through services/controllers. UI should not directly rewrite save data.

### 3.5 Save versioning from day one
Every save contains a schema version so migration remains possible after release.

### 3.6 Paid entitlement separation
Progress save and permanent purchase entitlements are logically separate.

### 3.7 Mobile-first input
All primary interactions must work through touch. Mouse input is supported for desktop development/testing only.

### 3.8 Orlumi first
Technical shortcuts must not force visually generic or intrusive UI behaviour.

---

## 4. Reference Resolution and Display

### 4.1 Design reference resolution

`1080 × 1920`

Portrait 9:16 reference canvas.

### 4.2 Scaling strategy

Use Godot 2D canvas scaling so layouts preserve composition across Android portrait devices.

Requirements:

- maintain portrait design intent
- preserve top-left UI safe region
- avoid stretching character/furniture art
- allow safe-area padding for devices with notches/cut-outs
- room art may crop conservatively at extreme aspect ratios rather than distort

### 4.3 Coordinate zones

Main room visual zones:

- **Top-left:** persistent resource UI reserve
- **Centre-left / lower-middle:** primary interaction space
- **Right:** future Area 2 reservation
- **Overlay:** shop/settings/story/offline/photo controls

---

## 5. Proposed Repository Structure

```text
Orlumi-Petal-Nook/
├─ project.godot
├─ README.md
├─ docs/
│  ├─ product/
│  │  └─ PRD-v1.0.md
│  ├─ technical/
│  │  └─ TDD-v1.0.md
│  └─ art/
├─ game/
│  ├─ autoload/
│  │  ├─ game_state.gd
│  │  ├─ save_service.gd
│  │  ├─ economy_service.gd
│  │  ├─ offline_service.gd
│  │  ├─ entitlement_service.gd
│  │  └─ audio_service.gd
│  ├─ scenes/
│  │  ├─ boot/
│  │  │  └─ boot.tscn
│  │  ├─ main_room/
│  │  │  └─ main_room.tscn
│  │  ├─ ui/
│  │  │  ├─ hud.tscn
│  │  │  ├─ shop_panel.tscn
│  │  │  ├─ settings_panel.tscn
│  │  │  ├─ offline_popup.tscn
│  │  │  ├─ story_overlay.tscn
│  │  │  └─ photo_mode_ui.tscn
│  │  ├─ furniture/
│  │  │  ├─ little_pot.tscn
│  │  │  ├─ wooden_rack.tscn
│  │  │  ├─ curtain.tscn
│  │  │  └─ small_table.tscn
│  │  └─ companions/
│  │     └─ lumie.tscn
│  ├─ scripts/
│  │  ├─ main_room/
│  │  ├─ ui/
│  │  ├─ furniture/
│  │  └─ companions/
│  ├─ data/
│  │  ├─ furniture/
│  │  ├─ companions/
│  │  └─ localization/
│  └─ tests/
├─ assets/
│  ├─ backgrounds/
│  ├─ furniture/
│  ├─ companions/
│  ├─ ui/
│  ├─ fx/
│  └─ audio/
└─ legacy/
   └─ gdevelop/
```

`legacy/gdevelop/` is optional and only used if the existing prototype files are later committed.

---

## 6. Boot Architecture

### 6.1 Boot scene

`boot.tscn`

Responsibilities:

1. initialize services
2. load permanent entitlements
3. load progress save
4. validate/migrate save schema
5. calculate offline elapsed time
6. prepare pending offline reward
7. route to `main_room.tscn`

The main room should not independently perform persistence initialization.

---

## 7. Global Services / Autoloads

### 7.1 `GameState`

Owns runtime player progress.

Core fields:

```gdscript
petals: float
little_pot_level: int
wooden_rack_level: int
curtain_level: int
small_table_level: int
comfort: int
base_income_per_sec: float
bonus_percent: float
final_income_per_sec: float
tap_value: float
area2_unlocked: bool
intro_played: bool
lumie_unlocked: bool
lumie_intro_played: bool
offline_cap_minutes: int
last_save_unix: int
save_version: int
```

Future companion ownership must not require restructuring the entire state object.

### 7.2 `EconomyService`

Responsibilities:

- calculate furniture purchase/upgrade validity
- deduct Petals
- recalculate income
- recalculate Comfort
- calculate tap value
- emit state-change signals

UI must call EconomyService instead of changing levels directly.

### 7.3 `SaveService`

Responsibilities:

- serialize progress
- deserialize progress
- validate values
- migrate older save versions
- autosave
- immediate-save requests
- reset progress

### 7.4 `OfflineService`

Responsibilities:

- compute elapsed offline duration
- enforce `OfflineCapMinutes`
- calculate pending reward
- avoid double claim
- return reward metadata to UI

### 7.5 `EntitlementService`

Owns permanent non-consumable state such as:

- remove ads
- permanent content unlocks
- theme packs

Reset progress must never clear this store.

### 7.6 `AudioService`

Centralized music/SFX management for future mute settings and consistent Orlumi audio behaviour.

---

## 8. Data Model — Furniture

Furniture must be defined using reusable Resource data rather than switch statements scattered through UI code.

Example conceptual schema:

```gdscript
class_name FurnitureDefinition
extends Resource

@export var id: StringName
@export var display_name_key: String
@export var starts_owned: bool
@export var max_level: int
@export var levels: Array[FurnitureLevelDefinition]
```

Level definition concept:

```gdscript
class_name FurnitureLevelDefinition
extends Resource

@export var level: int
@export var price: int
@export var base_income: float
@export var income_bonus_percent: float
@export var tap_bonus: float
@export var comfort: int
@export var visual_key: StringName
```

This allows future level caps and furniture additions without rewriting the shop system.

---

## 9. Economy Calculation

### 9.1 Required behaviour

Derived economy must be recomputed whenever relevant progress changes.

Conceptually:

```text
BaseIncomePerSec = sum(base-income contribution from owned furniture)
BonusPercent = sum(valid percentage modifiers)
FinalIncomePerSec = BaseIncomePerSec × (1 + BonusPercent / 100)
Comfort = sum(current cumulative Comfort values)
TapValue = base tap value + valid furniture tap bonuses
```

Exact stacking behaviour must match PRD values.

### 9.2 Runtime passive income

The game may accumulate fractional Petals internally.

UI may display a rounded/floored user-friendly value while keeping internal precision.

### 9.3 Upgrade transaction

Atomic sequence:

1. validate furniture exists/upgrade allowed
2. validate current level
3. validate Petals >= price
4. deduct price
5. change level
6. recalculate economy
7. evaluate milestones including Lumie unlock
8. emit UI/state signals
9. immediate save

A failed transaction changes nothing.

---

## 10. Main Room Scene

### 10.1 Scene composition

Conceptual tree:

```text
MainRoom
├─ World
│  ├─ Background
│  ├─ FurnitureLayer
│  ├─ CompanionLayer
│  └─ ForegroundFX
├─ UI
│  └─ HUD
└─ Overlay
   ├─ StoryOverlay
   ├─ OfflinePopup
   ├─ ShopPanel
   ├─ SettingsPanel
   └─ PhotoModeUI
```

### 10.2 Z-order

Furniture and Lumie require deterministic visual layering to preserve semi-top-down depth.

Preferred approach:

- static placement with explicit z-index for fixed furniture
- Lumie z-index adjusted from Y position where required
- foreground decor may intentionally occlude Lumie in approved walk zones

---

## 11. Furniture Visual State

Furniture scenes read current owned level and select a visual key.

Rules:

- Lv0: hidden/not instantiated unless required for editor placeholders
- Lv1+: visible
- artwork can map multiple levels to one image during v1
- data architecture must support unique image per level later

Little Pot starts visible at Lv1.

---

## 12. Lumie Architecture

### 12.1 Scene

`lumie.tscn`

Conceptual structure:

```text
Lumie
├─ Visual
│  ├─ NormalSprite
│  └─ AnnoyedSprite
├─ InteractionArea
├─ EmojiAnchor
├─ EmojiDisplay
└─ MovementController
```

### 12.2 State machine

Lumie states:

```text
HIDDEN
INTRO
IDLE
MOVING
REACTING
COOLDOWN
ANNOYED
```

Valid high-level transitions:

```text
HIDDEN → INTRO → IDLE
IDLE → MOVING → IDLE
IDLE/MOVING → REACTING → COOLDOWN → IDLE
REACTING/IDLE → ANNOYED → IDLE
```

### 12.3 Unlock

Lumie unlock check runs only after a successful real purchase/upgrade or during save-load reconciliation.

Initial Little Pot Lv1 must not trigger unlock on a fresh game.

### 12.4 Movement zones

Movement uses approved floor polygons/rectangles rather than arbitrary screen coordinates.

Requirements:

- stay inside active main-room floor
- exclude Area 2 reservation
- avoid impossible wall/furniture positions
- move slowly enough to preserve calm character presence

### 12.5 Tap reaction

A tap is accepted only when Lumie is in an interactable state.

Reaction process:

1. receive accepted tap
2. increment valid repeated-tap count
3. evaluate annoyed probability from threshold 6 onward
4. if annoyed: enter ANNOYED
5. otherwise choose emoji
6. display reaction ~2 seconds
7. enter 1–2 second cooldown
8. return to idle

The exact randomized cooldown may be selected in the 1–2 second range.

### 12.6 Annoyed

Probability table:

- count 6–7: 25%
- count 8–9: 50%
- count 10+: 100%

On trigger:

- show annoyed visual
- ignore interaction input for 30 seconds
- optionally show approved angry reaction
- reset repeated-tap counter when returning to normal

---

## 13. UI Architecture

### 13.1 HUD

HUD observes GameState signals and displays:

- Petals
- Income
- Comfort
- Offline Limit

Controls:

- Save
- Offline Boost
- Shop
- Settings
- Photo Mode

### 13.2 UI modal controller

Only one blocking modal should own normal interaction at a time.

Modal states:

```text
NONE
STORY
OFFLINE_REWARD
SHOP
SETTINGS
RESET_CONFIRM_1
RESET_CONFIRM_2
PHOTO_MODE
```

Normal world input is blocked when appropriate.

Photo Mode is exceptional: Lumie remains interactive.

### 13.3 Shop

Shop panel uses reusable `FurnitureCard` scenes.

The 2 × 2 layout is generated from furniture definitions rather than four unrelated custom scripts.

Each card binds:

- icon/art
- name
- current level
- next effect text
- cost
- upgrade state

---

## 14. Save Format

### 14.1 Storage

Use a local app-private progress file under Godot `user://` storage.

Initial implementation may use JSON for inspectability and migration simplicity.

Proposed filename:

```text
user://petal_nook_progress.json
```

Permanent entitlements use a separate logical store/file.

### 14.2 Example progress schema

```json
{
  "save_version": 1,
  "saved_at_unix": 0,
  "petals": 0.0,
  "furniture": {
    "little_pot": 1,
    "wooden_rack": 0,
    "curtain": 0,
    "small_table": 0
  },
  "progression": {
    "area2_unlocked": false,
    "intro_played": false,
    "lumie_unlocked": false,
    "lumie_intro_played": false
  },
  "offline": {
    "cap_minutes": 60
  }
}
```

Derived fields such as FinalIncomePerSec and Comfort should normally be recalculated after loading rather than trusted from disk.

### 14.3 Validation

On load:

- reject impossible negative levels
- clamp level values to supported ranges
- clamp offline cap to allowed range
- sanitize invalid currency values
- migrate recognized older versions
- recover to safe defaults if save is unrecoverable

Corrupt save handling must not crash the app.

---

## 15. Autosave and Lifecycle

### 15.1 Autosave

Every 60 seconds while gameplay is active.

### 15.2 Immediate save

Required after:

- furniture transaction
- Lumie unlock
- story completion
- offline claim
- offline cap change
- reset completion
- important unlock milestone

### 15.3 App lifecycle

When Android sends background/focus/lifecycle events, request save where supported.

The saved timestamp becomes the basis of later offline calculation.

---

## 16. Offline Progress

### 16.1 Calculation

```text
elapsed = max(0, current_unix - saved_at_unix)
allowed = min(elapsed, OfflineCapMinutes × 60)
reward = FinalIncomePerSec × allowed × 0.1
```

### 16.2 Anti-double-claim design

On boot, calculate a pending reward from the previous saved timestamp.

Before or immediately after presenting the pending reward, establish a new session baseline timestamp so reopening/crashing cannot repeatedly recreate the same elapsed period.

Claim operation must be idempotent within one calculated offline session.

### 16.3 Clock anomalies

If device time moves backwards:

- treat elapsed as zero
- do not generate negative reward

Major clock-cheat prevention is not a v1 requirement, but the architecture should not crash on abnormal timestamps.

---

## 17. Rewarded Ads

### 17.1 Product behaviour

Rewarded ad action increases future offline cap by 15 minutes to a maximum of 120 minutes.

### 17.2 Technical boundary

Gameplay code does not call a specific ad SDK directly.

Define an abstraction such as:

```gdscript
AdService.request_rewarded_ad(reward_context)
```

Successful ad completion emits a reward event.

Only after verified completion may OfflineCapMinutes increase.

### 17.3 SDK selection

**Implementation spike required before monetization milestone.**

The core game must remain runnable with a mock ad service during development.

---

## 18. Photo Mode

### 18.1 Rendering behaviour

Entering Photo Mode:

- hide regular HUD
- hide unrelated controls
- keep room/furniture/Lumie
- show logo
- show Capture and Exit
- keep Lumie interaction active

### 18.2 Capture sequence

1. user presses Capture
2. hide Capture and Exit controls
3. wait until next rendered frame
4. capture viewport image
5. restore Photo Mode controls
6. save/share result through platform-appropriate flow

### 18.3 Technical spike

Godot viewport capture is straightforward; Android gallery/share integration must be validated as a dedicated platform spike.

Acceptance for early prototype:

- clean PNG can be generated and stored in app-accessible storage

Release acceptance:

- player can retrieve/share the image through an Android-appropriate user flow

---

## 19. Localization

Primary source copy: English.
Supporting localization: Traditional Chinese.

UI and narrative text must be key-based rather than embedded throughout scripts.

Example keys:

```text
ui.petals
ui.income
ui.comfort
ui.offline_limit
shop.upgrade
shop.max
story.opening.01
story.lumie_intro.01
```

Architecture must support adding additional languages without scene rewrites.

---

## 20. Input

Use Godot InputMap actions such as:

```text
interact
ui_accept
ui_cancel
photo_capture
```

Touch is primary.

Development mouse input may map to the same interaction actions.

Do not build core logic around hover-only interactions.

---

## 21. Audio Technical Structure

V1 architecture should reserve buses for:

```text
Master
Music
SFX
UI
```

Settings should be able to mute/adjust categories later without refactoring every scene.

Actual final sound set is an Art/Audio production task, not required to block the first playable prototype.

---

## 22. Performance Targets

Petal Nook is a lightweight 2D title.

Technical expectations:

- stable responsive interaction on mainstream Android devices
- avoid per-frame allocations in idle systems where unnecessary
- avoid spawning persistent unnecessary particles
- atlas/texture optimization considered once final assets stabilize
- pause or reduce nonessential updates while app is backgrounded
- no gameplay dependence on network connectivity for core v1 loop

The game should remain fully playable offline except for features that explicitly require network access such as rewarded ads.

---

## 23. Testing Strategy

### 23.1 Logic tests

Priority automated/unit-test candidates:

- furniture price lookup
- upgrade validity
- economy recalculation
- Comfort calculation
- Lumie unlock condition
- annoyed probability thresholds
- offline cap clamping
- offline reward calculation
- reset preserving entitlements
- save migration/validation

### 23.2 Scene/integration tests

Manual or scripted checks:

- first boot sequence
- first Little Pot upgrade
- Lumie first appearance exactly once
- shop opens/closes correctly
- save → close → reload restores state
- offline popup does not duplicate reward
- reset double confirmation
- Photo Mode hides correct nodes
- Lumie remains tappable in Photo Mode

### 23.3 Android device tests

Before release candidate:

- touch accuracy
- text scaling
- safe-area behaviour
- background/resume saving
- offline time calculation after real device sleep
- rewarded ad completion/cancel/failure
- screenshot retrieval/share flow
- APK/AAB install behaviour

---

## 24. Development Environments

### 24.1 Local editor

Godot editor used for:

- scene layout
- visual inspection
- Android export configuration
- device testing

### 24.2 GitHub

GitHub is the canonical source repository.

All production scripts, scene files, configs and documentation belong in source control unless excluded for security/build reasons.

### 24.3 Codex / AI development

Code-first architecture is intentionally designed so Codex/AI can:

- add scripts
- refactor systems
- write tests
- inspect diffs
- update data definitions
- debug errors from logs
- produce pull requests/commits

Visual approvals remain a Studio/Owner decision.

---

## 25. Secrets and Store Credentials

Never commit:

- Android signing passwords
- private keystore credentials
- ad network secret keys
- store credentials
- private analytics keys where secrecy is required

Use local/environment/CI secret storage when those systems are introduced.

---

## 26. Migration From GDevelop

Migration is **behavioural**, not file-format conversion.

Carry forward:

- approved PRD rules
- economy values
- UI flows
- object naming concepts where useful
- art assets
- narrative copy
- Lumie interaction design

Do not mechanically recreate every GDevelop event if Godot architecture provides a cleaner implementation.

Migration phases:

1. create Godot project shell
2. implement GameState/EconomyService
3. build MainRoom with placeholder assets
4. implement Little Pot active/passive income
5. implement Shop and upgrades
6. trigger Lumie unlock
7. implement Lumie state machine
8. implement persistence/offline
9. implement settings/reset
10. implement Photo Mode
11. Android device build
12. replace placeholders with approved final assets

---

## 27. First Playable Build Definition

The first meaningful playable build is complete when all of the following work in Godot:

1. Android-style portrait viewport launches.
2. MainRoom renders.
3. Little Pot begins at Lv1.
4. Petals increase passively.
5. Tapping Little Pot adds Petals.
6. Shop opens.
7. Player can buy the Little Pot Lv2 upgrade when affordable.
8. Economy recalculates correctly.
9. First real upgrade triggers Lumie once.
10. Progress can be saved.
11. Closing/reopening restores progress.

This build may use approved placeholders and does not require final animation, ads or Photo Mode.

---

## 28. Production Milestones

### M0 — Technical Foundation
- Godot project
- reference resolution
- folder structure
- autoload architecture
- basic tests

### M1 — Core Loop Playable
- MainRoom
- passive income
- pot tapping
- Petal HUD
- Little Pot upgrade
- basic Shop

### M2 — Furniture & Comfort
- all four furniture definitions
- generic furniture-card UI
- Comfort
- Area 2 eligibility state

### M3 — Lumie
- first appearance
- movement
- reaction emoji
- cooldown
- annoyed state

### M4 — Persistence
- save/load
- autosave
- lifecycle save
- reset
- offline rewards

### M5 — Presentation Systems
- opening
- Lumie intro
- settings
- Photo Mode
- localization pass

### M6 — Monetization & Android Integration
- rewarded-ad abstraction + provider
- Android screenshot/share validation
- signing/export pipeline

### M7 — Polish / Release Candidate
- final assets
- sound
- UI polish
- performance pass
- device QA
- store-ready AAB

---

## 29. Technical Decision Gates

The following require validation but do not block M0/M1:

### DG-T01 — Exact Godot 4.x release
Use the current stable production release selected at project initialization and record it in `project.godot` / README.

### DG-T02 — Rewarded ad provider
Select only when monetization milestone begins.

### DG-T03 — Android screenshot/share implementation
Prototype before Photo Mode release acceptance.

### DG-T04 — Analytics
No analytics SDK required for first playable build. Add only with explicit product/privacy decision.

### DG-T05 — Cloud save
Not required for v1 baseline. Local save remains authoritative unless separately approved.

---

## 30. Definition of Done for TDD v1.0

TDD v1.0 is technically approved when:

- production engine is selected
- source structure is defined
- state ownership is defined
- economy architecture is deterministic
- furniture content is data-driven
- save schema direction is defined
- Lumie state machine is defined
- offline calculation is defined
- UI/modal ownership is defined
- Android-first constraints are documented
- first playable build is explicitly scoped
- unresolved platform integrations are isolated as technical spikes rather than hidden assumptions

---

## 31. Current Technical Decision

**Proceed with Godot 4.x + GDScript as the Petal Nook production implementation.**

The next production step after this TDD is:

> **M0 — Technical Foundation: create the actual Godot project in this repository.**
