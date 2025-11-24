extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $Area2D/AnimatedSprite2D

func _ready() -> void:
	Globals.set_random_frame(animated_sprite_2d)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		Events.player_died.emit()
	if body is IAEnemy:
		body.queue_free()
		print("yes enemy there")
