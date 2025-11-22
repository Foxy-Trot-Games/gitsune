class_name AmmoDisplay
extends Control

@onready var wave_animated_sprite_2d_2: AnimatedSprite2D = %WaveAnimatedSprite2D2
@onready var ammo_animated_sprite_2d: AnimatedSprite2D = %AmmoAnimatedSprite2D
@onready var player := Globals.get_player()

func _ready() -> void:
	# Connect your signals
	Events.gun_stats_updated.connect(_gun_stats_updated)
	Events.reactor_wave_moved.connect(_reactor_wave_moved)

func _gun_stats_updated(current_ammo: int, max_ammo: int) -> void:

	# set ammo level
	var sprite_frames := ammo_animated_sprite_2d.sprite_frames
	var frame_count: int = sprite_frames.get_frame_count("default")
	ammo_animated_sprite_2d.frame = clampi(current_ammo, 0, frame_count)

	# update color
	var color_lerp : Color = lerp(Color.RED, Color(0.498, 1.0, 0.659), float(current_ammo) / float(max_ammo))
	ammo_animated_sprite_2d.modulate = color_lerp

func _reactor_wave_moved(pos: Vector2, limit: Vector2) -> void:
	
	var sprite_frames := wave_animated_sprite_2d_2.sprite_frames
	var frame_count: int = sprite_frames.get_frame_count("default")
	
	# map the wave position to a sprite frame to use
	var frame_to_use : float = remap(pos.x, limit.x, limit.y, frame_count, 0)
	
	wave_animated_sprite_2d_2.frame = roundi(frame_to_use)
