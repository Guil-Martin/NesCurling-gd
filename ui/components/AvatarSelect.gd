class_name AvatarSelect extends Control

@onready var avatar_grid: GridContainer = %avatar_grid

func _ready() -> void:
	# Setup grid with avatar images
	var avatar_slots = avatar_grid.get_children()
	for i in range(avatar_slots.size()) :
		var slot = avatar_slots[i]
		var	nextImg = GameState.AVATAR_NAMES[i]
		if nextImg:
			slot.get_node("avatar").texture = load(GameState.AVATAR_PATH + nextImg + ".png")


func _on_close_button_pressed() -> void:
	var menu_start: MenuStart = GameState.menu_start
	var players_boxes: Array = menu_start.get_node("%vbox_players").get_children()
	players_boxes[menu_start.select_avatar_slot].close_select_avatar()
