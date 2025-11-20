extends IAEnemy

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

var current_state: States = States.WANDER
var stunned: bool = false
var stun_timer: Timer


func _ready() -> void:
	add_to_group("enemy")
	direction = Vector2.RIGHT
	animated_sprite_2d.flip_h = false
	ray_cast_2d.target_position = Vector2(100, 0)

	left_bounds = position + Vector2(-100, 0)
	right_bounds = position + Vector2(100, 0)

	stun_timer = Timer.new()
	stun_timer.one_shot = true
	stun_timer.connect("timeout", Callable(self, "_on_stun_timeout"))
	add_child(stun_timer)


# ======================
#  STUN + KNOCKBACK
# ======================
func _on_pulse_stun(knockback_direction: Vector2, radius: float, duration: float, knockback_force: float) -> void:
	var normalized_direction := knockback_direction.normalized()

	velocity.x = normalized_direction.x * knockback_force * 0.2
	velocity.y = normalized_direction.y * knockback_force * 0.5
	stunned = true
	stun_timer.start(duration)


func _on_stun_timeout() -> void:
	stunned = false


# ======================
#  PHYSICS
# ======================
func _physics_process(delta: float) -> void:
	handle_gravity(delta)

	if stunned:
		velocity.x = lerp(velocity.x, 0.0, 0.8 * delta)
	else:
		handle_movement(delta)
		change_direction()
		look_for_player()

	move_and_slide()


func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta


# ======================
#  MOVEMENT LOGIC
# ======================
func handle_movement(delta: float) -> void:
	if stunned:
		return

	if current_state == States.WANDER:
		panel.visible = false
		velocity = velocity.move_toward(direction * SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(direction * CHASE_SPEED, ACCELERATION * delta)


func change_direction() -> void:
	print(current_state)
	if current_state == States.WANDER:
		# Moving right
		if not animated_sprite_2d.flip_h:
			if position.x >= right_bounds.x:
				animated_sprite_2d.flip_h = true
				ray_cast_2d.target_position = Vector2(-100, 0)
				direction = Vector2.LEFT
			else:
				direction = Vector2.RIGHT

		# Moving left
		else:
			if position.x <= left_bounds.x:
				animated_sprite_2d.flip_h = false
				ray_cast_2d.target_position = Vector2(100, 0)
				direction = Vector2.RIGHT
			else:
				direction = Vector2.LEFT

	else:
		var player : Player = get_tree().get_first_node_in_group("player")
		if player:
			direction = (player.position - position).normalized()
			print("player position" , player )
			if direction.x > 0:
				animated_sprite_2d.flip_h = false
				
			else:
				animated_sprite_2d.flip_h = true
				


# ======================
#  CHASE LOGIC
# ======================
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
	panel.visible = true


func stop_chase() -> void:
	if timer.time_left <= 0:
		current_state = States.WANDER
		panel.visible = false
		timer.start()


# ======================
#  PLAYER HIT
# ======================
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		Events.player_died.emit()
