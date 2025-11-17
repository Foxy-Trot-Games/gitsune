@tool
extends Area2D

@onready var collision_shape_2d: CollisionShape2D = %GravityCollisionShape2D

func _draw() -> void:
	var radius := (collision_shape_2d.shape as CircleShape2D).radius
	
	draw_circle(Vector2(0,0), radius, Color(0,0,0,.2), true)
