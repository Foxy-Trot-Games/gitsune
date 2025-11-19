class_name Gun extends Node2D

@onready var muzzle: Node2D = %Muzzle
@onready var pulse: Pulse = %Pulse

signal keyboard_used(dir: Vector2)
signal mouse_used(pos: Vector2)

var max_ammo: int = 3 :
	set(value):
		max_ammo = value
		current_ammo = value
		# send out signal to update displays
		_update_gun_stats()
var current_ammo : int
var player: Player

var _prev_mouse_pos := Vector2.ZERO

func _ready() -> void:
	player = get_parent()
	
	keyboard_used.connect(_keyboard_used)
	mouse_used.connect(_mouse_used)
	pulse.pulse_activated_signal.connect(_on_pulse_activated_signal)
	Events.ammo_picked_up.connect(_ammo_picked_up)
	
	max_ammo = player.max_ammo

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
	var mouse_pos: Vector2 = get_global_mouse_position()
	if mouse_pos.distance_squared_to(_prev_mouse_pos) > 100 || Input.is_action_just_pressed("pulse"):
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
	_update_gun_stats(max_ammo if ammo_amount == -1 else ammo_amount)

func _on_pulse_activated_signal() -> void:
	_update_gun_stats(-1)
	
func _update_gun_stats(ammo_amount: int = 0) -> void:
	current_ammo = clampi(current_ammo + ammo_amount, 0, max_ammo)
	Events.gun_stats_updated.emit(current_ammo, max_ammo)
