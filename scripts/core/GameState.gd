extends Node
## GameState Autoload
## Manages global game state, progression, and persistence

# Signals
signal score_changed(new_score: int)
signal combo_changed(new_combo: int)
signal sp_changed(new_sp: int)
signal hp_changed(new_hp: int)
signal mp_changed(new_mp: int)
signal spell_cooldowns_changed
signal status_effects_changed
signal level_complete(level_id: String, stars: int)
signal game_over

# Constants
const SAVE_FILE_PATH := "user://save_data.json"

# Core state variables
var current_score: int = 0
var current_combo: int = 0
var current_level: String = ""
var player_hp: int = 100
var player_mp: int = 100
var sp_points: int = 1
var spell_cooldowns: Dictionary = {}
var detrimental_effects: Array[String] = []
var floor_invulnerable_turns: int = 0
var ward_turns: int = 0
var reraise_turns: int = 0

# Progression tracking
var unlocked_levels: Array[String] = []
var level_stars: Dictionary = {}  # { level_id: star_count }
var total_games_played: int = 0
var total_wins: int = 0

# Combo tracking
var combo_timer: float = 0.0
const COMBO_TIMEOUT: float = 3.0  # Seconds before combo resets


func _ready() -> void:
	# Initialize starting level
	unlocked_levels = ["level_001"]
	load_game()


func _process(delta: float) -> void:
	# Combo timer
	if current_combo > 0:
		combo_timer += delta
		if combo_timer >= COMBO_TIMEOUT:
			reset_combo()


## Add score with combo multiplier
func add_score(base_points: int, combo_count: int = 0) -> void:
	var multiplier: float = 1.0 + (combo_count * 0.25)
	var earned_points: int = int(base_points * multiplier)
	current_score += earned_points
	score_changed.emit(current_score)
	
	# Update combo
	if combo_count > 0:
		current_combo = combo_count
		combo_timer = 0.0
		combo_changed.emit(current_combo)


## Reset combo counter
func reset_combo() -> void:
	if current_combo > 0:
		current_combo = 0
		combo_timer = 0.0
		combo_changed.emit(current_combo)


## Add shot points, which control how many balls launch per shot.
func add_sp(amount: int) -> void:
	sp_points = max(1, sp_points + amount)
	sp_changed.emit(sp_points)


## Take damage
func take_damage(amount: int) -> void:
	if ward_turns > 0:
		amount = int(ceil(float(amount) * 0.5))
	player_hp = max(0, player_hp - amount)
	hp_changed.emit(player_hp)
	if player_hp <= 0:
		if reraise_turns > 0:
			reraise_turns = 0
			player_hp = 50
			hp_changed.emit(player_hp)
			status_effects_changed.emit()
		else:
			game_over.emit()


## Heal player
func heal(amount: int) -> void:
	player_hp = min(100, player_hp + amount)
	hp_changed.emit(player_hp)


## Use MP
func spend_mp(cost: int) -> bool:
	if player_mp >= cost:
		player_mp -= cost
		mp_changed.emit(player_mp)
		return true
	return false


## Regenerate MP
func regen_mp(amount: int) -> void:
	player_mp = min(100, player_mp + amount)
	mp_changed.emit(player_mp)


func get_spell_cooldown(spell_id: String) -> int:
	return int(spell_cooldowns.get(spell_id, 0))


func set_spell_cooldown(spell_id: String, turns: int) -> void:
	spell_cooldowns[spell_id] = max(0, turns)
	spell_cooldowns_changed.emit()


func tick_turn_effects() -> void:
	for spell_id in spell_cooldowns.keys():
		spell_cooldowns[spell_id] = max(0, int(spell_cooldowns[spell_id]) - 1)
	floor_invulnerable_turns = max(0, floor_invulnerable_turns - 1)
	ward_turns = max(0, ward_turns - 1)
	reraise_turns = max(0, reraise_turns - 1)
	spell_cooldowns_changed.emit()
	status_effects_changed.emit()


func clear_detrimental_effects_except_doom() -> void:
	var retained: Array[String] = []
	for effect in detrimental_effects:
		if effect.to_lower() == "doom":
			retained.append(effect)
	detrimental_effects = retained
	status_effects_changed.emit()


func grant_floor_invulnerability(turns: int) -> void:
	floor_invulnerable_turns = max(floor_invulnerable_turns, turns)
	status_effects_changed.emit()


func grant_ward(turns: int) -> void:
	ward_turns = max(ward_turns, turns)
	status_effects_changed.emit()


func grant_reraise(turns: int) -> void:
	reraise_turns = max(reraise_turns, turns)
	status_effects_changed.emit()


## Complete a level with star rating
func complete_level(level_id: String, stars: int) -> void:
	level_stars[level_id] = max(level_stars.get(level_id, 0), stars)
	total_wins += 1
	
	# Unlock next level
	var next_level := _get_next_level(level_id)
	if next_level and next_level not in unlocked_levels:
		unlocked_levels.append(next_level)
	
	level_complete.emit(level_id, stars)


## Get next level ID
func _get_next_level(current_id: String) -> String:
	# Extract number from level_id (e.g., "level_001" -> 1)
	var parts := current_id.split("_")
	if parts.size() < 2:
		return ""
	
	var current_num := int(parts[1])
	var next_num := current_num + 1
	return "level_%03d" % next_num


## Check if level is unlocked
func is_level_unlocked(level_id: String) -> bool:
	return level_id in unlocked_levels


## Get star count for level
func get_level_stars(level_id: String) -> int:
	return level_stars.get(level_id, 0)


## Save game data
func save_game() -> Error:
	var save_data := {
		"score": current_score,
		"unlocked_levels": unlocked_levels,
		"level_stars": level_stars,
		"total_games_played": total_games_played,
		"total_wins": total_wins
	}
	
	var file := FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Failed to open save file for writing")
		return FileAccess.get_open_error()
	
	file.store_string(JSON.stringify(save_data, "\t"))
	file.close()
	return OK


## Load game data
func load_game() -> Error:
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		return ERR_FILE_NOT_FOUND
	
	var file := FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if file == null:
		push_error("Failed to open save file for reading")
		return FileAccess.get_open_error()
	
	var json_string := file.get_as_text()
	file.close()
	
	var json := JSON.new()
	var parse_result := json.parse(json_string)
	if parse_result != OK:
		push_error("Failed to parse save data")
		return ERR_INVALID_DATA
	
	var data: Variant = json.get_data()
	if data is Dictionary:
		current_score = data.get("score", 0)
		unlocked_levels = data.get("unlocked_levels", ["level_001"])
		level_stars = data.get("level_stars", {})
		total_games_played = data.get("total_games_played", 0)
		total_wins = data.get("total_wins", 0)
	
	return OK


## Reset game state (for new game)
func new_game() -> void:
	current_score = 0
	current_combo = 0
	player_hp = 100
	player_mp = 100
	sp_points = 1
	spell_cooldowns.clear()
	detrimental_effects.clear()
	floor_invulnerable_turns = 0
	ward_turns = 0
	reraise_turns = 0
	unlocked_levels = ["level_001"]
	level_stars.clear()
	total_games_played += 1
	
	score_changed.emit(0)
	combo_changed.emit(0)
	sp_changed.emit(sp_points)
	hp_changed.emit(player_hp)
	mp_changed.emit(player_mp)
	spell_cooldowns_changed.emit()
	status_effects_changed.emit()


## Get statistics
func get_stats() -> Dictionary:
	var total_stars := 0
	for stars in level_stars.values():
		total_stars += int(stars)
	return {
		"score": current_score,
		"total_games": total_games_played,
		"total_wins": total_wins,
		"win_rate": float(total_wins) / max(1, total_games_played) * 100.0,
		"levels_completed": level_stars.size(),
		"total_stars": total_stars
	}
