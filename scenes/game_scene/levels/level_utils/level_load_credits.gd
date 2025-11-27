@tool
extends Level

func _on_level_exited(to_level_path: String, door_id: int) -> void:
	super(to_level_path, door_id)
	var door := _get_exits()[-1]
	if door.exit_to_level == to_level_path && door.exit_door_id == door_id: # door to next area
		SceneLoader.load_scene(AppConfig.ending_scene_path)
