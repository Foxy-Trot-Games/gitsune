class_name Pulse
extends Node2D


const PARTICLES = preload("uid://dmwmphp4y0bya")
const KNOCKBACK_IMPULSE: float = 200.0

var particle_throttle := Throttle.new(.2)



func apply_knockback_impulse(direction: Vector2) -> void:
	var knock_back_force = direction * KNOCKBACK_IMPULSE
	
	_create_sound_wave(direction)
	Events.player_movement_input(knock_back_force)

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
	var lifetime = particles.lifetime
	await get_tree().create_timer(lifetime).timeout
	particles.queue_free()

func _process(_delta: float) -> void:
	if Input.is_action_pressed("pulse"):
		apply_knockback_impulse(Vector2(0.0, -1.0))
