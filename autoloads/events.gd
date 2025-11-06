extends Node

signal pulse_knockback_signal(direction: Vector2)
signal player_movement_input_signal
signal current_gun_ammo_signal(int)

func player_movement_input(direction:Vector2)->void:
	emit_signal("player_movement_input_signal", direction)
	
func pulse_knockback(direction:Vector2)->void:
	emit_signal("pulse_knockback_signal", direction)

func current_gun_ammo(ammo_count: int)->void:
	emit_signal("current_gun_ammo_signal", ammo_count)
