class_name Pulse
extends Node2D

const PARTICLES = preload("uid://dmwmphp4y0bya")
const KNOCKBACK_IMPULSE: float = 200.0


var particle_throttle := Throttle.new(.2)
var pulse_cooldown: float = 0.2
var can_pulse: bool = true

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
	else:
		process_material.direction = Vector3(-direction.x, -direction.y, 0)

	add_child(particles)

	# Free after lifetime
	var lifetime := particles.lifetime
	await get_tree().create_timer(lifetime).timeout
	particles.queue_free()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("pulse") and can_pulse:
		apply_knockback_impulse(Vector2(0.0, -1.0))
		can_pulse = false
		await get_tree().create_timer(pulse_cooldown).timeout
		can_pulse = true
