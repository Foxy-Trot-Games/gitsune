class_name Pulse
extends Node2D

signal pulse_activated_signal

@onready var gun: Gun = $".."

const PARTICLES = preload("uid://oc3nknueoo5d")  # SoundParticles scene with collision detection
const KNOCKBACK_IMPULSE: float = 200.0

var pulse_cooldown: float = 0.1
var pulse_throttle := Throttle.new(pulse_cooldown)

func apply_knockback_impulse(direction: Vector2) -> void:
	# Emit a knockback signal instead of changing velocity
	Events.pulse_knockback(direction * KNOCKBACK_IMPULSE)
	_create_sound_wave(direction)

func _create_sound_wave(direction: Vector2) -> void:
	var particles: GPUParticles2D = PARTICLES.instantiate()
	particles.emitting = true

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
	if Input.is_action_just_pressed("pulse") and gun.current_ammo > 0:
		pulse_throttle.call_throttled(_fire_pulse)
		
func _fire_pulse() -> void:
	pulse_activated_signal.emit()
	var rotation_normal_vector: Vector2 = Vector2.from_angle(gun.rotation)
	# impulse player opposite where the gun is pointing
	apply_knockback_impulse(-rotation_normal_vector)
