extends Control
class_name TouchControls

var feedback_points: Dictionary = {}


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	visible = InputHandler.show_touch_feedback


func _input(event: InputEvent) -> void:
	if not InputHandler.show_touch_feedback:
		return
	if event is InputEventScreenTouch:
		if event.pressed:
			feedback_points[event.index] = event.position
		else:
			feedback_points.erase(event.index)
		queue_redraw()
	elif event is InputEventScreenDrag:
		feedback_points[event.index] = event.position
		queue_redraw()


func _draw() -> void:
	for point in feedback_points.values():
		draw_circle(point, 26.0, Color(1, 1, 1, 0.14))
		draw_arc(point, 32.0, 0.0, TAU, 32, Color(1, 1, 1, 0.32), 2.0)
