@tool
extends Node2D

@onready var area_2d: Area2D = %Area2D
@onready var _player: Node2D = Globals.get_player()

var wave_speed : float = 1

func _physics_process(delta: float) -> void:
	
	if Engine.is_editor_hint():
		return
	
	var new_scale := area_2d.scale.x + (wave_speed * delta)
	
	area_2d.scale = new_scale * Vector2.ONE
	
	var wrapped := wrapf(new_scale, 0.185, 8) * Vector2.ONE
	
	# wrap occured
	if wrapped != area_2d.scale:
		area_2d.scale = wrapped
		reset_physics_interpolation()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player && (_player as Player).state.reactor_wave_recharges:
		Events.ammo_picked_up.emit()
