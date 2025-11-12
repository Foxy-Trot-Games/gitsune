class_name Player
extends CharacterBody2D

@onready var player_sprite: AnimatedSprite2D = %AnimatedSprite2D

@export var speed: int = 200
@export var jump_force: int = 400

var _move_direction := Vector2.ZERO
var _pending_knockback := Vector2.ZERO
var _gun: Node2D
var PLAYER_AIR_RESISTENCE := 0.1 # higher is more resistence up to 1.0
var MAX_PLAYER_SPEED := 500
var _player_state := PlayerStates.IDLING

enum PlayerStates {
	JUMPING,
	IDLING,
	RUNNING,
	FALLING,
	PULSING
}

func _ready() -> void:
	Events.player_movement_input_signal.connect(_on_player_movement_input_signal)
	Events.pulse_knockback_signal.connect(_on_pulse_knockback)
	Events.player_died.connect(_player_died)

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
			_update_state(PlayerStates.IDLING)
		else:
			_update_state(PlayerStates.RUNNING)

func _physics_process(delta: float) -> void:
	
	if is_on_floor():
		velocity.x = _move_direction.x * speed
	elif _move_direction != Vector2.ZERO:
		# apply horizontal velocity to the player in the air if they are actively trying to move
		# air resistence is taken into account to slowly move the player
		velocity.x = lerpf(velocity.x, _move_direction.x * speed, PLAYER_AIR_RESISTENCE)

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_force
		_update_state(PlayerStates.JUMPING)

	# Apply pending knockback from pulse
	if _pending_knockback != Vector2.ZERO:
		velocity += _pending_knockback
		_pending_knockback = Vector2.ZERO
		_update_state(PlayerStates.PULSING)
	
	# apply gravity and any gravity zones
	velocity += get_gravity() * delta
	# prevent moving faster than set amount
	velocity = velocity.clampf(-MAX_PLAYER_SPEED, MAX_PLAYER_SPEED)
	
	# if falling by arbitraty amount
	if velocity.y > 50:
		_update_state(PlayerStates.FALLING)
	
	move_and_slide()
	
	_check_state()

func _update_state(state: PlayerStates) -> void:
	_player_state = state

func _check_state() -> void:
	match(_player_state):
		PlayerStates.IDLING:
			_play_animation("idle")
		PlayerStates.JUMPING, PlayerStates.PULSING:
			_play_animation("jump")
		PlayerStates.FALLING:
			_play_animation("fall")
		PlayerStates.RUNNING:
			_play_animation("run")

func _play_animation(animation: String) -> void:
	# only play the animation once, even the looping ones
	if player_sprite.animation != animation:
		player_sprite.play(animation)

#player dying function after emiting a signal from the enemies
func _player_died() -> void:
	print("Player died") # for debugging
	get_tree().call_deferred("reload_current_scene") # Using call_defered() here to avoid potential issues, removing collision bodies during 
												  # _physics_process can lead to dumb and anoying issues. 
