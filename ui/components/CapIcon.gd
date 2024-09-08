class_name CapIcon extends TextureRect

const CAP_COLOR: Shader = preload("res://ui/images/cap_color.gdshader")
const CAP_WHITE: CompressedTexture2D = preload("res://ui/images/cap_white.png")

func _ready():
	#texture = CAP_WHITE
#
	#var shader_material: ShaderMaterial = ShaderMaterial.new()
	#shader_material.shader = CAP_COLOR
	#shader_material.set_shader_parameter("mask_texture", CAP_WHITE)
	#
	#material = shader_material
#
	#change_icon_color(Color(randf(), randf(), randf()))
	
	texture = CAP_WHITE

	var shader_material: ShaderMaterial = ShaderMaterial.new()
	shader_material.shader = CAP_COLOR

	#material = shader_material

	change_icon_color(Color(randf(), randf(), randf()))

func change_icon_color(new_color: Color):
	if material is ShaderMaterial:
		var shader_material = material as ShaderMaterial
		shader_material.set_shader_parameter("modulate_color", new_color)
