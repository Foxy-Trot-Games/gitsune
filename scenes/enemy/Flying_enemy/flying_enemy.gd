extends Enemy

@onready var vision: Area2D = $vision
@onready var animated_sprite_2d: AnimatedSprite2D = $hitbox_area/AnimatedSprite2D
@onready var vision_collision: CollisionShape2D = $vision/vision_collision
@onready var hitbox_area: Area2D = $hitbox_area


var seen : bool = false 
var player : Player
signal player_hit
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("enemies")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if seen == true:
		change_direction()


func change_direction() -> void:
	if player.position.x < position.x:
		# Player is left of enemy
		animated_sprite_2d.flip_h = false
	else:
		# Player is right of enemy
		animated_sprite_2d.flip_h = true

func _on_vision_body_entered(body: Node2D) -> void:
	if body is Player:
		seen=true
		player=body

func _on_vision_body_exited(body: Node2D) -> void:
		if body is Player:
			seen=false
			player=null
# Reload scene when player dies

func _on_hitbox_area_body_entered(body: Node2D) -> void:
		if body is Player: 
			emit_signal("player_hit", body)
