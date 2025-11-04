@tool
extends OverlaidMenu

signal restart_pressed
signal main_menu_pressed

@onready var exit_button: Button = %ExitButton
@onready var confirm_main_menu: ConfirmationDialog = $ConfirmMainMenu
@onready var confirm_exit: ConfirmationDialog = $ConfirmExit

func _ready() -> void:
	if OS.has_feature("web"):
		exit_button.hide()

func _on_exit_button_pressed() -> void:
	confirm_main_menu.popup_centered()

func _on_main_menu_button_pressed() -> void:
	confirm_exit.popup_centered()

func _on_confirm_main_menu_confirmed() -> void:
	main_menu_pressed.emit()
	close()

func _on_confirm_exit_confirmed() -> void:
	get_tree().quit()

func _on_close_button_pressed() -> void:
	restart_pressed.emit()
	close()
