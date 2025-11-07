class_name AmmoDisplay
extends TextureRect

var max_ammo: int = 10
var current_ammo: int = 10

func _ready() -> void:
	# Connect your signals
	Events.current_gun_ammo_signal.connect(_on_current_gun_ammo_signal)
	Events.gun_equipped_signal.connect(_on_gun_equipped_signal)
	
	# Initialize shader with starting values
	_update_shader()

func _on_gun_equipped_signal(MAX_AMMO: int) -> void:
	max_ammo = MAX_AMMO
	current_ammo = MAX_AMMO  # start full
	_update_shader()

func _on_current_gun_ammo_signal(ammo_count: int) -> void:
	current_ammo = ammo_count
	_update_shader()
	print(self, ammo_count)


func _update_shader() -> void:
	if max_ammo == 0:
		return  # avoid division by zero
	
	if material and material is ShaderMaterial:
		material.set_shader_parameter("max_ammo", max_ammo)
		material.set_shader_parameter("current_ammo", current_ammo)
		var ammo_ratio = clamp(float(current_ammo) / float(max_ammo), 0.1, 1.0)
		material.set_shader_parameter("speed", 0.01 + 3.0 * ammo_ratio)
