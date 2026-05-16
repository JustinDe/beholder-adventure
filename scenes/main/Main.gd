extends Node2D

@onready var game_board: Node = $GameBoard
@onready var hud: CanvasLayer = $HUD
@onready var card_selector: Control = $HUD/CardSelector


func _ready() -> void:
	GameState.new_game()
	card_selector.card_selected.connect(game_board.set_active_card)
	game_board.status_changed.connect(hud.show_message)
	game_board.level_cleared.connect(_on_level_cleared)
	InputHandler.pause_toggled.connect(_toggle_pause)


func _on_level_cleared(_level_id: String) -> void:
	hud.show_message("Level cleared")


func _toggle_pause() -> void:
	get_tree().paused = not get_tree().paused
	hud.show_message("Paused" if get_tree().paused else "Resumed")
