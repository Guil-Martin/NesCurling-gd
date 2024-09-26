class_name UISelectMenu extends Control

@onready var select_container: GridContainer = %select_container
@export var elements: Array[Resource]

#signal button_pressed(element_name)
const SELECT_ELEMENT = preload("res://ui/components/selector/select_element.tscn")

func _ready() -> void:
	for element: Resource in elements:
		add_element(element)


# Call function event_selector on GameState and emit signal based on resource type
func element_pressed(element: Resource) -> void:
	GameState.event_selector(element)
	visible = false


func add_element(element: Resource) -> void:
	var select_element: PanelContainer = SELECT_ELEMENT.instantiate()
	select_element.get_node("%image").texture = element.image
	select_element.get_node("%button").pressed.connect(element_pressed.bind(element))
	select_container.add_child(select_element)


func _on_button_close_pressed() -> void:
	visible = false
