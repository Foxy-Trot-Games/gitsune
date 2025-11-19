extends Collectable

func collected(id: int) -> void:
	PlayerState.add_max_ammo(id)
