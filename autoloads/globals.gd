## Planning on using this to store Global Variables. 
extends Node

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

func create_timer(seconds: float, process_in_physics: bool = true) -> Signal:
	return get_tree().create_timer(seconds, true, process_in_physics).timeout

func print_all_properties(obj: Object) -> void:
	@warning_ignore("unsafe_property_access", "unsafe_cast")
	print("\nObject Property List for:", obj.name if obj.has_method("name") else (obj.get_script() as Script).get_global_name())
	var property_list := obj.get_property_list()
	for prop in property_list:
		if prop.usage & PROPERTY_USAGE_STORAGE or prop.usage & PROPERTY_USAGE_EDITOR:
			@warning_ignore("unsafe_call_argument")
			print(prop.name, ": ", obj.get(prop.name))

func _input(event: InputEvent) -> void:
	# enable mouse if it was hidden
	if event is InputEventMouseButton || event is InputEventMouseMotion:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	# hide mouse if using keyboard
	if event.is_action_pressed(&"pulse_right") || event.is_action_pressed(&"pulse_left") || \
		event.is_action_pressed(&"pulse_up") || event.is_action_pressed(&"pulse_down"):
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
