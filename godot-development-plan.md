# Beholder Adventure - Godot Development Plan

*Platform: PC & Mobile (iOS/Android)*  
*Engine: Godot 4.x*  
*Language: GDScript (native)*  
*Art Policy: Human-created ONLY*  
*Created: 2026-04-13*  
*Last implementation update: 2026-06-14*

---

## ✅ Current Implementation Status

The project now boots into a playable Godot prototype scene instead of the original test scene.

### Implemented So Far
- [x] Main gameplay container: `scenes/main/Main.tscn` and `scenes/main/Main.gd`
- [x] Grid-based board scene: `scenes/gameplay/GameBoard.tscn`
- [x] JSON-backed level loading: `resources/level_data/level_001.json`
- [x] Player launcher placed to the right of the grid
- [x] Mouse wheel launcher movement: wheel up moves one row up, wheel down moves one row down
- [x] Ball launch origin wired to the player launcher row
- [x] Ball projectile scene and script: `scenes/gameplay/Ball.tscn`, `scripts/gameplay/Ball.gd`
- [x] Wall bounce physics and reflection prediction: `scripts/gameplay/BallPhysics.gd`
- [x] Dotted trajectory preview from player launcher to mouse position
- [x] Trajectory preview reflects off board walls and extends board width plus 4 square widths
- [x] Enemy base scene and script: `scenes/gameplay/Enemy.tscn`, `scripts/gameplay/Enemy.gd`
- [x] Initial enemy type data: `scripts/gameplay/EnemyTypes.gd`
- [x] Enemy health, damage, defeat, and score values
- [x] Combo and score tracking: `scripts/gameplay/ComboSystem.gd`
- [x] Removed bottom-left action toggles from the runtime prototype
- [x] Added SP resource: collectible board nodes increase future shot count
- [x] Added MP spell panel in the bottom-left UI with costs, cooldowns, and stage restrictions
- [x] HUD scene for score, HP, MP, combo, and status messages: `scenes/ui/HUD.tscn`
- [x] Touch feedback helper script: `scripts/ui/TouchControls.gd`
- [x] Godot normal windowed validation using `C:\Users\Justin\Documents\GDOT\Godot_v4.6.2-stable_win64_console.exe`
- [x] Project renderer set to GL Compatibility for stable local startup and mobile-oriented rendering

### Current Control Model
| Action | Current PC Prototype |
|--------|----------------------|
| Aim | Move mouse; dotted trajectory updates during player turn |
| Fire Ball | Left click/release using current mouse direction |
| Move Launcher Up | Mouse wheel up |
| Move Launcher Down | Mouse wheel down |
| Cancel | Right click / Escape |
| Pause | Escape |

### Current Resource Model
- **SP:** Shot Points. Starts at 1, increases when a ball collects an SP node, and determines how many balls launch on the next shot.
- **MP:** Spell resource consumed by Eye spells. Buttons are disabled when MP is insufficient, the spell is on cooldown, or the stage restriction is not met.

### Current Spell Roster
| Spell | MP | Recast | Availability | Prototype Effect |
|-------|----|--------|--------------|------------------|
| Eye Fire | 30 | 3 turns | Stage 1+ | Deals 20 damage to the nearest enemy in front of the player row. |
| Eye Starstorm | 40 | 4 turns | Stage 1+ | Deals 10 damage to enemies in a 3x3 area centered 8 squares in front of the player. |
| Eye Meteor | 80 | 10 turns | Stage 3 only | Deals 15 damage to all enemies. |
| Eye Cure | 10 | 1 turn | Stage 1+ | Restores 50 HP. |
| Eye Esuna | 20 | 3 turns | Stages 2-3 | Clears detrimental effects except Doom. |
| Eye Levitation | 20 | 3 turns | Stages 2-3 | Grants 1 turn of floor-effect immunity. |
| Eye Ward | 30 | 3 turns | Stage 1+ | Grants 1 turn of damage reduction barrier. |
| Eye Reraise | 50 | 99 turns | Stage 1+ | Grants automatic revival on KO while active. |

### Known Prototype Limitations
- [ ] Player, enemies, tiles, and UI still use placeholder geometry/widgets.
- [ ] Trajectory preview currently predicts board-wall bounces, not obstacle bounces.
- [ ] Obstacle collision is implemented as simple runtime rectangle reflection and should be unified with prediction.
- [ ] Level clear/progression exists, but no level select or next-level flow exists yet.
- [ ] No human-created art/audio assets have been integrated.
- [ ] No visual QA screenshot pass has been completed in the editor/browser.
- [ ] Local Godot `--headless` mode crashes before project startup even without a project path; use windowed validation until the local engine runtime is replaced or repaired.

---

## 🎯 Development Philosophy

- [x] Project structure defined
- [ ] Asset pipeline defined
- [ ] Documentation outline


**Core Principle:** AI handles code, logic, and systems. HUMANS create all visual/audio assets. No exceptions.

**Why:** Art is soul. It's identity. It's the difference between a game that feels alive and a game that feels assembled. This plan respects that boundary completely.

---

## 📁 Project Structure

- [x] Godot project initialized
- [x] Autoloads (GameState, InputHandler, AudioManager) set
- [x] Input system implemented
- [x] Test scene created
- [x] Main gameplay scene created
- [x] Gameplay, UI, and resource folders populated with prototype systems
- [ ] Export presets for PC/Android/iOS
- [ ] Project icon created
- [ ] Font and color palette selected


```
beholder-adventure/
├── project.godot                 # Godot project file
├── icon.svg                      # App icon (HUMAN CREATED)
│
├── scenes/
│   ├── main/
│   │   ├── Main.tscn            # Main game container
│   │   └── Main.gd
│   │
│   ├── gameplay/
│   │   ├── GameBoard.tscn       # Grid battlefield
│   │   ├── GameBoard.gd
│   │   ├── Ball.tscn            # Bouncing ball projectile
│   │   ├── Ball.gd
│   │   ├── Enemy.tscn           # Enemy base scene
│   │   ├── Enemy.gd
│   │   └── TrajectoryPreview.gd # Dotted launcher aim preview
│   │
│   ├── ui/
│   │   ├── HUD.tscn             # Health, MP, score, combo, status
│   │   ├── SpellPanel.tscn      # Bottom-left MP spell panel
│   │   └── MainMenu.tscn        # Title screen
│   │
│   └── levels/
│       ├── Level_001.tscn       # Individual level layouts
│       ├── Level_002.tscn
│       └── ...
│
├── scripts/
│   ├── core/
│   │   ├── GameState.gd         # Global game state manager
│   │   ├── InputHandler.gd      # Cross-platform input
│   │   └── AudioManager.gd      # Sound management
│   │
│   ├── gameplay/
│   │   ├── SpellBook.gd         # MP spell definitions
│   │   ├── BallPhysics.gd       # Bounce/trajectory logic
│   │   ├── EnemyTypes.gd        # Enemy behavior classes
│   │   ├── ComboSystem.gd       # Multiplier tracking
│   │   └── LevelManager.gd      # Level loading/progression
│   │
│   └── ui/
│       ├── SpellPanel.gd        # Spell button UI logic
│       └── TouchControls.gd     # Mobile input handling
│
├── assets/                       # ⚠️ HUMAN CREATED ONLY
│   ├── sprites/
│   │   ├── enemies/             # All enemy sprites
│   │   ├── ball/                # Ball variations
│   │   ├── environment/         # Tiles, walls, obstacles
│   │   └── ui/                  # Icons, buttons, HUD assets
│   │
│   ├── audio/
│   │   ├── sfx/                 # Sound effects
│   │   └── music/               # Background tracks
│   │
│   └── fonts/                   # Custom fonts
│
├── resources/
│   ├── enemy_data/              # Enemy stat definitions
│   ├── level_data/              # Level JSON configs, including level_001.json
│   └── settings/                # Game settings presets
│
└── exports/                     # Build configurations
    ├── pc/
    ├── android/
    └── ios/
```

---

## 🖥️ Phase 1: Project Setup (Week 1)

### 1.1 Godot Project Initialization
**AI Responsibilities:**
- [x] Create `project.godot` with proper settings
- [x] Configure input maps for PC + Mobile
- [x] Set up project-wide autoloads (GameState, AudioManager)
- [ ] Configure export presets for PC, Android, iOS

**Human Responsibilities:**
- [ ] Create project icon (1024x1024 PNG)
- [ ] Choose/select base font for UI
- [ ] Provide color palette reference

### 1.2 Input System Setup
**AI Responsibilities:**
- [x] Create `InputHandler.gd` singleton
- [x] Map keyboard/mouse controls (PC)
- [x] Map touch controls (Mobile)
- [x] Implement input abstraction layer
- [x] Add mouse wheel launcher movement for PC prototype

**Controls Mapping:**
| Action | PC | Mobile |
|--------|-----|--------|
| Aim | Mouse position / mouse drag | Touch drag |
| Move Launcher | Mouse wheel up/down | TBD |
| Adjust Angle | Right click drag | Two-finger rotate |
| Fire Ball | Left click / Space | Release touch |
| Cancel | Right click / Escape | Tap UI cancel button |
| Pause | Escape | Pause button |

**Human Responsibilities:**
- [ ] Test and provide feedback on control feel
- [ ] Approve final control scheme

### 1.3: Test Scene & Documentation Screenshot
**AI Responsibilities**:
- [x] Create basic test scene with placeholder graphics
- [x] Set up simple game board (colored rectangles for tiles)
- [x] Add placeholder ball sprite (colored circle)
- [x] Configure playable prototype as main scene for testing
- [ ] Attempt headless render/screenshot OR document manual process
- [ ] Add screenshot to documentation

**Human Responsibilities**:
- [ ] Review test scene output
- [ ] Provide feedback on visual direction

---

## 🎮 Phase 2: Core Gameplay Prototype (Weeks 2-3)

### 2.1 Game Board System
**AI Responsibilities:**
- [x] Create grid-based board (Configurable: 8x6, 10x8, etc.)
- [x] Implement tile system with collision detection
- [x] Create wall/boundary logic
- [x] Build level data structure (JSON-based)
- [x] Add player launcher to the right side of the board
- [x] Add mouse wheel launcher row movement

**Human Responsibilities:**
- [ ] Create tile sprites (floor, wall, obstacle)
- [ ] Define grid size preferences
- [ ] Provide visual style reference

### 2.2 Ball Physics System
**AI Responsibilities:**
- [x] Create `Ball.gd` with physics behavior
- [x] Implement wall bouncing (angle reflection)
- [x] Add trajectory preview line (dotted line showing path)
- [x] Calculate bounce predictions (up to N bounces)
- [x] Handle collision detection with enemies
- [x] Launch ball from player character row

**Key Physics Considerations:**
```gdscript
# Ball behavior constants (tunable)
const BALL_SPEED: float = 400.0
const MAX_BOUNCES: int = 10
const GRAVITY: float = 0.0  # No gravity - straight lines
const BOUNCE_DAMPING: float = 1.0  # No energy loss (or tunable)
```

**Human Responsibilities:**
- [ ] Create ball sprite(s) - base design + variations
- [ ] Create trajectory line visual style
- [ ] Test and approve "feel" of ball physics

### 2.3 Enemy System Foundation
**AI Responsibilities:**
- [x] Create `Enemy.gd` base class
- [x] Implement health/damage system
- [x] Create enemy spawn system
- [x] Build enemy data resource system

**Enemy Types (Initial):**
1. **Basic Slime** - Stationary, 1 HP
2. **Armored Beetle** - Stationary, 3 HP
3. **Flying Wisp** - Moves slowly, 1 HP
4. **Spiky Urchin** - Damages ball on wrong angle, 2 HP

**Human Responsibilities:**
- [ ] Create ALL enemy sprites (idle, hit, death animations)
- [ ] Define enemy personalities/visual themes
- [ ] Approve enemy roster

---

## 🎯 Phase 3: Combat & Scoring (Weeks 4-5)

### 3.1 Damage & Combo System
**AI Responsibilities:**
- [x] Implement hit detection and damage calculation
- [x] Create combo multiplier system
- [x] Track consecutive hits per ball launch
- [x] Display combo counters UI
- [x] Calculate score with multipliers

**Scoring Formula:**
```gdscript
base_score = 100 * enemy_type_multiplier
combo_multiplier = 1.0 + (consecutive_hits * 0.25)
final_score = base_score * combo_multiplier
```

**Human Responsibilities:**
- [ ] Create combo visual effects (particles, numbers)
- [ ] Design score popup style
- [ ] Balance enemy point values

### 3.2 Resource Management
**AI Responsibilities:**
- [x] Remove the extra action-currency regeneration and UI from the current prototype
- [x] Create HP/MP UI labels
- [x] Implement MP spell costs, cooldowns, and unavailable states
- [x] Add stage-gated spell availability
- [ ] Balance MP costs, cooldowns, and spell effects

**Human Responsibilities:**
- [ ] Create UI bar graphics (HP, MP, SP)
- [ ] Design resource icons
- [ ] Approve regeneration rates

---

## 📱 Phase 4: Platform Optimization (Weeks 6-7)

### 4.1 Mobile Touch Controls
**AI Responsibilities:**
- [ ] Implement touch-based aiming system
- [ ] Create drag-to-aim gesture recognition
- [ ] Add visual touch feedback (finger indicators)
- [ ] Implement pinch-to-zoom (optional)
- [ ] Handle different screen aspect ratios
- [ ] Create safe area handling (notches, etc.)

**Mobile-Specific Considerations:**
```gdscript
# Touch input thresholds
const MIN_DRAG_DISTANCE: float = 50.0  # pixels
const AIM_SENSITIVITY: float = 1.0
const TOUCH_VISUAL_FEEDBACK: bool = true
```

**Human Responsibilities:**
- [ ] Create touch feedback visuals (ripple effects, etc.)
- [ ] Test on actual mobile devices
- [ ] Provide feedback on control responsiveness

### 4.2 UI Scaling & Responsive Design
**AI Responsibilities:**
- [ ] Implement anchor-based UI layout
- [ ] Create resolution-independent scaling
- [ ] Build DPI-aware text sizing
- [ ] Test UI on multiple resolutions

**Target Resolutions:**
- **PC:** 1920x1080, 2560x1440, 3840x2160
- **Mobile:** Various (720p to 1440p, various aspect ratios)

**Human Responsibilities:**
- [ ] Create UI assets at multiple scales (1x, 2x, 3x)
- [ ] Approve UI layouts on different screens

### 4.3 Performance Optimization
**AI Responsibilities:**
- [ ] Implement object pooling for balls/enemies
- [ ] Optimize draw calls (batching)
- [ ] Add LOD for complex scenes
- [ ] Profile and optimize mobile performance
- [ ] Implement texture atlasing recommendations

**Target Performance:**
- **PC:** 60 FPS minimum
- **Mobile:** 30 FPS minimum (60 preferred)

**Human Responsibilities:**
- [ ] Optimize art assets for performance (texture sizes)
- [ ] Provide sprite sheets instead of individual files

---

## 🎨 Phase 5: Visual Polish (Weeks 8-9)

### 5.1 Visual Effects
**AI Responsibilities:**
- [ ] Create particle systems for:
  - Ball launch trail
  - Wall bounce sparks
  - Enemy hit effects
  - Enemy death explosions
  - Combo buildup glow
- [ ] Implement screen shake (subtle, on big hits)
- [ ] Add hit flash effects
- [ ] Create trajectory line animations

**Human Responsibilities:**
- [ ] Create ALL particle textures
- [ ] Design VFX color palettes
- [ ] Approve effect intensity levels

### 5.2 Animation System
**AI Responsibilities:**
- [ ] Implement enemy idle animations
- [ ] Create enemy hit/death animations
- [ ] Add ball spin/rotation during flight
- [ ] Animate UI elements (buttons, transitions)
- [ ] Build animation state machines

**Human Responsibilities:**
- [ ] Create ALL animation frames/spritesheets
- [ ] Define animation timing and style
- [ ] Approve animation smoothness

### 5.3 Camera & Framing
**AI Responsibilities:**
- [ ] Implement smooth camera movement
- [ ] Add camera shake on impacts
- [ ] Create zoom levels for different board sizes
- [ ] Handle camera bounds/clamping

**Human Responsibilities:**
- [ ] Approve camera behavior
- [ ] Test on different screen sizes

---

## 🔊 Phase 6: Audio Implementation (Week 10)

### 6.1 Sound Effects
**AI Responsibilities:**
- [ ] Create audio bus structure
- [ ] Implement SFX triggering system
- [ ] Add volume/mute controls
- [ ] Handle audio pooling for rapid sounds

**Required SFX (Human Created):**
- Ball launch
- Ball bounce (wall)
- Ball bounce (enemy)
- Enemy hit
- Enemy death (per type)
- Combo buildup
- UI clicks
- Victory fanfare
- Defeat sound

**Human Responsibilities:**
- [ ] Create ALL sound effects
- [ ] Provide music tracks
- [ ] Approve audio mixing levels

### 6.2 Music System
**AI Responsibilities:**
- [ ] Implement music crossfading
- [ ] Create dynamic music states (menu, gameplay, victory)
- [ ] Add music volume control
- [ ] Handle music looping

**Human Responsibilities:**
- [ ] Compose/procure ALL music tracks
- [ ] Define music transition points
- [ ] Approve final mix

---

## 📊 Phase 7: Level Design & Content (Weeks 11-13)

### 7.1 Level Editor Tools
**AI Responsibilities:**
- [ ] Create custom Godot editor plugin for level design
- [ ] Build level data export system
- [ ] Implement level validation tools
- [ ] Create level preview system

**Human Responsibilities:**
- [ ] Design ALL levels manually
- [ ] Test level difficulty progression
- [ ] Create level themes/contexts

### 7.2 Level Progression
**AI Responsibilities:**
- [ ] Implement level unlock system
- [ ] Create star/rating system (1-3 stars per level)
- [ ] Build progression gates
- [ ] Track player statistics

**Initial Content Target:**
- **Tutorial:** 5 levels
- **World 1:** 15 levels
- **World 2:** 15 levels
- **World 3:** 15 levels
- **Bonus:** 10 levels
- **Total:** 60 levels

**Human Responsibilities:**
- [ ] Design every single level layout
- [ ] Place all enemies manually
- [ ] Define level objectives
- [ ] Create level intro/outro text

### 7.3 Difficulty Balancing
**AI Responsibilities:**
- [ ] Create difficulty tuning parameters
- [ ] Implement playtesting data collection
- [ ] Build analytics for failure points
- [ ] Create balance adjustment tools

**Human Responsibilities:**
- [ ] Playtest extensively
- [ ] Provide balance feedback
- [ ] Approve final difficulty curve

---

## 🚀 Phase 8: Polish & Release Prep (Weeks 14-16)

### 8.1 Settings & Options
**AI Responsibilities:**
- [ ] Create settings menu
- [ ] Implement graphics quality options
- [ ] Add control remapping (PC)
- [ ] Create audio settings
- [ ] Add language/localization support (if needed)

**Human Responsibilities:**
- [ ] Create settings UI graphics
- [ ] Approve default settings values

### 8.2 Save System
**AI Responsibilities:**
- [ ] Implement save/load functionality
- [ ] Create save file management
- [ ] Add cloud save support (platform-specific)
- [ ] Handle save corruption recovery

**Human Responsibilities:**
- [ ] Approve save data structure
- [ ] Test save/load reliability

### 8.3 Platform-Specific Requirements
**AI Responsibilities:**

**PC (Steam/Epic):**
- [ ] Achievements integration
- [ ] Leaderboards
- [ ] Cloud saves
- [ ] Overlay compatibility

**Mobile (iOS/Android):**
- [ ] App store compliance
- [ ] Age rating setup
- [ ] In-app purchase framework (if applicable)
- [ ] Ad integration (if applicable)
- [ ] Push notifications (optional)

**Human Responsibilities:**
- [ ] Create store page assets (screenshots, trailers, descriptions)
- [ ] Handle app store submissions
- [ ] Manage platform relationships

### 8.4 Bug Fixes & QA
**AI Responsibilities:**
- [ ] Create bug tracking system
- [ ] Implement crash reporting
- [ ] Build automated test scenarios
- [ ] Fix reported bugs

**Human Responsibilities:**
- [ ] Extensive playtesting
- [ ] Report bugs
- [ ] Approve release candidate

---

## 🛠️ Technical Specifications

### Godot Version
- **Target:** Godot 4.2+ (stable)
- **Renderer:** GL Compatibility (for stable local startup and mobile support)
- **Physics:** Built-in 2D physics

### GDScript Standards
```gdscript
# Naming conventions
class_name EnemyType  # Classes
var enemy_health: int  # Variables (snake_case)
func _ready():  # Functions (snake_case)
const MAX_SPEED = 100  # Constants (UPPER_CASE)

# Type safety
var player_hp: int = 100
var ball_velocity: Vector2 = Vector2.ZERO
var is_mobile: bool = false

# Signals for decoupling
signal enemy_defeated(enemy_type: String, combo_count: int)
signal ball_launched(ball_id: int)
```

### Mobile-Specific Considerations
```gdscript
# Display management
DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

# Touch input
if Input.is_action_pressed("touch_aim"):
    var touch_pos = get_viewport().get_touch_position(0)

# Performance hints
RenderingServer.canvas_set_cull_mode(get_canvas_item(), RenderingServer.CANVAS_CULL_MODE_DISABLED)
```

### Export Settings

**PC (Windows):**
- Format: Windows Desktop
- Architecture: x86_64
- Features: Full

**Android:**
- Format: Android
- Architecture: arm64
- Min SDK: 24 (Android 7.0)
- Target SDK: Latest

**iOS:**
- Format: iOS
- Architecture: arm64
- Min Version: iOS 13.0

---

## ⚠️ AI/Human Boundary - ENFORCED

### ✅ AI CAN Do:
- Write all GDScript code
- Create scene structures (.tscn files)
- Implement game logic and systems
- Build UI layouts and functionality
- Create data structures (JSON, resources)
- Set up project configuration
- Implement audio systems (not create audio)
- Build tools and editors
- Optimize performance
- Fix bugs

### ❌ AI CANNOT Do:
- Create any visual art (sprites, textures, UI graphics)
- Create any audio (SFX, music)
- Design level layouts (can implement, not design)
- Make creative decisions on art style
- Choose color palettes
- Design character/enemy appearances
- Create icons or logos
- Write narrative/story content (without human direction)

### 🤝 Collaboration Model:
```
Human: Creates asset → Places in assets/ folder
AI: References asset in code → Implements functionality
Human: Tests and provides feedback
AI: Adjusts implementation based on feedback
```

---

## 📅 Timeline Summary

| Phase | Duration | Focus |
|-------|----------|-------|
| 1 | Week 1 | Project setup, input system |
| 2 | Weeks 2-3 | Core gameplay prototype |
| 3 | Weeks 4-5 | Combat and scoring |
| 4 | Weeks 6-7 | Mobile optimization |
| 5 | Weeks 8-9 | Visual polish, VFX |
| 6 | Week 10 | Audio implementation |
| 7 | Weeks 11-13 | Level design & content |
| 8 | Weeks 14-16 | Polish, QA, release prep |

**Total Estimated Time:** 16 weeks (4 months)

**Human Time Commitment:**
- Art creation: ~40-60 hours (spread across timeline)
- Level design: ~20-30 hours
- Playtesting: ~15-20 hours
- Review/approvals: ~10-15 hours

**AI Time Commitment:**
- Code implementation: Full development
- System integration: Full development
- Bug fixes: Ongoing

---

## 🎯 Success Metrics

### Technical Success:
- [ ] 60 FPS on mid-range PC
- [ ] 30+ FPS on mid-range mobile
- [ ] No crashes in 100+ hours playtesting
- [ ] Save/load works 100% reliably

### Gameplay Success:
- [ ] Tutorial completion rate > 80%
- [ ] Average session length > 10 minutes
- [ ] Players complete World 1 > 50%
- [ ] Positive feedback on "feel" and controls

### Art Success:
- [ ] All assets human-created ✅
- [ ] Consistent visual style
- [ ] Clear visual readability
- [ ] Mobile-friendly UI clarity

---

## 📝 Next Steps

1. **Immediate:** Unify obstacle collision prediction with runtime obstacle bounce behavior.
2. **Immediate:** Add a visible player turn state and clearer fire interaction.
3. **Immediate:** Human creates initial art style guide and first sprite batch.
4. **Next:** Replace placeholder player, ball, enemy, tile, and HUD visuals with human-created assets.
5. **Next:** Add screenshot/visual QA documentation for the playable prototype.
6. **Ongoing:** Weekly art deliveries + code iterations.

---

*This plan respects the sacred boundary: Code is mine. Art is yours. Together we make magic.* 🍜🎮

*Last updated: 2026-06-14*  
*Version: 1.3*
