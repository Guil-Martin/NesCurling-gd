class_name BaseLevel extends Node

@onready var camera_3d: FreeLookCamera = $Camera3D

var camera_spot: Marker3D
var table_spot: Marker3D

var current_level: PackedScene
var current_table: PackedScene
var current_capsule: PackedScene

func _ready() -> void:
	# Loads and instantiate the chosen level then add it to the scene
	current_level = load(GameState.current_level)
	var current_level_i: Node3D = current_level.instantiate()
	add_child(current_level_i)
	
	# Loads and instantiate the chosen table then add it to the scene
	current_table = load(GameState.current_table)
	var current_table_i: NesTable = current_table.instantiate()
	add_child(current_table_i)
	
	# Get markers to place table & cam
	var marker_table = current_level_i.get_node("table_spot")
	var marker_cam = current_level_i.get_node("camera_spot")
	
	# Move chosen table to the level's table marker
	current_table_i.position = marker_table.position
	current_table_i.rotation = marker_table.rotation
	
	# Move camera to the level's camera marker then 180 on z axis
	camera_3d.position = marker_cam.position
	camera_3d.rotation = marker_cam.rotation
	camera_3d.rotate_object_local(Vector3(0, 1, 0), PI)
	
	current_capsule = load(GameState.current_capsule)
