class_name PlayerState
extends Resource

@export var rune_number : int = 0
@export var keys : Dictionary[String, bool] = {} 

# Upgrades
@export var gun_max_ammo : int = 1
@export var gun_recharge_time : float = .5
@export var has_air_movement : bool = false
@export var has_super_jump : bool = false
@export var has_hover : bool = false
@export var has_crouch_lock_down : bool = false
@export var gun_can_stun_enemies : bool = false
@export var max_player_velocity := 1.2

# future upgrades?
# allow aim direction
# allow gun recharging
# recharge 1 instantly on floor
# reactor wave recharges gun
# gun recharges in teh air
# pulse amount
# air manuevalbitliy
# walk speed
# impulse amount

static var player_state : PlayerState :
	get():
		return GameState.get_player_state()

static func add_rune() -> void:
	player_state.rune_number += 1
	Globals.get_player().rune_picked_up.emit()

static func add_max_ammo() -> void:
	player_state.gun_max_ammo = clampi(player_state.gun_max_ammo + 1, 0, 10)
	Events.upgrade_picked_up.emit(player_state)
	Events.ammo_picked_up.emit()

static func add_gun_recharge_time() -> void:
	player_state.gun_recharge_time = clampf(player_state.gun_recharge_time - 0.1, 0.0, 0.5)
	Events.upgrade_picked_up.emit(player_state)
	
static func add_air_movement() -> void:
	Events.upgrade_picked_up.emit(player_state)

static func add_super_jump() -> void:
	player_state.has_super_jump = true
	Events.upgrade_picked_up.emit(player_state)
	
static func add_hover() -> void:
	player_state.has_hover = true
	Events.upgrade_picked_up.emit(player_state)

static func add_crouch_lock_down() -> void:
	player_state.has_crouch_lock_down = true
	Events.upgrade_picked_up.emit(player_state)

static func add_stun_enemies() -> void:
	player_state.gun_can_stun_enemies = true
	Events.upgrade_picked_up.emit(player_state)

static func add_max_player_velocity() -> void:
	player_state.max_player_velocity = clampf(player_state.max_player_velocity + 0.1, 1.0, 3.0)
	Events.upgrade_picked_up.emit(player_state)

static func add_key(level_path: String) -> void:
	player_state.keys[level_path] = true

static func has_key(level_path: String) -> bool:
	return player_state.keys.has(level_path)
