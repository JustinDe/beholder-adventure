extends Node
class_name LevelManager

const DEFAULT_LEVEL_PATH := "res://resources/level_data/level_001.json"

var current_level_id: String = "level_001"
var level_data: Dictionary = {}


func load_level(level_id: String) -> Dictionary:
	current_level_id = level_id
	var path := "res://resources/level_data/%s.json" % level_id
	level_data = _load_json(path)
	if level_data.is_empty():
		level_data = _load_json(DEFAULT_LEVEL_PATH)
	if level_data.is_empty():
		level_data = _fallback_level()
	return level_data.duplicate(true)


func _load_json(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}
	var text := file.get_as_text()
	file.close()
	var json := JSON.new()
	if json.parse(text) != OK:
		push_error("Invalid level JSON: " + path)
		return {}
	var data = json.get_data()
	return data if data is Dictionary else {}


func _fallback_level() -> Dictionary:
	return {
					"id": "level_001",
		"grid_size": [10, 8],
		"ball_start": [5, 7],
		"enemies": [
			{"type": "basic_slime", "cell": [4, 2]},
			{"type": "armored_beetle", "cell": [6, 2]},
			{"type": "flying_wisp", "cell": [2, 4]},
			{"type": "spiky_urchin", "cell": [8, 4]}
		],
		"obstacles": [[1, 3], [5, 4], [8, 3]]
	}
