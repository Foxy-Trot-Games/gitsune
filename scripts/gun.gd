class_name Gun extends Node2D


@onready var muzzle: Node2D = %Muzzle
@onready var pulse: Pulse = %Pulse


const MAX_AMMO: int = 10

var player: Player
var debug_timer := 0.0  # Timer to throttle debug prints


func _ready() -> void:
	Events.current_gun_ammo(MAX_AMMO)
	pulse.pulse_activated_signal.connect(_on_pulse_activated_signal)
	Events.gun_equipped(MAX_AMMO) ## TODO will create a picked up function. 
	


func _process(delta: float) -> void:
	if player == null:
		player = get_parent()

	var mouse_pos: Vector2 = get_global_mouse_position()
	var target_pos: Vector2 = mouse_pos

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
	
	look_at(target_pos)

	queue_redraw()


func _on_pulse_activated_signal()->void:
	
	var _current_ammo_count = Globals.active_gun_ammo_count
	if _current_ammo_count < 2:
		pulse.can_pulse = false
		print(pulse.can_pulse)
	_current_ammo_count -= 1
	
	if _current_ammo_count > MAX_AMMO :
		_current_ammo_count = MAX_AMMO

	Events.current_gun_ammo(_current_ammo_count)



func _draw() -> void:
	if not is_instance_valid(muzzle):
		return

	var local_muzzle: Vector2 = muzzle.position
	
	draw_line(local_muzzle, get_local_mouse_position(), Color(0, 1, 0), 2, false)
