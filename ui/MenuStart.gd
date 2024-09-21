class_name MenuStart extends Control

@onready var button_quit: Button = %button_quit
@onready var slider_nbcapsules: HSlider = %slider_nbcapsules
@onready var label_nbcapsules_txt: Label = %label_nbcapsules_txt
@onready var slider_score: HSlider = %slider_score
@onready var label_score_txt: Label = %label_score_txt
@onready var ui_select_menu: Control = $UISelectMenu
@onready var ui_players: VBoxContainer = %ui_players

var select_avatar_slot = -1


func _ready() -> void:
	GameState.menu_start = self
	
	## Hides quit button for web export
	button_quit.grab_focus()
	button_quit.visible = !GameState.platformWeb
	
	slider_score.set_value_no_signal(GameState.scoreToWin)
	label_score_txt.text = str(GameState.scoreToWin)

	slider_nbcapsules.set_value_no_signal(GameState.nbCapsules)
	label_nbcapsules_txt.text = str(GameState.nbCapsules)
		

func _on_slider_nbcapsules_value_changed(value: float) -> void:
	label_nbcapsules_txt.text = str(value)


func _on_slider_score_value_changed(value: float) -> void:
	label_score_txt.text = str(value)


func _on_button_start_pressed() -> void:
	GameState.start_game()
	

func _on_button_quit_pressed() -> void:
	get_tree().quit()
