extends RefCounted
class_name BallPhysics

const BALL_SPEED: float = 620.0
const MAX_BOUNCES: int = 10
const BOUNCE_DAMPING: float = 1.0
const BALL_RADIUS: float = 14.0


static func reflect_velocity(velocity: Vector2, normal: Vector2, damping: float = BOUNCE_DAMPING) -> Vector2:
	return velocity.bounce(normal).normalized() * velocity.length() * damping


static func predict_path(
	start_position: Vector2,
	direction: Vector2,
	bounds: Rect2,
	max_bounces: int = MAX_BOUNCES,
	max_distance: float = 2400.0
) -> PackedVector2Array:
	var points := PackedVector2Array([start_position])
	if direction.length_squared() == 0.0:
		return points

	var pos := start_position
	var dir := direction.normalized()
	var distance_left := max_distance

	for _i in range(max_bounces + 1):
		var hit_distance := distance_left
		var normal := Vector2.ZERO

		if dir.x > 0.0:
			var d := (bounds.end.x - BALL_RADIUS - pos.x) / dir.x
			if d >= 0.0 and d < hit_distance:
				hit_distance = d
				normal = Vector2.LEFT
		elif dir.x < 0.0:
			var d := (bounds.position.x + BALL_RADIUS - pos.x) / dir.x
			if d >= 0.0 and d < hit_distance:
				hit_distance = d
				normal = Vector2.RIGHT

		if dir.y > 0.0:
			var d := (bounds.end.y - BALL_RADIUS - pos.y) / dir.y
			if d >= 0.0 and d < hit_distance:
				hit_distance = d
				normal = Vector2.UP
		elif dir.y < 0.0:
			var d := (bounds.position.y + BALL_RADIUS - pos.y) / dir.y
			if d >= 0.0 and d < hit_distance:
				hit_distance = d
				normal = Vector2.DOWN

		pos += dir * hit_distance
		points.append(pos)
		distance_left -= hit_distance
		if normal == Vector2.ZERO or distance_left <= 0.0:
			break
		dir = dir.bounce(normal).normalized()

	return points
