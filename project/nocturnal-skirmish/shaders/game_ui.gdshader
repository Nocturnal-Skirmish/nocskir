shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

uniform float scale : hint_range(0.1, 10) = 1.0;

uniform vec4 color : source_color;
uniform float flashState : hint_range(0, 1) = 0;

void fragment() {
	vec4 pixelColor = texture(TEXTURE, UV * scale);
	// Called for every pixel the material is visible on.;
	COLOR = mix(pixelColor, color, flashState);
	COLOR.a *= pixelColor.a;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
