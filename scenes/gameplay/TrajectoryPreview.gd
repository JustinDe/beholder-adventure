extends Node2D
class_name TrajectoryPreview

@export var dot_radius: float = 4.0
@export var dot_spacing: float = 22.0
@export var dot_color: Color = Color(1.0, 0.94, 0.45, 0.82)

var path_points: PackedVector2Array = PackedVector2Array()


func set_path(points: PackedVector2Array) -> void:
	path_points = points
	visible = path_points.size() > 1
	queue_redraw()


func clear_path() -> void:
	path_points.clear()
	visible = false
	queue_redraw()


func _draw() -> void:
	if path_points.size() < 2:
		return

	var distance_to_next_dot := 0.0
	for i in range(path_points.size() - 1):
		var start := path_points[i]
		var end := path_points[i + 1]
		var segment := end - start
		var segment_length := segment.length()
		if segment_length <= 0.0:
			continue

		var direction := segment / segment_length
		var traveled := distance_to_next_dot
		while traveled <= segment_length:
			var dot_position := start + direction * traveled
			draw_circle(dot_position, dot_radius, dot_color)
			traveled += dot_spacing
		distance_to_next_dot = maxf(0.0, traveled - segment_length)
