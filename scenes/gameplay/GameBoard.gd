extends Node2D
class_name GameBoard

signal level_cleared(level_id: String)
signal status_changed(message: String)

const BallScene := preload("res://scenes/gameplay/Ball.tscn")
const EnemyScene := preload("res://scenes/gameplay/Enemy.tscn")
const BallPhysicsScript := preload("res://scripts/gameplay/BallPhysics.gd")
const LevelManagerScript := preload("res://scripts/gameplay/LevelManager.gd")
const ComboSystemScript := preload("res://scripts/gameplay/ComboSystem.gd")

@export var cell_size: Vector2 = Vector2(96, 80)
@export var board_origin: Vector2 = Vector2(480, 190)
@export var trajectory_extra_square_widths: float = 4.0

var level_manager: Node
var combo_system: Node
var level_id: String = "level_001"
var grid_size: Vector2i = Vector2i(10, 8)
var ball_start_cell: Vector2i = Vector2i(5, 7)
var player_row: int = 7
var active_card = null
var enemies: Array = []
var active_balls: Array = []
var obstacle_rects: Array[Rect2] = []
var is_launching: bool = false
var aim_direction: Vector2 = Vector2.UP
var level_is_cleared: bool = false

@onready var grid_layer: Node2D = $GridLayer
@onready var obstacle_layer: Node2D = $ObstacleLayer
@onready var enemy_layer: Node2D = $EnemyLayer
@onready var ball_layer: Node2D = $BallLayer
@onready var trajectory_preview: Node2D = $TrajectoryPreview
@onready var spawn_marker: Marker2D = $SpawnMarker
@onready var player: Node2D = $Player
@onready var player_body: Polygon2D = $Player/Body
@onready var player_muzzle: Marker2D = $Player/Muzzle


func _ready() -> void:
	level_manager = LevelManagerScript.new()
	add_child(level_manager)
	combo_system = ComboSystemScript.new()
	add_child(combo_system)
	InputHandler.aim_started.connect(_on_aim_started)
	InputHandler.aim_updated.connect(_on_aim_updated)
	InputHandler.aim_ended.connect(_on_aim_ended)
	InputHandler.action_cancelled.connect(_on_action_cancelled)
	_update_player_body()
	load_level(level_id)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_move_player(-1)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_move_player(1)


func _process(_delta: float) -> void:
	if _is_players_turn():
		aim_direction = _get_mouse_aim_direction()
		_update_trajectory(aim_direction)
	else:
		trajectory_preview.clear_path()
	for ball in active_balls:
		if is_instance_valid(ball) and ball.active:
			_check_obstacle_bounce(ball)


func load_level(new_level_id: String) -> void:
	level_id = new_level_id
	var data: Dictionary = level_manager.load_level(level_id)
	level_is_cleared = false
	grid_size = _array_to_vec2i(data.get("grid_size", [10, 8]))
	ball_start_cell = _array_to_vec2i(data.get("ball_start", [5, 7]))
	player_row = clampi(ball_start_cell.y, 0, grid_size.y - 1)
	_clear_board()
	_draw_grid()
	_place_obstacles(data.get("obstacles", []))
	_spawn_enemies(data.get("enemies", []))
	_update_player_position()
	trajectory_preview.clear_path()
	status_changed.emit("Mouse wheel moves launcher. Aim with mouse")


func set_active_card(card) -> void:
	active_card = card


func consume_card_for_launch(card_selector) -> void:
	if active_card != null:
		active_card = card_selector.consume_selected_card()


func get_board_bounds() -> Rect2:
	return Rect2(board_origin, Vector2(grid_size.x, grid_size.y) * cell_size)


func cell_to_world(cell: Vector2i) -> Vector2:
	return board_origin + Vector2(cell.x, cell.y) * cell_size + cell_size * 0.5


func get_launch_position() -> Vector2:
	var bounds := get_board_bounds()
	return Vector2(bounds.end.x - BallPhysicsScript.BALL_RADIUS - 2.0, _row_center_y(player_row))


func get_player_position() -> Vector2:
	return Vector2(get_board_bounds().end.x + cell_size.x * 0.45, _row_center_y(player_row))


func get_trajectory_distance() -> float:
	return get_board_bounds().size.x + cell_size.x * trajectory_extra_square_widths


func _clear_board() -> void:
	for layer in [grid_layer, obstacle_layer, enemy_layer, ball_layer]:
		for child in layer.get_children():
			child.queue_free()
	enemies.clear()
	active_balls.clear()
	obstacle_rects.clear()


func _draw_grid() -> void:
	for y in range(grid_size.y):
		for x in range(grid_size.x):
			var tile := ColorRect.new()
			tile.position = board_origin + Vector2(float(x), float(y)) * cell_size
			tile.size = cell_size - Vector2.ONE
			tile.color = Color(0.12, 0.17, 0.20, 1.0) if (x + y) % 2 == 0 else Color(0.15, 0.21, 0.24, 1.0)
			grid_layer.add_child(tile)


func _update_player_position() -> void:
	player.position = get_player_position()
	spawn_marker.position = get_launch_position()


func _move_player(row_delta: int) -> void:
	if active_balls.size() > 0:
		return
	var previous_row := player_row
	player_row = clampi(player_row + row_delta, 0, grid_size.y - 1)
	if player_row == previous_row:
		return
	_update_player_position()
	status_changed.emit("Launcher row %d" % (player_row + 1))


func _update_player_body() -> void:
	var points := PackedVector2Array([
		Vector2(-24, -30),
		Vector2(22, -18),
		Vector2(32, 0),
		Vector2(22, 18),
		Vector2(-24, 30)
	])
	player_body.polygon = points


func _row_center_y(row: int) -> float:
	return board_origin.y + (float(row) + 0.5) * cell_size.y


func _place_obstacles(obstacles: Array) -> void:
	for entry in obstacles:
		var cell := _array_to_vec2i(entry)
		var rect := Rect2(board_origin + Vector2(cell.x, cell.y) * cell_size, cell_size)
		obstacle_rects.append(rect)
		var obstacle := ColorRect.new()
		obstacle.position = rect.position + Vector2(8, 8)
		obstacle.size = rect.size - Vector2(16, 16)
		obstacle.color = Color(0.40, 0.34, 0.27, 1.0)
		obstacle_layer.add_child(obstacle)


func _spawn_enemies(enemy_entries: Array) -> void:
	for entry in enemy_entries:
		if not entry is Dictionary:
			continue
		var enemy := EnemyScene.instantiate()
		enemy.enemy_type = entry.get("type", "basic_slime")
		enemy.grid_cell = _array_to_vec2i(entry.get("cell", [0, 0]))
		enemy.position = cell_to_world(enemy.grid_cell)
		enemy.defeated.connect(_on_enemy_defeated)
		enemy_layer.add_child(enemy)
		enemies.append(enemy)


func _launch(direction: Vector2) -> void:
	if active_balls.size() > 0 or direction.length_squared() == 0.0:
		return
	trajectory_preview.clear_path()
	combo_system.begin_launch()
	var card = active_card
	if card != null and not GameState.spend_bp(card.bp_cost):
		card = null
	active_card = null
	var ball_count: int = card.ball_count if card else 1
	var spread: float = card.spread_degrees if card else 0.0
	var start_angle: float = -spread * 0.5
	for i in range(ball_count):
		var launch_direction := direction
		if ball_count > 1:
			var offset: float = start_angle + (spread / float(max(1, ball_count - 1))) * float(i)
			launch_direction = direction.rotated(deg_to_rad(offset))
		_spawn_ball(launch_direction, card)
	status_changed.emit("Ball launched")


func _spawn_ball(direction: Vector2, card) -> void:
	var ball := BallScene.instantiate()
	if card:
		ball.damage = max(1, int(round(float(ball.damage) * card.damage_multiplier)))
		ball.max_bounces = max(1, ball.max_bounces + card.bounce_modifier)
		ball.pierce_count = card.pierce_count
		ball.explosive_radius = card.explosion_radius
	ball.hit_enemy.connect(_on_ball_hit_enemy)
	ball.expired.connect(_on_ball_expired)
	ball.bounced.connect(_on_ball_bounced)
	ball_layer.add_child(ball)
	active_balls.append(ball)
	ball.launch(get_launch_position(), direction, get_board_bounds())


func _on_ball_hit_enemy(enemy, ball) -> void:
	var defeated: bool = enemy.take_damage(ball.damage)
	combo_system.register_hit(enemy.score_value)
	status_changed.emit("Hit %s" % enemy.enemy_type.replace("_", " "))
	if ball.explosive_radius > 0.0:
		_apply_explosion(enemy.position, ball.explosive_radius, ball.damage)
	if defeated:
		enemies.erase(enemy)
		_check_level_clear()


func _apply_explosion(center: Vector2, radius: float, damage: int) -> void:
	for enemy in enemies.duplicate():
		if not is_instance_valid(enemy) or enemy.position.distance_to(center) <= 1.0:
			continue
		if enemy.position.distance_to(center) <= radius:
			var defeated: bool = enemy.take_damage(damage)
			combo_system.register_hit(enemy.score_value)
			if defeated:
				enemies.erase(enemy)


func _on_enemy_defeated(enemy) -> void:
	enemies.erase(enemy)
	_check_level_clear()


func _on_ball_expired(ball) -> void:
	active_balls.erase(ball)
	ball.queue_free()
	if active_balls.is_empty():
		combo_system.end_launch()
		status_changed.emit("Ready")


func _on_ball_bounced(ball, _position: Vector2) -> void:
	_check_obstacle_bounce(ball)


func _check_obstacle_bounce(ball) -> void:
	for rect in obstacle_rects:
		if rect.grow(BallPhysicsScript.BALL_RADIUS).has_point(ball.position):
			var center := rect.get_center()
			var delta: Vector2 = ball.position - center
			var normal := Vector2.RIGHT if abs(delta.x) > abs(delta.y) else Vector2.DOWN
			if abs(delta.x) > abs(delta.y) and delta.x < 0.0:
				normal = Vector2.LEFT
			elif abs(delta.y) >= abs(delta.x) and delta.y < 0.0:
				normal = Vector2.UP
			ball.velocity = BallPhysicsScript.reflect_velocity(ball.velocity, normal)
			ball.position += normal * 6.0
			return


func _check_level_clear() -> void:
	if enemies.is_empty():
		level_is_cleared = true
		trajectory_preview.clear_path()
		GameState.complete_level(level_id, 3)
		status_changed.emit("Level cleared")
		level_cleared.emit(level_id)


func _on_aim_started(position: Vector2) -> void:
	if active_balls.size() > 0:
		return
	if level_is_cleared:
		return
	is_launching = true
	aim_direction = _get_mouse_aim_direction()
	_update_trajectory(aim_direction)


func _on_aim_updated(_position: Vector2, _delta: Vector2) -> void:
	if is_launching:
		aim_direction = _get_mouse_aim_direction()
		_update_trajectory(aim_direction)


func _on_aim_ended(_position: Vector2) -> void:
	if not is_launching:
		return
	is_launching = false
	aim_direction = _get_mouse_aim_direction()
	if aim_direction.length_squared() > 0.0:
		_launch(aim_direction)


func _on_action_cancelled() -> void:
	is_launching = false
	status_changed.emit("Aim cancelled")


func _update_trajectory(direction: Vector2) -> void:
	if direction.length_squared() == 0.0:
		trajectory_preview.clear_path()
		return
	var points: PackedVector2Array = BallPhysicsScript.predict_path(
		get_launch_position(),
		direction,
		get_board_bounds(),
		BallPhysicsScript.MAX_BOUNCES,
		get_trajectory_distance()
	)
	trajectory_preview.set_path(points)


func _get_mouse_aim_direction() -> Vector2:
	var direction := get_global_mouse_position() - get_launch_position()
	if direction.length() < 8.0:
		return Vector2.ZERO
	return direction.normalized()


func _is_players_turn() -> bool:
	return active_balls.is_empty() and not level_is_cleared


func _array_to_vec2i(value) -> Vector2i:
	if value is Array and value.size() >= 2:
		return Vector2i(int(value[0]), int(value[1]))
	return Vector2i.ZERO
