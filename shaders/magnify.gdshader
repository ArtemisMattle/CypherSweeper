shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture,filter_linear;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 zoom=SCREEN_UV*0.9+texture(TEXTURE,UV).r*0.01;
	COLOR=texture(SCREEN_TEXTURE,zoom)*(texture(TEXTURE,UV));
	
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
