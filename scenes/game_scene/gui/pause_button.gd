extends MarginContainer

func _on_button_button_down() -> void:
	var pause_controller : PauseMenuController = get_tree().get_first_node_in_group("PauseMenuController")
	pause_controller.open_pause_menu()
