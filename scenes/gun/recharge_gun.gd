extends Node2D

@onready var player: Player = $"../.."

func _physics_process(delta: float) -> void:
	if player.is_on_floor():
		Events.ammo_picked_up.emit()

func _on_recharge_timer_timeout() -> void:
	#if player.is_on_floor():
		#Events.ammo_picked_up.emit(1)
	pass
