# Beholder Adventure - Screenshot Capture Script
# Phase 1.3 Documentation
# Run this script to open Godot and prepare for screenshot capture

param(
    [string]$GodotPath = "",
    [switch]$Headless
)

$projectPath = "C:\Users\Justin\Documents\GodotProjects\beholder-adventure"
$scenePath = "res://scenes/main/TestScene.tscn"
$screenshotPath = "C:\Users\Justin\Documents\GodotProjects\beholder-adventure\screenshots"

# Create screenshots directory
if (!(Test-Path $screenshotPath)) {
    New-Item -ItemType Directory -Path $screenshotPath -Force | Out-Null
    Write-Host "📁 Created screenshots folder: $screenshotPath" -ForegroundColor Green
}

# Find Godot if path not specified
if ([string]::IsNullOrEmpty($GodotPath)) {
    Write-Host "🔍 Searching for Godot..." -ForegroundColor Cyan
    
    # Common locations
    $possiblePaths = @(
        "C:\Program Files\Godot*\Godot_v*.exe",
        "C:\Users\$env:USERNAME\AppData\Local\Programs\Godot*\Godot_v*.exe",
        "C:\Users\$env:USERNAME\source\Godot*\Godot_v*.exe",
        "$env:USERPROFILE\godot*\Godot_v*.exe"
    )
    
    foreach ($pattern in $possiblePaths) {
        $found = Get-ChildItem -Path $pattern -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($found) {
            $GodotPath = $found.FullName
            Write-Host "✅ Found Godot: $GodotPath" -ForegroundColor Green
            break
        }
    }
    
    if ([string]::IsNullOrEmpty($GodotPath)) {
        Write-Host "❌ Godot not found! Please install Godot 4.2+ from:" -ForegroundColor Red
        Write-Host "   https://godotengine.org/download" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Or specify the path manually:" -ForegroundColor Yellow
        Write-Host "   .\capture-screenshot.ps1 -GodotPath 'C:\path\to\Godot_v4.x.exe'" -ForegroundColor Cyan
        exit 1
    }
}

Write-Host ""
Write-Host "🎮 Beholder Adventure - Test Scene" -ForegroundColor Magenta
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host ""

if ($Headless) {
    Write-Host "🖥️  Running in headless mode (no screenshot capability)..." -ForegroundColor Yellow
    Write-Host ""
    
    $args = @(
        "--headless"
        "--quit-after 120"
        "--path `"$projectPath`""
        "--scene `"$scenePath`""
    )
    
    Write-Host "Command: $GodotPath $($args -join ' ')" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Note: Headless mode doesn't support screenshots." -ForegroundColor Yellow
    Write-Host "      Use manual capture instead (Win+PrintScreen)" -ForegroundColor Yellow
} else {
    Write-Host "📸 MANUAL SCREENSHOT MODE" -ForegroundColor Green
    Write-Host ""
    Write-Host "Instructions:" -ForegroundColor Cyan
    Write-Host "  1. Godot will open with the test scene" -ForegroundColor White
    Write-Host "  2. Press F5 or click Play to run the scene" -ForegroundColor White
    Write-Host "  3. Press SPACE to launch the ball" -ForegroundColor White
    Write-Host "  4. Press Win+PrintScreen to capture" -ForegroundColor White
    Write-Host "  5. Save to: $screenshotPath" -ForegroundColor White
    Write-Host ""
    Write-Host "Starting Godot..." -ForegroundColor Green
    Write-Host ""
    
    # Launch Godot with project
    Start-Process -FilePath $GodotPath -ArgumentList "--path `"$projectPath`""
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host ""
Write-Host "📝 Screenshot Checklist:" -ForegroundColor Magenta
Write-Host "  ☐ Initial state (ball at rest, red)" -ForegroundColor White
Write-Host "  ☐ Mid-flight (ball in motion, green)" -ForegroundColor White
Write-Host "  ☐ Bounce moment (ball yellow flash)" -ForegroundColor White
Write-Host "  ☐ Full arena view (showing bounds + UI)" -ForegroundColor White
Write-Host ""
Write-Host "Save screenshots to: $screenshotPath" -ForegroundColor Cyan
Write-Host ""
