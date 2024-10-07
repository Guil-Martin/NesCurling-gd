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
var player_colors: Array[Color] = [Color.DODGER_BLUE, Color.FIREBRICK, Color.GOLDENROD, Color.SEA_GREEN]
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
	
var score_to_win: float = 10
var nb_capsules: float = 3

# Shooting
var power_bar: ProgressBar


func check_if_rules_ready() -> bool:
	# TODO any change event: if check_if_rules_ready(): then enable start button if returns true
	# TODO check if rules are ok then enable start button if so
	return players.size() > 0


# Called from button event in MenuStart, Set rules, level, table, players, capsules etc
func setup_game() -> void:
	var slider_score: HSlider = menu_start.get_node("%slider_score")
	var slider_nbcapsules: HSlider = menu_start.get_node("%slider_nbcapsules")
	nb_capsules = slider_nbcapsules.value
	score_to_win = slider_score.value
	
	var players_boxes: Array = menu_start.get_node("%ui_players").get_children()
	
	# Get players box then append an object value in the players array if a name has been entered in the input
	for index in players_boxes.size():
		var player_box: PlayerBox = players_boxes[index]
		if player_box.input_name.text.length() > 0:
			var newPlayer: Player = Player.new()
			newPlayer.name = player_box.input_name.text
			newPlayer.slot = players.size() 
			newPlayer.remaining_capsules = nb_capsules # TODO add nb of capsule in UI
			newPlayer.avatar = player_box.button_avatar.texture_normal
			newPlayer.capsule_skin = capsule_skins[index] # Adds capsule skin from index of the player box and set in the dictionary from UIStartGamePlayers
			players.append(newPlayer)
	
	state = States.SPECTATING;
		
	if check_if_rules_ready():
		get_tree().call_deferred("change_scene_to_file", LEVELS_PATH + "MainLevel.tscn")


func start_game() -> void:
	current_round = 1
	current_turn = 1
	current_player = players[0]
	game_ui.display_message()
	game_ui.update_UI()
	spawn_capsule()


# Loop through players to check if one of them has the necessary score to win and return its reference if so
func is_there_winner() -> Player:
	for player: Player in players:
		if player.score >= score_to_win:
			return player
	return null


# Deternine which player is the winner of this round and add its points, return null if there in no capsule in the zone
func point_counting() -> NesCapsule:
	var nearest_capsule: NesCapsule
	if within_score_zone.size() > 0:
		nearest_capsule = within_score_zone[0]
		for capsule: NesCapsule in within_score_zone:
			if capsule.global_position.z > nearest_capsule.global_position.z:
				nearest_capsule = capsule
				
		# TODO cumulate points if multiple winning capsule of the same player
		if nearest_capsule:
			players[nearest_capsule.player_owner.slot].score += 1
		
	return nearest_capsule


func next_turn() -> void:
	switch_camera("main")
	state = States.SPECTATING

	current_player = determine_next_player()
	
	# TODO Check score for victory
	if current_player == null:
		
		# Count point and set winning_capsule, can be null if no capsules in the zone
		var winning_capsule: NesCapsule = point_counting()
		
		var winner: Player = is_there_winner()
		if winner:
			print("Player ", winner.name, " is the winner!")
			return
		else:
			# Start of a new round, clean up capsules, reset capsules for all players
			current_round += 1
			clean_capsules()
			for player: Player in players:
				player.remaining_capsules = nb_capsules
			# Last to win points start the round, else the first player 
			# TODO if no point marked, choose the one with best score
			current_player = players[winning_capsule.player_owner.slot] if winning_capsule != null else players[0]
			
	current_turn += 1
	game_ui.display_message()
	game_ui.update_UI()
	spawn_capsule() # Spawn capsule of the new player


# Instantiate a nes capsule object on the Marker3D spawn point of the current table
func spawn_capsule() -> void:
	var nes_capsule_i: NesCapsule = NES_CAPSULE.instantiate()
	main_level.add_child(nes_capsule_i)
	nes_capsule_i.global_transform.origin = main_level.current_table.spawn_point.global_transform.origin
	nes_capsule_i.possess()


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


# Does this player own a capsule in the score zone ?
func has_capsule_inzone(player_slot) -> bool:
	for capsule: NesCapsule in within_score_zone:
		if capsule.player_owner.slot == player_slot:
			return true
	return false


# Check if this player has the farthest capsule in the score zone, there must be at least 1 capsule in zone
func is_farthest(player_slot) -> bool:
	var farthest_cap: NesCapsule = within_score_zone[0]
	for capsule: NesCapsule in within_score_zone:
		farthest_cap = farthest_cap if farthest_cap.global_position.z < capsule.global_position.z else capsule
	return farthest_cap.player_owner.slot == player_slot


# Look for a valid player to be the next player to play, if the player has capsules left, is outside the score zone or the farthest from the edge
func determine_next_player() -> Player:
	# Slice the array to reorder with the current player at index 0
	var ordered_players: Array[Player] = players.slice(current_player.slot) + players.slice(0, current_player.slot)
	
	for i in range(1, ordered_players.size()):
		var player: Player = ordered_players[i]
		if player.remaining_capsules > 0: # Ignore if no capsule left
			var in_zone = has_capsule_inzone(player.slot)
			if !in_zone: # return the first player outside of the zone
				return player

	# If no player after the current player has a capsule outside, return the current player if they don't have a capsule inside the score zone and remaining capsules
	if ordered_players[0].remaining_capsules > 0 && !has_capsule_inzone(ordered_players[0].slot):
		return ordered_players[0]

	# If sill no player found, return the player that has the farthest capsule from the edge
	for i in range(1, ordered_players.size()):
		var player: Player = ordered_players[i]
		if player.remaining_capsules > 0: # Ignore if no capsule left
			var in_zone = has_capsule_inzone(player.slot)
			if in_zone && is_farthest(player.slot): 
				return player
				
	# A player still has not been found, return next player that have capsule remaining
	for player in players:
		if player.remaining_capsules > 0: 
			return player
	
	return null


# Remove all references of NesCapsule objects in the scene
func clean_capsules() -> void:
	for child in main_level.get_children():
		if child is NesCapsule:
			child.queue_free()


# TODO
func resetGame() -> void:
	current_turn = 0
	current_round = 0
	for player: Player in players:
		player.score = 0
		player.remaining_capsules = nb_capsules
