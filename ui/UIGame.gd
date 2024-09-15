class_name UIGame extends Control

@onready var labelFPS: Label = %labelFPS
@onready var label_turn: Label = %label_turn
@onready var label_round: Label = %label_round
@onready var cap_icons_container: HBoxContainer = %cap_icons_container
const CAP_ICON = preload("res://ui/components/CapIcon.tscn")
const NES_CAPSULE = preload("res://scenes/nes_capsules/base/nes_capsule.tscn")

# Player box
@onready var players_box: VBoxContainer = %ui_players_box
const UI_GAME_P_BOX = preload("res://ui/components/UIGamePBox.tscn")


func _ready() -> void:
	GameState.game_ui = self
	for player in GameState.players:
		var pbox: UIGamePBox = UI_GAME_P_BOX.instantiate()
		players_box.add_child(pbox)
		pbox.setup_player_box(player)


func _process(delta: float) -> void:
	labelFPS.set_text("FPS %d" % Engine.get_frames_per_second())


func set_round(round: int) -> void:
	label_round.text = "Round: " + str(round)


func set_turn(turn: int) -> void:
	label_turn.text = "Turn: " + str(round)
	

# SpawnCapsule button (Test)
func _on_spawn_capsule_pressed() -> void:
	var current_table: NesTable
	var spawn_point: Marker3D
	current_table = get_tree().current_scene.get_node("NesTable")
	spawn_point = current_table.get_node("%spawn_point")
	
	# Instantiate a nes capsule object
	var nes_capsule_i: NesCapsule = NES_CAPSULE.instantiate()
	owner.add_child(nes_capsule_i)
	nes_capsule_i.global_transform.origin = spawn_point.global_transform.origin
	

func _on_delete_all_pressed() -> void:
	for child in get_parent().get_children():
		if child is NesCapsule:
			child.queue_free()


# Possess last capsule added if it exists
func _on_possess_pressed() -> void:
	if GameState.last_capsule != null:
		GameState.last_capsule.possess()


# Add icons with shader color change for each capsule in the zone
func update_capsule_icons() -> void:
	# Remove all icons from the cap_icons_container container
	for child: CapIcon in cap_icons_container.get_children():
		child.queue_free()
	
	# Iterate through the capsule in the zone then add a CapIcon object with its color from the NesCapsule object
	for capsule: NesCapsule in GameState.within_score_zone:
		var cap_icon_i: CapIcon = CAP_ICON.instantiate()
		cap_icon_i.change_icon_color(capsule.color)
		cap_icons_container.add_child(cap_icon_i)
