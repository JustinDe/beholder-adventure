extends Control
class_name SpellPanel

const SpellBookScript := preload("res://scripts/gameplay/SpellBook.gd")

signal spell_requested(spell_id: String)

var current_stage: int = 1
var buttons_by_spell_id: Dictionary = {}


func _ready() -> void:
	_build_spell_buttons()


func _process(_delta: float) -> void:
	_refresh_buttons()


func set_stage(stage: int) -> void:
	current_stage = stage
	_refresh_buttons()


func _build_spell_buttons() -> void:
	for child in get_children():
		child.queue_free()
	buttons_by_spell_id.clear()

	var grid := GridContainer.new()
	grid.name = "SpellGrid"
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 8)
	grid.add_theme_constant_override("v_separation", 8)
	add_child(grid)

	for spell_id in SpellBookScript.all_spell_ids():
		var spell := SpellBookScript.get_spell(spell_id)
		var button := Button.new()
		button.custom_minimum_size = Vector2(176, 56)
		button.tooltip_text = spell.get("description", "")
		button.pressed.connect(func() -> void: spell_requested.emit(spell_id))
		grid.add_child(button)
		buttons_by_spell_id[spell_id] = button

	_refresh_buttons()


func _refresh_buttons() -> void:
	for spell_id in buttons_by_spell_id.keys():
		var button := buttons_by_spell_id[spell_id] as Button
		var spell := SpellBookScript.get_spell(spell_id)
		var cost := int(spell.get("mp_cost", 0))
		var cooldown := GameState.get_spell_cooldown(spell_id)
		var min_stage := int(spell.get("min_stage", 1))
		var max_stage := int(spell.get("max_stage", 99))
		var available := current_stage >= min_stage and current_stage <= max_stage
		button.text = "%s\nMP %d%s" % [
			spell.get("name", spell_id),
			cost,
			"  CD %d" % cooldown if cooldown > 0 else ""
		]
		button.disabled = not available or GameState.player_mp < cost or cooldown > 0
