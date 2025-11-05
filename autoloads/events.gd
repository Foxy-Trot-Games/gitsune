extends Node


signal player_movement_input_signal

func player_movement_input(direction:Vector2)->void:
	emit_signal("player_movement_input_signal", direction)
	
