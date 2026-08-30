extends CanvasLayer
class_name TitleMenu

signal start_requested

const STORE_ITEMS := [
	{"id": "aiming_lens", "name": "Aiming Lens", "cost": 1},
	{"id": "prism_core", "name": "Prism Core", "cost": 2},
	{"id": "warded_orb", "name": "Warded Orb", "cost": 3},
	{"id": "meteor_focus", "name": "Meteor Focus", "cost": 5}
]

var title_screen: Control
var store_screen: Control
var settings_screen: Control
var gem_labels: Array[Label] = []
var store_grid: GridContainer
var store_status: Label
var settings_value_labels: Dictionary = {}


func _ready() -> void:
	_build_ui()
	GameState.golden_gems_changed.connect(func(_value: int) -> void: _refresh())
	GameState.store_purchases_changed.connect(_refresh)
	show_title()


func show_title() -> void:
	show()
	_set_screen(title_screen)
	_refresh()


func _build_ui() -> void:
	var backdrop := ColorRect.new()
	backdrop.name = "Backdrop"
	backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	backdrop.color = Color(0.06, 0.08, 0.10, 1.0)
	add_child(backdrop)

	title_screen = _new_screen("TitleScreen")
	store_screen = _new_screen("StoreScreen")
	settings_screen = _new_screen("SettingsScreen")
	add_child(title_screen)
	add_child(store_screen)
	add_child(settings_screen)
	_build_title_screen()
	_build_store_screen()
	_build_settings_screen()


func _new_screen(screen_name: String) -> Control:
	var screen := Control.new()
	screen.name = screen_name
	screen.set_anchors_preset(Control.PRESET_FULL_RECT)
	return screen


func _build_title_screen() -> void:
	var panel := _center_panel(title_screen, Vector2(460, 560))
	var title := _label("Beholder Adventure", 38, Color(1.0, 0.95, 0.78, 1.0))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	panel.add_child(title)
	var gems := _label("", 24, Color(1.0, 0.82, 0.28, 1.0))
	gems.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	panel.add_child(gems)
	gem_labels.append(gems)

	_add_menu_button(panel, "Start", func() -> void: start_requested.emit())
	_add_menu_button(panel, "Store", func() -> void: _open_store())
	_add_menu_button(panel, "Settings", func() -> void: _set_screen(settings_screen))
	_add_menu_button(panel, "Exit", func() -> void:
		GameState.save_game()
		AudioManager.save_settings()
		get_tree().quit()
	)


func _build_store_screen() -> void:
	var panel := _center_panel(store_screen, Vector2(860, 640))
	var title := _label("Store", 34, Color(1.0, 0.95, 0.78, 1.0))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	panel.add_child(title)
	var gems := _label("", 22, Color(1.0, 0.82, 0.28, 1.0))
	gems.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	panel.add_child(gems)
	gem_labels.append(gems)

	store_grid = GridContainer.new()
	store_grid.columns = 2
	store_grid.add_theme_constant_override("h_separation", 16)
	store_grid.add_theme_constant_override("v_separation", 16)
	panel.add_child(store_grid)

	store_status = _label("", 18, Color(0.9, 0.94, 1.0, 1.0))
	store_status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	panel.add_child(store_status)
	_add_menu_button(panel, "Back", func() -> void: _set_screen(title_screen))


func _build_settings_screen() -> void:
	var panel := _center_panel(settings_screen, Vector2(560, 520))
	var title := _label("Settings", 34, Color(1.0, 0.95, 0.78, 1.0))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	panel.add_child(title)
	_add_volume_row(panel, "SFX", AudioManager.SFX_BUS, "sfx")
	_add_volume_row(panel, "Music", AudioManager.MUSIC_BUS, "music")
	_add_volume_row(panel, "UI", AudioManager.UI_BUS, "ui")
	_add_menu_button(panel, "Back", func() -> void:
		AudioManager.save_settings()
		_set_screen(title_screen)
	)


func _center_panel(parent: Control, size: Vector2) -> VBoxContainer:
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_CENTER)
	margin.offset_left = -size.x * 0.5
	margin.offset_top = -size.y * 0.5
	margin.offset_right = size.x * 0.5
	margin.offset_bottom = size.y * 0.5
	margin.add_theme_constant_override("margin_left", 24)
	margin.add_theme_constant_override("margin_top", 24)
	margin.add_theme_constant_override("margin_right", 24)
	margin.add_theme_constant_override("margin_bottom", 24)
	parent.add_child(margin)

	var panel_bg := ColorRect.new()
	panel_bg.color = Color(0.10, 0.14, 0.16, 0.96)
	panel_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_child(panel_bg)

	var panel := VBoxContainer.new()
	panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	panel.add_theme_constant_override("separation", 18)
	margin.add_child(panel)
	return panel


func _add_menu_button(parent: VBoxContainer, text: String, callback: Callable) -> Button:
	var button := Button.new()
	button.custom_minimum_size = Vector2(240, 52)
	button.text = text
	button.pressed.connect(callback)
	parent.add_child(button)
	return button


func _add_volume_row(parent: VBoxContainer, label_text: String, bus_name: String, setting_key: String) -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 14)
	parent.add_child(row)

	var name_label := _label(label_text, 22, Color.WHITE)
	name_label.custom_minimum_size = Vector2(90, 36)
	row.add_child(name_label)

	var slider := HSlider.new()
	slider.custom_minimum_size = Vector2(300, 36)
	slider.min_value = 0.0
	slider.max_value = 1.0
	slider.step = 0.01
	slider.value = AudioManager.get_volume_linear(bus_name)
	row.add_child(slider)

	var value_label := _label("%d%%" % int(round(slider.value * 100.0)), 20, Color(0.86, 0.92, 1.0, 1.0))
	value_label.custom_minimum_size = Vector2(72, 36)
	row.add_child(value_label)
	settings_value_labels[setting_key] = value_label

	slider.value_changed.connect(func(value: float) -> void:
		match setting_key:
			"sfx":
				AudioManager.set_sfx_volume(value)
			"music":
				AudioManager.set_music_volume(value)
			"ui":
				AudioManager.set_ui_volume(value)
		value_label.text = "%d%%" % int(round(value * 100.0))
	)


func _open_store() -> void:
	store_status.text = ""
	_set_screen(store_screen)
	_refresh()


func _set_screen(active: Control) -> void:
	title_screen.visible = active == title_screen
	store_screen.visible = active == store_screen
	settings_screen.visible = active == settings_screen
	_refresh()


func _refresh() -> void:
	for label in gem_labels:
		label.text = "Golden Gems %d" % GameState.golden_gems
	_refresh_store()


func _refresh_store() -> void:
	if store_grid == null:
		return
	for child in store_grid.get_children():
		child.queue_free()
	for item in STORE_ITEMS:
		_add_store_card(item)


func _add_store_card(item: Dictionary) -> void:
	var card := VBoxContainer.new()
	card.custom_minimum_size = Vector2(360, 160)
	card.add_theme_constant_override("separation", 10)
	store_grid.add_child(card)

	var name_label := _label(str(item["name"]), 24, Color.WHITE)
	card.add_child(name_label)
	var cost := int(item["cost"])
	var cost_label := _label("Cost %d" % cost, 20, Color(1.0, 0.82, 0.28, 1.0))
	card.add_child(cost_label)
	var purchased := GameState.is_store_item_purchased(str(item["id"]))
	var button := Button.new()
	button.custom_minimum_size = Vector2(180, 44)
	button.text = "Owned" if purchased else "Purchase"
	button.disabled = purchased or GameState.golden_gems < cost
	button.pressed.connect(func() -> void:
		if GameState.purchase_store_item(str(item["id"]), cost):
			store_status.text = "%s purchased" % item["name"]
		else:
			store_status.text = "Not enough golden gems"
		_refresh()
	)
	card.add_child(button)


func _label(text: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	return label
