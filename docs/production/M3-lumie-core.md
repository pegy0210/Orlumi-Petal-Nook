# M3 — Lumie Companion Core

**Status:** IMPLEMENTED IN SOURCE / RUNTIME VERIFICATION PENDING

## Scope completed

- Lumie extracted into a reusable companion scene.
- Lumie is hidden until `GameState.lumie_unlocked == true`.
- Lumie moves gently inside a bounded main-room region.
- Movement is limited to the active main-room space and does not use the right-side Area 2 reservation.
- Lumie remains clickable while idle or moving.
- Successful taps trigger one normal emoji reaction.
- Emoji cannot refresh while visible.
- Normal emoji display time: 2 seconds.
- Cooldown after emoji: random 1–2 seconds.
- Taps during reaction/cooldown/annoyed are ignored.
- Successful tap count increments only for accepted taps.
- Annoyed probability:
  - taps 1–5: 0%
  - taps 6–7: 25%
  - taps 8–9: 50%
  - taps 10+: 100%
- Annoyed duration: 30 seconds.
- During annoyed state Lumie ignores interaction.
- At the end of annoyed state:
  - visual returns to normal placeholder state
  - emoji clears
  - successful tap count resets to 0
  - movement resumes

## Normal emoji pool

- 🌸
- ✨
- 😊
- 💛
- 😴
- ❔

## Current developer visual

The current `BodyButton` and emoji label are placeholders only. They exist to validate behaviour before approved Lumie sprites/animations are integrated.

Final Lumie art must preserve Orlumi identity:

- star-ear structure
- glowing droplet tail
- soft luminous eyes
- creamy white / pastel lavender / blush pink / pale gold palette

## Files

- `game/scenes/companions/lumie.tscn`
- `game/scripts/companions/lumie.gd`
- `game/scenes/main_room/main_room.tscn`
- `game/scripts/main_room/main_room.gd`

## Static / logic validation

Probability threshold review:

```text
Tap 1  -> 0%
Tap 2  -> 0%
Tap 3  -> 0%
Tap 4  -> 0%
Tap 5  -> 0%
Tap 6  -> 25%
Tap 7  -> 25%
Tap 8  -> 50%
Tap 9  -> 50%
Tap 10 -> 100%
```

Movement target range is currently constrained to the main active zone through `movement_bounds` and therefore does not enter the reserved right-side Area 2 region.

## Runtime verification still required

When Godot runtime is available, verify:

1. Scene/parser loads without warnings or errors.
2. Lumie appears immediately after first real purchase/upgrade.
3. Movement remains visually inside the intended floor area.
4. Touch input works while Lumie is stationary and moving.
5. Emoji remains visible for approximately 2 seconds.
6. Cooldown blocks repeated refresh.
7. 10 accepted rapid interaction cycles always reaches annoyed state if earlier probability checks did not already trigger it.
8. Annoyed lasts approximately 30 seconds and then fully recovers.
9. Opening/Lumie intro overlays block unintended background input.
10. Final approved sprite hitbox feels natural on Android touch devices.

## Next production step

Move from companion behaviour into the remaining player-facing shell:

- Settings + double-confirm Reset
- Offline Limit boost control abstraction
- Photo Mode state and UI hiding rules
- then approved art integration
