# ADR-001 — Petal Nook Production Engine

**Status:** Accepted  
**Project:** @Orlumi Studio → @Petal Nook  

## Decision

Use **Godot 4.x stable with GDScript** as the production engine for Orlumi: Petal Nook.

The existing GDevelop implementation remains a prototype/reference only.

## Context

Petal Nook requires a workflow that supports:

- Android delivery
- portrait 2D room/decor gameplay
- persistent game state
- offline progress
- reusable furniture/companion data
- source control
- direct code review
- Codex/AI-assisted implementation
- long-term expansion inside the Orlumi universe

## Rationale

Godot provides a stronger production fit than continuing an event-sheet-heavy workflow because game systems can be expressed as maintainable text-based source, tested independently, reviewed through GitHub, and extended without manually duplicating large event structures.

## Consequences

### Positive

- GitHub becomes a practical source of truth for the game itself, not only documentation.
- Codex/AI can directly implement and revise major systems.
- Core game logic becomes testable and reusable.
- Future companions, furniture and areas can use common abstractions.
- Android export remains a first-class target.

### Cost

- Existing GDevelop implementation will not be mechanically reused.
- The first Godot playable must recreate the approved prototype behaviour.
- Final visual layout and Android build configuration still require editor/device validation.

## Migration Rule

Migrate **approved behaviour and assets**, not GDevelop event-sheet structure.

## Next Action

Create M0 Godot technical foundation in the existing `pegy0210/Orlumi-Petal-Nook` repository.
