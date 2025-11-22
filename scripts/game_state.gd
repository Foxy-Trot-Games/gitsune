class_name GameState
extends Resource

const STATE_NAME : String = "GameState"
const FILE_PATH = "res://scripts/game_state.gd"

@export var player_state : PlayerState
@export var level_states : Dictionary = {}
@export var current_level_path : String
@export var current_door_id : int
#continue_level_path : String
@export var total_games_played : int
@export var play_time : int
@export var total_time : int

static func get_player_state() -> PlayerState:
	if not has_game_state(): 
		return
	var game_state := get_or_create_state()
	if game_state.player_state:
		return game_state.player_state
	else:
		var new_player_state := PlayerState.new()
		game_state.player_state = new_player_state
		GlobalState.save()
		return new_player_state

static func get_level_state(level_state_key : String) -> LevelState:
	if not has_game_state(): 
		return
	var game_state := get_or_create_state()
	if level_state_key.is_empty() : return
	if level_state_key in game_state.level_states:
		return game_state.level_states[level_state_key] 
	else:
		var new_level_state := LevelState.new()
		game_state.level_states[level_state_key] = new_level_state
		GlobalState.save()
		return new_level_state

static func has_game_state() -> bool:
	return GlobalState.has_state(STATE_NAME)

static func get_or_create_state() -> GameState:
	return GlobalState.get_or_create_state(STATE_NAME, FILE_PATH)

static func get_current_level_path() -> String:
	if not has_game_state(): 
		return ""
	var game_state := get_or_create_state()
	return game_state.current_level_path

static func get_current_door_id() -> int:
	if not has_game_state(): 
		return -1
	var game_state := get_or_create_state()
	return game_state.current_door_id

static func get_levels_reached() -> int:
	if not has_game_state(): 
		return 0
	var game_state := get_or_create_state()
	return game_state.level_states.size()
#
#static func level_reached(level_path : String) -> void:
	#var game_state := get_or_create_state()
	#game_state.current_level_path = level_path
	#game_state.continue_level_path = level_path
	#get_level_state(level_path)
	#GlobalState.save()

static func set_current_level(level_path : String) -> void:
	var game_state := get_or_create_state()
	game_state.current_level_path = level_path
	GlobalState.save()

static func set_current_door_id(door_id : int) -> void:
	var game_state := get_or_create_state()
	game_state.current_door_id = door_id
	GlobalState.save()

static func start_game() -> void:
	var game_state := get_or_create_state()
	game_state.total_games_played += 1
	Level.reset_global_variables()
	GlobalState.save()

static func continue_game() -> void:
	Level.reset_global_variables()
	GlobalState.save()

static func reset() -> void:
	var game_state := get_or_create_state()
	game_state.level_states = {}
	game_state.player_state = null
	game_state.current_level_path = ""
	game_state.current_door_id = -1
	game_state.play_time = 0
	game_state.total_time = 0
	Level.reset_global_variables()
	GlobalState.save()
