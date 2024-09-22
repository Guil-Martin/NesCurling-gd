class_name PlayerBox extends HBoxContainer

var slot: int

@onready var avatar_btn: TextureButton = %avatarBtn
@onready var input_name: LineEdit = %input_name
@onready var delete: TextureButton = %delete


func _on_delete_pressed() -> void:
	if slot != 0: # Prevent removing the first player
		get_parent().remove_player(slot)


func setup(player_slot) -> void:
	slot = player_slot
	input_name.placeholder_text = "Player " + str(slot + 1)
	# Have to diconnect the signal before if already connected or the binded element (slot) won't be updated
	avatar_btn.pressed.disconnect(get_parent().open_select_avatar)
	avatar_btn.pressed.connect(get_parent().open_select_avatar.bind(slot))
