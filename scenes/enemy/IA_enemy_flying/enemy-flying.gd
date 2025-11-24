extends IAEnemy

@export var SPEED: int = 50
@export var CHASE_SPEED: int = 150
@export var ACCELERATION: int = 300
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var panel: Panel = $Panel
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

var direction: Vector2
var right_bounds: Vector2
var left_bounds: Vector2
var is_dead:= false
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

	left_bounds = position + Vector2(-150, 0)
	right_bounds = position + Vector2(150, 0)

	stun_timer = Timer.new()
	stun_timer.one_shot = true
	stun_timer.connect("timeout", Callable(self, "_on_stun_timeout"))
	add_child(stun_timer)



# ======================
#  STUN + KNOCKBACK
# ======================
func _on_pulse_stun(knockback_direction: Vector2, radius: float, duration: float, knockback_force: float) -> void:
	var normalized_direction := knockback_direction.normalized()

	velocity.x = normalized_direction.x * knockback_force
	velocity.y = normalized_direction.y * knockback_force * 0.3
	stunned = true
	stun_timer.start(duration)


func _on_stun_timeout() -> void:
	stunned = false


# ======================
#  PHYSICS
# ======================
func _physics_process(delta: float) -> void:
	if stunned:
		velocity.x = lerp(velocity.x, 0.0, 0.8 * delta)
	else:
		handle_movement(delta)
		change_direction()


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
	# CHASE state has priority - update direction every frame
	if current_state == States.CHASE:
		
		var player: Player = get_tree().get_first_node_in_group("player")
		if player:
			direction = (player.global_position - global_position).normalized()
			animated_sprite_2d.flip_h = direction.x < 0
		return
	
	# WANDER state - check bounds
	if not animated_sprite_2d.flip_h:
		if position.x >= right_bounds.x:
			animated_sprite_2d.flip_h = true
			direction = Vector2(-1, 0)  # Move left
		else:
			direction = Vector2(1, 0)  # Move right
	else:
		if position.x <= left_bounds.x:
			animated_sprite_2d.flip_h = false
			direction = Vector2(1, 0)  # Move right
		else:
			direction = Vector2(-1, 0)  # Move left


# ======================
#  CHASE LOGIC
# ======================
func chase_player() -> void:
	timer.stop()
	current_state = States.CHASE
	panel.visible = true


func stop_chase() -> void:
	current_state = States.WANDER
	panel.visible = false


func _on_timer_timeout() -> void:
	stop_chase()


# ======================
#  PLAYER HIT
# ======================
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		Events.player_died.emit()


func _on_player_range_body_entered(body: Node) -> void:
	if body is Player and !is_dead:
		chase_player()


func _on_player_range_body_exited(body: Node) -> void:
	if body is Player:
		if timer.time_left <= 0:
			timer.start()

func die() -> void:
	if is_dead:
		return
	is_dead = true
	stop_chase()



	# Create a Tween for the shock effect
	var tween := get_tree().create_tween()

	# Jump up quickly
	tween.tween_property(self, "position:y", position.y - 20, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	# Fall back down
	tween.tween_property(self, "position:y", position.y + 5, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	# Small horizontal shake (simulate electricity)
	tween.tween_property(self, "position:x", position.x - 5, 0.05)
	tween.tween_property(self, "position:x", position.x + 5, 0.05)
	tween.tween_property(self, "position:x", position.x, 0.05)



	# Wait for the tween to finish
	await tween.finished


	# Remove enemy
	queue_free()
