class_name Player extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D

const PARTICLES = preload("uid://dmwmphp4y0bya")

const HORIZONTAL_SPEED = 300.0
const KNOCKBACK_IMPULSE: float = 300.0

var particle_throttle := Throttle.new(.2)

func apply_knockback_impulse(direction: Vector2) -> void:
	# This force is applied instantly on impact
	velocity += direction * KNOCKBACK_IMPULSE
	# clamp velocity to 2x impluse so additional impulses don't keep increasing to infinity
	velocity = velocity.clampf(-KNOCKBACK_IMPULSE * 2, KNOCKBACK_IMPULSE * 2)
	# remove any partial velocity so player can drop straight down
	velocity = velocity.snappedf(KNOCKBACK_IMPULSE)
	
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

# keyboard input
func _unhandled_key_input(event: InputEvent) -> void:
	
	# don't do anything if space is held down
	# note that this uses Input rather than the event
	if Input.is_action_pressed("ui_accept"):
		return
	
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

	# Handle space.
	if Input.is_action_pressed("ui_accept") && not is_on_floor():
		velocity = Vector2.ZERO
		particle_throttle.call_throttled(_create_sound_wave.bind(Vector2.ZERO))

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
