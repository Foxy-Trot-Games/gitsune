class_name Player
extends CharacterBody2D

@onready var player_sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var gun: Gun = $Gun

@export var speed: int = 200
@export var jump_force: int = 200

var _move_direction := Vector2.ZERO
var _pending_knockback := Vector2.ZERO
var _gun: Node2D
var PLAYER_AIR_RESISTENCE := 0.1 # higher is more resistence up to 1.0
var _animation_state := AnimationStates.IDLING
var _allow_gravity_zone_movement := false
var _dead := false
var state : PlayerState :
	get:
		return GameState.get_player_state()

enum AnimationStates {
	IDLING,
	RUNNING,
	FALLING,
	RISING,
	IN_ZERO_GRAVITY,
	DYING
}

const PLAYER_FOOTSTEP = preload("uid://xgvd557bddwe")
const PLAYER_DAMAGED = preload("uid://bmx8smly4ucvn")
const FAlLING_GUN = preload("uid://xwie54t8khkk")

func _ready() -> void:
	Events.player_movement_input_signal.connect(_on_player_movement_input_signal)
	Events.pulse_knockback_signal.connect(_on_pulse_knockback)
	Events.player_died.connect(_player_died)
	Events.entered_gravity_zone.connect(_set_gravity_zone_var.bind(true))
	Events.exited_gravity_zone.connect(_set_gravity_zone_var.bind(false))
	#I use this to the enemy to detect the player 
	add_to_group("player")

func _on_pulse_knockback(knockback: Vector2) -> void:
	_pending_knockback += knockback

func _on_player_movement_input_signal(direction: Vector2) -> void:
	
	_move_direction = direction
	if !_gun:
		for child in get_children():
			if child.is_in_group("Gun"):
				_gun = child
				break

	# Flip sprite
	if direction.x > 0 and player_sprite.flip_h:
		player_sprite.flip_h = false

	elif direction.x < 0 and !player_sprite.flip_h:
		player_sprite.flip_h = true
		
	if is_on_floor():
		if direction == Vector2.ZERO:
			_update_anim_state(AnimationStates.IDLING)
		else:
			_update_anim_state(AnimationStates.RUNNING)

func _set_gravity_zone_var(allow_movement: bool, entered: bool) -> void:
	_allow_gravity_zone_movement = allow_movement if entered else false

# rising by arbitrary amount
func _is_rising() -> bool:
	return velocity.y < -50

func _is_falling() -> bool:
	return velocity.y > 50

func _physics_process(delta: float) -> void:
	
	# Apply movement
	if _allow_gravity_zone_movement:
		velocity += lerp(Vector2.ZERO, _move_direction * speed / 10, .15)
	elif is_on_floor():
		velocity.x = _move_direction.x * speed
	elif _move_direction != Vector2.ZERO:
		# apply horizontal velocity to the player in the air if they are actively trying to move
		# air resistence is taken into account to slowly move the player
		velocity.x = lerpf(velocity.x, _move_direction.x * speed, PLAYER_AIR_RESISTENCE)
	
	# Apply Jump
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#velocity.y = -jump_force

	# Apply pending knockback from pulse
	if _pending_knockback != Vector2.ZERO:
		# if player is falling we want to apply the full impulse so they 'pogo' back up
		# instead of just reducing the velocity
		if _is_falling():
			velocity.y = 0
		velocity += _pending_knockback
		_pending_knockback = Vector2.ZERO
	
	# apply gravity and any gravity zones
	velocity += get_gravity() * delta
	
	# prevent moving faster than set amount
	var max_player_speed := speed * state.max_player_velocity
	velocity = velocity.clampf(-max_player_speed, max_player_speed)
	
	# if falling
	if _is_falling():
		_update_anim_state(AnimationStates.FALLING)
	# if rising
	elif _is_rising():
		_update_anim_state(AnimationStates.RISING)
	
	move_and_slide()
	
	_check_state()

func _update_anim_state(anim_state: AnimationStates) -> void:
	if !_dead:
		_animation_state = anim_state

func _check_state() -> void:
	match(_animation_state):
		AnimationStates.IDLING:
			_play_animation(&"idle")
		AnimationStates.RISING:
			_play_animation(&"jump")
		AnimationStates.FALLING:
			_play_animation(&"fall")
		AnimationStates.RUNNING:
			_play_animation("run")
			if is_on_floor():
				Audio.play_sfx(PLAYER_FOOTSTEP, self, 200, -40)
		AnimationStates.DYING:
			if is_on_floor() && player_sprite.animation != &"dying":
				_play_animation(&"dying_ground")

func _play_animation(animation: String) -> void:
	# only play the animation once, even the looping ones
	if player_sprite.animation != animation:
		player_sprite.play(animation)

#player dying function after emiting a signal from the enemies
func _player_died() -> void:
	if !_dead:
		_update_anim_state(AnimationStates.DYING)
		_dead = true
		
		Audio.play_sfx(PLAYER_DAMAGED, self)
		
		# spawn falling gun
		var falling_gun : RigidBody2D = FAlLING_GUN.instantiate()
		falling_gun.global_position = global_position
		falling_gun.linear_velocity = velocity
		falling_gun.angular_velocity = TAU if velocity.x > 0 else -TAU
		get_parent().call_deferred("add_child", falling_gun)
		
		if is_on_floor():
			_play_animation(&"dying")
		else:
			_play_animation(&"dying_flying")
		
		await Globals.create_timer(3)
		# Using call_defered() here to avoid potential issues, removing collision bodies during
		# _physics_process can lead to dumb and anoying issues. 
		get_tree().call_deferred("reload_current_scene")  
