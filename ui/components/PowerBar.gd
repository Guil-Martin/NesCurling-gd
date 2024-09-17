extends Control


# Variables for power bar logic
var is_filling: bool = true  # Track if the bar is filling or emptying
var power_value: float = 0.0  # Current power value (0.0 to 1.0)
var power_speed: float = 0.5  # Speed at which the bar fills/empties
var is_charging: bool = false  # If the mouse button is held down

# UI references (if using a ProgressBar or similar)
@onready var progress_bar = $ProgressBar  # Assuming the bar node is a child of this node

func _process(delta: float) -> void:
	if is_charging:
		update_power_bar(delta)

func _input(event: InputEvent) -> void:
	# Detect when the left mouse button is pressed
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_charging = true  # Start charging when button is pressed
			else:
				is_charging = false  # Stop charging when button is released
				on_power_released()

func update_power_bar(delta: float) -> void:
	# Fill or empty the bar based on current state
	if is_filling:
		power_value += power_speed * delta
		if power_value >= 1.0:
			power_value = 1.0
			is_filling = false  # Start emptying when full
	else:
		power_value -= power_speed * delta
		if power_value <= 0.0:
			power_value = 0.0
			is_filling = true  # Start filling when empty
	
	# Update the UI (progress bar or similar)
	progress_bar.value = power_value * 100  # Assuming the bar range is from 0 to 100

func on_power_released() -> void:
	# Do something with the current power value when the mouse button is released
	print("Power value released:", power_value)
	# Perform any logic with the `power_value` here
