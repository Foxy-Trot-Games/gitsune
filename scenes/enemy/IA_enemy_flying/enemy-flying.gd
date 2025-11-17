class_name IAEnemy
extends CharacterBody2D

@export var SPEED: int = 50
@export var CHASE_SPEED: int = 150
@export var ACCELERATION: int = 300

@onready var panel: Panel = $Panel
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

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
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))

	direction = Vector2.RIGHT
	animated_sprite_2d.flip_h = false

	stun_timer = Timer.new()
	stun_timer.one_shot = true
	stun_timer.connect("timeout", Callable(self, "_on_stun_timeout"))
	add_child(stun_timer)
	


# ======================
#  STUN + KNOCKBACK
# ======================
func _on_pulse_stun(knockback_direction: Vector2, radius: float, duration: float, knockback_force: float) -> void:
	var normalized_direction := knockback_direction.normalized()
	velocity.x = normalized_direction.x * knockback_force * 0.15
	velocity.y = normalized_direction.y * knockback_force * 0.15
	stunned = true
	stun_timer.start(duration)


func _on_stun_timeout() -> void:
	stunned = false


# ======================
#  PHYSICS
# ======================
func _physics_process(delta: float) -> void:
	if stunned:
		velocity = velocity.move_toward(Vector2.ZERO, 0.8 * delta)
	else:
		handle_movement(delta)
		change_direction()  # optional for flying wander
	move_and_slide()

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
	if current_state == States.WANDER:
		# Moving right
		if not animated_sprite_2d.flip_h:
			if position.x >= right_bounds.x:
				animated_sprite_2d.flip_h = true
				direction = Vector2.LEFT
			else:
				direction = Vector2.RIGHT

		# Moving left
		else:
			if position.x <= left_bounds.x:
				animated_sprite_2d.flip_h = false
				direction = Vector2.RIGHT
			else:
				direction = Vector2.LEFT

	else:
		var player : Player = get_tree().get_first_node_in_group("player")
		if player:
			direction = (player.position - position).normalized()

			if direction.x > 0:
				animated_sprite_2d.flip_h = false
			else:
				animated_sprite_2d.flip_h = true


# ======================
#  CHASE LOGIC
# ======================



func chase_player() -> void:
	timer.stop()
	current_state = States.CHASE
	panel.visible = true
	# Update direction toward player in _physics_process
	var player: Player = get_tree().get_first_node_in_group("player")
	if player:
		direction = (player.position - position).normalized()
		if direction.x > 0:
			animated_sprite_2d.flip_h = false
		else:
			animated_sprite_2d.flip_h = true



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


func _on_player_range_body_entered(body: Node) -> void:
	if body is Player:
		chase_player()
		# Stop the timer if it was running
		if timer.is_stopped() == false:
			timer.stop()

func _on_player_range_body_exited(body: Node) -> void:
	if body is Player:
		# Start the timer to delay stop chase
		timer.start()



func _on_timer_timeout() -> void:
	stop_chase()
