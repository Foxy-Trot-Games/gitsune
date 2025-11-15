extends CharacterBody2D

@export var SPEED: int = 50
@export var CHASE_SPEED: int = 150
@export var ACCELERATION: int = 300
@onready var panel: Panel = $Panel
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var ray_cast_2d: RayCast2D = $RayCast2D



var direction: Vector2
var right_bounds: Vector2
var left_bounds: Vector2

enum States {
	WANDER,
	CHASE
}

var current_state : States = States.WANDER

func _ready() -> void:
	direction = Vector2(1, 0)  # Start moving right
	animated_sprite_2d.flip_h = false  # flip_h = true means facing right
	ray_cast_2d.target_position = Vector2(100, 0)  # raycast pointing right
	left_bounds = self.position + Vector2(-100, 0)
	right_bounds = self.position + Vector2(100, 0)
	
	
func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	handle_movement(delta)
	change_direction()
	look_for_player()

func look_for_player() -> void:
	if ray_cast_2d.is_colliding():
		var collider : Node2D = ray_cast_2d.get_collider()
		if collider is Player:
			chase_player()		
			
		elif current_state == States.CHASE:
			stop_chase()
	elif current_state == States.CHASE:
		stop_chase()
		
		

func chase_player() -> void:
	timer.stop()
	current_state = States.CHASE
	panel.visible=true

func stop_chase() -> void:
	if timer.time_left <= 0:
		
		timer.start()
	
func handle_movement(delta: float) -> void:
	if current_state == States.WANDER:
		panel.visible=false
		velocity = velocity.move_toward(direction * SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(direction * CHASE_SPEED, ACCELERATION * delta)
	move_and_slide()

func change_direction() -> void:
	if current_state == States.WANDER:
		if not animated_sprite_2d.flip_h: # moving right (sprite faces right by default)
			if self.position.x >= right_bounds.x:  # reached right bound
				# flip to moving left
				animated_sprite_2d.flip_h = true
				ray_cast_2d.target_position = Vector2(-100, 0)
				direction = Vector2(-1, 0)
			else:
				direction = Vector2(1, 0)
		else: # moving left (sprite is flipped)
			if self.position.x <= left_bounds.x:  # reached left bound
				# flip to moving right
				animated_sprite_2d.flip_h = false
				ray_cast_2d.target_position = Vector2(100, 0)
				direction = Vector2(1, 0)
			else:
				direction = Vector2(-1, 0)
	else: # Chase state. Follow player.
		var player : CharacterBody2D = get_tree().get_first_node_in_group("player")
		if player:
				direction = (player.position - self.position).normalized()
				if direction.x > 0: # moving right
					animated_sprite_2d.flip_h = false
					ray_cast_2d.target_position = Vector2(100, 0)
				else: # moving left
					animated_sprite_2d.flip_h = true
					ray_cast_2d.target_position = Vector2(-100, 0)


func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
func _on_timer_timeout() -> void:
	current_state = States.WANDER


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		Events.player_died.emit()
