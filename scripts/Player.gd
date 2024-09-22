class_name Player

var name: String
var slot: int
var avatar: Texture2D
var capsules: Array[NesCapsule]
var score: int = 0

# Adds the given capsule to the array of capsule for this player
func add_capsule(capsule: NesCapsule) -> void:
	capsules.append(capsule)


# Remove the given ref capsule from the capsule array for this player
# Returns true if successfully removed, false otherwise
func remove_capsule(capRef: NesCapsule) -> bool:
	var index: int = capsules.find(capRef)
	if index != -1:
		capsules.remove_at(index)
		return true
	return false


func capsule_remain() -> int:
	return capsules.size()


# Returns the next available capsule or null if empty
func next_capsule() -> NesCapsule:
	if (!capsule_remain()):
		return null
	return capsules[0]


func _to_string() -> String:
	return "Name: {name} / Slot: {slot} / Capsule owner: {capsule_owner}".format({
		"name": name,
		"slot": slot,
		"capsule_owner": String(", ").join(capsules.map(func(capsule): return capsule.player_owner.name))
	})
