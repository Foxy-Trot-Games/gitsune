extends Node

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
