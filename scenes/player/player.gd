extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D

const PARTICLES = preload("uid://dmwmphp4y0bya")

const HORIZONTAL_SPEED = 300.0
const JUMP_VELOCITY = -400.0
const KNOCKBACK_IMPULSE_Y: float = 300.0

func apply_knockback_impulse(direction: Vector2) -> void:
	# This force is applied instantly on impact
	velocity += direction * KNOCKBACK_IMPULSE_Y
	# clamp velocity so it doesn't keep going to infinity
	velocity = velocity.clampf(-600,600)
	
	_create_sound_wave(direction)

func _create_sound_wave(direction: Vector2) -> void:
	# create new sound wave particle
	var particles : GPUParticles2D = PARTICLES.instantiate()
	particles.emitting = true
	
	# set particle emit direction
	var process_material : ParticleProcessMaterial = particles.process_material
	process_material.direction = Vector3(-direction.x, -direction.y, 0.0) 
	
	add_child(particles)
	
	# free up particle node after its lifetime is done
	# todo probably a better way to do this
	await particles.finished
	particles.queue_free()

# keyboard input
func _unhandled_key_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("ui_up"):
		apply_knockback_impulse(Vector2.UP)
	
	# only allow up button to be pressed on the floor
	# don't allow any others
	if is_on_floor():
		return
	
	if event.is_action_pressed("ui_down"):
		apply_knockback_impulse(Vector2.DOWN)

		
	if event.is_action_pressed("ui_right"):
		apply_knockback_impulse(Vector2.RIGHT)
		
	if event.is_action_pressed("ui_left"):
		apply_knockback_impulse(Vector2.LEFT)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")

	if is_on_floor():
		if direction:
			velocity.x = direction * HORIZONTAL_SPEED
		else:
			## slow down to zero speed on floor
			velocity.x = move_toward(velocity.x, 0, HORIZONTAL_SPEED)

	#flip sprite
	if velocity.x > 0:
		# Moving right: don't flip
		sprite_2d.flip_h = false
	elif velocity.x < 0:
		# Moving left: flip
		sprite_2d.flip_h = true

	move_and_slide()
