@tool
# Using a control node is a quick and dirty way to quickly resize/rotate the zone with handlebars in the editor
extends TextureRect

@export_range(-4096, 4096, 1, "suffix:px/s²") var gravity_value : float = 980.0
@export var slows_down_player := false

@onready var area_2d: Area2D = %Area2D
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var gpu_particles_2d: GPUParticles2D = %GPUParticles2D
@onready var visible_on_screen_enabler_2d: VisibleOnScreenEnabler2D = %VisibleOnScreenEnabler2D

var _debug_label : Label

func _ready() -> void:
	area_2d.gravity = gravity_value

func _process(_delta: float) -> void:
	# if we are in the editor we want to redraw every frame so it updates correctly when editing
	if Engine.is_editor_hint():
		queue_redraw()
	
	if slows_down_player:
		# find the player and slow them down
		# todo this probably isn't very performant since it has to check if the player is inside each frame, refactor later
		for body in area_2d.get_overlapping_bodies():
			if body is Player:
				var player : Player = body
				player.velocity = player.velocity.lerp(Vector2.ZERO, .015)

func _draw() -> void:
	# lock scale so it can't be changed
	scale = Vector2.ONE
	
	var center := size / 2
	
	# set element positions when the node is resized or position is updated
	area_2d.position = center
	
	var shape : RectangleShape2D = collision_shape_2d.shape
	shape.size = size
	
	# set the visible_on_screen_enabler_2d rect, since it doesn't have size we have to build one to assign to rect
	visible_on_screen_enabler_2d.rect = Rect2(Vector2.ZERO, size)
	
	# set particle positions/size
	gpu_particles_2d.position = center
	var process_material : ParticleProcessMaterial = gpu_particles_2d.process_material
	process_material.emission_box_extents = Vector3(center.x, center.y, 1)
	process_material.gravity = Vector3(gravity_value / 10, 0, 0)
	
	# set gravity vector based on node rotation (which is in radians)
	area_2d.gravity_direction = Vector2(cos(rotation), sin(rotation))
	
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
