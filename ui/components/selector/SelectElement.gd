extends Resource

enum EVENT_METHODS {
	AVATAR,
	LEVEL,
	TABLE,
	CAPSULE
}

const event: Dictionary = {
	EVENT_METHODS.AVATAR : "set_avatar",
	EVENT_METHODS.LEVEL : "set_level",
	EVENT_METHODS.TABLE : "set_table",
	EVENT_METHODS.CAPSULE : "set_capsule"
}

@export var name: String
@export var image: Texture2D
@export var type: EVENT_METHODS
@export var scene: PackedScene
