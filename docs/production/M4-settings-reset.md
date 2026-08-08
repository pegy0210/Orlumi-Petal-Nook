# M4 — Settings + Double-Confirm Reset

**Status:** IMPLEMENTED IN SOURCE / RUNTIME VERIFICATION PENDING

## Completed

- Added `Settings` control to MainRoom developer UI.
- Added reusable `settings_panel.tscn`.
- Reset requires two separate confirmation steps.
- Cancel is available at both confirmation stages.
- Final reset calls the centralized `SaveService.reset_progress()` path.
- Pending offline reward is cleared before reset.
- Reset restores the approved v1 defaults:
  - Petals = 0
  - Little Pot = Lv1
  - Wooden Rack = Lv0
  - Curtain = Lv0
  - Small Table = Lv0
  - Comfort recalculated to 2
  - Income recalculated to 1/sec
  - Lumie locked
  - opening flag cleared
  - Lumie intro flag cleared
  - offline cap = 60 minutes
- Reset immediately returns the current session to first-launch opening flow.
- Lumie's transient reaction/annoyed state is also cleared when progress locks Lumie again.

## Paid entitlement rule

The reset flow only calls progress reset. It does not delete any permanent entitlement storage. This preserves the TDD requirement that paid permanent content remains logically separate from ordinary game progress.

## Modal input protection

MainRoom now prevents background interaction while any of these are open:

- Opening / Lumie story overlay
- Shop
- Settings
- Offline reward popup

During these modal states:

- Little Pot input is blocked
- Save/Shop/Settings main buttons are blocked
- Lumie tap interaction is blocked

This avoids touch-through behaviour on mobile.

Photo Mode is intentionally not part of this block rule yet; when Photo Mode is implemented, Lumie will remain interactive there by product requirement.

## Files

- `game/scenes/ui/settings_panel.tscn`
- `game/scripts/ui/settings_panel.gd`
- `game/scripts/main_room/main_room.gd`
- `game/scenes/main_room/main_room.tscn`
- `game/autoload/offline_service.gd`
- `game/scripts/companions/lumie.gd`

## Runtime verification checklist

1. Settings opens and closes correctly.
2. First reset confirmation does not reset progress.
3. Cancelling first confirmation keeps progress.
4. Continue opens final confirmation.
5. Cancelling final confirmation keeps progress.
6. Final Reset clears only progress.
7. Opening restarts immediately after reset.
8. Lumie disappears and transient annoyed/reaction state clears.
9. Furniture placeholders return to their initial visibility.
10. No background taps pass through modal panels.
