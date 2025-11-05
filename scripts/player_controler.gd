# PlayerController.gd
class_name PlayerController
extends Node2D
@onready var player: Player = $".."

@onready var player_sprite: Sprite2D = %PlayerSprite


func _process(_delta: float) -> void:
	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
		if player_sprite.is_flipped_h():
			player_sprite.set_flip_h(false)
			
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
		if !player_sprite.is_flipped_h():
			player_sprite.set_flip_h(true)
	Events.player_movement_input(direction.normalized())

	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.velocity.y = -player.jump_force
