# Spawner2D.gd
extends Node2D

var enemy_scenes: Array[PackedScene]       # <--- multiple enemy types     
@export var spawn_interval: float = 1.0


var timer := 0.0
var active_enemies := 0

func _ready() -> void:
	enemy_scenes = [
		load("res://scenes/enemy/IA_enemy_flying/enemy-flying.tscn"),
		load("res://scenes/enemy/IA_enemy/enemy.tscn")
	]
	randomize()

func _process(delta) -> void:
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
