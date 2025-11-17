extends Node2D

@onready var player: Player = $"../.."
@onready var recharge_timer: Timer = $RechargeTimer

func _physics_process(delta: float) -> void:
	if player.is_on_floor():
		recharge_timer.paused = false
	else:
		recharge_timer.paused = true

func _on_recharge_timer_timeout() -> void:
	Events.ammo_picked_up.emit(1)
