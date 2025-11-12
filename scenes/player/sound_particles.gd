extends Node2D

@onready var pulse_area: Area2D = $PulseArea
@onready var particles: GPUParticles2D = $"."
var pulse_radius: float = 60.0
var travel_direction: Vector2 = Vector2.RIGHT  # Direction the pulse is traveling
var hit_enemies: Array = []  # Track enemies we've already hit


var speed: float = 800.0  # pixels per second

func _ready() -> void:
	pulse_area.connect("body_entered", Callable(self, "_on_body_entered"))
	particles.emitting = true
	travel_direction = Vector2.RIGHT.rotated(rotation)

func _physics_process(delta: float) -> void:
	# Move pulse forward with raycast to detect fast collisions
	var distance_this_frame = speed * delta
	var from_pos = global_position
	var to_pos = from_pos + travel_direction * distance_this_frame
	
	# Raycast to check for enemies we might pass through
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(from_pos, to_pos)
	query.collide_with_areas = false
	query.collide_with_bodies = true
	# Check all collision layers
	query.collision_mask = 0xFFFFFFFF
	
	var result = space_state.intersect_ray(query)
	
	if result:
		var collider = result.collider
		if collider.is_in_group("enemy") and collider not in hit_enemies:
			_apply_knockback_to_enemy(collider)
	
	# Move pulse forward
	position += travel_direction * distance_this_frame
	
	# Optional: destroy pulse after going too far
	if position.distance_to(get_tree().current_scene.global_position) > 2000:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemy") and body not in hit_enemies:
		_apply_knockback_to_enemy(body)

func _apply_knockback_to_enemy(body: Node) -> void:
	var knockback_force = 600.0
	var stun_duration = 1.2
	if body.has_method("_on_pulse_stun"):
		body._on_pulse_stun(travel_direction, pulse_radius, stun_duration, knockback_force)
		hit_enemies.append(body)
