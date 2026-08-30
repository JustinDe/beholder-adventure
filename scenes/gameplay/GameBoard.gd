extends Node2D
class_name GameBoard

signal level_cleared(level_id: String)
signal status_changed(message: String)
signal phase_started(phase: int)

const BallScene := preload("res://scenes/gameplay/Ball.tscn")
const EnemyScene := preload("res://scenes/gameplay/Enemy.tscn")
const SPNodeScene := preload("res://scenes/gameplay/SPNode.tscn")
const SpellBookScript := preload("res://scripts/gameplay/SpellBook.gd")
const BallPhysicsScript := preload("res://scripts/gameplay/BallPhysics.gd")
const LevelManagerScript := preload("res://scripts/gameplay/LevelManager.gd")
const ComboSystemScript := preload("res://scripts/gameplay/ComboSystem.gd")

@export var cell_size: Vector2 = Vector2(96, 80)
@export var board_origin: Vector2 = Vector2(480, 190)
@export var trajectory_extra_square_widths: float = 4.0
@export var ball_timeout_seconds: float = 12.0

var level_manager: Node
var combo_system: Node
var level_id: String = "level_001"
var grid_size: Vector2i = Vector2i(10, 8)
var ball_start_cell: Vector2i = Vector2i(5, 7)
var player_row: int = 7
var enemies: Array = []
var active_balls: Array = []
var obstacle_rects: Array[Rect2] = []
var is_launching: bool = false
var aim_direction: Vector2 = Vector2.UP
var level_is_cleared: bool = false
var enemy_turn_resolving: bool = false
var launch_sequence_id: int = 0

@onready var grid_layer: Node2D = $GridLayer
@onready var obstacle_layer: Node2D = $ObstacleLayer
@onready var resource_layer: Node2D = $ResourceLayer
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
	InputHandler.restart_round_requested.connect(_on_restart_round_requested)
	GameState.phase_changed.connect(_on_phase_changed)
	_update_player_body()
	load_level(level_id)


func _input(event: InputEvent) -> void:
	if not _is_players_turn():
		return
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
	_spawn_sp_nodes(data.get("sp_nodes", []))
	_spawn_enemies(data.get("enemies", []))
	_update_player_position()
	trajectory_preview.clear_path()
	status_changed.emit("Mouse wheel moves launcher. Aim with mouse")
	phase_started.emit(GameState.current_phase)


func get_current_stage() -> int:
	return GameState.current_phase


func cast_spell(spell_id: String) -> void:
	if not _is_players_turn():
		status_changed.emit("Wait for your turn")
		return
	var spell := SpellBookScript.get_spell(spell_id)
	if spell.is_empty():
		return
	var current_stage := get_current_stage()
	if current_stage < int(spell.get("min_stage", 1)) or current_stage > int(spell.get("max_stage", 99)):
		status_changed.emit("%s is not available on this stage" % spell.get("name", spell_id))
		return
	if GameState.get_spell_cooldown(spell_id) > 0:
		status_changed.emit("%s is still recasting" % spell.get("name", spell_id))
		return
	if spell_id == SpellBookScript.EYE_FIRE and _get_eye_fire_target() == null:
		status_changed.emit("Eye Fire found no target")
		return
	if not GameState.spend_mp(int(spell.get("mp_cost", 0))):
		status_changed.emit("Not enough MP")
		return

	_apply_spell_effect(spell_id, spell)
	GameState.set_spell_cooldown(spell_id, int(spell.get("recast_turns", 0)))


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
	launch_sequence_id += 1
	for layer in [grid_layer, obstacle_layer, resource_layer, enemy_layer, ball_layer]:
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
	if not _is_players_turn():
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


func _row_for_y(y_position: float) -> int:
	var row := int(floor((y_position - board_origin.y) / cell_size.y))
	return clampi(row, 0, grid_size.y - 1)


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


func _spawn_sp_nodes(sp_entries: Array) -> void:
	for entry in sp_entries:
		var cell := Vector2i.ZERO
		var value := 1
		if entry is Dictionary:
			cell = _array_to_vec2i(entry.get("cell", [0, 0]))
			value = int(entry.get("value", 1))
		else:
			cell = _array_to_vec2i(entry)
		var sp_node := SPNodeScene.instantiate()
		sp_node.position = cell_to_world(cell)
		sp_node.sp_value = value
		resource_layer.add_child(sp_node)


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
		if enemy.has_method("apply_phase_difficulty"):
			enemy.apply_phase_difficulty(GameState.current_phase)
		enemies.append(enemy)


func _apply_spell_effect(spell_id: String, spell: Dictionary) -> void:
	match spell_id:
		SpellBookScript.EYE_FIRE:
			var target = _get_eye_fire_target()
			_damage_enemy(target, 20)
			status_changed.emit("Eye Fire")
		SpellBookScript.EYE_STARSTORM:
			var hit_count := _damage_enemies_in_starstorm_area(10)
			status_changed.emit("Eye Starstorm hit %d" % hit_count)
		SpellBookScript.EYE_METEOR:
			var hit_count := _damage_all_enemies(15)
			status_changed.emit("Eye Meteor hit %d" % hit_count)
		SpellBookScript.EYE_CURE:
			GameState.heal(50)
			status_changed.emit("Eye Cure")
		SpellBookScript.EYE_ESUNA:
			GameState.clear_detrimental_effects_except_doom()
			status_changed.emit("Eye Esuna")
		SpellBookScript.EYE_LEVITATION:
			GameState.grant_floor_invulnerability(int(spell.get("effect_turns", 1)))
			status_changed.emit("Eye Levitation")
		SpellBookScript.EYE_WARD:
			GameState.grant_ward(int(spell.get("effect_turns", 1)))
			status_changed.emit("Eye Ward")
		SpellBookScript.EYE_RERAISE:
			GameState.grant_reraise(99)
			status_changed.emit("Eye Reraise")


func _get_eye_fire_target():
	var target = null
	var best_x := -INF
	for enemy in enemies:
		if not is_instance_valid(enemy):
			continue
		if _row_for_y(enemy.position.y) != player_row:
			continue
		if enemy.position.x < get_launch_position().x and enemy.position.x > best_x:
			best_x = enemy.position.x
			target = enemy
	return target


func _damage_enemies_in_starstorm_area(damage: int) -> int:
	var center_cell := Vector2i(max(0, grid_size.x - 1 - 8), player_row)
	var center := cell_to_world(center_cell)
	var area := Rect2(center - cell_size * 1.5, cell_size * 3.0)
	var hit_count := 0
	for enemy in enemies.duplicate():
		if is_instance_valid(enemy) and area.has_point(enemy.position):
			_damage_enemy(enemy, damage)
			hit_count += 1
	return hit_count


func _damage_all_enemies(damage: int) -> int:
	var hit_count := 0
	for enemy in enemies.duplicate():
		if is_instance_valid(enemy):
			_damage_enemy(enemy, damage)
			hit_count += 1
	return hit_count


func _damage_enemy(enemy, damage: int) -> void:
	var defeated: bool = enemy.take_damage(damage)
	if defeated:
		enemies.erase(enemy)
		_check_level_clear()


func _launch(direction: Vector2) -> void:
	if active_balls.size() > 0 or direction.length_squared() == 0.0:
		return
	launch_sequence_id += 1
	var current_launch_id := launch_sequence_id
	trajectory_preview.clear_path()
	combo_system.begin_launch()
	var ball_count: int = max(1, GameState.sp_points)
	for i in range(ball_count):
		_spawn_ball(direction)
		if i < ball_count - 1:
			await get_tree().create_timer(0.12).timeout
	status_changed.emit("Launched %d ball%s" % [ball_count, "" if ball_count == 1 else "s"])
	_start_ball_timeout(current_launch_id)


func _spawn_ball(direction: Vector2) -> void:
	var ball := BallScene.instantiate()
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
	_despawn_ball(ball, "Ready")


func _on_ball_bounced(ball, _position: Vector2) -> void:
	if _should_despawn_at_player_wall(ball):
		_despawn_ball(ball, "Ball returned")
		return
	_check_obstacle_bounce(ball)


func _despawn_ball(ball, message: String) -> void:
	if not is_instance_valid(ball):
		return
	ball.active = false
	active_balls.erase(ball)
	ball.queue_free()
	if active_balls.is_empty():
		_end_player_turn(message)


func _despawn_all_balls(message: String) -> void:
	if active_balls.is_empty():
		return
	for ball in active_balls.duplicate():
		if is_instance_valid(ball):
			ball.active = false
			ball.queue_free()
	active_balls.clear()
	_end_player_turn(message)


func _start_ball_timeout(current_launch_id: int) -> void:
	await get_tree().create_timer(ball_timeout_seconds).timeout
	if current_launch_id != launch_sequence_id or active_balls.is_empty():
		return
	_despawn_all_balls("Ball timeout")


func _end_player_turn(message: String) -> void:
	combo_system.end_launch()
	GameState.tick_turn_effects()
	status_changed.emit(message)
	var advanced := GameState.complete_side_turn(GameState.TURN_PLAYER)
	if advanced:
		return
	_resolve_enemy_turn()


func _resolve_enemy_turn() -> void:
	if enemy_turn_resolving or GameState.current_turn_owner != GameState.TURN_ENEMIES:
		return
	enemy_turn_resolving = true
	trajectory_preview.clear_path()
	await get_tree().create_timer(0.35).timeout
	var total_damage := 0
	for enemy in enemies:
		if is_instance_valid(enemy):
			total_damage += int(enemy.attack_damage)
	if total_damage > 0:
		GameState.take_damage(total_damage, false)
		status_changed.emit("Enemies attack for %d" % total_damage)
	else:
		status_changed.emit("No enemies remain")
	await get_tree().create_timer(0.25).timeout
	enemy_turn_resolving = false
	if GameState.player_hp <= 0:
		GameState.complete_side_turn(GameState.TURN_ENEMIES)
		GameState.end_run()
		return
	var advanced := GameState.complete_side_turn(GameState.TURN_ENEMIES)
	if not advanced:
		status_changed.emit("Player turn")


func _should_despawn_at_player_wall(ball) -> bool:
	if not is_instance_valid(ball):
		return false
	var bounds := get_board_bounds()
	var right_wall_x := bounds.end.x - BallPhysicsScript.BALL_RADIUS
	if absf(ball.position.x - right_wall_x) > 2.0:
		return false
	return _row_for_y(ball.position.y) == player_row


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
		status_changed.emit("Enemies cleared")


func _on_aim_started(position: Vector2) -> void:
	if not _is_players_turn():
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
	if not _is_players_turn():
		return
	is_launching = false
	status_changed.emit("Aim cancelled")


func _on_restart_round_requested() -> void:
	if not _is_players_turn():
		return
	is_launching = false
	launch_sequence_id += 1
	load_level(level_id)
	status_changed.emit("Round restarted")


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
	return active_balls.is_empty() and not level_is_cleared and not enemy_turn_resolving and GameState.current_turn_owner == GameState.TURN_PLAYER


func _on_phase_changed(phase: int, awarded_gem: bool) -> void:
	load_level(level_id)
	var message := "Phase %d" % phase
	if awarded_gem:
		message += " - Golden gem earned"
	status_changed.emit(message)


func _array_to_vec2i(value) -> Vector2i:
	if value is Array and value.size() >= 2:
		return Vector2i(int(value[0]), int(value[1]))
	return Vector2i.ZERO
