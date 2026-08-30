# Feature Specification: Playable Bounce Combat Prototype

**Feature Branch**: `001-playable-prototype`

**Created**: 2026-05-23

**Status**: Draft

**Input**: User description: "Describe what we've been building so far in this project. Focus on the what and why, not the tech stack."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Aim And Fire From A Right-Side Launcher (Priority: P1)

As a player, I want a visible character/launcher on the right side of the board so I can move vertically, preview a shot, and launch bouncing projectiles into the grid.

**Why this priority**: This is the core KupoKupo-inspired interaction. Without aiming, launcher movement, and projectile bounce behavior, the prototype has no playable loop.

**Independent Test**: Start the prototype, move the launcher with the mouse wheel, aim with the mouse, and fire. The player can verify launcher row movement, dotted trajectory preview, bounce prediction, and projectile launch from the correct row.

**Acceptance Scenarios**:

1. **Given** it is the player's turn, **When** the mouse moves around the board, **Then** a dotted trajectory line appears from the launcher and updates to match the mouse direction.
2. **Given** the launcher is on any valid row, **When** the player scrolls up or down, **Then** the launcher moves exactly one row in that direction and remains within the board height.
3. **Given** the player fires a shot, **When** the ball collides with board walls, **Then** it reflects using angle-based bounce behavior.
4. **Given** a bounced ball reaches the right wall on the player's current row, **When** it returns to the launcher row, **Then** the ball is removed from the field and the turn resolves.

---

### User Story 2 - Defeat Enemies With Bounce Combat (Priority: P1)

As a player, I want enemies on the board with health and score values so my bouncing shots can damage, defeat, and score against them.

**Why this priority**: Enemy collision transforms the bounce mechanic into combat and gives the player a reason to plan trajectories.

**Independent Test**: Fire a ball into enemies. Confirm enemies lose health, flash, disappear when defeated, increase score/combo, and eventually clear the level.

**Acceptance Scenarios**:

1. **Given** a ball collides with an enemy, **When** the hit is processed, **Then** the enemy takes damage and the score/combo updates.
2. **Given** an enemy's health reaches zero, **When** damage is applied, **Then** the enemy is removed from the board.
3. **Given** all enemies are removed, **When** the last enemy is defeated, **Then** the level is marked cleared.

---

### User Story 3 - Collect SP To Launch More Balls (Priority: P2)

As a player, I want collectible SP nodes on the board so that successful shots can increase the number of balls launched on future turns.

**Why this priority**: SP creates a clear reward loop for precision shots and adds progression inside a level without reintroducing the removed BP/card system.

**Independent Test**: Hit an SP node with a ball, confirm the SP value increases in the HUD, then fire the next shot and confirm that many balls launch along the same trajectory with spacing.

**Acceptance Scenarios**:

1. **Given** an SP node is on the board, **When** a ball collides with it, **Then** the node is removed and SP increases by the node's value.
2. **Given** the player has SP greater than one, **When** the player fires, **Then** the game launches that many balls on the same trajectory with visible time spacing.

---

### User Story 4 - Cast MP Spells From The Bottom-Left Panel (Priority: P2)

As a player, I want a bottom-left spell panel with MP costs and cooldowns so I can use tactical Eye spells in addition to ball shots.

**Why this priority**: Spells add tactical choices, healing, area damage, and defensive effects while keeping resource decisions readable.

**Independent Test**: Use each available spell from the panel and confirm MP is spent, cooldown appears, unavailable spells are disabled, and effects apply to enemies or player state as described.

**Acceptance Scenarios**:

1. **Given** the player has enough MP and the spell is available for the current stage, **When** the player activates a spell, **Then** MP decreases and the spell enters its recast cooldown.
2. **Given** a spell is on cooldown, unavailable for the stage, or too expensive for current MP, **When** the player views the spell panel, **Then** the spell button is disabled.
3. **Given** Eye Fire is cast with an enemy in front of the player row, **When** the spell resolves, **Then** the nearest valid enemy takes 20 damage.
4. **Given** Eye Cure is cast, **When** the spell resolves, **Then** the player restores 50 HP up to the maximum.

---

### User Story 5 - Load Prototype Level Data (Priority: P3)

As a designer, I want level layout, enemy placement, obstacles, and SP nodes to come from simple data so the prototype can be adjusted without rewriting scene logic.

**Why this priority**: Data-driven layout supports iteration and future level design tooling.

**Independent Test**: Modify the level JSON placements, reload the project, and confirm the board reflects the updated layout.

**Acceptance Scenarios**:

1. **Given** a level data file defines grid size, enemies, obstacles, and SP nodes, **When** the level loads, **Then** all defined objects appear at their configured cells.
2. **Given** the level data is missing or invalid, **When** the level manager loads, **Then** the game falls back to a playable default layout.

### Edge Cases

- If the mouse is too close to the launch point, no invalid shot should launch.
- If a spell has no valid target, it should not waste MP or start cooldown unless explicitly designed to do so.
- If multiple balls are active, launcher movement and new launches should be blocked until the turn resolves.
- If a ball is removed due to max bounces, return-to-launcher, or level clear, it should not be processed twice.
- If the player lacks MP, spell controls should visibly disable before activation.
- If a stage-restricted spell is outside its valid stage range, it should remain unavailable.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST show a playable grid board with visible tiles, obstacles, enemies, SP nodes, launcher, trajectory preview, and HUD.
- **FR-002**: System MUST place the player launcher to the right of the grid and allow mouse wheel movement by exactly one row per wheel step.
- **FR-003**: System MUST show a dotted trajectory preview from the launcher during the player's turn, including board-wall bounce prediction.
- **FR-004**: System MUST launch projectile balls from the launcher row along the current mouse trajectory.
- **FR-005**: System MUST remove a projectile when it returns to the right wall on the player's row after bouncing.
- **FR-006**: System MUST damage enemies when balls or spells hit them and remove enemies at zero health.
- **FR-007**: System MUST track score and combo during ball launches.
- **FR-008**: System MUST track SP, start SP at 1, increment SP when SP nodes are collected, and launch one ball per SP on future shots.
- **FR-009**: System MUST provide MP spell controls in the bottom-left UI.
- **FR-010**: System MUST enforce spell MP costs, recast cooldowns, and stage availability.
- **FR-011**: System MUST support Eye Fire, Eye Starstorm, Eye Meteor, Eye Cure, Eye Esuna, Eye Levitation, Eye Ward, and Eye Reraise with the effects and restrictions listed in the design documents.
- **FR-012**: System MUST load level layout from data for the prototype level.
- **FR-013**: System MUST preserve the human-created asset boundary by using placeholders only as implementation scaffolding.
- **FR-014**: System MUST validate startup without parser/runtime startup errors.

### Key Entities

- **Player Launcher**: Right-side player position; determines launch row, catch row, and "in front" spell targeting.
- **Ball Projectile**: Moving projectile with velocity, bounce count, damage, and collision behavior.
- **Enemy**: Board target with type, health, score value, position, and defeat behavior.
- **SP Node**: Collectible board object that increases Shot Points.
- **Spell**: MP ability with name, cost, recast, stage availability, and effect.
- **Level Data**: Grid and placement data for board setup.
- **HUD**: Player-facing display for score, HP, MP, SP, combo, status messages, and spells.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A player can complete the core loop of aim, fire, bounce, hit enemy, and end turn without leaving the main scene.
- **SC-002**: A player can collect an SP node and observe the next shot launch multiple spaced balls equal to current SP.
- **SC-003**: A player can cast every stage-available spell from the bottom-left panel and see MP/cooldown feedback immediately.
- **SC-004**: The project passes Godot startup validation with no project errors.
- **SC-005**: The playable prototype remains responsive during aiming and ball movement at the default viewport.

## Assumptions

- The board's "front" direction is leftward from the right-side launcher into the grid.
- Stage number is derived from the numeric part of the current level id.
- The current prototype uses placeholder geometry and text controls until human-created art/audio assets are supplied.
- Godot 4.6.2 console is available at the path documented in `project.md`.
