@tool
class_name LevelLoader
extends Node
## Loads scenes into a container.

signal level_load_started
signal level_loaded
signal level_ready

## Container where the level instance will be added.
@export var level_container : Node
## Optional reference to a loading screen in the scene.
@export var level_loading_screen : LoadingScreen
@export_group("Debugging")
@export var current_level : Level

@onready var screen_transition_effect: ColorRect = %ScreenTransitionEffect
@onready var animation_player: AnimationPlayer = %AnimationPlayer

var is_loading : bool = false

func _attach_level(level_resource : Resource):
	assert(level_container != null, "level_container is null")
	var instance = level_resource.instantiate()
	level_container.call_deferred("add_child", instance)
	return instance

func load_level(level_path : String, spawn_at_door_id := -1):
	if is_loading : return
	
	is_loading = true
	
	if is_instance_valid(current_level):
		await _fade_out()
		current_level.queue_free()
		await current_level.tree_exited
		current_level = null
		
	SceneLoader.load_scene(level_path, true)
	if level_loading_screen:
		level_loading_screen.reset()
	level_load_started.emit()
	await SceneLoader.scene_loaded
	is_loading = false
	current_level = _attach_level(SceneLoader.get_resource())
	
	if level_loading_screen:
		level_loading_screen.close()
	level_loaded.emit()
	await current_level.ready
	current_level.update_player_pos(spawn_at_door_id)
	level_ready.emit()
	await _fade_in()

func _fade_out() -> Signal:
	get_tree().paused = true
	animation_player.play(&"fade_out")
	return animation_player.animation_finished

func _fade_in() -> Signal:
	get_tree().paused = false
	animation_player.play(&"fade_in")
	var finished := animation_player.animation_finished
	return finished
	
