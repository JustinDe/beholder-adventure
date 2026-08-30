extends Node2D

@onready var game_board: Node = $GameBoard
@onready var hud: CanvasLayer = $HUD


func _ready() -> void:
	GameState.new_game()
	hud.set_stage(game_board.get_current_stage())
	hud.spell_requested.connect(game_board.cast_spell)
	game_board.status_changed.connect(hud.show_message)
	game_board.level_cleared.connect(_on_level_cleared)
	InputHandler.pause_toggled.connect(_toggle_pause)


func _on_level_cleared(_level_id: String) -> void:
	hud.show_message("Level cleared")


func _toggle_pause() -> void:
	get_tree().paused = not get_tree().paused
	hud.show_message("Paused" if get_tree().paused else "Resumed")
