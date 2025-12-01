extends Node2D


func load_end_credits() -> void:
	SceneLoader.load_scene(AppConfig.ending_scene_path)
