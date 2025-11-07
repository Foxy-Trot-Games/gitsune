extends Node2D

func _ready() -> void:
	pass

func _on_timer_timeout() -> void:
	var player : Player = get_parent()
	if player.is_on_floor():
		var increase_ammo_count: int = Globals.active_gun_ammo_count + 1
		Events.current_gun_ammo(increase_ammo_count)
