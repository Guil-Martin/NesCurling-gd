class_name Player

var name: String
var slot: int
var avatar: Texture2D
var remaining_capsules: int = 0
var capsule_skin: Texture2D = null
var score: int = 0

func add_capsule() -> void:
	remaining_capsules += 1


func remove_capsule() -> bool:
	if remaining_capsules > 0:
		remaining_capsules -= 1
		return true
	return false


func _to_string() -> String:
	return "Name: {name} / Slot: {slot} / Capsule owner: {capsule_owner}".format({
		"name": name,
		"slot": slot,
		#"capsule_owner": String(", ").join(capsules.map(func(capsule): return capsule.player_owner.name))
	})
