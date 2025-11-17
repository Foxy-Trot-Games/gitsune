class_name PulsingGlowVfx extends Sprite2D

func _ready() -> void:
	Events.gun_stats_updated.connect(_on_gun_stats_updated)

func _on_gun_stats_updated(ammo_count_left: int, max_ammo_count: int) -> void:
	var ammo_ratio := clampf(float(ammo_count_left) / float(max_ammo_count), 0.0, 1.0)
	(material as ShaderMaterial).set_shader_parameter("pulse_speed", lerp(0.0, 3.0, ammo_ratio))
