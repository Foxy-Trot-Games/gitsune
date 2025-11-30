@tool
class_name Level extends Node2D

signal level_exited(to_level_path : String, door_id: int)
signal check_point_reached(check_point_pos: int)

@export var bgm: AudioStreamMP3

@onready var tutorial_manager: TutorialManager = %TutorialManager
@onready var player: Player = %Player
@onready var camera_2d: Camera2D = $CameraManager/Camera2D

static var current_check_point_pos := Vector2.INF

var level_state : LevelState :
	get():
		return GameState.get_level_state(scene_file_path)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# don't load data or play music in the editor
	if !Engine.is_editor_hint():
		#Audio.play_bgm(bgm)
		
		assert(!_get_exits().is_empty(), "Level %s must have an exit!" % GameState.get_current_level_path())
		
		var current_door_id_spawn := GameState.get_current_door_id()
		
		if started_from_main_menu():
			# move player to checkpoint or door
			if current_check_point_pos != Vector2.INF:
				player.global_position = current_check_point_pos
			elif current_door_id_spawn != -1:
				move_player_to_door(current_door_id_spawn)
		
		#print("== Player Data ==")
		#Globals.print_all_properties(GameState.get_player_state())

## if level started from clicking start game from main menu
func started_from_main_menu() -> bool:
	return get_tree().current_scene is not Level

func get_level_rect() -> Rect2:
	var rect := Rect2(
		# get top-left corner as position
		Vector2(camera_2d.limit_left, camera_2d.limit_top),
		# get width and height
		Vector2(
			camera_2d.limit_right - camera_2d.limit_left,
			camera_2d.limit_bottom - camera_2d.limit_top
		)
	)
	
	return rect

func _get_exits() -> Array[LevelExit]:
	var exits : Array[LevelExit] = []
	# needed in order to correctly set array type
	exits.assign(get_tree().get_nodes_in_group("LevelExit"))
	return exits

func move_player_to_door(door_id: int) -> void:
	var exits := _get_exits()
	var index := door_id - 1
	if index >= 0 && index < exits.size():
		var exit := exits[index]
		exit.door_used.emit()
		player.global_position = exit.global_position
	else:
		push_error("Door ID %s is invalid or not found! Must be between 1 and %s." % [door_id, exits.size()])

func _on_check_point_reached(check_point_pos: Vector2) -> void:
	current_check_point_pos = check_point_pos

func _on_level_exited(to_level_path: String, door_id: int) -> void:
	current_check_point_pos = Vector2.INF

static func reset_global_variables() -> void:
	current_check_point_pos = Vector2.INF
