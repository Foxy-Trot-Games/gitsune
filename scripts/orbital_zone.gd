@tool
extends Area2D

@onready var collision_shape_2d: CollisionShape2D = %GravityCollisionShape2D
@onready var gradient_texture_rect: TextureRect = $GradientTextureRect

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
	
	# set texture size
	gradient_texture_rect.position =  Vector2(-zone_radius, -zone_radius)
	gradient_texture_rect.size = Vector2(zone_radius * 2, zone_radius * 2)
		
	# set gradient size
	var gradient : GradientTexture2D = gradient_texture_rect.texture
	gradient.width = zone_radius
	gradient.height = zone_radius
	
	#draw_circle(Vector2(0,0), zone_radius, Color(1.0, 1.0, 1.0, 0.2), false)
