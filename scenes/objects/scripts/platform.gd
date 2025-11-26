@tool
extends Path2D

@export var speed := 50
@export var wait_time := .5

@onready var path_follow_2d: PathFollow2D = $PathFollow2D
@onready var sprite_2d: Sprite2D = $AnimatableBody2D/Sprite2D
@onready var line_2d: Line2D = $Line2D

var _running := false
var _reversing := false

func _ready() -> void:
	for child: AnimatedSprite2D in sprite_2d.get_children():
		Globals.set_random_frame(child)

func _physics_process(delta: float) -> void:
	
	if _running:
		_check_wait()
			
		path_follow_2d.progress += speed * delta

func _check_wait() -> void:
	if path_follow_2d.progress_ratio < .01 && _reversing:
		speed = abs(speed)  # go forward
		_running = false
		_reversing = false
	elif path_follow_2d.progress_ratio >= .99 && !_reversing:
		speed = -abs(speed)  # go reverse
		_running = false
		_reversing = true
		
	if !_running:
		await Globals.create_timer(wait_time)
		_running = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		_running = true

func _draw() -> void:
	if curve:
		line_2d.points = curve.get_baked_points()
