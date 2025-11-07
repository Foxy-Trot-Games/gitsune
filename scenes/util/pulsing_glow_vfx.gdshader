// pulsing_glow_vfx.gdshader
shader_type canvas_item;
render_mode blend_add, unshaded;

/**
 * Glow color (use the inspector color picker)
 */
uniform vec4 glow_color : source_color = vec4(1.0, 0.85, 0.4, 1.0);

/** Pulse cycles per second */
uniform float pulse_speed : hint_range(0.0, 10.0, 0.01) = 1.0;

/** How much extra brightness the pulse adds (0 = no pulse) */
uniform float pulse_strength : hint_range(0.0, 4.0, 0.01) = 0.65;

/** Controls radial falloff softness (higher = softer) */
uniform float edge_softness : hint_range(0.1, 8.0, 0.01) = 1.6;

/** Base alpha multiplier for overall brightness */
uniform float base_alpha : hint_range(0.0, 2.0, 0.01) = 1.0;

/** Optional subtle noise flicker — increase for more organic shimmer */
uniform float noise_amount : hint_range(0.0, 1.0, 0.01) = 0.06;

/** Noise speed */
uniform float noise_speed : hint_range(0.0, 10.0, 0.01) = 1.0;

/* Simple 2D hash/noise function (cheap) */
float hash21(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 78.233);
    return fract(p.x * p.y);
}

void fragment() {
    // Base texture alpha used as mask (good when using a soft white circle texture)
    vec4 tex = texture(TEXTURE, UV);
    float mask = tex.a;

    // radial falloff (assumes texture UV 0..1, center at 0.5)
    vec2 centered = UV - vec2(0.5);
    float dist = length(centered) * 2.0; // normalized 0..~1
    float radial = pow(clamp(1.0 - dist, 0.0, 1.0), edge_softness);

    // main pulse 0..1
    float pulse = 0.5 + 0.5 * sin(TIME * pulse_speed * TAU);

    // cheap noise based on UV + time
    float n = hash21(UV * 37.0 + TIME * noise_speed);
    // smooth the noise a bit
    float noise = smoothstep(0.0, 1.0, n);

    // combine pulse and subtle noise
    float mod = 1.0 + pulse_strength * pulse + noise_amount * (noise - 0.5);

    float a = base_alpha * mask * radial * mod;
    // premultiply color by alpha for additive blending
    COLOR = vec4(glow_color.rgb * a, a);
}
