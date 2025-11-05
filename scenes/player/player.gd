# Player.gd
class_name Player
extends CharacterBody2D
@onready var player_sprite: Sprite2D = %PlayerSprite

@export var speed: int = 200
@export var jump_force: int = 400

var move_direction = Vector2.ZERO

func _ready() -> void:
	Events.player_movement_input_signal.connect(_on_player_movement_input_signal)

func _on_player_movement_input_signal(direction: Vector2) -> void:
	move_direction = direction
	if direction == Vector2(1.0, 0.0) and player_sprite.flip_h:
		player_sprite.set_flip_h(false)
		
	if direction == Vector2(-1.0, 0.0) and !player_sprite.flip_h:
		player_sprite.set_flip_h(true)


func _physics_process(delta: float) -> void:
	# Horizontal movement
	velocity.x = move_direction.x * speed
	# Apply gravity 
	if move_direction.y == 0.0:
		velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta
	else:
		velocity.y = move_direction.y 
	# Move player
	move_and_slide()
