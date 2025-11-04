## Usage:
## var throttle: Throttle.new(1.0) 
## throttle.call_throttled()
class_name Throttle extends RefCounted

var _last_call_time := -INF
var _cooldown := 1.0

func _init(cooldown: float = 1.0) -> void:
	_cooldown = cooldown
	
func _should_execute() -> bool:
	var current_time := Time.get_ticks_msec() / 1000.0
	if current_time - _last_call_time >= _cooldown:
		_last_call_time = current_time
		return true
	return false

func call_throttled(callback: Callable) -> Variant:
	if _should_execute():
		return await callback.call() # await is needed if callable has await too
	return null

func print_warning(message: String) -> void:
	if _should_execute():
		push_warning(message)
