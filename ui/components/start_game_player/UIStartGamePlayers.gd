class_name UIStartGamePlayers extends VBoxContainer

const PLAYER_BOX = preload("res://ui/components/start_game_player/PlayerBox.tscn")
var select_avatar_slot: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect set avatar signal from GameState to change the avatar of the given player box's avatar button 
	GameState.set_avatar_s.connect(set_avatar)
	
	# Add at least one player each time
	add_player_box()
	
	# TODO, add buttons to add player, or handle this with multiplayer socket function ? Or both to play locally ?


# Returns the size of how many PlayerBox item have been added
func player_boxes_length() -> int:
	return get_children().size()


# Add new layer box parameters
func add_player_box() -> void:
	var addedBoxes: int = player_boxes_length()
	if addedBoxes < 4:
		var pBox: PlayerBox = PLAYER_BOX.instantiate()
		add_child(pBox)
		pBox.setup(addedBoxes)


func remove_player(slot: int) -> void:
	var pboxes: Array = get_children()
	pboxes[slot].queue_free()
	pboxes.remove_at(slot)
	var pboxes_len = pboxes.size()
	if pboxes_len > 0:
		for i in range(0, pboxes_len):
			pboxes[i].setup(i)


# Callable from the signal of each avatar button of player boxes
func open_select_avatar(slot: int) -> void:
	select_avatar_slot = slot
	GameState.menu_start.ui_avatar_select_menu.visible = true


# Triggered from SelectElement 
func set_avatar(avatar: Resource) -> void:
	var pBox: PlayerBox = get_children()[select_avatar_slot]
	pBox.get_node("avatarBtn").texture_normal = avatar.image
