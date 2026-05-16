extends Node
class_name ComboSystem

signal combo_changed(combo_count: int)
signal score_awarded(points: int, combo_count: int)

var launch_hits: int = 0


func begin_launch() -> void:
	launch_hits = 0
	combo_changed.emit(launch_hits)


func register_hit(base_score: int) -> int:
	launch_hits += 1
	var points := int(float(base_score) * (1.0 + float(launch_hits) * 0.25))
	GameState.add_score(base_score, launch_hits)
	combo_changed.emit(launch_hits)
	score_awarded.emit(points, launch_hits)
	return points


func end_launch() -> void:
	launch_hits = 0
	combo_changed.emit(launch_hits)
