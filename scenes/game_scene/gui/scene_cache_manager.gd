## This manager caches scenes like particles that can cause stutters when first added to the world 
extends Node

@onready var particle_scene_lister: SceneLister = %ParticleSceneLister

func _ready() -> void:
	
	_cache_particle_scenes()
	
func _cache_particle_scenes() -> void:
	# instantiate scenes so they are cached on game start
	for file : String in particle_scene_lister.files:
		var scene : Node2D = (load(file) as PackedScene).instantiate()
		add_child(scene)
		
		# disable scene
		scene.set_process(false)
		scene.set_physics_process(false)
		# hiding doesn't work, we want to draw it to the screen still to cache it
		scene.modulate = Color.TRANSPARENT
		#scene.hide()
		
		# free after adding it to the world, this will cache it internally after adding it
		scene.ready.connect(scene.queue_free)
