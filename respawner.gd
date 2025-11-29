# Spawner2D.gd
extends Node2D

@export var enemy_scenes: Array[PackedScene] = [
	preload("res://scenes/enemy/IA_enemy_flying/enemy-flying.tscn"),
	preload("res://scenes/enemy/IA_enemy/enemy.tscn")
]
@export var spawn_interval: float = 3.0

var timer := 0.0
var active_enemies := 0

func _ready() -> void:
	randomize()

func _process(delta: float) -> void:
	timer += delta
	if timer >= spawn_interval :
		_spawn_enemy()
		timer = 0.0

func _spawn_enemy() -> void:
	# choose random enemy type
	if enemy_scenes.is_empty():
		return
	var scene := enemy_scenes[randi() % enemy_scenes.size()]
	var enemy := scene.instantiate()
	add_child(enemy)
