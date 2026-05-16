extends Control
class_name CardSelector

const ActionCardScript := preload("res://scripts/gameplay/ActionCard.gd")

signal card_selected(card)

var cards: Array = []
var selected_card = null
var button_by_card_id: Dictionary = {}


func _ready() -> void:
	cards = ActionCardScript.create_defaults()
	_build_buttons()
	GameState.score_changed.connect(func(_new_score: int) -> void: _refresh_buttons())


func _process(_delta: float) -> void:
	_refresh_buttons()


func _build_buttons() -> void:
	for child in get_children():
		child.queue_free()
	button_by_card_id.clear()

	var row := HBoxContainer.new()
	row.name = "CardRow"
	row.add_theme_constant_override("separation", 8)
	add_child(row)

	for card in cards:
		var button := Button.new()
		button.text = "%s\n%d BP" % [card.display_name, card.bp_cost]
		button.custom_minimum_size = Vector2(132, 64)
		button.toggle_mode = true
		button.pressed.connect(_select_card.bind(card))
		row.add_child(button)
		button_by_card_id[card.id] = button

	_refresh_buttons()


func _select_card(card) -> void:
	if GameState.battle_points < card.bp_cost:
		selected_card = null
		_refresh_buttons()
		card_selected.emit(null)
		return
	if selected_card == card:
		selected_card = null
	else:
		selected_card = card
	for candidate in cards:
		var button := button_by_card_id.get(candidate.id) as Button
		if button:
			button.button_pressed = candidate == selected_card
	card_selected.emit(selected_card)
	_refresh_buttons()


func consume_selected_card():
	var card = selected_card
	if card == null:
		return null
	if not GameState.spend_bp(card.bp_cost):
		return null
	selected_card = null
	_refresh_buttons()
	return card


func _refresh_buttons() -> void:
	for card in cards:
		var button := button_by_card_id.get(card.id) as Button
		if button == null:
			continue
		button.disabled = GameState.battle_points < card.bp_cost
		button.button_pressed = card == selected_card
