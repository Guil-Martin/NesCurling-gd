extends Node

var debug: bool = false
var platformWeb = OS.has_feature("web") or OS.has_feature("web_android") or OS.has_feature("web_ios")

const NES_CAPSULE = preload("res://scenes/nes_capsules/base/nes_capsule.tscn")

func _ready() -> void:
	print("gamestate platformWeb ", platformWeb)
	
	# Set default values
	const SELECT_OFFICE_LEVEL = preload("res://ui/components/selector/levels/select_office_level.tres")
	const SELECT_BASE_TABLE = preload("res://ui/components/selector/tables/select_base_table.tres")
	current_level = SELECT_OFFICE_LEVEL
	current_table = SELECT_BASE_TABLE
	
# Paths
const SCENE_PATH: String = "res://scenes/"
const LEVELS_PATH: String = SCENE_PATH + "levels/"
const UI_PATH: String = "res://ui/"
const UI_SCENE_PATH: String = UI_PATH + "components/"
const AVATAR_PATH: String = "res://ui/images/avatars/"
const RESOURCES_PATH: String = "res://resources/"

# UI
var menu_start: MenuStart # Ref set in MenuStart _ready
var game_ui: UIGame # Ref set in UIGame _ready

# level
var main_level: MainLevel # Ref set in MainLevel _ready
var current_level: Resource
var current_table: Resource

### Selector functions, will be triggered when an element in selected in a UISelectMenu and will emit a corresponding signal ###
signal set_avatar_s
signal set_level_s
signal set_table_s
signal set_capsule_s


## This funciton will be triggered when an element of a selector is selected, the corresponding Resource is passed then we get its type to trigger the corresponding signal
func event_selector(element: Resource) -> void:
	emit_signal("set_" + element.event[element.type] + "_s", element)

###############

### ==================================================================== ###

# Players
var players: Array[Player]
var playingPlayer: Player
var capsule_skins: Dictionary = { 0: null, 1: null, 2: null, 3: null } # Holds UI selected capsule skins until the player objects are created 

# Local data
var gameHistory: Dictionary # json file, something to store history locally, then database storing ?

# Refs
var last_capsule: NesCapsule

# List of capsules present in the score zone
var within_score_zone : Array[NesCapsule]

func add_to_score_zone(capsule: NesCapsule) -> void:
	GameState.within_score_zone.append(capsule)
	game_ui.update_capsule_icons()

func remove_from_score_zone(capsule: NesCapsule) -> void:
	GameState.within_score_zone.erase(capsule)
	game_ui.update_capsule_icons()

# Game status
var current_player: Player
var state: States = States.SPECTATING;
enum States {
	SPECTATING,
	PLACING,
	SHOOTING
}

var current_round: int = 0
var current_turn: int = 0

# UI stuff
var endRoundMsg: String
func setEndRoundMsg(message):
	endRoundMsg = message
	
var scoreToWin: float = 10
var nbCapsules: float = 3

# Shooting
var power_bar: ProgressBar


func check_if_rules_ready() -> bool:
	# TODO any change event: if check_if_rules_ready(): then enable start button if returns true
	# TODO check if rules are ok then enable start button if so
	return players.size() > 0


# Set rules, level, table, players, capsules etc
func start_game() -> void:
	var slider_score: HSlider = menu_start.get_node("%slider_score")
	var slider_nbcapsules: HSlider = menu_start.get_node("%slider_nbcapsules")
	nbCapsules = slider_nbcapsules.value
	scoreToWin = slider_score.value
	
	var players_boxes: Array = menu_start.get_node("%ui_players").get_children()
	
	# Get players box then append an object value in the players array if a name has been entered in the input

	for index in players_boxes.size():
		var player_box: PlayerBox = players_boxes[index]
		if player_box.input_name.text.length() > 0:
			var newPlayer: Player = Player.new()
			newPlayer.name = player_box.input_name.text
			newPlayer.slot = players.size() if players.size() == 0 else players.size() + 1
			newPlayer.remaining_capsules = nbCapsules # TODO add nb of capsule in UI
			newPlayer.avatar = player_box.button_avatar.texture_normal
			newPlayer.capsule_skin = capsule_skins[index] # Adds capsule skin from index of the player box and set in the dictionary from UIStartGamePlayers
			players.append(newPlayer)
	
	current_player = players[0]
	
	state = States.SPECTATING;
	current_turn = 1
	current_round = 1
		
	if check_if_rules_ready():
		get_tree().call_deferred("change_scene_to_file", LEVELS_PATH + "MainLevel.tscn")


# Enable or disable the collisions on the table placement zone
func toggle_table_placement_collisions(enable: bool) -> void:
	for collision: StaticBody3D in main_level.current_table.placement_cols:
		collision.process_mode = Node.PROCESS_MODE_INHERIT if enable else Node.PROCESS_MODE_DISABLED


func switch_camera(cameraRef: String) -> void:
	if cameraRef == "main":
		main_level.setup_camera() # Reset camera position
		main_level.main_camera.make_current() # Switch to the main camera
	elif cameraRef == "top":
		main_level.current_table.cameras[0].make_current()


# TODO get next capsule to spawn from next player to play capsules array
# Instantiate a nes capsule object on the Marker3D spawn point of the current table
func spawn_capsule() -> void:
	var nes_capsule_i: NesCapsule = NES_CAPSULE.instantiate()
	main_level.add_child(nes_capsule_i)
	nes_capsule_i.global_transform.origin = main_level.current_table.spawn_point.global_transform.origin
	nes_capsule_i.possess()


func determine_next_player() -> void:
	pass

  #determineNextPlayer: (inZoneCapsules) => {
	#const currentPlayerSlot = get().playingPlayer.slot - 1; // Adjust slot to zero-based index
	#const players = get().players;
#
	#// Initialize the next player, current player if capsule remaining, otherwise next player in line
	#let nextPlayer =
	  #players[currentPlayerSlot].remaining > 0
		#? players[currentPlayerSlot]
		#: currentPlayerSlot === players.length - 1
		  #? players[0]
		  #: players[currentPlayerSlot + 1];
#
	#// console.log("============== nextPlayer", nextPlayer);
#
	#// Iterate through all players starting from the current player
	#for (let i = 1; i <= players.length; i++) {
	  #const playerIndex = (currentPlayerSlot + i) % players.length;
	  #const player = players[playerIndex];
#
	  #// console.log("Iterate next player -> ", player);
#
	  #// Check if the player has any capsules left to play
	  #const capsuleRemaining = player.remaining > 0;
	  #if (!capsuleRemaining) continue;
#
	  #// Prioritize players who haven't played any capsules in this round
	  #if (player.remaining === get().nbCapsules) {
		#nextPlayer = player;
		#break;
	  #}
#
	  #// nextPlayer has no capsule, no point of comparing
	  #if (!(nextPlayer.remaining > 0)) {
		#nextPlayer = player;
		#continue;
	  #}
#
	  #// Check if the player has a capsule in the score zone
	  #const bestCapsule = inZoneCapsules.find(
		#(capsule) => capsule.userData.owner.slot === player.slot
	  #);
#
	  #// If the player has a capsule in the score zone and it's closer to the edge than the nextPlayer's capsule
	  #if (bestCapsule) {
		#const nextPlayerBestCapsule = inZoneCapsules.find(
		  #(capsule) => capsule.userData.owner.slot === nextPlayer.slot
		#);
#
		#const bestCapsuleDistance = bestCapsule.translation().z;
		#let nextPlayerBestCapsuleDistance = -Infinity;
		#if (nextPlayerBestCapsule) {
		  #nextPlayerBestCapsuleDistance = nextPlayerBestCapsule.translation().z;
		#}
#
		#if (bestCapsuleDistance < nextPlayerBestCapsuleDistance) {
		  #nextPlayer = player;
		#}
	  #} else {
		#// If there are no capsules in the score zone, choose the next player with capsules left to play
		#nextPlayer = player;
		#break;
	  #}
	#}
#
	#return nextPlayer; //get().players.findIndex((player) => player.slot === nextPlayer.slot);
  #},


func next_turn() -> void:
	# TODO If multiplayer, check current player before switching cams
	switch_camera("main")
	state = States.SPECTATING
	current_turn += 1
	# TODO Refresh UI
	# TODO set next player


# TODO
func resetGame() -> void:
	current_turn = 0
	current_round = 0
