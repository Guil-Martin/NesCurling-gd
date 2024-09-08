class_name NesCapsule extends RigidBody3D

@onready var nes_capsule: MeshInstance3D = $nes_capsule

func _ready() -> void:
	# Copy material or it'll change the material for all capsule instances
	var material = nes_capsule.get_active_material(0).duplicate()
	material.albedo_color = Color(randf(), randf(), randf())
	nes_capsule.set_surface_override_material(0, material)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		# Push every spawned capsule on the map
		apply_central_impulse(Vector3(0, 0, 0.4))


# On click, push opposite to the camera, testing purpose
func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var scene_camera: FreeLookCamera = get_parent().get_node("Camera3D")
		var impulse_strength = 2
		var camera_position: Vector3 = scene_camera.global_transform.origin
		var rigid_body_position: Vector3 = global_transform.origin
		var direction_to_camera: Vector3 = camera_position - rigid_body_position
		direction_to_camera.y = 0.01
		var opposite_direction: Vector3 = -direction_to_camera.normalized()
	
		apply_central_impulse(opposite_direction * impulse_strength)
