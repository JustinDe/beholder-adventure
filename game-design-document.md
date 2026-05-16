# Beholder Adventure - Game Design Document

*Inspired by "Kupo Kupo Adventure"*  
*Created: 2026-04-13*  
*Status:  In Development*

---

## 🎯 Game Overview

**Elevator Pitch:** A tactical puzzle-action game where players use a bouncing ball to defeat enemies on a grid-based battlefield. Master angles, chain combos, and clear the field with precision shots!

**Core Fantasy:** You're a battlefield tactician who defeats enemies not with direct combat, but by launching magical bouncing projectiles that ricochet with physics-based precision.

---

## 🎮 Core Mechanics

### Primary Gameplay Loop
1. **Assess** the battlefield layout
2. **Aim** your trajectory carefully
3. **Launch** the bouncing ball
4. **Watch** it ricochet and defeat enemies
5. **Chain** combos for maximum efficiency
6. **Clear** the field to advance

### The Bouncing Ball
- Travels in straight lines until hitting obstacles
- **Bounces off walls** at equal angles (like billiards)
- **Damages enemies** on contact
- Can hit **multiple enemies** in one shot
- **Combo multiplier** for consecutive hits

### Grid System
- **Tile-based battlefield** (appears to be ~8x6 visible grid)
- Enemies occupy specific tiles
- Walls/obstacles create bounce opportunities
- Open spaces allow for complex trajectories

---

## 🕹️ Controls & Input

### Aiming Phase
- **Aim:** Control stick / Mouse drag to set trajectory
- **Adjust:** Fine-tune angle before launch
- **Preview:** Trajectory line shows initial path

### Launch Phase
- **Fire:** Button press / Click to launch ball
- **Power:** Possibly variable (needs testing)

### Camera/View
- **Pan:** Move around larger battlefields
- **Zoom:** Adjust view for precision

---

## 👾 Enemies & Obstacles

### Enemy Types (from reference)
Based on visual analysis:

| Enemy | Appearance | Behavior | Notes |
|-------|-----------|----------|-------|
| **Slime** | Blue blob | Stationary | Basic enemy, single hit |
| **Spiky Creature** | Purple with spikes | Possibly mobile? | May require specific angle |
| **Armored Enemy** | Brown/dark | Tanky? | May need multiple hits |
| **Flying Enemy** | Orange/yellow | Mobile? | Harder to hit |

### Obstacles
- **Walls:** Solid boundaries for bouncing
- **Barriers:** May block or redirect
- **Environmental:** Rocks, trees (decorative vs functional)

---

## 📊 UI/HUD Elements

### Action Cards System
Located bottom-left, appears to show:
- **Card icons** (different abilities/powerups?)
- **Numbers:** 30, 40, 10, 30, 50 (cost? damage? BP cost?)
- **Selection:** Active card highlighted

### Status Bars
- **HP (Health Points):** 100/100 - Player health
- **MP (Magic Points):** 100/100 - Resource for abilities
- **BP (Battle Points?):** 1 - Action currency per turn

### Top Bar
- **Counter:** "31" (turns? score? enemies remaining?)
- **X Button:** Exit/cancel function

### Japanese Control Text (Bottom)
Translates roughly to:
- Left stick: Move/adjust aim
- Right stick: Angle adjustment  
- Left click: Launch ball

---

## 🎯 Scoring & Progression

### Scoring System
- **Base points** per enemy defeated
- **Combo multiplier** for multi-enemy hits
- **Efficiency bonus** for fewer shots
- **Style points** for trick shots/bounces

### Progression Ideas
- **Levels:** Increasingly complex layouts
- **Enemy variety:** New types with special behaviors
- **Upgrades:** Ball improvements, new abilities
- **Challenges:** Specific objectives per level

---

## 🔮 Power-Ups & Abilities

### Potential Action Cards
*(Based on UI card system)*

1. **Multi-Ball:** Launch multiple balls at once
2. **Explosive:** Ball explodes on impact
3. **Piercing:** Passes through first enemy
4. **Homing:** Slight tracking adjustment
5. **Time Slow:** Slow motion for precision

### Resource Management
- **BP System:** Limited actions per turn
- **MP Abilities:** Special shots cost magic
- **Card Cooldowns:** Limited use abilities

---

## 🎨 Visual Style

### Art Direction
- **Top-down isometric** or **top-down orthographic**
- **Grid-overlay** for tactical clarity
- **Vibrant colors** for enemy differentiation
- **Clear trajectory lines** (dotted/dashed preview)

### Effects
- **Impact sparks** on enemy hit
- **Bounce dust** on wall contact
- **Chain reaction glow** for combos
- **Number popups** for damage/score

---

## 🎵 Audio Design

### Sound Effects
- **Launch:** "Whoosh" or magical charge
- **Bounce:** Satisfying "pong" on walls
- **Hit:** Enemy defeat sounds (varied by type)
- **Combo:** Building musical stinger for chains

### Music
- **Tactical/ambient** during aiming
- **Dynamic** intensifying during ball flight
- **Victory fanfare** on level clear

---

## 📱 Platform Considerations

### Primary Target
- **PC** (mouse precision aiming)
- **Console** (controller support)
- **Mobile** (touch drag aiming)

### Control Schemes
Each platform needs optimized input:
- **Mouse:** Drag to aim, click to fire
- **Controller:** Stick aim, trigger fire
- **Touch:** Drag trajectory, release to fire

---

## 🚀 Development Phases

### Phase 1: Core Prototype
- [ ] Basic grid system
- [ ] Ball physics (bounce mechanics)
- [ ] Simple enemy placement
- [ ] Win/loss conditions

### Phase 2: Gameplay Loop
- [ ] Enemy variety (3-4 types)
- [ ] Action card system
- [ ] Resource management (BP/MP)
- [ ] 5-10 test levels

### Phase 3: Polish
- [ ] Visual effects
- [ ] Sound design
- [ ] UI refinement
- [ ] Tutorial system

### Phase 4: Content
- [ ] 20+ levels
- [ ] Enemy balance
- [ ] Power-up balance
- [ ] Progression systems

---

## 🤔 Open Questions

1. **Ball Behavior:**
   - Does it disappear after hitting an enemy?
   - Can it hit the same enemy twice?
   - Maximum bounce count?

2. **Enemy Behavior:**
   - Do enemies move during player turn?
   - Do they have attack patterns?
   - Turn-based or real-time?

3. **Damage System:**
   - One-hit kill or HP-based?
   - Does bounce angle affect damage?
   - Critical hit zones?

4. **Level Design:**
   - Static or destructible environment?
   - Moving obstacles?
   - Multiple ball launch points?

---

## 📝 Notes & Ideas

### Unique Mechanics to Explore
- **Elemental balls** (fire, ice, lightning)
- **Reflective surfaces** (increase bounce damage)
- **Combo zones** (hit for multiplier)
- **Environmental traps** (bounce into spikes)

### Inspiration Sources
- **Kupo Kupo Adventure** (primary)
- **Pinball** (bounce physics)
- **Billiards/Pool** (angle precision)
- **Peggle** (satisfying bounces)
- **Final Fantasy Tactics** (grid combat)

---

## 🎯 Success Criteria

A successful prototype should have:
- ✅ Satisfying ball physics
- ✅ Clear visual feedback
- ✅ Meaningful tactical choices
- ✅ "One more turn" addictiveness
- ✅ Accessible but deep mastery curve

---

*Stay curious. Stay dangerous. Hack the planet.* 🍜

*Document version: 1.0*  
*Last updated: 2026-04-13*
