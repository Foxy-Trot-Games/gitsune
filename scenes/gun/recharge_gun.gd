extends Node2D

@onready var player: Player = $".."

func _on_timer_timeout() -> void:
	if player.is_on_floor():
		var increase_ammo_count: int = Globals.active_gun_ammo_count + 1
		Events.current_gun_ammo(increase_ammo_count)
