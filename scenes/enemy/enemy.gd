extends RigidBody2D

@export var PLAYER_NAME = "CharacterBody2D"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == PLAYER_NAME:
		print(PLAYER_NAME+" entred the area of an enemy")
		get_tree().reload_current_scene()
		
