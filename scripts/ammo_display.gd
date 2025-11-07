class_name AmmoDisplay extends ProgressBar


func _ready() -> void:
	Events.current_gun_ammo_signal.connect(_on_current_gun_ammo_signal)
	Events.gun_equipped_signal.connect(_on_gun_equipped_signal)

	

func _on_gun_equipped_signal(MAX_AMMO: int) -> void:
	set_max(MAX_AMMO)



func _on_current_gun_ammo_signal(ammo_count: int) -> void:
	set_value(ammo_count)
	print(self, ammo_count)
