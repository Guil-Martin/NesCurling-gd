class_name NesCapsule extends RigidBody3D

var player_owner: Player = GameState.players[0]
var color: Color = Color.GRAY

@onready var nes_capsule: MeshInstance3D = $nesCapsule
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var collision_shape_3d_2: CollisionShape3D = $CollisionShape3D2
@onready var shoot_timer: Timer = $ShootTimer

@onready var cam_root: Node3D = $camRoot
@onready var cam_yaw: Node3D = %camYaw
@onready var cam_pitch: Node3D = %camPitch
@onready var spring_arm_3d: SpringArm3D = %SpringArm3D
@onready var camera_3d: Camera3D = %Camera3D

# Camera
var yaw: float = 0
var pitch: float = 0
var yaw_sensitivity: float = 0.07
var pitch_sensitivity: float = 0.07
var yaw_acceleration: float = 15.0
var pitch_acceleration: float = 15.0
var pitch_min: float = -10
var pitch_max: float = 75.0

# SpringArm zoom settings
var max_arm_length: float = 1.5
var min_arm_length: float = 0.5
var zoom_speed: float = 3.0
var max_y_offset: float = 1.5
var min_y_offset: float = 0.4
var y_offset_speed: float = 2.0

# Movement placement
var possessed: bool = false;
var move_speed: float = 1.4
var turn_speed: float = 2.0
var upright_strength: float = 2.0
var zqsd_mode: bool = false # Set this to true to switch to ZQSD

# Shooting
var is_charging: bool = false
var is_filling: bool = true  # Track if the bar is filling or emptying
var power_value: float = 0.0  # Current power value (0.0 to 1.0)
var power_mult: float = 1.4
var power_speed: float = 1.5  # Speed at which the bar fills/empties


func _ready() -> void:
	# TODO player owner
	#player_owner = the current palyer
	GameState.last_capsule = self
	
	# TODO check current player remaining capsule then take its informations to change the skin of the spawned capsule
	# Set color for this capsule, copy material so it's different from the base one (or it'll change the material color for all capsule instances)
	var material: Material = nes_capsule.get_active_material(0).duplicate()
	
	# If null, set random color
	if GameState.current_player.capsule_skin:
		material.albedo_texture = GameState.current_player.capsule_skin
	else:
		color = Color(randf(), randf(), randf())
		material.albedo_color = color
		
	nes_capsule.set_surface_override_material(0, material)


func _process(delta: float) -> void:
	if is_charging:
		update_power_bar(delta)


func _physics_process(delta: float) -> void:
	move_camera(delta)
	get_move_input(delta)
	handle_camera_zoom()


# Possess the capsule and enable movement in the placement zone
func possess() -> void:
	possessed = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	lock_rotation = true
	global_rotation = Vector3.ZERO
	global_position = (Vector3(global_position.x, global_position.y +0.1, global_position.z))
	camera_3d.make_current()
	
	GameState.toggle_table_placement_collisions(true)
	GameState.state = GameState.States.PLACING


func _input(event: InputEvent) -> void:
	if GameState.state == GameState.States.PLACING:
		# Activate the charging state to shoot the capsule, display bar and set is_charging to true
		if event is InputEventMouseButton:
			# Charge shoot holding the left click
			if event.button_index == MOUSE_BUTTON_LEFT:
				if event.pressed:
					GameState.power_bar.visible = true
					is_charging = true
				else:
					if is_charging:
						on_power_released()
			# Cancel charge with right click
			if event.button_index == MOUSE_BUTTON_RIGHT:
				GameState.power_bar.visible = false
				is_charging = false
				power_value = 0
					
		elif event is InputEventMouseMotion:
			yaw += -event.relative.x * yaw_sensitivity
			pitch += event.relative.y * pitch_sensitivity


func on_power_released() -> void:
	GameState.state = GameState.States.SHOOTING
	GameState.toggle_table_placement_collisions(false)
	GameState.switch_camera("top")
	lock_rotation = false
	
	# Get the current value of the progress bar and set power_value
	power_value = GameState.power_bar.material.get_shader_parameter("value")
	
	# Stop charging when button is released and Reset power bar value
	is_charging = false
	GameState.power_bar.material.set_shader_parameter("value", 0)
	GameState.power_bar.visible = false
	
	#GameState.state = GameState.States.PLACING
	
	# Shoot capsule
	shoot_capsule()


# SHoot capsule in the camera direction
func shoot_capsule() -> void:
	var impulse_strength: float = power_value * power_mult
	power_value = 0
	var camera_position: Vector3 = camera_3d.global_transform.origin
	var direction_to_camera: Vector3 = camera_position - global_transform.origin
	direction_to_camera.y = 0.01
	var opposite_direction: Vector3 = -direction_to_camera.normalized()

	apply_central_impulse(opposite_direction * impulse_strength)
	
	shoot_timer.start()


# Uses the ShootTimer node, 2 seconds after the shoot this function triggers
func _on_shoot_timer_timeout() -> void:
	# TODO check is there is a capsule in the placement zone then move it is so
	possessed = false
	GameState.next_turn()
	GameState.spawn_capsule() # TODO test, to remove


# In _process, each frame we fill and deplete the power bar using the value shader parameter until the click is released
func update_power_bar(delta: float) -> void:
	# Fill or empty the bar based on current state
	if is_filling:
		power_value += power_speed * delta
		if power_value >= 1.0:
			power_value = 1.0
			is_filling = false  # Start emptying when full
	else:
		power_value -= power_speed * delta
		if power_value <= 0.0:
			power_value = 0.0
			is_filling = true  # Start filling when empty
	
	GameState.power_bar.material.set_shader_parameter("value", power_value)


# Move camera horizontally and vertically while the capsule is possessed
func move_camera(delta: float) -> void:
	if possessed:
		pitch = clamp(pitch, pitch_min, pitch_max)
		cam_yaw.rotation_degrees.y = lerp(cam_yaw.rotation.y, yaw, yaw_acceleration * delta)
		cam_pitch.rotation_degrees.x = lerp(cam_pitch.rotation_degrees.x, pitch, pitch_acceleration * delta)
		# Settings values directly with no smooth camera
		#cam_yaw.rotation_degrees.y = yaw
		#cam_pitch.rotation_degrees.x = pitch
		
		nes_capsule.rotation_degrees.y = cam_yaw.rotation_degrees.y
		collision_shape_3d.rotation_degrees.y = cam_yaw.rotation_degrees.y
		collision_shape_3d_2.rotation_degrees.y = cam_yaw.rotation_degrees.y


# Move the capsule
func get_move_input(delta: float) -> void:
	if possessed && !is_charging && GameState.state == GameState.States.PLACING:
		var input_dir: Vector2 = Input.get_vector("move_right", "move_left", "move_backward", "move_forward" )
		var direction: Vector3 = (cam_yaw.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if input_dir != Vector2(0,0):
			# Turn the 3D model in relation to the camera
			var cam_direction: float = camera_3d.rotation_degrees.y - rad_to_deg(input_dir.angle()) + 90
			# Apply force in the direction of movement
			apply_central_force(direction * move_speed)


# Zoom the camera in and out by changing the SpringArm length
func handle_camera_zoom() -> void:
	var scroll_input: float = 0.0
	
	if Input.is_action_just_released("cam_forward"):
		scroll_input = -1
	elif Input.is_action_just_released("cam_backward"):
		scroll_input = 1
		
	# Update the spring arm's Y position by adjusting its translation along the y-axis
	var new_y_offset = clamp(spring_arm_3d.transform.origin.y + scroll_input * y_offset_speed * get_physics_process_delta_time(), min_y_offset, max_y_offset)
	spring_arm_3d.transform.origin.y = new_y_offset

	# Zoom
	#spring_arm_3d.spring_length = clamp(spring_arm_3d.spring_length + scroll_input * zoom_speed * get_physics_process_delta_time(), min_arm_length, max_arm_length)


#func _to_string() -> String:
	#return "Owned: " + player_owner.name
