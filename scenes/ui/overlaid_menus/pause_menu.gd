@tool
extends OverlaidMenu

@export var options_packed_scene : PackedScene
## Defines the path to the main menu. Hides the Main Menu button if not set.
## Will attempt to read from AppConfig if left empty.
@export_file("*.tscn") var main_menu_scene_path : String

@onready var exit_button: Button = %ExitButton
@onready var options_button: Button = %OptionsButton
@onready var main_menu_button: Button = %MainMenuButton
@onready var confirm_restart: ConfirmationDialog = %ConfirmRestart
@onready var confirm_main_menu: ConfirmationDialog = %ConfirmMainMenu
@onready var confirm_exit: ConfirmationDialog = %ConfirmExit

var popup_open : ConfirmationDialog
var _ignore_first_cancel : bool = false

func get_main_menu_scene_path() -> String:
	if main_menu_scene_path.is_empty():
		return AppConfig.main_menu_scene_path
	return main_menu_scene_path

func close_popup() -> void:
	if popup_open != null:
		popup_open.hide()
		popup_open = null

func _disable_focus() -> void:
	for child : Button in %MenuButtons.get_children():
		if child is Control:
			child.focus_mode = FOCUS_NONE

func _enable_focus() -> void:
	for child : Button in %MenuButtons.get_children():
		if child is Control:
			child.focus_mode = FOCUS_ALL

func _load_scene(scene_path: String) -> void:
	_scene_tree.paused = false
	SceneLoader.load_scene(scene_path)

func open_options_menu() -> void:
	var options_scene := options_packed_scene.instantiate()
	add_child(options_scene)
	_disable_focus.call_deferred()
	await options_scene.tree_exiting
	_enable_focus.call_deferred()

func _handle_cancel_input() -> void:
	if _ignore_first_cancel:
		_ignore_first_cancel = false
		return
	if popup_open != null:
		close_popup()
	else:
		super._handle_cancel_input()

func _hide_exit_for_web() -> void:
	if OS.has_feature("web"):
		exit_button.hide()

func _hide_options_if_unset() -> void:
	if options_packed_scene == null:
		options_button.hide()

func _hide_main_menu_if_unset() -> void:
	if get_main_menu_scene_path().is_empty():
		main_menu_button.hide()

func _ready() -> void:
	_hide_exit_for_web()
	_hide_options_if_unset()
	_hide_main_menu_if_unset()
	if Input.is_action_pressed("ui_cancel"):
		_ignore_first_cancel = true

var _restart_area := false

func _on_restart_button_pressed(restart_area := false) -> void:
	_restart_area = restart_area
	
	if _restart_area:
		confirm_restart.dialog_text = "Restart from the last door?"
	else:
		confirm_restart.dialog_text = "Restart from last checkpoint?"
	
	confirm_restart.popup_centered()
	popup_open = confirm_restart

func _on_options_button_pressed() -> void:
	open_options_menu()

func _on_main_menu_button_pressed() -> void:
	confirm_main_menu.popup_centered()
	popup_open = confirm_main_menu

func _on_exit_button_pressed() -> void:
	confirm_exit.popup_centered()
	popup_open = confirm_exit

func _on_confirm_restart_confirmed() -> void:
	if _restart_area:
		Level.reset_global_variables()
	
	SceneLoader.reload_current_scene()
	close()

func _on_confirm_main_menu_confirmed() -> void:
	_load_scene(get_main_menu_scene_path())

func _on_confirm_exit_confirmed() -> void:
	get_tree().quit()
