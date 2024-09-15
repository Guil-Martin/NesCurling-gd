class_name MenuStart extends Control

@onready var button_quit: Button = %button_quit

@onready var slider_nbcapsules: HSlider = %slider_nbcapsules
@onready var label_nbcapsules_txt: Label = %label_nbcapsules_txt

@onready var slider_score: HSlider = %slider_score
@onready var label_score_txt: Label = %label_score_txt

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
	
	
# // Avatar change / # TODO -> to improve
func change_avatar(chosen_texture: CompressedTexture2D) -> void:
	if chosen_texture:
		var players = get_node("%vbox_players").get_children()
		var pBox: PlayerBox = players[select_avatar_slot]
		var avatar_btn: TextureButton = pBox.get_node("%avatarBtn")
		avatar_btn.texture_normal = chosen_texture
		
		# Close avatar select windows
		var avatar_select_window: AvatarSelect = get_node("AvatarSelect")
		avatar_select_window._on_close_button_pressed()
		
