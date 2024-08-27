class_name UIGame extends Control

@onready var label_fps_counter: Label = $margin/label_fps_counter

var nesCapsule = preload("res://models/nesCapsule/nes_capsule.tscn")
@onready var level_office: Node3D = $"../level_office"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label_fps_counter.set_text("FPS %d" % Engine.get_frames_per_second())

# SpawnCapsule button
func _on_spawn_capsule_pressed() -> void:
	var spawnPoint = Vector3(randf_range(0.5, 1.8), 1, randf_range(-3.4, -3))
	
	var nesCapsuleInstance: NesCapsule = nesCapsule.instantiate()
	nesCapsuleInstance.translate(spawnPoint)
	
	owner.add_child(nesCapsuleInstance)

func _on_delete_all_pressed() -> void:
	for child in get_parent().get_children():
		if child is NesCapsule:
			child.queue_free()
