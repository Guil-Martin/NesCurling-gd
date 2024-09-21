class_name PlayerBox extends HBoxContainer

static var select_avatar_menu_instanciated = -1
static var player_button_nb: int = 0

var player_button_slot: int
var select_avatar_menu: PackedScene = preload(GameState.UI_SCENE_PATH + "AvatarSelect" + ".tscn")

@onready var avatar_btn: TextureButton = %avatarBtn
@onready var input_name: LineEdit = $input_name

var select_avatar_menu_instance: AvatarSelect

func _ready() -> void:
	# Add 1 to number of total buttons instancied and set the slot of this button instance
	player_button_slot = player_button_nb
	player_button_nb += 1
	
	input_name.placeholder_text = "Player " + str(player_button_nb)
	
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_cancel"):
		if is_select_avatar_opened():
			close_select_avatar()


func _on_button_pressed() -> void:
	# Opens the avatar selector
	if GameState.menu_start:
		if is_select_avatar_opened():
			close_select_avatar()
		else:
			GameState.menu_start.select_avatar_slot = player_button_slot
			open_select_avatar()


func is_select_avatar_opened() -> bool:
	return select_avatar_menu && select_avatar_menu_instance && select_avatar_menu_instanciated >= 0

		
func open_select_avatar() -> void:
	if select_avatar_menu:
		select_avatar_menu_instanciated = GameState.menu_start.select_avatar_slot
		select_avatar_menu_instance = select_avatar_menu.instantiate()
		owner.add_child(select_avatar_menu_instance)

			
func close_select_avatar() -> void:
	if select_avatar_menu:
		if select_avatar_menu_instance != null:
			select_avatar_menu_instanciated = -1
			select_avatar_menu_instance.queue_free();
			# Set to null since before the instance is deleted _process will run this again thus crashing because the instance is already in a queue free state
			select_avatar_menu_instance = null
