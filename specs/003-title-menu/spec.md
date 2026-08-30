# Feature Specification: Title Menu

**Feature Branch**: `003-title-menu`

**Created**: 2026-08-30

**Status**: Draft

**Input**: User description: "create a title menu that when the game launches it takes you into. The options for the title menu should show your current count of golden gems that are earned every 5 phases completed. the menu should have the following options. Start, Store, Settings, and Exit. Start should start a new roguelike run which is the main gameplay loop. Store should take you to a gallery like page where a user can spend their golden gems. Settings should take you to a settings page where a user can adjust SFX, Music, and UI sound levels. Exit should quit the game."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Launch Into Title Menu (Priority: P1)

As a player, I want the game to open on a clear title menu so I can choose what to do before entering a run.

**Why this priority**: The title menu becomes the entry point for every session and controls access to the main gameplay loop.

**Independent Test**: Launch the game from a fresh start and confirm the title menu appears before gameplay, with the required menu options visible.

**Acceptance Scenarios**:

1. **Given** the game is not running, **When** the player launches it, **Then** the title menu is the first interactive screen shown.
2. **Given** the title menu is shown, **When** the player views the available actions, **Then** Start, Store, Settings, and Exit are all available.
3. **Given** the player returns from another menu screen, **When** the title menu is shown again, **Then** the same options remain available.

---

### User Story 2 - Start A New Run (Priority: P1)

As a player, I want the Start option to begin a fresh roguelike run so I can enter the main gameplay loop quickly.

**Why this priority**: Starting a run is the primary purpose of the title menu and must work before optional menu flows matter.

**Independent Test**: Select Start from the title menu and confirm a new roguelike run begins with normal gameplay state.

**Acceptance Scenarios**:

1. **Given** the player is on the title menu, **When** they choose Start, **Then** a new roguelike run begins.
2. **Given** the player starts a new run, **When** gameplay begins, **Then** the run uses fresh in-run progress while keeping persistent golden gems intact.

---

### User Story 3 - View And Spend Golden Gems In Store (Priority: P2)

As a player, I want to see my golden gem balance and enter a gallery-style store so I can spend milestone currency earned from completed phases.

**Why this priority**: Golden gems are the bridge between run progress and between-run rewards, so the menu must make the currency visible and usable.

**Independent Test**: Give the player a known golden gem balance, open the title menu and Store, then verify the balance is shown and spendable.

**Acceptance Scenarios**:

1. **Given** the player has earned golden gems, **When** the title menu appears, **Then** the current golden gem count is visible.
2. **Given** the player chooses Store, **When** the store opens, **Then** a gallery-like page of purchasable items or unlocks is shown.
3. **Given** the player has enough golden gems for an item, **When** they purchase it, **Then** the item is acquired and the golden gem count decreases by the item cost.
4. **Given** the player does not have enough golden gems for an item, **When** they attempt to purchase it, **Then** the purchase is prevented and the player is clearly informed why.

---

### User Story 4 - Adjust Audio Settings (Priority: P2)

As a player, I want to adjust SFX, music, and UI sound levels from Settings so the game's audio mix fits my preference.

**Why this priority**: Audio controls are expected quality-of-life settings and should be reachable before or between runs.

**Independent Test**: Open Settings from the title menu, adjust each audio category, leave the screen, and confirm the selected levels remain in effect.

**Acceptance Scenarios**:

1. **Given** the player is on the title menu, **When** they choose Settings, **Then** settings for SFX, Music, and UI sound levels are available.
2. **Given** the player changes an audio level, **When** the setting is applied, **Then** the corresponding audio category reflects the new level.
3. **Given** the player leaves and reopens Settings, **When** the settings screen is shown again, **Then** the last selected audio levels are retained.

---

### User Story 5 - Exit From Title Menu (Priority: P3)

As a player, I want the Exit option to quit the game from the title menu so I can close the application intentionally.

**Why this priority**: Exit is necessary for desktop usability but does not block the main menu-to-gameplay loop.

**Independent Test**: Select Exit from the title menu and confirm the game closes cleanly.

**Acceptance Scenarios**:

1. **Given** the player is on the title menu, **When** they choose Exit, **Then** the game quits.
2. **Given** the player has unsaved persistent golden gems or settings, **When** they choose Exit, **Then** the game preserves those persistent values before quitting.

### Edge Cases

- If the player has never earned golden gems, the title menu and store show a balance of 0.
- If stored golden gem data cannot be loaded, the menu uses a safe default balance and does not allow data corruption to block menu access.
- If the player returns to the title menu after a run where phase milestones were completed, the displayed golden gem count reflects the newly earned total.
- If the Store is opened with 0 golden gems, purchasable content remains viewable but unaffordable purchases are blocked.
- If audio settings have never been changed, Settings starts with sensible default values for SFX, Music, and UI sound levels.
- If the game is running on a platform where a direct quit action is unavailable or discouraged, Exit follows that platform's expected close or return behavior.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The game MUST show the title menu as the first interactive screen after launch.
- **FR-002**: The title menu MUST show the player's current golden gem count.
- **FR-003**: The title menu MUST provide Start, Store, Settings, and Exit options.
- **FR-004**: Choosing Start MUST begin a new roguelike run and enter the main gameplay loop.
- **FR-005**: Starting a new run MUST reset in-run progress without resetting persistent golden gems.
- **FR-006**: Choosing Store MUST open a gallery-like store page.
- **FR-007**: The Store MUST show purchasable or unlockable entries that can be browsed before purchase.
- **FR-008**: The Store MUST allow the player to spend golden gems on eligible entries.
- **FR-009**: The Store MUST prevent purchases when the player has insufficient golden gems.
- **FR-010**: Golden gem spending MUST update the visible golden gem balance after a successful purchase.
- **FR-011**: Choosing Settings MUST open a settings page with separate controls for SFX, Music, and UI sound levels.
- **FR-012**: Audio settings changes MUST remain active after leaving the Settings page.
- **FR-013**: Choosing Exit MUST quit the game or perform the platform-appropriate close action.
- **FR-014**: The menu MUST provide a way to return from Store and Settings to the title menu.
- **FR-015**: Persistent golden gem balance and audio settings MUST be available across game sessions.
- **FR-016**: Golden gems shown in the menu MUST represent the currency earned from completing every 5 gameplay phases.

### Key Entities

- **Title Menu**: The first interactive screen that displays golden gem balance and routes the player to Start, Store, Settings, or Exit.
- **Golden Gem Balance**: The player's persistent between-run currency earned from phase milestones and spent in the Store.
- **Roguelike Run**: A fresh gameplay attempt started from the title menu, with in-run progress separate from persistent currency.
- **Store Gallery**: A browsable page of purchasable or unlockable entries that use golden gems as currency.
- **Store Entry**: A purchasable item or unlock with a display state, price, affordability state, and ownership state.
- **Audio Settings**: Persistent player preferences for SFX, Music, and UI sound levels.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In 100 game launches, the title menu appears before gameplay 100% of the time.
- **SC-002**: In usability testing, at least 95% of players can start a new run from the title menu within 10 seconds.
- **SC-003**: Given a known golden gem balance, the title menu and store display the correct balance in 100% of test cases.
- **SC-004**: Across at least 20 store purchase attempts, eligible purchases deduct the correct golden gem cost and insufficient-balance purchases are blocked 100% of the time.
- **SC-005**: Across repeated settings changes, SFX, Music, and UI sound levels retain their selected values after leaving and reopening Settings 100% of the time.
- **SC-006**: In desktop validation, choosing Exit closes the game cleanly within 3 seconds.

## Assumptions

- "Golden gems" are the same persistent milestone currency described for completing every 5 gameplay phases.
- Store content can initially use placeholder entries, but the page must behave like a gallery of browsable purchasable or unlockable content.
- Golden gems are persistent between runs and game sessions, while run state is reset when Start begins a new run.
- Audio levels are represented as player-adjustable ranges with sensible defaults.
- Store and Settings are accessed from the title menu and can return to it without starting a run.
- Exit is primarily intended for desktop builds, with platform-appropriate behavior on platforms where applications should not self-terminate.
