@tool
extends Area2D

@onready var player: Player = %Player

@onready var phantom_camera_2d: PhantomCamera2D = $PhantomCamera2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(player)
	phantom_camera_2d.follow_target = player

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		phantom_camera_2d.priority = 10

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		phantom_camera_2d.priority = 0
