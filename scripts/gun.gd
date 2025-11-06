class_name Gun extends Node2D

@onready var muzzle: Node2D = %Muzzle

var player: Player
var debug_timer := 0.0  # Timer to throttle debug prints

func _process(delta: float) -> void:
	if player == null:
		player = get_parent()

	var mouse_pos: Vector2 = get_global_mouse_position()
	var target_pos: Vector2 = mouse_pos

	# move the gun position so it's centered on the players mouth
	if player.player_sprite.flip_h:
		position.x = -abs(position.x)
	else:
		position.x = abs(position.x)
	
	# flip gun axis depending on its rotation so its never rotated upside down
	var angle := Vector2.from_angle(rotation)
	if angle.x > 0:
		scale.y = abs(scale.y)
	else:
		scale.y = -abs(scale.y)
	
	look_at(target_pos)

	#debug_timer -= delta
	#if debug_timer <= 0:
		#print("Gun global pos:", global_position)
		#print("Muzzle global pos:", muzzle.global_position)
		#print("Mouse pos:", mouse_pos)
		#print("Target po s (look_at):", target_pos)
		#print("Gun rotation (rad):", rotation, "Player flipped:", player.player_sprite.flip_h)
		#debug_timer = 0.2

	queue_redraw()


func _draw() -> void:
	if not is_instance_valid(muzzle):
		return

	var local_muzzle: Vector2 = muzzle.position
	
	#draw_line(local_muzzle, to_local(get_global_mouse_position()), Color(1, 0, 0), 2)
	
	draw_line(local_muzzle, get_local_mouse_position(), Color(0, 1, 0), 2, false)
