class_name PlayerController extends Node2D

@onready var player: Player = $".."

func _physics_process(_delta: float) -> void:
	var xdir := Input.get_axis("move_left", "move_right")
	var ydir := Input.get_axis("move_up", "move_down")
	
	Events.player_movement_input(Vector2(xdir, ydir))
