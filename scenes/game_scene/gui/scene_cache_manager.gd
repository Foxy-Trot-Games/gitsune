extends Node

@onready var particle_scene_lister: SceneLister = %ParticleSceneLister

func _ready() -> void:
	
	_cache_particle_scenes()
	
func _cache_particle_scenes() -> void:
	# instantiate scenes so they are cached on game start
	for file : String in particle_scene_lister.files:
		var scene : Node2D = (load(file) as PackedScene).instantiate()
		scene.process_mode = Node.PROCESS_MODE_DISABLED
		# disable scene
		scene.set_process(false)
		scene.set_physics_process(false)
		scene.hide()
		
		add_child(scene)
