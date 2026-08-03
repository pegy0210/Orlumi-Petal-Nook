# Orlumi: Petal Nook

A portrait-format cozy idle decor game for Android, developed as part of the wider **Orlumi** brand universe.

> Little lights, little wonders.

## Current development status

- GDevelop project started
- `MainRoom` scene and core layers created
- Core global variables initialized
- Petal display and basic income logic started
- Current implementation stage: **Step 4 — Shop UI skeleton**

## Core direction

- Portrait mobile layout
- Semi top-down room with clear front-to-back depth
- Soft painterly 2D art
- Gentle, dreamy and premium-cute visual language
- Main interaction area in the centre-left
- Right side reserved for future Area 2 expansion
- Android first; not a web-first game

## Repository structure

```text
docs/
  core-design-spec.md
  art-direction.md
  asset-size-guide.md
  gdevelop-build-log.md
assets/
  README.md
```

## Key rules

- Little Pot starts at Lv1.
- Other furniture starts at Lv0 and appears at Lv1.
- Lumie appears only after the first real purchase or upgrade.
- Lumie is a companion only in v1 and has no economic bonus.
- Offline earning capacity starts at 60 minutes and can be extended by rewarded ads in 15-minute increments, up to 120 minutes.
- Shop uses a 2 × 2 card grid with large furniture art.
- Photo Mode hides standard UI but keeps Lumie interaction available.

See the files under `docs/` for the finalized v2 rules and implementation notes.
