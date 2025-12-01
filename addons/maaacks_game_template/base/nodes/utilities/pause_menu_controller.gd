class_name PauseMenuController extends Node

## Node for opening a pause menu when detecting a 'ui_cancel' event.

@export var pause_menu_packed : PackedScene
@export var focused_viewport : Viewport

@onready var pause_button : Button :
	get: 
		if !pause_button:
			pause_button = get_tree().get_first_node_in_group("PauseButton")
		return pause_button

func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		open_pause_menu()

func open_pause_menu() -> void:
	if not focused_viewport:
		focused_viewport = get_viewport()
	var _initial_focus_control = focused_viewport.gui_get_focus_owner()
	var current_menu = pause_menu_packed.instantiate()
	
	pause_button.hide()
	
	get_tree().current_scene.call_deferred("add_child", current_menu)
	await current_menu.tree_exited
	
	pause_button.show()
	
	if is_inside_tree() and _initial_focus_control:
		_initial_focus_control.grab_focus()
