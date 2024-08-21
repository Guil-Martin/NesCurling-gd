extends Node

var debug = false

var players : Array = [null, null, null, null]
var playingPlayer
var gameHistory # json file, something to store history locally, then database storing ?

# Refs
var placementPlaneRef
func setScorePlacementPlaneRef(ref):
	placementPlaneRef = ref
	
var scoreZoneRef : Node3D
func setScoreZoneRef(ref):
	scoreZoneRef = ref
	
# List of capsules present in the score zone
var withinScoreZone : Array
func setWithinScoreZone(capsule : NesCapsule):
	withinScoreZone.append(capsule)
	
# Game status
var score = [0, 0, 0, 0]
#0 : Nothing
#1 : Game start
#2 : During capsule shot
#3 : Capsule placement
var gameState = 0;
var gameEvent # isDragging and stuff
var turn = 0
var round = 0

var capsules
var draggedCapsule

# UI stuff
var endRoundMsg
func setEndRoundMsg(message):
	endRoundMsg = message
	
var scoreToWin
var nbCapsules

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
	

	
func setGameState(state):
	gameState = state