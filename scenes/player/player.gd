class_name Player
extends CharacterBody2D

@onready var player_sprite: Sprite2D = %PlayerSprite

@export var speed: int = 200
@export var jump_force: int = 400

var _move_direction := Vector2.ZERO
var _pending_knockback := Vector2.ZERO


func _ready() -> void:
	Events.player_movement_input_signal.connect(_on_player_movement_input_signal)
	Events.pulse_knockback_signal.connect(_on_pulse_knockback)

func _on_pulse_knockback(knockback: Vector2) -> void:
	# Instead of directly changing velocity here, you could
	# store it in a variable and apply it in _physics_process
	_pending_knockback += knockback

func _on_player_movement_input_signal(direction: Vector2) -> void:
	_move_direction = direction

	# Flip sprite
	if direction.x > 0 and player_sprite.flip_h:
		player_sprite.flip_h = false
	elif direction.x < 0 and !player_sprite.flip_h:
		player_sprite.flip_h = true


func _physics_process(delta: float) -> void:
	# Normal movement
	velocity.x = _move_direction.x * speed

	# Gravity
	if not is_on_floor():
		velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_force

	# Apply pending knockback from pulse
	velocity += _pending_knockback
	_pending_knockback = Vector2.ZERO

	move_and_slide()

#player dying function after emiting a signal from the enemies
func die() -> void:
	print("Player died") # for debugging
	get_tree().reload_current_scene()
