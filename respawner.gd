# Spawner2D.gd
class_name Respawner extends Node2D

@export var enemy_scenes: Array[PackedScene] = [
	preload("res://scenes/enemy/IA_enemy_flying/enemy-flying.tscn"),
	preload("res://scenes/enemy/IA_enemy/enemy.tscn")
]
@export var spawn_interval: float = 3.0
@export var max_enemies := 3

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var gravity_particles: GPUParticles2D = $GravityParticles

signal respawner_destroyed

var timer := 0.0
var active_enemies := []
var hp := 4
var _dead := false

func _ready() -> void:
	randomize()

func _physics_process(delta: float) -> void:
	timer += delta
	
	var _total_enemies := active_enemies.filter(is_instance_valid).size()
	
	if timer >= spawn_interval && _total_enemies < 3:
		_spawn_enemy()
		timer = 0.0

func _spawn_enemy() -> void:
	# choose random enemy type
	if enemy_scenes.is_empty():
		return
	var scene := enemy_scenes[randi() % enemy_scenes.size()]
	var enemy := scene.instantiate()
	active_enemies.append(enemy)
	add_child(enemy)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is PulseArea && !_dead:
		hp -= 1
		
		# particles need to be restarted for one_shot to work correctly
		gravity_particles.restart()
		
		if hp <= 0:
			_dead = true
			animation_player.play(&"dead")
			set_physics_process(false)
			respawner_destroyed.emit()
		else:
			animation_player.play(&"hit")
