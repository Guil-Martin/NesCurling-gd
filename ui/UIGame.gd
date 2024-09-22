class_name UIGame extends Control

@onready var debug_state: Label = $debug_state

@onready var labelFPS: Label = %labelFPS
@onready var label_turn: Label = %label_turn
@onready var label_round: Label = %label_round
@onready var cap_icons_container: HBoxContainer = %cap_icons_container
@onready var players_box: VBoxContainer = %ui_players_box
@onready var power_bar: ProgressBar = %power_bar

const CAP_ICON = preload("res://ui/components/ui_game/CapIcon.tscn")
const NES_CAPSULE = preload("res://scenes/nes_capsules/base/nes_capsule.tscn")
const UI_GAME_P_BOX = preload("res://ui/components/ui_game/UIGamePBox.tscn")

func _ready() -> void:
	GameState.game_ui = self
	GameState.power_bar = power_bar
	
	for player in GameState.players:
		var pbox: UIGamePBox = UI_GAME_P_BOX.instantiate()
		players_box.add_child(pbox)
		pbox.setup_player_box(player)
		
	set_turn(GameState.turn)
	set_round(GameState.round)


func _process(delta: float) -> void:
	labelFPS.set_text("FPS %d" % Engine.get_frames_per_second())
	# TODO to remove prod
	debug_state.text = GameState.States.keys()[GameState.state]


func set_round(round: int) -> void:
	label_round.text = "Round: " + str(round)


func set_turn(turn: int) -> void:
	label_turn.text = "Turn: " + str(turn)
	

# SpawnCapsule button (Test)
func _on_spawn_capsule_pressed() -> void:
	# Instantiate a nes capsule object on the Marker3D spawn point of the current table
	if GameState.main_level.main_camera.current:
		var nes_capsule_i: NesCapsule = NES_CAPSULE.instantiate()
		owner.add_child(nes_capsule_i)
		nes_capsule_i.global_transform.origin = GameState.main_level.current_table.spawn_point.global_transform.origin
		#nes_capsule_i.translate(GameState.main_level.current_table.spawn_point.global_transform.origin)
	

func _on_delete_all_pressed() -> void:
	if GameState.main_level.main_camera.current:
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
