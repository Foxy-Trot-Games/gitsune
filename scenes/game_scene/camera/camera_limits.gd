extends Area2D

@onready var level: Level = $"../.."
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if level.started_from_main_menu():
		var shape := (collision_shape_2d.shape as RectangleShape2D)
		# for some reason the subviewport is messing up with the camera limits, so we adjust it here by the size amount
		shape.size += Vector2(640, 360)
