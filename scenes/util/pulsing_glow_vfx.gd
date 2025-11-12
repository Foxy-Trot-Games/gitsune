class_name PulsingGlowVfx extends Sprite2D





var _current_ammo_count: int
var _MAX_AMMO_COUNT: int


func _ready() -> void:
	Events.current_gun_ammo_signal.connect(_on_current_gun_ammo_signal)
	Events.gun_equipped_signal.connect(_on_gun_equipped_signal)
	_current_ammo_count = Globals.active_gun_ammo_count

func _on_current_gun_ammo_signal(ammo_count: int) -> void:
	_current_ammo_count = ammo_count

	var ammo_ratio: float = 0.0
	ammo_ratio = clamp(float(_current_ammo_count) / float(_MAX_AMMO_COUNT), 0.0, 1.0)

	material.set_shader_parameter("pulse_speed", lerp(0.0, 3.0, ammo_ratio))




func _on_gun_equipped_signal(MAX_COUNT: int)->void:
	_MAX_AMMO_COUNT = MAX_COUNT
	pass
	
