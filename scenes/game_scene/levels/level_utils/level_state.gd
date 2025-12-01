class_name LevelState
extends Resource

enum ExitType {
	OPEN,
	UNLOCKED
}

@export var collectable_ids : Dictionary[int, bool] = {}
@export var exit := ExitType.OPEN
@export var total_level_runes := 0 :
	get:
		if total_level_runes == 0:
			total_level_runes = Globals.get_nodes_in_group("Rune").size()
		return total_level_runes
@export var collected_runes := 0
@export var animation_played := false

func unlock_exit() -> void:
	exit = ExitType.UNLOCKED

func exit_unlocked() -> bool:
	return exit == ExitType.UNLOCKED
