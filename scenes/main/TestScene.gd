extends Node2D
## Test Scene - Phase 1.3 Documentation
## Basic test scene with placeholder graphics for Beholder Adventure

@onready var ball: Node2D = $Ball
@onready var ball_sprite: ColorRect = $Ball/BallSprite
@onready var trajectory_line: Line2D = $Ball/TrajectoryLine
@onready var status_label: Label = $UI/StatusLabel
@onready var game_board: Node2D = $GameBoard

# Ball state
var ball_velocity: Vector2 = Vector2.ZERO
var is_ball_moving: bool = false
const BALL_SPEED: float = 400.0

# Bounds
var bounds_min: Vector2 = Vector2(240, 90)
var bounds_max: Vector2 = Vector2(1680, 990)


func _ready() -> void:
	print("🍜 Test Scene Loaded - Beholder Adventure")
	print("   Phase 1.3 Documentation")
	print("   Press SPACE to launch ball")
	update_status("Ready - Press SPACE")


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_SPACE:
			launch_ball()
		elif event.keycode == KEY_R:
			reset_ball()


func _process(delta: float) -> void:
	if is_ball_moving:
		# Move ball
		ball.position += ball_velocity * delta
		
		# Bounce off walls
		check_wall_collisions()
		
		# Update status
		update_status("Ball Moving: %.0f, %.0f" % [ball.position.x, ball.position.y])


func launch_ball() -> void:
	if is_ball_moving:
		return
	
	# Launch upward with slight random angle
	var angle := deg_to_rad(-90 + randf_range(-15, 15))
	ball_velocity = Vector2(cos(angle), sin(angle)) * BALL_SPEED
	is_ball_moving = true
	
	# Change ball color to indicate launch
	ball_sprite.color = Color(0.2, 0.9, 0.2, 1.0)
	
	print("🎱 Ball Launched!")
	update_status("Ball Launched!")


func reset_ball() -> void:
	ball.position = Vector2(960, 540)
	ball_velocity = Vector2.ZERO
	is_ball_moving = false
	ball_sprite.color = Color(0.9, 0.2, 0.2, 1.0)
	
	print("🔄 Ball Reset")
	update_status("Reset - Press SPACE")


func check_wall_collisions() -> void:
	# Left wall
	if ball.position.x <= bounds_min.x:
		ball.position.x = bounds_min.x
		ball_velocity.x = abs(ball_velocity.x)
		bounce_effect()
	
	# Right wall
	if ball.position.x >= bounds_max.x:
		ball.position.x = bounds_max.x
		ball_velocity.x = -abs(ball_velocity.x)
		bounce_effect()
	
	# Top wall
	if ball.position.y <= bounds_min.y:
		ball.position.y = bounds_min.y
		ball_velocity.y = abs(ball_velocity.y)
		bounce_effect()
	
	# Bottom wall
	if ball.position.y >= bounds_max.y:
		ball.position.y = bounds_max.y
		ball_velocity.y = -abs(ball_velocity.y)
		bounce_effect()


func bounce_effect() -> void:
	# Flash ball color on bounce
	ball_sprite.color = Color(1.0, 1.0, 0.2, 1.0)
	
	# Create simple tween for color fade
	var tween := create_tween()
	tween.tween_property(ball_sprite, "color", Color(0.2, 0.9, 0.2, 1.0), 0.1)
	
	print("💥 Bounce!")


func update_status(text: String) -> void:
	if status_label:
		status_label.text = "Status: %s\nBall Position: (%.0f, %.0f)" % [text, ball.position.x, ball.position.y]


## Draw debug grid lines
func _draw() -> void:
	# Draw bounds rectangle
	draw_rect(Rect2(bounds_min, bounds_max - bounds_min), Color(1, 1, 1, 0.1), false, 2.0)
	
	# Draw center point
	draw_circle(Vector2(960, 540), 5.0, Color(1, 0, 0, 0.5))
