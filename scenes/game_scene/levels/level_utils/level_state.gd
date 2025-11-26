class_name LevelState
extends Resource

enum ExitType {
	OPEN,
	UNLOCKED
}

@export var collectable_ids : Dictionary[int, bool] = {}
@export var exit := ExitType.OPEN

func unlock_exit() -> void:
	exit = ExitType.UNLOCKED

func exit_unlocked() -> bool:
	return exit == ExitType.UNLOCKED
