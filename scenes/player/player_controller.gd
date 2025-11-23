class_name PlayerController extends Node2D

@onready var player: Player = $".."

func _physics_process(_delta: float) -> void:
	
	if player._dead:
		Events.player_movement_input(Vector2.ZERO)
		return
	
	var input_vect := Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
	
	Events.player_movement_input(input_vect)
