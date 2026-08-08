# M1 — Playable Flow Simulation

**Project:** Orlumi: Petal Nook  
**Studio:** @Orlumi Studio → @Petal Nook  
**Status:** LOGIC SIMULATION PASSED / GODOT RUNTIME VERIFICATION PENDING

## Scope checked

The current production branch was reviewed through the following route:

`project.godot → Boot → load/recalculate → MainRoom → passive income → Little Pot tap → Shop → Little Pot upgrade → Lumie unlock → save/load → offline reward`

## Simulated player flow

Initial state:

- Petals: 0
- Little Pot: Lv1
- Income: 1/sec
- Comfort: 2
- Lumie: locked

Simulation:

1. 20 seconds passive income → +20 Petals
2. 10 Little Pot taps at TapValue 1 → +10 Petals
3. Total = 30 Petals
4. Upgrade Little Pot Lv1 → Lv2 for 30 Petals
5. Petals = 0
6. Recalculation result:
   - Little Pot Lv2
   - Income = 2/sec
   - Comfort = 4
   - Lumie unlocked = true
7. 10 more seconds active → 20 Petals
8. Simulated restart after 60 seconds offline
9. Offline reward = `2 × 60 × 0.1 = 12 Petals`
10. Claim result = 32 Petals total

## Result

Core economy and persistence logic are internally consistent for the M1 path.

No blocking logic defect was found during static review and deterministic simulation.

## Additional M1 work added after simulation

- reusable StoryOverlay scene/controller
- first-launch four-beat opening sequence
- opening completion persisted
- Lumie intro triggered after first real successful purchase/upgrade
- Lumie intro completion persisted
- Shop is closed before Lumie intro so the introduction receives visual focus
- Story overlay blocks underlying touch interactions

## Important limitation

This is not a claim that the Godot project has been executed on the Godot runtime. The current execution environment does not contain Godot, so parser/render/input/device verification remains pending until the project is opened with Godot 4.x.

The next runtime smoke test must confirm:

- project opens without parser errors
- Boot reaches MainRoom
- touch/button input works
- StoryOverlay layering is correct
- save file can be written/read
- Android pause notification saves successfully
- portrait scaling behaves correctly

## Decision

Proceed with development. Runtime verification remains a required gate before calling M1 release-ready.
