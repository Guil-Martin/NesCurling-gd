class_name MenuStart extends Control

@onready var btn_quit: Button = %btn_quit

func _ready() -> void:
	%btn_start.grab_focus()
	# Hides quit button for web export
	btn_quit.visible = !GameState.platformWeb

func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/level_office.tscn")

func _on_btn_options_pressed() -> void:
	print("Load and adds options scene to current scene")
	#var options = load("res://ui/menu/options.tscn").instance()
	#get_tree().current_scene.add_child(options)

func _on_btn_quit_pressed() -> void:
	get_tree().quit()
