extends Node2D

@onready var pulse_area: Area2D = $PulseArea
@onready var particles: GPUParticles2D = $"."
var pulse_radius: float = 60.0
var travel_direction: Vector2 = Vector2.RIGHT  # Direction the pulse is traveling
var hit_enemies: Array = []  # Track enemies we've already hit
var spawn_position: Vector2  # Position where pulse was spawned (player position)

var speed: float = 200.0  # pixels per second

func _ready() -> void:
	particles.emitting = true
	travel_direction = Vector2.RIGHT.rotated(rotation)
	spawn_position = global_position

func _physics_process(delta: float) -> void:
	## Smooth movement
	pulse_area.global_position += travel_direction * speed * delta


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") and body not in hit_enemies:
		_apply_knockback_to_enemy(body)

func _apply_knockback_to_enemy(body: Node2D) -> void:
	var knockback_force := 600.0
	var stun_duration := 1.2
	if body is IAEnemy:
		(body as IAEnemy)._on_pulse_stun(travel_direction, pulse_radius, stun_duration, knockback_force)
		hit_enemies.append(body)
