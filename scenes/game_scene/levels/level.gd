extends Node

@export_file("*.tscn") var next_level_path : String

@onready var tutorial_manager: TutorialManager = %TutorialManager

var level_state : LevelState

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_state = GameState.get_level_state(scene_file_path)
	if !level_state.tutorial_read:
		open_tutorials()

func open_tutorials() -> void:
	tutorial_manager.open_tutorials()
	level_state.tutorial_read = true
	GlobalState.save()
