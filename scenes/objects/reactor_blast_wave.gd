@tool
extends ColorRect

@export_enum("left","right") var start_position : int
@export var wave_speed := 1000 # pixels
@export var wave_interval := 3.0 # seconds

@onready var area_2d: Area2D = %Area2D
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = %AudioStreamPlayer2D
@onready var camera_2d: Camera2D = %Camera2D

const _additional_padding := Vector2(640,360)

enum Position {
	LEFT,
	RIGHT
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# get_tree() is needed so this works in the editor
	var level : Level = get_tree().get_first_node_in_group("Level")
	
	if !level:
		return
		
	await level.ready
	
	var level_rect := level.get_level_rect()
	
	var start_pos : Vector2
	var end_pos : Vector2
	
	if start_position == Position.LEFT:
		start_pos = level_rect.position - _additional_padding
		end_pos = level_rect.end + _additional_padding
		area_2d.gravity_direction = Vector2.RIGHT
	else:
		# top-right
		start_pos = Vector2(
			level_rect.position.x + level_rect.size.x + _additional_padding.x, 
			level_rect.position.y - _additional_padding.y
		)
		end_pos = level_rect.position - _additional_padding
		area_2d.gravity_direction = Vector2.LEFT
		
	position = start_pos
		
	size.y = level_rect.size.y + _additional_padding.y * 2
	
	# don't actually animate the wave in the editor
	if Engine.is_editor_hint():
		return
	
	var duration := (level_rect.size.x + _additional_padding.x) / wave_speed
	
	var tween := create_tween()
	tween.set_loops()
	tween.tween_property(self, "position", Vector2(end_pos.x, position.y), duration).from_current()
	tween.tween_interval(wave_interval - duration) # wait to start until interval
	tween.loop_finished.connect(func(i: int) -> void: 
		reset_physics_interpolation()
	)

func _physics_process(delta: float) -> void:
	# if we are in the editor we want to redraw every frame so it updates correctly when editing
	if Engine.is_editor_hint():
		return
		
	# set the audio_stream_player_2d y position to always align with the camera y position
	# this makes it so the audio_stream_player_2d will always be in the middle of the wave on screen no matter the player y coords
	audio_stream_player_2d.global_position.y = camera_2d.global_position.y

func _draw() -> void:
	
	# lock scale so it can't be changed
	scale = Vector2.ONE
	
	var center := size / 2
	
	# set element positions when the node is resized or position is updated
	area_2d.position = center
	
	var shape : RectangleShape2D = collision_shape_2d.shape
	shape.size = size
