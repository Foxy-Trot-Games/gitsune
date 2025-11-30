extends LevelManager

var level_change_shortcut := Shortcut.new()
const ASSET_LEVEL := "uid://tthbu8e46oms"

var current_door_id : int : 
	set = _set_current_door_id

func _ready() -> void:
	super()
	_setup_debug_level_change()

func _setup_debug_level_change() -> void:
	var events := []
	
	for i in range(0,10):
		var key_event := InputEventKey.new()
		key_event.keycode = 48 + i as Key
		key_event.ctrl_pressed = true
		key_event.command_or_control_autoremap = true # Swaps Ctrl for Command on Mac.
		events.append(key_event)
		
	level_change_shortcut.events = events

func _shortcut_input(event: InputEvent) -> void:
	if level_change_shortcut.matches_event(event) and event.is_pressed() and not event.is_echo():
		var key_event : InputEventKey = event
		var key_pressed := key_event.keycode % 48 - 1
		
		if scene_lister.files.size() > key_pressed:
			current_level_path = scene_lister.files.get(key_pressed)
		else:
			current_level_path = ASSET_LEVEL
		
		PlayerState.add_max_ammo()
		PlayerState.add_max_ammo()
		PlayerState.add_max_ammo()
		PlayerState.add_max_ammo()
		
		load_current_level()

func _set_current_door_id(door_id : int) -> void:
	current_door_id = door_id
	GameState.set_current_door_id(door_id)

func set_current_level_path(value : String) -> void:
	super.set_current_level_path(value)
	GameState.set_current_level(value)

func get_current_level_path() -> String:
	var state_level_path := GameState.get_current_level_path()
	if not state_level_path.is_empty():
		current_level_path = state_level_path
	return super.get_current_level_path()

#func _advance_level() -> bool:
	#var _advanced := super._advance_level()
	#if _advanced:
		#GameState.level_reached(current_level_path)
	#return _advanced

func _connect_level_signals() -> void:
	super()
	_try_connecting_signal_to_level(&"level_exited", _level_exited)

func _level_exited(level_path: String, door_id: int) -> void:
	current_level_path = level_path
	current_door_id = door_id
	level_loader.load_level(level_path)
