@tool
extends Level

@onready var ending_animation_player: AnimationPlayer = %EndingAnimationPlayer

const REACTOR_SWEEP_SHORT = preload("uid://o8hmhmftbt27")
const ENDING_LEVEL = "uid://cjdsdpsohed7q"

var _respawners_left := 0

func _ready() -> void:
	super()
	
	if Engine.is_editor_hint():
		return
	
	for respawner : Respawner in Globals.get_nodes_in_group("Respawner"):
		_respawners_left += 1
		respawner.respawner_destroyed.connect(_respawner_destroyed)

func _respawner_destroyed() -> void:
	
	Audio.play_sfx(REACTOR_SWEEP_SHORT, self, 100, 0)
	
	_respawners_left -= 1
	
	if _respawners_left <= 0:
		# remove pusling glow group
		get_tree().call_group("PulsingGlow", "queue_free")
		ending_animation_player.play(&"ending")
		await ending_animation_player.animation_finished
		# load credits scene
		SceneLoader.load_scene(ENDING_LEVEL)
