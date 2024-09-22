class_name CapIcon extends TextureRect

const CAP_COLOR: Shader = preload("res://ui/shaders/cap_color.gdshader")

func change_icon_color(new_color: Color) -> void:
	# Create instance if shader and apply to this icon material
	var shader_material: ShaderMaterial = ShaderMaterial.new()
	shader_material.shader = CAP_COLOR
	shader_material.set_shader_parameter("target_color", new_color)
	material = shader_material
