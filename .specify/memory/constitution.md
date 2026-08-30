# Beholder Adventure Constitution

## Core Principles

### I. Gameplay Code Is Small, Typed, and Purposeful
All GDScript MUST use explicit types for public variables, signals, function parameters, and return values wherever Godot permits it without fighting engine APIs. Scene scripts MUST own only the behavior for their scene and delegate reusable rules to focused scripts under `scripts/`. Shared behavior MUST be named by gameplay concept, not implementation convenience. New abstractions are allowed only when they reduce real duplication or clarify a gameplay rule.

Runtime code MUST avoid hidden coupling through broad node searches. Prefer exported references, scene-owned `$NodePath` references, signals, or explicit setup calls. Placeholder visuals are acceptable during prototyping, but gameplay logic MUST remain asset-swappable so human-created art can replace placeholders without rewriting systems.

### II. Tests And Validation Are Required For Behavior Changes
Every gameplay behavior change MUST include a verification plan. At minimum, changes MUST pass Godot startup validation with:

```powershell
& 'C:\Users\Justin\Documents\GDOT\Godot_v4.6.2-stable_win64_console.exe' --path 'D:\iCloud\iCloudDrive\beholder-adventure' --quit-after 120
```

As of 2026-06-14, the local Godot runtime crashes in `--headless` mode before project startup even when no project path is supplied. Treat that as a local runtime issue, not a project failure, until the engine runtime is replaced or repaired.

New deterministic gameplay rules SHOULD have automated tests once a test harness exists. Until then, specs and task notes MUST include manual acceptance checks for launch behavior, collision behavior, resource changes, spell cooldowns, level loading, and UI state. Bug fixes MUST include a regression check that would have caught the bug.

### III. User Experience Must Stay Consistent And Playable
The first screen MUST remain the playable game, not a landing page or explanation page. Core controls MUST stay predictable: mouse position aims, left click fires, mouse wheel moves the right-side launcher by one row, right click/Escape cancels, and Escape pauses unless an approved spec changes the scheme.

UI MUST use consistent placement: top HUD for state summaries, bottom-left for MP spells, board space for trajectory and gameplay objects. Buttons MUST show cost/cooldown/availability clearly and be disabled when unusable. Text MUST remain readable at the configured viewport size and must not overlap board-critical information. New UI elements MUST not reintroduce removed concepts unless a spec explicitly restores them.

### IV. Performance Budgets Are Gameplay Requirements
Prototype and production work MUST preserve responsive aiming and projectile motion. The target budgets are 60 FPS on mid-range PC and 30+ FPS on mid-range mobile, with 60 FPS preferred. Per-frame logic MUST avoid unnecessary allocation, broad tree scans, or expensive geometry recomputation. Predictive trajectory drawing MUST stay bounded by configured bounce/distance limits.

Systems that can grow, including balls, enemies, spells, resource nodes, particles, and UI lists, MUST be designed with pooling or batching in mind before content scale increases. Any feature expected to create many nodes or repeated effects MUST document its expected upper bound and mitigation strategy.

### V. Human-Created Asset Boundary Is Mandatory
AI may create code, scene structure, placeholder geometry, JSON data structures, and implementation documentation. AI MUST NOT create final visual art, sprites, textures, icons, logos, audio, music, character designs, enemy appearances, or narrative content unless the human explicitly provides direction that changes this boundary. Code MUST reference assets through clear paths and fallbacks so human-created replacements can drop in cleanly.

## Project Constraints

- Engine: Godot 4.x, currently validated with Godot 4.6.2 console on Windows using normal windowed startup.
- Language: GDScript.
- Primary project path: `D:\iCloud\iCloudDrive\beholder-adventure`.
- Core documents: `game-design-document.md`, `godot-development-plan.md`, and `project.md`.
- Level data SHOULD remain JSON-backed unless a spec justifies moving to Godot resources.
- Main scene SHOULD boot into the current playable prototype.
- `.godot/`, import cache, logs, temporary files, and generated exports MUST NOT be committed.

## Development Workflow And Quality Gates

Specs MUST state user-facing behavior, acceptance checks, and performance implications before implementation begins. Plans MUST call out files/scenes touched, test strategy, and any docs that need updates.

Before work is considered complete:
- Godot startup validation MUST pass.
- Relevant docs MUST be updated when gameplay concepts, controls, resources, or UI change.
- `git status --short` SHOULD be reviewed so generated files and unrelated changes are not accidentally included.
- Any known limitation introduced or preserved by the change MUST be named in the final response or docs.

## Governance

This constitution supersedes informal habits and older plan language when they conflict. Amendments require an explicit user request or approval, an update to this file, and a note in the relevant plan/design documentation when the change affects gameplay direction.

Feature specs, implementation plans, and code reviews MUST check compliance with these principles. Exceptions are allowed only when documented with a reason, expected impact, and follow-up task.

**Version**: 1.0.1 | **Ratified**: 2026-05-23 | **Last Amended**: 2026-06-14
