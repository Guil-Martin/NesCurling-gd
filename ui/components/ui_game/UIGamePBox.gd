class_name UIGamePBox extends VBoxContainer

var player: Player
@onready var player_avatar: TextureRect = %player_avatar
@onready var player_name: Label = %player_name
@onready var player_color: TextureRect = %player_color
@onready var player_score: Label = %player_score

func setup_player_box(player: Player) -> void:
	self.player = player
	player_name.text = player.name
	player_avatar.texture = player.avatar
	set_score(player.score)


func set_score(newScore: int) -> void:
	player_score.text = "Score: " + str(newScore)
