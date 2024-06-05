shader_type canvas_item;

uniform bool is_hovered = false;

void fragment() {
    vec4 textureCol = texture(TEXTURE, UV);
    
    if (is_hovered) {
        vec3 white = vec3(0.8, 0.8, 0.8);
        vec3 whitenedTextureRGB = mix(textureCol.rgb, white, 0.5);
        COLOR = vec4(whitenedTextureRGB, textureCol.a);
    } else {
        COLOR = textureCol;
    }
}
