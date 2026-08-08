# M5 — Offline Boost + Photo Mode Shell

**Status:** IMPLEMENTED IN SOURCE / PLATFORM RUNTIME VERIFICATION PENDING

## A. Offline Limit Boost

### Product rule preserved

- Base offline cap: 60 minutes
- One completed rewarded ad: +15 minutes
- Maximum: 120 minutes
- The reward increases future offline accumulation capacity; it does not add instant offline income.

### Technical flow

`MainRoom → RewardedAdService → Android ad adapter → completion callback → OfflineService → SaveService`

`RewardedAdService` deliberately does not know about a specific ad SDK.

Signals:

- `reward_requested(reward_id)` — future Android adapter opens the ad
- `reward_granted(reward_id)` — game reward completed
- `reward_unavailable(reward_id)` — provider/reward unavailable

### Debug behaviour

When running a debug build without an ad provider, a completed rewarded ad is simulated so the +15-minute flow can be tested before selecting an Android SDK.

Release behaviour is different: if no provider is available, no reward is granted.

### Cap progression

```text
60 → 75 → 90 → 105 → 120
```

At 120 minutes:

- UI displays `Offline MAX`
- control is disabled
- no further cap increase occurs

---

## B. Photo Mode

### Entry

Photo Mode is available from the MainRoom developer UI when no modal overlay is active.

### Standard UI hidden

While Photo Mode is active, the following are hidden:

- Header
- Petals / Income / Comfort / Offline Limit
- Save
- Shop
- Settings
- Offline Boost
- Photo entry button
- status text
- developer note

### Scene content retained

The following remain visible:

- room/background
- Little Pot placeholder / future furniture art
- owned furniture placeholders / future furniture art
- Lumie
- Photo Mode logo
- Capture
- Exit

### Lumie rule

Lumie remains interactive in Photo Mode. Normal emoji and annoyed behaviour continue to operate.

Little Pot gameplay input is disabled during Photo Mode.

### Capture sequence

1. Player presses Capture.
2. Capture and Exit controls are hidden.
3. The code waits for the next rendered frame.
4. The viewport is captured.
5. PNG is saved to app-private `user://` storage.
6. Capture and Exit controls are restored.

The logo remains visible during capture.

### Current filename

```text
user://petal_nook_photo_<unix_timestamp>.png
```

### Important platform boundary

The current implementation proves the in-engine capture flow only.

For release Android builds, a later platform adapter is still required if the Studio wants any of the following:

- save directly to the user's photo gallery
- Android media-library integration
- native share sheet
- share to social apps

That integration must not change Photo Mode's game-state rules.

---

## Files

- `game/autoload/rewarded_ad_service.gd`
- `game/autoload/offline_service.gd`
- `game/scenes/ui/photo_mode_ui.tscn`
- `game/scripts/ui/photo_mode_ui.gd`
- `game/scenes/main_room/main_room.tscn`
- `game/scripts/main_room/main_room.gd`
- `project.godot`

## Runtime verification checklist

### Offline Boost

1. Debug simulation increases 60 → 75.
2. Repeated completed rewards stop exactly at 120.
3. Each increase persists across save/reload.
4. Release build without provider grants nothing.
5. Android provider callback grants only after genuine rewarded completion.

### Photo Mode

1. Enter/exit does not alter progression.
2. All standard UI is hidden.
3. Lumie remains tappable.
4. Capture/Exit disappear from the actual captured frame.
5. Logo remains in the captured frame.
6. PNG saves successfully in desktop/debug runtime.
7. Capture does not freeze Lumie or passive income after completion.
8. Android app-private capture path works before gallery/share integration is attempted.
