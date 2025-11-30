class_name Gun extends Node2D

@onready var pulse: Pulse = %Pulse

signal keyboard_used(dir: Vector2)
signal mouse_used(pos: Vector2)

var current_ammo : int
var player: Player

var _prev_mouse_pos := Vector2.ZERO

const PLAYER_PICKUP_FULL_AMMO_SOUND = preload("uid://4y2nkedvdudj")
const PLAYER_PICKUP_PARTIAL_AMMO_SOUND = preload("uid://chgeoqt7y3274")

func _ready() -> void:
	player = get_parent()
	
	keyboard_used.connect(_keyboard_used)
	mouse_used.connect(_mouse_used)
	pulse.pulse_activated_signal.connect(_on_pulse_activated_signal)
	Events.ammo_picked_up.connect(_ammo_picked_up)
	Events.player_died.connect(_player_died)
	
	# fill ammo
	_ammo_picked_up()

func _physics_process(delta: float) -> void:
	
	_check_if_using_mouse()
	_check_if_using_keyboard()

	# move the gun position so it's centered on the players mouth
	if player.player_sprite.flip_h:
		position.x = -abs(position.x)
	else:
		position.x = abs(position.x)
	
	# flip gun axis depending on its rotation so its never rotated upside down
	var angle := Vector2.from_angle(rotation)
	if angle.x > 0:
		scale.y = abs(scale.y)
	else:
		scale.y = -abs(scale.y)

func _check_if_using_mouse() -> void:
	var mouse_pos: Vector2 = DisplayServer.mouse_get_position()
	if mouse_pos.distance_squared_to(_prev_mouse_pos) > 10 || Input.is_action_just_pressed("pulse"):
		mouse_used.emit(mouse_pos)
	_prev_mouse_pos = mouse_pos
	
func _check_if_using_keyboard() -> void:
	var pulse_dir := Globals.get_keyboard_pulse_fired_dir()
	if pulse_dir:
		keyboard_used.emit(pulse_dir)

func _keyboard_used(dir: Vector2) -> void:
	# rotate gun to dir
	rotation = dir.angle()
	
func _mouse_used(pos: Vector2) -> void:
	look_at(get_global_mouse_position())

func _ammo_picked_up(ammo_amount: int = -1) -> void:
	if player.state.gun_max_ammo != current_ammo: # some things continuosly add ammo, so we only update if it's not at max ammo
		
		if ammo_amount == -1: # fill all ammo
			Audio.play_sfx(PLAYER_PICKUP_FULL_AMMO_SOUND, self)
			_update_gun_stats(player.state.gun_max_ammo)
		else:
			Audio.play_sfx(PLAYER_PICKUP_PARTIAL_AMMO_SOUND, self)
			_update_gun_stats(ammo_amount)

func _on_pulse_activated_signal() -> void:
	_update_gun_stats(-1)
	
func _update_gun_stats(ammo_amount: int = 0) -> void:
	current_ammo = clampi(current_ammo + ammo_amount, 0, player.state.gun_max_ammo)
	Events.gun_stats_updated.emit(current_ammo, player.state.gun_max_ammo)

func _player_died() -> void:
	queue_free()
