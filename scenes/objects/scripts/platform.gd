extends Path2D

@export var speed := 50

@onready var path_follow_2d: PathFollow2D = $PathFollow2D
@onready var sprite_2d: Sprite2D = $AnimatableBody2D/Sprite2D

func _ready() -> void:
	for child: AnimatedSprite2D in sprite_2d.get_children():
		Globals.set_random_frame(child)

func _physics_process(delta: float) -> void:
	path_follow_2d.progress += speed * delta
