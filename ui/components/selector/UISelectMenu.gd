extends Control

@onready var select_container: GridContainer = %select_container
@export var elements: Array[Resource]

signal button_pressed(element_name)

func _ready() -> void:
	for element: Resource in elements:
		add_element(element)


func element_pressed(element) -> void:
	# Call function by name by getting the value of the event dictionary using the element.type enum value
	GameState.call(element.event[element.type], element)
	# TODO Deletes itself


func add_element(element: Resource) -> void:
	var button: TextureButton = TextureButton.new()
	button.custom_minimum_size = Vector2(256, 256)
	button.texture_normal = element.image
	button.pressed.connect(element_pressed.bind(element))
	select_container.add_child(button)
