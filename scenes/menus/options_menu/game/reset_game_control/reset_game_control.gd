extends HBoxContainer

signal reset_confirmed

@onready var confirm_reset_dialog: ConfirmationDialog = $ConfirmResetDialog
@onready var reset_button: Button = $ResetButton

func _on_ResetButton_pressed() -> void:
	confirm_reset_dialog.popup_centered()
	reset_button.disabled = true

func _on_ConfirmResetDialog_confirmed() -> void:
	reset_confirmed.emit()
	get_tree().paused = false
	SceneLoader.reload_current_scene()

func _on_confirm_reset_dialog_canceled() -> void:
	reset_button.disabled = false
