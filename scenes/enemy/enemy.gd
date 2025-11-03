extends RigidBody2D

@export var PLAYER_NAME:String = "CharacterBody2D"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == PLAYER_NAME:
		print(PLAYER_NAME + " entered the area of an enemy")
		call_deferred("_restart_scene")


func _restart_scene() -> void:
	get_tree().reload_current_scene()
	
		
