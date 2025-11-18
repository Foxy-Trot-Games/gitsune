## Planning on using this to store Global Variables. 
extends Node

var air_movement := true

func get_level() -> Level:
	return get_tree().get_first_node_in_group("Level")
	
func get_player() -> Player:
	return get_tree().get_first_node_in_group("Player")

func add_child_to_level(node: Node) -> void:
	get_level().add_child(node)

func set_random_frame(animated_sprite_2d: AnimatedSprite2D, animation := "default") -> void:
	var sprite_frames := animated_sprite_2d.sprite_frames
	var frame_count: int = sprite_frames.get_frame_count(animation)
	var random_index: int = randi() % frame_count
	animated_sprite_2d.frame = random_index

func get_keyboard_pulse_fired_dir() -> Vector2:
	if Input.is_action_just_pressed("pulse_right") || Input.is_action_just_pressed("pulse_left") || \
		Input.is_action_just_pressed("pulse_up") || 	Input.is_action_just_pressed("pulse_down"):
		var pulse_dir := Vector2(Input.get_axis("pulse_right","pulse_left"), Input.get_axis("pulse_down","pulse_up"))
		return pulse_dir
	else:
		return Vector2.ZERO
