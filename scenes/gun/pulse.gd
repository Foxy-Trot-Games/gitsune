class_name Pulse
extends Node2D

signal pulse_activated_signal

@onready var gun: Gun = $".."

const KNOCKBACK_IMPULSE: float = 200.0

var pulse_cooldown: float = 0.1
var pulse_throttle := Throttle.new(pulse_cooldown)

var _prev_pulse_dir : Vector2

const PARTICLES_SCENE = preload("uid://oc3nknueoo5d")  # SoundParticles scene with collision detection
const PLAYER_WAVEGUN_SOUND = preload("uid://cuq5vtch23uxj")
const PLAYER_WAVEGUN_EMPTY_SOUND = preload("uid://0wpuvqrl7u61")

func apply_knockback_impulse(direction: Vector2) -> void:
	var tmp := direction * KNOCKBACK_IMPULSE
	# double verticle impulse, makes it feel nicer
	tmp.y *= 2
	# Emit a knockback signal instead of changing velocity
	Events.pulse_knockback(tmp)
	_create_sound_wave(direction)

func _create_sound_wave(direction: Vector2) -> void:
	var particles: GPUParticles2D = PARTICLES_SCENE.instantiate()
	particles.emitting = true
	
	if gun.current_ammo == 0: # last pulse
		Audio.play_sfx(PLAYER_WAVEGUN_EMPTY_SOUND, self)
	else:
		Audio.play_sfx(PLAYER_WAVEGUN_SOUND, self)

	var process_material: ParticleProcessMaterial = particles.process_material
	if direction == Vector2.ZERO:
		process_material.spread = 180
		
	particles.global_position = global_position
	particles.rotation = gun.rotation
	Globals.add_child_to_level(particles)
	
	var lifetime := particles.lifetime
	await get_tree().create_timer(lifetime).timeout
	particles.queue_free()

func _physics_process(delta: float) -> void:
	
	if gun.current_ammo <= 0:
		return
	
	if Input.is_action_just_pressed("pulse"):
		pulse_throttle.call_throttled(_fire_pulse)
	
	var pulse_dir := Globals.get_keyboard_pulse_fired_dir()
	
	# add a one frame delay to keyboard input so that diagonal inputs are more consistently detected
	if _prev_pulse_dir:
		pulse_throttle.call_throttled(_fire_pulse)
		_prev_pulse_dir = Vector2.ZERO
	else:
		_prev_pulse_dir = pulse_dir
		
func _fire_pulse() -> void:
	pulse_activated_signal.emit()
	var rotation_normal_vector: Vector2 = Vector2.from_angle(gun.rotation)
	# impulse player opposite where the gun is pointing
	apply_knockback_impulse(-rotation_normal_vector)
