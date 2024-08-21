class_name NesCapsule extends Node3D

func _on_nes_capsulerigid_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("Pressed Left Mouse Button")
