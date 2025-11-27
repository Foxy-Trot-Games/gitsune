@tool
extends Level

func _on_level_exited(to_level_path: String, door_id: int) -> void:
	SceneLoader.load_scene(AppConfig.ending_scene_path)
