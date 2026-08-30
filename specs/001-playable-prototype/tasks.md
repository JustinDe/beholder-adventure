# Tasks: Playable Bounce Combat Prototype

**Input**: Design documents from `/specs/001-playable-prototype/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, quickstart.md

**Tests**: Godot startup validation is required. Use windowed validation locally because `--headless` currently crashes before project startup. Manual acceptance checks are listed per user story until an automated Godot test harness exists.

**Organization**: Tasks are grouped by independently testable user story.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish project-level documentation, governance, and runtime entrypoint.

- [x] T001 [P] Create Spec Kit constitution in `.specify/memory/constitution.md`
- [x] T002 [P] Create feature spec in `specs/001-playable-prototype/spec.md`
- [x] T003 [P] Create technical plan in `specs/001-playable-prototype/plan.md`
- [x] T004 [P] Create supporting design docs in `specs/001-playable-prototype/research.md`, `specs/001-playable-prototype/data-model.md`, and `specs/001-playable-prototype/quickstart.md`
- [x] T005 Configure playable main scene in `project.godot` and `scenes/main/Main.tscn`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core gameplay infrastructure required by all stories.

- [x] T006 [P] Implement global player/progression/resource state in `scripts/core/GameState.gd`
- [x] T007 [P] Implement input abstraction in `scripts/core/InputHandler.gd`
- [x] T008 [P] Implement level loading in `scripts/gameplay/LevelManager.gd`
- [x] T009 [P] Implement board scene ownership and level setup in `scenes/gameplay/GameBoard.gd` and `scenes/gameplay/GameBoard.tscn`
- [x] T010 [P] Implement HUD shell in `scenes/ui/HUD.gd` and `scenes/ui/HUD.tscn`

**Checkpoint**: Foundation ready.

---

## Phase 3: User Story 1 - Aim And Fire From A Right-Side Launcher (Priority: P1)

**Goal**: Player can move the launcher, preview shots, fire balls, and resolve returned balls.

**Independent Test**: Run the main scene, move launcher with mouse wheel, aim with mouse, fire, observe bounce/return behavior.

- [x] T011 [US1] Add right-side launcher position and row movement in `scenes/gameplay/GameBoard.gd`
- [x] T012 [US1] Add dotted trajectory preview in `scenes/gameplay/TrajectoryPreview.gd`
- [x] T013 [US1] Implement bounce prediction in `scripts/gameplay/BallPhysics.gd`
- [x] T014 [US1] Implement projectile scene and movement in `scripts/gameplay/Ball.gd` and `scenes/gameplay/Ball.tscn`
- [x] T015 [US1] Remove returned balls when they hit the launcher row after bouncing in `scenes/gameplay/GameBoard.gd`

**Checkpoint**: User Story 1 is functional.

---

## Phase 4: User Story 2 - Defeat Enemies With Bounce Combat (Priority: P1)

**Goal**: Balls and spells can damage enemies; defeated enemies clear from the board.

**Independent Test**: Fire into enemies and verify damage, defeat, score/combo, and level clear.

- [x] T016 [P] [US2] Implement enemy types in `scripts/gameplay/EnemyTypes.gd`
- [x] T017 [P] [US2] Implement enemy scene/script in `scripts/gameplay/Enemy.gd` and `scenes/gameplay/Enemy.tscn`
- [x] T018 [US2] Spawn enemies from level data in `scenes/gameplay/GameBoard.gd`
- [x] T019 [US2] Connect ball-enemy collision, score, combo, and level-clear behavior in `scripts/gameplay/Ball.gd`, `scripts/gameplay/ComboSystem.gd`, and `scenes/gameplay/GameBoard.gd`

**Checkpoint**: User Story 2 is functional.

---

## Phase 5: User Story 3 - Collect SP To Launch More Balls (Priority: P2)

**Goal**: Player can collect SP nodes and launch multiple spaced balls based on SP.

**Independent Test**: Collect an SP node, confirm HUD SP increases, then fire and observe multiple balls.

- [x] T020 [P] [US3] Add SP state and HUD signal in `scripts/core/GameState.gd`
- [x] T021 [P] [US3] Add SP HUD label in `scenes/ui/HUD.gd` and `scenes/ui/HUD.tscn`
- [x] T022 [US3] Implement SP node scene/script in `scripts/gameplay/SPNode.gd` and `scenes/gameplay/SPNode.tscn`
- [x] T023 [US3] Spawn SP nodes from `resources/level_data/level_001.json`
- [x] T024 [US3] Launch one spaced ball per SP in `scenes/gameplay/GameBoard.gd`

**Checkpoint**: User Story 3 is functional.

---

## Phase 6: User Story 4 - Cast MP Spells From The Bottom-Left Panel (Priority: P2)

**Goal**: Player can cast MP spells with visible costs, cooldowns, availability, and prototype effects.

**Independent Test**: Cast each available spell, verify MP/cooldown UI, and confirm effects.

- [x] T025 [P] [US4] Define spell data in `scripts/gameplay/SpellBook.gd`
- [x] T026 [P] [US4] Add spell cooldown/status/MP signals in `scripts/core/GameState.gd`
- [x] T027 [US4] Implement bottom-left spell panel in `scripts/ui/SpellPanel.gd` and `scenes/ui/SpellPanel.tscn`
- [x] T028 [US4] Wire spell requests through `scenes/ui/HUD.gd`, `scenes/ui/HUD.tscn`, and `scenes/main/Main.gd`
- [x] T029 [US4] Implement spell effects and stage gates in `scenes/gameplay/GameBoard.gd`
- [x] T030 [US4] Remove obsolete bottom-left action toggle/card files from `scenes/ui/ActionCards.tscn`, `scripts/ui/CardSelector.gd`, and `scripts/gameplay/ActionCard.gd`

**Checkpoint**: User Story 4 is functional.

---

## Phase 7: User Story 5 - Load Prototype Level Data (Priority: P3)

**Goal**: Board setup is editable from JSON data.

**Independent Test**: Edit `resources/level_data/level_001.json`, reload, and confirm board placement updates.

- [x] T031 [US5] Define level id, grid, ball start, obstacles, SP nodes, and enemies in `resources/level_data/level_001.json`
- [x] T032 [US5] Preserve fallback level data in `scripts/gameplay/LevelManager.gd`

**Checkpoint**: User Story 5 is functional.

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Documentation and validation that cut across all stories.

- [x] T033 [P] Update `godot-development-plan.md` with current implementation status, resources, and spell roster
- [x] T034 [P] Update `game-design-document.md` with SP and MP spell model
- [x] T035 Run Godot startup validation from `specs/001-playable-prototype/quickstart.md`
- [x] T036 Review `git status --short` for generated files and unrelated changes

---

## Dependencies & Execution Order

- Phase 1 and Phase 2 establish the playable project structure and state systems.
- User Stories 1 and 2 are MVP and must remain functional before SP/spells are considered complete.
- User Story 3 depends on board, ball collision, GameState, and HUD.
- User Story 4 depends on GameState, HUD, Main, and GameBoard.
- User Story 5 supports all gameplay stories through data-driven layout.

## Implementation Strategy

The feature has been implemented incrementally in the current prototype. The remaining execution step is validation against the quickstart and review of changed files before commit.
