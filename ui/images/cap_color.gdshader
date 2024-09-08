shader_type canvas_item;

uniform vec4 modulate_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
    vec4 tex_color = texture(TEXTURE, FRAGCOORD.xy / TEXTURE_PIXEL_SIZE);
    if (tex_color.r < 0.1 && tex_color.g < 0.1 && tex_color.b < 0.1) {
        COLOR = tex_color;
    } else {
        float gray = (tex_color.r + tex_color.g + tex_color.b) / 3.0;
        COLOR = vec4(modulate_color.rgb * gray, modulate_color.a);
    }
}