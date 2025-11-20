extends Node

signal pulse_knockback_signal(direction: Vector2)
signal player_movement_input_signal
signal entered_gravity_zone(allow_movement: bool)
signal exited_gravity_zone(allow_movement: bool)

signal ammo_picked_up(amount_picked_up: int)
signal upgrade_picked_up(state: PlayerState)
signal gun_stats_updated(ammo_count_left: int, max_ammo: int)
signal player_died

func player_movement_input(direction:Vector2) -> void:
	emit_signal("player_movement_input_signal", direction)
	
func pulse_knockback(direction:Vector2) -> void:
	emit_signal("pulse_knockback_signal", direction)
