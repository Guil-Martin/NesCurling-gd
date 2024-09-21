class_name AvatarButton extends Control

@onready var avatar: TextureRect = $avatar
var menu_start: MenuStart
var avatar_select: AvatarSelect

func _ready() -> void:
	menu_start = get_tree().current_scene
	avatar_select = menu_start.get_node("AvatarSelect")


func _on_btn_pressed() -> void:
	if avatar.texture:
		avatar.texture
		var players = menu_start.get_node("%vbox_players")
		var player_slot = players.get_children()[menu_start.select_avatar_slot]
		menu_start.change_avatar(avatar.texture)
