class_name MainLevel extends Node

@onready var main_camera: FreeLookCamera = $Camera3D

var marker_table: Marker3D
var marker_cam: Marker3D
var score_zone: Area3D
	
var current_level: BaseLevel
var current_table: NesTable
var current_capsule: NesCapsule

func _ready() -> void:
	# Self ref in GameState to be accessed from everywhere
	GameState.main_level = self
	
	# Loads and instantiate the chosen level then add it to the scene
	var current_level_scn: PackedScene = load(GameState.current_level_path)
	current_level = current_level_scn.instantiate()
	add_child(current_level)
	
	# Loads and instantiate the chosen table then add it to the scene
	var current_table_scn: PackedScene = load(GameState.current_table_path)
	current_table = current_table_scn.instantiate()
	add_child(current_table)
	
	# Get current loaded level markers to place table & cam
	marker_table = current_level.table_spot
	marker_cam = current_level.camera_spot
	
	# Score zone
	score_zone = current_table.score_zone
	
	# Move chosen table to the level's table marker
	current_table.position = marker_table.position
	current_table.rotation = marker_table.rotation
	
	setup_camera()
	
	var current_capsule_scn: PackedScene = load(GameState.current_capsule_path)
	
	
# Move camera to the level's camera marker then 180 on z axis
func setup_camera() -> void:
	main_camera.position = marker_cam.position
	main_camera.rotation = marker_cam.rotation
	main_camera.rotate_object_local(Vector3(0, 1, 0), PI)
