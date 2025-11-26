class_name Globals

static var scene_tree : SceneTree :
	get():
		return Engine.get_main_loop()

static func get_level() -> Level:
	return scene_tree.get_first_node_in_group("Level")
	
static func get_player() -> Player:
	return scene_tree.get_first_node_in_group("Player")

static func add_child_to_level(node: Node) -> void:
	get_level().add_child(node)

static func get_nodes_in_group(group: String) -> Array[Node]:
	return scene_tree.get_nodes_in_group(group)

static func set_random_frame(animated_sprite_2d: AnimatedSprite2D, animation := "default") -> void:
	var sprite_frames := animated_sprite_2d.sprite_frames
	var frame_count: int = sprite_frames.get_frame_count(animation)
	var random_index: int = randi() % frame_count
	animated_sprite_2d.frame = random_index

static func get_keyboard_pulse_fired_dir() -> Vector2:
	if Input.is_action_just_pressed("pulse_right") || Input.is_action_just_pressed("pulse_left") || \
		Input.is_action_just_pressed("pulse_up") || 	Input.is_action_just_pressed("pulse_down"):
		var pulse_dir := Vector2(Input.get_axis("pulse_right","pulse_left"), Input.get_axis("pulse_down","pulse_up"))
		return pulse_dir
	else:
		return Vector2.ZERO

static func create_timer(seconds: float, process_in_physics: bool = true) -> Signal:
	return scene_tree.create_timer(seconds, true, process_in_physics).timeout

static func print_all_properties(obj: Object) -> void:
	@warning_ignore("unsafe_property_access", "unsafe_cast")
	print("\nObject Property List for:", obj.name if obj.has_method("name") else (obj.get_script() as Script).get_global_name())
	var property_list := obj.get_property_list()
	for prop in property_list:
		if prop.usage & PROPERTY_USAGE_STORAGE or prop.usage & PROPERTY_USAGE_EDITOR:
			@warning_ignore("unsafe_call_argument")
			print(prop.name, ": ", obj.get(prop.name))
	print("")
