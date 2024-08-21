extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Table ready, game state =>", GameState.gameState)
	GameState.setGameState(4)
	print("Table ready, game state =>", GameState.gameState)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
