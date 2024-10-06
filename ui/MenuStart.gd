class_name MenuStart extends Control

@onready var button_quit: Button = %button_quit
@onready var slider_nbcapsules: HSlider = %slider_nbcapsules
@onready var label_nbcapsules_txt: Label = %label_nbcapsules_txt
@onready var slider_score: HSlider = %slider_score
@onready var label_score_txt: Label = %label_score_txt
@onready var selected_level: TextureButton = %selected_level
@onready var selected_table: TextureButton = %selected_table
@onready var ui_players: Control = %ui_players

@onready var ui_avatar_select_menu: UISelectMenu = $UIAvatarSelectMenu
@onready var ui_level_select_menu: UISelectMenu = $UILevelSelectMenu
@onready var ui_table_select_menu: UISelectMenu = $UITableSelectMenu
@onready var ui_capsule_select_menu: UISelectMenu = $UICapsuleSelectMenu

var select_avatar_slot = -1

func _ready() -> void:
	GameState.menu_start = self
	
	# Connect to event signals from GameState
	GameState.set_level_s.connect(set_level)
	GameState.set_table_s.connect(set_table)
	
	## Hides quit button for web export
	button_quit.grab_focus()
	button_quit.visible = !GameState.platformWeb
	
	slider_score.set_value_no_signal(GameState.score_to_win)
	label_score_txt.text = str(GameState.score_to_win)

	slider_nbcapsules.set_value_no_signal(GameState.nb_capsules)
	label_nbcapsules_txt.text = str(GameState.nb_capsules)


func _on_slider_nbcapsules_value_changed(value: float) -> void:
	label_nbcapsules_txt.text = str(value)


func _on_slider_score_value_changed(value: float) -> void:
	label_score_txt.text = str(value)


func _on_button_add_player_pressed() -> void:
	ui_players.add_player_box()


func _on_button_start_pressed() -> void:
	GameState.setup_game()
	

func _on_button_quit_pressed() -> void:
	get_tree().quit()


func _on_selected_level_pressed() -> void:
	ui_level_select_menu.visible = true


# From GameState.set_level_s signal
func set_level(level: Resource) -> void:
	selected_level.texture_normal = level.image


func _on_selected_table_pressed() -> void:
	ui_table_select_menu.visible = true


# From GameState.set_table_s signal
func set_table(table: Resource) -> void:
	selected_table.texture_normal = table.image


func _on_selected_capsule_pressed() -> void:
	ui_capsule_select_menu.visible = true
