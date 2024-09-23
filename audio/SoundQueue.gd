@tool
class_name SoundQueue extends Node3D

var next: int = 1
var audioStreamPlayers: Array[AudioStreamPlayer]

@export var count: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_child_count() == 0:
		return print("No AudioStreamPlayer found")
		
	var child = get_child(0)
	if child is AudioStreamPlayer:
		audioStreamPlayers.append(child)
		for i in range(0, count):
			var duplicate: AudioStreamPlayer = child.duplicate()
			add_child(duplicate)
			audioStreamPlayers.append(duplicate)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func play_sound(delta: float) -> void:
	if !audioStreamPlayers[next].playing:
		next += 1
		audioStreamPlayers[next].play()
		next %= audioStreamPlayers.size() # Reset to 0 if next is at max array size
		
		
func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []

	if get_child_count() == 0:
		warnings.append("No children found, Expected on AudioStreamPlayer child.")
		
	if get_child(0) is not AudioStreamPlayer:
		warnings.append("Expected first child to be a AudioStreamPlayer.")

	# Returning an empty array means "no warning".
	return warnings
