shader_type canvas_item;

// Controls shadow slant/angle (-0.5 leans left, 0.5 leans right)
uniform float shadow_slant : hint_range(-2.0, 2.0) = 0.5;

// Vertical squish/scale (0.5 makes the shadow half height, 1.0 is full height)
uniform float shadow_height : hint_range(0.1, 4.0) = 4;

// General offset to align the base with the wall bottom
uniform vec2 shadow_offset = vec2(2.0, 4.0);

uniform float shadow_darkness : hint_range(0.0, 1.0) = 0.35;
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

void vertex() {
	// 1. Scale height (squish tall walls slightly onto the ground)
	VERTEX.y *= shadow_height;
	
	// 2. Shear / Rotate transform: shift X based on Y height
	VERTEX.x += VERTEX.y * shadow_slant;
	
	// 3. Apply general position offset
	VERTEX += shadow_offset;
}

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	
	if (tex.a > 0.01) {
		vec4 bg_color = texture(screen_texture, SCREEN_UV);
		COLOR = vec4(bg_color.rgb * (1.0 - shadow_darkness), bg_color.a);
	} else {
		discard;
	}
}