@tool
extends Level

@onready var beginning_animation_player: AnimationPlayer = %BeginningAnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()

	if Engine.is_editor_hint():
		return

	if level_state.animation_played:
		beginning_animation_player.play(&"skip_animation")
	else:
		beginning_animation_player.play(&"beginning")
		level_state.animation_played = true
