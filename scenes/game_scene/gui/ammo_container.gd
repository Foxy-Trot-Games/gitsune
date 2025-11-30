class_name AmmoDisplay
extends Control

@onready var wave_animated_sprite_2d_2: AnimatedSprite2D = %WaveAnimatedSprite2D2
#@onready var ammo_animated_sprite_2d: AnimatedSprite2D = %AmmoAnimatedSprite2D
@onready var player := Globals.get_player()
@onready var bullets_spites: Array = %Bullets.get_children()
@onready var key: Sprite2D = $Control/Key

func _ready() -> void:
	# Connect your signals
	Events.gun_stats_updated.connect(_gun_stats_updated)
	Events.reactor_wave_moved.connect(_reactor_wave_moved)
	Events.gun_charging.connect(_gun_charging)
	Events.upgrade_picked_up.connect(_upgrade_picked_up)
	
	_show_key()

func _gun_charging() -> void:
	if player.gun.current_ammo != player.state.gun_max_ammo:
		var sprite : AnimatedSprite2D = bullets_spites[player.gun.current_ammo]
		sprite.play(&"charging")

func _gun_stats_updated(current_ammo: int, max_ammo: int) -> void:

	# set ammo level
	#var sprite_frames := ammo_animated_sprite_2d.sprite_frames
	#var frame_count: int = sprite_frames.get_frame_count("default")
	#ammo_animated_sprite_2d.frame = clampi(current_ammo, 0, frame_count)
#
	## update color
	#var color_lerp : Color = lerp(Color.RED, Color(0.498, 1.0, 0.659), float(current_ammo) / float(max_ammo))
	#ammo_animated_sprite_2d.modulate = color_lerp
	
	for i in range(bullets_spites.size()):
		var sprite : AnimatedSprite2D = bullets_spites[i]
		var num := i + 1
		
		if num > max_ammo:
			sprite.play(&"locked")
		elif num > current_ammo:
			sprite.play(&"spent")
		elif num <= current_ammo:
			sprite.play(&"ready")

func _show_key() -> void:
	var has_key := PlayerState.has_key(GameState.get_current_level_path())
	key.visible = has_key

func _upgrade_picked_up(_state: PlayerState) -> void:
	_show_key()

func _reactor_wave_moved(pos: Vector2, limit: Vector2) -> void:
	
	var sprite_frames := wave_animated_sprite_2d_2.sprite_frames
	var frame_count: int = sprite_frames.get_frame_count("default")
	
	# map the wave position to a sprite frame to use
	var frame_to_use : float = remap(pos.x, limit.x, limit.y, frame_count, 0)
	
	wave_animated_sprite_2d_2.frame = roundi(frame_to_use)
