@tool
class_name Level extends Node2D

signal level_exited(to_level_path : String, door_id: int)

@export var bgm: AudioStreamMP3
@export_file("*.tscn") var next_level_path : String

@onready var tutorial_manager: TutorialManager = %TutorialManager
@onready var player: Player = %Player
@onready var camera_2d: Camera2D = $CameraManager/Camera2D

var level_state : LevelState

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# don't load data or play music in the editor
	if !Engine.is_editor_hint():
		level_state = GameState.get_level_state(scene_file_path)
			
		Audio.play_bgm(bgm)
		
		assert(!_get_exits().is_empty(), "Level %s must have an exit!" % GameState.get_current_level_path())
		
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

func update_player_pos(spawn_at_door: int) -> void:
	if spawn_at_door != -1:
		var exits := _get_exits()
		var index := spawn_at_door - 1
		if index <= exits.size():
			var exit := exits[index]
			player.global_position = exit.global_position
			exit.door_used.emit()
		else:
			push_error("Door id %s not found!" % index)
