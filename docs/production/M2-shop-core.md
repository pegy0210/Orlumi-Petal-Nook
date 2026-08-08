# M2 — Shop Core Checkpoint

**Project:** Orlumi: Petal Nook  
**Studio:** @Orlumi Studio → @Petal Nook  
**Status:** IMPLEMENTED IN SOURCE / GODOT RUNTIME VERIFICATION PENDING

## Implemented

- Shop extracted from MainRoom into reusable `shop_panel.tscn`
- Portrait 2 × 2 card grid
- Little Pot card
- Wooden Rack card
- Curtain card
- Small Table card
- Current level display
- Next-effect display
- Petal cost display
- Upgrade / MAX state
- Buttons disabled when Petals are insufficient
- All four cards route purchases through `EconomyService`
- First successful purchase from any furniture type can trigger Lumie unlock/intro
- MainRoom shows developer placeholders when Wooden Rack, Curtain or Small Table becomes owned
- Shop refresh is skipped while hidden to avoid unnecessary per-frame UI work

## Current art state

All shop and room furniture visuals are developer placeholders only.

Approved Orlumi assets will replace these without changing economy or save logic.

## Next technical targets

- Lumie movement controller
- Lumie tap reactions
- annoyed state machine
- proper modal input blocking for offline/shop overlays
- Settings/reset
- Photo Mode
- rewarded-ad adapter abstraction

## Runtime gate

A real Godot 4.x smoke run is still required before any milestone is marked runtime-verified.
