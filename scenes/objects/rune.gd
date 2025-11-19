class_name Rune extends Node2D

var _rune_id := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# generate a unique hash based on the level name and the global position
	_rune_id = hash("%s-%s-%s" % [GameState.get_current_level_path(), global_position.x, global_position.y])
	
	var level_runes : Dictionary[int, bool] = Globals.get_level().level_state.rune_ids
	if level_runes.has(_rune_id):
		queue_free()
	
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		# pick up rune
		PlayerState.add_rune(_rune_id)
		queue_free()
