class_name UIGame extends Control

@onready var debug_state: Label = $debug_state

@onready var labelFPS: Label = %labelFPS
@onready var label_turn: Label = %label_turn
@onready var label_round: Label = %label_round
@onready var cap_icons_container: HBoxContainer = %cap_icons_container
@onready var players_box: VBoxContainer = %ui_players_box
@onready var power_bar: ProgressBar = %power_bar

@onready var panel_msg: PanelContainer = %panel_msg
@onready var next_turn_message: RichTextLabel = %next_turn_message
@onready var timer_msg_display: Timer = $timer_msg_display

const CAP_ICON = preload("res://ui/components/ui_game/CapIcon.tscn")
const NES_CAPSULE = preload("res://scenes/nes_capsules/base/nes_capsule.tscn")
const UI_GAME_P_BOX = preload("res://ui/components/ui_game/UIGamePBox.tscn")

func _ready() -> void:
	GameState.game_ui = self
	GameState.power_bar = power_bar
	
	for player: Player in GameState.players:
		var pbox: UIGamePBox = UI_GAME_P_BOX.instantiate()
		players_box.add_child(pbox)
		pbox.setup_player_box(player)
		
	update_UI()


func set_score_players(players: Array[Player]) -> void:
	var player_boxes = players_box.get_children()
	for i in range(player_boxes.size()):
		var player_box: UIGamePBox = player_boxes[i]
		player_box.player_score.text = "Score: " + str(players[i].score)


func set_remaining_capsules(players: Array[Player]) -> void:
	var player_boxes = players_box.get_children()
	for i in range(player_boxes.size()):
		var player_box: UIGamePBox = player_boxes[i]
		player_box.remaining_capsules.text = "Capsules: " + str(players[i].remaining_capsules)


func update_UI() -> void:
	set_turn(GameState.current_turn)
	set_round(GameState.current_round)
	set_score_players(GameState.players)
	set_remaining_capsules(GameState.players)
	# TODO Set outline on the current player container


# Display the name of the next player
func display_message() -> void:
	next_turn_message.text = "[center]Tour [color=gold]%s[/color], round [color=gold]%s[/color]\nj%s : Au tour de [color=%s][b]%s[/b][/color] ![/center]" % [GameState.current_turn, GameState.current_round, GameState.current_player.slot + 1, GameState.player_colors[GameState.current_player.slot].to_html(), GameState.current_player.name]
	panel_msg.visible = true
	timer_msg_display.start()


# Triggered after 3 seconds when display_message() is called
func _on_timer_msg_display_timeout() -> void:
	panel_msg.visible = false


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
	# Makes sure the state is SPECTATING to spawn a capsule
	if GameState.state == GameState.States.SPECTATING:
		GameState.spawn_capsule()


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
