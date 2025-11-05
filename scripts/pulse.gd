class_name Pulse extends Node2D
@onready var player: Player = $".."

const PARTICLES = preload("uid://dmwmphp4y0bya")


const KNOCKBACK_IMPULSE: float = 300.0

var particle_throttle := Throttle.new(.2)


func apply_knockback_impulse(direction: Vector2) -> void:
	# This force is applied instantly on impact
	player.velocity += direction * KNOCKBACK_IMPULSE
	# clamp velocity to 2x impluse so additional impulses don't keep increasing to infinity
	player.velocity = player.velocity.clampf(-KNOCKBACK_IMPULSE * 2, KNOCKBACK_IMPULSE * 2)
	# remove any partial velocity so player can drop straight down
	player.velocity = player.velocity.snappedf(KNOCKBACK_IMPULSE)
	
	_create_sound_wave(direction)

func _create_sound_wave(direction: Vector2) -> void:
	# create new sound wave particle
	var particles : GPUParticles2D = PARTICLES.instantiate()
	particles.emitting = true
	
	# set particle emit direction
	var process_material : ParticleProcessMaterial = particles.process_material
	if direction == Vector2.ZERO:
		process_material.spread = 180
	else:
		process_material.direction = Vector3(-direction.x, -direction.y, 0.0) 
	
	add_child(particles)
	
	# free up particle node after its lifetime is done
	# todo probably a better way to do this
	await particles.finished
	particles.queue_free()
