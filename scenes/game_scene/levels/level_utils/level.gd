@tool
class_name Level extends Node2D

signal level_lost
signal level_won
signal level_won_and_changed(level_path : String)

@export var bgm: AudioStreamMP3
@export_file("*.tscn") var next_level_path : String

@onready var tutorial_manager: TutorialManager = %TutorialManager
@onready var player: Player = %Player
@onready var camera_2d: Camera2D = $CameraManager/Camera2D

const REACTOR_BLAST_WAVE = preload("uid://cnuggijmxgf0u")

var level_state : LevelState

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# don't load data or play music in the editor
	if !Engine.is_editor_hint():
		level_state = GameState.get_level_state(scene_file_path)
		if level_state && !level_state.tutorial_read:
			open_tutorials()
			
		Audio.play_bgm(bgm)
		
		# spawn first wave
		_spawn_reactor_wave()

func open_tutorials() -> void:
	tutorial_manager.open_tutorials()
	level_state.tutorial_read = true
	GlobalState.save()

## if level started from clicking start game from main menu
func started_from_main_menu() -> bool:
	return get_tree().current_scene is not Level

func _next_level_exit_area_entered(body: Node2D) -> void:
	if body is Player:
		if not next_level_path.is_empty():
			level_won_and_changed.emit(next_level_path)
		else:
			level_won.emit()

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

func _on_reactor_blast_wave_timer_timeout() -> void:
	_spawn_reactor_wave()
	
func _spawn_reactor_wave() -> void:
	var wave := REACTOR_BLAST_WAVE.instantiate()
	add_child(wave)
