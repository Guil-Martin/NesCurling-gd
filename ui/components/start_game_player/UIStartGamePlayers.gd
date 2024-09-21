extends VBoxContainer

const PLAYER_BOX = preload("res://ui/components/start_game_player/PlayerBox.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#var player_box = PLAYER_BOX.instantiate()
	#add_child(player_box)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#func open_select_avatar() -> void:
	#if !ui_select_menu.visible:
		#ui_select_menu.visible = true
		#
	#if select_avatar_menu:
		#select_avatar_menu_instanciated = GameState.menu_start.select_avatar_slot
		#select_avatar_menu_instance = select_avatar_menu.instantiate()
		#owner.add_child(select_avatar_menu_instance)
#
			#
#func close_select_avatar() -> void:
	#if select_avatar_menu:
		#if select_avatar_menu_instance != null:
			#select_avatar_menu_instanciated = -1
			#select_avatar_menu_instance.queue_free();
			## Set to null since before the instance is deleted _process will run this again thus crashing because the instance is already in a queue free state
			#select_avatar_menu_instance = null
#
## // Avatar change / # TODO -> to improve
#func change_avatar(chosen_texture: CompressedTexture2D) -> void:
	#if chosen_texture:
		#var pBox: PlayerBox = ui_players[select_avatar_slot]
		#var avatar_btn: TextureButton = pBox.get_node("%avatarBtn")
		#avatar_btn.texture_normal = chosen_texture
		#
		## Close avatar select windows
		#var avatar_select_window: AvatarSelect = get_node("AvatarSelect")
		#avatar_select_window._on_close_button_pressed()
