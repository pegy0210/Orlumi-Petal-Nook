# @Orlumi Studio — @Petal Nook
# M0 Production Bootstrap

**Date:** 2026-08-08  
**Status:** IMPLEMENTED IN REPOSITORY / ENGINE-RUNTIME VERIFICATION PENDING

## Objective
Convert Petal Nook from a documentation/prototype-only repository into the production Godot codebase defined by TDD v1.0.

## Implemented

- `project.godot`
- Godot autoload architecture
- central `GameState`
- `EconomyService`
- passive Petal income
- Little Pot tap income
- Little Pot Lv1→Lv5 upgrade logic
- economy recalculation from levels
- Lumie unlock flag based on first real purchase/upgrade
- `SaveService`
- JSON progress save
- 60-second autosave
- manual save hook
- `OfflineService`
- 60-minute base offline cap
- offline reward formula at 10% production rate
- future +15-minute offline-cap service hook, max 120 minutes
- boot scene and boot initialization flow
- developer `MainRoom` scene
- developer HUD
- Little Pot tap control
- Shop open/close
- Little Pot upgrade card
- offline claim popup
- Lumie placeholder visibility for unlock verification
- Android-oriented 1080×1920 reference viewport
- Godot `.gitignore`

## Important
The current MainRoom is a **developer validation layout**, not approved final Orlumi UI or art.

It exists to prove the production systems before approved assets and final component layouts are integrated.

## Runtime verification status
The repository files have been authored against Godot 4.x conventions. The current ChatGPT execution environment does not contain a Godot runtime/editor, so the project has **not yet been launched or compiled here**.

The next technical gate is to open/validate the repo with Godot 4.x or Codex in an environment with Godot installed, fix any parser/runtime errors, and establish a repeatable smoke-test/build workflow.

## Next milestone
**M1 — Core playable vertical slice validation**

Required acceptance path:

1. project launches into MainRoom
2. Petals increase passively
3. Little Pot tap adds Petals
4. Shop opens/closes
5. Lv1→Lv2 purchase deducts 30 Petals
6. income recalculates to 2/sec
7. Lumie unlock flag becomes true
8. save and reopen restores state
9. offline return prepares one claimable reward without double-counting
