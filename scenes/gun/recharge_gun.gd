extends Node2D

@onready var player: Player = $".."

func _physics_process(delta: float) -> void:
	if player.is_on_floor():
		Events.current_gun_ammo(Globals.ACTIVE_GUN_MAX_AMMO)
