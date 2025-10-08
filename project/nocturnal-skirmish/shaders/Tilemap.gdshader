shader_type canvas_item;

uniform bool enabled = false;

// --- Editable target colors (show color pickers in the Inspector) ---
uniform vec4 purple_target : source_color = vec4(0.6, 0.2, 0.9, 1.0);
uniform vec4 gold_target   : source_color = vec4(1.0, 0.85, 0.2, 1.0);

// --- Controls how strong the recolor is and how far color matching extends ---
uniform float blend_strength : hint_range(0.0, 1.0) = 1.0;
uniform float tolerance : hint_range(0.0, 0.5) = 0.08;

// Reds and yellows to detect (from your provided list)
const vec3 reds[6] = vec3[6](
    vec3(0.29, 0.01, 0.01),  // #4a0202
    vec3(0.67, 0.03, 0.03),  // #ac0707
    vec3(0.53, 0.03, 0.03),  // #860808
    vec3(0.75, 0.00, 0.00),  // #be0000
    vec3(0.72, 0.02, 0.02),  // #b90505
    vec3(0.87, 0.01, 0.01)   // #df0303
);

const vec3 yellow = vec3(0.84, 0.69, 0.15); // #d5af25

// --- RGB→HSV and HSV→RGB conversions ---
vec3 rgb2hsv(vec3 c) {
    float cmax = max(c.r, max(c.g, c.b));
    float cmin = min(c.r, min(c.g, c.b));
    float delta = cmax - cmin;
    float h = 0.0;
    if (delta > 0.00001) {
        if (cmax == c.r)
            h = mod((c.g - c.b) / delta, 6.0);
        else if (cmax == c.g)
            h = ((c.b - c.r) / delta) + 2.0;
        else
            h = ((c.r - c.g) / delta) + 4.0;
        h /= 6.0;
        if (h < 0.0) h += 1.0;
    }
    float s = (cmax == 0.0) ? 0.0 : delta / cmax;
    float v = cmax;
    return vec3(h, s, v);
}

vec3 hsv2rgb(vec3 c) {
    vec3 rgb = clamp(
        abs(mod(c.x * 6.0 + vec3(0.0, 4.0, 2.0), 6.0) - 3.0) - 1.0,
        0.0, 1.0
    );
    return c.z * mix(vec3(1.0), rgb, c.y);
}

// --- Utility: how close two colors are ---
float color_match(vec3 a, vec3 b) {
    return 1.0 - smoothstep(tolerance * 0.5, tolerance, length(a - b));
}

void fragment() {
	if (enabled == true) {
	    vec4 tex_color = texture(TEXTURE, UV);
	    vec3 color = tex_color.rgb;

	    // Detect red matches
	    float red_match = 0.0;
	    for (int i = 0; i < 6; i++) {
	        red_match = max(red_match, color_match(color, reds[i]));
	    }

	    // Detect yellow
	    float yellow_match = color_match(color, yellow);

	    // Convert to HSV for brightness/saturation preservation
	    vec3 hsv = rgb2hsv(color);
	    vec3 new_color = color;

	    if (red_match > 0.0) {
	        // Convert the chosen purple_target to HSV to get its hue
	        vec3 purple_hsv = rgb2hsv(purple_target.rgb);
	        hsv.x = purple_hsv.x; // shift hue to chosen purple
	        vec3 shifted = hsv2rgb(hsv);
	        new_color = mix(color, shifted, red_match * blend_strength);
	    } else if (yellow_match > 0.0) {
	        new_color = mix(color, gold_target.rgb, yellow_match * blend_strength);
	    }

	    COLOR = vec4(new_color, tex_color.a);
	}
}
