extends Node

var debug: bool = false
var platformWeb = OS.has_feature("web") or OS.has_feature("web_android") or OS.has_feature("web_ios")

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
	
func set_avatar(element) -> void:
	emit_signal("set_avatar_s", element)

func set_level(element) -> void:
	emit_signal("set_level_s", element)
	current_level = element
	
func set_table(element) -> void:
	emit_signal("set_table_s", element)
	current_table = element
	
func set_capsule(element) -> void:
	emit_signal("set_capsule_s", element)
###############

### ==================================================================== ###

# Players
var players: Array[Player]
var playingPlayer: Player

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
var state: States = States.SPECTATING;
enum States {
	SPECTATING,
	PLACING,
	SHOOTING
}

var round: int = 0
var turn: int = 0

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
	for player_box:PlayerBox in players_boxes:
		if player_box.input_name.text.length() > 0:
			var newPlayer: Player = Player.new()
			newPlayer.name = player_box.input_name.text
			newPlayer.slot = players.size()
			newPlayer.avatar = player_box.avatar_btn.texture_normal
			players.append(newPlayer)
	
	state = States.SPECTATING;
	turn = 1
	round = 1
		
	if check_if_rules_ready():
		get_tree().call_deferred("change_scene_to_file", LEVELS_PATH + "MainLevel.tscn")


# Enter a state of placing the capsule on the placement zone, enable the given collision to make the capsule stay in the zone
func placement(capsule: NesCapsule) -> void:
	if state != States.PLACING:
		for collision: StaticBody3D in main_level.current_table.placement_cols:
			collision.process_mode = Node.PROCESS_MODE_INHERIT

		state = States.PLACING
	else:
		main_level.setup_camera() # Reset camera position
		main_level.main_camera.make_current() # Switch to the main camera
		for collision: StaticBody3D in main_level.current_table.placement_cols:
			collision.process_mode = Node.PROCESS_MODE_DISABLED

		state = States.SPECTATING


# TODO
func resetGame() -> void:
	turn = 0
	round = 0
