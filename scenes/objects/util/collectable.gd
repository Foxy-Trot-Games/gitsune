class_name Collectable extends Area2D

var _id := 0
var collect_callable := Callable()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# generate a unique hash based on the level name and the global position
	_id = hash("%s-%s-%s" % [GameState.get_current_level_path(), global_position.x, global_position.y])
	
	var level_collectables : Dictionary[int, bool] = Globals.get_level().level_state.collectable_ids
	# delete the collectable if it was collected in the level state
	if level_collectables.has(_id):
		queue_free()
	
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		collected(_id)
		queue_free()

func collected(id: int) -> void:
	push_error("Implement in a child class!")
