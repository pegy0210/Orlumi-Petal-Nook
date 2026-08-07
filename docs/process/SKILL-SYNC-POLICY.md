# @Orlumi Studio — Skill Sync Policy

## Scope
This policy applies to **@Orlumi Studio → @Petal Nook** and any project skill or operating instruction used to develop Orlumi: Petal Nook.

## Rule
Whenever a relevant Skill is created, updated, revised, or materially expanded, a repository copy must also be committed to the project repository.

Repository:
`pegy0210/Orlumi-Petal-Nook`

The GitHub copy acts as a durable project snapshot and development reference. ChatGPT/Studio-side instructions must not be the only copy of an important production Skill.

## Required Sync Workflow
For every material Skill update:

1. Update the active Skill / Studio instruction.
2. Create or update the corresponding repository snapshot in the same work cycle.
3. Include a clear version or update date where appropriate.
4. Commit with a message that identifies the Skill update.
5. Ensure downstream PRD, TDD, art, production, or QA documents are updated if the Skill change affects them.

## Recommended Repository Location
Use:

`studio/skills/`

Suggested naming examples:

- `studio/skills/orlumi-studio.md`
- `studio/skills/petal-nook.md`
- `studio/skills/art-direction.md`
- `studio/skills/production-workflow.md`

If a Skill is project-specific, prefer the Petal Nook repository copy over a generic note elsewhere.

## Source-of-Truth Rule
The active Skill may continue to drive the working session, while GitHub stores the durable synchronized copy.

If the two differ, the discrepancy must be resolved rather than silently allowing them to drift.

## Status
**MANDATORY PROJECT WORKFLOW**
