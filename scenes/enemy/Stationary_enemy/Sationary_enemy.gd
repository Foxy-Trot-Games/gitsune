extends Enemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		print("%s entered the area of an enemy" % body.get_class())
		call_deferred("_restart_scene")


func _restart_scene() -> void:
	get_tree().reload_current_scene()
	
		
