# Feature Specification: Turn Phase Progression

**Feature Branch**: `002-turn-phase-progression`

**Created**: 2026-08-30

**Status**: Draft

**Input**: User description: "create the turn system where the player takes their turn first always, then the enemies take their turn. after each player and enemy turn the global turn counter should increase by one. After 10 turns the game should progress to the next phase. the game should be a like a roguelike in that there are an infinate number of phases with each phase enhancing the enemy difficulty. After every 5 phases the player should get a special gem that will act as a currancy to be spent in the shop between runs."

## Clarifications

### Session 2026-08-30

- Q: When should the player's fired attacks despawn and the player turn end? -> A: Fired attacks despawn when they hit the wall in front of the player, a timeout despawns stuck balls, R restarts the current round only during the player's turn, and the player's turn ends only after all fired balls despawn.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Resolve Alternating Turns (Priority: P1)

As a player in combat, I always take the first turn in a run and each round alternates from player action to enemy action so the order is predictable and fair.

**Why this priority**: The turn order is the foundation for combat pacing, cooldowns, enemy pressure, and player decision-making.

**Independent Test**: Start a run and observe the first several combat turns; the player acts first, enemies act after the player, and the sequence repeats without enemies acting before the player.

**Acceptance Scenarios**:

1. **Given** a new run has started, **When** combat begins, **Then** the game waits for the player's turn before any enemy turn resolves.
2. **Given** the player has completed their turn, **When** the next turn begins, **Then** all eligible enemies resolve their turn before control returns to the player.
3. **Given** the enemy turn has completed, **When** combat continues in the same phase, **Then** the player receives the next actionable turn.
4. **Given** the player has fired one or more balls, **When** every fired ball has despawned, **Then** the player turn is considered complete and the enemy turn may begin.

---

### User Story 2 - Advance Phases By Global Turn Count (Priority: P1)

As a player, I want the game to advance to a new gameplay phase after a fixed number of turns so each run has a clear escalating rhythm.

**Why this priority**: Phase progression defines the roguelike structure and provides a measurable cadence for increasing challenge.

**Independent Test**: Complete player and enemy turns until the global turn counter reaches 10; the current gameplay phase ends and the next phase begins.

**Acceptance Scenarios**:

1. **Given** the global turn counter is 0 at the start of a phase, **When** the player completes their first turn, **Then** the counter becomes 1.
2. **Given** the global turn counter is 1 after the player turn, **When** the enemies complete their turn, **Then** the counter becomes 2.
3. **Given** the global turn counter reaches 10 after any completed player or enemy turn, **When** the turn resolution finishes, **Then** the game advances to the next gameplay phase.

---

### User Story 3 - Escalate Endless Enemy Difficulty (Priority: P2)

As a player, I want every new gameplay phase to become more dangerous so a run can continue indefinitely while steadily testing mastery.

**Why this priority**: Endless phase progression is the main replay structure and makes each run feel like a scaling challenge rather than a fixed level.

**Independent Test**: Advance through multiple phases and verify that each later phase has stronger enemy challenge than the prior phase.

**Acceptance Scenarios**:

1. **Given** the player advances from gameplay phase 1 to gameplay phase 2, **When** the next phase begins, **Then** enemy difficulty is higher than it was in gameplay phase 1.
2. **Given** the player advances through many gameplay phases, **When** each new phase starts, **Then** there is no designed final phase cap that stops progression.
3. **Given** a phase begins, **When** enemy difficulty is presented through enemy stats, count, behavior, or composition, **Then** the challenge increase is visible or otherwise understandable to the player.

---

### User Story 4 - Award Special Gems For Milestones (Priority: P3)

As a player, I want to earn a special gem after every 5 completed gameplay phases so long runs provide meta-progression currency for the shop between runs.

**Why this priority**: Special gems connect in-run progress to between-run progression and reward survival milestones.

**Independent Test**: Complete gameplay phase 5 and confirm one special gem is awarded for use outside the current run; repeat at phase 10 to confirm milestone repetition.

**Acceptance Scenarios**:

1. **Given** the player completes gameplay phase 5, **When** the game transitions to gameplay phase 6, **Then** the player gains 1 special gem.
2. **Given** the player completes gameplay phase 10, **When** the game transitions to gameplay phase 11, **Then** the player gains 1 additional special gem.
3. **Given** the player ends a run after earning special gems, **When** they enter the between-run shop, **Then** the earned special gems are available as currency.

### Edge Cases

- If the player defeats all active enemies before the global turn counter reaches 10, the phase still waits until the 10-turn threshold unless another existing victory or progression rule explicitly ends the phase.
- If the player is defeated during an enemy turn, the turn counter increments for the completed enemy turn before the run-end outcome is shown.
- If a phase transition is triggered by the player's turn reaching turn 10, enemies do not receive an extra turn in the completed phase.
- If a phase transition is triggered by the enemy turn reaching turn 10, the next phase begins with the player's turn.
- If the player reaches multiple 5-phase milestones over a long run, each milestone grants exactly 1 special gem once.
- If the player abandons or loses a run before a 5-phase milestone is completed, no partial special gem is awarded for that incomplete milestone.
- If a fired ball hits the wall in front of the player, that ball despawns instead of bouncing back into play.
- If fired balls become stuck or fail to despawn normally, a timeout despawns the remaining balls so the player's turn can complete.
- If the player presses R during their turn before firing, the current round restarts; pressing R while balls are active or during the enemy turn has no effect.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The game MUST start every run and every new gameplay phase with the player turn active before enemies can act.
- **FR-002**: The game MUST alternate turn ownership in the sequence player turn, enemy turn, player turn, enemy turn while the phase remains active.
- **FR-003**: The game MUST increase the global turn counter by exactly 1 after each completed player turn.
- **FR-004**: The game MUST increase the global turn counter by exactly 1 after each completed enemy turn.
- **FR-005**: The game MUST progress to the next gameplay phase immediately after the global turn counter reaches 10 for the current phase.
- **FR-006**: The game MUST reset the phase turn counter to 0 when a new gameplay phase begins while preserving any lifetime or run-level turn history used elsewhere.
- **FR-007**: The game MUST support unbounded gameplay phase progression without a predefined final gameplay phase.
- **FR-008**: The game MUST increase enemy difficulty for each new gameplay phase compared with the previous phase.
- **FR-009**: The game MUST ensure every gameplay phase transition after completing phases divisible by 5 awards exactly 1 special gem.
- **FR-010**: The game MUST make earned special gems available as between-run shop currency after the run ends.
- **FR-011**: The game MUST prevent duplicate special gem awards for the same completed phase milestone.
- **FR-012**: The game MUST communicate the current gameplay phase and turn count to the player clearly enough to understand progression toward the next phase.
- **FR-013**: The game MUST preserve existing player resources, cooldown pacing, combat resolution, and defeat handling unless they directly conflict with the new turn and phase rules.
- **FR-014**: Fired balls MUST despawn when they hit the wall in front of the player.
- **FR-015**: The player turn MUST end only after all balls fired during that turn have despawned.
- **FR-016**: The game MUST despawn all remaining fired balls after a timeout if they have not despawned normally.
- **FR-017**: The player MUST be able to restart the current round with R only while it is the player's turn and no fired balls are active.

### Key Entities

- **Turn State**: Represents whose turn is active, whether a turn is resolving, and whether player input or enemy actions are currently allowed.
- **Global Turn Counter**: Tracks completed player and enemy turns within the current gameplay phase and triggers phase advancement at 10.
- **Gameplay Phase**: Represents the current endless run stage, including its phase number, turn progress, and enemy difficulty level.
- **Enemy Difficulty Profile**: Represents the challenge settings applied to enemies for a gameplay phase, such as enemy strength, enemy count, behavior complexity, or enemy mix.
- **Special Gem Balance**: Represents the player's earned milestone currency that can be spent in the shop between runs.
- **Run Progress**: Represents phase milestones completed during the current run and which milestone rewards have already been granted.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In 100 observed new runs, the first actionable combat turn belongs to the player 100% of the time.
- **SC-002**: Across at least 50 complete player/enemy turn pairs, the global turn counter increases by 2 per pair with no skipped or duplicate increments.
- **SC-003**: In repeated phase tests, the game advances to the next gameplay phase within one resolved turn after the phase counter reaches 10, 100% of the time.
- **SC-004**: Across at least 20 consecutive gameplay phases, every new phase applies a higher enemy difficulty level than the prior phase.
- **SC-005**: Across phases 5, 10, 15, and 20, the player receives exactly 1 special gem per milestone and no special gem on non-milestone phases.
- **SC-006**: At least 90% of test players can identify the current gameplay phase and progress toward the next phase without external explanation.
- **SC-007**: In 100 launches where balls return to the wall in front of the player, those balls despawn at that wall 100% of the time.
- **SC-008**: In timeout tests with forced stuck balls, all remaining balls despawn and the player turn completes within the configured timeout 100% of the time.

## Assumptions

- A "turn" means one completed side turn: either the player's action resolution or the enemies' collective action resolution.
- "After 10 turns" means after 10 increments of the current gameplay phase's global turn counter, not 10 full player/enemy rounds.
- "Phase" in this feature means an in-run gameplay phase, distinct from the project's development phases.
- A special gem is awarded when the player completes gameplay phase 5, 10, 15, and every later multiple of 5.
- Enemy difficulty can be enhanced through any player-visible challenge vector, including stronger stats, additional enemies, upgraded enemy types, more dangerous behaviors, or harder enemy compositions.
- Special gems are meta-progression currency retained for the between-run shop, while normal in-run resources remain separate.
- The "current round" restart means reloading the current gameplay phase encounter while preserving the current run, current phase number, and persistent golden gems.
