extends CanvasLayer
class_name HUD

signal spell_requested(spell_id: String)

@onready var score_label: Label = $TopBar/ScoreLabel
@onready var hp_label: Label = $TopBar/HPLabel
@onready var mp_label: Label = $TopBar/MPLabel
@onready var sp_label: Label = $TopBar/SPLabel
@onready var phase_label: Label = $TopBar/PhaseLabel
@onready var turn_label: Label = $TopBar/TurnLabel
@onready var combo_label: Label = $TopBar/ComboLabel
@onready var message_label: Label = $MessageLabel
@onready var spell_panel: Control = $SpellPanel


func _ready() -> void:
	GameState.score_changed.connect(_on_score_changed)
	GameState.combo_changed.connect(_on_combo_changed)
	GameState.sp_changed.connect(_on_sp_changed)
	GameState.hp_changed.connect(_on_hp_changed)
	GameState.mp_changed.connect(_on_mp_changed)
	GameState.turn_changed.connect(_on_turn_changed)
	GameState.phase_changed.connect(_on_phase_changed)
	spell_panel.connect("spell_requested", func(spell_id: String) -> void: spell_requested.emit(spell_id))
	_refresh()


func set_stage(stage: int) -> void:
	spell_panel.call("set_stage", stage)


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
	sp_label.text = "SP %d" % GameState.sp_points
	phase_label.text = "Phase %d" % GameState.current_phase
	turn_label.text = "Turn %d/%d %s" % [
		GameState.phase_turn_count,
		GameState.TURNS_PER_PHASE,
		"Player" if GameState.current_turn_owner == GameState.TURN_PLAYER else "Enemy"
	]
	combo_label.text = "Combo x%d" % GameState.current_combo


func _on_score_changed(_new_score: int) -> void:
	_refresh()


func _on_combo_changed(_new_combo: int) -> void:
	_refresh()


func _on_sp_changed(_new_sp: int) -> void:
	_refresh()


func _on_hp_changed(_new_hp: int) -> void:
	_refresh()


func _on_mp_changed(_new_mp: int) -> void:
	_refresh()


func _on_turn_changed(_turn_owner: String, _phase_turn_count: int, _current_phase: int) -> void:
	_refresh()


func _on_phase_changed(current_phase: int, _awarded_gem: bool) -> void:
	set_stage(current_phase)
	_refresh()
