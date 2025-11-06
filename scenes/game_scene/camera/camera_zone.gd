@tool
extends Area2D

@export var player : Player

@onready var phantom_camera_2d: PhantomCamera2D = $PhantomCamera2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(player)
	phantom_camera_2d.follow_target = player
	
func _process(_delta: float) -> void:
	# if we are in the editor we want to redraw every frame so it updates correctly when editing
	if Engine.is_editor_hint():
		queue_redraw()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		phantom_camera_2d.priority = 10

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		phantom_camera_2d.priority = 0

func _draw() -> void:
	# snap camera zone position to exactly the resolution size so it doesn't overlap other zones
	position.x = snappedf(position.x, 640)
	position.y = snappedf(position.y, 360)
