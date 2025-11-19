class_name PlayerState
extends Resource

@export var rune_number : int = 0
@export var gun_max_ammo : int = 1
@export var gun_recharge_time : float = 1.0
@export var has_air_movement : bool = false
@export var has_super_jump : bool = false
@export var has_hover : bool = false
@export var has_crouch_lock_down : bool = false
@export var gun_can_stun_enemies : bool = false

static func add_rune(collectable_id: int = 0) -> void:
	var player_state := GameState.get_player_state()
	player_state.rune_number += 1
	_update_level_state(collectable_id)

static func add_max_ammo(collectable_id: int) -> void:
	var player_state := GameState.get_player_state()
	player_state.gun_max_ammo += 1
	Events.ammo_picked_up.emit(-1)
	_update_level_state(collectable_id)

static func _update_level_state(collectable_id: int) -> void:
	if collectable_id:
		Globals.get_level().level_state.collectable_ids[collectable_id] = true
