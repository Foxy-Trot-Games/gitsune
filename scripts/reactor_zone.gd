@tool
extends Area2D

@onready var collision_shape_2d: CollisionShape2D = %GravityCollisionShape2D

@export var zone_radius := 160 : 
	set(value):
		zone_radius = value
		queue_redraw()

func _physics_process(_delta: float) -> void:
	# if we are in the editor we want to redraw every frame so it updates correctly when editing
	if Engine.is_editor_hint():
		queue_redraw()

func _draw() -> void:
	
	(collision_shape_2d.shape as CircleShape2D).radius = zone_radius
	
	draw_circle(Vector2(0,0), zone_radius, Color(0,0,0,.2), true)
