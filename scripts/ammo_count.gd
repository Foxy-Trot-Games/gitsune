## Temp node to display Ammo Count untill we make UI/GUI/Player HUD. 
class_name AmmoCount extends Label

func _ready() -> void:
	Events.gun_stats_updated.connect(_gun_stats_updated)

func _gun_stats_updated(ammo_count: int, max_count: int)->void:
	text = "%s/%s" % [ammo_count, max_count]
