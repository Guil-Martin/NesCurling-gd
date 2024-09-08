class_name UIGame extends Control

@onready var labelFPS: Label = %labelFPS

const NES_CAPSULE = preload("res://scenes/nes_capsules/base/nes_capsule.tscn")

# Player box
@onready var players_box: VBoxContainer = %ui_players_box
const UI_GAME_P_BOX = preload("res://ui/components/UIGamePBox.tscn")

func _ready() -> void:
	for player in GameState.players:
		var pbox: UIGamePBox = UI_GAME_P_BOX.instantiate()
		players_box.add_child(pbox)
		pbox.setup_player_box(player)


func _process(delta: float) -> void:
	labelFPS.set_text("FPS %d" % Engine.get_frames_per_second())


# SpawnCapsule button (Test)
func _on_spawn_capsule_pressed() -> void:
	var current_table: NesTable
	var spawn_point: Marker3D
	current_table = get_tree().current_scene.get_node("NesTable")
	spawn_point = current_table.get_node("%spawn_point")
	
	var nes_capsule_i: NesCapsule = NES_CAPSULE.instantiate()
	owner.add_child(nes_capsule_i)
	nes_capsule_i.global_transform.origin = spawn_point.global_transform.origin
	#nes_capsule_i.translate(spawn_point.global_transform.origin)
	

func _on_delete_all_pressed() -> void:
	for child in get_parent().get_children():
		if child is NesCapsule:
			child.queue_free()
