extends Node

signal pulse_knockback_signal(direction: Vector2)
signal player_movement_input_signal

func player_movement_input(direction:Vector2)->void:
	emit_signal("player_movement_input_signal", direction)
	
func pulse_knockback(direction:Vector2)->void:
	emit_signal("pulse_knockback_signal", direction)
