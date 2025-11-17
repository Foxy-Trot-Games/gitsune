class_name AmmoDisplay
extends Control

@onready var color_rect: ColorRect = %PulseColorRect

func _ready() -> void:
	# Connect your signals
	Events.gun_stats_updated.connect(_gun_stats_updated)

func _gun_stats_updated(current_ammo: int, max_ammo: int) -> void:
	if color_rect.material and color_rect.material is ShaderMaterial:
		var shader : ShaderMaterial = color_rect.material
		
		# use current_ammo for max_ammo param so that the wave shrinks in wave number
		shader.set_shader_parameter("max_ammo", current_ammo)
		shader.set_shader_parameter("current_ammo", current_ammo)
		
		# update speed
		#var ammo_ratio := clampf(float(current_ammo) / float(max_ammo), 0.1, 1.0)
		#shader.set_shader_parameter("speed", 0.01 + 3.0 * ammo_ratio)
		
		# update color
		var color_lerp : Color = lerp(Color.RED, Color(0.498, 1.0, 0.659), float(current_ammo) / float(max_ammo))
		shader.set_shader_parameter("wave_color", color_lerp)
