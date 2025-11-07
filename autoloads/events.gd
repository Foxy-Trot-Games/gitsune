extends Node

signal pulse_knockback_signal(direction: Vector2)
signal player_movement_input_signal
signal current_gun_ammo_signal(ammo_count: int)
signal gun_equipped_signal(MAX_AMMO: int) ## TODO will need to send out either rresource or ref of Gun 
signal player_died

func player_movement_input(direction:Vector2) -> void:
	emit_signal("player_movement_input_signal", direction)
	
func pulse_knockback(direction:Vector2) -> void:
	emit_signal("pulse_knockback_signal", direction)

func current_gun_ammo(ammo_count: int) -> void:
	var new_ammo_count: int = ammo_count + Globals.active_gun_ammo_count

	if new_ammo_count > Globals.ACTIVE_GUN_MAX_AMMO:
		var clamped_ammo_count: int = Globals.ACTIVE_GUN_MAX_AMMO - Globals.active_gun_ammo_count
		
		emit_signal("current_gun_ammo_signal", clamped_ammo_count)
		print(Globals.ACTIVE_GUN_MAX_AMMO)
		return

	emit_signal("current_gun_ammo_signal", ammo_count)


func gun_equipped(MAX_AMMO: int) -> void:
	emit_signal("gun_equipped_signal", MAX_AMMO)
	print(self, MAX_AMMO)
	
