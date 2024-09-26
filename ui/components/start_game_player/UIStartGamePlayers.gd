class_name UIStartGamePlayers extends VBoxContainer

const PLAYER_BOX = preload("res://ui/components/start_game_player/PlayerBox.tscn")
var select_avatar_slot: int
var select_capsule_slot: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect set avatar & capsule signal from GameState to change the avatar/capsule of the given player box's avatar/capsule button 
	GameState.set_avatar_s.connect(set_avatar)
	GameState.set_capsule_s.connect(set_capsule)
	
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


# Callable from the signal of each avatar button of player boxes
func open_select_capsule(slot: int) -> void:
	select_capsule_slot = slot
	GameState.menu_start.ui_capsule_select_menu.visible = true


# Connected in the ready function, Triggered from SelectElement that execute set_avatar function on GameState that trigger the connected signal
func set_avatar(avatar: Resource) -> void:
	var pBox: PlayerBox = get_children()[select_avatar_slot]
	pBox.get_node("button_avatar").texture_normal = avatar.image


# Connected in the ready function, Triggered from SelectElement that execute set_capsule function on GameState that trigger the connected signal
func set_capsule(capsule: Resource) -> void:
	var pBox: PlayerBox = get_children()[select_capsule_slot]
	pBox.get_node("button_capsule").texture_normal = capsule.image
	GameState.capsule_skins[select_capsule_slot] = capsule.albedo
	# TODO change skin of players's capsules, set a variable in the corresponding player's script ? 
	# so when a capsule is spwaned it takes this texture and puts it on the capsule material
