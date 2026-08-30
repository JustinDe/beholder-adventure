# Quickstart: Playable Bounce Combat Prototype

## Run Validation

From the repository root:

```powershell
& 'C:\Users\Justin\Documents\GDOT\Godot_v4.6.2-stable_win64_console.exe' --path 'D:\iCloud\iCloudDrive\beholder-adventure' --quit-after 120
```

Expected result: Godot starts in normal windowed mode, loads `res://scenes/main/Main.tscn`, and exits without project errors.

Current local note: as of 2026-06-14, `--headless` crashes before project startup even when no project path is supplied. Treat that as a local Godot runtime issue rather than a project validation failure.

## Manual Acceptance Checks

1. Open the project in Godot and run the main scene.
2. Move the mouse over the board and confirm a dotted trajectory appears from the right-side launcher.
3. Use mouse wheel up/down and confirm the launcher moves one row per wheel step.
4. Left click/release to fire and confirm the ball follows the preview direction and bounces off walls.
5. Hit an enemy and confirm health/score/combo feedback.
6. Hit an SP node and confirm SP increases in the HUD.
7. Fire again after collecting SP and confirm multiple balls launch on the same trajectory with spacing.
8. Cast Eye Cure and confirm MP decreases, HP increases, and cooldown appears.
9. Cast an unavailable spell for stage 1 and confirm the button is disabled.
10. Let a bounced ball return to the launcher row and confirm it is removed from the field.

## Docs To Review

- `game-design-document.md`
- `godot-development-plan.md`
- `.specify/memory/constitution.md`
