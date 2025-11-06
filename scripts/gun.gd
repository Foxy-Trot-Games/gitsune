class_name Gun extends Node2D

@onready var muzzle: Node2D = %Muzzle

var player: Player
var debug_timer := 0.0  # Timer to throttle debug prints

func _process(delta: float) -> void:
	if player == null:
		player = get_parent()

	var mouse_pos: Vector2 = get_global_mouse_position()
	var target_pos: Vector2 = mouse_pos

	if player.player_sprite.flip_h:
		# Mirror horizontally relative to gun position
		target_pos.x = global_position.x - (mouse_pos.x - global_position.x)
		scale.x = -1
	else:
		scale.x = 1

	look_at(target_pos)

	debug_timer -= delta
	if debug_timer <= 0:
		print("Gun global pos:", global_position)
		print("Muzzle global pos:", muzzle.global_position)
		print("Mouse pos:", mouse_pos)
		print("Target pos (look_at):", target_pos)
		print("Gun rotation (rad):", rotation, "Player flipped:", player.player_sprite.flip_h)
		debug_timer = 0.2

	queue_redraw()


func _draw() -> void:
	if not is_instance_valid(muzzle):
		return

	var local_muzzle: Vector2 = muzzle.position
	var local_mouse: Vector2 = to_local(get_global_mouse_position())

	draw_line(local_muzzle, local_mouse, Color(1, 0, 0), 2)

	draw_line(local_muzzle, to_local(get_global_mouse_position()), Color(0, 1, 0), 2)
