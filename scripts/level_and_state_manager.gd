extends LevelManager

var level_change_shortcut := Shortcut.new()
const ASSET_LEVEL := "uid://tthbu8e46oms"

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
		var file : Variant = scene_lister.files.get(key_pressed)
		
		if file:
			current_level_path = file
		else:
			current_level_path = ASSET_LEVEL
		
		load_current_level()

func set_current_level_path(value : String) -> void:
	super.set_current_level_path(value)
	GameState.set_current_level(value)
	GameState.get_level_state(value)

func get_current_level_path() -> String:
	var state_level_path := GameState.get_current_level_path()
	if not state_level_path.is_empty():
		current_level_path = state_level_path
	return super.get_current_level_path()

func _advance_level() -> bool:
	var _advanced := super._advance_level()
	if _advanced:
		GameState.level_reached(current_level_path)
	return _advanced
