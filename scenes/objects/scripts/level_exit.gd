@tool
class_name LevelExit extends Area2D

@onready var label: Label = $Label
@onready var label_2: Label = $Label2

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
		
func _draw() -> void:
	_update_label_text()

func _update_label_text() -> void:
	if label && label_2:
		var path := ResourceUID.ensure_path(exit_to_level)
		label.text = "Door %s" % [id]
		label_2.text = "Exit to %s door %s" % [path.get_file().replace(".tscn",""), exit_door_id]

func _on_body_entered(body: Node2D) -> void:
	if body is Player && !_door_disabled:
		Globals.get_level().level_exited.emit(exit_to_level, exit_door_id)

func _on_body_exited(body: Node2D) -> void:
	_door_disabled = false

func _on_door_used() -> void:
	# disable door until player leaves it's area
	_door_disabled = true
	
func _validate_property(property: Dictionary) -> void:
	# disable id in the editor so it's readonly
	if property.name == "id":
		property.usage |= PROPERTY_USAGE_READ_ONLY
