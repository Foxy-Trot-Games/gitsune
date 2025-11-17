class_name Ammo extends Node2D

@onready var player_detection: Area2D = %PlayerDetection

@export var ammo_value: int = 3

func _ready() -> void:
	player_detection.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D)->void:
	if body is Player:
		Events.ammo_picked_up.emit(ammo_value)
		queue_free()
