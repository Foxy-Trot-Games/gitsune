## Temp node to display Ammo Count untill we make UI/GUI/Player HUD. 
class_name AmmoCount extends Label

var _display_current_ammo_count: String

func _ready() -> void:
	Events.current_gun_ammo_signal.connect(_on_current_gun_ammo_signal)
	_display_current_ammo_count = str(Globals.active_gun_ammo_count)
	set_text(_display_current_ammo_count)
	



func _on_current_gun_ammo_signal(ammo_count: int)->void:
	_display_current_ammo_count = str(ammo_count)
	set_text(_display_current_ammo_count)
