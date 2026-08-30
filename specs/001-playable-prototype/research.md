# Research: Playable Bounce Combat Prototype

## Decisions

### Use Godot 2D scenes and GDScript

**Decision**: Continue using Godot scene composition and GDScript.

**Rationale**: The project is already a Godot project, the game is 2D grid-based, and the existing prototype uses Godot-native signals, nodes, and scenes.

**Alternatives Considered**: External physics/gameplay libraries were not needed because the required bounce behavior is simple and Godot's built-in 2D primitives are sufficient.

### Keep levels JSON-backed

**Decision**: Store prototype level layout in JSON under `resources/level_data/`.

**Rationale**: JSON is easy to edit by hand and supports quick level iteration before a custom level editor exists.

**Alternatives Considered**: Godot resources could provide stronger editor integration later, but are heavier for this early prototype.

### Use a static spell book

**Decision**: Define Eye spells in `SpellBook.gd`.

**Rationale**: Spell definitions are structured, stable, and shared by UI and gameplay. A static source avoids duplicating costs/cooldowns in multiple files.

**Alternatives Considered**: JSON spell data may be useful later for balancing, but static definitions are simpler until content scale grows.

### Validate through Godot console

**Decision**: Require Godot startup validation for all behavior changes.

**Rationale**: Godot parser/runtime errors are caught quickly without launching the full editor. On the current Windows runtime, `--headless` crashes before project startup even without a project path, so windowed validation is the reliable local command.

## Open Follow-ups

- Establish automated tests for deterministic gameplay rules.
- Add visual QA screenshots once the target view is stable.
- Decide whether MP regenerates, persists, or resets per stage.
- Unify obstacle prediction with runtime obstacle bounce behavior.
