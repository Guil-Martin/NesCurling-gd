class_name NesCapsule extends RigidBody3D

var player_owner: Player = GameState.players[0]
var color: Color = Color.GRAY

@onready var nes_capsule: MeshInstance3D = $nes_capsule
@onready var spring_arm_3d: SpringArm3D = $SpringArm3D
@onready var camera_3d: Camera3D = $SpringArm3D/Camera3D
@onready var collision: CollisionShape3D = $collision

# Movement placement
var possessed: bool = false;
@export var move_speed: float = 3.0
@export var turn_speed: float = 2.0
@export var upright_strength: float = 2.0
@export var zqsd_mode: bool = false # Set this to true to switch to ZQSD

# SpringArm zoom settings
@export var max_arm_length: float = 1.5
@export var min_arm_length: float = 0.5
@export var zoom_speed: float = 0.1

func _ready() -> void:
	# TODO player owner
	#player_owner = the current palyer
	GameState.last_capsule = self
	
	# Set color for this capsule, copy material so it's different from the base one (or it'll change the material color for all capsule instances)
	var material = nes_capsule.get_active_material(0).duplicate()
	color = Color(randf(), randf(), randf())
	material.albedo_color = color
	nes_capsule.set_surface_override_material(0, material)


func possess() -> void:
	if !possessed:
		possessed = true
		
		# TODO rotation does not work
		print("self ", self)
		print("last_capsule ", GameState.last_capsule)
		global_rotation = Vector3.ZERO
		rotation = Vector3.ZERO
		print("global_rotation ",global_rotation)
		
		lock_rotation = true
		camera_3d.make_current()
	else:
		possessed = false
		lock_rotation = false
		
	GameState.placement(self)


# On click, push opposite to the camera, testing purpose
func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var impulse_strength = 1.8
		var camera_position: Vector3 = GameState.main_level.main_camera.global_transform.origin
		var rigid_body_position: Vector3 = global_transform.origin
		var direction_to_camera: Vector3 = camera_position - rigid_body_position
		direction_to_camera.y = 0.01
		var opposite_direction: Vector3 = -direction_to_camera.normalized()
	
		apply_central_impulse(opposite_direction * impulse_strength)


func _physics_process(delta: float) -> void:
	get_move_input(delta)

	
func get_move_input(delta: float) -> void:
	if possessed:
		
		var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		var direction: Vector3 = (spring_arm_3d.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

		if input_dir != Vector2(0,0):
			
			# Turn the 3D model in relation to the camera
			var cam_direction: float = camera_3d.rotation_degrees.y - rad_to_deg(input_dir.angle()) + 90
			nes_capsule.rotation_degrees.y = cam_direction
			collision.rotation_degrees.y = cam_direction
			
			# Apply force in the direction of movement
			apply_central_force(direction * move_speed)

		# Handle camera
		handle_camera_zoom()


# Zoom the camera in and out by changing the SpringArm length
func handle_camera_zoom() -> void:
	var scroll_input: float = 0.0

	if Input.is_action_pressed("cam_forward"):
		scroll_input = -0.1
	elif Input.is_action_pressed("cam_backward"):
		scroll_input = 0.1
	elif Input.is_action_pressed("cam_left"):
		spring_arm_3d.rotate_y(deg_to_rad(2))
	elif Input.is_action_pressed("cam_right"):
		spring_arm_3d.rotate_y(deg_to_rad(-2))

	spring_arm_3d.spring_length = clamp(spring_arm_3d.spring_length + scroll_input * zoom_speed * get_physics_process_delta_time(), min_arm_length, max_arm_length)


#func _to_string() -> String:
	#return "Owned: " + player_owner.name
