class_name Ammo extends Node2D


@onready var player_detection: Area2D = %PlayerDetection



@export var ammo_value: int = 3


func _ready() -> void:
	player_detection.body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D)->void:
	
	if body.is_in_group("Player"):
		var increase_ammo_count: int = Globals.active_gun_ammo_count + ammo_value
		Events.current_gun_ammo(increase_ammo_count)
		print(self, "Adding ", increase_ammo_count )
		queue_free()
