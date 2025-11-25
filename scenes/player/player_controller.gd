class_name PlayerController extends Node2D

@onready var player: Player = $".."

func _physics_process(_delta: float) -> void:
	
	if player._dead:
		Events.player_movement_input(Vector2.ZERO)
		return
	
	var input_vect := Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
	
	Events.player_movement_input(input_vect)

func _input(event: InputEvent) -> void:
	# enable mouse if it was hidden
	if event is InputEventMouseButton || event is InputEventMouseMotion:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	# hide mouse if using keyboard
	if event.is_action_pressed(&"pulse_right") || event.is_action_pressed(&"pulse_left") || \
		event.is_action_pressed(&"pulse_up") || event.is_action_pressed(&"pulse_down"):
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _exit_tree() -> void:
	# always show mouse on exit
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
