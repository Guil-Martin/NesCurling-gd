class_name NesTable extends Node3D

@export var spawn_point: Marker3D
@export var score_zone: Area3D
@export var placement_cols: Array[StaticBody3D]

# Score zone add capsule
func _on_score_zone_body_entered(body: Node3D) -> void:
	if body is NesCapsule:
		GameState.add_to_score_zone(body)

# Score zone remove capsule
func _on_score_zone_body_exited(body: Node3D) -> void:
	if body is NesCapsule:
		GameState.remove_from_score_zone(body)
