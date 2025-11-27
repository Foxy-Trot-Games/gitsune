@tool
class_name TutorialMessage extends Label

@export var fade_in_time := 1.0

@onready var player := Globals.get_player()

var _player_in_range := false
var _detection_range_squared := 200.0 ** 2

func _ready() -> void:
	if Engine.is_editor_hint():
		modulate = Color.WHITE
		set_process(false)
	else:
		modulate = Color.TRANSPARENT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_distance := global_position.distance_squared_to(player.global_position) < _detection_range_squared
	
	if player_distance && !_player_in_range:
		_player_in_range = true
		fade_in()
	elif !player_distance && _player_in_range:
		_player_in_range = false
		fade_out()

func fade_in() -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, fade_in_time)
	tween.set_ease(Tween.EASE_IN)

func fade_out() -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, fade_in_time)
	#tween.set_ease(Tween.EASE_IN)
