@tool
# Using a control node is a quick and dirty way to quickly resize/rotate the zone with handlebars in the editor
extends TextureRect

@export_range(-4096, 4096, 1, "suffix:px/s²") var gravity_value : float = 980.0
@export var slows_down_player := false
@export var recharges_gun := false
@export var allow_movement := false

@onready var area_2d: Area2D = %Area2D
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var gpu_particles_2d: GPUParticles2D = %GravityParticles
@onready var visible_on_screen_enabler_2d: VisibleOnScreenEnabler2D = %VisibleOnScreenEnabler2D

var _debug_label : Label

func _ready() -> void:
	area_2d.gravity = gravity_value

func _physics_process(_delta: float) -> void:
	# if we are in the editor we want to redraw every frame so it updates correctly when editing
	if Engine.is_editor_hint():
		queue_redraw()
	
	if slows_down_player:
		# find the player and slow them down
		# todo this probably isn't very performant since it has to check if the player is inside each frame, refactor later
		for body in area_2d.get_overlapping_bodies():
			if body is Player:
				var player : Player = body
				player.velocity = player.velocity.lerp(Vector2.ZERO, .025)

func _draw() -> void:
	# lock scale so it can't be changed
	scale = Vector2.ONE
	
	var center := size / 2
	
	# set element positions when the node is resized or position is updated
	area_2d.position = center
	
	var shape : RectangleShape2D = collision_shape_2d.shape
	shape.size = size
	
	# set the visible_on_screen_enabler_2d rect, since it doesn't have size we have to build one to assign to rect
	# it needs to be big enough to account for particles that can move outside the zone
	visible_on_screen_enabler_2d.rect = Rect2(Vector2.ZERO, Vector2(size.x + 120, size.y))
	
	# set particle positions/size
	gpu_particles_2d.position = center
	var process_material : ParticleProcessMaterial = gpu_particles_2d.process_material
	process_material.emission_box_extents = Vector3(center.x, center.y, 1)
	process_material.gravity = Vector3(gravity_value / 10, 0, 0)
	
	# set gravity vector based on node rotation (which is in radians)
	area_2d.gravity_direction = Vector2(cos(rotation), sin(rotation))
	
	# update gravity zone color based on export params
	if slows_down_player:
		(material as ShaderMaterial).set_shader_parameter("wave_color", Color("3E7A68"))
	elif allow_movement:
		(material as ShaderMaterial).set_shader_parameter("wave_color", Color("53686e"))
	elif recharges_gun:
		(material as ShaderMaterial).set_shader_parameter("wave_color", Color("ffa181"))
	else:
		(material as ShaderMaterial).set_shader_parameter("wave_color", Color("ffffffff"))
	
	_update_debug_label()

func _update_debug_label() -> void:
	
	if !Engine.is_editor_hint():
		return
	
	if !_debug_label:
		_debug_label = Label.new()
		add_child(_debug_label)
	
	_debug_label.text = "Gravity: %s" % gravity_value
	
	# set pos
	_debug_label.position = (size - _debug_label.size) / 2
	# set the pivot so it can rotate around the center axis
	_debug_label.pivot_offset = _debug_label.size / 2
	
	# unrotate since we might have rotated it when setting
	_debug_label.rotation = -rotation

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		Events.entered_gravity_zone.emit(allow_movement, gravity_value > 980)
		if recharges_gun:
			Events.ammo_picked_up.emit()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		Events.exited_gravity_zone.emit(allow_movement, gravity_value > 980)
