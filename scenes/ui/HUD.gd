extends CanvasLayer
class_name HUD

@onready var score_label: Label = $TopBar/ScoreLabel
@onready var hp_label: Label = $TopBar/HPLabel
@onready var mp_label: Label = $TopBar/MPLabel
@onready var bp_label: Label = $TopBar/BPLabel
@onready var combo_label: Label = $TopBar/ComboLabel
@onready var message_label: Label = $MessageLabel


func _ready() -> void:
	GameState.score_changed.connect(_on_score_changed)
	GameState.combo_changed.connect(_on_combo_changed)
	_refresh()


func _process(_delta: float) -> void:
	_refresh()


func show_message(text: String) -> void:
	message_label.text = text
	message_label.modulate.a = 1.0
	var tween := create_tween()
	tween.tween_interval(1.2)
	tween.tween_property(message_label, "modulate:a", 0.0, 0.35)


func _refresh() -> void:
	score_label.text = "Score %d" % GameState.current_score
	hp_label.text = "HP %d" % GameState.player_hp
	mp_label.text = "MP %d" % GameState.player_mp
	bp_label.text = "BP %d" % GameState.battle_points
	combo_label.text = "Combo x%d" % GameState.current_combo


func _on_score_changed(_new_score: int) -> void:
	_refresh()


func _on_combo_changed(_new_combo: int) -> void:
	_refresh()
