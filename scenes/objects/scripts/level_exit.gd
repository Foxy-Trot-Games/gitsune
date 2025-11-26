@tool
class_name LevelExit extends Area2D

@onready var debug_label: Label = $DebugLabel
@onready var debug_label_2: Label = $DebugLabel2
@onready var locked_panel: Panel = $LockedPanel
@onready var door_1_animated_sprite_2d: AnimatedSprite2D = $Door1AnimatedSprite2D
@onready var door_2_animated_sprite_2d: AnimatedSprite2D = $Door2AnimatedSprite2D
@onready var level_state : LevelState = Globals.get_level().level_state

@export var id := -1 :
	set(value):
		id = value
		_update_label_text()
@export_file("*.tscn") var exit_to_level := default_level_dir :
	set(value):
		exit_to_level = value
		_update_label_text()
@export var exit_door_id := -1 :
	set(value):
		exit_door_id = value
		_update_label_text()
@export var lockable := false

const default_level_dir := "res://scenes/game_scene/levels/"
var _door_disabled := false

signal door_used

# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	var exits := get_tree().get_nodes_in_group("LevelExit")
	id = exits.size()

func _ready() -> void:
	if owner: # prevents code from running unless added to a level
		assert(id != -1, "Door should have an ID! %s" % owner)
		assert(exit_to_level != default_level_dir, "Door should have exit level set! %s" % owner)
		assert(exit_door_id != -1, "No door id set! %s" % owner)
		
		if lockable && !level_state.exit_unlocked():
			door_1_animated_sprite_2d.play(&"locked")
			door_2_animated_sprite_2d.play(&"locked")
		
func _draw() -> void:
	_update_label_text()

func _update_label_text() -> void:
	
	if !Engine.is_editor_hint():
		if debug_label:
			debug_label.queue_free()
		if debug_label_2:
			debug_label_2.queue_free()
		return
		
	if debug_label && debug_label_2:
		var path := ResourceUID.ensure_path(exit_to_level)
		debug_label.text = "Door %s" % [id]
		debug_label_2.text = "Exit to %s door %s" % [path.get_file().replace(".tscn",""), exit_door_id]

func _on_body_entered(body: Node2D) -> void:
	if body is Player && !_door_disabled:
		
		if lockable && !level_state.exit_unlocked():
			if PlayerState.has_key(GameState.get_current_level_path()):
				level_state.unlock_exit()
				door_1_animated_sprite_2d.play(&"opening")
				door_2_animated_sprite_2d.play(&"opening")
				await door_2_animated_sprite_2d.animation_finished
				Globals.get_level().level_exited.emit(exit_to_level, exit_door_id)
			else:
				locked_panel.visible=true
		else:
			Globals.get_level().level_exited.emit(exit_to_level, exit_door_id)


func _on_body_exited(body: Node2D) -> void:
	locked_panel.visible=false
	_door_disabled = false

func _on_door_used() -> void:
	# disable door until player leaves it's area
	_door_disabled = true

func _validate_property(property: Dictionary) -> void:
	# disable id in the editor so it's readonly
	if property.name == "id":
		property.usage |= PROPERTY_USAGE_READ_ONLY
