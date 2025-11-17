## Planning on using this to store Global Variables. 
extends Node

func get_level() -> Level:
	return get_tree().get_first_node_in_group("Level")

func add_child_to_level(node: Node) -> void:
	get_level().add_child(node)

func set_random_frame(animated_sprite_2d: AnimatedSprite2D, animation := "default") -> void:
	var sprite_frames := animated_sprite_2d.sprite_frames
	var frame_count: int = sprite_frames.get_frame_count(animation)
	var random_index: int = randi() % frame_count
	animated_sprite_2d.frame = random_index
