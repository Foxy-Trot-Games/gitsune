@tool
extends OverlaidMenu

signal continue_pressed
signal restart_pressed
signal main_menu_pressed

@onready var confirm_main_menu: ConfirmationDialog = $ConfirmMainMenu

func _on_main_menu_button_pressed() -> void:
	confirm_main_menu.popup_centered()

func _on_confirm_main_menu_confirmed() -> void:
	main_menu_pressed.emit()
	close()

func _on_restart_button_pressed() -> void:
	restart_pressed.emit()
	close()

func _on_close_button_pressed() -> void:
	continue_pressed.emit()
	close()
