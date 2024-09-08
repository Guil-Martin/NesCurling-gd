extends Node

var debug: bool = false
var platformWeb = OS.has_feature("web") or OS.has_feature("web_android") or OS.has_feature("web_ios")

# Constants
const SCENE_PATH: String = "res://scenes/"
const LEVELS_PATH: String = SCENE_PATH + "levels/"
const UI_SCENE_PATH: String = "res://ui/components/"
const AVATAR_PATH: String = "res://ui/images/avatars/"

const CAPSULES_PATH: String = SCENE_PATH + "nes_capsules/"
const CAPSULES = {
	"base" = CAPSULES_PATH + "base/nes_capsule.tscn"
}

const TABLES_PATH: String = SCENE_PATH + "nes_tables/"
const TABLES = {
	"base" = TABLES_PATH + "base/nes_table.tscn"
}

#const BASE_LEVEL = preload(LEVELS_PATH + "BaseLevel.tscn")
const LEVELS = {
	"base" = LEVELS_PATH + "BaseLevel.tscn",
	"office" = LEVELS_PATH + "office/level.tscn"
}

var AVATAR_NAMES: Array = ["blondin", "cat", "clown", "mago", "rabbit", "red_panda"]

# level
var current_level: String
var current_table: String
var current_capsule: String

# Players
var players: Array = []
var playingPlayer #: Player

# Local data
var gameHistory # json file, something to store history locally, then database storing ?

# Refs
var placementPlaneRef
func setScorePlacementPlaneRef(ref):
	placementPlaneRef = ref
	
var scoreZoneRef: Node3D
func setScoreZoneRef(ref):
	scoreZoneRef = ref
	
# List of capsules present in the score zone
var withinScoreZone : Array
func setWithinScoreZone(capsule : NesCapsule):
	withinScoreZone.append(capsule)
	
# Game status
var score: Array = [0, 0, 0, 0]
#0 : Nothing
#1 : Game start
#2 : During capsule shot
#3 : Capsule placement
var gameState: int = 0;
var gameEvent # isDragging and stuff
var turn: int = 0
var round: int = 0

var capsules #: NesCapsule []
var draggedCapsule #: NesCapsule

# UI stuff
var endRoundMsg: String
func setEndRoundMsg(message):
	endRoundMsg = message
	
var scoreToWin: float = 10
var nbCapsules: float = 3

#determineNextPlayer()
func check_if_rules_ready() -> bool:
	# TODO any change event: if check_if_rules_ready(): then enable start button if returns true
	# TODO check if rules are ok then enable start button if so
	return players.size() > 0
	
	
func start_game():
	# TODO set rules, level, table, players, capsules etc
	
	# Get MenuStart instance by getting the current scene since we should be in its scene when the game starts
	var menu_start: MenuStart = get_tree().current_scene
	if menu_start:
		
		var slider_score: HSlider = menu_start.get_node("%slider_score")
		var slider_nbcapsules: HSlider = menu_start.get_node("%slider_nbcapsules")
		nbCapsules = slider_nbcapsules.value
		scoreToWin = slider_score.value
		
		var players_boxes: Array = menu_start.get_node("%vbox_players").get_children()
		
		# Get players box then append an object value in the players array if a name has been entered in the input
		for player_box:PlayerBox in players_boxes:
			if player_box.input_name.text.length() > 0:
				players.append({
					"name": player_box.input_name.text,
					"slot": players.size(),
					"avatar": player_box.avatar_btn.texture_normal
				})
		
		gameState = 0;
		turn = 1
		round = 1
		
		current_table = TABLES.get("base")
		current_capsule = CAPSULES.get("base")
		current_level = LEVELS.get("office")
		
		print("current_table ", current_table)
		print("current_capsule ", current_capsule)
		print("current_level ", current_level)
		
		if check_if_rules_ready():
			get_tree().call_deferred("change_scene_to_file", LEVELS.get("base"))


func resetGame():
	turn = 0
	round = 0
	# TODO get all capsule ref and delete (to put in a fonction)

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("gamestate ready ", rng.randf())
	print("gamestate platformWeb ", platformWeb)
	
func setGameState(state):
	gameState = state
