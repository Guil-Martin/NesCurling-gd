class_name NesTable extends Node3D

@export var spawn_point: Marker3D

func _ready() -> void:
	print("Table ready, spawn_point => ", spawn_point)
