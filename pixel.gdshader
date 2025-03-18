shader_type canvas_item;  // Post-processing shader

uniform vec2 pixel_size = vec2(8.0, 8.0);  // Controls pixelation level
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

void fragment() {
    // Get the screen UV coordinates (normalized from 0 to 1)
    vec2 uv = UV;
    
    // Compute pixelated coordinates by snapping UV to a grid
    vec2 pixelated_uv = floor(uv * pixel_size) / pixel_size;
    
    // Sample the screen texture at the snapped coordinates
    vec4 color = texture(SCREEN_TEXTURE, pixelated_uv);
    
    // Output the color
    COLOR = color;
}
