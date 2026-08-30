extends Area2D
class_name SPNode

@export var sp_value: int = 1

var collected: bool = false

@onready var body: Polygon2D = $Body
@onready var label: Label = $Label


func _ready() -> void:
	collision_layer = 2
	collision_mask = 4
	_update_body()
	if label:
		label.text = "SP"


func collect_sp() -> void:
	if collected:
		return
	collected = true
	GameState.add_sp(sp_value)
	queue_free()


func _update_body() -> void:
	if body == null:
		return
	var points: PackedVector2Array = []
	for i in range(6):
		var angle := TAU * float(i) / 6.0 + PI / 6.0
		points.append(Vector2(cos(angle), sin(angle)) * 24.0)
	body.polygon = points
