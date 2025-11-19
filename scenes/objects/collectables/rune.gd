extends Collectable

func collected(id: int) -> void:
	PlayerState.add_rune(id)
