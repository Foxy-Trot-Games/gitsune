class_name Collectable extends AnimatedSprite2D

var _id := 0

@export var upgrade_type : Type
@export var tutorial_resource : TutorialResource

enum Type {
	RUNE,
	MAX_AMMO,
	RECHARGE_TIME,
	AIR_MOVEMENT,
	SUPER_JUMP,
	HOVER,
	CROUCH_LOCK_DOWN,
	STUN_ENEMIES,
	MAX_VELOCITY,
}

const TUTORIAL_OVERLAY = preload("uid://m4lsx3aqr7pp")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# generate a unique hash based on the level name and the global position
	_id = hash("%s-%s-%s" % [GameState.get_current_level_path(), global_position.x, global_position.y])
	
	var level_collectables : Dictionary[int, bool] = Globals.get_level().level_state.collectable_ids
	# delete the collectable if it was collected in the level state
	if level_collectables.has(_id):
		queue_free()
	
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		collected()
		queue_free()

func collected() -> void:
	match upgrade_type:
		Type.RUNE:
			PlayerState.add_rune()
		Type.MAX_AMMO:
			PlayerState.add_max_ammo()
		Type.RECHARGE_TIME:
			PlayerState.add_gun_recharge_time()
		Type.AIR_MOVEMENT:
			PlayerState.add_air_movement()
		Type.SUPER_JUMP:
			PlayerState.add_super_jump()
		Type.HOVER:
			PlayerState.add_hover()
		Type.CROUCH_LOCK_DOWN:
			PlayerState.add_crouch_lock_down()
		Type.STUN_ENEMIES:
			PlayerState.add_stun_enemies()
		Type.MAX_VELOCITY:
			PlayerState.add_max_player_velocity()
		
	_update_level_state()
	show_tutorial()

func _update_level_state() -> void:
	Globals.get_level().level_state.collectable_ids[_id] = true

func show_tutorial() -> void:
	if tutorial_resource:
		var tutorial_menu : TutorialOverlay = TUTORIAL_OVERLAY.instantiate()
		if tutorial_menu == null:
			push_warning("tutorial failed to open %s" % tutorial_resource)
			return
		
		tutorial_menu.tutorial_resource = tutorial_resource
			
		get_tree().current_scene.call_deferred("add_child", tutorial_menu)
		await tutorial_menu.tree_exited
		var _initial_focus_control : Control = get_viewport().gui_get_focus_owner()
		if is_inside_tree() and _initial_focus_control:
			_initial_focus_control.grab_focus()
