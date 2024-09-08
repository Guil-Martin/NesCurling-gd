class_name UIGamePBox extends VBoxContainer

@onready var player_avatar: TextureRect = %player_avatar
@onready var player_name: Label = %player_name
@onready var player_color: TextureRect = %player_color
@onready var player_score: Label = %player_score

func _ready() -> void:
	pass

func setup_player_box(player):
	print("setup_player_box player ", setup_player_box)
	player_name.text = player["name"]
	player_avatar.texture = player["avatar"]
	#player_color = 
	player_score.text = "Score: 0"
