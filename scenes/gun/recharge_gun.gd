extends Node2D

@onready var player: Player = Globals.get_player()
@onready var recharge_timer: Timer = $RechargeTimer

func _ready() -> void:
	Events.upgrade_picked_up.connect(_update_recharge_time)
	
	_update_recharge_time(player.state)
		
func _update_recharge_time(state: PlayerState) -> void:
	if _can_recharge_instantly():
		# pause recharege timer since it's not needed anymore
		recharge_timer.paused = true
	else:
		recharge_timer.wait_time = state.gun_recharge_time

var _queued_ammo_charge := false

func _physics_process(delta: float) -> void:
	if player.is_on_floor():
		if _can_recharge_instantly():
			Events.ammo_picked_up.emit()
		elif _queued_ammo_charge:
			Events.ammo_picked_up.emit(1)
			# reset timer so it can't immediately fire right after filling up ammo
			recharge_timer.start()
			Events.gun_charging.emit()
			_queued_ammo_charge = false

func _on_recharge_timer_timeout() -> void:
	if player.is_on_floor():
		Events.ammo_picked_up.emit(1)
		Events.gun_charging.emit()
		_queued_ammo_charge = false
	else:
		# queue up a ammo charge if player is in the air so they immediately get ammo on the ground
		_queued_ammo_charge = true

func _can_recharge_instantly() -> float:
	# due to floating point comparision need to use this method
	return is_zero_approx(player.state.gun_recharge_time)
