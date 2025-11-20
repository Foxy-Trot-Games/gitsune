extends Node2D

@onready var player: Player = $"../.."
@onready var recharge_timer: Timer = $RechargeTimer

func _ready() -> void:
	Events.upgrade_picked_up.connect(_update_timer)
	
	_update_timer(GameState.get_player_state())
		
func _update_timer(state: PlayerState) -> void:
	if state.gun_recharge_time <= 0:
		recharge_timer.paused = true
	else:
		recharge_timer.wait_time = state.gun_recharge_time
	
func _physics_process(delta: float) -> void:
	if player.state.gun_recharge_time <= 0:
		if player.is_on_floor():
			Events.ammo_picked_up.emit()
	else:
		recharge_timer.paused = !player.is_on_floor()

func _on_recharge_timer_timeout() -> void:
	Events.ammo_picked_up.emit(1)
