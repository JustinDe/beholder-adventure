# Test Scene Screenshot Guide

*Phase 1.3 Documentation*  
*Created: 2026-04-15*

---

## 🎮 Test Scene Created!

**Location:** `C:\Users\Justin\Documents\GodotProjects\beholder-adventure\scenes\main\TestScene.tscn`

**Status:** ✅ Complete and ready to run!

---

## 🖼️ How to Capture Screenshot

### Option 1: Manual Screenshot (Recommended)

1. **Open Godot Engine** (4.2+)
2. **Import the project** (if not already imported):
   - Click "Import"
   - Navigate to: `C:\Users\Justin\Documents\GodotProjects\beholder-adventure\`
   - Select `project.godot`
3. **Open TestScene.tscn**:
   - In FileSystem dock, navigate to `scenes/main/`
   - Double-click `TestScene.tscn`
4. **Run the scene**:
   - Press `F5` or click the "Play Scene" button (top-right)
   - Or right-click the scene → "Run"
5. **Launch the ball** (optional):
   - Press `SPACE` to launch the bouncing ball
   - Watch it bounce around the arena!
6. **Take screenshot**:
   - **Windows:** `Win + PrintScreen` (saves to Pictures/Screenshots)
   - **Or:** `PrintScreen` (copies to clipboard)
   - **Or:** `Win + Shift + S` (snipping tool)

### Option 2: Godot CLI (Advanced)

If Godot is in your PATH:

```bash
# Run headless and quit after 2 seconds
godot --headless --quit-after 120 --path "C:\Users\Justin\Documents\GodotProjects\beholder-adventure" res://scenes/main/TestScene.tscn

# Take screenshot manually while running
godot --path "C:\Users\Justin\Documents\GodotProjects\beholder-adventure" res://scenes/main/TestScene.tscn
```

**Note:** Godot's CLI screenshot functionality is limited. Manual screenshot is more reliable.

---

## 🎯 What You'll See

### Visual Elements:

| Element | Color | Position | Description |
|---------|-------|----------|-------------|
| **Game Board** | Blue-Grey | Center | 5 placeholder tiles |
| **Wall** | Brown | Top | Boundary marker |
| **Ball** | Red | (960, 540) | Starting position |
| **Trajectory Line** | Yellow | From ball | Aim preview |
| **UI Text** | White | Top-left | Instructions |

### Controls:

- **SPACE** - Launch the ball
- **R** - Reset ball to starting position
- **ESC** - Close/stop scene

---

## 📸 Screenshot Checklist

For documentation purposes, capture:

- [ ] **Initial state** (ball at rest, red)
- [ ] **Mid-flight** (ball in motion, green)
- [ ] **Bounce moment** (ball yellow flash on wall hit)
- [ ] **Full arena view** (showing bounds and UI)

---

## 🔧 Troubleshooting

### "No main scene configured"
- ✅ Fixed! Main scene is now set to TestScene.tscn

### "Godot not found"
- Download Godot 4.2+ from: https://godotengine.org/download
- Extract to: `C:\Program Files\Godot\`
- Add to PATH or use full path to executable

### "Scene won't run"
- Check Godot version (needs 4.2+)
- Verify project was imported correctly
- Check Output dock for errors

---

## 🎨 Placeholder Art Policy

**REMEMBER:** All graphics in this test scene are **PLACEHOLDERS ONLY**

- ❌ Blue rectangles ≠ final tile art
- ❌ Red circle ≠ final ball sprite
- ❌ Yellow line ≠ final trajectory VFX

**Final art will be created by humans** per the development plan!

---

## 📁 File Locations

```
beholder-adventure/
├── scenes/
│   └── main/
│       ├── TestScene.tscn      ← Scene file
│       └── TestScene.gd        ← Script file
├── project.godot               ← Main scene configured ✅
└── docs/
    └── test-scene-screenshot-guide.md  ← This file
```

---

## ✅ Phase 1.3 Status

**AI Tasks:**
- [x] Create basic test scene with placeholder graphics
- [x] Set up simple game board (colored rectangles for tiles)
- [x] Add placeholder ball sprite (colored circle)
- [x] Configure as main scene for testing
- [x] Document manual screenshot process
- [ ] ⏳ Screenshot pending (requires manual capture)

**Human Tasks:**
- [ ] ⏳ Review test scene output
- [ ] ⏳ Provide feedback on visual direction
- [ ] ⏳ Capture and add screenshot to documentation

---

*Ready for screenshot capture! Open Godot and run the scene!* 🍜🎮
