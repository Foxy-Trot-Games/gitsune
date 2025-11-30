@tool
extends ColorRect

@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var visible_on_screen_enabler_2d: VisibleOnScreenEnabler2D = $VisibleOnScreenEnabler2D
@onready var spawn_position: Marker2D = %SpawnPosition
@onready var animated_sprite_2d: AnimatedSprite2D = $Control/AnimatedSprite2D

@export var id := -1 :
	set(value):
		id = value

var _activated := false

const CHECKPOINT_TRIGGER_SOUND = preload("uid://40bxaid5f1cb")

func _enter_tree() -> void:
	var check_points := get_tree().get_nodes_in_group("CheckPoint")
	id = check_points.size()
	
	if !Engine.is_editor_hint():
		Globals.get_level().check_point_reached.connect(_check_point_reached)

func _physics_process(_delta: float) -> void:
	# if we are in the editor we want to redraw every frame so it updates correctly when editing
	if Engine.is_editor_hint():
		queue_redraw()

func _draw() -> void:
	# lock scale so it can't be changed
	scale = Vector2.ONE
	
	var center := size / 2
	
	# set element positions when the node is resized or position is updated
	area_2d.position = center
	
	var shape : RectangleShape2D = collision_shape_2d.shape
	shape.size = size
	
	# set the visible_on_screen_enabler_2d rect, since it doesn't have size we have to build one to assign to rect
	visible_on_screen_enabler_2d.rect = Rect2(Vector2.ZERO, size)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player && !_activated:
		Audio.play_sfx(CHECKPOINT_TRIGGER_SOUND, self, 100, -20, 0)
		Globals.get_level().check_point_reached.emit(spawn_position.global_position)
		_activated = true
		animated_sprite_2d.play(&"charging")
		await animated_sprite_2d.animation_finished
		animated_sprite_2d.play(&"active")

func _check_point_reached(pos: Vector2) -> void:
	animated_sprite_2d.play(&"inactive")
	_activated = false

func _validate_property(property: Dictionary) -> void:
	# disable id in the editor so it's readonly
	if property.name == "id":
		property.usage |= PROPERTY_USAGE_READ_ONLY
