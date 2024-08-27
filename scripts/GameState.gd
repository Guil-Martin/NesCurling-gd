extends Node

var debug: bool = false
var platformWeb = OS.has_feature("web") or OS.has_feature("web_android") or OS.has_feature("web_ios")

# Players
var players: Array = [null, null, null, null]
var playingPlayer #: Player

# level
var levecurrentLevel
var currentTable

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
#startGame()
#resetGame()

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
