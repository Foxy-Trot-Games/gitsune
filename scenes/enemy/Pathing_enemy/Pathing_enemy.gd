extends Enemy

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var vision: Area2D = $Sprite2D/vision
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var vision_collision: CollisionShape2D = $Sprite2D/vision/vision_Collision
@onready var hitbox: Area2D = $Sprite2D/hitbox

signal player_hit

var seen : bool = false 
var player : Player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("enemies")
	# Random starting frame for animation
	animation_player.seek(randf_range(0,animation_player.current_animation_length))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if seen == true:
		change_direction()


func change_direction() -> void:
	if player.position.x < position.x:
		# Player is left of enemy
		sprite_2d.flip_h = false
	else:
		# Player is right of enemy
		sprite_2d.flip_h = true



func _on_vision_body_entered(body: Node2D) -> void:
	if body is Player:
		seen=true
		player=body



func _on_vision_body_exited(body: Node2D) -> void:
		if body is Player:
			seen=false
			player=null


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Player:
		emit_signal("player_hit", body)
