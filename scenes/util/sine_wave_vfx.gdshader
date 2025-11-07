shader_type canvas_item;

uniform int max_ammo : hint_range(1,50) = 10;
uniform int current_ammo : hint_range(0,50) = 10;

uniform float base_amplitude : hint_range(0.0,0.3) = 0.1;
uniform float speed : hint_range(0.0,10.0) = 2.0;
uniform float pulse_speed : hint_range(0.0,10.0) = 1.0;
uniform float thickness : hint_range(0.0,0.1) = 0.02;
uniform float glow_size : hint_range(0.0,0.1) = 0.05;
uniform vec4 wave_color : source_color = vec4(0.0,0.8,1.0,1.0);

// cheap pseudo-random hash (works fine in canvas shaders)
float hash(float x) {
    return fract(sin(x * 12.9898) * 43758.5453);
}

void fragment() {
    vec2 uv = UV;

    // safety
    float safe_max = max(float(max_ammo), 1.0);
    float safe_current = clamp(float(current_ammo), 0.0, safe_max);

    // normalized ammo
    float fill_ratio = safe_current / safe_max;

    // pulse
    float pulse = 0.5 + 0.5 * sin(TIME * pulse_speed);

    // non-linear scaling so low ammo shrinks more
    float ammo_factor = pow(fill_ratio, 0.5);

    // minimum amplitude that scales with ammo
    float min_amp = 0.01 + 0.03 * ammo_factor;

    // --- Per-peak smooth variation (no jumps) ---
    // position in "peak space" (0..safe_max)
    float pos = uv.x * safe_max;
    float idx_f = floor(pos);                 // integer index for current peak
    float local = fract(pos);                 // 0..1 inside the peak segment

    // get two hash values (current peak and next peak)
    float h0 = hash(idx_f);
    float h1 = hash(idx_f + 1.0);

    // smooth the interpolation so it's not abrupt at edges
    float t = smoothstep(0.0, 1.0, local);

    // map hash (0..1) into a variation multiplier range, e.g. 0.7 .. 1.3
    float peak0 = 0.7 + 0.6 * h0;
    float peak1 = 0.7 + 0.6 * h1;

    // smoothly blended variation for this uv.x
    float peak_variation = mix(peak0, peak1, t);

    // final amplitude uses ammo_factor, pulse and per-peak variation
    float scaled_amplitude = (base_amplitude * ammo_factor * pulse * peak_variation) + min_amp;

    // --- continuous wave that spans the whole bar ---
    float wave_frequency = safe_max; // conceptual 1 peak per ammo
    float phase = uv.x * 6.28318530718 * wave_frequency - TIME * speed;
    float wave_y = 0.5 + sin(phase) * scaled_amplitude;

    // small extra organic jitter
    wave_y += sin(uv.x * 12.56637 + TIME * speed * 0.5) * 0.01;

    // render line with soft glow
    float dist = abs(uv.y - wave_y);
    // make the smoothstep thresholds slightly softer to hide micro-artifacts
    float line_mask = smoothstep(thickness + glow_size * 1.05, glow_size * 0.9, dist);

    // alpha by mask
    COLOR = vec4(wave_color.rgb, wave_color.a * line_mask);
}
