class_name Level extends Node

signal level_lost
signal level_won
signal level_won_and_changed(level_path : String)

@export_file("*.tscn") var next_level_path : String

@onready var tutorial_manager: TutorialManager = %TutorialManager
@onready var player: Player = $Player

var level_state : LevelState

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_state = GameState.get_level_state(scene_file_path)
	if !level_state.tutorial_read:
		open_tutorials()
		
	for enemy: Enemy in get_tree().get_nodes_in_group("enemies"):
		print("Connecting enemy signal")
		enemy.player_hit.connect(_on_flying_enemey_player_hit)

func open_tutorials() -> void:
	tutorial_manager.open_tutorials()
	level_state.tutorial_read = true
	GlobalState.save()

func _on_flying_enemey_player_hit(_player: Player) -> void:
	player.die()

func _next_level_exit_area_entered(body: Node2D) -> void:
	if body is Player:
		if not next_level_path.is_empty():
			level_won_and_changed.emit(next_level_path)
		else:
			level_won.emit()
