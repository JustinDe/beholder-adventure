# Implementation Plan: Playable Bounce Combat Prototype

**Branch**: `001-playable-prototype` | **Date**: 2026-05-23 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/001-playable-prototype/spec.md`

## Summary

Build and maintain the current playable Godot prototype: a grid-based bounce combat game inspired by KupoKupo Adventure where a right-side launcher fires balls into a board, defeats enemies, collects SP nodes, and casts MP-based Eye spells from a bottom-left panel.

The technical approach keeps gameplay rules in small GDScript files, scene ownership clear, and layout/data editable through Godot scenes plus JSON level data. Placeholder visuals remain implementation scaffolding only; final art/audio must be human-created.

## Technical Context

**Language/Version**: GDScript, Godot 4.x. Current local validation uses Godot 4.6.2 stable console.

**Primary Dependencies**: Godot built-in 2D scene system, signals, `Area2D`, `Node2D`, `CanvasLayer`, `Control`, JSON loading through `FileAccess`/`JSON`.

**Storage**: JSON level data in `resources/level_data/`; lightweight save data through `user://save_data.json`.

**Testing**: Godot startup validation is mandatory. On this machine, use normal windowed validation because `--headless` crashes before project startup even without a project path. Manual acceptance checks cover aiming, launching, bouncing, SP collection, spells, cooldowns, and level loading until an automated Godot test harness is introduced.

**Target Platform**: PC prototype first, with planned mobile support.

**Project Type**: Godot 2D game.

**Performance Goals**: 60 FPS on mid-range PC, 30+ FPS on mid-range mobile, responsive aiming and projectile movement.

**Constraints**: No AI-created final art/audio. The first screen remains playable. Per-frame trajectory and collision work must stay bounded.

**Scale/Scope**: One playable prototype level now; architecture should support many levels, enemies, SP nodes, spells, and future human-created assets.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Code Quality**: PASS. Gameplay systems are split across focused scripts (`GameBoard`, `Ball`, `Enemy`, `SPNode`, `SpellBook`, `SpellPanel`, `GameState`).
- **Testing/Validation**: PASS with required Godot windowed validation command documented in quickstart.
- **UX Consistency**: PASS. Top HUD summarizes state; bottom-left panel contains MP spells; mouse and wheel controls remain consistent.
- **Performance**: PASS for prototype scale. Trajectory prediction is bounded by max bounce/distance. Future pooling is called out for scale.
- **Asset Boundary**: PASS. Current visuals are placeholder geometry/widgets; no final AI-created art/audio is introduced.

## Project Structure

### Documentation (this feature)

```text
specs/001-playable-prototype/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
└── tasks.md
```

### Source Code (repository root)

```text
project.godot
scenes/
├── main/
│   ├── Main.tscn
│   └── Main.gd
├── gameplay/
│   ├── GameBoard.tscn
│   ├── GameBoard.gd
│   ├── Ball.tscn
│   ├── Enemy.tscn
│   ├── SPNode.tscn
│   └── TrajectoryPreview.gd
└── ui/
    ├── HUD.tscn
    ├── HUD.gd
    ├── SpellPanel.tscn
    └── SpellPanel.gd

scripts/
├── core/
│   ├── GameState.gd
│   ├── InputHandler.gd
│   └── AudioManager.gd
├── gameplay/
│   ├── Ball.gd
│   ├── BallPhysics.gd
│   ├── ComboSystem.gd
│   ├── Enemy.gd
│   ├── EnemyTypes.gd
│   ├── LevelManager.gd
│   ├── SPNode.gd
│   └── SpellBook.gd
└── ui/
    ├── SpellPanel.gd
    └── TouchControls.gd

resources/
└── level_data/
    └── level_001.json
```

**Structure Decision**: Use Godot scene files for composition, GDScript for gameplay systems, and JSON for level layout iteration. Runtime global state remains in `GameState` autoload, while board-specific behavior stays in `GameBoard`.

## Architecture Choices

- **Scene Ownership**: `Main` wires top-level scene communication. `GameBoard` owns board state, level loading, launcher state, projectiles, enemies, SP nodes, and spell effects. `HUD` owns presentation and forwards spell requests.
- **Data-Driven Level Setup**: `LevelManager` reads `resources/level_data/level_001.json`, with fallback data for resilience.
- **Resources**: SP is a shot-count resource. MP is a spell-casting resource. HP is player survival state. Score/combo are combat feedback.
- **Spell Definitions**: `SpellBook` is a centralized static definition source for names, costs, cooldowns, descriptions, and stage restrictions.
- **Collision Model**: Balls are `Area2D` nodes. Enemies and SP nodes are also `Area2D` nodes on the collision layer the ball detects.
- **Trajectory Preview**: A custom `TrajectoryPreview` node draws dotted path points from bounded prediction data.

## Complexity Tracking

No constitution violations are required for this implementation. Known complexity risks are tracked as follow-ups:

| Risk | Why Accepted | Follow-up |
|------|--------------|-----------|
| Obstacle bounce prediction differs from runtime collision | Prototype already supports runtime obstacle collision; prediction currently covers board walls only | Unify obstacle prediction and runtime reflection |
| Manual testing only | Godot test harness is not established yet | Add automated gameplay tests when harness exists |
| Active balls are instantiated per launch | Prototype scale is small | Add pooling before content scale increases |
