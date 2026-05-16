extends Area2D
class_name Ball

const BallPhysicsScript := preload("res://scripts/gameplay/BallPhysics.gd")

signal hit_enemy(enemy, ball)
signal expired(ball)
signal bounced(ball, position: Vector2)

@export var speed: float = 620.0
@export var max_bounces: int = 10
@export var damage: int = 1
@export var pierce_count: int = 0
@export var explosive_radius: float = 0.0

var velocity: Vector2 = Vector2.ZERO
var bounce_count: int = 0
var board_bounds: Rect2 = Rect2()
var active: bool = false
var hit_enemies: Array[Area2D] = []

@onready var body: Polygon2D = $Body


func _ready() -> void:
	collision_layer = 4
	collision_mask = 2
	area_entered.connect(_on_area_entered)
	_update_body()


func launch(start_position: Vector2, direction: Vector2, bounds: Rect2) -> void:
	position = start_position
	board_bounds = bounds
	velocity = direction.normalized() * speed
	active = true
	bounce_count = 0
	hit_enemies.clear()
	show()
	set_process(true)


func reset() -> void:
	active = false
	velocity = Vector2.ZERO
	set_process(false)
	hide()


func _process(delta: float) -> void:
	if not active:
		return
	position += velocity * delta
	_check_wall_bounce()
	rotation += velocity.length() * delta * 0.01


func _check_wall_bounce() -> void:
	var normal := Vector2.ZERO
	var radius: float = BallPhysicsScript.BALL_RADIUS

	if position.x <= board_bounds.position.x + radius:
		position.x = board_bounds.position.x + radius
		normal = Vector2.RIGHT
	elif position.x >= board_bounds.end.x - radius:
		position.x = board_bounds.end.x - radius
		normal = Vector2.LEFT

	if position.y <= board_bounds.position.y + radius:
		position.y = board_bounds.position.y + radius
		normal = Vector2.DOWN
	elif position.y >= board_bounds.end.y - radius:
		position.y = board_bounds.end.y - radius
		normal = Vector2.UP

	if normal != Vector2.ZERO:
		velocity = BallPhysicsScript.reflect_velocity(velocity, normal)
		bounce_count += 1
		bounced.emit(self, position)
		if bounce_count > max_bounces:
			active = false
			expired.emit(self)


func _on_area_entered(area: Area2D) -> void:
	var enemy := area
	if not enemy.has_method("take_damage") or enemy in hit_enemies:
		return
	hit_enemies.append(enemy)
	hit_enemy.emit(enemy, self)
	if pierce_count > 0:
		pierce_count -= 1
		return
	velocity = -velocity


func _update_body() -> void:
	if body == null:
		return
	var points: PackedVector2Array = []
	for i in range(20):
		var angle := TAU * float(i) / 20.0
		points.append(Vector2(cos(angle), sin(angle)) * BallPhysicsScript.BALL_RADIUS)
	body.polygon = points
