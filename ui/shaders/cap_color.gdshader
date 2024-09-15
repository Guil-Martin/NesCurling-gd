shader_type canvas_item;

uniform vec4 target_color = vec4(0.0, 0.7, 1.6, 1.0); // New color to apply (default blue)
uniform float tolerance = 0.1; // How much variation from pure grey we accept

void fragment() {
    // Get the texture color at this pixel
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Calculate the grey level by averaging RGB channels
    float grey_value = (tex_color.r + tex_color.g + tex_color.b) / 3.0;

    // Check how close the pixel's color is to grey
    float diff_r = abs(tex_color.r - grey_value);
    float diff_g = abs(tex_color.g - grey_value);
    float diff_b = abs(tex_color.b - grey_value);
    
    // If the pixel is grey (within tolerance), tint it based on the grey value
    if (diff_r < tolerance && diff_g < tolerance && diff_b < tolerance && tex_color.a > 0.0) {
        // Multiply the target color by the grey value to keep the luminance, preserving alpha
        COLOR = vec4(target_color.rgb * grey_value, tex_color.a);
    } else {
        // Keep the original color (including alpha) for non-grey areas
        COLOR = tex_color;
    }
}
