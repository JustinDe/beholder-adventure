extends Area2D
class_name Enemy

const EnemyTypesScript := preload("res://scripts/gameplay/EnemyTypes.gd")

signal defeated(enemy)
signal damaged(enemy, amount: int)

@export var enemy_type: String = "basic_slime"
@export var grid_cell: Vector2i = Vector2i.ZERO

var max_hp: int = 1
var hp: int = 1
var score_value: int = 100
var collision_radius: float = 26.0
var moves: bool = false
var movement_time: float = 0.0

@onready var body: Polygon2D = $Body
@onready var hp_label: Label = $HPLabel


func _ready() -> void:
	collision_layer = 2
	collision_mask = 4
	apply_type(enemy_type)


func apply_type(new_type: String) -> void:
	enemy_type = new_type
	var data: Dictionary = EnemyTypesScript.get_data(enemy_type)
	max_hp = data.get("max_hp", 1)
	hp = max_hp
	score_value = data.get("score", 100)
	moves = data.get("moves", false)
	collision_radius = data.get("radius", 26.0)
	_update_collision_shape()
	_update_body(data.get("body_color", Color.WHITE))
	_update_label()


func _process(delta: float) -> void:
	if moves:
		movement_time += delta
		position.y += sin(movement_time * 3.0) * 18.0 * delta


func take_damage(amount: int) -> bool:
	hp = max(0, hp - amount)
	damaged.emit(self, amount)
	_flash()
	_update_label()
	if hp <= 0:
		defeated.emit(self)
		queue_free()
		return true
	return false


func _update_collision_shape() -> void:
	var shape_node := get_node_or_null("CollisionShape2D") as CollisionShape2D
	if shape_node == null:
		shape_node = CollisionShape2D.new()
		shape_node.name = "CollisionShape2D"
		add_child(shape_node)
	var circle := CircleShape2D.new()
	circle.radius = collision_radius
	shape_node.shape = circle


func _update_body(color: Color) -> void:
	if body == null:
		return
	var points: PackedVector2Array = []
	var sides := 16
	for i in range(sides):
		var angle := TAU * float(i) / float(sides)
		points.append(Vector2(cos(angle), sin(angle)) * collision_radius)
	body.polygon = points
	body.color = color


func _update_label() -> void:
	if hp_label:
		hp_label.text = str(hp)


func _flash() -> void:
	if body == null:
		return
	var original := body.color
	var tween := create_tween()
	tween.tween_property(body, "color", Color.WHITE, 0.04)
	tween.tween_property(body, "color", original, 0.12)
