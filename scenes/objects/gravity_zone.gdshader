shader_type canvas_item;

uniform float wave_frequency = 10.0;
uniform float wave_speed = 4.0;
uniform float wave_amplitude = .005;
uniform vec3 wave_color: source_color = vec3(1.0);

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

vec4 overlay(vec4 base, vec4 blend) {
	vec4 limit = step(0.5, base);
	return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), limit);
}

void fragment() {
	float wave_x = sin(UV.x * wave_frequency + TIME * wave_speed) * wave_amplitude - wave_amplitude;
	float wave_y = cos(UV.y * wave_frequency + TIME * wave_speed) * wave_amplitude - wave_amplitude;
	
	vec2 water_uv = UV + vec2(wave_x, wave_y) * 5.0;
	vec4 water_color = texture(TEXTURE, water_uv);
	
	vec2 final_uv = SCREEN_UV + vec2(wave_x, wave_y);
	vec4 screen_color = texture(SCREEN_TEXTURE, final_uv);
	
	COLOR = overlay(water_color, screen_color);
	
	COLOR.rgb *= wave_color;
	
	//float wave2 = sin(UV.x * wave_frequency * 3.0 + TIME * -wave_speed * 2.0) * .002 - .002;
	//float foam = smoothstep(0.0, .005, 1.0 - UV.x + wave_y + wave2);
	//float foam2 = smoothstep(0.0, .005, UV.x + wave_y + wave2);
	//float foam3 = smoothstep(0.0, .005, 1.0 - UV.y + wave_x + wave2);
	//float foam4 = smoothstep(0.0, .005, UV.y + wave_x + wave2);
	//COLOR.a *= foam * foam2 * foam3 * foam4;
}