class_name MenuRules extends Control

var slider_score: HSlider
var label_score_txt: Label

var slider_nbcapsules: HSlider
var label_nbcapsules_txt: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slider_score = $VBoxContainer/slider_score
	slider_score.set_value_no_signal(GameState.scoreToWin)
	label_score_txt = $label_score_txt
	label_score_txt.text = str(GameState.scoreToWin)
	
	slider_nbcapsules = $VBoxContainer/slider_nbcapsules
	slider_nbcapsules.set_value_no_signal(GameState.nbCapsules)
	label_nbcapsules_txt = $label_nbcapsules_txt
	label_nbcapsules_txt.text = str(GameState.nbCapsules)

func _on_slider_nbcapsules_value_changed(value: float) -> void:
	label_nbcapsules_txt.text = str(value)

func _on_slider_score_value_changed(value: float) -> void:
	label_score_txt.text = str(value)
