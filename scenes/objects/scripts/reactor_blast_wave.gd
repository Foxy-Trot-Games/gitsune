@tool
extends Node2D

@export_enum("left","right") var start_position : int = Position.RIGHT
@export var wave_speed := 100 # pixels
## how many seconds it takes for wave to loop
@export var wave_period := 20.0 # seconds

@onready var area_2d: Area2D = %Area2D
@onready var _player : Player = get_player()
@onready var _x_offset := wave_speed * wave_period / 2

var _actual_wave_speed : int

enum Position {
	LEFT,
	RIGHT
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !_player:
		return
	
	if start_position == Position.RIGHT:
		area_2d.gravity_direction = Vector2.LEFT
		global_position.x = _player.global_position.x + _x_offset
		_actual_wave_speed = -wave_speed
	else:
		area_2d.gravity_direction = Vector2.RIGHT
		global_position.x = _player.global_position.x - _x_offset
		_actual_wave_speed = wave_speed

func _physics_process(delta: float) -> void:
	# don't animate in the editor
	if Engine.is_editor_hint():
		return
	
	# update the wave y so it's always on the player y
	global_position.y = _player.global_position.y
	
	# move the wave
	global_position.x +=  _actual_wave_speed * delta
	
	# wrap the wave if too far from player
	var wrapped_wave_x := wrapf(global_position.x, _player.global_position.x - _x_offset, _player.global_position.x + _x_offset)
	
	# wrapped should occured
	if wrapped_wave_x != global_position.x:
		global_position.x = wrapped_wave_x
		reset_physics_interpolation()

func get_player() -> Player:
	# get_tree() is needed so this works in the editor
	return get_tree().get_first_node_in_group("Player")
