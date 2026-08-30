extends Node2D

const GameBoardScene := preload("res://scenes/gameplay/GameBoard.tscn")
const HUDScene := preload("res://scenes/ui/HUD.tscn")
const TouchControlsScript := preload("res://scripts/ui/TouchControls.gd")

@onready var game_container: Node2D = $GameContainer
@onready var menu: CanvasLayer = $TitleMenu

var game_board: Node = null
var hud: CanvasLayer = null
var touch_controls: Control = null


func _ready() -> void:
	menu.start_requested.connect(_start_run)
	GameState.game_over.connect(_on_game_over)
	InputHandler.pause_toggled.connect(_toggle_pause)


func _start_run() -> void:
	_clear_run()
	GameState.start_new_run()
	menu.hide()
	game_board = GameBoardScene.instantiate()
	hud = HUDScene.instantiate()
	touch_controls = Control.new()
	touch_controls.name = "TouchControls"
	touch_controls.set_anchors_preset(Control.PRESET_FULL_RECT)
	touch_controls.grow_horizontal = Control.GROW_DIRECTION_BOTH
	touch_controls.grow_vertical = Control.GROW_DIRECTION_BOTH
	touch_controls.set_script(TouchControlsScript)
	game_container.add_child(game_board)
	game_container.add_child(hud)
	game_container.add_child(touch_controls)
	hud.set_stage(game_board.get_current_stage())
	hud.spell_requested.connect(game_board.cast_spell)
	game_board.status_changed.connect(hud.show_message)
	game_board.level_cleared.connect(_on_level_cleared)
	game_board.phase_started.connect(hud.set_stage)


func _on_level_cleared(_level_id: String) -> void:
	if hud:
		hud.show_message("Level cleared")


func _on_game_over() -> void:
	GameState.save_game()
	_clear_run()
	menu.show_title()


func _toggle_pause() -> void:
	if game_board == null:
		return
	get_tree().paused = not get_tree().paused
	if hud:
		hud.show_message("Paused" if get_tree().paused else "Resumed")


func _clear_run() -> void:
	get_tree().paused = false
	InputHandler.reset_input_state()
	for child in game_container.get_children():
		child.queue_free()
	game_board = null
	hud = null
	touch_controls = null
