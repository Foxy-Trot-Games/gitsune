# Player.gd
class_name Player
extends CharacterBody2D

@export var speed: int = 200
@export var jump_force: int = 400

var move_direction = Vector2.ZERO

func _ready() -> void:
	Events.player_movement_input_signal.connect(_on_player_movement_input_signal)

func _on_player_movement_input_signal(direction: Vector2) -> void:
	move_direction = direction

func _physics_process(delta: float) -> void:
	# Horizontal movement
	velocity.x = move_direction.x * speed

	# Jumping


	# Apply gravity
	velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta

	# Move player
	move_and_slide()
