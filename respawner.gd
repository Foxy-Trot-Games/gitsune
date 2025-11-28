# Spawner2D.gd
extends Node2D

@export var enemy_scenes: Array[PackedScene]       # <--- multiple enemy types
@export var spawn_points: Array[Node2D]            # <--- optional manual points
@export var spawn_interval: float = 3.0


var timer := 0.0
var active_enemies := 0

func _ready():
	enemy_scenes = [
		load("res://scenes/enemy/IA_enemy_flying/enemy-flying.tscn"),
		load("res://scenes/enemy/IA_enemy/enemy.tscn")
	]
	randomize()

func _process(delta):
	timer += delta

	if timer >= spawn_interval :
		_spawn_enemy()
		timer = 0.0

func _spawn_enemy():
	# choose random enemy type
	if enemy_scenes.is_empty():
		return
	var scene := enemy_scenes[randi() % enemy_scenes.size()]
	var enemy = scene.instantiate()

	# --- spawn near spawner ---
	# random offset in pixels
 

	add_child(enemy)
	active_enemies += 1

	# track death
	if enemy.has_signal("died"):
		enemy.connect("died", Callable(self, "_on_enemy_died"))
	else:
		enemy.connect("tree_exited", Callable(self, "_on_enemy_died"))


	# --- add the enemy ---
	add_child(enemy)
	active_enemies += 1

	# track death if your enemy emits "died"
	if enemy.has_signal("died"):
		enemy.connect("died", Callable(self, "_on_enemy_died"))
	else:
		enemy.connect("tree_exited", Callable(self, "_on_enemy_died"))

func _on_enemy_died():
	active_enemies = max(0, active_enemies - 1)
