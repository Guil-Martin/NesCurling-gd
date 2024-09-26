extends Resource

enum EVENT_METHODS {
	AVATAR,
	LEVEL,
	TABLE,
	CAPSULE
}

const event: Dictionary = {
	EVENT_METHODS.AVATAR : "avatar",
	EVENT_METHODS.LEVEL : "level",
	EVENT_METHODS.TABLE : "table",
	EVENT_METHODS.CAPSULE : "capsule"
}

## Name of the resource
@export var name: String

## Image preview of the resource
@export var image: Texture2D

## Will trigger the corresponding named function on GameState script when this resource is chosen
@export var type: EVENT_METHODS

## Optional scene to be loaded (used with level for example)
@export var scene: PackedScene

## Optional texture to be applied on a material (used with capsule for example)
@export var albedo: Texture2D
