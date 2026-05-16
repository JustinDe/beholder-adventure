extends Node
## InputHandler Autoload
## Cross-platform input abstraction for PC and Mobile

# Signals
signal aim_started(position: Vector2)
signal aim_updated(position: Vector2, delta: Vector2)
signal aim_ended(position: Vector2)
signal ball_fired(trajectory: Vector2)
signal action_cancelled
signal pause_toggled

# Input state
var is_aiming: bool = false
var aim_start_position: Vector2 = Vector2.ZERO
var current_position: Vector2 = Vector2.ZERO
var is_touch_device: bool = false

# Configuration
var aim_sensitivity: float = 1.0
var min_drag_distance: float = 50.0  # Minimum pixels to register as aim
var show_touch_feedback: bool = true

# Touch tracking
var touch_ids: Array[int] = []
var primary_touch_id: int = -1


func _ready() -> void:
	# Detect if we're on a touch device
	is_touch_device = DisplayServer.is_touchscreen_available()
	
	# Set up input action weights for mobile
	if is_touch_device:
		_setup_mobile_input()
	else:
		_setup_desktop_input()


func _setup_desktop_input() -> void:
	# Desktop defaults
	aim_sensitivity = 1.0
	show_touch_feedback = false


func _setup_mobile_input() -> void:
	# Mobile optimizations
	aim_sensitivity = 1.5  # Slightly more sensitive for touch
	show_touch_feedback = true


func _input(event: InputEvent) -> void:
	# Handle mouse input (PC)
	if event is InputEventMouseButton:
		_handle_mouse_button(event)
	elif event is InputEventMouseMotion:
		_handle_mouse_motion(event)
	
	# Handle touch input (Mobile)
	if event is InputEventScreenTouch:
		_handle_screen_touch(event)
	elif event is InputEventScreenDrag:
		_handle_screen_drag(event)
	
	# Handle keyboard
	if event is InputEventKey:
		_handle_key(event)


func _handle_mouse_button(event: InputEventMouseButton) -> void:
	if event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_start_aim(event.position)
		else:
			_end_aim(event.position)
	
	if event.button_index == MOUSE_BUTTON_RIGHT:
		if event.pressed:
			action_cancelled.emit()


func _handle_mouse_motion(event: InputEventMouseMotion) -> void:
	if is_aiming:
		current_position = event.position
		var delta = event.relative * aim_sensitivity
		aim_updated.emit(current_position, delta)


func _handle_screen_touch(event: InputEventScreenTouch) -> void:
	if event.pressed:
		# New touch started
		if primary_touch_id == -1:
			primary_touch_id = event.index
			_start_aim(event.position)
		touch_ids.append(event.index)
	else:
		# Touch ended
		if event.index in touch_ids:
			touch_ids.erase(event.index)
		
		if event.index == primary_touch_id:
			_end_aim(event.position)
			primary_touch_id = touch_ids[0] if touch_ids.size() > 0 else -1


func _handle_screen_drag(event: InputEventScreenDrag) -> void:
	if event.index == primary_touch_id and is_aiming:
		current_position = event.position
		var delta = event.relative * aim_sensitivity
		aim_updated.emit(current_position, delta)


func _handle_key(event: InputEventKey) -> void:
	if not event.pressed:
		return
	
	# Fire ball
	if Input.is_action_just_pressed("fire_ball"):
		_fire_ball()
	
	# Cancel action
	if Input.is_action_just_pressed("cancel"):
		action_cancelled.emit()
	
	# Pause toggle
	if Input.is_action_just_pressed("pause"):
		pause_toggled.emit()


## Start aiming action
func _start_aim(position: Vector2) -> void:
	is_aiming = true
	aim_start_position = position
	current_position = position
	aim_started.emit(position)


## End aiming action
func _end_aim(position: Vector2) -> void:
	if is_aiming:
		is_aiming = false
		aim_ended.emit(position)


## Fire the ball with current trajectory
func _fire_ball() -> void:
	if not is_aiming:
		return
	
	# Calculate trajectory based on aim
	var trajectory = _calculate_trajectory()
	ball_fired.emit(trajectory)
	is_aiming = false


## Calculate trajectory vector from aim input
func _calculate_trajectory() -> Vector2:
	var drag_vector = current_position - aim_start_position
	
	# Normalize and scale
	if drag_vector.length() > min_drag_distance:
		drag_vector = drag_vector.normalized() * min_drag_distance
	
	# Invert for intuitive aiming (pull back to shoot forward)
	return -drag_vector * aim_sensitivity


## Get current aim progress (0.0 to 1.0)
func get_aim_progress() -> float:
	if not is_aiming:
		return 0.0
	
	var drag_vector = current_position - aim_start_position
	var progress = drag_vector.length() / min_drag_distance
	return clamp(progress, 0.0, 1.0)


## Get aim direction as normalized vector
func get_aim_direction() -> Vector2:
	if not is_aiming:
		return Vector2.DOWN  # Default aim direction
	
	var drag_vector = current_position - aim_start_position
	if drag_vector.length() < min_drag_distance:
		return Vector2.DOWN
	
	return -drag_vector.normalized()


## Check if valid aim (minimum drag distance met)
func is_valid_aim() -> bool:
	if not is_aiming:
		return false
	
	var drag_vector = current_position - aim_start_position
	return drag_vector.length() >= min_drag_distance


## Reset input state
func reset_input_state() -> void:
	is_aiming = false
	aim_start_position = Vector2.ZERO
	current_position = Vector2.ZERO
	primary_touch_id = -1
	touch_ids.clear()


## Set sensitivity (for options menu)
func set_sensitivity(value: float) -> void:
	aim_sensitivity = clamp(value, 0.5, 2.0)


## Toggle touch feedback (for options menu)
func set_touch_feedback(enabled: bool) -> void:
	show_touch_feedback = enabled
